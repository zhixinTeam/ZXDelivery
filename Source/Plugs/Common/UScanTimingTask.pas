unit UScanTimingTask;

interface

uses
  Windows, Classes, SysUtils, DateUtils, UBusinessConst, UMgrDBConn,
  UBusinessWorker, UWaitItem, ULibFun, USysDB, UMITConst, USysLoger,
  UBusinessPacker, NativeXml, UMgrParam ;


type
  TScanTimingTask = class(TThread)
  private
    FDBConn, FDBConnOPer: PDBWorker;
    //���ݶ���
    FListA,FListB,FListC: TStrings;
    //list
  protected
    procedure GetConn;
    procedure ReleaseConn;
    procedure Execute; override;
  public
    constructor Create(nSuspended:Boolean);
    destructor  Destroy; override;
  end;

var
  gScanTimingTask: TScanTimingTask = nil;


implementation


procedure WriteLog(const nMsg: string);
begin
  gSysLoger.AddLog(TScanTimingTask, '��ʱ����ɨ��', nMsg);
end;

constructor TScanTimingTask.Create(nSuspended:Boolean);
begin
  inherited Create(nSuspended);
  FreeOnTerminate := True;
  //********
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
end;

destructor TScanTimingTask.Destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

procedure TScanTimingTask.GetConn;
var nErr : Integer;
begin
  Sleep(3000);

  FDBConn := nil;  FDBConnOPer:= nil;
  FDBConn := gDBConnManager.GetConnection(gDBConnManager.DefaultConnection, nErr);
  FDBConnOPer := gDBConnManager.GetConnection(gDBConnManager.DefaultConnection, nErr);
end;

procedure TScanTimingTask.ReleaseConn;
var nErr : Integer;
begin
  gDBConnManager.ReleaseConnection(FDBConn);
  gDBConnManager.ReleaseConnection(FDBConnOPer);

  FDBConn := nil;  FDBConnOPer:= nil;
end;

procedure TScanTimingTask.Execute;
var nErr : Integer;
    nStr, nLog, nID, nMan, nZK, nMName, nPrice,
    nYunFei, nNewPrice, nNewYunFei: string;
    nInit  : Int64;
    nIdx   : Integer;
    nTemWK : PDBWorker;
begin
  try
    WriteLog('��ʱ����ɨ���߳�������');
    while not Terminated do
    try
      if Terminated then Exit;
      //--------------------------------------------------------------------------

      with gParamManager.ActiveParam^ do
      try
        if (FDBConn=nil)or(FDBConnOPer=nil) then
        begin
          GetConn;
          Continue;
        end;

        //************************
        nStr:= 'Select * From %s Where D_NewPriceExeced=''N'' And D_NewPriceExecuteTime<=GETDATE()';
        nStr:= Format(nStr,[sTable_ZhiKaDtl]);
        with gDBConnManager.WorkerQuery(FDBConn, nStr) do
        begin
          if RecordCount < 1 then
            Continue;
          //������Ϣ

          WriteLog('��ѯ�� '+ IntToStr(RecordCount) + ' ��ֽ��Ʒ������¼۸�,��ʼ��������...');
          nInit := GetTickCount;

          First;
          FListA.Clear;
          while not Eof do
          begin

              nID      := FieldByName('R_ID').AsString;
              nZK      := FieldByName('D_ZID').AsString;
              nMName   := FieldByName('D_StockName').AsString;
              nPrice   := FieldByName('D_Price').AsString;
              nYunFei  := FieldByName('D_YunFei').AsString;
              nNewPrice:= FieldByName('D_NextPrice').AsString;
              nNewYunFei:= FieldByName('D_NextYunFei').AsString;
              nMan     := FieldByName('D_TJMan').AsString;
              //******************************************************************

              nStr:= 'UPDate %s Set D_PPrice=D_Price Where D_TPrice<>''N'' And R_ID=%s';
              nStr:= Format(nStr, [sTable_ZhiKaDtl, nID]);
              FListA.Add(nStr);

              nStr:= 'UPDate %s Set D_Price=D_NextPrice, D_YunFei=D_NextYunFei,D_NewPriceExeced=''Y''  Where D_TPrice<>''N'' And R_ID=%s';
              nStr:= Format(nStr, [sTable_ZhiKaDtl, nID]);
              FListA.Add(nStr);
              //******************************************************************

              nLog := '��ʱ���� %s Ʒ��[ %s ]�����۵��۵���[ %s -> %s ] �˷ѵ��۵���[ %s -> %s ]';
              nLog := Format(nLog, [nZK,nMName,nPrice,nNewPrice,nYunFei,nNewYunFei ]);

              nStr := 'Insert Into $T(L_Date,L_Man,L_Group,L_ItemID,L_KeyID,L_Event) ' +
                      'Values($D,''$M'',''$G'',''$I'',''$K'',''$E'')';
              nStr := MacroValue(nStr, [MI('$T', sTable_SysLog), MI('$D', 'GetDate()'),MI('$G', sFlag_ZhiKaItem),
                                        MI('$M', nMan),MI('$I', nZK),MI('$E', nLog), MI('$K', '')]);
              FListA.Add(nStr);

            Next;
          end;
        end;

        FDBConn.FConn.BeginTrans;
        try
          for nIdx:=0 to FListA.Count - 1 do
          begin
            gDBConnManager.WorkerExec(FDBConnOPer, FListA[nIdx]);
            WriteLog('�� '+IntToStr(nIdx)+' �����ݴ�����ɣ�ֽ��:'+nZK);
          end;

          FDBConn.FConn.CommitTrans;
          WriteLog('������ɺ�ʱ: ' + IntToStr(GetTickCount - nInit) + 'ms');
        except
          if FDBConn.FConn.InTransaction then
            FDBConn.FConn.RollbackTrans;
        end ;
      finally
        Sleep(1000);
      end;
    except
      on E:Exception do
      begin
        WriteLog('��ʱ�����߳�ɨ�跢������' + E.Message);
      end;
    end;
  finally
    ReleaseConn;
  end;
end;



end.
 