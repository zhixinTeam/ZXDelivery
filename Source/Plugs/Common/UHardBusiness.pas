{*******************************************************************************
  ����: dmzn@163.com 2012-4-22
  ����: Ӳ������ҵ��
*******************************************************************************}
unit UHardBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, SysUtils, UMgrDBConn, UMgrParam, DB, UMITConst,
  UBusinessWorker, UBusinessConst, UBusinessPacker, UMgrQueue, DateUtils, UFormCtrl,
  {$IFDEF MultiReplay}UMultiJS_Reply, {$ELSE}UMultiJS, {$ENDIF}

  {$IFDEF UseModbusJS}UMultiModBus_JS, {$ENDIF}
  {$IFDEF UseLBCModbus}UMgrLBCModusTcp, {$ENDIF}
  UMgrHardHelper, U02NReader, UMgrERelay, UMgrRemotePrint, UMgrBXFontCard,
  UMgrRemoteSnap, UMgrBasisWeight,UMgrPoundTunnels,UMgrVoiceNet,UMgrTruckProbe,
  UMgrLEDDisp, UMgrRFID102, UBlueReader, UMgrTTCEM100, UMgrSendCardNo, UMgrERelayPLC;
  UMgrRemoteSnap, UMgrVoiceNet, IDGlobal,
  UMgrLEDDisp, UMgrRFID102, UBlueReader, UMgrTTCEM100, UMgrSendCardNo,
  UMgrBasisWeight, UMgrPoundTunnels, UMgrTruckProbe;

procedure ShowTextByBXFontCard(nCard, nTitle, nData:string);
procedure WhenReaderCardArrived(const nReader: THHReaderItem);
procedure WhenHYReaderCardArrived(const nReader: PHYReaderItem);
procedure WhenBlueReaderCardArrived(nHost: TBlueReaderHost; nCard: TBlueReaderCard);
//���¿��ŵ����ͷ
procedure WhenTTCE_M100_ReadCard(const nItem: PM100ReaderItem);
//Ʊ�������
procedure WhenReaderCardIn(const nCard: string; const nHost: PReaderHost);
//�ֳ���ͷ���¿���
procedure WhenReaderCardOut(const nCard: string; const nHost: PReaderHost);
//�ֳ���ͷ���ų�ʱ
procedure WhenBusinessMITSharedDataIn(const nData: string);
//ҵ���м����������
function GetJSTruck(const nTruck,nBill: string): string;
//��ȡ��������ʾ����
procedure WhenSaveJS(const nTunnel: PMultiJSTunnel);
//����������
{$IFDEF UseModbusJS}
procedure WhenSaveJSEx(const nTunnel: PJSTunnel);
//modus����������
{$ENDIF}
procedure SaveGrabCard(const nCard: string; nTunnel: string; nDelete: Boolean);
//����ץ����ˢ����Ϣ
{$IFDEF UseLBCModbus}
procedure WhenLBCWeightStatusChange(const nTunnel: PLBTunnel);
//����Ӷ���װ��״̬�ı�
{$ENDIF}
procedure WhenBasisWeightStatusChange(const nTunnel: PBWTunnel);
//����װ��״̬�ı�

procedure SetInFactTimeOut(nTime:Integer);

procedure AutoTruckOutFact(const nCard : string);
//�Զ�����implementation

implementation

uses
  ULibFun, USysDB, USysLoger, UTaskMonitor,UWorkerBusiness;

const
  sPost_In   = 'in';
  sPost_Out  = 'out';
  sPost_ZT   = 'zt';
  sPost_FH   = 'fh';

  sBlueCard  = 'bluecard';
  sHyCard    = 'hycard';

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
function CallBusinessCommand(const nCmd: Integer;
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
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessCommand);
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

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessSaleBill(const nCmd: Integer;
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
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessSaleBill);
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

//Date: 2015-08-06
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessPurchaseOrder(const nCmd: Integer;
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
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessPurchaseOrder);
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

//Date: 2017-09-22
//Parm: ����;����;����;���
//Desc: �����м���ϵĶ̵����ݶ���
function CallBusinessDuanDao(const nCmd: Integer;
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
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessDuanDao);
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

//Date: 2014-10-16
//Parm: ����;����;����;���
//Desc: ����Ӳ���ػ��ϵ�ҵ�����
function CallHardwareCommand(const nCmd: Integer;
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
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_HardwareCommand);
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

//Date: 2012-3-23
//Parm: �ſ���;��λ;�������б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ľ������б�
function GetLadingBills(const nCard,nPost: string;
 var nData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
       AnalyseBillItems(nOut.FData, nData)
  else gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
end;

//Date: 2014-09-18
//Parm: ��λ;�������б�
//Desc: ����nPost��λ�ϵĽ���������
function SaveLadingBills(const nPost: string; nData: TLadingBillItems): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessSaleBill(cBC_SavePostBills, nStr, nPost, @nOut);

  if not Result then
    gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
  //xxxxx
end;

//Date: 2015-08-06
//Parm: �ſ���
//Desc: ��ȡ�ſ�ʹ������
function GetCardUsed(const nCard: string; var nCardType: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetCardUsed, nCard, '', @nOut);

  if Result then
       nCardType := nOut.FData
  else gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
  //xxxxx
end;

function VeryTruckLicense(const nTruck, nBill: string; var nMsg: string): Boolean;
var
  nList: TStrings;
  nOut: TWorkerBusinessCommand;
  nID : string;
begin
  if nBill = '' then
    nID := nTruck + FormatDateTime('YYMMDD',Now)
  else
    nID := nBill;

  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Truck'] := nTruck;
    nList.Values['Bill'] := nID;

    Result := CallBusinessCommand(cBC_VeryTruckLicense, nList.Text, '', @nOut);
    nMsg := nOut.FData
  finally
    nList.Free;
  end;
end;

//Date: 2015-08-06
//Parm: �ſ���;��λ;�ɹ����б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ľ������б�
function GetLadingOrders(const nCard,nPost: string;
 var nData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_GetPostOrders, nCard, nPost, @nOut);
  if Result then
       AnalyseBillItems(nOut.FData, nData)
  else gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
end;

//Date: 2019-4-25
//Parm: �������;װ����ID;���ϱ���
//Desc: ����������λ
function SaveStockKuWei(const nID,nLineID,nStockNo: string): Boolean;
var nOut: TWorkerBusinessCommand;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Values['ID']      := nID;
    nList.Values['LineID']  := nLineID;
    nList.Values['StockNo'] := nStockNo;
    Result := CallBusinessCommand(cBC_SaveStockKuWei, nList.Text, '', @nOut);
  finally
    nList.Free;
  end;
end;

//Date: 2015-08-06
//Parm: ��λ;�ɹ����б�
//Desc: ����nPost��λ�ϵĲɹ�������
function SaveLadingOrders(const nPost: string; nData: TLadingBillItems): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessPurchaseOrder(cBC_SavePostOrders, nStr, nPost, @nOut);

  if not Result then
    gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
  //xxxxx
end;

//Date: 2017-10-24
//Parm: �ſ���;��λ;�̵����б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ķ̵����б�
function GetDuanDaoItems(const nCard,nPost: string;
 var nData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessDuanDao(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
       AnalyseBillItems(nOut.FData, nData)
  else gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
end;

//Date: 2017-10-24
//Parm: ��λ;�̵����б�
//Desc: ����nPost��λ�ϵĶ̵�������
function SaveDuanDaoItems(const nPost: string; nData: TLadingBillItems): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessDuanDao(cBC_SavePostBills, nStr, nPost, @nOut);

  if not Result then
    gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Date: 2013-07-21
//Parm: �¼�����;��λ��ʶ
//Desc:
procedure WriteHardHelperLog(const nEvent: string; nPost: string = '');
begin
  gDisplayManager.Display(nPost, nEvent);
  gSysLoger.AddLog(THardwareHelper, 'Ӳ���ػ�����', nEvent);
end;

procedure BlueOpenDoor(const nReader: string;const nReaderType: string = '');
var nIdx: Integer;
begin
  nIdx := 0;
  if Copy(nReader,0,1)='V' then Exit;
  
  if nReader <> '' then
  while nIdx < 5 do
  begin
    if nReaderType = sBlueCard then
    begin
      gHardwareHelper.OpenDoor(nReader);
      WriteHardHelperLog('����������̧��:' + nReader);
    end
    else
    if nReaderType = sHyCard then
    begin
      gHYReaderManager.OpenDoor(nReader);
      WriteHardHelperLog('���������̧��:' + nReader);
    end
    else
    begin
      if gHardwareHelper.ConnHelper then
           gHardwareHelper.OpenDoor(nReader)
      {$IFDEF BlueCard}
      else gHYReaderManager.OpenDoor(nReader);
      {$ELSE}
      else gHYReaderManager.OpenDoor(nReader);
      {$ENDIF}
    end;

    Inc(nIdx);
  end;
end;

//Date: 2012-4-22
//Parm: ����
//Desc: ����ˢ�������־
procedure GetTruckInfo(const nCard,nReader: string);
var nStr,nTruck,nCardType: string;
    nTrucks: TLadingBillItems;
    nRet: Boolean;
    nMsg: string;
begin
  nCardType := '';
  if not GetCardUsed(nCard, nCardType) then Exit;

  if nCardType = sFlag_Provide then
    nRet := GetLadingOrders(nCard, sFlag_TruckIn, nTrucks) else
  if nCardType = sFlag_Sale then
    nRet := GetLadingBills(nCard, sFlag_TruckIn, nTrucks) else
  if nCardType = sFlag_DuanDao then
    nRet := GetDuanDaoItems(nCard, sFlag_TruckIn, nTrucks) else nRet := False;

  if not nRet then
  begin
    nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, 'ˢ��');
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û�ж�Ӧ����.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, 'ˢ��');
    Exit;
  end;

  nStr := '������:[ %s ]�ſ�:[ %s ]����:[ %s ]����:[ %s ]';
  nStr := Format(nStr, [nReader,nCard,nTrucks[0].FTruck,nTrucks[0].FID]);
  WriteHardHelperLog(nStr, sPost_In);
end;

//Date: 2017-10-16
//Parm: ����;��λ;ҵ��ɹ�
//Desc: ����HKLED С����ʾ
procedure MakeGateHKLEDDisplay(const nText,nPost: string; const nSucc: Boolean);
var nStr: string;
    nInt: Integer;
begin
  try
    if nSucc then
         nInt := 2
    else nInt := 3;

    gHKSnapHelper.Display(nPost, nText, nInt);
    //С����ʾ
    WriteHardHelperLog('���ͺ��� '+nPost+' С����' + nText);
  except
    on nErr: Exception do
    begin
      nStr := '���ͺ���С��[ %s ]��ʾʧ��,����: %s';
      nStr := Format(nStr, [nPost, nErr.Message]);
      WriteHardHelperLog(nStr);
    end;
  end;
end;

//Date: 2012-4-22
//Parm: ����
//Desc: ��nCard���н���
procedure MakeTruckIn(const nCard,nReader: string; const nDB: PDBWorker;
                      const nReaderType: string = '');
var nStr,nTruck,nCardType: string;
    nIdx,nInt: Integer;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
    nRet: Boolean;
    nMsg: string;
begin
  if gTruckQueueManager.IsTruckAutoIn and (GetTickCount -
     gHardwareHelper.GetCardLastDone(nCard, nReader) < 2 * 60 * 1000) then
  begin
    gHardwareHelper.SetReaderCard(nReader, nCard);
    Exit;
  end; //ͬ��ͷͬ��,��2�����ڲ������ν���ҵ��.

  nCardType := '';
  if not GetCardUsed(nCard, nCardType) then Exit;

  if nCardType = sFlag_Provide then
    nRet := GetLadingOrders(nCard, sFlag_TruckIn, nTrucks) else
  if nCardType = sFlag_Sale then
    nRet := GetLadingBills(nCard, sFlag_TruckIn, nTrucks) else
  if nCardType = sFlag_DuanDao then
    nRet := GetDuanDaoItems(nCard, sFlag_TruckIn, nTrucks) else nRet := False;

  if not nRet then
  begin
    nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_In);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫ��������.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_In);
    Exit;
  end;
  
  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if gTruckQueueManager.IsFobiddenInMul then//��ֹ��ν���
    begin
      if FStatus = sFlag_TruckNone then Continue;
      //δ����
    end
    else
    begin
      if (FStatus = sFlag_TruckNone) or (FStatus = sFlag_TruckIn) then Continue;
      //δ����,���ѽ���
    end;

    nStr := '����[ %s ]��һ״̬Ϊ:[ %s ],����ˢ����Ч.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);

    WriteHardHelperLog(nStr, sPost_In);
    Exit;
  end;

  {$IFDEF UseEnableStruck}
  if nTrucks[0].FStatus = sFlag_TruckNone then
  if not VeryTruckLicense(nTrucks[0].FTruck,nTrucks[0].FID, nMsg) then
  begin
    WriteHardHelperLog(nMsg, sPost_In);
    Exit;
  end;
  nStr := nMsg + ',�����';
  WriteHardHelperLog(nMsg, sPost_In);
  {$ENDIF}

  if nTrucks[0].FStatus = sFlag_TruckIn then
  begin
    if gTruckQueueManager.IsTruckAutoIn then
    begin
      gHardwareHelper.SetCardLastDone(nCard, nReader);
      gHardwareHelper.SetReaderCard(nReader, nCard);
      {$IFDEF HYJC}
      if (nReader = 'HY192168000044') or (nReader = 'HY192168000048')then
        BlueOpenDoor(nReader, nReaderType);
        //̧��
      {$ENDIF}
    end else
    begin
      if gTruckQueueManager.TruckReInfactFobidden(nTrucks[0].FTruck) then
      begin
        BlueOpenDoor(nReader, nReaderType);
        //̧��

        nStr := '����[ %s ]�ٴ�̧�˲���.';
        nStr := Format(nStr, [nTrucks[0].FTruck]);
        WriteHardHelperLog(nStr, sPost_In);
      end;
    end;

    if nCardType = sFlag_DuanDao then
    begin
      nStr := '%s����';
      nStr := Format(nStr, [nTrucks[0].FTruck]);
      WriteHardHelperLog(nStr, sPost_In);
      gDisplayManager.Display(nReader, nStr);
    end;
    Exit;
  end;

  if nCardType <> sFlag_Sale then
  begin
    if nCardType = sFlag_Provide then
      nRet := SaveLadingOrders(sFlag_TruckIn, nTrucks) else
    if nCardType = sFlag_DuanDao then
      nRet := SaveDuanDaoItems(sFlag_TruckIn, nTrucks) else nRet := False;
    //xxxxx

    //if not SaveLadingOrders(sFlag_TruckIn, nTrucks) then
    if not nRet then
    begin
      nStr := '����[ %s ]��������ʧ��.';
      nStr := Format(nStr, [nTrucks[0].FTruck]);

      WriteHardHelperLog(nStr, sPost_In);
      Exit;
    end;

    if gTruckQueueManager.IsTruckAutoIn then
    begin
      gHardwareHelper.SetCardLastDone(nCard, nReader);
      gHardwareHelper.SetReaderCard(nReader, nCard);
    end else
    begin
      BlueOpenDoor(nReader,nReaderType);
      //̧��
    end;

