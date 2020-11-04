{*******************************************************************************
  ����: dmzn@163.com 2016-12-30
  ����: ģ��ҵ�����
*******************************************************************************}
unit UWorkerBusinessBill;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  {$IFDEF MicroMsg}UMgrRemoteWXMsg,{$ENDIF}
  {$IFDEF HardMon} UMgrRemotePrint, {$ENDIF}
  UWorkerBusiness, UBusinessConst, UMgrDBConn, ULibFun, UFormCtrl, UBase64,
  USysLoger, USysDB, UMITConst;

type
  TStockMatchItem = record
    FStock: string;         //Ʒ��
    FGroup: string;         //����
    FRecord: string;        //��¼
  end;

  TBillLadingLine = record
    FBill: string;          //������
    FLine: string;          //װ����
    FName: string;          //������
    FPerW: Integer;         //����
    FTotal: Integer;        //�ܴ���
    FNormal: Integer;       //����
    FBuCha: Integer;        //����
    FHKBills: string;       //�Ͽ���
  end;

  TWorkerBusinessBills = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
    //io
    FSanMultiBill: Boolean;
    //ɢװ�൥
    FStockItems: array of TStockMatchItem;
    FMatchItems: array of TStockMatchItem;
    //����ƥ��
    FBillLines: array of TBillLadingLine;
    //װ���� 
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetStockGroup(const nStock: string): string;
    function GetMatchRecord(const nStock: string): string;
    //���Ϸ���
    function AllowedSanMultiBill: Boolean;
    function GetStockKuWei(const nStockNo: string): string;
    //��ȡ���Ͽ�λ
    function GetCusType(const nCusID: string): string;
    //��ȡ�ͻ�����
    function VerifyBeforSave(var nData: string): Boolean;
    function SaveBills(var nData: string): Boolean;
    //���潻����
    function DeleteBill(var nData: string): Boolean;
    //ɾ��������
    function ChangeBillTruck(var nData: string): Boolean;
    //�޸ĳ��ƺ�
    function BillSaleAdjust(var nData: string): Boolean;
    //���۵���
    function SaveBillCard(var nData: string): Boolean;
    function SaveBillLSCard(var nData: string): Boolean;
    //�󶨴ſ�
    function LogoffCard(var nData: string): Boolean;
    //ע���ſ�
    function MakeSanPreHK(var nData: string): Boolean;
    //ִ��ɢװԤ�Ͽ�
    function GetPostBillItems(var nData: string): Boolean;
    //��ȡ��λ������
    function SavePostBillItems(var nData: string): Boolean;
    //�����λ������
    function ZhiKaPriceChk(var nData: string): Boolean;
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function VerifyTruckNO(nTruck: string; var nData: string): Boolean;
    //��֤�����Ƿ���Ч
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation

class function TWorkerBusinessBills.FunctionName: string;
begin
  Result := sBus_BusinessSaleBill;
end;

constructor TWorkerBusinessBills.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessBills.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessBills.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessBills.GetInOutData(var nIn, nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
class function TWorkerBusinessBills.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nPacker.InitData(@nIn, True, False);
    //init
    
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(FunctionName);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TWorkerBusinessBills.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;

  case FIn.FCommand of
   cBC_SaveBills           : Result := SaveBills(nData);
   cBC_DeleteBill          : Result := DeleteBill(nData);
   cBC_ModifyBillTruck     : Result := ChangeBillTruck(nData);
   cBC_SaleAdjust          : Result := BillSaleAdjust(nData);
   cBC_SaveBillCard        : Result := SaveBillCard(nData);
   cBC_SaveBillLSCard      : Result := SaveBillLSCard(nData);
   cBC_LogoffCard          : Result := LogoffCard(nData);
   cBC_GetPostBills        : Result := GetPostBillItems(nData);
   cBC_SavePostBills       : Result := SavePostBillItems(nData);
   cBC_MakeSanPreHK        : Result := MakeSanPreHK(nData);

   cBC_GetLadePlace        : Result := GetLadePlace(nData);
   cBC_ZhiKaPriceChk       : Result := ZhiKaPriceChk(nData);

  else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Invalid Command).';
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2014/7/30
//Parm: Ʒ�ֱ��
//Desc: ����nStock��Ӧ�����Ϸ���
function TWorkerBusinessBills.GetStockGroup(const nStock: string): string;
var nIdx: Integer;
begin
  Result := '';
  //init

  for nIdx:=Low(FStockItems) to High(FStockItems) do
  if FStockItems[nIdx].FStock = nStock then
  begin
    Result := FStockItems[nIdx].FGroup;
    Exit;
  end;
end;

//Date: 2014/7/30
//Parm: Ʒ�ֱ��
//Desc: ����������������nStockͬƷ��,��ͬ��ļ�¼
function TWorkerBusinessBills.GetMatchRecord(const nStock: string): string;
var nStr: string;
    nIdx: Integer;
begin
  Result := '';
  //init

  for nIdx:=Low(FMatchItems) to High(FMatchItems) do
  if FMatchItems[nIdx].FStock = nStock then
  begin
    Result := FMatchItems[nIdx].FRecord;
    Exit;
  end;

  nStr := GetStockGroup(nStock);
  if nStr = '' then Exit;  

  for nIdx:=Low(FMatchItems) to High(FMatchItems) do
  if FMatchItems[nIdx].FGroup = nStr then
  begin
    Result := FMatchItems[nIdx].FRecord;
    Exit;
  end;
end;

//Date: 2014-09-16
//Parm: ���ƺ�;
//Desc: ��֤nTruck�Ƿ���Ч
class function TWorkerBusinessBills.VerifyTruckNO(nTruck: string;
  var nData: string): Boolean;
var nIdx: Integer;
    nWStr: WideString;
begin
  Result := False;
  nIdx := Length(nTruck);
  if (nIdx < 3) or (nIdx > 10) then
  begin
    nData := '��Ч�ĳ��ƺų���Ϊ3-10.';
    Exit;
  end;

  nWStr := LowerCase(nTruck);
  //lower
  
  for nIdx:=1 to Length(nWStr) do
  begin
    case Ord(nWStr[nIdx]) of
     Ord('-'): Continue;
     Ord('0')..Ord('9'): Continue;
     Ord('a')..Ord('z'): Continue;
    end;

    if nIdx > 1 then
    begin
      nData := Format('���ƺ�[ %s ]��Ч.', [nTruck]);
      Exit;
    end;
  end;

  Result := True;
end;

//Date: 2014-10-07
//Desc: ����ɢװ�൥
function TWorkerBusinessBills.AllowedSanMultiBill: Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_SanMultiBill]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString = sFlag_Yes;
  end;
end;

//Date: 2014-09-15
//Desc: ��֤�ܷ񿪵�
function TWorkerBusinessBills.VerifyBeforSave(var nData: string): Boolean;
var nIdx: Integer;
    nStr,nTruck: string;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  try
    {$IFDEF MoreBeltLine}
    if FListA.Values['BeltLine']='' then
    begin
      nData := '��ѡ�������ߺ��ٲ���.';
      nData := Format(nData, [nTruck]);
      Exit;
    end;
    {$ENDIF}

    nTruck := FListA.Values['Truck'];
    if not VerifyTruckNO(nTruck, nData) then Exit;

    nStr := 'Select %s as T_Now,T_LastTime,T_NoVerify,T_Valid From %s ' +
            'Where T_Truck=''%s''';
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_Truck, nTruck]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount > 0 then
        if FieldByName('T_Valid').AsString = sFlag_No then
        begin
          nData := '����[ %s ]������Ա��ֹ����.';
          nData := Format(nData, [nTruck]);
          Exit;
        end;
    end;

    {$IFDEF BusinessOnly}
    nStr := 'Select top 10 * From %s Where O_Truck=''%s'' order by O_Date desc';
    nStr := Format(nStr, [sTable_Order, nTruck]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount > 0 then
      begin
        First;

        while not Eof do
        begin
          if Trim(FieldByName('O_Card').AsString) <> '' then
          begin
            nStr := '����[ %s ]��δ���[ %s ]�ɹ���֮ǰ��ֹ����.';
            nData := Format(nStr, [nTruck, FieldByName('O_ID').AsString]);
            Exit;
          end;
          Next;
        end;
      end;
    end;
    {$ENDIF}

    nStr := 'Select * From %s Where L_OutFact is Null And L_Truck=''%s'' ';
    nStr := Format(nStr, [sTable_Bill, nTruck]);
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount > 0 then
      begin
        First;
        nStr := '����[ %s ]��δ���[ %s ]���۵�֮ǰ��ֹ����.';
        nData := Format(nStr, [nTruck, FieldByName('L_ID').AsString]);
        Exit;
      end;
    end;
    //----------------------------------------------------------------------------
    SetLength(FStockItems, 0);
    SetLength(FMatchItems, 0);
    //init

    {$IFDEF SanPreHK}
    FSanMultiBill := True;
    {$ELSE}
    FSanMultiBill := AllowedSanMultiBill;
    {$ENDIF}//ɢװ�����൥

    nStr := 'Select M_ID,M_Group From %s Where M_Status=''%s'' ';
    nStr := Format(nStr, [sTable_StockMatch, sFlag_Yes]);
    //Ʒ�ַ���ƥ��

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      SetLength(FStockItems, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        FStockItems[nIdx].FStock := Fields[0].AsString;
        FStockItems[nIdx].FGroup := Fields[1].AsString;

        Inc(nIdx);
        Next;
      end;
    end;

    nStr := 'Select R_ID,T_Bill,T_StockNo,T_Type,T_InFact,T_Valid From %s ' +
            'Where T_Truck=''%s'' ';
    nStr := Format(nStr, [sTable_ZTTrucks, nTruck]);
    //���ڶ����г���

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      SetLength(FMatchItems, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        if (FieldByName('T_Type').AsString = sFlag_San) and (not FSanMultiBill) then
        begin
          nStr := '����[ %s ]��δ���[ %s ]������֮ǰ��ֹ����.';
          nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
          Exit;
        end else

        if (FieldByName('T_Type').AsString = sFlag_Dai) and
           (FieldByName('T_InFact').AsString <> '') then
        begin
          nStr := '����[ %s ]��δ���[ %s ]������֮ǰ��ֹ����.';
          nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
          Exit;
        end else

        if FieldByName('T_Valid').AsString = sFlag_No then
        begin
          nStr := '����[ %s ]���ѳ��ӵĽ�����[ %s ],���ȴ���.';
          nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
          Exit;
        end;

        with FMatchItems[nIdx] do
        begin
          FStock := FieldByName('T_StockNo').AsString;
          FGroup := GetStockGroup(FStock);
          FRecord := FieldByName('R_ID').AsString;
        end;

        Inc(nIdx);
        Next;
      end;
    end;

    //���壬����һСʱ��ֹ����
    {$IFDEF Between2BillTime}
    nStr := 'select top 1 L_OutFact from %s where '+
            'l_truck=''%s'' order by L_OutFact desc';
    nStr := Format(nStr,[sTable_Bill,nTruck]);
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if recordcount > 0 then
      begin
        if (Now - FieldByName('L_OutFact').AsDateTime)*24*60 < sFlag_Between2BillsTime then
        begin
          nStr := '����[ %s ]����δ��һ��Сʱ,��ֹ����.';
          nData := Format(nStr, [nTruck]);
          Exit;
        end;
      end;
    end;
    {$ENDIF}

    TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, nTruck, '', @nOut);
    //���泵�ƺ�

    //----------------------------------------------------------------------------
    nStr := 'Select zk.*,ht.C_Area,cus.C_Name,cus.C_PY,sm.S_Name From $ZK zk ' +
            ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
            'Where Z_ID=''$ZID''';
    nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
            MI('$HT', sTable_SaleContract),
            MI('$Cus', sTable_Customer),
            MI('$SM', sTable_Salesman),
            MI('$ZID', FListA.Values['ZhiKa'])]);
    //ֽ����Ϣ

    with gDBConnManager.WorkerQuery(FDBConn, nStr),FListA do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('ֽ��[ %s ]�Ѷ�ʧ.', [Values['ZhiKa']]);
        Exit;
      end;

      if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      begin
        nData := Format('ֽ��[ %s ]�ѱ�����Ա����.', [Values['ZhiKa']]);
        Exit;
      end;

      if FieldByName('Z_InValid').AsString = sFlag_Yes then
      begin
        nData := Format('ֽ��[ %s ]�ѱ�����Ա����.', [Values['ZhiKa']]);
        Exit;
      end;

      nStr := FieldByName('Z_TJStatus').AsString;

      {$IFNDEF NoShowPriceChange}
      if nStr  <> '' then
      begin
        if nStr = sFlag_TJOver then
             nData := 'ֽ��[ %s ]�ѵ���,�����¿���.'
        else nData := 'ֽ��[ %s ]���ڵ���,���Ժ�.';

        nData := Format(nData, [Values['ZhiKa']]);
        Exit;
      end;
      {$ELSE}
      if nStr = sFlag_TJing then
      begin
        nData := 'ֽ��[ %s ]���ڵ���,���Ժ�.';
        nData := Format(nData, [Values['ZhiKa']]);
        Exit;
      end;
      {$ENDIF}

      if FieldByName('Z_ValidDays').AsDateTime <= Date() then
      begin
        nData := Format('ֽ��[ %s ]����[ %s ]����.', [Values['ZhiKa'],
                 Date2Str(FieldByName('Z_ValidDays').AsDateTime)]);
        Exit;
      end;

      {$IFDEF UseFreight}
      Values['XHSpot'] := FieldByName('Z_XHSpot').AsString;
      if FieldByName('Z_Lading').AsString = sflag_songh then
        Values['Freight'] := FieldByName('Z_Freight').AsString;
      {$ENDIF}  //�˷�

      Values['Lading']  := FieldByName('Z_Lading').AsString;
      Values['Project'] := FieldByName('Z_Project').AsString;
      Values['Area']    := FieldByName('Z_Area').AsString;
      Values['CusID']   := FieldByName('Z_Customer').AsString;
      Values['CusName'] := FieldByName('C_Name').AsString;
      Values['CusPY']   := FieldByName('C_PY').AsString;
      Values['SaleID']  := FieldByName('Z_SaleMan').AsString;
      Values['SaleMan'] := FieldByName('S_Name').AsString;
      Values['ZKMoney'] := FieldByName('Z_OnlyMoney').AsString;
    end;

    Result := True;
    //verify done
  finally
    if not Result then WriteLog('����У��δͨ����'+nData);
  end;
