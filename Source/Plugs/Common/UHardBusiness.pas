{*******************************************************************************
  作者: dmzn@163.com 2012-4-22
  描述: 硬件动作业务
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
  UMgrRemoteSnap, UMgrERelayPLC, UMgrVoiceNet, IDGlobal,
  UMgrLEDDisp, UMgrRFID102, UBlueReader, UMgrTTCEM100, UMgrSendCardNo,
  UMgrBasisWeight, UMgrPoundTunnels, UMgrTruckProbe;

procedure ShowTextByBXFontCard(nCard, nTitle, nData:string);
procedure WhenReaderCardArrived(const nReader: THHReaderItem);
procedure WhenHYReaderCardArrived(const nReader: PHYReaderItem);
procedure WhenBlueReaderCardArrived(nHost: TBlueReaderHost; nCard: TBlueReaderCard);
//有新卡号到达读头
procedure WhenTTCE_M100_ReadCard(const nItem: PM100ReaderItem);
//票箱读卡器
procedure WhenReaderCardIn(const nCard: string; const nHost: PReaderHost);
//现场读头有新卡号
procedure WhenReaderCardOut(const nCard: string; const nHost: PReaderHost);
//现场读头卡号超时

procedure WhenBusinessMITSharedDataIn(const nData: string);
//业务中间件共享数据
function GetJSTruck(const nTruck,nBill: string): string;
//获取计数器显示车牌
procedure WhenSaveJS(const nTunnel: PMultiJSTunnel);
//保存计数结果
{$IFDEF UseModbusJS}
procedure WhenSaveJSEx(const nTunnel: PJSTunnel);
//modus保存计数结果
{$ENDIF}
procedure SaveGrabCard(const nCard: string; nTunnel: string; nDelete: Boolean);
//保存抓斗称刷卡信息
{$IFDEF UseLBCModbus}
procedure WhenLBCWeightStatusChange(const nTunnel: PLBTunnel);
//链板秤定量装车状态改变
{$ENDIF}
function WhenParsePoundWeight(const nPort: PPTPortItem): Boolean;
//地磅数据解析
procedure WhenBasisWeightStatusChange(const nTunnel: PBWTunnel);
//定量装车状态改变
procedure WhenTruckLineChanged(const nTruckLine: TList);
//通道状态切换
function SavePoundData(const nTunnel: PBWTunnel; const nValue: Double;
                       out nMsg:string): Boolean;

procedure SetInFactTimeOut(nTime:Integer);

procedure AutoTruckOutFact(const nCard : string);
//自动出厂implementation

implementation

uses
  ULibFun, USysDB, USysLoger, UTaskMonitor;

const
  sPost_In   = 'in';
  sPost_Out  = 'out';

  sBlueCard  = 'bluecard';
  sHyCard    = 'hycard';

//Date: 2014-09-15
//Parm: 命令;数据;参数;输出
//Desc: 本地调用业务对象
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
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
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
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
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
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的短倒单据对象
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
//Parm: 命令;数据;参数;输出
//Desc: 调用硬件守护上的业务对象
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
//Parm: 磁卡号;岗位;交货单列表
//Desc: 获取nPost岗位上磁卡为nCard的交货单列表
function GetLadingBills(const nCard,nPost: string;
 var nData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
       AnalyseBillItems(nOut.FData, nData)
  else gSysLoger.AddLog(TBusinessWorkerManager, '业务对象', nOut.FData);
end;

//Date: 2014-09-18
//Parm: 岗位;交货单列表
//Desc: 保存nPost岗位上的交货单数据
function SaveLadingBills(const nPost: string; nData: TLadingBillItems): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessSaleBill(cBC_SavePostBills, nStr, nPost, @nOut);

  if not Result then
    gSysLoger.AddLog(TBusinessWorkerManager, '业务对象', nOut.FData);
  //xxxxx
end;

//Date: 2015-08-06
//Parm: 磁卡号
//Desc: 获取磁卡使用类型
function GetCardUsed(const nCard: string; var nCardType: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetCardUsed, nCard, '', @nOut);

  if Result then
       nCardType := nOut.FData
  else gSysLoger.AddLog(TBusinessWorkerManager, '业务对象', nOut.FData);
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
//Parm: 磁卡号;岗位;采购单列表
//Desc: 获取nPost岗位上磁卡为nCard的交货单列表
function GetLadingOrders(const nCard,nPost: string;
 var nData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_GetPostOrders, nCard, nPost, @nOut);
  if Result then
       AnalyseBillItems(nOut.FData, nData)
  else gSysLoger.AddLog(TBusinessWorkerManager, '业务对象', nOut.FData);
end;

//Date: 2019-4-25
//Parm: 提货单号;装车线ID;物料编码
//Desc: 更新所属库位
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
//Parm: 岗位;采购单列表
//Desc: 保存nPost岗位上的采购单数据
function SaveLadingOrders(const nPost: string; nData: TLadingBillItems): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessPurchaseOrder(cBC_SavePostOrders, nStr, nPost, @nOut);

  if not Result then
    gSysLoger.AddLog(TBusinessWorkerManager, '业务对象', nOut.FData);
  //xxxxx
end;

//Date: 2017-10-24
//Parm: 磁卡号;岗位;短倒单列表
//Desc: 获取nPost岗位上磁卡为nCard的短倒单列表
function GetDuanDaoItems(const nCard,nPost: string;
 var nData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessDuanDao(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
       AnalyseBillItems(nOut.FData, nData)
  else gSysLoger.AddLog(TBusinessWorkerManager, '业务对象', nOut.FData);
end;

//Date: 2017-10-24
//Parm: 岗位;短倒单列表
//Desc: 保存nPost岗位上的短倒单数据
function SaveDuanDaoItems(const nPost: string; nData: TLadingBillItems): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessDuanDao(cBC_SavePostBills, nStr, nPost, @nOut);

  if not Result then
    gSysLoger.AddLog(TBusinessWorkerManager, '业务对象', nOut.FData);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Date: 2013-07-21
//Parm: 事件描述;岗位标识
//Desc:
procedure WriteHardHelperLog(const nEvent: string; nPost: string = '');
begin
  gDisplayManager.Display(nPost, nEvent);
  gSysLoger.AddLog(THardwareHelper, '硬件守护辅助', nEvent);
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
      WriteHardHelperLog('蓝卡读卡器抬杆:' + nReader);
    end
    else
    if (nReaderType = sHyCard)or
        (nReaderType = '') then
    begin
      gHYReaderManager.OpenDoor(nReader);
      WriteHardHelperLog('华益读卡器抬杆:' + nReader);
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

//Date: 2017-10-16
//Parm: 内容;岗位;业务成功
//Desc: 发送HKLED 小屏显示
procedure MakeGateHKLEDDisplay(const nText,nPost: string; const nSucc: Boolean);
var nStr: string;
    nInt: Integer;
begin
  try
    if nSucc then
         nInt := 2
    else nInt := 3;

    gHKSnapHelper.Display(nPost, nText, nInt);
    //小屏显示
    WriteHardHelperLog('发送海康 '+nPost+' 小屏：' + nText);
  except
    on nErr: Exception do
    begin
      nStr := '发送海康小屏[ %s ]显示失败,描述: %s';
      nStr := Format(nStr, [nPost, nErr.Message]);
      WriteHardHelperLog(nStr);
    end;
  end;
end;

//Date: 2012-4-22
//Parm: 卡号
//Desc: 对nCard放行进厂
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
  end; //同读头同卡,在2分钟内不做二次进厂业务.

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
    nStr := '读取磁卡[ %s ]订单信息失败.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_In);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '磁卡[ %s ]没有需要进厂车辆.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_In);
    Exit;
  end;
  
  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if gTruckQueueManager.IsFobiddenInMul then//禁止多次进厂
    begin
      if FStatus = sFlag_TruckNone then Continue;
      //未进厂
    end
    else
    begin
      if (FStatus = sFlag_TruckNone) or (FStatus = sFlag_TruckIn) then Continue;
      //未进厂,或已进厂
    end;

    nStr := '车辆[ %s ]下一状态为:[ %s ],进厂刷卡无效.';
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
  nStr := nMsg + ',请进厂';
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
        //抬杆
      {$ENDIF}
    end else
    begin
      if gTruckQueueManager.TruckReInfactFobidden(nTrucks[0].FTruck) then
      begin
        BlueOpenDoor(nReader, nReaderType);
        //抬杆

        nStr := '车辆[ %s ]再次抬杆操作.';
        nStr := Format(nStr, [nTrucks[0].FTruck]);
        WriteHardHelperLog(nStr, sPost_In);
      end;
    end;

    if nCardType = sFlag_DuanDao then
    begin
      nStr := '%s进厂';
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
      nStr := '车辆[ %s ]进厂放行失败.';
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
      //抬杆
    end;

//    nStr := '原材料卡[%s]进厂抬杆成功';
//    nStr := Format(nStr, [nCard]);
//    WriteHardHelperLog(nStr, sPost_In);

    nStr := '%s磁卡[%s]进厂抬杆成功';
    nStr := Format(nStr, [BusinessToStr(nCardType), nCard]);
    WriteHardHelperLog(nStr, sPost_In);

    if nCardType = sFlag_DuanDao then
    begin
      nStr := '%s进厂';
      nStr := Format(nStr, [nTrucks[0].FTruck]);
      WriteHardHelperLog(nStr, sPost_In);
      gDisplayManager.Display(nReader, nStr);
    end;
    Exit;
  end;
  //采购磁卡直接抬杆

  nPLine := nil;
  //nPTruck := nil;

  with gTruckQueueManager do
  if not IsDelayQueue then //非延时队列(厂内模式)
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
      nStr := '车辆[ %s ]没有在调度队列中.';
      nStr := Format(nStr, [nTrucks[0].FTruck]);

      WriteHardHelperLog(nStr, sPost_In);
      Exit;
    end;
  finally
    SyncLock.Leave;
  end;

  if not SaveLadingBills(sFlag_TruckIn, nTrucks) then
  begin
    nStr := '车辆[ %s ]进厂放行失败.';
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
    //抬杆
  end;

  with gTruckQueueManager do
  if not IsDelayQueue then //厂外模式,进厂时绑定道号(一车多单)
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
      //绑定通道
    end;
  finally
    SyncLock.Leave;
  end;
end;


//Date: 2012-4-22
//Parm: 卡号;读头;打印机;化验单打印机
//Desc: 对nCard放行出厂
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
  WriteHardHelperLog('MakeTruckOut 进入, 打印机:'+nPrinter+'、'+nHYPrinter+' 读卡器：'+nReader+' 卡号:'+nCard +' 小屏:'+ nBxCardNo );
  if not GetCardUsed(nCard, nCardType) then Exit;

  if nCardType = sFlag_Provide then
    nRet := GetLadingOrders(nCard, sFlag_TruckOut, nTrucks) else
  if nCardType = sFlag_Sale then
    nRet := GetLadingBills(nCard, sFlag_TruckOut, nTrucks) else
  if nCardType = sFlag_DuanDao then
    nRet := GetDuanDaoItems(nCard, sFlag_TruckOut, nTrucks) else nRet := False;

  if not nRet then
  begin
    nStr := '读取磁卡[ %s ]订单信息失败.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_Out);
    {$IFDEF UseBXFontLED}
    ShowTextByBXFontCard(nBxCardNo, '', nStr);
    {$ENDIF}
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '磁卡[ %s ]没有需要出厂车辆.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_Out);
    {$IFDEF UseBXFontLED}
    ShowTextByBXFontCard(nBxCardNo, '', nStr);
    {$ENDIF}
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if FNextStatus = sFlag_TruckOut then Continue;
    nStr := '车辆[ %s ]下一状态为:[ %s ],无法出厂.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);

    WriteHardHelperLog(nStr, sPost_Out);
    {$IFDEF UseBXFontLED}
    ShowTextByBXFontCard(nBxCardNo, '', nStr);
    {$ENDIF}
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
    nStr := '车辆[ %s ]出厂放行失败.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteHardHelperLog(nStr, sPost_Out);
    {$IFDEF UseBXFontLED}
    ShowTextByBXFontCard(nBxCardNo, '', nStr);
    {$ENDIF}
    Exit;
  end;


  if (nReader <> '') then
    BlueOpenDoor(nReader, nReaderType); //抬杆
  Result := True;

  {$IFDEF JZZJ}
  nBxCardNo:= 'EastOut';
  if nReader = 'VY192168026045' then nBxCardNo:= 'WestOut';
  {$ENDIF}
  {$IFDEF UseBXFontLED}
  nStr := '\C3%s \C1请出厂,祝您一路顺风,欢迎您再次光临.';
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
    //磁卡类型
    if nHYPrinter <> '' then
      nStr := nStr + #6 + nHYPrinter;
    //化验单打印机
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
  end; //打印报表
end;

//Date: 2012-10-19
//Parm: 卡号;读头
//Desc: 检测车辆是否在队列中,决定是否抬杆
procedure MakeTruckPassGate(const nCard,nReader: string; const nDB: PDBWorker;
                            const nReaderType: string = '');
var nStr: string;
    nIdx: Integer;
    nTrucks: TLadingBillItems;
begin
  if not GetLadingBills(nCard, sFlag_TruckOut, nTrucks) then
  begin
    nStr := '读取磁卡[ %s ]交货单信息失败.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '磁卡[ %s ]没有需要通过道闸的车辆.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  if gTruckQueueManager.TruckInQueue(nTrucks[0].FTruck) < 0 then
  begin
    nStr := '车辆[ %s ]不在队列,禁止通过道闸.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  BlueOpenDoor(nReader, nReaderType);
  //抬杆

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  begin
    nStr := 'Update %s Set T_InLade=%s Where T_Bill=''%s'' And T_InLade Is Null';
    nStr := Format(nStr, [sTable_ZTTrucks, sField_SQLServer_Now, nTrucks[nIdx].FID]);

    gDBConnManager.WorkerExec(nDB, nStr);
    //更新提货时间,语音程序将不再叫号.
  end;
end;

//Date: 2019-10-26
//Parm: 卡号;读头
//Desc: 抬杆同时生成过闸记录
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
      nStr := '读取通行卡[ %s ]信息失败.';
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
    nStr := '通行卡[ %s ]车辆[ %s ]在读卡器[ %s ]不能通过,上次通过时间为[ %s ],等待间隔为[ %d ]分.';
    nStr := Format(nStr, [nCard, nTruck, nReader, DateTime2Str(nLastTime), nWait]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  nStr := Format('C_Card=''%s''', [nCard]);
  nStr := MakeSQLByStr([
          SF('C_LastDate', sField_SQLServer_Now, sfVal)
          ], sTable_Card, nStr, False);
  gDBConnManager.WorkerExec(nDB, nStr);

  nStr := '通行卡[ %s ]车辆[ %s ]在读卡器[ %s ]通过,通过时间为[ %s ].';
  nStr := Format(nStr, [nCard, nTruck, nReader, DateTime2Str(Now)]);
  WriteHardHelperLog(nStr);

  if nSaveData <> sFlag_Yes then
  begin
    BlueOpenDoor(nReader, nReaderType);
    //抬杆
    Exit;
  end;

  nStr := MakeSQLByStr([SF('C_Card', nCard),
          SF('C_Truck', nTruck),
          SF('C_Reader', nReader),
          SF('C_Date', sField_SQLServer_Now, sfVal)
          ], sTable_TruckCross, '', True);
  gDBConnManager.WorkerExec(nDB, nStr);

  BlueOpenDoor(nReader, nReaderType);
  //抬杆
end;

//Date: 2012-4-22
//Parm: 读头数据
//Desc: 对nReader读到的卡号做具体动作
procedure WhenReaderCardArrived(const nReader: THHReaderItem);
var nStr,nCard,nReaderType: string;
    nErrNum: Integer;
    nDBConn: PDBWorker;
begin
  nDBConn := nil;
  {$IFDEF DEBUG}
  WriteHardHelperLog('WhenReaderCardArrived进入.');
  {$ENDIF}

  with gParamManager.ActiveParam^ do
  try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
    if not Assigned(nDBConn) then
    begin
      WriteHardHelperLog('连接HM数据库失败(DBConn Is Null).');
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
      nStr := Format('磁卡号[ %s ]匹配失败.', [nReader.FCard]);
      WriteHardHelperLog(nStr);
      Exit;
    end;

    if Assigned(nReader.FOptions) then
         nReaderType := nReader.FOptions.Values['ReaderType']
    else nReaderType := '';

    try
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
        //抬杆
      end
      {$IFDEF PoundBlueOpen}
      else
      if nReader.FTYpe = rtPound then
      begin
        WriteHardHelperLog('过磅抬杆.');
        if nReader.FID <> '' then
          BlueOpenDoor(nReader.FID, nReaderType);
        //抬杆
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
        //抬杆
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
//Parm: 读头数据
//Desc: 华益读头磁卡动作
procedure WhenHYReaderCardArrived(const nReader: PHYReaderItem);
var nIdx: Integer;
begin
  {$IFDEF DEBUG}
  WriteHardHelperLog(Format('华益标签 %s:%s', [nReader.FTunnel, nReader.FCard]));
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
  WriteHardHelperLog(Format('蓝卡读卡器 %s:%s', [nHost.FReaderID, nCard.FCard]));
  {$ENDIF}

  gHardwareHelper.SetReaderCard(nHost.FReaderID, nCard.FCard, False);
end;

//Date: 2018-01-08
//Parm: 三合一读卡器
//Desc: 处理三合一读卡器信息
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
  nStr := '三合一读卡器卡号'  + nItem.FID + ' ::: ' + nItem.FCard;
  WriteHardHelperLog(nStr);
  {$ENDIF}

  try
    if not nItem.FVirtual then Exit;
    if nItem.FVType = rtOutM100 then
    begin
      nRetain := MakeTruckOut(nItem.FCard, nItem.FVReader, nItem.FVPrinter,
                              nItem.FVHYPrinter,'',nItem.FBxCardNo);
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
              WriteHardHelperLog('连接HM数据库失败(DBConn Is Null).');
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
          WriteHardHelperLog('吞卡机:'+ nItem.FID +' 卡类型:'+nCType+' 动作: 吞卡')
        else
          WriteHardHelperLog('吞卡机:'+ nItem.FID +' 卡类型:'+nCType+' 动作: 吞卡后吐卡');
    end else
    begin
      gHardwareHelper.SetReaderCard(nItem.FVReader, nItem.FCard, False);
    end;
  finally
    gM100ReaderManager.DealtWithCard(nItem, nRetain)
  end;
end;

//------------------------------------------------------------------------------
procedure WriteNearReaderLog(const nEvent: string);
begin
  gSysLoger.AddLog(T02NReader, '现场近距读卡器', nEvent);
end;

// 发送网口小屏显示信息
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

    WriteNearReaderLog(Format('向网口小屏 %s 发送 %s %s', [nCard, nTitle, nData]));

    if Pos('ZT',nCard)>0 then
      gBXFontCardManager.Display(nTitle, nData, nCard, 3600, 3600, @nTitleM, @nDataM)
    else gBXFontCardManager.Display(nTitle, nData, nCard, 3, 60, @nTitleM, @nDataM);
  end
  else WriteNearReaderLog('网口小屏管理器不存在');
end;

//Date: 2012-4-24
//Parm: 车牌;通道;是否检查先后顺序;提示信息
//Desc: 检查nTuck是否可以在nTunnel装车
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
      nHint := Format('通道[ %s ]无效.', [nTunnel]);
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
        //不在当前队列
        if not StockMatch(nPLine.FStockNo, nLineItem) then Continue;
        //刷卡道与队列道品种不匹配

        nIdx := nPLine.FTrucks.Add(nLineItem.FTrucks[nInt]);
        nLineItem.FTrucks.Delete(nInt);
        //挪动车辆到新道

        nHint := 'Update %s Set T_Line=''%s'' ' +
                 'Where T_Truck=''%s'' And T_Line=''%s''';
        nHint := Format(nHint, [sTable_ZTTrucks, nPLine.FLineID, nTruck,
                nLineItem.FLineID]);
        gTruckQueueManager.AddExecuteSQL(nHint);

        nHint := '车辆[ %s ]自主换道[ %s->%s ]';
        nHint := Format(nHint, [nTruck, nLineItem.FName, nPLine.FName]);
        WriteNearReaderLog(nHint);
        Break;
      end;
    end;
    //袋装重调队列

    if nIdx < 0 then
    begin
      nHint := Format('车辆[ %s ]不在[ %s ]队列中.', [nTruck, nPLine.FName]);
      Exit;
    end;

    nPTruck := nPLine.FTrucks[nIdx];
    nPTruck.FStockName := nPLine.FName;
    //同步物料名
    Result := True;
  finally
    SyncLock.Leave;
  end;
end;

//Date: 2013-1-21
//Parm: 通道号;交货单;
//Desc: 在nTunnel上打印nBill防伪码
function PrintBillCode(const nTunnel,nBill: string; var nHint: string): Boolean;
var nStr: string;
    nTask: Int64;
    nOut: TWorkerBusinessCommand;
begin
  Result := True;

  {$IFNDEF UseModbusJS}
  if not gMultiJSManager.CountEnable then Exit;
  {$ENDIF}

  nTask := gTaskMonitor.AddTask('UHardBusiness.PrintBillCode', cTaskTimeoutLong);
  //to mon
  
  if not CallHardwareCommand(cBC_PrintCode, nBill, nTunnel, @nOut) then
  begin
    nStr := '向通道[ %s ]发送防违流码失败,描述: %s';
    nStr := Format(nStr, [nTunnel, nOut.FData]);  
    WriteNearReaderLog(nStr);
  end;

  gTaskMonitor.DelTask(nTask, True);
  //task done
end;

//Date: 2012-4-24
//Parm: 车牌;通道;交货单;启动计数
//Desc: 对在nTunnel的车辆开启计数器
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
      nHint := Format('通道[ %s ]无效.', [nTunnel]);
      Exit;
    end;

    nPLine := Lines[nIdx];
    nIdx := TruckInLine(nTruck, nPLine.FTrucks);

    if nIdx < 0 then
    begin
      nHint := Format('车辆[ %s ]已不再队列.', [nTruck]);
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
//Parm: 交货单号
//Desc: 查询nBill上的已装量
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
      WriteNearReaderLog('连接HM数据库失败(DBConn Is Null).');
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

//Date: 2019-03-12
//Parm: 通道号;提示信息;车牌号
//Desc: 在nTunnel的小屏上显示信息
procedure ShowLEDHint(const nTunnel: string; nHint: string;
  const nTruck: string = '');
var nStr: string;
begin
  if nTruck <> '' then
    nHint := nTruck + StringOfChar(' ', 12 - Length(nTruck)) + nHint;
  //xxxxx
  
  if Length(nHint) > 24 then
    nHint := Copy(nHint, 1, 24);

  {$IFDEF UseERelayPLC}
      gERelayManagerPLC.ShowText(nTunnel, nHint);
      WriteNearReaderLog(Format('发送 gERelayManagerPLC 通道 %s 小屏显示：%s.', [nTunnel, nHint]));
  {$ELSE}
      {$IFDEF BasisWeightTruckProber}
        gProberManager.ShowTxt(nTunnel, nHint);
      {$ELSE}
        gERelayManager.ShowTxt(nTunnel, nHint);
      {$ENDIF}
  {$ENDIF}
end;

//Date: 2012-4-24
//Parm: 磁卡号;通道号
//Desc: 对nCard执行袋装装车操作
procedure MakeTruckLadingDai(const nCard: string; nTunnel: string);
var nStr: string;
    nIdx,nInt: Integer;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;

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
        nStr := '通道[ %s ]装车中,业务无效.';
        nStr := Format(nStr, [nTunnel]);
        WriteNearReaderLog(nStr);
      end;
    end;
begin
  WriteNearReaderLog('通道[ ' + nTunnel + ' ]: MakeTruckLadingDai进入.');
    //666666暂时屏蔽
  if IsJSRun then Exit;
  //tunnel is busy

  if not GetLadingBills(nCard, sFlag_TruckZT, nTrucks) then
  begin
    nStr := '读取磁卡[ %s ]交货单信息失败.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '磁卡[ %s ]没有需要栈台提货车辆.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if nTunnel = '' then
  begin
    nTunnel := gTruckQueueManager.GetTruckTunnel(nTrucks[0].FTruck);
    //重新定位车辆所在车道
    if IsJSRun then Exit;
  end;
  
  if not IsTruckInQueue(nTrucks[0].FTruck, nTunnel, False, nStr,
         nPTruck, nPLine, sFlag_Dai) then
  begin
    WriteNearReaderLog(nStr);
    Exit;
  end; //检查通道

  nStr := '';
  nInt := 0;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if {$IFNDEF DaiOnceLade} (FStatus = sFlag_TruckZT) or {$ENDIF} (FNextStatus = sFlag_TruckZT) then
    begin
      FSelected := Pos(FID, nPTruck.FHKBills) > 0;
      if FSelected then Inc(nInt); //刷卡通道对应的交货单
      Continue;
    end;

    FSelected := False;
    nStr := '车辆[ %s ]下一状态为:[ %s ],无法栈台提货.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);
  end;

  if nInt < 1 then
  begin
    WriteHardHelperLog(nStr);
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if not FSelected then Continue;
    if FStatus <> sFlag_TruckZT then Continue;

    nStr := '袋装车辆[ %s ]再次刷卡装车.';
    nStr := Format(nStr, [nPTruck.FTruck]);
    WriteNearReaderLog(nStr);

    if not TruckStartJS(nPTruck.FTruck, nTunnel, nPTruck.FBill, nStr,
       GetHasDai(nPTruck.FBill) < 1) then
      WriteNearReaderLog(nStr);
    Exit;
  end;

  if not SaveLadingBills(sFlag_TruckZT, nTrucks) then
  begin
    nStr := '车辆[ %s ]栈台提货失败.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if not TruckStartJS(nPTruck.FTruck, nTunnel, nPTruck.FBill, nStr) then
    WriteNearReaderLog(nStr);
  Exit;
end;

//Date: 2017-10-16
//Parm: 内容;岗位;业务成功
//Desc: 播放门岗语音
procedure MakeGateSound(const nText,nPost: string);
var nStr: string;
    nInt: Integer;
begin
  if (nPost='')or(nText='') then Exit;
  try
    if gNetVoiceHelper=nil then Exit;

    gNetVoiceHelper.PlayVoice(nText, nPost);
    //播发语音
    WriteHardHelperLog(Format('发送语音[%s %s]', [nPost ,nText]));
  except
    on nErr: Exception do
    begin
      nStr := '播放[ %s ]语音失败,描述: %s';
      nStr := Format(nStr, [nPost, nErr.Message]);
      WriteHardHelperLog(nStr);
    end;
  end;
end;

//Date: 2019-03-12
//Parm: 车辆;通道;皮重
//Desc: 授权nTruck在nTunnel车道放灰
procedure TruckStartFHEx(const nTruck: PTruckItem; const nTunnel: string;
 const nLading: TLadingBillItem);
var nStr: string;
begin

  gERelayManager.LineOpen(nTunnel);
  //开始放灰
  WriteNearReaderLog(Format('为车辆 %s 开启定量装车通道 %s 作业', [nTruck.FTruck, nTunnel]) );

  nStr := Format('Truck=%s', [nTruck.FTruck]);
  gBasisWeightManager.StartWeight(nTunnel, nTruck.FBill, nTruck.FValue,
    nLading.FPData.FValue, nStr);
  //开始定量装车

  if nLading.FStatus <> sFlag_TruckIn then
    gBasisWeightManager.SetParam(nTunnel, 'CanFH', sFlag_Yes);
  //添加可放灰标记
end;

//Date: 2019-03-12
//Parm: 磁卡号;通道号
//Desc: 对nCard执行称量操作
procedure MakeTruckWeightFirst(const nCard,nTunnel: string;nVoiceID:string='');
var nStr: string;
    nIdx: Integer;
    nPound: TBWTunnel;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
begin
  WriteNearReaderLog('MakeTruckWeightFirst进入. '+ nTunnel+' '+nVoiceID);

  if not GetLadingBills(nCard, sFlag_TruckFH, nTrucks) then
  begin
    nStr := '读取磁卡[ %s ]交货单信息失败.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    ShowLEDHint(nTunnel, '读取交货单信息失败', nTrucks[0].FTruck);
    MakeGateSound('读取交货单信息失败', nVoiceID);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '磁卡[ %s ]没有需要装料车辆.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    ShowLEDHint(nTunnel, '没有需要装料车辆', nTrucks[0].FTruck);
    MakeGateSound(nStr, nVoiceID);
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if FStatus = sFlag_TruckNone then
    begin
      ShowLEDHint(nTunnel, '请进厂刷卡', nTrucks[0].FTruck);
      MakeGateSound(Format('%s 请到进厂点刷卡', [nTrucks[0].FTruck]), nVoiceID);
      Exit;
    end
    {$IFNDEF BasisWeightWithPM}
    else if (FStatus <> sFlag_TruckBFP)and
              (FStatus <> sFlag_TruckFH) then
    begin
      nStr := ' %s 不能装车，需先到计量地磅过皮重.';
      nStr := Format(nStr, [nTrucks[0].FTruck]);
      WriteNearReaderLog(nStr);

      nStr := Format('请 %s 到计量地磅称皮重', [nTrucks[0].FTruck]);
      ShowLEDHint(nTunnel, nStr);
      MakeGateSound(nStr, nVoiceID);
      Exit;
    end
    {$ENDIF}
    else WriteNearReaderLog(Format('收到车道 %s 车辆 %s 刷卡装车', [nTunnel, nTrucks[nIdx].FTruck]));
  end;

  if gBasisWeightManager.IsTunnelBusy(nTunnel, @nPound) and
     (nPound.FBill <> nTrucks[0].FID) then //通道忙
  begin
    if nPound.FValTunnel = 0 then //前车已下磅
    begin
      nStr := Format('%s 请等待前车', [nTrucks[0].FTruck]);
      ShowLEDHint(nTunnel, nStr);
      MakeGateSound(nStr, nVoiceID);
      Exit;
    end;
  end;

  if not IsTruckInQueue(nTrucks[0].FTruck, nTunnel, False, nStr,
         nPTruck, nPLine, sFlag_San) then
  begin
    WriteNearReaderLog(nStr);

    nStr := Format('%s 请换道装车', [nTrucks[0].FTruck]);
    ShowLEDHint(nTunnel, '请换道装车', nTrucks[0].FTruck);
    MakeGateSound(nStr, nVoiceID);
    Exit;
  end; //检查通道

  if nTrucks[0].FStatus = sFlag_TruckIn then
  begin
    nStr := '车辆[ %s ]刷卡,等待称皮重.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);
    WriteNearReaderLog(nStr);

    nStr := Format('请 %s 上磅称量皮重', [nTrucks[0].FTruck]);
    ShowLEDHint(nTunnel, nStr);
    MakeGateSound(nStr, nVoiceID);
  end else
  begin
    if nPound.FValTunnel > 0 then
         nStr := '请 %s 上磅装车'
    else nStr := '请 %s 开始装车';

    nStr := Format(nStr, [nTrucks[0].FTruck]);
    ShowLEDHint(nTunnel, nStr, nTrucks[0].FTruck);
    MakeGateSound(nStr, nVoiceID);
  end;

  {$IFDEF SaveBillStatusFH}
  if (nTrucks[0].FStatus=sFlag_TruckBFP) then
  if not SaveLadingBills(sFlag_TruckFH, nTrucks) then
  begin
    nStr := '车辆[ %s ]放灰处提货失败.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;
  {$ENDIF}
  TruckStartFHEx(nPTruck, nTunnel, nTrucks[0]);
  //执行放灰
end;

//Date: 2012-4-25
//Parm: 车辆;通道
//Desc: 授权nTruck在nTunnel车道放灰
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
  //打开放灰
  nStr := Format('%s 开启放灰.' , [nTunnel]);
  WriteNearReaderLog(nStr);

  {$IFDEF UseLBCModbus}
  gModBusClient.StartWeight(nTunnel, nTruck.FBill, nTruck.FValue);
  //开始定量装车
  {$ENDIF}

  nStr := nTruck.FTruck + StringOfChar(' ', 12 - Length(nTruck.FTruck));
  nTmp := nTruck.FStockName + FloatToStr(nTruck.FValue);
  nStr := nStr + nTruck.FStockName + StringOfChar(' ', 12 - Length(nTmp)) +
          FloatToStr(nTruck.FValue);
  //xxxxx
  gERelayManager.ShowTxt(nTunnel, nStr);
  //显示内容
end;

//Date: 2012-4-25
//Parm: 车辆;通道
//Desc: 授权nTruck在nTunnel车道放灰
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
  gBasisWeightManager.StartWeight(nTunnel, nTruck.FBill, nTruck.FValue,
    nLading.FPData.FValue, nStr);
  //开始定量装车

  if nLading.FStatus <> sFlag_TruckIn then
    gBasisWeightManager.SetParam(nTunnel, 'CanFH', sFlag_Yes);
  //添加可放灰标记

  if (nLading.FStatus = sFlag_TruckFH) or (nLading.FStatus = sFlag_TruckBFM)
   or (nLading.FNextStatus = sFlag_TruckFH)then
  begin
    gERelayManager.LineOpen(nTunnel);
    //打开放灰
    ShowLEDHint(nTunnel, '请开始装车', nTruck.FTruck);
    gBasisWeightManager.SetParam(nTunnel, 'CanFH', sFlag_Yes);
    //添加可放灰标记
  end;
  gProberManager.OpenTunnel(nTunnel);
  //红绿灯
end;

//Date: 2012-4-24
//Parm: 磁卡号;通道号
//Desc: 对nCard执行袋装装车操作
procedure MakeTruckLadingSan(const nCard,nTunnel,IsLBC,IsZZC: string);
var nStr: string;
    nIdx: Integer;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
begin
  WriteNearReaderLog('MakeTruckLadingSan进入.');

  if not GetLadingBills(nCard, sFlag_TruckFH, nTrucks) then
  begin
    nStr := '读取磁卡[ %s ]交货单信息失败.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '磁卡[ %s ]没有需要放灰车辆.';
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
    //过重后允许返回(状态回溯至成皮重,防止过快出厂)
    {$ENDIF}

    if (FStatus = sFlag_TruckFH) or (FNextStatus = sFlag_TruckFH) then Continue;
    //未装或已装

    nStr := '车辆[ %s ]下一状态为:[ %s ],无法放灰.';
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
    nStr := nTrucks[0].FTruck + StringOfChar(' ',12 - nIdx) + '请换库装车';
    gERelayManager.ShowTxt(nTunnel, nStr);
    Exit;
  end; //检查通道
  {$IFDEF StockKuWeiEx}
  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    SaveStockKuWei(FID, nTunnel, FStockNo);
  end;
  {$ENDIF}

  if nTrucks[0].FStatus = sFlag_TruckFH then
  begin
    nStr := '%s 散装车辆[ %s ]再次刷卡装车.';
    nStr := Format(nStr, [nTunnel, nTrucks[0].FTruck]);
    WriteNearReaderLog(nStr);

    TruckStartFH(nPTruck, nTunnel);

    {$IFDEF FixLoad}
    WriteNearReaderLog('启动定置装车::'+nTunnel+'@'+nCard);
    //发送卡号和通道号到定置装车服务器
    gSendCardNo.SendCardNo(nTunnel+'@'+nCard);
    {$ENDIF}

    Exit;
  end;

  if not SaveLadingBills(sFlag_TruckFH, nTrucks) then
  begin
    nStr := '% 车辆[ %s ]放灰处提货失败.';
    nStr := Format(nStr, [nTunnel, nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  TruckStartFH(nPTruck, nTunnel);
  //执行放灰
  {$IFDEF FixLoad}
  WriteNearReaderLog('启动定置装车::'+nTunnel+'@'+nCard);
  //发送卡号和通道号到定置装车服务器
  gSendCardNo.SendCardNo(nTunnel+'@'+nCard);
  {$ENDIF}
end;

//Date: 2012-4-24
//Parm: 主机;卡号
//Desc: 对nHost.nCard新到卡号作出动作
procedure WhenReaderCardIn(const nCard: string; const nHost: PReaderHost);
var nStr: string;
    nIsLBC,nIsZZC:string;
begin
  if nHost.FType = rtOnce then
  begin
    if nHost.FFun = rfOut then
    begin
      if Assigned(nHost.FOptions) then
           nStr := nHost.FOptions.Values['HYPrinter']
      else nStr := '';
      MakeTruckOut(nCard, '', nHost.FPrinter, nStr);
    end else
    begin
      MakeTruckLadingDai(nCard, nHost.FTunnel);
    end;
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

      if nHost.FOptions.Values['IsBasisWeight'] = sFlag_Yes then
      begin
        MakeTruckWeightFirst(nCard, nHost.FTunnel, nHost.FOptions.Values['VoiceCard']);

        gBasisWeightManager.SetParam(nHost.FTunnel, 'LEDText', nHost.FLEDText, True);
        //附加参数
        Exit;
      end;
    end;
    if Assigned(nHost.FOptions) then
         nIsLBC := nHost.FOptions.Values['IsLBC']
    else nIsLBC := 'N';

    if Assigned(nHost.FOptions) then
         nIsZZC := nHost.FOptions.Values['IsZZC']
    else nIsZZC := 'N';

    {$IFDEF BasisWeightWithPM}
    if Assigned(nHost.FOptions) then
    begin
      if nHost.FOptions.Values['BasisWeight'] = sFlag_Yes then
      begin
        WriteHardHelperLog('开始进入定量装车');
        MakeTruckWeightFirst(nCard, nHost.FTunnel);
        Exit;
      end;
    end;
    MakeTruckLadingSan(nCard, nHost.FTunnel, nIsLBC, nIsZZC);
    {$ELSE}
    MakeTruckLadingSan(nCard, nHost.FTunnel, nIsLBC, nIsZZC);
    {$ENDIF}

    gBasisWeightManager.SetParam(nHost.FTunnel, 'LEDText', nHost.FLEDText, True);
    //附加参数
  end;
end;

//Date: 2012-4-24
//Parm: 主机;卡号
//Desc: 对nHost.nCard超时卡作出动作
procedure WhenReaderCardOut(const nCard: string; const nHost: PReaderHost);
begin
  {$IFDEF DEBUG}
  WriteHardHelperLog('WhenReaderCardOut退出.');
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
  WriteHardHelperLog('停止定置装车::'+nHost.FTunnel+'@Close');
  //发送卡号和通道号到定置装车服务器
  gSendCardNo.SendCardNo(nHost.FTunnel+'@Close');
  {$ENDIF}

  {$IFDEF BasisWeightWithPM}
  gBasisWeightManager.StopWeight(nHost.FTunnel);
  {$ENDIF}
  
  if nHost.FETimeOut then
       gERelayManager.ShowTxt(nHost.FTunnel, '电子标签超出范围')
  else gERelayManager.ShowTxt(nHost.FTunnel, nHost.FLEDText);
  Sleep(100);
end;

//------------------------------------------------------------------------------
//Date: 2012-12-16
//Parm: 磁卡号
//Desc: 对nCardNo做自动出厂(模拟读头刷卡)
procedure MakeTruckAutoOut(const nCardNo: string);
var nReader: string;
begin
  if gTruckQueueManager.IsTruckAutoOut then
  begin
    nReader := gHardwareHelper.GetReaderLastOn(nCardNo);
    WriteHardHelperLog(Format('自动出厂 设置读卡器卡号 %s:%s ', [nReader,nCardNo]));
    if nReader <> '' then
      gHardwareHelper.SetReaderCard(nReader, nCardNo);
    //模拟刷卡
  end;
end;

//Date: 2012-12-16
//Parm: 共享数据
//Desc: 处理业务中间件与硬件守护的交互数据
procedure WhenBusinessMITSharedDataIn(const nData: string);
begin
  WriteHardHelperLog('收到Bus_MIT业务请求:::' + nData);
  //log data

  if Pos('TruckOut', nData) = 1 then
    MakeTruckAutoOut(Copy(nData, Pos(':', nData) + 1, MaxInt));
  //auto out
end;

//Date: 2015-01-14
//Parm: 车牌号;交货单
//Desc: 格式化nBill交货单需要显示的车牌号
function GetJSTruck(const nTruck,nBill: string): string;
var nStr: string;
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
      //只处理32.5(b)

      nLen := cMultiJS_Truck - 2;
      Result := 'B-' + Copy(nTruck, Length(nTruck) - nLen + 1, nLen);
    end;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
  {$ENDIF}
end;

//Date: 2013-07-17
//Parm: 计数器通道
//Desc: 保存nTunnel计数结果
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

//Date: 2017-8-17
//Parm: 卡号;通道号;动作
//Desc: 保存抓斗称刷卡信息
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
    gERelayManager.ShowTxt(nTunnel.FID, '装车完成 请下磅');

    gERelayManager.LineClose(nTunnel.FID);
    Sleep(100);
    WriteNearReaderLog('称重完成:' + nTunnel.FID + '单据号：' + nTunnel.FBill);
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
   bsInit      : WriteNearReaderLog('初始化:' + nTunnel.FID   + '单据号：' + nTunnel.FBill);
   bsNew       : WriteNearReaderLog('新添加:' + nTunnel.FID   + '单据号：' + nTunnel.FBill);
   bsStart     : WriteNearReaderLog('开始称重:' + nTunnel.FID + '单据号：' + nTunnel.FBill);
   bsClose     : WriteNearReaderLog('称重关闭:' + nTunnel.FID + '单据号：' + nTunnel.FBill);
  end; //log

  if nTunnel.FStatusNew = bsClose then
  begin
    gERelayManager.ShowTxt(nTunnel.FID, '装车业务关闭');
    WriteNearReaderLog(nTunnel.FID+'装车业务关闭');
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
      WriteHardHelperLog('连接HM数据库失败(DBConn Is Null).');
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

//Desc: 对nCard放行出厂
procedure AutoTruckOutFact(const nCard : string);
var nStr,nCardType: string;
begin
  WriteHardHelperLog('自动出厂 '+nCard);
  MakeTruckOut(nCard, '', gSysParam.FOutFactPrint, nStr);
  ///自动出厂
end;

//------------------------------------------------------------------------------
//Date: 2019-03-12
//Parm: 端口
//Desc: 解析磅站数据
function WhenParsePoundWeight(const nPort: PPTPortItem): Boolean;
var nIdx,nLen: Integer;
    nVerify: Word;
    nBuf: TIdBytes;
begin
  Result := False;
  nBuf := ToBytes(nPort.FCOMBuff, Indy8BitEncoding);
  nLen := Length(nBuf) - 2;
  if nLen < 52 then Exit; //48-51为磅重数据

  nVerify := 0;
  nIdx := 0;

  while nIdx < nLen do
  begin
    nVerify := nBuf[nIdx] + nVerify;
    Inc(nIdx);
  end;

  if (nBuf[nLen] <> (nVerify shr 8 and $00ff)) or
     (nBuf[nLen+1] <> (nVerify and $00ff)) then Exit;
  //校验失败

  nPort.FCOMData := IntToStr(StrToInt('$' +
    IntToHex(nBuf[51], 2) + IntToHex(nBuf[50], 2) +
    IntToHex(nBuf[49], 2) + IntToHex(nBuf[48], 2)));
  //毛重显示数据

  Result := True;
end;

//Date: 2019-03-12
//Parm: 交货单号;重量
//Desc: 依据nBill状态写入nValue重量
function SavePoundData(const nTunnel: PBWTunnel; const nValue: Double;
                       out nMsg:string): Boolean;
var nStr, nStatus, nTruck: string;
    nDBConn: PDBWorker;
    nPvalue,nDefaultPValue,nPValueWuCha : Double;
begin
  nDBConn := nil;
  try
    Result := False;
    nStr := 'Select L_Status,L_Value,L_PValue,L_Truck From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nTunnel.FBill]);
     
    with gDBConnManager.SQLQuery(nStr, nDBConn) do
    begin
      if RecordCount < 1 then
      begin
        WriteNearReaderLog(Format('交货单[ %s ]已丢失', [nTunnel.FBill]));
        Exit;
      end;

      nStatus := FieldByName('L_Status').AsString;
      nTruck  := FieldByName('L_Truck').AsString;
      if nStatus = sFlag_TruckIn then //皮重
      begin
        //查找默认皮重值
        nStr := ' Select D_Value from %s  where D_Name = ''%s'' and D_Memo = ''%s''  ';
        nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam,sFlag_DefaultPValue]);
        with gDBConnManager.WorkerQuery(nDBConn, nStr) do
        begin
          if RecordCount < 1 then
            nDefaultPValue := 0
          else
            nDefaultPValue :=  FieldByName('D_Value').AsFloat;
        end;
        //查找皮重上下浮动值
        nStr := ' Select D_Value from %s  where D_Name = ''%s'' and D_Memo = ''%s''  ';
        nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam,sFlag_PValueWuCha]);
        with gDBConnManager.WorkerQuery(nDBConn, nStr) do
        begin
          if RecordCount < 1 then
            nPValueWuCha := 500
          else
            nPValueWuCha :=  FieldByName('D_Value').AsFloat;
        end;

        //判断皮重有效性
        nPvalue := 0;
        nStr := ' Select Top 5 L_PValue from %s  where L_Truck = ''%s'' and L_PValue is not null order by R_ID Desc ';
        nStr := Format(nStr, [sTable_Bill, nTruck]);
        with gDBConnManager.WorkerQuery(nDBConn, nStr) do
        begin
          if RecordCount < 1 then
            nPvalue := nDefaultPValue
          else
          begin
            First;
            while not Eof do
            begin
              nPvalue := nPvalue + FieldByName('L_Pvalue').AsFloat;
              Next;
            end;
            nPvalue := nPvalue / RecordCount;
          end;
        end;
        //皮重有效范围值

        WriteNearReaderLog(nTunnel.FID+'历史平均皮重：'+FloatToStr(nPValue)
          +'当前皮重：'+FloatToStr(nValue)+'浮动范围：'+FloatToStr(nPValueWuCha));
        if nPvalue > 0 then
        if  (nValue < nPvalue - nPvalueWucha)  or (nValue > nPvalue + nPvalueWucha) then
        begin
          nMsg := '皮重异常';
          Exit;
        end;

        nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckBFP),
                SF('L_NextStatus', sFlag_TruckFH),
                SF('L_LadeTime', sField_SQLServer_Now, sfVal),
                SF('L_PValue', nValue, sfVal),
                SF('L_PDate', sField_SQLServer_Now, sfVal)
          ], sTable_Bill, SF('L_ID', nTunnel.FBill), False);
        gDBConnManager.WorkerExec(nDBConn, nStr);

        gBasisWeightManager.SetTruckPValue(nTunnel.FID, nValue);
        //更新通道皮重, 确认磅重上限

        {$IFDEF HKVDVR}
        gCameraManager.CapturePicture(nTunnel.FID, nTunnel.FBill);
        //抓拍
        {$ENDIF}
        gERelayManager.LineOpen(nTunnel.FID);
        //打开放灰
        ShowLEDHint(nTunnel.FID, '请开始装车', FieldByName('L_Truck').AsString);
        WriteNearReaderLog(nTunnel.FID + ',' + nTunnel.FBill + '保存皮重完毕,允许放灰');
        gBasisWeightManager.SetParam(nTunnel.FID, 'CanFH', sFlag_Yes);
        //添加可放灰标记
      end else
      begin
        nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckBFM),
                SF('L_NextStatus', sFlag_TruckOut),
                SF('L_MValue', nValue, sfVal),
                SF('L_MDate', sField_SQLServer_Now, sfVal)
          ], sTable_Bill, SF('L_ID', nTunnel.FBill), False);
        gDBConnManager.WorkerExec(nDBConn, nStr);
      end; //放灰状态,只更新重量,出厂时计算净重
    end;

    Result := True;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