//    nStr := 'ԭ���Ͽ�[%s]����̧�˳ɹ�';
//    nStr := Format(nStr, [nCard]);
//    WriteHardHelperLog(nStr, sPost_In);

    nStr := '%s�ſ�[%s]����̧�˳ɹ�';
    nStr := Format(nStr, [BusinessToStr(nCardType), nCard]);
    WriteHardHelperLog(nStr, sPost_In);

    if nCardType = sFlag_DuanDao then
    begin
      nStr := '%s����';
      nStr := Format(nStr, [nTrucks[0].FTruck]);
      WriteHardHelperLog(nStr, sPost_In);
      gDisplayManager.Display(nReader, nStr);
    end;
    Exit;
  end;
  //�ɹ��ſ�ֱ��̧��

  nPLine := nil;
  //nPTruck := nil;

  with gTruckQueueManager do
  if not IsDelayQueue then //����ʱ����(����ģʽ)
  try
    SyncLock.Enter;
    nStr := nTrucks[0].FTruck;

    for nIdx:=Lines.Count - 1 downto 0 do
    begin
      nInt := TruckInLine(nStr, PLineItem(Lines[nIdx]).FTrucks);
      if nInt >= 0 then
      begin
        nPLine := Lines[nIdx];
        //nPTruck := nPLine.FTrucks[nInt];
        Break;
      end;
    end;

    if not Assigned(nPLine) then
    begin
      nStr := '����[ %s ]û���ڵ��ȶ�����.';
      nStr := Format(nStr, [nTrucks[0].FTruck]);

      WriteHardHelperLog(nStr, sPost_In);
      Exit;
    end;
  finally
    SyncLock.Leave;
  end;

  if not SaveLadingBills(sFlag_TruckIn, nTrucks) then
  begin
    nStr := '����[ %s ]��������ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteHardHelperLog(nStr, sPost_In);
    Exit;
  end;

  if gTruckQueueManager.IsTruckAutoIn then
  begin
    gHardwareHelper.SetCardLastDone(nCard, nReader);
    gHardwareHelper.SetReaderCard(nReader, nCard);
  end else
  begin
    BlueOpenDoor(nReader, nReaderType);
    //̧��
  end;

  with gTruckQueueManager do
  if not IsDelayQueue then //����ģʽ,����ʱ�󶨵���(һ���൥)
  try
    SyncLock.Enter;
    nTruck := nTrucks[0].FTruck;

    for nIdx:=Lines.Count - 1 downto 0 do
    begin
      nPLine := Lines[nIdx];
      nInt := TruckInLine(nTruck, PLineItem(Lines[nIdx]).FTrucks);

      if nInt < 0 then Continue;
      nPTruck := nPLine.FTrucks[nInt];
      {$IFDEF ChkPeerWeight}
      nStr := 'Update %s Set T_Line=''%s'' Where T_Bill=''%s''';
      nStr := Format(nStr, [sTable_ZTTrucks, nPLine.FLineID,nPTruck.FBill]);
      {$ELSE}
      nStr := 'Update %s Set T_Line=''%s'',T_PeerWeight=%d Where T_Bill=''%s''';
      nStr := Format(nStr, [sTable_ZTTrucks, nPLine.FLineID, nPLine.FPeerWeight,
              nPTruck.FBill]);
      {$ENDIF}
      //xxxxx

      gDBConnManager.WorkerExec(nDB, nStr);
      //��ͨ��
    end;
  finally
    SyncLock.Leave;
  end;
end;


//Date: 2012-4-22
//Parm: ����;��ͷ;��ӡ��;���鵥��ӡ��
//Desc: ��nCard���г���
function MakeTruckOut(const nCard,nReader,nPrinter: string;
 const nHYPrinter: string = '';const nReaderType: string = ''; nBxCardNo: string = ''): Boolean;
var nStr,nCardType: string;
    nIdx: Integer;
    nRet: Boolean;
    nTrucks: TLadingBillItems;
    {$IFDEF PrintBillMoney}
    nOut: TWorkerBusinessCommand;
    {$ENDIF}