end;

//Date: 2014-09-15
//Desc: ���潻����
function TWorkerBusinessBills.SaveBills(var nData: string): Boolean;
var nIdx: Integer;
    nVal,nMoney, nPeerWeight: Double;
    nStr,nSQL,nFixMoney,nParam: string;
    {$IFDEF TruckInNow}
    nStatus, nNextStatus: string;
    {$ENDIF}
    nOut, nTmp: TWorkerBusinessCommand;
    nLine:string;
    nList:TStrings;
begin
  Result := False;
  nList := TStringList.Create;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if not VerifyBeforSave(nData) then Exit;

  if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
            FListA.Values['ZhiKa'], '', @nOut) then
  begin
    nData := nOut.FData;
    Exit;
  end;

  nMoney := StrToFloat(nOut.FData);
  nFixMoney := nOut.FExtParam;
  //zhika money

  FListB.Text := PackerDecodeStr(FListA.Values['Bills']);
  //unpack bill list
  nVal := 0;

  for nIdx:=0 to FListB.Count - 1 do
  begin
    FListC.Text := PackerDecodeStr(FListB[nIdx]);
    //get bill info

    with FListC do
      nVal := nVal + Float2Float(StrToFloat(Values['Price']) *
                     StrToFloat(Values['Value']), cPrecision, True);
    //xxxx
  end;

  if FloatRelation(nVal, nMoney, rtGreater) then
  begin
    nData := 'ֽ��[ %s ]��û���㹻�Ľ��,��������:' + #13#10#13#10 +
             '���ý��: %.2f' + #13#10 +
             '�������: %.2f' + #13#10#13#10 +
             '���С��������ٿ���.';
    nData := Format(nData, [FListA.Values['ZhiKa'], nMoney, nVal]);
    Exit;
  end;

  if GetStockType(FListC.Values['StockNO'])='D' then
  begin
    if (StrToInt(FloatToStr( StrToFloat( FListC.Values['Value'] ) * 100)) Mod 5)<>0 then
    begin
      nData:= Format('%s ����Ϊ��װ����������Ч������Ϊ 0.05 �ı�����.', [ FListA.Values['Truck'] ]);
      Exit;
    end;
  end;

  {$IFDEF SalePlanCheckByMoney}
  if not SalePlanCheckByMoney(nData) then Exit;
  {$ENDIF}

  {$IFDEF SalePlanCheck}
  if not VerifyBeforSaveEx(nData) then Exit;
  {$ENDIF}
  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    for nIdx:=0 to FListB.Count - 1 do
    begin
      if Length(FListA.Values['Card']) > 0 then
      begin      //��������ҵ���Դ���������
        nSQL := 'Select L_ID From %s Where L_Card = ''%s'' And L_OutFact Is NULL';
        nSQL := Format(nSQL, [sTable_Bill, FListA.Values['Card']]);
        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '�޷��ҵ��ſ�[ %s ]��Ӧ����ҵ�񵥺�.';
            nData := Format(nData, [FListA.Values['Card']]);
            Exit;
          end;

          if RecordCount > 1 then
          begin
            nData := '��������ҵ���ֹƴ��.';
            Exit;
          end;

          nOut.FData := Fields[0].AsString;
        end;

      end else   //����ҵ�񣬻�ȡ��������

      begin
        FListC.Values['Group'] :=sFlag_BusGroup;
        FListC.Values['Object'] := sFlag_BillNo;
        //to get serial no

        if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
              FListC.Text, sFlag_Yes, @nOut) then
          raise Exception.Create(nOut.FData);
        //xxxxx
      end;

      FOut.FData := FOut.FData + nOut.FData + ',';
      //combine bill

      FListC.Text := PackerDecodeStr(FListB[nIdx]);
      //get bill info

      {$IFDEF JZZJ}
      // �����о����г��������鵥
      FListC.Values['PrintHY']:= 'Y';
      {$ENDIF}
                                   
      {$IFDEF CustomerType}
        {$IFDEF HYJC}    //��������AB�ͻ������ǲ��������κ�
         if not TWorkerBusinessCommander.CallMe(cBC_GetStockBatcode,
           FListC.Values['StockNO'], FListC.Values['Value'], @nTmp) then
           raise Exception.Create(nTmp.FData);
        {$ELSE}
        FListC.Values['CustomerType'] := GetCusType(FListA.Values['CusID']);
        if FListC.Values['CustomerType'] = '' then
          raise Exception.Create('�ͻ�' + FListA.Values['CusID'] + '����Ϊ��');

        if not TWorkerBusinessCommander.CallMe(cBC_GetStockBatcodeByCusType,
           FListC.Values['StockNO'], FListC.Text, @nTmp) then
           raise Exception.Create(nTmp.FData);
        {$ENDIF}
      {$ELSE}

        {$IFDEF MoreBeltLine}
          begin
            // �������ߡ��೧����ͬ���λ�ȡ
            with nList do
            begin
              Clear;
              Values['StockNO'] := FListC.Values['StockNO'];
              Values['BeltLine']:= FListA.Values['BeltLine'];
            end;
            nParam:= PackerEncodeStr(nList.Text);
            //*******************
            if not TWorkerBusinessCommander.CallMe(cBC_GetStockBatcodeMoreBeltLine,
               nParam, FListC.Values['Value'], @nTmp) then
               raise Exception.Create(nTmp.FData);
          end;
        {$ELSE}
          if not TWorkerBusinessCommander.CallMe(cBC_GetStockBatcode,
             FListC.Values['StockNO'], FListC.Values['Value'], @nTmp) then
             raise Exception.Create(nTmp.FData);
         {$ENDIF}
      {$ENDIF}

      {$IFDEF BatchInHYOfBill}
      if nTmp.FData = '' then
           FListC.Values['HYDan'] := FListC.Values['Seal']
      else FListC.Values['HYDan'] := nTmp.FData;
      {$ELSE}
      if nTmp.FData <> '' then
        FListC.Values['Seal'] := nTmp.FData;
      //auto batcode
      {$ENDIF}

      if PBWDataBase(@nTmp).FErrCode = sFlag_ForceHint then
      begin
        FOut.FBase.FErrCode := sFlag_ForceHint;
        FOut.FBase.FErrDesc := PBWDataBase(@nTmp).FErrDesc;
      end;
      //��ȡ���κ���Ϣ

      FListC.Values['StockKuWei'] := GetStockKuWei(FListC.Values['StockNO']);

      nStr := MakeSQLByStr([SF('L_ID', nOut.FData),
              SF('L_ZhiKa', FListA.Values['ZhiKa']),
              SF('L_Order', FListC.Values['OrderNo']),
              SF('L_Project', FListA.Values['Project']),
              SF('L_Area', FListA.Values['Area']),
              SF('L_CusID', FListA.Values['CusID']),
              SF('L_CusName', FListA.Values['CusName']),
              SF('L_CusPY', FListA.Values['CusPY']),
              SF('L_SaleID', FListA.Values['SaleID']),
              SF('L_SaleMan', FListA.Values['SaleMan']),

              SF('L_Type', FListC.Values['Type']),
              SF('L_StockNo', FListC.Values['StockNO']),
              SF('L_StockName', FListC.Values['StockName']),
              SF('L_Value', FListC.Values['Value'], sfVal),
              SF('L_Price', FListC.Values['Price'], sfVal),

              {$IFDEF MoreBeltLine} //������
              SF('L_BeltLine', FListA.Values['BeltLine']),
              {$ENDIF}

              {$IFDEF PrintGLF}
              SF('L_PrintGLF', FListC.Values['PrintGLF']),
              {$ENDIF} //�Զ���ӡ��·��

              {$IFDEF PrintHYEach}
              SF('L_PrintHY', FListC.Values['PrintHY']),
              {$ENDIF} //�泵��ӡ���鵥

              {$IFDEF StockKuWei}
              SF('L_KuWei', FListC.Values['StockKuWei']),
              {$ENDIF} //�泵��ӡ���鵥

              {$IFDEF CustomerType}
              SF('L_CusType', FListC.Values['CustomerType']),
              {$ENDIF} //�泵��ӡ���鵥

              {$IFDEF UseFreight}
              SF('L_Freight', FListA.Values['Freight'],sfVal),
                {$IFDEF UseXHSpot}
                SF('L_XHSpot', FListA.Values['L_XHSpot']),
                {$ELSE}
                SF('L_XHSpot', FListA.Values['XHSpot']),
                {$ENDIF}
              {$ENDIF} //�����˷�

              {$IFDEF IdentCard}
              SF('L_Ident', FListA.Values['Ident']),
              SF('L_SJName', FListA.Values['SJName']),
              {$ENDIF}

              {$IFDEF UseWebYYOrder}
              SF('L_WebOrderID', FListA.Values['WebOrderID']),
              {$ENDIF}

              SF('L_ZKMoney', nFixMoney),
              SF('L_Truck', FListA.Values['Truck']),
              SF('L_Lading', FListA.Values['Lading']),
              SF('L_IsVIP', FListA.Values['IsVIP']),
              SF('L_Seal', FListC.Values['Seal']),
              SF('L_HYDan', FListC.Values['HYDan']),
              SF('L_Man', FIn.FBase.FFrom.FUser),
              SF('L_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Bill,SF('L_ID', nOut.FData),FListA.Values['Card']='');
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //���ݿ����������߸�����Ϣ

      nStr := MakeSQLByStr([
                SF('P_Truck', FListA.Values['Truck']),
                SF('P_CusID', FListA.Values['CusID']),
                SF('P_CusName', FListA.Values['CusName']),
                SF('P_MID', FListC.Values['StockNO']),
                SF('P_MName', FListC.Values['StockName']),
                SF('P_MType', FListC.Values['Type']),
                SF('P_LimValue', FListC.Values['Value'], sfVal)
                ], sTable_PoundLog, SF('P_Bill', nOut.FData), False);
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //���°���������Ϣ

      nStr := 'UPDate %s Set B_HasUse=B_HasUse+%s Where B_Batcode=''%s''';
          {$IFDEF MoreBeltLine}
           nStr := nStr + ' And B_BeltLine='''+FListA.Values['BeltLine']+'''';
          {$endif}       /// ���¶�Ӧ�����߻�������������
      nStr := Format(nStr, [sTable_StockBatcode, FListC.Values['Value'],
              FListC.Values['HYDan']]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //�������κ�ʹ����

      if FListA.Values['Card'] = '' then
      begin
        nStr := MakeSQLByStr([
                SF('L_Status', sFlag_TruckNone)
                ], sTable_Bill, SF('L_ID', nOut.FData), False);
        gDBConnManager.WorkerExec(FDBConn, nStr);
        //�����ɽ�����״̬Ϊδ֪

        if FListC.Values['IsPlan'] = sFlag_Yes then
        begin
          nStr := MakeSQLByStr([
                  SF('S_InterID', FListC.Values['InterID']),
                  SF('S_EntryID', FListC.Values['EntryID']),
                  SF('S_Truck', FListA.Values['Truck']),
                  SF('S_Date', sField_SQLServer_Now, sfVal)
                  ], sTable_K3_SalePlan, '', True);
          gDBConnManager.WorkerExec(FDBConn, nStr);
        end;
        //������ʹ�õ����ۼƻ�
      end;

      if FListA.Values['BuDan'] = sFlag_Yes then //����
      begin
        {$IFDEF BuDanChangeDate}
        nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckOut),
                SF('L_Date',   FListA.Values['BuDanDate']),
                SF('L_InTime', FListA.Values['BuDanDate']),
                SF('L_PValue', 0, sfVal),
                SF('L_PDate', FListA.Values['BuDanDate']),
                SF('L_PMan', FIn.FBase.FFrom.FUser),
                SF('L_MValue', FListC.Values['Value'], sfVal),
                SF('L_MDate', FListA.Values['BuDanDate']),
                SF('L_MMan', FIn.FBase.FFrom.FUser),
                SF('L_OutFact', FListA.Values['BuDanDate']),
                SF('L_OutMan', FIn.FBase.FFrom.FUser),
                {$IFDEF BDAUDIT}
                SF('L_Audit', sFlag_Yes),
                {$ENDIF}
                SF('L_Card', '')
                ], sTable_Bill, SF('L_ID', nOut.FData), False);
        {$ELSE}
        nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckOut),
                SF('L_InTime', sField_SQLServer_Now, sfVal),
                SF('L_PValue', 0, sfVal),
                SF('L_PDate', sField_SQLServer_Now, sfVal),
                SF('L_PMan', FIn.FBase.FFrom.FUser),
                SF('L_MValue', FListC.Values['Value'], sfVal),
                SF('L_MDate', sField_SQLServer_Now, sfVal),
                SF('L_MMan', FIn.FBase.FFrom.FUser),
                SF('L_OutFact', sField_SQLServer_Now, sfVal),
                SF('L_OutMan', FIn.FBase.FFrom.FUser),
                {$IFDEF BDAUDIT}
                SF('L_Audit', sFlag_Yes),
                {$ENDIF}
                SF('L_Card', '')
                ], sTable_Bill, SF('L_ID', nOut.FData), False);
        {$ENDIF}
        gDBConnManager.WorkerExec(FDBConn, nStr);
      end else
      begin
        if FListC.Values['Type'] = sFlag_San then
        begin
          nStr := '';
          //ɢװ����ϵ�
        end else
        begin
          nStr := FListC.Values['StockNO'];
          nStr := GetMatchRecord(nStr);
          //��Ʒ����װ�������еļ�¼��
        end;

        if nStr <> '' then
        begin
          nSQL := 'Update $TK Set T_Value=T_Value + $Val,' +
                  'T_HKBills=T_HKBills+''$BL.'' Where R_ID=$RD';
          nSQL := MacroValue(nSQL, [MI('$TK', sTable_ZTTrucks),
                  MI('$RD', nStr), MI('$Val', FListC.Values['Value']),
                  MI('$BL', nOut.FData)]);
          gDBConnManager.WorkerExec(FDBConn, nSQL);
        end else
        begin
          {$IFDEF ChkPeerWeight}
          nStr := 'select * from %s where D_Name=''%s'' and D_Value=''%s''';
          nStr := Format(nStr,[sTable_SysDict,sFlag_PeerWeight,FListC.Values['StockNO']]);
          with gDBConnManager.WorkerQuery(FDBConn,nStr) do
          begin
            nPeerWeight := 0;
            if recordCount > 0 then
              nPeerWeight := FieldByName('D_ParamA').AsFloat;
          end;
          {$ENDIF}
          nLine := '';
          {$IFDEF MoreNumZDLine}
          nStr := 'Select D_Name From $Sys where D_Memo=''$ST'' and D_ParamB = ''$SA'' and D_Value <= $SV ';
          nStr := MacroValue(nStr, [MI('$Sys', sTable_SysDict),
                  MI('$ST', FListC.Values['StockName']),
                  MI('$SA', sFlag_ZDLineItem),
                  MI('$SV', FListC.Values['Value'])]);
          with gDBConnManager.WorkerQuery(FDBConn, nStr) do
          begin
            if RecordCount > 0 then
            begin
              nLine := FieldByName('D_Name').AsString;
            end;
          end;
          {$ENDIF}
          nSQL := MakeSQLByStr([
            SF('T_Truck'   , FListA.Values['Truck']),
            SF('T_StockNo' , FListC.Values['StockNO']),
            SF('T_Stock'   , FListC.Values['StockName']),
            SF('T_Type'    , FListC.Values['Type']),
            SF('T_InTime'  , sField_SQLServer_Now, sfVal),
            SF('T_Bill'    , nOut.FData),
            {$IFDEF MoreNumZDLine}
            SF('T_Line',     nLine),
            {$ENDIF}
            SF('T_Valid'   , sFlag_Yes),
            SF('T_Value'   , FListC.Values['Value'], sfVal),
            SF('T_VIP'     , FListA.Values['IsVIP']),
            {$IFDEF ChkPeerWeight}
            SF('T_PeerWeight',floattostr(nPeerWeight)),
            {$ENDIF}

            {$IFDEF MoreBeltLine}SF('T_BeltLine' , FListA.Values['BeltLine']), {$ENDIF}

            SF('T_HKBills' , nOut.FData + '.')
            ], sTable_ZTTrucks, '', True);
          gDBConnManager.WorkerExec(FDBConn, nSQL);
        end;

        if Length(FListA.Values['Card']) > 0 then
        begin
          if FListC.Values['Type'] = sFlag_Dai then
          begin
            nSQL := 'Update $Bill Set L_NextStatus=''$NT'' '+
                    'Where L_ID=''$ID''';
            nSQL := MacroValue(nSQL, [MI('$Bill', sTable_Bill),
                    MI('$NT', sFlag_TruckZT),
                    MI('$ID', nOut.FData)]);
            gDBConnManager.WorkerExec(FDBConn, nSQL);
          end;
          //��װ��һ״̬ջ̨

          nSQL := 'Update %s Set T_InFact=%s Where T_HKBills Like ''%%%s%%''';
          nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now,
                  nOut.FData]);
          gDBConnManager.WorkerExec(FDBConn, nSQL);
        end;
        //��������ҵ���ѽ���

        {$IFDEF TruckInNow}
        nStatus := sFlag_TruckIn;
        nNextStatus := sFlag_TruckBFP;
        if FListC.Values['Type'] = sFlag_Dai then
        begin
          nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
          nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_PoundIfDai]);

          with gDBConnManager.WorkerQuery(FDBConn, nStr) do
           if (RecordCount > 0) and (Fields[0].AsString = sFlag_No) then
            nNextStatus := sFlag_TruckZT;
          //��װ������
        end;

        nSQL := MakeSQLByStr([
                SF('L_Status', nStatus),
                SF('L_NextStatus', nNextStatus),
                SF('L_InTime', sField_SQLServer_Now, sfVal)
                ], sTable_Bill, SF('L_ID', nOut.FData), False);
        gDBConnManager.WorkerExec(FDBConn, nSQL);

        nSQL := 'Update %s Set T_InFact=%s Where T_HKBills Like ''%%%s%%''';
        nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now,
                nOut.FData]);
        gDBConnManager.WorkerExec(FDBConn, nSQL);
        {$ENDIF}
      end;
    end;

    if FListA.Values['BuDan'] = sFlag_Yes then //����
    begin
      {$IFDEF BDAUDIT}
      WriteLog('������˹�������,����δ����,�ȴ��������...');
      {$ELSE}
      nStr := 'Update %s Set A_OutMoney=A_OutMoney+%s Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nVal),
              FListA.Values['CusID']]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //freeze money from account
      {$ENDIF}
    end else
    begin
      nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney+%s Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nVal),
              FListA.Values['CusID']]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //freeze money from account
    end;

    if nFixMoney = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney-%s Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, FloatToStr(nVal),
              FListA.Values['ZhiKa']]);
      //xxxxx

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //freeze money from zhika
    end;

    nIdx := Length(FOut.FData);
    if Copy(FOut.FData, nIdx, 1) = ',' then
      System.Delete(FOut.FData, nIdx, 1);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;

  //ʹ��ҵ��Ա����
  {$IFDEF UseSalesCredit}
  TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
            FListA.Values['ZhiKa'], '', @nOut);
  {$ENDIF}

  {$IFDEF UseERP_K3}
  if FListA.Values['BuDan'] = sFlag_Yes then //����
  try
    nSQL := AdjustListStrFormat(FOut.FData, '''', True, ',', False);
    //bill list

    if not TWorkerBusinessCommander.CallMe(cBC_SyncStockBill, nSQL, '', @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx
  except
    nStr := 'Delete From %s Where L_ID In (%s)';
    nStr := Format(nStr, [sTable_Bill, nSQL]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    raise;
  end;
  {$ENDIF}

  {$IFDEF MicroMsg}
  with FListC do
  begin
    Clear;
    Values['bill'] := FOut.FData;
    Values['company'] := gSysParam.FHintText;
  end;

  if FListA.Values['BuDan'] = sFlag_Yes then
       nStr := cWXBus_OutFact
  else nStr := cWXBus_MakeCard;

  gWXPlatFormHelper.WXSendMsg(nStr, FListC.Text);
  {$ENDIF}
end;

//------------------------------------------------------------------------------
//Date: 2014-09-16
//Parm: ������[FIn.FData];���ƺ�[FIn.FExtParam]
//Desc: �޸�ָ���������ĳ��ƺ�
function TWorkerBusinessBills.ChangeBillTruck(var nData: string): Boolean;
var nIdx: Integer;
    nStr,nTruck: string;
begin
  Result := False;
  if not VerifyTruckNO(FIn.FExtParam, nData) then Exit;

  nStr := 'Select L_Truck,L_InTime From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount <> 1 then
    begin
      nData := '������[ %s ]����Ч.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    {$IFNDEF TruckInNow}
    if Fields[1].AsString <> '' then
    begin
      nData := '������[ %s ]�����,�޷��޸ĳ��ƺ�.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    {$ENDIF}

    nTruck := Fields[0].AsString;
  end;

  nStr := 'Select R_ID,T_HKBills From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_ZTTrucks, nTruck]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    FListA.Clear;
    FListB.Clear;
    First;

    while not Eof do
    begin
      SplitStr(Fields[1].AsString, FListC, 0, '.');
      FListA.AddStrings(FListC);
      FListB.Add(Fields[0].AsString);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set L_Truck=''%s'' Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FExtParam, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //�����޸���Ϣ

    if (FListA.Count > 0) and (CompareText(nTruck, FIn.FExtParam) <> 0) then
    begin
      for nIdx:=FListA.Count - 1 downto 0 do
      if CompareText(FIn.FData, FListA[nIdx]) <> 0 then
      begin
        nStr := 'Update %s Set L_Truck=''%s'' Where L_ID=''%s''';
        nStr := Format(nStr, [sTable_Bill, FIn.FExtParam, FListA[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //ͬ���ϵ����ƺ�

        nStr := 'Update %s Set P_Truck=''%s'' Where P_Bill=''%s''';
        nStr := Format(nStr, [sTable_PoundLog, FIn.FExtParam, FListA[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //ͬ���ϵ�������¼���ƺ�
      end;
    end;

    if (FListB.Count > 0) and (CompareText(nTruck, FIn.FExtParam) <> 0) then
    begin
      for nIdx:=FListB.Count - 1 downto 0 do
      begin
        nStr := 'Update %s Set T_Truck=''%s'' Where R_ID=%s';
        nStr := Format(nStr, [sTable_ZTTrucks, FIn.FExtParam, FListB[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //ͬ���ϵ����ƺ�
      end;
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-30
//Parm: ��������[FIn.FData];��ֽ��[FIn.FExtParam]
//Desc: ����������������ֽ���Ŀͻ�
function TWorkerBusinessBills.BillSaleAdjust(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nVal,nMon: Double;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  //init

  //----------------------------------------------------------------------------
  nStr := 'Select L_CusID,L_StockNo,L_StockName,L_Value,L_Price,L_ZhiKa,' +
          'L_ZKMoney,L_OutFact From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [FIn.FData]);
      Exit;
    end;

    if FieldByName('L_OutFact').AsString = '' then
    begin
      nData := '����������(������)���ܵ���.';
      Exit;
    end;

    FListB.Clear;
    with FListB do
    begin
      Values['CusID'] := FieldByName('L_CusID').AsString;
      Values['StockNo'] := FieldByName('L_StockNo').AsString;
      Values['StockName'] := FieldByName('L_StockName').AsString;
      Values['ZhiKa'] := FieldByName('L_ZhiKa').AsString;
      Values['ZKMoney'] := FieldByName('L_ZKMoney').AsString;
    end;
    
    nVal := FieldByName('L_Value').AsFloat;
    nMon := nVal * FieldByName('L_Price').AsFloat;
    nMon := Float2Float(nMon, cPrecision, True);
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select zk.*,ht.C_Area,cus.C_Name,cus.C_PY,sm.S_Name From $ZK zk ' +
          ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
          'Where Z_ID=''$ZID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
          MI('$HT', sTable_SaleContract),
          MI('$Cus', sTable_Customer),
          MI('$SM', sTable_Salesman),
          MI('$ZID', FIn.FExtParam)]);
  //ֽ����Ϣ

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('ֽ��[ %s ]�Ѷ�ʧ.', [FIn.FExtParam]);
      Exit;
    end;

    if FieldByName('Z_Freeze').AsString = sFlag_Yes then
    begin
      nData := Format('ֽ��[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
      Exit;
    end;

    if FieldByName('Z_InValid').AsString = sFlag_Yes then
    begin
      nData := Format('ֽ��[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
      Exit;
    end;

    if FieldByName('Z_ValidDays').AsDateTime <= Date() then
    begin
      nData := Format('ֽ��[ %s ]����[ %s ]����.', [FIn.FExtParam,
               Date2Str(FieldByName('Z_ValidDays').AsDateTime)]);
      Exit;
    end;

    FListA.Clear;
    with FListA do
    begin
      Values['Project'] := FieldByName('Z_Project').AsString;
      Values['Area'] := FieldByName('C_Area').AsString;
      Values['CusID'] := FieldByName('Z_Customer').AsString;
      Values['CusName'] := FieldByName('C_Name').AsString;
      Values['CusPY'] := FieldByName('C_PY').AsString;
      Values['SaleID'] := FieldByName('Z_SaleMan').AsString;
      Values['SaleMan'] := FieldByName('S_Name').AsString;
      Values['ZKMoney'] := FieldByName('Z_OnlyMoney').AsString;
      Values['ZArea']   := FieldByName('Z_Area').AsString;
      Values['XHSpot']  := FieldByName('Z_XHSpot').AsString;
      Values['Lading']  := FieldByName('Z_Lading').AsString;
      Values['Freight']  := FieldByName('Z_Freight').AsString;
    end;
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select D_Price,b.Z_Freight From %s,%s b Where D_Zid=Z_ID And '+
          ' D_ZID=''%s'' And D_StockNo=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl,sTable_ZhiKa, FIn.FExtParam, FListB.Values['StockNo']]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := 'ֽ��[ %s ]��û������Ϊ[ %s ]��Ʒ��.';
      nData := Format(nData, [FIn.FExtParam, FListB.Values['StockName']]);
      Exit;
    end;

    FListC.Clear;
    nStr := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nMon, FListB.Values['CusID']]);
    FListC.Add(nStr); //��ԭ���������

    if FListB.Values['ZKMoney'] = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) ' +
              'Where Z_ID=''%s'' And Z_OnlyMoney=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nMon,
              FListB.Values['ZhiKa'], sFlag_Yes]);
      FListC.Add(nStr); //��ԭ�����������
    end;

    nMon := nVal * FieldByName('D_Price').AsFloat;
    nMon := Float2Float(nMon, cPrecision, True);

    if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
            FIn.FExtParam, '', @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;

    if FloatRelation(nMon, StrToFloat(nOut.FData), rtGreater, cPrecision) then
    begin
      nData := '�ͻ�[ %s.%s ]����,��������:' + #13#10#13#10 +
               '��.�������: %.2fԪ' + #13#10 +
               '��.��������: %.2fԪ' + #13#10 +
               '��.�� �� ��: %.2fԪ' + #13#10#13#10 +
               '�뵽�����Ұ���"��������"����,Ȼ���ٴε���.';
      nData := Format(nData, [FListA.Values['CusID'], FListA.Values['CusName'],
               StrToFloat(nOut.FData), nMon,
               Float2Float(nMon - StrToFloat(nOut.FData), cPrecision, True)]);
      Exit;
    end;

    nStr := 'Update %s Set A_OutMoney=A_OutMoney+(%.2f) Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nMon, FListA.Values['CusID']]);
    FListC.Add(nStr); //���ӵ���������

    if FListA.Values['ZKMoney'] = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nMon, FIn.FExtParam]);
      FListC.Add(nStr); //�ۼ�������������
    end;

    nStr := MakeSQLByStr([SF('L_ZhiKa', FIn.FExtParam),
            SF('L_Project', FListA.Values['Project']),
            SF('L_Area', FListA.Values['ZArea']),
            SF('L_CusID', FListA.Values['CusID']),
            SF('L_CusName', FListA.Values['CusName']),
            SF('L_CusPY', FListA.Values['CusPY']),
            SF('L_SaleID', FListA.Values['SaleID']),
            SF('L_SaleMan', FListA.Values['SaleMan']),
            SF('L_Price', FieldByName('D_Price').AsFloat, sfVal),
            SF('L_ZKMoney', FListA.Values['ZKMoney']),
            SF('L_Lading', FListA.Values['Lading']),
            SF('L_Freight', FieldByName('Z_Freight').AsFloat, sfVal),
            SF('L_XHSpot', FListA.Values['XHSpot'])
            ], sTable_Bill, SF('L_ID', FIn.FData), False);
    FListC.Add(nStr); //���ӵ���������
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListC.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-16
//Parm: ��������[FIn.FData]
//Desc: ɾ��ָ��������
function TWorkerBusinessBills.DeleteBill(var nData: string): Boolean;
var nIdx: Integer;
    nHasOut: Boolean;
    nVal,nMoney: Double;
    nStr,nP,nFix,nRID,nCus,nBill,nZK,nHY,nFact: string;
begin
  Result := False;
  //init

  nStr := 'Select L_ZhiKa,L_Value,L_Price,L_CusID,L_OutFact,L_ZKMoney,L_HYDan ' +
          {$IFDEF MoreBeltLine} ',L_BeltLine ' + {$ENDIF}
          'From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '������[ %s ]����Ч.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nHasOut := FieldByName('L_OutFact').AsString <> '';
    //�ѳ���
    {$IFDEF HYJC}
    if nHasOut and (FIn.FBase.FFrom.FUser<>'admin') then
    begin
      nData := '������[ %s ]�ѳ���,������ɾ��.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    {$ENDIF}
    nCus := FieldByName('L_CusID').AsString;
    nHY  := FieldByName('L_HYDan').AsString;
    nZK  := FieldByName('L_ZhiKa').AsString;
    nFix := FieldByName('L_ZKMoney').AsString;

    {$IFDEF MoreBeltLine}
    nFact := FieldByName('L_BeltLine').AsString;
    {$ENDIF}

    nVal := FieldByName('L_Value').AsFloat;
    nMoney := Float2Float(nVal*FieldByName('L_Price').AsFloat, cPrecision, True);
  end;

  nStr := 'Select R_ID,T_HKBills,T_Bill From %s ' +
          'Where T_HKBills Like ''%%%s%%''';
  nStr := Format(nStr, [sTable_ZTTrucks, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    if RecordCount <> 1 then
    begin
      nData := '������[ %s ]�����ڶ�����¼��,�쳣��ֹ!';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nRID := Fields[0].AsString;
    nBill := Fields[2].AsString;
    SplitStr(Fields[1].AsString, FListA, 0, '.')
  end else
  begin
    nRID := '';
    FListA.Clear;
  end;

  FDBConn.FConn.BeginTrans;
  try
    if FListA.Count = 1 then
    begin
      nStr := 'Delete From %s Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, nRID]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else

    if FListA.Count > 1 then
    begin
      nIdx := FListA.IndexOf(FIn.FData);
      if nIdx >= 0 then
        FListA.Delete(nIdx);
      //�Ƴ��ϵ��б�

      if nBill = FIn.FData then
        nBill := FListA[0];
      //����������

      nStr := 'Update %s Set T_Bill=''%s'',T_Value=T_Value-(%.2f),' +
              'T_HKBills=''%s'' Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, nBill, nVal,
              CombinStr(FListA, '.'), nRID]);
      //xxxxx

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //���ºϵ���Ϣ
    end;

    //--------------------------------------------------------------------------
    if nHasOut then
    begin
      nStr := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CusAccount, nMoney, nCus]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //�ͷų���
    end else
    begin
      nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney-(%.2f) Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CusAccount, nMoney, nCus]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //�ͷŶ����
    end;

    if nFix = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nMoney, nZK]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //�ͷ�������
    end;

    nStr := 'Update %s Set B_HasUse=B_HasUse-%.2f Where B_Batcode=''%s''';
        {$IFDEF MoreBeltLine}
         nStr := nStr + ' And B_BeltLine='''+nFact+'''';
        {$endif}
    nStr := Format(nStr, [sTable_StockBatcode, nVal, nHY]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //�ͷ�ʹ�õ����κ�

    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_Bill]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('L_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //�����ֶ�,������ɾ��

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $BB($FL,L_DelMan,L_DelDate) ' +
            'Select $FL,''$User'',$Now From $BI Where L_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$BB', sTable_BillBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$BI', sTable_Bill), MI('$ID', FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Delete From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: ������[FIn.FData];�ſ���[FIn.FExtParam]
//Desc: Ϊ�������󶨴ſ�
function TWorkerBusinessBills.SaveBillCard(var nData: string): Boolean;
var nStr,nSQL,nTruck,nType: string;
begin  
  nType := '';
  nTruck := '';
  Result := False;

  FListB.Text := FIn.FExtParam;
  //�ſ��б�
  nStr := AdjustListStrFormat(FIn.FData, '''', True, ',', False);
  //�������б�

  nSQL := 'Select L_ID,L_Card,L_Type,L_Truck,L_OutFact From %s ' +
          'Where L_ID In (%s)';
  nSQL := Format(nSQL, [sTable_Bill, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [FIn.FData]);
      Exit;
    end;

    First;
    while not Eof do
    begin
      if FieldByName('L_OutFact').AsString <> '' then
      begin
        nData := '������[ %s ]�ѳ���,��ֹ�쿨.';
        nData := Format(nData, [FieldByName('L_ID').AsString]);
        Exit;
      end;

      nStr := FieldByName('L_Truck').AsString;
      if (nTruck <> '') and (nStr <> nTruck) then
      begin
        nData := '������[ %s ]�ĳ��ƺŲ�һ��,���ܲ���.' + #13#10#13#10 +
                 '*.��������: %s' + #13#10 +
                 '*.��������: %s' + #13#10#13#10 +
                 '��ͬ�ƺŲ��ܲ���,���޸ĳ��ƺ�,���ߵ����쿨.';
        nData := Format(nData, [FieldByName('L_ID').AsString, nStr, nTruck]);
        Exit;
      end;

      if nTruck = '' then
        nTruck := nStr;
      //xxxxx

      nStr := FieldByName('L_Type').AsString;
      if (nType <> '') and ((nStr <> nType) or (nStr = sFlag_San)) then
      begin
        if nStr = sFlag_San then
             nData := '������[ %s ]ͬΪɢװ,���ܲ���.'
        else nData := '������[ %s ]��ˮ�����Ͳ�һ��,���ܲ���.';
          
        nData := Format(nData, [FieldByName('L_ID').AsString]);
        Exit;
      end;

      if nType = '' then
        nType := nStr;
      //xxxxx

      nStr := FieldByName('L_Card').AsString;
      //����ʹ�õĴſ�
        
      if (nStr <> '') and (FListB.IndexOf(nStr) < 0) then
        FListB.Add(nStr);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  SplitStr(FIn.FData, FListA, 0, ',');
  //�������б�
  nStr := AdjustListStrFormat2(FListB, '''', True, ',', False);
  //�ſ��б�

  nSQL := 'Select L_ID,L_Type,L_Truck From %s Where L_Card In (%s)';
  nSQL := Format(nSQL, [sTable_Bill, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('L_Type').AsString;
      if (nStr <> sFlag_Dai) or ((nType <> '') and (nStr <> nType)) then
      begin
        nData := '����[ %s ]����ʹ�øÿ�,�޷�����.';
        nData := Format(nData, [FieldByName('L_Truck').AsString]);
        Exit;
      end;

      nStr := FieldByName('L_Truck').AsString;
      if (nTruck <> '') and (nStr <> nTruck) then
      begin
        nData := '����[ %s ]����ʹ�øÿ�,��ͬ�ƺŲ��ܲ���.';
        nData := Format(nData, [nStr]);
        Exit;
      end;

      nStr := FieldByName('L_ID').AsString;
      if FListA.IndexOf(nStr) < 0 then
        FListA.Add(nStr);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  if not AllowedSanMultiBill then
  begin
    nSQL := 'Select T_HKBills From %s Where T_Truck=''%s'' ';
    nSQL := Format(nSQL, [sTable_ZTTrucks, nTruck]);

    //���ڶ����г���
    nStr := '';
    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      try
        nStr := nStr + Fields[0].AsString;
      finally
        Next;
      end;

      nStr := Copy(nStr, 1, Length(nStr)-1);
      nStr := StringReplace(nStr, '.', ',', [rfReplaceAll]);
    end;

    nStr := AdjustListStrFormat(nStr, '''', True, ',', False);
    //�����н������б�

    nSQL := 'Select L_Card From %s Where L_ID In (%s)';
    nSQL := Format(nSQL, [sTable_Bill, nStr]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if (Fields[0].AsString <> '') and
           (Fields[0].AsString <> FIn.FExtParam) then
        begin
          nData := '����[ %s ]�Ĵſ��Ų�һ��,���ܲ���.' + #13#10#13#10 +
                   '*.�����ſ�: [%s]' + #13#10 +
                   '*.�����ſ�: [%s]' + #13#10#13#10 +
                   '��ͬ�ſ��Ų��ܲ���,���޸ĳ��ƺ�,���ߵ����쿨.';
          nData := Format(nData, [nTruck, FIn.FExtParam, Fields[0].AsString]);
          Exit;
        end;

        Next;
      end;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    if FIn.FData <> '' then
    begin
      nStr := AdjustListStrFormat2(FListA, '''', True, ',', False);
      //���¼����б�

      nSQL := 'Update %s Set L_Card=''%s'' Where L_ID In(%s)';
      nSQL := Format(nSQL, [sTable_Bill, FIn.FExtParam, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    nStr := 'Select Count(*) From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FExtParam]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if Fields[0].AsInteger < 1 then
    begin
      nStr := MakeSQLByStr([SF('C_Card', FIn.FExtParam),
              SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Sale),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, '', True);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else
    begin
      nStr := Format('C_Card=''%s''', [FIn.FExtParam]);
      nStr := MakeSQLByStr([SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Sale),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, nStr, False);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2016-12-30
//Parm: ���ƺ�[FIn.FData];�ſ���[FIn.FExtParam]
//Desc: ���ɳ����ĳ������������¼
function TWorkerBusinessBills.SaveBillLSCard(var nData: string): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  nStr := 'Select T_HKBills From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_ZTTrucks, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := '����[ %s ]���е���[ %s ]δ���,���ܰ���ſ�.';
    nData := Format(nStr, [FIn.FData, Fields[0].AsString]);
    Exit;
  end;

  FListC.Values['Group'] :=sFlag_BusGroup;
  FListC.Values['Object'] := sFlag_BillNo;
  //to get serial no

  if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
        FListC.Text, sFlag_Yes, @nOut) then
    raise Exception.Create(nOut.FData);
  //xxxxx

  FOut.FData := nOut.FData;
  //bill no

  FDBConn.FConn.BeginTrans;
  try
    nStr := MakeSQLByStr([SF('L_ID', nOut.FData),
            SF('L_Card', FIn.FExtParam),
            SF('L_CusID', sFlag_LSCustomer),
            SF('L_CusName', '���ۿͻ�_����'),

            SF('L_Type', sFlag_San),
            SF('L_StockNo', sFlag_LSStock),
            SF('L_StockName', '��������_����'),
            SF('L_Value', 0, sfVal),
            SF('L_Price', 0, sfVal),

            SF('L_Truck', FIn.FData),
            SF('L_Status', sFlag_BillNew),
            SF('L_Man', FIn.FBase.FFrom.FUser),
            SF('L_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Bill, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := Format('C_Card=''%s''', [FIn.FExtParam]);
    nStr := MakeSQLByStr([SF('C_Status', sFlag_CardUsed),
            SF('C_Used', sFlag_Sale),
            SF('C_Freeze', sFlag_No),
            SF('C_Man', FIn.FBase.FFrom.FUser),
            SF('C_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Card, nStr, False);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: �ſ���[FIn.FData]
//Desc: ע���ſ�
function TWorkerBusinessBills.LogoffCard(var nData: string): Boolean;
var nStr: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set L_Card=Null Where L_Card=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Update %s Set C_Status=''%s'', C_Used=Null Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, sFlag_CardInvalid, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2017-07-04
//Parm: �������[FIn.FData];�Ͽ���[FIn.FExtParam]
//Desc: ��Ԥ�ȹ�����ֽ���п۳�������
function TWorkerBusinessBills.MakeSanPreHK(var nData: string): Boolean;
var nStr: string;
    nListA,nListB: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;

  Result := False;
  try
    nStr := 'Select * From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FData]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '�����[ %s ]��ʧ,�Ͽ�ʧ��';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      with nListA do
      begin
        Clear;
        Values['BillID']   := FIn.FData;
        Values['BillCard'] := FieldByName('L_Card').AsString;
        //ԭ����

        Values['Truck']    := FieldByName('L_Truck').AsString;
        Values['Lading']   := FieldByName('L_Lading').AsString;
        Values['IsVIP']    := FieldByName('L_IsVIP').AsString;
        Values['BuDan']    := sFlag_No;
      end;

      with nListB do
      begin
        Clear;
        Values['Type']      := FieldByName('L_Type').AsString;
        Values['StockNO']   := FieldByName('L_StockNo').AsString;
        Values['StockName'] := FieldByName('L_StockName').AsString;

        Values['Seal']      := FieldByName('L_Seal').AsString;
        Values['PrintGLF']  := FieldByName('L_PrintGLF').AsString;
        Values['PrintHY']   := FieldByName('L_PrintHY').AsString;
      end;
    end;

    nStr := 'Select H_ZhiKa,D_StockNo,D_Price From %s hk ' +
            ' Left Join %s zd on zd.D_ZID=hk.H_ZhiKa ' +
            'Where H_Bill=''%s''';
    nStr := Format(nStr, [sTable_BillHK, sTable_ZhiKaDtl, FIn.FData]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '����[ %s ]����[ %s ]��,�����ֽ��';
        nData := Format(nData, [nListA.Values['Truck'], FIn.FExtParam]);
        Exit;
      end;

      First;
      nListA.Values['ZhiKa'] := FieldByName('H_ZhiKa').AsString;
    
      while not Eof do
      begin
        if FieldByName('D_StockNo').AsString = nListB.Values['StockNO'] then
        begin
          nListB.Values['Price'] := FieldByName('D_Price').AsString;
          nListB.Values['Value'] := FIn.FExtParam;

          nListA.Values['Bills'] := PackerEncodeStr(PackerEncodeStr(nListB.Text));
          Break;
        end;

        Next;
      end;

      if nListB.Values['Price'] = '' then
      begin
        nData := '����[ %s ]����[ %s ]��,���ϵ�ֽ����û��[ %s ]Ʒ��.';
        nData := Format(nData, [nListA.Values['Truck'], FIn.FExtParam,
                 nListB.Values['StockName']]);
        Exit;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := PackerEncodeStr(nListA.Text);
    if not TWorkerBusinessBills.CallMe(cBC_SaveBills, nStr, '', @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;

    FDBConn.FConn.BeginTrans;
    try
      nListA.Values['HKBill'] := nOut.FData;
      //�Ͽ����ɵĵ���

      nStr := MakeSQLByStr([SF('L_Card', nListA.Values['BillCard']),
              SF('L_Status', sFlag_TruckBFM),
              SF('L_NextStatus', sFlag_TruckOut),
              SF('L_PValue', '0', sfVal),
              SF('L_MValue', FIn.FExtParam, sfVal),
              SF('L_Man', FIn.FData + '-�ϵ�')
              ], sTable_Bill, SF('L_ID', nListA.Values['HKBill']), False);
      gDBConnManager.WorkerExec(FDBConn, nStr);

      nStr := 'Update %s Set H_HKBill=''%s'' Where H_Bill=''%s''';
      nStr := Format(nStr, [sTable_BillHK, nListA.Values['HKBill'],
              nListA.Values['BillID']]);
      gDBConnManager.WorkerExec(FDBConn, nStr);

      FDBConn.FConn.CommitTrans;
      Result := True;
    except
      on E: Exception do
      begin
        nData := '����[ %s ]�ϵ�ʧ��,����: %s';
        nData := Format(nData, [nListA.Values['Truck'], E.Message]);
        FDBConn.FConn.RollbackTrans;

        TWorkerBusinessBills.CallMe(cBC_DeleteBill, nOut.FData, '', @nOut);
        //ɾ�������
      end;
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

//Date: 2014-09-17
//Parm: �ſ���[FIn.FData];��λ[FIn.FExtParam]
//Desc: ��ȡ�ض���λ����Ҫ�Ľ������б�
function TWorkerBusinessBills.GetPostBillItems(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nIsBill: Boolean;
    nBills: TLadingBillItems;
begin
  Result := False;
  nIsBill := False;

  nStr := 'Select B_Prefix, B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_BillNo]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nIsBill := (Pos(Fields[0].AsString, FIn.FData) = 1) and
               (Length(FIn.FData) = Fields[1].AsInteger);
    //ǰ׺�ͳ��ȶ����㽻�����������,����Ϊ��������
  end;

  if not nIsBill then
  begin
    nStr := 'Select C_Status,C_Freeze From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FData]);
    //card status

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('�ſ�[ %s ]��Ϣ�Ѷ�ʧ.', [FIn.FData]);
        Exit;
      end;

      if Fields[0].AsString <> sFlag_CardUsed then
      begin
        nData := '�ſ�[ %s ]��ǰ״̬Ϊ[ %s ],�޷����.';
        nData := Format(nData, [FIn.FData, CardStatusToStr(Fields[0].AsString)]);
        Exit;
      end;

      if Fields[1].AsString = sFlag_Yes then
      begin
        nData := '�ſ�[ %s ]�ѱ�����,�޷����.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;
    end;
  end;

  {$IFDEF SendUnLoadPlace}
  nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusName,L_Type,L_StockNo,' +
          'L_StockName,L_Truck,L_Value,L_Price,L_ZKMoney,L_Status,' +
          'L_NextStatus,L_Card,L_IsVIP,L_PValue,L_MValue,L_PrintHY,' +
          'L_HYDan, L_EmptyOut, L_LadeTime,L_CusType,L_SPlace From $Bill b ';
  //xxxxx
  {$ELSE}
  nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusName,L_Type,L_StockNo,' +
          'L_StockName,L_Truck,L_Value,L_Price,L_ZKMoney,L_Status,' +
          'L_NextStatus,L_Card,L_IsVIP,L_PValue,L_MValue,L_PrintHY,' +
          'L_HYDan, L_EmptyOut, L_LadeTime,L_CusType,L_MHeight From $Bill b ';
  //xxxxx
  {$ENDIF}

  if nIsBill then
       nStr := nStr + 'Where L_ID=''$CD'''
  else nStr := nStr + 'Where L_Card=''$CD''';

  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$CD', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      if nIsBill then
           nData := '������[ %s ]����Ч.'
      else nData := '�ſ���[ %s ]û�н�����.';

      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    SetLength(nBills, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    with nBills[nIdx] do
    begin
      FID         := FieldByName('L_ID').AsString;
      FZhiKa      := FieldByName('L_ZhiKa').AsString;
      FCusID      := FieldByName('L_CusID').AsString;
      FCusName    := FieldByName('L_CusName').AsString;
      FTruck      := FieldByName('L_Truck').AsString;

      FType       := FieldByName('L_Type').AsString;
      FStockNo    := FieldByName('L_StockNo').AsString;
      FStockName  := FieldByName('L_StockName').AsString;
      FValue      := FieldByName('L_Value').AsFloat;
      FPrice      := FieldByName('L_Price').AsFloat;

      FCard       := FieldByName('L_Card').AsString;
      FIsVIP      := FieldByName('L_IsVIP').AsString;
      FStatus     := FieldByName('L_Status').AsString;
      FNextStatus := FieldByName('L_NextStatus').AsString;

      FHYDan      := FieldByName('L_HYDan').AsString;
      FPrintHY    := FieldByName('L_PrintHY').AsString = sFlag_Yes;
      FLadeTime   := FieldByName('L_LadeTime').AsString;
      FCusType    := FieldByName('L_CusType').AsString;
      FMHeight    := FieldByName('L_MHeight').AsString;

      if FIsVIP = sFlag_TypeShip then
      begin
        FStatus    := sFlag_TruckZT;
        FNextStatus := sFlag_TruckOut;
      end;

      if (FStatus = sFlag_BillNew)or(FStatus = '') then
      begin
        FStatus     := sFlag_TruckNone;
        FNextStatus := sFlag_TruckNone;
      end;

      FPData.FValue := FieldByName('L_PValue').AsFloat;
      FMData.FValue := FieldByName('L_MValue').AsFloat;
      FYSValid      := FieldByName('L_EmptyOut').AsString;
      if Assigned(FindField('L_SPlace')) then
        FSPlace := FieldByName('L_SPlace').AsString;

      FSelected := True;

      Inc(nIdx);
      Next;
    end;
  end;

  FOut.FData := CombineBillItmes(nBills);
  Result := True;
end;

//Date: 2014-09-18
//Parm: ������[FIn.FData];��λ[FIn.FExtParam]
//Desc: ����ָ����λ�ύ�Ľ������б�
function TWorkerBusinessBills.SavePostBillItems(var nData: string): Boolean;
var nStr,nPrintTask,nSQL,nTmp,nFixMoney,nBeltLine: string;
    f,m,nVal,nMVal: Double;
    i,nIdx,nInt: Integer;
    nBills: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  AnalyseBillItems(FIn.FData, nBills);
  nInt := Length(nBills);

  if nInt < 1 then
  begin
    nData := '��λ[ %s ]�ύ�ĵ���Ϊ��.';
    nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
    Exit;
  end;

  {$IFNDEF SanPreHK}
  if (nBills[0].FType = sFlag_San) and (nInt > 1) then
  begin
    nData := '��λ[ %s ]�ύ��ɢװ�ϵ�,��ҵ��ϵͳ��ʱ��֧��.';
    nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
    Exit;
  end;
  {$ENDIF}

  FListA.Clear;
  //���ڴ洢SQL�б�

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckIn then //����
  begin
    with nBills[0] do
    begin
      FStatus := sFlag_TruckIn;
      FNextStatus := sFlag_TruckBFP;
    end;

    if nBills[0].FType = sFlag_Dai then
    begin
      nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_PoundIfDai]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
       if (RecordCount > 0) and (Fields[0].AsString = sFlag_No) then
        nBills[0].FNextStatus := sFlag_TruckZT;
      //��װ������
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    begin
      nStr := SF('L_ID', nBills[nIdx].FID);
      nSQL := MakeSQLByStr([
              SF('L_Status', nBills[0].FStatus),
              SF('L_NextStatus', nBills[0].FNextStatus),
              SF('L_InTime', sField_SQLServer_Now, sfVal),
              SF('L_InMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, nStr, False);
      FListA.Add(nSQL);

      nSQL := 'Update %s Set T_InFact=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now,
              nBills[nIdx].FID]);
      FListA.Add(nSQL);
      //���¶��г�������״̬
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFP then //����Ƥ��
  begin
    {$IFDEF YNHT}
    //�ж�Ƥ���Ƿ����
    with nBills[0] do
    begin
      nStr := 'Select R_ID From %s Where P_Bill=''%s''';
      nStr := Format(nStr, [sTable_PoundLog, FID]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        nData := '��վ[ %s ]����[ %s ]����[ %s ]�ύ�Ķ����Ѵ���Ƥ������,����ϵ����Ա.';
        nData := Format(nData, [FPData.FStation,FID,FTruck]);
        WriteLog('Ƥ�ؼ�¼��־��'+nData);
        Exit;
      end;
    end;
    {$ENDIF}
    FListB.Clear;
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        FListB.Add(Fields[0].AsString);
        Next;
      end;
    end;

    nInt := -1;
    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPoundID = sFlag_Yes then
    begin
      nInt := nIdx;
      Break;
    end;

    if nInt < 0 then
    begin
      nData := '��λ[ %s ]�ύ��Ƥ������Ϊ0.';
      nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
      Exit;
    end;

    //--------------------------------------------------------------------------
    FListC.Clear;
    FListC.Values['Field'] := 'T_PValue';
    FListC.Values['Truck'] := nBills[nInt].FTruck;
    FListC.Values['Value'] := FloatToStr(nBills[nInt].FPData.FValue);

    if not TWorkerBusinessCommander.CallMe(cBC_UpdateTruckInfo,
          FListC.Text, '', @nOut) then
      raise Exception.Create(nOut.FData);
    //���泵����ЧƤ��

    FListC.Clear;
    FListC.Values['Group']  := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_PoundID;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FStatus := sFlag_TruckBFP;
      if FType = sFlag_Dai then
           FNextStatus := sFlag_TruckZT
      else FNextStatus := sFlag_TruckFH;

      if FListB.IndexOf(FStockNo) >= 0 then
        FNextStatus := sFlag_TruckBFM;
      //�ֳ�������ֱ�ӹ���

      nSQL := MakeSQLByStr([
              SF('L_Status', FStatus),
              SF('L_NextStatus', FNextStatus),
              SF('L_PValue', nBills[nInt].FPData.FValue, sfVal),
              SF('L_PDate', sField_SQLServer_Now, sfVal),
              SF('L_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL);

      if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      FOut.FData := nOut.FData;
      //���ذ񵥺�,�������հ�

      nSQL := MakeSQLByStr([
              SF('P_ID', nOut.FData),
              SF('P_Type', sFlag_Sale),
              SF('P_Bill', FID),
              SF('P_Truck', FTruck),
              SF('P_CusID', FCusID),
              SF('P_CusName', FCusName),
              SF('P_MID', FStockNo),
              SF('P_MName', FStockName),
              SF('P_MType', FType),
              SF('P_LimValue', FValue),
              SF('P_PValue', nBills[nInt].FPData.FValue, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_FactID', nBills[nInt].FFactory),
              SF('P_PStation', nBills[nInt].FPData.FStation),
              SF('P_Direction', '����'),
              SF('P_PModel', FPModel),
              SF('P_Status', sFlag_TruckBFP),
              SF('P_Valid', sFlag_Yes),
              SF('P_PrintNum', 1, sfVal)
              ], sTable_PoundLog, '', True);
      FListA.Add(nSQL);
    end;

    nSQL := 'Update %s Set T_PDate=%s Where T_Truck=''%s''';
    nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now,
                          nBills[nInt].FTruck]);
    FListA.Add(nSQL); //���¹�Ƥʱ��,�����Ŷ�ʱ�ɲο���ʱ���Ŷ�
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckZT then //ջ̨�ֳ�
  begin
    nInt := -1;
    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPData.FValue > 0 then
    begin
      nInt := nIdx;
      Break;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FStatus := sFlag_TruckZT;
      if nInt >= 0 then //�ѳ�Ƥ
           FNextStatus := sFlag_TruckBFM
      else FNextStatus := sFlag_TruckOut;

      nSQL := MakeSQLByStr([SF('L_Status', FStatus),
              SF('L_NextStatus', FNextStatus),
              SF('L_LadeTime', sField_SQLServer_Now, sfVal),
              SF('L_EmptyOut', FYSValid),
              {$IFDEF SendUnLoadPlace}
              SF('L_SPlace', FSPlace),
              {$ENDIF}
              SF('L_LadeMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL);

      nSQL := 'Update %s Set T_InLade=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now, FID]);
      FListA.Add(nSQL);
      //���¶��г������״̬

      nSQL := 'UPDate %s Set L_InTime=L_Date Where L_InTime Is Null And L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill, FID]);
      FListA.Add(nSQL);
      //���û�н���ʱ�������
    end;
  end else

  if FIn.FExtParam = sFlag_TruckFH then //�Ż��ֳ�
  begin
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      nSQL := MakeSQLByStr([SF('L_Status', sFlag_TruckFH),
              SF('L_NextStatus', sFlag_TruckBFM),
              SF('L_LadeTime', sField_SQLServer_Now, sfVal),
              SF('L_EmptyOut', FYSValid),
              {$IFDEF SendUnLoadPlace}
              SF('L_SPlace', FSPlace),
              {$ENDIF}
              SF('L_LadeMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL);

      nSQL := 'Update %s Set T_InLade=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now, FID]);
      FListA.Add(nSQL);
      //���¶��г������״̬
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    nInt := -1;
    nMVal := 0;

    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPoundID = sFlag_Yes then
    begin
      nMVal := nBills[nIdx].FMData.FValue;
      nInt := nIdx;
      Break;
    end;

    if nInt < 0 then
    begin
      nData := '��λ[ %s ]�ύ��ë������Ϊ0.';
      nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
      Exit;
    end;

    {$IFDEF MoreBeltLine}
    nSQL := ' Select L_HYDan, L_BeltLine From %s Where L_ID=''%s'' ';
    nSQL := Format(nSQL, [sTable_Bill, nBills[0].FID]);
    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      nBeltLine:= Fields[1].AsString;
    end;
    {$ENDIF}

    with nBills[0] do
    begin
      if FYSValid <> sFlag_Yes then
      begin
        if FType = sFlag_San then //ɢװ�轻���ʽ��
        begin
          if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
                 nBills[0].FZhiKa, '', @nOut) then
          begin
            nData := nOut.FData;
            Exit;
          end;

          m := StrToFloat(nOut.FData);
          m := m + Float2Float(FPrice * FValue, cPrecision, False);
          //ֽ�����ý�

          nVal := FValue;
          FValue := nMVal - FPData.FValue;
          //�¾���,ʵ�������
          f := Float2Float(FPrice * FValue, cPrecision, False)+0.01 - m;
          //ʵ������������ý���,ֻ�벻��

          if f > 0 then
          begin
            {$IFDEF SanPreHK}
            f := Float2Float(f / FPrice, cPrecision, False)+0.01;
            //ֽ����������

            FValue := FValue - f;
            //ֽ�����ɷ���
            nMVal := nMVal - f;
            FMData.FValue := nMVal;
            //����ë��,ʹ��������һ��

            if not TWorkerBusinessBills.CallMe(cBC_MakeSanPreHK,
                   nBills[0].FID, FloatToStr(f), @nOut) then
            begin
              nData := nOut.FData;
              Exit;
            end;
            {$ELSE}
            nData := '�ͻ�[ %s.%s ]�ʽ�����,��������:' + #13#10#13#10 +
                     '��.���ý��: %.2fԪ' + #13#10 +
                     '��.������: %.2fԪ' + #13#10 +
                     '��.�� �� ��: %.2fԪ' + #13#10+#13#10 +
                     '�뵽�����Ұ���"��������"����,Ȼ���ٴγ���.';
            nData := Format(nData, [FCusID, FCusName, m, FPrice * FValue, f]);
            Exit;
            {$ENDIF}
          end;

          m := Float2Float(FPrice * FValue, cPrecision, True);
          m := m - Float2Float(FPrice * nVal, cPrecision, True);
          //����������

          WriteLog('zyww::����ë�����������,�ͻ���'+FCusID+',����:'+floattostr(m));

          nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%.2f) ' +
                  'Where A_CID=''%s''';
          nSQL := Format(nSQL, [sTable_CusAccount, m, FCusID]);
          FListA.Add(nSQL); //�����˻�

          nSQL := MakeSQLByStr([SF('L_Value', FValue, sfVal)
                  ], sTable_Bill, SF('L_ID', FID), False);
          FListA.Add(nSQL); //���������

          if nOut.FExtParam = sFlag_Yes then
          begin
            nSQL := 'Update %s Set Z_FixedMoney=Z_FixedMoney-(%.2f) ' +
                    'Where Z_ID=''%s''';
            nSQL := Format(nSQL, [sTable_ZhiKa, m, FZhiKa]);
            FListA.Add(nSQL); //����ֽ��������
          end;

          nSQL := 'Select L_HYDan From %s Where L_ID=''%s''';
          nSQL := Format(nSQL, [sTable_Bill, FID]);
          with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
          if RecordCount > 0 then
          begin
            nSQL := 'Update %s Set B_HasUse=B_HasUse+(%.2f - %.2f) ' +
                    'Where B_Batcode=''%s''';
            {$IFDEF MoreBeltLine}
            nSQL := nSQL + ' And B_BeltLine='''+nBeltLine+'''';
            {$endif}
            nSQL := Format(nSQL, [sTable_StockBatcode, FValue, nVal,
                    Fields[0].AsString]);
            FListA.Add(nSQL);
          end;
          //�������κ�ʹ����
        end;
      end
      else
      begin
        if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
               nBills[0].FZhiKa, '', @nOut) then
        begin
          nData := nOut.FData;
          Exit;
        end;
        nFixMoney := nOut.FExtParam;

        if nFixMoney = sFlag_Yes then
        begin
          nSQL := 'Update %s Set Z_FixedMoney=Z_FixedMoney-%s Where Z_ID=''%s''';
          nSQL := Format(nSQL, [sTable_ZhiKa, FloatToStr(nVal),
                  nBills[0].FZhiKa]);
          //xxxxx

          FListA.Add(nSQL);
        end;
        //�ͷ�������

        nVal := Float2Float(FPrice * FValue, cPrecision, False);

        nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney-%s Where A_CID=''%s''';
        nSQL := Format(nSQL, [sTable_CusAccount, FloatToStr(nVal),
                FCusID]);
        FListA.Add(nSQL);
        //�ͷŶ����

        nSQL := 'Update %s Set A_FreezeMoney = 0 Where A_FreezeMoney < 0 ';
        nSQL := Format(nSQL, [sTable_CusAccount]);
        FListA.Add(nSQL);
        //�����Ϊ��������Ϊ0

        nSQL := 'Update %s Set B_HasUse=B_HasUse-%.2f Where B_Batcode=''%s''';
            {$IFDEF MoreBeltLine}
            nSQL := nSQL + ' And B_BeltLine='''+nBeltLine+'''';
            {$endif}
        nSQL := Format(nSQL, [sTable_StockBatcode, FValue, FHYDan]);
        FListA.Add(nSQL);
        //�ͷ�ʹ�õ����κ�
      end;
    end;

    nVal := 0;
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      if nIdx < High(nBills) then
      begin
        FMData.FValue := FPData.FValue + FValue;
        nVal := nVal + FValue;
        //�ۼƾ���

        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', nBills[nInt].FMData.FStation)
                ], sTable_PoundLog, SF('P_Bill', FID), False);
        FListA.Add(nSQL);
      end else
      begin
        FMData.FValue := nMVal - nVal;
        //�ۼ����ۼƵľ���

        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', nBills[nInt].FMData.FStation)
                ], sTable_PoundLog, SF('P_Bill', FID), False);
        FListA.Add(nSQL);
      end;
    end;

    FListB.Clear;
    if nBills[nInt].FPModel <> sFlag_PoundCC then //����ģʽ,ë�ز���Ч
    begin
      nSQL := 'Select L_ID From %s Where L_Card=''%s'' And L_MValue Is Null';
      nSQL := Format(nSQL, [sTable_Bill, nBills[nInt].FCard]);
      //δ��ë�ؼ�¼

      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      if RecordCount > 0 then
      begin
        First;

        while not Eof do
        begin
          FListB.Add(Fields[0].AsString);
          Next;
        end;
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      if nBills[nInt].FPModel = sFlag_PoundCC then Continue;
      //����ģʽ,������״̬

      i := FListB.IndexOf(FID);
      if i >= 0 then
        FListB.Delete(i);
      //�ų����γ���

      if FYSValid <> sFlag_Yes then   //�ж��Ƿ�ճ�����
      begin
        nSQL := MakeSQLByStr([SF('L_Value', FValue, sfVal),
                SF('L_Status', sFlag_TruckBFM),
                SF('L_NextStatus', sFlag_TruckOut),
                SF('L_MValue', FMData.FValue , sfVal),
                SF('L_MDate', sField_SQLServer_Now, sfVal),
                SF('L_MMan', FIn.FBase.FFrom.FUser)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL);
      end else
      begin
        nSQL := MakeSQLByStr([SF('L_Value', 0.00, sfVal),
                SF('L_Status', sFlag_TruckBFM),
                SF('L_NextStatus', sFlag_TruckOut),
                SF('L_MValue', FMData.FValue , sfVal),
                SF('L_MDate', sField_SQLServer_Now, sfVal),
                SF('L_MMan', FIn.FBase.FFrom.FUser)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL);
      end;
    end;

    if FListB.Count > 0 then
    begin
      nTmp := AdjustListStrFormat2(FListB, '''', True, ',', False);
      //δ���ؽ������б�

      nStr := Format('L_ID In (%s)', [nTmp]);
      nSQL := MakeSQLByStr([
              SF('L_PValue', nMVal, sfVal),
              SF('L_PDate', sField_SQLServer_Now, sfVal),
              SF('L_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, nStr, False);
      FListA.Add(nSQL);
      //û�г�ë�ص������¼��Ƥ��,���ڱ��ε�ë��

      nStr := Format('P_Bill In (%s)', [nTmp]);
      nSQL := MakeSQLByStr([
              SF('P_PValue', nMVal, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_PStation', nBills[nInt].FMData.FStation)
              ], sTable_PoundLog, nStr, False);
      FListA.Add(nSQL);
      //û�г�ë�صĹ�����¼��Ƥ��,���ڱ��ε�ë��
    end;

    nSQL := 'Select P_ID From %s Where P_Bill=''%s'' And P_MValue Is Null';
    nSQL := Format(nSQL, [sTable_PoundLog, nBills[nInt].FID]);
    //δ��ë�ؼ�¼

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      FOut.FData := Fields[0].AsString;
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckOut then
  begin
    FListB.Clear;
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FListB.Add(FID);
      //�������б�

      nSQL := MakeSQLByStr([SF('L_Status', sFlag_TruckOut),
              SF('L_NextStatus', ''),
              SF('L_Card', ''),
              SF('L_OutFact', sField_SQLServer_Now, sfVal),
              SF('L_OutMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL); //���½�����

      if FYSValid <> sFlag_Yes then
      begin
        nVal := Float2Float(FPrice * FValue, cPrecision, True);
        //������

        nSQL := 'Update %s Set A_OutMoney=A_OutMoney+(%.2f),' +
                'A_FreezeMoney=A_FreezeMoney-(%.2f) Where A_CID=''%s''';
        nSQL := Format(nSQL, [sTable_CusAccount, nVal, nVal, FCusID]);
        FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
      end;
      {$IFDEF PrintHYEach}
      if FPrintHY then
      begin
        FListC.Values['Group'] :=sFlag_BusGroup;
        FListC.Values['Object'] := sFlag_HYDan;
        //to get serial no

        if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
          raise Exception.Create(nOut.FData);
        //xxxxx

        nSQL := MakeSQLByStr([SF('H_No', nOut.FData),
                SF('H_Custom', FCusID),
                SF('H_CusName', FCusName),
                SF('H_SerialNo', FHYDan),
                SF('H_Truck', FTruck),
                SF('H_Value', FValue, sfVal),
                SF('H_BillDate', sField_SQLServer_Now, sfVal),
                SF('H_ReportDate', sField_SQLServer_Now, sfVal),
                //SF('H_EachTruck', sFlag_Yes),
                SF('H_Reporter', FID)], sTable_StockHuaYan, '', True);
        FListA.Add(nSQL); //�Զ����ɻ��鵥
      end;
      {$ENDIF}
    end;

    {$IFDEF UseERP_K3}
    nStr := CombinStr(FListB, ',', True);
    if not TWorkerBusinessCommander.CallMe(cBC_SyncStockBill, nStr, '', @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;
    {$ENDIF}

    {$IFDEF SendBillToBakDB}
    if nBills[0].FCusType = 'A' then    //A:��Ʊ�ͻ�
    begin
      nStr := CombinStr(FListB, ',', True);
      if not TWorkerBusinessCommander.CallMe(cBC_SyncStockBill, nStr, '', @nOut) then
      begin
        nData := nOut.FData;
        Exit;
      end;
    end;
    {$ENDIF}

    nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
    nSQL := Format(nSQL, [sTable_Card, sFlag_CardIdle, nBills[0].FCard]);
    FListA.Add(nSQL); //���´ſ�״̬

    nStr := AdjustListStrFormat2(FListB, '''', True, ',', False);
    //�������б�

    nSQL := 'Select T_Line,Z_Name as T_Name,T_Bill,T_PeerWeight,T_Total,' +
            'T_Normal,T_BuCha,T_HKBills From %s ' +
            ' Left Join %s On Z_ID = T_Line ' +
            'Where T_Bill In (%s)';
    nSQL := Format(nSQL, [sTable_ZTTrucks, sTable_ZTLines, nStr]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      SetLength(FBillLines, RecordCount);
      //init

      if RecordCount > 0 then
      begin
        nIdx := 0;
        First;

        while not Eof do
        begin
          with FBillLines[nIdx] do
          begin
            FBill    := FieldByName('T_Bill').AsString;
            FLine    := FieldByName('T_Line').AsString;
            FName    := FieldByName('T_Name').AsString;
            FPerW    := FieldByName('T_PeerWeight').AsInteger;
            FTotal   := FieldByName('T_Total').AsInteger;
            FNormal  := FieldByName('T_Normal').AsInteger;
            FBuCha   := FieldByName('T_BuCha').AsInteger;
            FHKBills := FieldByName('T_HKBills').AsString;
          end;

          Inc(nIdx);
          Next;
        end;
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      nInt := -1;
      for i:=Low(FBillLines) to High(FBillLines) do
       if (Pos(FID, FBillLines[i].FHKBills) > 0) and
          (FID <> FBillLines[i].FBill) then
       begin
          nInt := i;
          Break;
       end;
      //�Ͽ�,��������

      if nInt < 0 then Continue;
      //����װ����Ϣ

      with FBillLines[nInt] do
      begin
        if FPerW < 1 then Continue;
        //������Ч

        i := Trunc(FValue * 1000 / FPerW);
        //����

        nSQL := MakeSQLByStr([SF('L_LadeLine', FLine),
                SF('L_LineName', FName),
                SF('L_DaiTotal', i, sfVal),
                SF('L_DaiNormal', i, sfVal),
                SF('L_DaiBuCha', 0, sfVal)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL); //����װ����Ϣ

        FTotal := FTotal - i;
        FNormal := FNormal - i;
        //�ۼ��Ͽ�������װ����
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      nInt := -1;
      for i:=Low(FBillLines) to High(FBillLines) do
       if FID = FBillLines[i].FBill then
       begin
          nInt := i;
          Break;
       end;
      //�Ͽ�����

      if nInt < 0 then Continue;
      //����װ����Ϣ

      with FBillLines[nInt] do
      begin
        nSQL := MakeSQLByStr([SF('L_LadeLine', FLine),
                SF('L_LineName', FName),
                SF('L_DaiTotal', FTotal, sfVal),
                SF('L_DaiNormal', FNormal, sfVal),
                SF('L_DaiBuCha', FBuCha, sfVal)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL); //����װ����Ϣ
      end;
    end;

    nSQL := 'Delete From %s Where T_Bill In (%s)';
    nSQL := Format(nSQL, [sTable_ZTTrucks, nStr]);
    FListA.Add(nSQL); //����װ������

    {$IFDEF UseWebYYOrder}
    nSQL := ' Delete From %s Where W_WebOrderID In (select distinct L_WebOrderID from S_Bill where L_ID In(%s)) ';
    nSQL := Format(nSQL, [sTable_YYWebBill, nStr]);
    FListA.Add(nSQL); //����ԤԼ����Ϣ
    {$ENDIF}
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;

  //ʹ��ҵ��Ա����
  {$IFDEF UseSalesCredit}
  if FIn.FExtParam = sFlag_TruckBFM then
    TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
                 nBills[0].FZhiKa, '', @nOut);
  {$ENDIF}

  {$IFDEF PoundMAfterAutoOutFact} //�����о�ˮ�� ë�غ��Զ�����
  if Result then
  {$ENDIF}

  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    if Assigned(gHardShareData) then
      gHardShareData('TruckOut:'+nBills[0].FCard);
    //�����Զ�����
  end;

  {$IFDEF MicroMsg}
  nStr := '';
  for nIdx:=Low(nBills) to High(nBills) do
    nStr := nStr + nBills[nIdx].FID + ',';
  //xxxxx

  if FIn.FExtParam = sFlag_TruckOut then
  begin
    with FListA do
    begin
      Clear;
      Values['bill'] := nStr;
      Values['company'] := gSysParam.FHintText;
    end;

    gWXPlatFormHelper.WXSendMsg(cWXBus_OutFact, FListA.Text);
  end;
  {$ENDIF}

  {$IFDEF SaveCusMoneyByOutFact}
  if FIn.FExtParam = sFlag_TruckOut then //����
  begin
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      if TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoneyEx,
                FZhiKa, '', @nOut) then
      begin
        WriteLog('�ͻ�ʣ���ʽ�'+nOut.FData);
        nSQL := MakeSQLByStr([
                SF('L_NowValidMoney', nOut.FData)
                ], sTable_Bill, SF('L_ID', FID), False);
        gDBConnManager.WorkerExec(FDBConn, nSQL);
      end;
    end;
  end;
  {$ENDIF}
end;

//Date: 2019-03-17
//Desc: ��ȡ���Ͽ�λ
function TWorkerBusinessBills.GetStockKuWei(const nStockNo: string): string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_StockKuWei, nStockNo]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
  end;
end;

function TWorkerBusinessBills.GetCusType(const nCusID: string): string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select C_Type From %s Where C_ID=''%s''';
  nStr := Format(nStr, [sTable_Customer, nCusID]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
  end;
end;

//�ϰ���Ƥ��ʱ�����¼��ֽ���۸�
function TWorkerBusinessBills.ZhiKaPriceChk(var nData: string): Boolean;
var nStr, nFixZhiKa,nCID : string;
    nIdx : Integer;
    nOut : TWorkerBusinessCommand;
    nOldMoney,nNewMoney, nVal, nZhiKaMoney:Double;
    nListB : TStrings;
begin
  Result:= False;
  nFixZhiKa:= 'N';  nListB:= TStringList.Create;
  FListA.Text := PackerDecodeStr(FIn.FData);
  try
    nStr := 'Select L_ID,L_CusID,L_StockNo,L_StockName,L_Price,L_Value,Z_FixedMoney,Z_OnlyMoney,D_Price, '+
                   'L_Value*L_Price OLDMoney, L_Value*D_Price NewMoney  From %s  '+
            'Left Join %s On L_ZhiKa=Z_ID  '+
            'Left Join %s On Z_ID=D_ZID  '+
            'Where L_ID=''%s'' And D_StockNo=''%s'' ';
    nStr := Format(nStr, [sTable_Bill, sTable_ZhiKa, sTable_ZhiKaDtl, FListA.Values['LID'], FListA.Values['MID']]);
    //xxxxx
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount > 0 then
      begin
        nFixZhiKa:= FieldByName('Z_OnlyMoney').AsString;
        nCID     := FieldByName('L_CusID').AsString;
        //
        if FieldByName('L_Price').Asfloat=FieldByName('D_Price').Asfloat then
        begin
          WriteLog(FListA.Values['LID']+' �������뵱ǰ��һ�¡�У��ͨ��');
          Result:= True;
          Exit;
        end;

        //*********************************
        nOldMoney:= FieldByName('OLDMoney').Asfloat;
        nNewMoney:= FieldByName('NewMoney').Asfloat;
        nVal := nOldMoney-nNewMoney;
        if nVal>=0 then
        begin
          Result:= True;
        end
        else
        begin
          if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
                    FListA.Values['ZhiKa'], '', @nOut) then
          begin
            nData := nOut.FData;
            WriteLog('��ȡֽ�����ʧ�ܣ�'+nData);
            Exit;
          end;

          nZhiKaMoney := StrToFloat(nOut.FData);
          if FloatRelation(Abs(nVal), nZhiKaMoney, rtGreater) then
          begin
            nData := 'ֽ��[ %s ]��û���㹻�Ľ��,��������:' + #13#10#13#10 +
                     '�貹����: %.2f' + #13#10 +
                     '��ɾ�����������С��������ٿ���.';
            nData := Format(nData, [FListA.Values['ZhiKa'], Abs(nVal)]);
            Exit;
          end;

          Result:= True;
        end;

        if Result then
        begin
          //**********************************************************************
          //**********************************************************************
          nStr:= 'UPDate S_Bill Set L_Price=%g Where L_ID=''%s''';
          nStr:= Format(nStr, [FieldByName('D_Price').Asfloat, FListA.Values['LID']]);
          nListB.Add(nStr);
          // ���¶�������

          if nFixZhiKa='Y' then
          begin
            nStr:= 'UPDate S_ZhiKa Set Z_FixedMoney=Z_FixedMoney+(%g) Where Z_ID=''%s''';
            nStr:= Format(nStr, [nVal, FListA.Values['ZhiKa']]);
            nListB.Add(nStr);
            // ����ֽ�����
          end;

          nStr:= 'UPDate Sys_CustomerAccount Set A_FreezeMoney=A_FreezeMoney-(%g) Where A_CID=''%s''';
          nStr:= Format(nStr, [nVal, nCID]);
          nListB.Add(nStr);
          // ���¶����
        end;

        //----------------------------------------------------------------------------
        FDBConn.FConn.BeginTrans;
        try
          for nIdx:=0 to nListB.Count - 1 do
            gDBConnManager.WorkerExec(FDBConn, nListB[nIdx]);
          //xxxxx

          FDBConn.FConn.CommitTrans;
          Result := True;
        except
          FDBConn.FConn.RollbackTrans;
          raise;
        end;
      end
      else nData:= FListA.Values['LID'] + ' �۸�У��ʧ�ܡ������¿���';
    end;
  finally
    FreeAndNil(nListB);
  end;
end;


initialization
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessBills, sPlug_ModuleBus);

  
end.