end;

//Date: 2019-03-11
//Parm: 定量装车通道
//Desc: 当nTunnel状态改变时,处理业务
procedure WhenBasisWeightStatusChange(const nTunnel: PBWTunnel);
var nStr, nTruck, nMsg, nVoiceID: string;
begin
  if nTunnel.FStatusNew = bsProcess then
  begin
    if nTunnel.FWeightMax > 0 then
         nStr := Format('%.2f/%.2f', [nTunnel.FWeightMax, nTunnel.FValTunnel])
    else nStr := Format('%.2f/%.2f', [nTunnel.FValue, nTunnel.FValTunnel]);

    ShowLEDHint(nTunnel.FID, nStr, nTunnel.FParams.Values['Truck']);
    Exit;
  end;

  case nTunnel.FStatusNew of
   bsInit      : WriteNearReaderLog('初始化:' + nTunnel.FID);
   bsNew       : WriteNearReaderLog('新添加:' + nTunnel.FID);
   bsStart     : WriteNearReaderLog('开始称重:' + nTunnel.FID);
   bsClose     : WriteNearReaderLog('称重关闭:' + nTunnel.FID);
   bsDone      : WriteNearReaderLog('称重完成:' + nTunnel.FID);
   bsStable    : WriteNearReaderLog('数据平稳:' + nTunnel.FID);
  end; //log


  nVoiceID:= '';  nTruck:= '';
  nVoiceID:= nTunnel.FTunnel.FOptions.Values['VoiceCard'];
  nTruck  := nTunnel.FParams.Values['Truck'];
  ///
  if nTunnel.FStatusNew = bsClose then
  begin
    ShowLEDHint(nTunnel.FID, '装车业务关闭', nTunnel.FParams.Values['Truck']);
    WriteNearReaderLog(nTunnel.FID+'装车业务关闭');

    gERelayManager.LineClose(nTunnel.FID);
    //停止装车
    gBasisWeightManager.SetParam(nTunnel.FID, 'CanFH', sFlag_No);
    //通知DCS关闭装车
    Exit;
  end;

  if nTunnel.FStatusNew = bsDone then
  begin
    {$IFDEF BasisWeight}
    ShowLEDHint(nTunnel.FID, '装车完成 请下磅');                                MakeGateSound(nTruck+'装车完成、请下磅', nVoiceID);
    gProberManager.OpenTunnel(nTunnel.FID);
    //红绿灯
    gProberManager.OpenTunnel(nTunnel.FID + '_Z');
    //打开道闸
    {$IFDEF HKVDVR}
    gCameraManager.CapturePicture(nTunnel.FID, nTunnel.FBill);
    //抓拍
    {$ENDIF}
    {$ELSE}
    ShowLEDHint(nTunnel.FID, '装车完成请等待保存称重');                         MakeGateSound(nTruck+'装车完成、请等待保存称重', nVoiceID);
    WriteNearReaderLog(nTunnel.FID+'装车完成请等待保存称重');
    {$ENDIF}
    gERelayManager.LineClose(nTunnel.FID);
    //停止装车
    gBasisWeightManager.SetParam(nTunnel.FID, 'CanFH', sFlag_No);
    //通知DCS关闭装车
    Exit;
  end;

  if nTunnel.FStatusNew = bsStable then
  begin
    {$IFDEF BasisWeight}
    Exit; //非库底计量,不保存数据
    {$ENDIF}

    if not gProberManager.IsTunnelOK(nTunnel.FID) then
    begin
      nTunnel.FStableDone := False;
      //继续触发事件
      ShowLEDHint(nTunnel.FID, '车辆未停到位 请移动车辆');                      MakeGateSound(nTruck+'未停到位 请移动车辆', nVoiceID);
      Exit;
    end;

    ShowLEDHint(nTunnel.FID, '数据平稳准备保存称重', nTruck);
    WriteNearReaderLog(nTunnel.FID+'数据平稳准备保存称重');
                                   
    if SavePoundData(nTunnel, nTunnel.FValHas, nMsg) then
    begin
      gBasisWeightManager.SetParam(nTunnel.FID, 'CanFH', sFlag_Yes);
      //添加可放灰标记

      if nTunnel.FWeightDone then
      begin
        ShowLEDHint(nTunnel.FID, '毛重保存完毕请下磅', nTruck);
        WriteNearReaderLog(nTunnel.FID+'毛重保存完毕,请下磅');                  MakeGateSound(nTruck+'毛重保存完毕请下磅', nVoiceID);
        gProberManager.OpenTunnel(nTunnel.FID + '_Z');
        gProberManager.OpenTunnel(nTunnel.FID);
        //红绿灯
        {$IFDEF HKVDVR}
        gCameraManager.CapturePicture(nTunnel.FID, nTunnel.FBill);
        //抓拍
        {$ENDIF}
      end else
      begin
        ShowLEDHint(nTunnel.FID, '保存完毕请等待装车', nTruck);                 MakeGateSound(nTruck+'请等待装车', nVoiceID);
        WriteNearReaderLog(nTunnel.FID+'保存完毕,请等待装车');
      end;
    end else
    begin
      nTunnel.FStableDone := False;
      //继续触发事件
      if nMsg <> '' then
      begin
        ShowLEDHint(nTunnel.FID, nMsg, nTruck);
        WriteNearReaderLog(nTunnel.FID+nMsg);
      end
      else
      begin
        ShowLEDHint(nTunnel.FID, '保存失败请联系管理员', nTruck);               MakeGateSound(nTruck+'称重保存失败请联系工作人员', nVoiceID);
        WriteNearReaderLog(nTunnel.FID+'保存失败 请联系管理员');
      end;
    end;
  end;
end;

//Date: 2019-03-19
//Parm: 通道列表
//Desc: 装车线状态切换
procedure WhenTruckLineChanged(const nTruckLine: TList);
var nStr: string;
    nIdx: Integer;
    nLine: PLineItem;
begin
  for nIdx:=nTruckLine.Count - 1 downto 0 do
  begin
    nLine := nTruckLine[nIdx];
    if nLine.FIsValid then
         nStr := '1'
    else nStr := '0';

    gBasisWeightManager.SetParam(nLine.FLineID, 'LineStatus', nStr, True);
    //更新通道状态

    {$IFDEF ReverseTrafficLight}
    if nLine.FIsValid then
         gProberManager.CloseTunnel(nLine.FLineID)
    else gProberManager.OpenTunnel(nLine.FLineID);
    {$ELSE}
    if nLine.FIsValid then
         gProberManager.OpenTunnel(nLine.FLineID)
    else gProberManager.CloseTunnel(nLine.FLineID);
    {$ENDIF} //同步道闸
  end;
end;

end.