begin
  Result := False;
  nCardType := '';
  WriteHardHelperLog('MakeTruckOut ����, ��ӡ��:'+nPrinter+'��'+nHYPrinter+' ��������'+nReader+' ����:'+nCard);
  if not GetCardUsed(nCard, nCardType) then Exit;

  if nCardType = sFlag_Provide then
    nRet := GetLadingOrders(nCard, sFlag_TruckOut, nTrucks) else
  if nCardType = sFlag_Sale then
    nRet := GetLadingBills(nCard, sFlag_TruckOut, nTrucks) else
  if nCardType = sFlag_DuanDao then
    nRet := GetDuanDaoItems(nCard, sFlag_TruckOut, nTrucks) else nRet := False;

  if not nRet then
  begin
    nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_Out);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫ��������.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_Out);
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    {$IFDEF HXXG}
    if (FMData.FValue > gSysParam.FMValueLimit) and (nCardType <> sFlag_Provide)  then
    begin
      nStr := '����[ %s ]ë��ֵ:[ %s ],�޷�����.';
      nStr := Format(nStr, [FTruck, Floattostr(FMData.FValue)]);

      WriteHardHelperLog(nStr, sPost_Out);
      Exit;
    end;
    {$ENDIF}
    if FNextStatus = sFlag_TruckOut then Continue;
    nStr := '����[ %s ]��һ״̬Ϊ:[ %s ],�޷�����.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);

    WriteHardHelperLog(nStr, sPost_Out);
    Exit;
  end;

  if nCardType = sFlag_Provide then
    nRet := SaveLadingOrders(sFlag_TruckOut, nTrucks) else
  if nCardType = sFlag_Sale then
    nRet := SaveLadingBills(sFlag_TruckOut, nTrucks) else
  if nCardType = sFlag_DuanDao then
    nRet := SaveDuanDaoItems(sFlag_TruckOut, nTrucks);

  if not nRet then
  begin
    nStr := '����[ %s ]��������ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteHardHelperLog(nStr, sPost_Out);
    Exit;
  end;

  if (nReader <> '') then
    BlueOpenDoor(nReader, nReaderType); //̧��
  Result := True;

  {$IFDEF JZZJ}
  nBxCardNo:= 'EastOut';
  if nReader = 'VY192168026045' then nBxCardNo:= 'WestOut';
  {$ENDIF}
  {$IFDEF UseBXFontLED}
  nStr := '\C3%s \C1�����,ף��һ·˳��,��ӭ���ٴι���.';
  nStr := Format(nStr, [nTrucks[0].FTruck]);
  ShowTextByBXFontCard(nBxCardNo, '', nStr);
  {$ENDIF}

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  begin
    {$IFDEF PrintBillMoney}
    if CallBusinessCommand(cBC_GetZhiKaMoney,nTrucks[nIdx].FZhiKa,'',@nOut) then
         nStr := #8 + nOut.FData
    else nStr := #8 + '0';
    {$ELSE}
    nStr := '';
    {$ENDIF}

    nStr := nStr + #7 + nCardType;
    //�ſ�����
    if nHYPrinter <> '' then
      nStr := nStr + #6 + nHYPrinter;
    //���鵥��ӡ��
    {$IFNDEF UseOrderNoPrint}
    if nPrinter = '' then
         gRemotePrinter.PrintBill(nTrucks[nIdx].FID + nStr)
    else gRemotePrinter.PrintBill(nTrucks[nIdx].FID + #9 + nPrinter + nStr);
    {$ELSE}
    if nCardType = sFlag_Sale then
    begin
      if nPrinter = '' then
           gRemotePrinter.PrintBill(nTrucks[nIdx].FID + nStr)
      else gRemotePrinter.PrintBill(nTrucks[nIdx].FID + #9 + nPrinter + nStr);
    end;
    {$ENDIF}
  end; //��ӡ����
end;

//Date: 2017-10-16
//Parm: ����;���ڵ�;��λ
//Desc: ����װ������
procedure MakeLadingSound(const nTruck: PTruckItem; const nLine: PLineItem;
  const nPost: string; const nTunnel:string);
var nStr, nZID, nNextTruck : string;
    nIdx: Integer;
    nNext, nTem: PTruckItem;
    nlast : Boolean;
    nList : TStrings;
begin
  try
    nlast:= False;
    nIdx := nLine.FTrucks.IndexOf(nTruck);
    if (nIdx < 0) or (nIdx = nLine.FTrucks.Count - 1) then
    begin
      nlast:= True;
    end;
    //no exits or last

    nNextTruck:= '';
    IF not nlast then
    begin
      nNext := nLine.FTrucks[nIdx+1];
      nNextTruck:= nNext.FTruck;
      //next truck

      nStr := '����[p500]%s��ʼװ��,��%s������ %s ׼��';
      nStr := Format(nStr, [nTruck.FTruck, nNext.FTruck, nLine.FName]);
      gNetVoiceHelper.PlayVoice(nStr, nPost);
      
      nStr := '%s ��ʼװ��,�� %s ׼��';
      nStr := Format(nStr, [nTruck.FTruck, nNext.FTruck]);
      gDisplayManager.Display(nTunnel, nStr);

      {$IFDEF UseBXFontLED}
//      if nPost=sPost_ZT then
//      begin
//        nZID:= nTunnel;
//        GetZTLineInfo(nZID);  WriteNearReaderLog('��ȡ����ջ̨���ƣ�'+nZID);
//
//        nStr := '��װ%s��װ%s';
//        {$IFDEF LEDLong}
//        nStr := ' %s װ���� %s ��׼��';
//        {$ENDIF}
//        nStr := Format(nStr, [nTruck.FTruck, nNext.FTruck]);
//        ShowTextByBXFontCard(nTunnel, nZID, nStr, True);
//      end;
      {$ENDIF}
    end
    else
    begin
      {$IFDEF UseBXFontLED}
//      if nPost=sPost_ZT then
//      begin
//        nZID:= nTunnel;
//        GetZTLineInfo(nZID);  WriteNearReaderLog('��ȡ����ջ̨���ƣ�'+nZID);
//
//        nStr := '��װ%s���޺�������';
//        {$IFDEF LEDLong}
//        nStr := ' %s װ���� ���޺�������';
//        {$ENDIF}
//        nStr := Format(nStr, [nTruck.FTruck]);
//
//        if nZID='ZT005' then nStr:= StringReplace(nStr, ' ', '', [rfReplaceAll]);
//
//        ShowTextByBXFontCard(nTunnel, nZID, nStr, True);
//      end;
      {$ENDIF}
    end;

    {$IFDEF UseBXFontLED}
//    try
//      nList := TStringList.Create;
//      with nList do
//      begin
//        Values['ZID']       := nTunnel;
//        Values['Truck']     := nTruck.FTruck;
//        Values['NextTruck'] := nNextTruck;
//      end;
//
//      SaveLineTrucks(PackerEncodeStr(nList.Text));
//    finally
//      nList.Free;
//    end;
    {$ENDIF}

    WriteHardHelperLog(nStr);
    //log content
  except
    on nErr: Exception do
    begin
      nStr := '����[ %s ]����ʧ��,����: %s';
      nStr := Format(nStr, [nPost, nErr.Message]);
      WriteHardHelperLog(nStr);
    end;
  end;
end;

//Date: 2012-10-19
//Parm: ����;��ͷ
//Desc: ��⳵���Ƿ��ڶ�����,�����Ƿ�̧��
procedure MakeTruckPassGate(const nCard,nReader: string; const nDB: PDBWorker;
                            const nReaderType: string = '');
var nStr: string;
    nIdx: Integer;
    nTrucks: TLadingBillItems;
begin
  if not GetLadingBills(nCard, sFlag_TruckOut, nTrucks) then
  begin
    nStr := '��ȡ�ſ�[ %s ]��������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫͨ����բ�ĳ���.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  if gTruckQueueManager.TruckInQueue(nTrucks[0].FTruck) < 0 then
  begin
    nStr := '����[ %s ]���ڶ���,��ֹͨ����բ.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  BlueOpenDoor(nReader, nReaderType);
  //̧��

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  begin
    nStr := 'Update %s Set T_InLade=%s Where T_Bill=''%s'' And T_InLade Is Null';
    nStr := Format(nStr, [sTable_ZTTrucks, sField_SQLServer_Now, nTrucks[nIdx].FID]);

    gDBConnManager.WorkerExec(nDB, nStr);
    //�������ʱ��,�������򽫲��ٽк�.
  end;
end;

//Date: 2019-10-26
//Parm: ����;��ͷ
//Desc: ̧��ͬʱ���ɹ�բ��¼
procedure MakeTruckPassGateEx(const nCard,nReader,nSaveData: string; const nDB: PDBWorker;
                            const nReaderType: string = '');
var nStr: string;
    nWait: Integer;
    nTruck: string;
    nLastTime: TDateTime;
    nCanSave: Boolean;
begin
  nCanSave := False;
  nWait := 30;

  nStr := 'select C_TruckNo,C_LastDate from %s where C_Card=''%s'' and C_Used=''%s''';
  nStr := Format(nStr,[sTable_Card, nCard, sFlag_Tx]);
  with gDBConnManager.WorkerQuery(nDB, nStr) do
  begin
    if RecordCount <= 0 then
    begin
      nStr := '��ȡͨ�п�[ %s ]��Ϣʧ��.';
      nStr := Format(nStr, [nCard]);

      WriteHardHelperLog(nStr);
      Exit;
    end;
    nTruck := Fields[0].AsString;
    nLastTime := Fields[1].AsDateTime;
  end;

  nStr := 'select D_Value from %s where D_Name=''%s''';
  nStr := Format(nStr,[sTable_SysDict, sFlag_CrossWaitTime]);
  with gDBConnManager.WorkerQuery(nDB, nStr) do
  begin
    if RecordCount > 0 then
    begin
      nWait := Fields[0].AsInteger;
    end;
  end;

  if MinutesBetween(Now,nLastTime) >= nWait then
    nCanSave := True;

  if not nCanSave then
  begin
    nStr := 'ͨ�п�[ %s ]����[ %s ]�ڶ�����[ %s ]����ͨ��,�ϴ�ͨ��ʱ��Ϊ[ %s ],�ȴ����Ϊ[ %d ]��.';
    nStr := Format(nStr, [nCard, nTruck, nReader, DateTime2Str(nLastTime), nWait]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  nStr := Format('C_Card=''%s''', [nCard]);
  nStr := MakeSQLByStr([
          SF('C_LastDate', sField_SQLServer_Now, sfVal)
          ], sTable_Card, nStr, False);
  gDBConnManager.WorkerExec(nDB, nStr);

  nStr := 'ͨ�п�[ %s ]����[ %s ]�ڶ�����[ %s ]ͨ��,ͨ��ʱ��Ϊ[ %s ].';
  nStr := Format(nStr, [nCard, nTruck, nReader, DateTime2Str(Now)]);
  WriteHardHelperLog(nStr);

  if nSaveData <> sFlag_Yes then
  begin
    BlueOpenDoor(nReader, nReaderType);
    //̧��
    Exit;
  end;

  nStr := MakeSQLByStr([SF('C_Card', nCard),
          SF('C_Truck', nTruck),
          SF('C_Reader', nReader),
          SF('C_Date', sField_SQLServer_Now, sfVal)
          ], sTable_TruckCross, '', True);
  gDBConnManager.WorkerExec(nDB, nStr);

  BlueOpenDoor(nReader, nReaderType);
  //̧��
end;

//------------------------------------------------------------------------------
procedure WriteNearReaderLog(const nEvent: string);
begin
  gSysLoger.AddLog(T02NReader, '�ֳ����������', nEvent);
end;

//Date: 2019-03-12
//Parm: ͨ����;��ʾ��Ϣ;���ƺ�
//Desc: ��nTunnel��С������ʾ��Ϣ
procedure ShowLEDHintPLC(const nTunnel: string; nHint: string;
  const nTruck: string = '';const nUnPLC:string = '');
begin
  if nTruck <> '' then
    nHint := nTruck + StringOfChar(' ', 12 - Length(nTruck)) + nHint;
  //xxxxx
  if Length(nHint) > 24 then
    nHint := Copy(nHint, 1, 24)
  else if Length(nHint) < 24 then
  begin
    nHint := nHint + StringOfChar(' ', 24 - Length(nHint));
  end;

  gERelayManagerPLC.ShowText(nTunnel, nHint);
  WriteNearReaderLog(Format('���� gERelayManagerPLC ͨ�� %s С����ʾ��%s.', [nTunnel, nHint]));
end;

//Date: 2019-03-12
//Parm: ͨ����;��ʾ��Ϣ;���ƺ�
//Desc: ��nTunnel��С������ʾ��Ϣ
procedure ShowLEDHint(const nTunnel: string; nHint: string;
  const nTruck: string = ''; const nPlayVoice: Boolean =True);
var nStr: string;
begin
  if nPlayVoice then
  begin
    nStr := nHint;
    gNetVoiceHelper.PlayVoice(nStr, nTunnel);
  end;
  if nTruck <> '' then
    nHint := nTruck + StringOfChar(' ', 12 - Length(nTruck)) + nHint;
  //xxxxx
  
  if Length(nHint) > 24 then
    nHint := Copy(nHint, 1, 24);
  gERelayManager.ShowTxt(nTunnel, nHint);
end;

//Date: 2013-07-17
//Parm: ��������
//Desc: �ж�ͨ���Ƿ���
function IsTunnelOpen(const nTunnel: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBConn: PDBWorker;
begin
  Result := False;
  //init

  nDBConn := nil;
  with gParamManager.ActiveParam^ do
  try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
    if not Assigned(nDBConn) then
    begin
      WriteNearReaderLog('����HM���ݿ�ʧ��(DBConn Is Null).');
      Exit;
    end;

    if not nDBConn.FConn.Connected then
      nDBConn.FConn.Connected := True;
    //conn db

    nStr := ' Select Z_ID From %s Where Z_ID = ''%s'' And Z_Valid = ''%s'' ' ;
    nStr := Format(nStr, [sTable_ZTLines, nTunnel,sFlag_Yes]);

    with gDBConnManager.WorkerQuery(nDBConn, nStr) do
    if RecordCount > 0 then
         Result := True
    else Result := False;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
end;

//Date: 2012-4-24
//Parm: ����;ͨ��;�Ƿ����Ⱥ�˳��;��ʾ��Ϣ
//Desc: ���nTuck�Ƿ������nTunnelװ��
function IsTruckInQueue(const nTruck,nTunnel: string; const nQueued: Boolean;
 var nHint: string; var nPTruck: PTruckItem; var nPLine: PLineItem;
 const nStockType: string = ''): Boolean;
var i,nIdx,nInt: Integer;
    nLineItem: PLineItem;
begin
  with gTruckQueueManager do
  try
    Result := False;
    SyncLock.Enter;
    nIdx := GetLine(nTunnel);

    if nIdx < 0 then
    begin
      nHint := Format('ͨ��[ %s ]��Ч.', [nTunnel]);
      Exit;
    end;

    nPLine := Lines[nIdx];
    nIdx := TruckInLine(nTruck, nPLine.FTrucks);

    if (nIdx < 0) and (nStockType <> '') and (
       ((nStockType = sFlag_Dai) and IsDaiQueueClosed) or
       ((nStockType = sFlag_San) and IsSanQueueClosed)) then
    begin
      for i:=Lines.Count - 1 downto 0 do
      begin
        if Lines[i] = nPLine then Continue;
        nLineItem := Lines[i];
        nInt := TruckInLine(nTruck, nLineItem.FTrucks);

        if nInt < 0 then Continue;
        //���ڵ�ǰ����
        if not StockMatch(nPLine.FStockNo, nLineItem) then Continue;
        //ˢ��������е�Ʒ�ֲ�ƥ��
        if not IsTunnelOpen(nPLine.FLineID) then Continue;
        //�ж�ͨ���Ƿ���

        nIdx := nPLine.FTrucks.Add(nLineItem.FTrucks[nInt]);
        nLineItem.FTrucks.Delete(nInt);
        //Ų���������µ�

        nHint := 'Update %s Set T_Line=''%s'' ' +
                 'Where T_Truck=''%s'' And T_Line=''%s''';
        nHint := Format(nHint, [sTable_ZTTrucks, nPLine.FLineID, nTruck,
                nLineItem.FLineID]);
        gTruckQueueManager.AddExecuteSQL(nHint);

        nHint := '����[ %s ]��������[ %s->%s ]';
        nHint := Format(nHint, [nTruck, nLineItem.FName, nPLine.FName]);
        WriteNearReaderLog(nHint);
        Break;
      end;
    end;
    //��װ�ص�����

    if nIdx < 0 then
    begin
      nHint := Format('����[ %s ]����[ %s ]������.', [nTruck, nPLine.FName]);
      Exit;
    end;

    nPTruck := nPLine.FTrucks[nIdx];
    nPTruck.FStockName := nPLine.FName;
    //ͬ��������
    Result := True;
  finally
    SyncLock.Leave;
  end;
end;

//Date: 2019-03-12
//Parm: ����;ͨ��;Ƥ��
//Desc: ��ȨnTruck��nTunnel�����Ż�
procedure TruckStartFHBasisWeightGL(const nTruck: PTruckItem; const nTunnel: string;
 const nLading: TLadingBillItem; const UnPLC:string = '');
var nStr, nTruckType: string;
    nDBConn: PDBWorker;
    nMValue, nVal : Double;
begin
  {$IFDEF UseERelayPLC}
    if UnPLC <> '' then
    begin
      {$IFDEF SendTrukTypeToPLC}
      //����PLC ����
      nTruckType:= GetTruckType(nTruck.FTruck);
      //gERelayManagerPLC.OpenTunnel(nTunnel+nTruckType);
      WriteNearReaderLog(nTunnel+' ���ͳ��ͣ�'+nTruckType);
      {$ENDIF}

      gERelayManagerPLC.OpenTunnel(nTunnel);
      WriteNearReaderLog(nTunnel+'�򿪽�����բ,���̵�');
    end
    else
    begin
      {$IFDEF BasisWeightTruckProber}
        gProberManager.OpenTunnel(nTunnel);
      {$ELSE}
        gERelayManager.LineOpen(nTunnel);
      {$ENDIF}
    end;
    //��������
    if Assigned(gNetVoiceHelper) then
      gNetVoiceHelper.PlayVoice(nLading.FTruck+' ˢ���ɹ����ϰ�',nTunnel);
  {$ELSE}
    gERelayManager.LineOpen(nTunnel);
  {$ENDIF}
  //��ʼ�Ż�

  nStr := Format('Truck=%s', [nTruck.FTruck]);

  {$IFDEF TruckLoadLimit}
  if nLading.FPData.FValue > 0 then
  begin
    nDBConn := nil;
    try
      nStr := ' select T_MaxBillNum from %s where T_Truck = ''%s'' ';
      nStr := Format(nStr,[sTable_Truck,nTruck.FTruck]);
      with gDBConnManager.SQLQuery(nStr, nDBConn) do
      begin
        if recordcount = 0 then
        begin
          nMValue := 49;
        end;
        nMValue := FieldByName('T_MaxBillNum').AsFloat;
        if nMValue < 1 then
          nMValue := 49;
        nVal := nMValue - nLading.FPData.FValue;    //��󿪵���
        if nVal < nTruck.FValue then
          nTruck.FValue := nVal;
        WriteNearReaderLog(nTruck.FBill+'����ˢ����������'+floattostr(nTruck.FValue));
        //�������������غ�Ƥ���������ȡСֵ.
      end;
    finally
      gDBConnManager.ReleaseConnection(nDBConn);
    end;
  end;
  {$ENDIF}

  gBasisWeightManager.StartWeight(nTunnel, nTruck.FBill, nTruck.FValue,StrToFloatDef(nLading.FMHeight,0),
    nLading.FPData.FValue, nStr);
  //��ʼ����װ��
  WriteNearReaderLog('ͨ��:' + nTunnel +' ��ʼװ��ҵ��:' + nTruck.FBill + ' ' + nTruck.FTruck);
  ShowLEDHintPLC(nTunnel, FloatToStr(nTruck.FValue), nTruck.FTruck,UnPLC);

  if nLading.FStatus <> sFlag_TruckIn then
  begin
    {$IFDEF UseERelayPLC}
      if UnPLC <> '' then
      begin
        gERelayManagerPLC.SendMHeight(nTunnel+'_W',StrToFloatDef(nLading.FMHeight,0), 0, 0);
        gERelayManagerPLC.OpenTunnel(nTunnel+'_O');
        WriteNearReaderLog(nTunnel+' ����Ż�');
      end
      else
      begin
        {$IFDEF BasisWeightTruckProber}
          gProberManager.OpenTunnel(nTunnel+'_O');
          WriteNearReaderLog(nTunnel+' ����Ż�');
        {$ENDIF}
      end;
    {$ENDIF}
    gBasisWeightManager.SetParam(nTunnel, 'CanFH', sFlag_Yes);
  //��ӿɷŻұ��
  end;
end;

//Date: 2012-4-25
//Parm: ����;ͨ��
//Desc: ��ȨnTruck��nTunnel�����Ż�
procedure TruckStartFHBasisWeight(const nTruck: PTruckItem; const nTunnel: string;
 const nLading: TLadingBillItem);
var nStr,nTmp: string;
    nWorker: PDBWorker;
    nValue: Double;
begin
  nWorker := nil;
  try
    nTmp := '';
    nStr := 'Select T_Card,T_CardUse From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nTruck.FTruck]);

    with gDBConnManager.SQLQuery(nStr, nWorker) do
    if RecordCount > 0 then
    begin
      nTmp := Trim(Fields[0].AsString);
      if Fields[1].AsString = sFlag_No then
        nTmp := '';
      //xxxxx
    end;

    g02NReader.SetRealELabel(nTunnel, nTmp);
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;

  nValue := nTruck.FValue;
  {$IFDEF QZNF}
  if nValue = 110 then
    nValue := 111;
  {$ENDIF}

  nStr := nTruck.FTruck + StringOfChar(' ', 12 - Length(nTruck.FTruck));
  nTmp := nTruck.FStockName + FloatToStr(nValue);
  nStr := nStr + nTruck.FStockName + StringOfChar(' ', 12 - Length(nTmp)) +
          FloatToStr(nValue);
  //xxxxx

  nStr := Format('Truck=%s', [nTruck.FTruck]);
  gBasisWeightManager.StartWeight(nTunnel, nTruck.FBill, nTruck.FValue,0,
    nLading.FPData.FValue, nStr);
  //��ʼ����װ��

  if nLading.FStatus <> sFlag_TruckIn then
    gBasisWeightManager.SetParam(nTunnel, 'CanFH', sFlag_Yes);
  //��ӿɷŻұ��

  if (nLading.FStatus = sFlag_TruckFH) or (nLading.FStatus = sFlag_TruckBFM)
   or (nLading.FNextStatus = sFlag_TruckFH)then
  begin
    gERelayManager.LineOpen(nTunnel);
    //�򿪷Ż�
    ShowLEDHint(nTunnel, '�뿪ʼװ��', nTruck.FTruck);
    gBasisWeightManager.SetParam(nTunnel, 'CanFH', sFlag_Yes);
    //��ӿɷŻұ��
  end;
  gProberManager.OpenTunnel(nTunnel);
  //���̵�
end;


//Date: 2019-03-12
//Parm: �ſ���;ͨ����
//Desc: ��nCardִ�г�������
procedure MakeTruckWeightFirstGL(const nCard,nTunnel: string;const UnPLC:string = '';
                                const nReader:string = '');
var nStr,nVoiceID : string;
    nIdx: Integer;
    nPound: TBWTunnel;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
    nPT: PPTTunnelItem;
    nDBConn: PDBWorker;
begin
  nDBConn := nil;
  WriteNearReaderLog(Format('MakeTruckWeightFirst����. %s %s %s',[nCard,nTunnel,UnPLC]));

  nVoiceID:= nTunnel;
  if not GetLadingBills(nCard, sFlag_TruckFH, nTrucks) then
  begin
    nStr := '��ȡ�ſ�[ %s ]��������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);

    nStr:= '��ȡ��������Ϣʧ��';
    ShowLEDHintPLC(nTunnel, nStr,'',UnPLC);
    {$IFDEF LineVoice}
    MakeGateSound(nStr, nVoiceID, False);
    {$ENDIF}
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫװ�ϳ���.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);

    nStr:= 'û����Ҫװ�ϳ���';
    ShowLEDHintPLC(nTunnel, nStr,'',UnPLC);
    {$IFDEF LineVoice}
    MakeGateSound(nStr, nVoiceID, False);
    {$ENDIF}
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if FStatus = sFlag_TruckNone then
    begin
      ShowLEDHintPLC(nTunnel, '�����ˢ��', nTrucks[0].FTruck,UnPLC);
      {$IFDEF LineVoice}
      nStr:=  nTrucks[0].FTruck + '�����ˢ��';
      MakeGateSound(nStr, nVoiceID, False);
      {$ENDIF}
      Exit;
    end;
  end;
  
 if gBasisWeightManager <> nil then
 begin
    with gBasisWeightManager.TunnelManager do
    begin
      nPT := GetTunnel(nTunnel);
      if not Assigned(nPT) then
      begin
        ShowLEDHintPLC(nTunnel, 'ͨ��δ����', nTrucks[0].FTruck,UnPLC);

        {$IFDEF LineVoice}
        nStr:= '��ǰͨ��δ���á��뻻��װ��';
        MakeGateSound(nStr, nVoiceID, False);
        {$ENDIF}
        Exit;
      end;
    end;

    if gBasisWeightManager.IsTunnelBusy(nTunnel, @nPound) and
       (nPound.FBill <> nTrucks[0].FID) then //ͨ��æ
    begin
      if nPound.FValTunnel > 0 then //ǰ�����°�
      begin
        nStr := Format('%s ��ȴ�ǰ��', [nTrucks[0].FTruck]);
        ShowLEDHintPLC(nTunnel, nStr,'',UnPLC);
        WriteNearReaderLog(nStr);
        {$IFDEF LineVoice}
        MakeGateSound(nStr, nVoiceID, False);
        {$ENDIF}
        Exit;
      end;
    end;
 end;


  WriteNearReaderLog('ͨ��:' + nTunnel +' ��ǰҵ��:' + nPound.FBill +
                     ' ��ˢ��:' + nTrucks[0].FID);

  if nPound.FBill <> '' then
  if (nPound.FBill <> nTrucks[0].FID) then //ǰ��ҵ��δ��ɺ�ˢ��
  begin
    if (nPound.FValTunnel < 0) or (nPound.FValTunnel > nPound.FTunnel.FPort.FMinValue) then 
    begin
      nStr := Format('%s.%s �ذ������쳣', [nTrucks[0].FID, nTrucks[0].FTruck]);
      WriteNearReaderLog(nStr);

        {$IFDEF LineVoice}
        MakeGateSound('�ذ������쳣������ϵ������Ա', nVoiceID, False);
        {$ENDIF}
      Exit;
    end;
  end;

  if not IsTruckInQueue(nTrucks[0].FTruck, nTunnel, False, nStr,
         nPTruck, nPLine, sFlag_San) then
  begin
    WriteNearReaderLog(nStr);
    ShowLEDHintPLC(nTunnel, '�뻻��װ��', nTrucks[0].FTruck,UnPLC);

    {$IFDEF LineVoice}
    MakeGateSound(nTrucks[0].FTruck + '�뻻��װ��', nVoiceID, False);
    {$ENDIF}
    //��������
    if Assigned(gNetVoiceHelper) then
      gNetVoiceHelper.PlayVoice(nTrucks[0].FTruck+'�뻻��װ��',nTunnel);
    Exit;
  end; //���ͨ��
  
  //����ˢ�������ж�
//  if (nTrucks[0].FMData.FValue > 0) and (nTrucks[0].FMData.FValue <= 50) then
//  begin
//    if nTrucks[0].FMData.FValue - nTrucks[0].FPData.FValue >= nTrucks[0].FValue then
//    begin
//      WriteNearReaderLog(nTrucks[0].FTruck+'װ��ҵ�������,��Ͷ������');
//      //��������
//      if Assigned(gNetVoiceHelper) then
//        gNetVoiceHelper.PlayVoice(nTrucks[0].FTruck+'װ��ҵ�������,��Ͷ������',nTunnel);
//      Exit;
//    end;
//    try
//      nStr := ' Select T_MaxBillNum From %s where T_Truck = ''%s'' ';
//      nStr := Format(nStr,[sTable_Truck,nTrucks[0].FTruck]);
//     
//      with gDBConnManager.SQLQuery(nStr, nDBConn) do
//      begin
//        if RecordCount > 0 then
//        begin
//          if nTrucks[0].FMData.FValue >= FieldByName('T_MaxBillNum').AsFloat then
//          begin
//            WriteNearReaderLog(nTrucks[0].FTruck+'װ��ҵ�������,��Ͷ������');
//            //��������
//            if Assigned(gNetVoiceHelper) then
//              gNetVoiceHelper.PlayVoice(nTrucks[0].FTruck+'װ��ҵ�������,��Ͷ������',nTunnel);
//            Exit;
//          end;
//        end;
//      end;
//    finally
//      gDBConnManager.ReleaseConnection(nDBConn);
//    end;
//  end;

  if nTrucks[0].FStatus = sFlag_TruckIn then
  begin
    nStr := '����[ %s ]ˢ��,�ȴ���Ƥ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);
    WriteNearReaderLog(nStr);

    nStr := Format('�� %s �ϰ�����Ƥ��', [nTrucks[0].FTruck]);
    ShowLEDHintPLC(nTunnel, nStr,'',UnPLC);

    {$IFDEF LineVoice}
    MakeGateSound(nStr, nVoiceID, False);
    {$ENDIF}
  end else
  begin
    //666666
    
    if nPound.FValTunnel > 0 then
         nStr := '���ϰ�װ��'
    else nStr := '�뿪ʼװ��';

    ShowLEDHintPLC(nTunnel, nStr, nTrucks[0].FTruck,UnPLC);

    {$IFDEF LineVoice}
    nStr:= nTrucks[0].FTruck + nStr;
    MakeGateSound(nStr, nVoiceID, False);
    {$ENDIF}
  end;

  {$IFDEF SaveBillStatusFH}
  if (nTrucks[0].FStatus=sFlag_TruckBFP) then
  if not SaveLadingBills(sFlag_TruckFH, nTrucks) then
  begin
    nStr := '����[ %s ]�ŻҴ����ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;
  {$ENDIF}
  {$IFDEF LineNeedOPenDoor}
  BlueOpenDoor(nReader,'');
  WriteNearReaderLog('��׼��������������̧��ָ�');
  //̧��
  {$ENDIF}

  TruckStartFHBasisWeightGL(nPTruck, nTunnel, nTrucks[0],UnPLC);
  //ִ�зŻ�
end;

//Date: 2019-03-12
//Parm: �ſ���;ͨ����
//Desc: ��nCardִ�г�������
procedure MakeTruckWeightFirst(const nCard,nTunnel: string;const nReader:string = '');
var nStr: string;
    nIdx: Integer;
    nPound: TBWTunnel;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
    nPT: PPTTunnelItem;
begin
  {$IFDEF DEBUG}
  WriteNearReaderLog('MakeTruckWeightFirst����.');
  {$ENDIF}

  if not GetLadingBills(nCard, sFlag_TruckFH, nTrucks) then
  begin
    nStr := '��ȡ�ſ�[ %s ]��������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    ShowLEDHint(nTunnel, '��ȡ��������Ϣʧ��');
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫװ�ϳ���.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    ShowLEDHint(nTunnel, 'û����Ҫװ�ϳ���');
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if FStatus = sFlag_TruckNone then
    begin
      ShowLEDHint(nTunnel, '�����ˢ��', nTrucks[0].FTruck);
      Exit;
    end;
    {$IFDEF BasisWeight}
    if FStatus = sFlag_TruckIn then
    begin
      ShowLEDHint(nTunnel, '��ȥ��Ƥ��', nTrucks[0].FTruck);
      Exit;
    end;
    if FStatus = sFlag_TruckBFM then
    begin
      ShowLEDHint(nTunnel, '��ȥ����', nTrucks[0].FTruck);
      Exit;
    end;
    {$ENDIF}
  end;

  with gBasisWeightManager.TunnelManager do
  begin
    nPT := GetTunnel(nTunnel);
    if not Assigned(nPT) then
    begin
      ShowLEDHint(nTunnel, 'ͨ��δ����', nTrucks[0].FTruck);
      Exit;
    end;
  end;

  if gBasisWeightManager.IsTunnelBusy(nTunnel, @nPound) and
     (nPound.FBill <> nTrucks[0].FID) then //ͨ��æ
  begin
//    if nPound.FValTunnel = 0 then //ǰ�����°�
//    begin
//      nStr := Format('%s ��ȴ�ǰ��', [nTrucks[0].FTruck]);
//      ShowLEDHint(nTunnel, nStr);
//      Exit;
//    end;
  end;

  WriteNearReaderLog('ͨ��' + nTunnel +'��ǰҵ��:' + nPound.FBill +
                     '��ˢ��:' + nTrucks[0].FID);

  if nPound.FBill <> '' then
  if (nPound.FBill <> nTrucks[0].FID) then //ǰ��ҵ��δ��ɺ�ˢ��
  begin
    if (nPound.FValTunnel < 0) or (nPound.FValTunnel > nPound.FTunnel.FPort.FMinValue) then 
    begin
      nStr := Format('%s.%s �ذ������쳣', [nTrucks[0].FID, nTrucks[0].FTruck]);
      WriteNearReaderLog(nStr);
      Exit;
    end;
  end;

  if not IsTruckInQueue(nTrucks[0].FTruck, nTunnel, False, nStr,
         nPTruck, nPLine, sFlag_San) then
  begin
    WriteNearReaderLog(nStr);
    ShowLEDHint(nTunnel, '�뻻��װ��', nTrucks[0].FTruck);
    Exit;
  end; //���ͨ��

  if nTrucks[0].FStatus = sFlag_TruckIn then
  begin
    nStr := '����[ %s ]ˢ��,�ȴ���Ƥ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);
    WriteNearReaderLog(nStr);

    nStr := Format('�� %s �ϰ�����Ƥ��', [nTrucks[0].FTruck]);
    ShowLEDHint(nTunnel, nStr);
  end else
  begin
    if nPound.FValTunnel > 0 then
         nStr := '���ϰ�װ��'
    else nStr := '�뿪ʼװ��';

    ShowLEDHint(nTunnel, nStr, nTrucks[0].FTruck);
  end;

  {$IFDEF BasisWeight}
  if nTrucks[0].FStatus = sFlag_TruckBFP then
  if not SaveLadingBills(sFlag_TruckFH, nTrucks) then
  begin
    nStr := '����[ %s ]�ŻҴ����ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;
  {$ENDIF}
  MakeLadingSound(nPTruck, nPLine, nTunnel, nTunnel);
  //��������
  BlueOpenDoor(nReader,'');
  //̧��
  TruckStartFHBasisWeight(nPTruck, nTunnel, nTrucks[0]);
  //ִ�зŻ�
end;

//Date: 2012-4-22
//Parm: ��ͷ����
//Desc: ��nReader�����Ŀ��������嶯��
procedure WhenReaderCardArrived(const nReader: THHReaderItem);
var nStr,nCard,nReaderType: string;
    nErrNum: Integer;
    nDBConn: PDBWorker;
begin
  nDBConn := nil;
  {$IFDEF DEBUG}
  WriteHardHelperLog('WhenReaderCardArrived����.');
  {$ENDIF}

  with gParamManager.ActiveParam^ do
  try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
    if not Assigned(nDBConn) then
    begin
      WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
      Exit;
    end;

    if not nDBConn.FConn.Connected then
      nDBConn.FConn.Connected := True;
    //conn db

    nStr := 'Select C_Card From $TB Where C_Card=''$CD'' or ' +
            'C_Card2=''$CD'' or C_Card3=''$CD''';
    nStr := MacroValue(nStr, [MI('$TB', sTable_Card), MI('$CD', nReader.FCard)]);

    with gDBConnManager.WorkerQuery(nDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nCard := Fields[0].AsString;
    end else
    begin
      nStr := Format('�ſ���[ %s ]ƥ��ʧ��.', [nReader.FCard]);
      WriteHardHelperLog(nStr);
      Exit;
    end;

    if Assigned(nReader.FOptions) then
         nReaderType := nReader.FOptions.Values['ReaderType']
    else nReaderType := '';

    try
      //����ˢ����־���
      GetTruckInfo(nCard, nReader.FID);

      if (Assigned(nReader.FOptions)) and
        (Trim(nReader.FOptions.Values['TunnelGL']) <> '') then
      begin
        MakeTruckWeightFirstGL(nCard, nReader.FOptions.Values['Tunnel'],Trim(nReader.FOptions.Values['EPLC']),
                                  nReader.FID);
      end else
      if (Assigned(nReader.FOptions)) and
        (Trim(nReader.FOptions.Values['Tunnel']) <> '') then
      begin
        MakeTruckWeightFirst(nCard, nReader.FOptions.Values['Tunnel'],nReader.FID);
      end
      else
      if nReader.FType = rtIn then
      begin
        MakeTruckIn(nCard, nReader.FID, nDBConn, nReaderType);
      end else

      if nReader.FType = rtOut then
      begin
        if Assigned(nReader.FOptions) then
             nStr := nReader.FOptions.Values['HYPrinter']
        else nStr := '';
        MakeTruckOut(nCard, nReader.FID, nReader.FPrinter, nStr, nReaderType);
      end else

      if nReader.FType = rtGate then
      begin
        if nReader.FID <> '' then
          BlueOpenDoor(nReader.FID, nReaderType);
        //̧��
      end
      {$IFDEF PoundBlueOpen}
      else
      if nReader.FTYpe = rtPound then
      begin
        WriteHardHelperLog('����̧��.');
        if nReader.FID <> '' then
          BlueOpenDoor(nReader.FID, nReaderType);
        //̧��
      end
      {$ENDIF}
      else
      if nReader.FType = rtQueueGate then
      begin
        if Assigned(nReader.FOptions) then
        begin
          if nReader.FOptions.Values['TruckCross'] = sFlag_Yes then
          begin
            MakeTruckPassGateEx(nCard, nReader.FID,nReader.FOptions.Values['SaveCrossData'],
                                nDBConn, nReaderType);
            Exit;
          end;
        end;
        if nReader.FID <> '' then
          MakeTruckPassGate(nCard, nReader.FID, nDBConn, nReaderType);
        //̧��
      end;
    except
      On E:Exception do
      begin
        WriteHardHelperLog(E.Message);
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
end;

//Date: 2014-10-25
//Parm: ��ͷ����
//Desc: �����ͷ�ſ�����
procedure WhenHYReaderCardArrived(const nReader: PHYReaderItem);
var nIdx: Integer;
begin
  {$IFDEF DEBUG}
  WriteHardHelperLog(Format('�����ǩ %s:%s', [nReader.FTunnel, nReader.FCard]));
  {$ENDIF}

  if nReader.FVirtual then
  begin
    for nIdx:=Low(nReader.FVReaders) to High(nReader.FVReaders) do
    begin
      case nReader.FVType of
       rt900:
        gHardwareHelper.SetReaderCard(nReader.FVReaders[nIdx],
                                      'H' + nReader.FCard, False);
       rt02n:
        g02NReader.SetReaderCard(nReader.FVReader[nIdx],
                                 'H' + nReader.FCard);
      end;

      if nReader.FVMultiInterval > 0 then
        Sleep(nReader.FVMultiInterval);
      //xxxxx
    end;
  end else g02NReader.ActiveELabel(nReader.FTunnel, nReader.FCard);
end;

procedure WhenBlueReaderCardArrived(nHost: TBlueReaderHost; nCard: TBlueReaderCard);
begin
  {$IFDEF DEBUG}
  WriteHardHelperLog(Format('���������� %s:%s', [nHost.FReaderID, nCard.FCard]));
  {$ENDIF}

  gHardwareHelper.SetReaderCard(nHost.FReaderID, nCard.FCard, False);
end;

//Date: 2018-01-08
//Parm: ����һ������
//Desc: ��������һ��������Ϣ
procedure WhenTTCE_M100_ReadCard(const nItem: PM100ReaderItem);
var nStr: string;
    nRetain: Boolean;
    nCType: string;
    nDBConn: PDBWorker;
    nErrNum: Integer;
begin
  nRetain := False;
  //init

  {$IFDEF DEBUG}
  nStr := '����һ����������'  + nItem.FID + ' ::: ' + nItem.FCard;
  WriteHardHelperLog(nStr);
  {$ENDIF}

  try
    if not nItem.FVirtual then Exit;
    if nItem.FVType = rtOutM100 then
    begin
      nRetain := MakeTruckOut(nItem.FCard, nItem.FVReader, nItem.FVPrinter,
                              nItem.FVHYPrinter);
      //xxxxx

      if not GetCardUsed(nItem.FCard, nCType) then
        nCType := '';

        if nCType = sFlag_Provide then
        begin
          nDBConn := nil;
          with gParamManager.ActiveParam^ do
          Try
            nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
            if not Assigned(nDBConn) then
            begin
              WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
              Exit;
            end;

            if not nDBConn.FConn.Connected then
              nDBConn.FConn.Connected := True;
            //conn db
            nStr := 'select O_CType from %s Where O_Card=''%s'' ';
            nStr := Format(nStr, [sTable_Order, nItem.FCard]);
            with gDBConnManager.WorkerQuery(nDBConn,nStr) do
            if RecordCount > 0 then
            begin
              if FieldByName('O_CType').AsString = sFlag_OrderCardG then
                nRetain := False;
            end;
          finally
            gDBConnManager.ReleaseConnection(nDBConn);
          end;
        end;
        if nRetain then
          WriteHardHelperLog('�̿���ִ��״̬:'+'������:'+nCType+'����:�̿�')
        else
          WriteHardHelperLog('�̿���ִ��״̬:'+'������:'+nCType+'����:�̿����¿�');
    end else
    begin
      gHardwareHelper.SetReaderCard(nItem.FVReader, nItem.FCard, False);
    end;
  finally
    gM100ReaderManager.DealtWithCard(nItem, nRetain)
  end;
end;

// ��������С����ʾ��Ϣ
procedure ShowTextByBXFontCard(nCard, nTitle, nData:string);
var nStr  : string;
    nTitleM, nDataM : TBXDisplayMode;
begin
  if nCard<>'' then
  if Assigned(gBXFontCardManager) then
  begin
    gBXFontCardManager.InitDisplayMode(nTitleM);
    gBXFontCardManager.InitDisplayMode(nDataM);

    //title
    nTitleM.FDisplayMode := 1;
    nTitleM.FNewLine := BX_NewLine_02;
    nTitleM.FSpeed   := $03;

    //Data
    nDataM.FDisplayMode := 3;
    nDataM.FNewLine := BX_NewLine_02;
    nDataM.FSpeed   := $03;

    WriteNearReaderLog(Format('������С�� %s ���� %s %s', [nCard, nTitle, nData]));

    if Pos('ZT',nCard)>0 then
      gBXFontCardManager.Display(nTitle, nData, nCard, 3600, 3600, @nTitleM, @nDataM)
    else gBXFontCardManager.Display(nTitle, nData, nCard, 3, 100, @nTitleM, @nDataM);
  end
  else WriteNearReaderLog('����С��������������');
end;

//Date: 2013-1-21
//Parm: ͨ����;������;
//Desc: ��nTunnel�ϴ�ӡnBill��α��
function PrintBillCode(const nTunnel,nBill: string; var nHint: string): Boolean;
var nStr: string;
    nTask: Int64;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin
  Result := True;

  {$IFNDEF UseModbusJS}
  if not gMultiJSManager.CountEnable then Exit;
  {$ENDIF}

  nTask := gTaskMonitor.AddTask('UHardBusiness.PrintBillCode', cTaskTimeoutLong);
  //to mon
  for nIdx := 0 to 2 do
  begin
    if not CallHardwareCommand(cBC_PrintCode, nBill, nTunnel, @nOut) then
    begin
      nStr := '��ͨ��[ %s ]���ͷ�Υ����ʧ��,����: %s';
      nStr := Format(nStr, [nTunnel, nOut.FData]);  
      WriteNearReaderLog(nStr);
    end;
    Sleep(300);
  end;

  gTaskMonitor.DelTask(nTask, True);
  //task done
end;

//Date: 2012-4-24
//Parm: ����;ͨ��;������;��������
//Desc: ����nTunnel�ĳ�������������
function TruckStartJS(const nTruck,nTunnel,nBill: string;
  var nHint: string; const nAddJS: Boolean = True): Boolean;
var nIdx: Integer;
    nTask: Int64;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
begin
  with gTruckQueueManager do
  try
    Result := False;
    SyncLock.Enter;
    nIdx := GetLine(nTunnel);

    if nIdx < 0 then
    begin
      nHint := Format('ͨ��[ %s ]��Ч.', [nTunnel]);
      Exit;
    end;

    nPLine := Lines[nIdx];
    nIdx := TruckInLine(nTruck, nPLine.FTrucks);

    if nIdx < 0 then
    begin
      nHint := Format('����[ %s ]�Ѳ��ٶ���.', [nTruck]);
      Exit;
    end;

    Result := True;
    nPTruck := nPLine.FTrucks[nIdx];

    for nIdx:=nPLine.FTrucks.Count - 1 downto 0 do
      PTruckItem(nPLine.FTrucks[nIdx]).FStarted := False;
    nPTruck.FStarted := True;

    if PrintBillCode(nTunnel, nBill, nHint) and nAddJS then
    begin
      nTask := gTaskMonitor.AddTask('UHardBusiness.AddJS', cTaskTimeoutLong);
      //to mon
      {$IFNDEF UseModbusJS}
      for nIdx := 0 to 2 do
        gMultiJSManager.AddJS(nTunnel, nTruck, nBill, nPTruck.FDai, True);
      {$ELSE}
      gMultiJSManager.AddJS(nTunnel, nTruck, nBill, nPTruck.FDai, True);
      gModbusJSManager.AddJS(nTunnel, nTruck, nBill, nPTruck.FDai, True);
      gMultiJSManager.AddJS(nTunnel, nTruck, nBill, nPTruck.FDai, True);
      {$ENDIF}
      gTaskMonitor.DelTask(nTask);
    end;
  finally
    SyncLock.Leave;
  end;
end;

//Date: 2013-07-17
//Parm: ��������
//Desc: ��ѯnBill�ϵ���װ��
function GetHasDai(const nBill: string): Integer;
var nStr: string;
    nIdx: Integer;
    nDBConn: PDBWorker;
begin
  {$IFNDEF UseModbusJS}
  if not gMultiJSManager.ChainEnable then
  begin
    Result := 0;
    Exit;
  end;

  Result := gMultiJSManager.GetJSDai(nBill);
  {$ELSE}
  Result := gModbusJSManager.GetJSDai(nBill);
  {$ENDIF}
  if Result > 0 then Exit;

  nDBConn := nil;
  with gParamManager.ActiveParam^ do
  try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
    if not Assigned(nDBConn) then
    begin
      WriteNearReaderLog('����HM���ݿ�ʧ��(DBConn Is Null).');
      Exit;
    end;

    if not nDBConn.FConn.Connected then
      nDBConn.FConn.Connected := True;
    //conn db

    nStr := 'Select T_Total From %s Where T_Bill=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, nBill]);

    with gDBConnManager.WorkerQuery(nDBConn, nStr) do
    if RecordCount > 0 then
    begin
      Result := Fields[0].AsInteger;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
end;

//Date: 2012-4-24
//Parm: �ſ���;ͨ����
//Desc: ��nCardִ�д�װװ������
procedure MakeTruckLadingDai(const nCard: string; nTunnel: string);
var nStr,nType: string;
    nIdx,nInt: Integer;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
    nWorker: PDBWorker;
    nList:TStrings;
    nTmp: TWorkerBusinessCommand;

    function IsJSRun: Boolean;
    begin
      Result := False;
      if nTunnel = '' then Exit;
      {$IFNDEF UseModbusJS}
      Result := gMultiJSManager.IsJSRun(nTunnel);
      {$ELSE}
      Result := gModbusJSManager.IsJSRun(nTunnel);
      {$ENDIF}

      if Result then
      begin
        nStr := 'ͨ��[ %s ]װ����,ҵ����Ч.';
        nStr := Format(nStr, [nTunnel]);
        WriteNearReaderLog(nStr);
      end;
    end;
begin
  WriteNearReaderLog('ͨ��[ ' + nTunnel + ' ]: MakeTruckLadingDai����.');
    //666666��ʱ����
  if IsJSRun then Exit;
  //tunnel is busy

  if not GetLadingBills(nCard, sFlag_TruckZT, nTrucks) then
  begin
    nStr := '��ȡ�ſ�[ %s ]��������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫջ̨�������.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if nTunnel = '' then
  begin
    nTunnel := gTruckQueueManager.GetTruckTunnel(nTrucks[0].FTruck);
    //���¶�λ�������ڳ���
    if IsJSRun then Exit;
  end;
  
  if not IsTruckInQueue(nTrucks[0].FTruck, nTunnel, False, nStr,
         nPTruck, nPLine, sFlag_Dai) then
  begin
    WriteNearReaderLog(nStr);
    Exit;
  end; //���ͨ��

  nStr := '';
  nInt := 0;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if {$IFNDEF HYJC} (FStatus = sFlag_TruckZT) or {$ENDIF} (FNextStatus = sFlag_TruckZT) then
    begin
      FSelected := Pos(FID, nPTruck.FHKBills) > 0;
      if FSelected then Inc(nInt); //ˢ��ͨ����Ӧ�Ľ�����
      Continue;
    end;

    FSelected := False;
    nStr := '����[ %s ]��һ״̬Ϊ:[ %s ],�޷�ջ̨���.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);
  end;

  if nInt < 1 then
  begin
    WriteHardHelperLog(nStr);
    Exit;
  end;

  {$IFDEF GetBatCodeByTunnel}
  nWorker := nil;
  nList := TStringList.Create;
  try
    nStr := 'Select * from %s where D_name=''%s'' and D_Memo=''%s''';
    nStr := Format(nStr,[sTable_SysDict, sFlag_GetBatCodeByTunnel, nTunnel]);
    with gDBConnManager.SQLQuery(nStr, nWorker) do
      nType := FieldByName('D_Value').asstring;
    if nType = '' then
    begin
      nStr := 'ͨ��['+nTunnel+']δ�������η���.';
      WriteNearReaderLog(nStr);
      Exit;
    end;
    nList.Values['CustomerType'] := nType;
    nList.Values['Value'] := FloatToStr(nTrucks[0].FValue);


    if not TWorkerBusinessCommander.CallMe(cBC_GetStockBatcodeByCusType,
       nTrucks[0].FStockNo, nList.Text, @nTmp) then
       raise Exception.Create(nTmp.FData);

    nStr := 'update %s set L_HYDan=''%s'' where L_id=''%s''';
    nStr := Format(nStr,[sTable_Bill, nTmp.FData, nTrucks[0].FID]);
    gDBConnManager.WorkerExec(nWorker, nStr);

    nStr := 'select * from %s where l_id=''%s''';
    nStr := Format(nstr, [sTable_Bill, nTrucks[0].FID]);
    with gDBConnManager.WorkerQuery(nWorker, nStr) do
    begin
      if FieldByName('l_ladetime').AsString = '' then
      begin
        nStr := 'UPDate %s Set B_HasUse=B_HasUse+%s Where B_Batcode=''%s'' and B_type=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, FloatToStr(nTrucks[0].FValue),nTmp.FData, nType]);
        gDBConnManager.WorkerExec(nWorker, nStr);
      end;
    end;
    
    WriteNearReaderLog('ͨ��['+nTunnel+'],�ᵥ:['+nTrucks[0].FID+']�ֳ�ˢ����ȡ���κ�:'+nTmp.FData);
  finally
    gDBConnManager.ReleaseConnection(nWorker);
    nList.free;
  end;
  {$ENDIF}

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if not FSelected then Continue;
    if FStatus <> sFlag_TruckZT then Continue;

    nStr := '��װ����[ %s ]�ٴ�ˢ��װ��.';
    nStr := Format(nStr, [nPTruck.FTruck]);
    WriteNearReaderLog(nStr);

    {$IFNDEF UseModbusJS}
    if not TruckStartJS(nPTruck.FTruck, nTunnel, nPTruck.FBill, nStr,
       GetHasDai(nPTruck.FBill) < 1) then
      WriteNearReaderLog(nStr);
    {$ELSE}
    if not TruckStartJS(nPTruck.FTruck, nTunnel, nPTruck.FBill, nStr,
       True) then
      WriteNearReaderLog(nStr);
    {$ENDIF}
    Exit;
  end;

  if not SaveLadingBills(sFlag_TruckZT, nTrucks) then
  begin
    nStr := '����[ %s ]ջ̨���ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if not TruckStartJS(nPTruck.FTruck, nTunnel, nPTruck.FBill, nStr) then
    WriteNearReaderLog(nStr);
  Exit;
end;

//Date: 2012-4-25
//Parm: ����;ͨ��
//Desc: ��ȨnTruck��nTunnel�����Ż�
procedure TruckStartFH(const nTruck: PTruckItem; const nTunnel: string);
var nStr,nTmp,nCardUse: string;
   nField: TField;
   nWorker: PDBWorker;
begin
  nWorker := nil;
  try
    nTmp := '';
    nStr := 'Select * From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nTruck.FTruck]);

    with gDBConnManager.SQLQuery(nStr, nWorker) do
    if RecordCount > 0 then
    begin
      nField := FindField('T_Card');
      if Assigned(nField) then nTmp := nField.AsString;

      nField := FindField('T_CardUse');
      if Assigned(nField) then nCardUse := nField.AsString;

      if nCardUse = sFlag_No then
        nTmp := '';
      //xxxxx
    end;

    g02NReader.SetRealELabel(nTunnel, nTmp);
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;


  gERelayManager.LineOpen(nTunnel);
  //�򿪷Ż�

  {$IFDEF UseLBCModbus}
  gModBusClient.StartWeight(nTunnel, nTruck.FBill, nTruck.FValue);
  //��ʼ����װ��
  {$ENDIF}

  nStr := nTruck.FTruck + StringOfChar(' ', 12 - Length(nTruck.FTruck));
  nTmp := nTruck.FStockName + FloatToStr(nTruck.FValue);
  nStr := nStr + nTruck.FStockName + StringOfChar(' ', 12 - Length(nTmp)) +
          FloatToStr(nTruck.FValue);
  //xxxxx  

  gERelayManager.ShowTxt(nTunnel, nStr);
  //��ʾ����
end;

//Date: 2012-4-24
//Parm: �ſ���;ͨ����
//Desc: ��nCardִ�д�װװ������
procedure MakeTruckLadingSan(const nCard,nTunnel: string);
var nStr, nType: string;
    nIdx: Integer;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
    nWorker:PDBWorker;
    nList:TStrings;
    nTmp: TWorkerBusinessCommand;
begin
  {$IFDEF DEBUG}
  WriteNearReaderLog('MakeTruckLadingSan����.');
  {$ENDIF}

  if not GetLadingBills(nCard, sFlag_TruckFH, nTrucks) then
  begin
    nStr := '��ȡ�ſ�[ %s ]��������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫ�Żҳ���.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    {$IFDEF AllowMultiM}
    if FStatus = sFlag_TRuckBFM then
    begin
      FStatus := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckFH;
    end;
    //���غ�������(״̬��������Ƥ��,��ֹ�������)
    {$ENDIF}

    if (FStatus = sFlag_TruckFH) or (FNextStatus = sFlag_TruckFH) then Continue;
    //δװ����װ

    nStr := '����[ %s ]��һ״̬Ϊ:[ %s ],�޷��Ż�.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  if not IsTruckInQueue(nTrucks[0].FTruck, nTunnel, False, nStr,
         nPTruck, nPLine, sFlag_San) then
  begin
    WriteNearReaderLog(nStr);
    //loged

    nIdx := Length(nTrucks[0].FTruck);
    nStr := nTrucks[0].FTruck + StringOfChar(' ',12 - nIdx) + '�뻻��װ��';
    gERelayManager.ShowTxt(nTunnel, nStr);
    Exit;
  end; //���ͨ��
  {$IFDEF StockKuWeiEx}
  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    SaveStockKuWei(FID, nTunnel, FStockNo);
  end;
  {$ENDIF}

  {$IFDEF GetBatCodeByTunnel}
  nWorker := nil;
  nList := TStringList.Create;
  try
    nStr := 'Select * from %s where D_name=''%s'' and D_Memo=''%s''';
    nStr := Format(nStr,[sTable_SysDict, sFlag_GetBatCodeByTunnel, nTunnel]);
    //WriteNearReaderLog('zyww::'+nstr);
    with gDBConnManager.SQLQuery(nStr, nWorker) do
      nType := FieldByName('D_Value').asstring;
    if nType = '' then
    begin
      nStr := 'ͨ��['+nTunnel+']δ�������η���.';
      WriteNearReaderLog(nStr);
      Exit;
    end;
    nList.Values['CustomerType'] := nType;
    nList.Values['Value'] := FloatToStr(nTrucks[0].FValue);
    //WriteNearReaderLog('zywww::'+ntype+'::'+FloatToStr(nTrucks[0].FValue));

    if not TWorkerBusinessCommander.CallMe(cBC_GetStockBatcodeByCusType,
       nTrucks[0].FStockNo, nList.Text, @nTmp) then
       raise Exception.Create(nTmp.FData);
       
    nStr := 'update %s set L_HYDan=''%s'' where L_id=''%s''';
    nStr := Format(nStr,[sTable_Bill, nTmp.FData, nTrucks[0].FID]);
    gDBConnManager.WorkerExec(nWorker, nStr);

    nStr := 'select * from %s where l_id=''%s''';
    nStr := Format(nstr, [sTable_Bill, nTrucks[0].FID]);
    with gDBConnManager.WorkerQuery(nWorker, nStr) do
    begin
      if FieldByName('l_ladetime').AsString = '' then
      begin
        nStr := 'UPDate %s Set B_HasUse=B_HasUse+%s Where B_Batcode=''%s'' and B_type=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, FloatToStr(nTrucks[0].FValue),nTmp.FData, nType]);
        gDBConnManager.WorkerExec(nWorker, nStr);
      end;
    end;

    WriteNearReaderLog('ͨ��['+nTunnel+'],�ᵥ:['+nTrucks[0].FID+']�ֳ�ˢ����ȡ���κ�:'+nTmp.FData);
  finally
    gDBConnManager.ReleaseConnection(nWorker);
    nList.free;
  end;
  {$ENDIF}

  if nTrucks[0].FStatus = sFlag_TruckFH then
  begin
    nStr := 'ɢװ����[ %s ]�ٴ�ˢ��װ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);
    WriteNearReaderLog(nStr);

    TruckStartFH(nPTruck, nTunnel);

    {$IFDEF FixLoad}
    WriteNearReaderLog('��������װ��::'+nTunnel+'@'+nCard);
    //���Ϳ��ź�ͨ���ŵ�����װ��������
    gSendCardNo.SendCardNo(nTunnel+'@'+nCard);
    {$ENDIF}

    Exit;
  end;

  if not SaveLadingBills(sFlag_TruckFH, nTrucks) then
  begin
    nStr := '����[ %s ]�ŻҴ����ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  MakeLadingSound(nPTruck, nPLine, nTunnel, nTunnel);
  //��������
  TruckStartFH(nPTruck, nTunnel);
  //ִ�зŻ�
  {$IFDEF FixLoad}
  WriteNearReaderLog('��������װ��::'+nTunnel+'@'+nCard);
  //���Ϳ��ź�ͨ���ŵ�����װ��������
  gSendCardNo.SendCardNo(nTunnel+'@'+nCard);
  {$ENDIF}
end;

//Date: 2012-4-24
//Parm: ����;����
//Desc: ��nHost.nCard�µ�������������
procedure WhenReaderCardIn(const nCard: string; const nHost: PReaderHost);
var nStr: string;
begin
  if nHost.FType = rtOnce then
  begin
    if nHost.FFun = rfOut then
    begin
      if Assigned(nHost.FOptions) then
           nStr := nHost.FOptions.Values['HYPrinter']
      else nStr := '';
      MakeTruckOut(nCard, '', nHost.FPrinter, nStr);
    end
    else
    begin
      WriteHardHelperLog('�����װװ����');
      MakeTruckLadingDai(nCard, nHost.FTunnel);
    end;
//    if Assigned(nHost.FOptions) then
//    begin
//      if nHost.FOptions.Values['IsSan'] = sFlag_Yes then
//      begin
//        {$IFDEF BasisWeightWithPM}
//        if Assigned(nHost.FOptions) then
//        begin
//          if nHost.FOptions.Values['BasisWeight'] = sFlag_Yes then
//          begin
//            MakeTruckWeightFirst(nCard, nHost.FTunnel);
//            Exit;
//          end;
//        end;
//        MakeTruckLadingSan(nCard, nHost.FTunnel);
//        {$ELSE}
//        MakeTruckLadingSan(nCard, nHost.FTunnel);
//        {$ENDIF}
//      end
//      else
//      begin
//        WriteHardHelperLog('�����װװ����');
//        MakeTruckLadingDai(nCard, nHost.FTunnel);
//      end;
//    end;
  end else

  if nHost.FType = rtKeep then
  begin
    if Assigned(nHost.FOptions) then
    begin
      if nHost.FOptions.Values['IsGrab'] = sFlag_Yes then
      begin
        SaveGrabCard(nCard, nHost.FTunnel,False);
        Exit;
      end;
    end;
    MakeTruckLadingSan(nCard, nHost.FTunnel);
  end;
end;

//Date: 2012-4-24
//Parm: ����;����
//Desc: ��nHost.nCard��ʱ����������
procedure WhenReaderCardOut(const nCard: string; const nHost: PReaderHost);
begin
  {$IFDEF DEBUG}
  WriteHardHelperLog('WhenReaderCardOut�˳�.');
  {$ENDIF}

  gERelayManager.LineClose(nHost.FTunnel);
  Sleep(100);

  if Assigned(nHost.FOptions) then
  begin
    if nHost.FOptions.Values['IsGrab'] = sFlag_Yes then
    begin
      SaveGrabCard(nCard, nHost.FTunnel,True);
      Exit;
    end;
  end;

  {$IFDEF FixLoad}
  WriteHardHelperLog('ֹͣ����װ��::'+nHost.FTunnel+'@Close');
  //���Ϳ��ź�ͨ���ŵ�����װ��������
  gSendCardNo.SendCardNo(nHost.FTunnel+'@Close');
  {$ENDIF}

//  {$IFDEF BasisWeightWithPM}
//  gBasisWeightManager.StopWeight(nHost.FTunnel);
//  {$ENDIF}

  if nHost.FETimeOut then
       gERelayManager.ShowTxt(nHost.FTunnel, '���ӱ�ǩ������Χ')
  else gERelayManager.ShowTxt(nHost.FTunnel, nHost.FLEDText);
  Sleep(100);
end;

//------------------------------------------------------------------------------
//Date: 2012-12-16
//Parm: �ſ���
//Desc: ��nCardNo���Զ�����(ģ���ͷˢ��)
procedure MakeTruckAutoOut(const nCardNo: string);
var nReader: string;
begin
  if gTruckQueueManager.IsTruckAutoOut then
  begin
    nReader := gHardwareHelper.GetReaderLastOn(nCardNo);
    WriteHardHelperLog(Format('�Զ����� ���ö��������� %s:%s ', [nReader,nCardNo]));
    if nReader <> '' then
      gHardwareHelper.SetReaderCard(nReader, nCardNo);
    //ģ��ˢ��
  end;
end;

//Date: 2012-12-16
//Parm: ��������
//Desc: ����ҵ���м����Ӳ���ػ��Ľ�������
procedure WhenBusinessMITSharedDataIn(const nData: string);
begin
  WriteHardHelperLog('�յ�Bus_MITҵ������:::' + nData);
  //log data

  if Pos('TruckOut', nData) = 1 then
    MakeTruckAutoOut(Copy(nData, Pos(':', nData) + 1, MaxInt));
  //auto out
end;

//Date: 2015-01-14
//Parm: ���ƺ�;������
//Desc: ��ʽ��nBill��������Ҫ��ʾ�ĳ��ƺ�
function GetJSTruck(const nTruck,nBill: string): string;
var nStr, nSQL, nType: string;
    nLen: Integer;
    nWorker: PDBWorker;
begin
  Result := nTruck;
  if nBill = '' then Exit;

  {$IFDEF LNYK}
  nWorker := nil;
  try
    nStr := 'Select L_StockNo From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nBill]);

    with gDBConnManager.SQLQuery(nStr, nWorker) do
    if RecordCount > 0 then
    begin
      nStr := UpperCase(Fields[0].AsString);
      if nStr <> 'BPC-02' then Exit;
      //ֻ����32.5(b)

      nLen := cMultiJS_Truck - 2;
      Result := 'B-' + Copy(nTruck, Length(nTruck) - nLen + 1, nLen);
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
  {$ENDIF}

  {$IFDEF QJXY}
  nWorker := nil;
  try
    nStr := 'Select L_StockNo From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nBill]);

    with gDBConnManager.SQLQuery(nStr, nWorker) do
    if RecordCount > 0 then
    begin
      nStr := UpperCase(Fields[0].AsString);
      nSQL := 'select * from %s where D_name=''%s'' and D_memo=''%s''';
      nSQL := Format(nSQL,[sTable_SysDict, sFlag_ShowCountType, nStr]);
      with gDBConnManager.WorkerQuery(nWorker, nSQL) do
      begin
        if recordcount = 0 then Exit;
        nType := UpperCase(FieldByName('D_Value').asstring);
        nLen := cMultiJS_Truck - 2;
        Result := nType + Copy(nTruck, Length(nTruck) - nLen + 1, nLen);
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
  {$ENDIF}
end;

//Date: 2013-07-17
//Parm: ������ͨ��
//Desc: ����nTunnel�������
procedure WhenSaveJS(const nTunnel: PMultiJSTunnel);
var nStr: string;
    nDai: Word;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nDai := nTunnel.FHasDone - nTunnel.FLastSaveDai;
  if nDai <= 0 then Exit;
  //invalid dai num

  if nTunnel.FLastBill = '' then Exit;
  //invalid bill

  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Bill'] := nTunnel.FLastBill;
    nList.Values['Dai'] := IntToStr(nDai);

    nStr := PackerEncodeStr(nList.Text);
    CallHardwareCommand(cBC_SaveCountData, nStr, '', @nOut)
  finally
    nList.Free;
  end;
end;

{$IFDEF UseModbusJS}
procedure WhenSaveJSEx(const nTunnel: PJSTunnel);
var nStr: string;
    nDai: Word;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nDai := nTunnel.FHasDone - nTunnel.FLastSaveDai;
  if nDai <= 0 then Exit;
  //invalid dai num

  if nTunnel.FLastBill = '' then Exit;
  //invalid bill

  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Bill'] := nTunnel.FLastBill;
    nList.Values['Dai'] := IntToStr(nDai);

    nStr := PackerEncodeStr(nList.Text);
    CallHardwareCommand(cBC_SaveCountData, nStr, '', @nOut)
  finally
    nList.Free;
  end;
end;
{$ENDIF}

//Date: 2019-03-12
//Parm: ͨ����;��ʾ��Ϣ;���ƺ�
//Desc: ��nTunnel��С������ʾ��Ϣ
//procedure ShowLEDHint(const nTunnel: string; nHint: string;
//  const nTruck: string = ''; const nPlayVoice: Boolean =True);
//var nStr: string;
//begin
//  if nTruck <> '' then
//    nHint := nTruck + StringOfChar(' ', 12 - Length(nTruck)) + nHint;
//  //xxxxx
//  
//  if Length(nHint) > 24 then
//    nHint := Copy(nHint, 1, 24);
//  gERelayManager.ShowTxt(nTunnel, nHint);
//end;

//Date: 2019-03-12
//Parm: ��������;����
//Desc: ����nBill״̬д��nValue����
//function SavePoundData(const nTunnel: PBWTunnel; const nValue: Double;
//                       out nMsg:string): Boolean;
//var nStr, nStatus, nTruck: string;
//    nDBConn: PDBWorker;
//    nPvalue,nDefaultPValue,nPValueWuCha : Double;
//    nList: TStrings;
//    nIdx: Integer;
//begin
//  nDBConn := nil;
//  try
//    Result := False;
//    nStr := 'Select L_Status,L_Value,L_PValue,L_Truck From %s Where L_ID=''%s''';
//    nStr := Format(nStr, [sTable_Bill, nTunnel.FBill]);
//     
//    with gDBConnManager.SQLQuery(nStr, nDBConn) do
//    begin
//      if RecordCount < 1 then
//      begin
//        WriteNearReaderLog(Format('������[ %s ]�Ѷ�ʧ', [nTunnel.FBill]));
//        Exit;
//      end;
//
//      nStatus := FieldByName('L_Status').AsString;
//      nTruck  := FieldByName('L_Truck').AsString;
//      if nStatus = sFlag_TruckIn then //Ƥ��
//      begin
//        //����Ĭ��Ƥ��ֵ
//        nStr := ' Select D_Value from %s  where D_Name = ''%s'' and D_Memo = ''%s''  ';
//        nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam,sFlag_DefaultPValue]);
//        with gDBConnManager.WorkerQuery(nDBConn, nStr) do
//        begin
//          if RecordCount < 1 then
//            nDefaultPValue := 0
//          else
//            nDefaultPValue :=  FieldByName('D_Value').AsFloat;
//        end;
//        //����Ƥ�����¸���ֵ
//        nStr := ' Select D_Value from %s  where D_Name = ''%s'' and D_Memo = ''%s''  ';
//        nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam,sFlag_PValueWuCha]);
//        with gDBConnManager.WorkerQuery(nDBConn, nStr) do
//        begin
//          if RecordCount < 1 then
//            nPValueWuCha := 5
//          else
//            nPValueWuCha :=  FieldByName('D_Value').AsFloat;
//        end;
//
//        //�ж�Ƥ����Ч��
//        nPvalue := 0;
//        nStr := ' Select Top 5 L_PValue from %s  where L_Truck = ''%s'' and L_PValue is not null order by R_ID Desc ';
//        nStr := Format(nStr, [sTable_Bill, nTruck]);
//        with gDBConnManager.WorkerQuery(nDBConn, nStr) do
//        begin
//          if RecordCount < 1 then
//            nPvalue := nDefaultPValue
//          else
//          begin
//            First;
//            while not Eof do
//            begin
//              nPvalue := nPvalue + FieldByName('L_Pvalue').AsFloat;
//              Next;
//            end;
//            nPvalue := nPvalue / RecordCount;
//          end;
//        end;
//        //Ƥ����Ч��Χֵ
//
//        WriteNearReaderLog(nTunnel.FID+'��ʷƽ��Ƥ�أ�'+FloatToStr(nPValue)
//          +'��ǰƤ�أ�'+FloatToStr(nValue)+'������Χ��'+FloatToStr(nPValueWuCha));
//        if nPvalue > 0 then
//        if  (nValue < nPvalue - nPvalueWucha)  or (nValue > nPvalue + nPvalueWucha) then
//        begin
//          nMsg := 'Ƥ���쳣';
//          Exit;
//        end;
//
//        nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckBFP),
//                SF('L_NextStatus', sFlag_TruckFH),
//                SF('L_LadeTime', sField_SQLServer_Now, sfVal),
//                SF('L_PValue', nValue, sfVal),
//                SF('L_PDate', sField_SQLServer_Now, sfVal)
//          ], sTable_Bill, SF('L_ID', nTunnel.FBill), False);
//        gDBConnManager.WorkerExec(nDBConn, nStr);
//
//        gBasisWeightManager.SetTruckPValue(nTunnel.FID, nValue);
//        //����ͨ��Ƥ��, ȷ�ϰ�������
//
//        {$IFDEF HKVDVR}
//        gCameraManager.CapturePicture(nTunnel.FID, nTunnel.FBill);
//        //ץ��
//        {$ENDIF}
//        gERelayManager.LineOpen(nTunnel.FID);
//        //�򿪷Ż�
//        ShowLEDHint(nTunnel.FID, '�뿪ʼװ��', FieldByName('L_Truck').AsString);
//        WriteNearReaderLog(nTunnel.FID + ',' + nTunnel.FBill + '����Ƥ�����,����Ż�');
//        gBasisWeightManager.SetParam(nTunnel.FID, 'CanFH', sFlag_Yes);
//        //��ӿɷŻұ��
//      end else
//      begin
//        nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckBFM),
//                SF('L_NextStatus', sFlag_TruckOut),
//                SF('L_MValue', nValue, sfVal),
//                SF('L_MDate', sField_SQLServer_Now, sfVal)
//          ], sTable_Bill, SF('L_ID', nTunnel.FBill), False);
//        gDBConnManager.WorkerExec(nDBConn, nStr);
//      end; //�Ż�״̬,ֻ��������,����ʱ���㾻��
//    end;
//
//    Result := True;
//  finally
//    gDBConnManager.ReleaseConnection(nDBConn);
//  end;   
//end;

//Date: 2019-03-11
//Parm: ����װ��ͨ��
//Desc: ��nTunnel״̬�ı�ʱ,����ҵ��
procedure WhenBasisWeightStatusChange(const nTunnel: PBWTunnel);
var nStr, nTruck, nMsg: string;
begin
  if nTunnel.FStatusNew = bsProcess then
  begin
    if nTunnel.FWeightMax > 0 then
         nStr := Format('%.2f/%.2f', [nTunnel.FWeightMax, nTunnel.FValTunnel])
    else nStr := Format('%.2f/%.2f', [nTunnel.FValue, nTunnel.FValTunnel]);
    
    gERelayManagerPLC.SendMHeight(nTunnel.FID+'_W',nTunnel.FMHeight, nTunnel.FWeightMax, nTunnel.FValTunnel);
    ShowLEDHint(nTunnel.FID, nStr, nTunnel.FParams.Values['Truck'], False);
    Exit;
  end;

  case nTunnel.FStatusNew of
   bsInit      : WriteNearReaderLog('��ʼ��:' + nTunnel.FID);
   bsNew       : WriteNearReaderLog('�����:' + nTunnel.FID);
   bsStart     : WriteNearReaderLog('��ʼ����:' + nTunnel.FID);
   bsClose     : WriteNearReaderLog('���عر�:' + nTunnel.FID);
   bsDone      : WriteNearReaderLog('�������:' + nTunnel.FID);
   bsStable    : WriteNearReaderLog('����ƽ��:' + nTunnel.FID);
  end; //log

  if nTunnel.FStatusNew = bsClose then
  begin
    ShowLEDHint(nTunnel.FID, 'װ��ҵ��ر�', nTunnel.FParams.Values['Truck']);
    WriteNearReaderLog(nTunnel.FID+'װ��ҵ��ر�');

    gERelayManager.LineClose(nTunnel.FID);
    //ֹͣװ��
    gBasisWeightManager.SetParam(nTunnel.FID, 'CanFH', sFlag_No);
    //֪ͨDCS�ر�װ��
    Exit;
  end;

  if nTunnel.FStatusNew = bsDone then
  begin
    {$IFDEF BasisWeight}
    ShowLEDHint(nTunnel.FID, 'װ����� ���°�');
    gProberManager.OpenTunnel(nTunnel.FID);
    //���̵�
    gProberManager.OpenTunnel(nTunnel.FID + '_Z');
    //�򿪵�բ
    {$IFDEF HKVDVR}
    gCameraManager.CapturePicture(nTunnel.FID, nTunnel.FBill);
    //ץ��
    {$ENDIF}
    {$ELSE}
    ShowLEDHint(nTunnel.FID, 'װ�������ȴ��������');
    WriteNearReaderLog(nTunnel.FID+'װ�������ȴ��������');
    {$ENDIF}
    gERelayManager.LineClose(nTunnel.FID);
    //ֹͣװ��
    gBasisWeightManager.SetParam(nTunnel.FID, 'CanFH', sFlag_No);
    //֪ͨDCS�ر�װ��
    Exit;
  end;

  if nTunnel.FStatusNew = bsStable then
  begin
    {$IFDEF BasisWeight}
    Exit; //�ǿ�׼���,����������
    {$ENDIF}

    if not gProberManager.IsTunnelOK(nTunnel.FID) then
    begin
      nTunnel.FStableDone := False;
      //���������¼�
      ShowLEDHint(nTunnel.FID, '����δͣ��λ ���ƶ�����');
      Exit;
    end;

    ShowLEDHint(nTunnel.FID, '����ƽ��׼���������', '', False);
    WriteNearReaderLog(nTunnel.FID+'����ƽ��׼���������');
                                   
//    if SavePoundData(nTunnel, nTunnel.FValHas, nMsg) then
//    begin
//      gBasisWeightManager.SetParam(nTunnel.FID, 'CanFH', sFlag_Yes);
//      //��ӿɷŻұ��
//
//      if nTunnel.FWeightDone then
//      begin
//        ShowLEDHint(nTunnel.FID, 'ë�ر���������°�.');
//        WriteNearReaderLog(nTunnel.FID+'ë�ر������,���°�');
//        gProberManager.OpenTunnel(nTunnel.FID + '_Z');
//        gProberManager.OpenTunnel(nTunnel.FID);
//        //���̵�
//        {$IFDEF HKVDVR}
//        gCameraManager.CapturePicture(nTunnel.FID, nTunnel.FBill);
//        //ץ��
//        {$ENDIF}
//      end else
//      begin
//        ShowLEDHint(nTunnel.FID, '���������ȴ�װ��.', '', False);
//        WriteNearReaderLog(nTunnel.FID+'�������,��ȴ�װ��');
//      end;
//    end else
//    begin
//      nTunnel.FStableDone := False;
//      //���������¼�
//      if nMsg <> '' then
//      begin
//        ShowLEDHint(nTunnel.FID, nMsg, '', False);
//        WriteNearReaderLog(nTunnel.FID+nMsg);
//      end
//      else
//      begin
//        ShowLEDHint(nTunnel.FID, '����ʧ������ϵ����Ա', '', False);
//        WriteNearReaderLog(nTunnel.FID+'����ʧ�� ����ϵ����Ա');
//      end;
//    end;
  end;
end;

//Date: 2017-8-17
//Parm: ����;ͨ����;����
//Desc: ����ץ����ˢ����Ϣ
procedure SaveGrabCard(const nCard: string; nTunnel: string; nDelete: Boolean);
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Card'] := nCard;
    nList.Values['Tunnel'] := nTunnel;
    IF nDelete then
    nList.Values['Delete'] := sFlag_Yes;

    nStr := nList.Text;
    CallBusinessCommand(cBC_SaveGrabCard, nStr, '', @nOut);
  finally
    nList.Free;
  end;
end;

{$IFDEF UseLBCModbus}
procedure WhenLBCWeightStatusChange(const nTunnel: PLBTunnel);
var
  nStr, nTruck, nMsg: string;
  nList : TStrings;
  nIdx  : Integer;
begin
  if nTunnel.FStatusNew = bsDone then
  begin
    gERelayManager.ShowTxt(nTunnel.FID, 'װ����� ���°�');

    gERelayManager.LineClose(nTunnel.FID);
    Sleep(100);
    WriteNearReaderLog('�������:' + nTunnel.FID + '���ݺţ�' + nTunnel.FBill);
    Exit;
  end;
  
  if nTunnel.FStatusNew = bsProcess then
  begin
    if nTunnel.FWeightMax > 0 then
    begin
      nStr := Format('%.2f/%.2f', [nTunnel.FWeightMax, nTunnel.FValTunnel]);
    end
    else nStr := Format('%.2f/%.2f', [nTunnel.FValue, nTunnel.FValTunnel]);
    
    gERelayManager.ShowTxt(nTunnel.FID, nStr);
    Exit;
  end;

  case nTunnel.FStatusNew of
   bsInit      : WriteNearReaderLog('��ʼ��:' + nTunnel.FID   + '���ݺţ�' + nTunnel.FBill);
   bsNew       : WriteNearReaderLog('�����:' + nTunnel.FID   + '���ݺţ�' + nTunnel.FBill);
   bsStart     : WriteNearReaderLog('��ʼ����:' + nTunnel.FID + '���ݺţ�' + nTunnel.FBill);
   bsClose     : WriteNearReaderLog('���عر�:' + nTunnel.FID + '���ݺţ�' + nTunnel.FBill);
  end; //log

  if nTunnel.FStatusNew = bsClose then
  begin
    gERelayManager.ShowTxt(nTunnel.FID, 'װ��ҵ��ر�');
    WriteNearReaderLog(nTunnel.FID+'װ��ҵ��ر�');
    Exit;
  end;
end;
{$ENDIF}

procedure SetInFactTimeOut(nTime:Integer);
var
  nDBConn: PDBWorker;
  nStr: string;
  nErrNum: Integer;
begin
  nDBConn := nil;
  with gParamManager.ActiveParam^ do
  try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
    if not Assigned(nDBConn) then
    begin
      WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
      Exit;
    end;

    if not nDBConn.FConn.Connected then
      nDBConn.FConn.Connected := True;
    //conn db

    nStr := 'update %s set d_value=%s where D_Name=''%s'' and D_Memo=''%s''';
    nStr := Format(nStr,[sTable_SysDict,IntToStr(nTime),sFlag_SysParam,sFlag_InTimeout]);
    gDBConnManager.WorkerExec(nDBConn, nStr);

    gTruckQueueManager.RefreshParam;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
end;

//Desc: ��nCard���г���
procedure AutoTruckOutFact(const nCard : string);
var nStr,nCardType: string;
begin
  WriteHardHelperLog('�Զ����� '+nCard);
  MakeTruckOut(nCard, '', gSysParam.FOutFactPrint, nStr);
  ///�Զ�����
end;

end.
