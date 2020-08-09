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
    //数据对象
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
  gSysLoger.AddLog(TScanTimingTask, '定时任务扫描', nMsg);
end;

constructor TScanTimingTask.Create(nSuspended:Boolean);
begin
  inherited Create(nSuspended);
  FreeOnTerminate := True;
end;

destructor TScanTimingTask.Destroy;
begin
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
    nInit: Int64;
    nTemWK: PDBWorker;
begin
  try
    WriteLog('定时任务扫描线程已启动');
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
          //无新消息

          WriteLog('查询到 '+ IntToStr(RecordCount) + ' 条纸卡品种需更新价格,开始批量调价...');
          nInit := GetTickCount;

          First;

          while not Eof do
          begin
            FDBConn.FConn.BeginTrans;

            try
              nID      := FieldByName('R_ID').AsString;
              nZK      := FieldByName('D_ZID').AsString;
              nMName   := FieldByName('D_StockName').AsString;
              nPrice   := FieldByName('D_Price').AsString;
              nYunFei  := FieldByName('D_YunFei').AsString;
              nNewPrice:= FieldByName('D_NextPrice').AsString;
              nNewYunFei:= FieldByName('D_NextYunFei').AsString;
              nMan     := FieldByName('D_TJMan').AsString;
              //******************************************************************

              nStr:= 'UPDate %s Set D_PPrice=D_Price Where R_ID=%s';
              nStr:= Format(nStr, [sTable_ZhiKaDtl, nID]);
              gDBConnManager.WorkerExec(FDBConnOPer, nStr);

              nStr:= 'UPDate %s Set D_Price=D_NextPrice, D_YunFei=D_NextYunFei,D_NewPriceExeced=''Y''  Where R_ID=%s';
              nStr:= Format(nStr, [sTable_ZhiKaDtl, nID]);
              gDBConnManager.WorkerExec(FDBConnOPer, nStr);
              //******************************************************************

              nLog := '定时调价 %s 品种[ %s ]、销售单价调整[ %s -> %s ] 运费单价调整[ %s -> %s ]';
              nLog := Format(nLog, [nZK,nMName,nPrice,nNewPrice,nYunFei,nNewYunFei ]);

              nStr := 'Insert Into $T(L_Date,L_Man,L_Group,L_ItemID,L_KeyID,L_Event) ' +
                      'Values($D,''$M'',''$G'',''$I'',''$K'',''$E'')';
              nStr := MacroValue(nStr, [MI('$T', sTable_SysLog), MI('$D', 'GetDate()'),MI('$G', sFlag_ZhiKaItem),
                                        MI('$M', nMan),MI('$I', nZK),MI('$E', nLog), MI('$K', '')]);
              gDBConnManager.WorkerExec(FDBConnOPer, nStr);

              FDBConn.FConn.CommitTrans;
            except
              if FDBConn.FConn.InTransaction then
                FDBConn.FConn.RollbackTrans;
            end ;
            WriteLog('第 '+IntToStr(RecNo)+' 条数据处理完成！纸卡:'+nZK);

            Next;
          end;
        end;
        WriteLog('处理完成耗时: ' + IntToStr(GetTickCount - nInit) + 'ms');
      finally
        Sleep(1000);
      end;
    except
      on E:Exception do
      begin
        WriteLog('定时调价线程扫描发生错误：' + E.Message);
      end;
    end;
  finally
    ReleaseConn;
  end;
end;



end.
 