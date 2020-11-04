{*******************************************************************************
  ����: dmzn@163.com 2010-3-8
  ����: ϵͳҵ����
*******************************************************************************}
unit USysBusiness;

interface
{$I Link.inc}
uses
  Windows, DB, Classes, Controls, SysUtils, UBusinessPacker, UBusinessWorker,
  UBusinessConst, ULibFun, UAdjustForm, UFormCtrl, UDataModule, UDataReport,
  UFormBase, cxMCListBox, UMgrPoundTunnels, UMgrCamera, UBase64, USysConst,
  USysDB, USysLoger, StrUtils;

type
  TLadingStockItem = record
    FID: string;         //���
    FType: string;       //����
    FName: string;       //����
    FParam: string;      //��չ
  end;

  TDynamicStockItemArray = array of TLadingStockItem;
  //ϵͳ���õ�Ʒ���б�

  PZTLineItem = ^TZTLineItem;
  TZTLineItem = record
    FID       : string;      //���
    FName     : string;      //����
    FStock    : string;      //Ʒ��
    FWeight   : Integer;     //����
    FValid    : Boolean;     //�Ƿ���Ч
    FPrinterOK: Boolean;     //�����
  end;

  PZTTruckItem = ^TZTTruckItem;
  TZTTruckItem = record
    FTruck    : string;      //���ƺ�
    FLine     : string;      //ͨ��
    FBill     : string;      //�����
    FValue    : Double;      //�����
    FDai      : Integer;     //����
    FTotal    : Integer;     //����
    FInFact   : Boolean;     //�Ƿ����
    FIsRun    : Boolean;     //�Ƿ�����    
  end;

  TZTLineItems = array of TZTLineItem;
  TZTTruckItems = array of TZTTruckItem;

  PSalePlanItem = ^TSalePlanItem;
  TSalePlanItem = record
    FOrderNo: string;        //������     
    FInterID: string;        //������
    FEntryID: string;        //������
    FStockID: string;        //���ϱ��
    FStockName: string;      //��������

    FTruck: string;          //���ƺ���
    FValue: Double;          //������
    FSelected: Boolean;      //״̬
  end;
  TSalePlanItems = array of TSalePlanItem;
  
//------------------------------------------------------------------------------
function AdjustHintToRead(const nHint: string): string;
//������ʾ����
function WorkPCHasPopedom: Boolean;
//��֤�����Ƿ�����Ȩ
function GetSysValidDate: Integer;
//��ȡϵͳ��Ч��
function GetTruckEmptyValue(nTruck: string): Double;
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean = True): string;
//��ȡ���б��
function GetLadingStockItems(var nItems: TDynamicStockItemArray): Boolean;
//����Ʒ���б�
function GetCardUsed(const nCard: string): string;
//��ȡ��Ƭ����

function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
//��ȡϵͳ�ֵ���
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
//��ȡҵ��Ա�б�
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
//��ȡ�ͻ��б�
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
//����ͻ���Ϣ

function IsZhiKaNeedVerify: Boolean;
//ֽ���Ƿ���Ҫ���
function IsPrintZK: Boolean;
//�Ƿ��ӡֽ��
function DeleteZhiKa(const nZID: string): Boolean;
//ɾ��ָ��ֽ��
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
//����ֽ��
function GetZhikaValidMoney(nZhiKa: string; var nFixMoney: Boolean): Double;
//ֽ�����ý�
function GetCustomerValidMoney(nCID: string; const nLimit: Boolean = True;
 const nCredit: PDouble = nil): Double;
//�ͻ����ý��

function SyncRemoteCustomer: Boolean;
//ͬ��Զ���û�
function SyncRemoteSaleMan: Boolean;
//ͬ��Զ��ҵ��Ա
function SyncRemoteProviders: Boolean;
//ͬ��Զ���û�
function SyncRemoteMeterails: Boolean;
//ͬ��Զ��ҵ��Ա
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
//����ʱ�ͻ�
function IsAutoPayCredit: Boolean;
//�ؿ�ʱ������
function SaveCustomerPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nPayment,nMemo: string; const nMoney: Double;const nID,nZID:string;
 const nCredit: Boolean = True): Boolean;
//����ؿ��¼
function SaveCustomerKPPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nPayment,nMemo: string; const nMoney: Double;
 const nCredit: Boolean = True): Boolean;
//����ؿ��¼
function SaveCustomerCredit(const nCusID,nMemo: string; const nCredit: Double;
 const nEndTime: TDateTime): Boolean;
//�������ü�¼
function IsCustomerCreditValid(const nCusID: string): Boolean;
//�ͻ������Ƿ���Ч
procedure SaveCustomerPaymentEvent(const nSID,nEvent,
      nFrom,nSolution,nDepartment: string);
//�����տ������۲��ŵ���������Ϣ

//����ʶ��
function VeriFyTruckLicense(const nReader: string; nBill: TLadingBillItem;
                         var nMsg, nPos: string): Boolean;

function GetTruckIsQueue(const nTruck: string): Boolean;
//��ȡ�����Ƿ��ڶ�����
function GetTruckIsOut(const nTruck: string): Boolean;
//��ȡ�����Ƿ��ѳ���
function IsStockValid(const nStocks: string): Boolean;
//Ʒ���Ƿ���Է���
function SaveBill(const nBillData: string): string;
//���潻����
function DeleteBill(const nBill: string): Boolean;
//ɾ��������
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
//�����������
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
//����������
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
//Ϊ����������ſ�
function SaveWebOrderMatch(const nBillID, nWebOrderID, nBillType: string):Boolean;
//����΢�Ŷ���

function SaveBillLSCard(const nCard,nTruck: string): Boolean;
//���������۴ſ�
function Get_ShopOrderByNo(const nXmlStr: string): string;
//����΢�Ŷ����Ż�ȡ���۵�����

function LoadSalePlan(const nCusID: string;var nPlans: TSalePlanItems): Boolean;
//��ȡ���ۼƻ�
function SaveBillCard(const nBill, nCard: string): Boolean;
//���潻�����ſ�
function LogoutBillCard(const nCard: string): Boolean;
//ע��ָ���ſ�
function SetTruckRFIDCard(nTruck: string; var nRFIDCard: string;
  var nIsUse: string; nOldCard: string=''): Boolean;

function GetLadingBills(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//��ȡָ����λ�Ľ������б�
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
//���뵥����Ϣ���б�
function SaveLadingBills(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil;const nLogin: Integer = -1): Boolean;
//����ָ����λ�Ľ�����

function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
//��ȡָ���������ѳ�Ƥ����Ϣ
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems;const nLogin: Integer = -1): Boolean;
//���泵��������¼
function ReadPoundCard(const nTunnel: string; var nReader: string): string;
//��ȡָ����վ��ͷ�ϵĿ���
function ReadPoundCardEx(var nReader: string;
  const nTunnel: string; nReadOnly: String = ''): string;
//��ȡָ����վ��ͷ�ϵĿ���(���ӱ�ǩ)
function GetTruckRealLabel(const nTruck: string): string;
//��ȡ�����󶨵ĵ��ӱ�ǩ
procedure CapturePicture(const nTunnel: PPTTunnelItem; const nList: TStrings);
//ץ��ָ��ͨ��

procedure GetLimitedLoadMValueChk(var nChk : Boolean; var nMValue: Double; const nTruck: string);
procedure GetPoundAutoWuCha(var nWCValZ,nWCValF: Double; const nVal: Double;
 const nStation: string = '');
//��ȡ��Χ

function GetTruckNO(const nTruck: WideString; const nLong: Integer=12): string;
function GetValue(const nValue: Double): string;
//��ʾ��ʽ��

function IsTunnelOK(const nTunnel: string): Boolean;
//��ѯͨ����դ�Ƿ�����
procedure TunnelOC(const nTunnel: string; const nOpen: Boolean);
//����ͨ�����̵ƿ���
function PlayNetVoice(const nText,nCard,nContent: string): Boolean;
//���м����������
procedure ProberShowTxt(const nTunnel, nText: string);
//���췢��С��

function SaveOrderBase(const nOrderData: string): string;
//����ɹ����뵥
function DeleteOrderBase(const nOrder: string): Boolean;
//ɾ���ɹ����뵥
function SaveOrder(const nOrderData: string): string;
//����ɹ���
function DeleteOrder(const nOrder: string): Boolean;
//ɾ���ɹ���
//function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
////�����������
function SetOrderCard(const nOrder,nTruck: string; nVerify: Boolean): Boolean;
//Ϊ�ɹ�������ſ�
function SaveOrderCard(const nOrder, nCard: string): Boolean;
//����ɹ����ſ�
function LogoutOrderCard(const nCard: string): Boolean;
//ע��ָ���ſ�
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
//�޸ĳ��ƺ�

function GetPurchaseOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//��ȡָ����λ�Ĳɹ����б�
function SavePurchaseOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil;const nLogin: Integer = -1): Boolean;
//����ָ����λ�Ĳɹ���
procedure LoadOrderItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);

function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean = False): Boolean;
//��ȡ��������
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
//��ͣ�����
function ChangeDispatchMode(const nMode: Byte): Boolean;
//�л�����ģʽ
function OpenDoorByReader(const nReader: string; nType: string = 'Y'): Boolean;
//�������򿪵�բ

function GetHYMaxValue: Double;
function GetHYValueByStockNo(const nNo: string): Double;
//��ȡ���鵥�ѿ���
function IsEleCardVaid(const nTruckNo: string): Boolean;
//��֤�������ӱ�ǩ
function IsEleCardVaidEx(const nTruckNo: string): Boolean;
//��֤�������ӱ�ǩ
function IfStockHasLs(const nStockNo: string): Boolean;
//��֤�����Ƿ���Ҫ������ˮ
function IFHasOrder(const nTruck: string): Boolean;
//�����Ƿ����δ��ɲɹ���
function IsWeekValid(const nWeek: string; var nHint: string): Boolean;
function IsWeekValidEx(const nWeek: string; var nHint: string; var nBegin,nEnd: TDateTime): Boolean;
//�����Ƿ���Ч
function IsWeekHasEnable(const nWeek: string): Boolean;
//�����Ƿ�����
function IsNextWeekEnable(const nWeek: string): Boolean;
//��һ�����Ƿ�����
function IsPreWeekOver(const nWeek: string): Integer;
//��һ�����Ƿ����
function SaveCompensation(const nSaleMan,nCusID,nCusName,nPayment,nMemo: string;
 const nMoney: Double): Boolean;
//�����û�������
function AdjustBillStatus(const nID: string): Boolean;
//��ι�ë�ء�����״̬

//------------------------------------------------------------------------------
procedure PrintSaleContractReport(const nID: string; const nAsk: Boolean);
//��ӡ��ͬ
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
//��ӡֽ��
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
//��ӡ�վ�
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
//��ӡ�����
function PrintOrderReport(const nOrder: string;  const nAsk: Boolean;
                          const nMul: Boolean = False): Boolean;
//��ӡ�ɹ���
function PrintRCOrderReport(const nID: string;  const nAsk: Boolean): Boolean;
//��ӡ�ɹ���
function PrintPoundReport(const nPound: string; nAsk: Boolean;
                          const nMul: Boolean = False): Boolean;
//��ӡ��
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean;n28D: Boolean=False): Boolean;
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
//���鵥,�ϸ�֤
function PrintHeGeReportEx(const nLID: string; const nAsk: Boolean): Boolean;
//�ϸ�֤
function PrintBillFYDReport(const nBill: string;  const nAsk: Boolean): Boolean;
function PrintBillLoadReport(nBill: string; const nAsk: Boolean): Boolean;
//��ӡ���˵�����·��

function GetTruckLastTime(const nTruck: string): Integer;
//���һ�ι���ʱ��
function IsStrictSanValue: Boolean;
//�ж��Ƿ��ϸ�ִ��ɢװ��ֹ����

function GetFQValueByStockNo(const nStock: string): Double;
//��ȡ��ǩ���ѷ���
function VerifyFQSumValue: Boolean;
//�Ƿ�У���ǩ��
function AddManualEventRecord(const nEID,nKey,nEvent:string;
 const nFrom: string = sFlag_DepBangFang ;
 const nSolution: string = sFlag_Solution_YN;
 const nDepartmen: string = sFlag_DepDaTing;
 const nReset: Boolean = False; const nMemo: string = ''): Boolean;
//��Ӵ����������¼
function VerifyManualEventRecord(const nEID: string; var nHint: string;
 const nWant: string = sFlag_Yes; const nUpdateHint: Boolean = True): Boolean;
//����¼��Ƿ�ͨ������
function VerifyManualEventRecordEx(const nEID: string; var nHint: string;
 const nWant: string = sFlag_Yes; const nUpdateHint: Boolean = True): Boolean;
//����¼��Ƿ�ͨ������

function getCustomerInfo(const nData: string): string;
//��ȡ�ͻ�ע����Ϣ
function get_Bindfunc(const nData: string): string;
//�ͻ���΢���˺Ű�
function send_event_msg(const nData: string): string;
//������Ϣ
function edit_shopclients(const nData: string): string;
//�����̳��û�
function edit_shopgoods(const nData: string): string;
//�����Ʒ
function get_shoporders(const nData: string): string;
//��ȡ������Ϣ
function complete_shoporders(const nData: string): string;
//���¶���״̬
function getAuditTruck(const nData: string): string;
//��ȡ��˳���
function UploadAuditTruck(const nData: string): string;
//��˳�������ϴ�
function DownLoadPic(const nData: string): string;
//������Ƭ
function GetshoporderbyTruck(const nData: string): string;
//���ݳ��ƺŻ�ȡ����
procedure SaveWebOrderDelMsg(const nLID, nBillType: string);
//����������Ϣ

function MakeSaleViewData: Boolean;
//���������ض��ֶ�����(�ض�ʹ��)
function MakeOrderViewData: Boolean;
//���ɲɹ��ض��ֶ�����(�ض�ʹ��)

function SaveDDBases(const nDDData: string): string;
//����̵�������Ϣ
function DeleteDDBase(const nBase: string): Boolean;
//ɾ���̵�������Ϣ

function LogoutDDCard(const nCard: string): Boolean;
//ע���̵��ſ�

function SaveDDCard(const nBID, nCard: string): Boolean;
//�󶨶̵��ſ�
function GetDuanDaoItems(const nCard,nPost: string;
  var nBills: TLadingBillItems): Boolean;
//��ȡָ����λ�Ķ̵���ϸ�б�
function SaveDuanDaoItems(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem=nil;const nLogin: Integer = -1): Boolean;
//����ָ����λ�Ķ̵���ϸ
function DeleteDDDetial(const nDID: string): Boolean;
//ɾ���̵���ϸ
function SetDDCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
//Ϊ����������ſ�
function PrintDuanDaoReport(const nID: string; nAsk: Boolean): Boolean;
//��ӡ�̵���


//����ʶ��
function ReadPoundReaderInfo(const nReader: string; var nDept: string): string;
//����ʶ��   ��ȡnReader��λ������
function VerifySnapTruck(const nReader: string; nBill: TLadingBillItem; var nMsg, nPos: string): Boolean;
function SaveSnapStatus(const nBill: TLadingBillItem; nStatus: string): Boolean;
procedure RemoteSnapDisPlay(const nPost, nText, nSucc: string);
function GetPersonWeight( var nWeight: Double): Boolean;
//��ë����˾������


procedure CapturePictureEx(const nTunnel: PPTTunnelItem;
                         const nLogin: Integer; nList: TStrings);
//ץ��nTunnel��ͼ��Ex
function InitCapture(const nTunnel: PPTTunnelItem; var nLogin: Integer): Boolean;
//��ʼ��ץ�ģ���CapturePictureEx����ʹ��
function FreeCapture(nLogin: Integer): Boolean;
//�ͷ�ץ��
function IsSealInfoDone(const nCardUse : string; nBill: TLadingBillItem): Boolean;
function ShowLedText(nTunnel, nStr:string):Boolean;
//����led��ʾ����
function GetIDCardNumCheckCode(nIDCardNum: string): string;
//���֤��У���㷨

function GetWlbYsStatus(const nStockNo,nOrderId: string): Boolean;
//��ȡ����������״̬

function PrintShouJu(const nSID: string; const nAsk: Boolean): Boolean;
//��ӡ�վ�

implementation

//Desc: ��¼��־
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(nEvent);
end;

//Date: 2017-09-22
//Parm: ����;����;����;���
//Desc: �����м���ϵĶ̵����ݶ���
function CallBusinessDuanDao(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessDuanDao);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����nHintΪ�׶��ĸ�ʽ
function AdjustHintToRead(const nHint: string): string;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Text := nHint;
    for nIdx:=0 to nList.Count - 1 do
      nList[nIdx] := '��.' + nList[nIdx];
    Result := nList.Text;
  finally
    nList.Free;
  end;
end;

//Desc: ��֤�����Ƿ�����Ȩ����ϵͳ
function WorkPCHasPopedom: Boolean;
begin
  Result := gSysParam.FSerialID <> '';
  if not Result then
  begin
    ShowDlg('�ù�����Ҫ����Ȩ��,�������Ա����.', sHint);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ������ЧƤ��
function GetTruckEmptyValue(nTruck: string): Double;
var nStr: string;
begin
  Result := 0;
  //init

  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_VerifyTruckP]);
  with FDM.QueryTemp(nStr) do
  if Recordcount > 0 then
   nStr := Fields[0].AsString;

  if nStr <> sFlag_Yes then Exit;
  //��У��Ƥ��

  nStr := 'Select T_PValue From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsFloat;
end;

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵ�ҵ���������
function CallBusinessCommand(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessSaleBill(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessSaleBill);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessPurchaseOrder(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessPurchaseOrder);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-10-01
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessHardware(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_HardwareCommand);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;


//Date: 2017-10-26
//Parm: ����;����;����;�����ַ;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessWechat(const nCmd: Integer; const nData,nExt,nSrvURL: string;
  const nOut: PWorkerWebChatData; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerWebChatData;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;
    nIn.FRemoteUL := nSrvURL;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //close hint param
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessWebchat);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-04
//Parm: ����;����;ʹ�����ڱ���ģʽ
//Desc: ����nGroup.nObject���ɴ��б��
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean): string;
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Group'] := nGroup;
    nList.Values['Object'] := nObject;

    if nUseDate then
         nStr := sFlag_Yes
    else nStr := sFlag_No;

    if CallBusinessCommand(cBC_GetSerialNO, nList.Text, nStr, @nOut) then
      Result := nOut.FData;
    //xxxxx
  finally
    nList.Free;
  end;   
end;

//Desc: ��ȡϵͳ��Ч��
function GetSysValidDate: Integer;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_IsSystemExpired, '', '', @nOut) then
       Result := StrToInt(nOut.FData)
  else Result := 0;
end;

function GetCardUsed(const nCard: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_GetCardUsed, nCard, '', @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

//Desc: ��ȡ��ǰϵͳ���õ�ˮ��Ʒ���б�
function GetLadingStockItems(var nItems: TDynamicStockItemArray): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select D_Value,D_Memo,D_ParamB From $Table ' +
          'Where D_Name=''$Name'' Order By D_Index ASC';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_StockItem)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    SetLength(nItems, RecordCount);
    if RecordCount > 0 then
    begin
      nIdx := 0;
      First;

      while not Eof do
      begin
        nItems[nIdx].FType := FieldByName('D_Memo').AsString;
        nItems[nIdx].FName := FieldByName('D_Value').AsString;
        nItems[nIdx].FID := FieldByName('D_ParamB').AsString;

        Next;
        Inc(nIdx);
      end;
    end;
  end;

  Result := Length(nItems) > 0;
end;

//------------------------------------------------------------------------------
//Date: 2014-06-19
//Parm: ��¼��ʶ;���ƺ�;ͼƬ�ļ�
//Desc: ��nFile�������ݿ�
procedure SavePicture(const nID, nTruck, nMate, nFile: string);
var nStr: string;
    nRID: Integer;
begin
  FDM.ADOConn.BeginTrans;
  try
    nStr := MakeSQLByStr([
            SF('P_ID', nID),
            SF('P_Name', nTruck),
            SF('P_Mate', nMate),
            SF('P_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Picture, '', True);
    //xxxxx

    if FDM.ExecuteSQL(nStr) < 1 then Exit;
    nRID := FDM.GetFieldMax(sTable_Picture, 'R_ID');

    nStr := 'Select P_Picture From %s Where R_ID=%d';
    nStr := Format(nStr, [sTable_Picture, nRID]);
    FDM.SaveDBImage(FDM.QueryTemp(nStr), 'P_Picture', nFile);

    FDM.ADOConn.CommitTrans;
  except
    FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ����ͼƬ·��
function MakePicName: string;
begin
  while True do
  begin
    Result := gSysParam.FPicPath + IntToStr(gSysParam.FPicBase) + '.jpg';
    if not FileExists(Result) then
    begin
      Inc(gSysParam.FPicBase);
      Exit;
    end;

    DeleteFile(Result);
    if FileExists(Result) then Inc(gSysParam.FPicBase)
  end;
end;

//Date: 2014-06-19
//Parm: ͨ��;�б�
//Desc: ץ��nTunnel��ͼ��
procedure CapturePicture(const nTunnel: PPTTunnelItem; const nList: TStrings);
const
  cRetry = 2;
  //���Դ���
var nStr: string;
    nIdx,nInt: Integer;
    nLogin,nErr: Integer;
    nPic: NET_DVR_JPEGPARA;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  nList.Clear;
  if not Assigned(nTunnel.FCamera) then Exit;
  //not camera

  if not DirectoryExists(gSysParam.FPicPath) then
    ForceDirectories(gSysParam.FPicPath);
  //new dir

  if gSysParam.FPicBase >= 100 then
    gSysParam.FPicBase := 0;
  //clear buffer

  nLogin := -1;
  gCameraNetSDKMgr.NET_DVR_SetDevType(nTunnel.FCamera.FType);
  //xxxxx

  gCameraNetSDKMgr.NET_DVR_Init;
  //xxxxx

  try
    for nIdx:=1 to cRetry do
    begin
      nLogin := gCameraNetSDKMgr.NET_DVR_Login(nTunnel.FCamera.FHost,
                   nTunnel.FCamera.FPort,
                   nTunnel.FCamera.FUser,
                   nTunnel.FCamera.FPwd, nInfo);
      //to login

      nErr := gCameraNetSDKMgr.NET_DVR_GetLastError;
      if nErr = 0 then break;

      if nIdx = cRetry then
      begin
        nStr := '��¼�����[ %s.%d ]ʧ��,������: %d';
        nStr := Format(nStr, [nTunnel.FCamera.FHost, nTunnel.FCamera.FPort, nErr]);
        WriteLog(nStr);
        Exit;
      end;
    end;

    nPic.wPicSize := nTunnel.FCamera.FPicSize;
    nPic.wPicQuality := nTunnel.FCamera.FPicQuality;

    for nIdx:=Low(nTunnel.FCameraTunnels) to High(nTunnel.FCameraTunnels) do
    begin
      if nTunnel.FCameraTunnels[nIdx] = MaxByte then continue;
      //invalid

      for nInt:=1 to cRetry do
      begin
        nStr := MakePicName();
        //file path

        gCameraNetSDKMgr.NET_DVR_CaptureJPEGPicture(nLogin,
                                   nTunnel.FCameraTunnels[nIdx],
                                   nPic, nStr);
        //capture pic

        nErr := gCameraNetSDKMgr.NET_DVR_GetLastError;

        if nErr = 0 then
        begin
          nList.Add(nStr);
          Break;
        end;

        if nIdx = cRetry then
        begin
          nStr := 'ץ��ͼ��[ %s.%d ]ʧ��,������: %d';
          nStr := Format(nStr, [nTunnel.FCamera.FHost,
                   nTunnel.FCameraTunnels[nIdx], nErr]);
          WriteLog(nStr);
        end;
      end;
    end;
  finally
    if nLogin > -1 then
     gCameraNetSDKMgr.NET_DVR_Logout(nLogin);
    gCameraNetSDKMgr.NET_DVR_Cleanup();
  end;
end;

//------------------------------------------------------------------------------
//Date: 2019-11-07
//Parm: �Ƿ��顢ë�ء�����
//Desc: ����Ƿ�ϵͳ�������ؿ��ơ������Ҷ�Ӧ��������ֵ
procedure GetLimitedLoadMValueChk(var nChk : Boolean; var nMValue: Double; const nTruck: string);
var nStr: string;
    nMax, nMin : Double;
begin
  nChk:= False;
  nMax:= 50; nMin:=20;

  if nTruck='' then Exit;
  //***********
  nStr := 'Select * From %s Where D_Name=''SysParam'' And D_Memo=''LimitedLoadMValueChk'' ';
  nStr := Format(nStr, [sTable_SysDict]);
  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    nChk:= FieldByName('D_Value').AsString = sFlag_Yes;
  end;

  if nChk then
  begin
    nStr := 'Select * From %s Where T_Truck=''%s'' ';
    nStr := Format(nStr, [sTable_Truck, nTruck]);
    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      nMax := FieldbyName('T_Limited').AsFloat*1000;
      nMin := FieldbyName('T_LimitedMin').AsFloat*1000;
    end;

    if (nMin<=nMValue*1000)and(nMValue*1000<nMax) then
    begin
      nMValue:= 0;
    end
    else if nMValue*1000=nMax then
    begin
      nMValue:= 100;
    end
    else if nMValue*1000>nMax then
    begin
      nMValue:= nMValue*1000-nMax;
    end
    else if nMValue*1000<nMin then
    begin
      nMValue:= nMValue*1000-nMin;
    end;
  end
  else nMValue:= 0;
end;

//Date: 2017-07-09
//Parm: ��װ�������;Ʊ��;��վ��
//Desc: ����nVal����Χ
procedure GetPoundAutoWuCha(var nWCValZ,nWCValF: Double; const nVal: Double;
 const nStation: string);
var nStr: string;
begin
  nWCValZ := 0;
  nWCValF := 0;
  if nVal <= 0 then Exit;

  nStr := 'Select * From %s Where P_Start<=%.2f and P_End>%.2f';
  nStr := Format(nStr, [sTable_PoundDaiWC, nVal, nVal]);

  if Length(nStation) > 0 then
    nStr := nStr + ' And P_Station=''' + nStation + '''';
  //xxxxx

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    if FieldByName('P_Percent').AsString = sFlag_Yes then 
    begin
      nWCValZ := nVal * 1000 * FieldByName('P_DaiWuChaZ').AsFloat;
      nWCValF := nVal * 1000 * FieldByName('P_DaiWuChaF').AsFloat;
      //�������������
    end else
    begin     
      nWCValZ := FieldByName('P_DaiWuChaZ').AsFloat;
      nWCValF := FieldByName('P_DaiWuChaF').AsFloat;
      //���̶�ֵ�������
    end;
  end;
end;

//Date: 2017-07-09
//Parm: ��������
//Desc: ����쳣�¼�����
function AddManualEventRecord(const nEID,nKey,nEvent:string;
 const nFrom,nSolution,nDepartmen: string;
 const nReset: Boolean; const nMemo: string): Boolean;
var nStr: string;
    nUpdate: Boolean;
begin
  Result := False;
  if Trim(nSolution) = '' then
  begin
    WriteLog('��ѡ������.');
    Exit;
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nEID]);

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    nStr := '�¼���¼:[ %s ]�Ѵ���';
    WriteLog(Format(nStr, [nEID]));

    if not nReset then Exit;
    nUpdate := True;
  end else nUpdate := False;

  nStr := SF('E_ID', nEID);
  nStr := MakeSQLByStr([
          SF('E_ID', nEID),
          SF('E_Key', nKey),
          SF('E_From', nFrom),
          SF('E_Memo', nMemo),
          SF('E_Result', 'Null', sfVal),

          SF('E_Event', nEvent),
          SF('E_Solution', nSolution),
          SF('E_Departmen', nDepartmen),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx

  FDM.ExecuteSQL(nStr);
  Result := True;
end;

//Date: 2017-07-09
//Parm: �¼�ID;Ԥ�ڽ��;���󷵻�
//Desc: �ж��¼��Ƿ���
function VerifyManualEventRecord(const nEID: string; var nHint: string;
 const nWant: string; const nUpdateHint: Boolean): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select E_Result, E_Event From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nEID]);

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Trim(FieldByName('E_Result').AsString);
    if nStr = '' then
    begin
      if nUpdateHint then
        nHint := FieldByName('E_Event').AsString;
      Exit;
    end;

    if nStr <> nWant then
    begin
      if nUpdateHint then
        nHint := '����ϵ����Ա������Ʊ����';
      Exit;
    end;

    Result := True;
  end;
end;

//Date: 2017-07-09
//Parm: �¼�ID;Ԥ�ڽ��;���󷵻�
//Desc: �ж��¼��Ƿ���
function VerifyManualEventRecordEx(const nEID: string; var nHint: string;
 const nWant: string; const nUpdateHint: Boolean): Boolean;
var nStr: string;
begin
  Result := True;
  nStr := 'Select E_Result, E_Event From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nEID]);

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Trim(FieldByName('E_Result').AsString);
    if nStr = '' then
    begin
      if nUpdateHint then
        nHint := FieldByName('E_Event').AsString;
      Result := False;
      Exit;
    end;

    if nStr <> nWant then
    begin
      if nUpdateHint then
        nHint := '����ϵ����Ա������Ʊ����';
      Result := False;
      Exit;
    end;

    Result := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2014-07-03
//Parm: ͨ����
//Desc: ��ѯnTunnel�Ĺ�դ״̬�Ƿ�����
function IsTunnelOK(const nTunnel: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessHardware(cBC_IsTunnelOK, nTunnel, '', @nOut) then
       Result := nOut.FData = sFlag_Yes
  else Result := False;
end;

procedure TunnelOC(const nTunnel: string; const nOpen: Boolean);
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nOpen then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  CallBusinessHardware(cBC_TunnelOC, nTunnel, nStr, @nOut);
end;

//Date: 2016-01-06
//Parm: �ı�;������;����
//Desc: ��nCard����nContentģʽ��nText�ı�.
function PlayNetVoice(const nText,nCard,nContent: string): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := 'Card=' + nCard + #13#10 +
          'Content=' + nContent + #13#10 + 'Truck=' + nText;
  //xxxxxx

  Result := CallBusinessHardware(cBC_PlayVoice, nStr, '', @nOut);
  if not Result then
    WriteLog(nOut.FBase.FErrDesc);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Date: 2010-4-13
//Parm: �ֵ���;�б�
//Desc: ��SysDict�ж�ȡnItem�������,����nList��
function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
var nStr: string;
begin
  nList.Clear;
  nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                      MI('$Name', nItem)]);
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with Result do
  begin
    First;

    while not Eof do
    begin
      nList.Add(FieldByName('D_Value').AsString);
      Next;
    end;
  end else Result := nil;
end;

//Desc: ��ȡҵ��Ա�б�nList��,������������
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'S_ID=Select S_ID,S_PY,S_Name From %s ' +
          'Where IsNull(S_InValid, '''')<>''%s'' %s Order By S_PY';
  nStr := Format(nStr, [sTable_Salesman, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.', DSA(['S_ID']));
  
  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: ��ȡ�ͻ��б�nList��,������������
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'C_ID=Select C_ID,C_Name From %s ' +
          'Where IsNull(C_XuNi, '''')<>''%s'' %s Order By C_PY';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.');

  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: ����nCID�ͻ�����Ϣ��nList��,���������ݼ�
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
var nStr: string;
begin
  nStr := 'Select cus.*,S_Name as C_SaleName From $Cus cus ' +
          ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ' +
          'Where C_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$Cus', sTable_Customer), MI('$ID', nCID),
          MI('$SM', sTable_Salesman)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with nList.Items,Result do
  begin
    Add('�ͻ����:' + nList.Delimiter + FieldByName('C_ID').AsString);
    Add('�ͻ�����:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('��ҵ����:' + nList.Delimiter + FieldByName('C_FaRen').AsString + ' ');
    Add('��ϵ��ʽ:' + nList.Delimiter + FieldByName('C_Phone').AsString + ' ');
    Add('����ҵ��Ա:' + nList.Delimiter + FieldByName('C_SaleName').AsString);
  end else
  begin
    Result := nil;
    nHint := '�ͻ���Ϣ�Ѷ�ʧ';
  end;
end;

//Desc: ����nSaleMan���µ�nNameΪ��ʱ�ͻ�,���ؿͻ���
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
var nID: Integer;
    nStr: string;
    nBool: Boolean;
begin
  nStr := 'Select C_ID From %s ' +
          'Where C_XuNi=''%s'' And C_SaleMan=''%s'' And C_Name=''%s''';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nSaleMan, nName]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
    Exit;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Insert Into %s(C_Name,C_PY,C_SaleMan,C_XuNi) ' +
            'Values(''%s'',''%s'',''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Customer, nName, GetPinYinOfStr(nName),
            nSaleMan, sFlag_Yes]);
    FDM.ExecuteSQL(nStr);

    nID := FDM.GetFieldMax(sTable_Customer, 'R_ID');
    Result := FDM.GetSerialID2('KH', sTable_Customer, 'R_ID', 'C_ID', nID);

    nStr := 'Update %s Set C_ID=''%s'' Where R_ID=%d';
    nStr := Format(nStr, [sTable_Customer, Result, nID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(A_CID,A_Date) Values(''%s'', %s)';
    nStr := Format(nStr, [sTable_CusAccount, Result, FDM.SQLServerNow]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    //commit if need
  except
    Result := '';
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ���ʱ�����ö��
function IsAutoPayCredit: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_PayCredit)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: ����nCusID��һ�λؿ��¼
function SaveCustomerPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nPayment,nMemo: string; const nMoney: Double;const nID,nZID:string;
 const nCredit: Boolean): Boolean;
var nStr, nData, nSaleManName: string;
    nBool: Boolean;
    nVal,nLimit: Double;
begin
  Result := False;
  nVal := Float2Float(nMoney, cPrecision, False);
  //adjust float value

  {$IFNDEF NoCheckOnPayment}
  if nVal < 0 then
  begin
    nLimit := GetCustomerValidMoney(nCusID, False);
    //get money value
    
    if (nLimit <= 0) or (nLimit < -nVal) then
    begin
      nStr := '�ͻ�: %s ' + #13#10#13#10 +
              '��ǰ���Ϊ[ %.2f ]Ԫ,�޷�֧��[ %.2f ]Ԫ.';
      nStr := Format(nStr, [nCusName, nLimit, -nVal]);
      
      ShowDlg(nStr, sHint);
      Exit;
    end;
  end;
  {$ENDIF}

  nLimit := 0;
  //no limit

  if nCredit and (nVal > 0) and IsAutoPayCredit then
  begin
    nStr := 'Select A_CreditLimit From %s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nCusID]);

    with FDM.QueryTemp(nStr) do
    if (RecordCount > 0) and (Fields[0].AsFloat > 0) then
    begin
      if FloatRelation(nVal, Fields[0].AsFloat, rtGreater) then
           nLimit := Float2Float(Fields[0].AsFloat, cPrecision, False)
      else nLimit := nVal;

      nStr := '�ͻ�[ %s ]��ǰ���ö��Ϊ[ %.2f ]Ԫ,�Ƿ���?' +
              #32#32#13#10#13#10 + '���"��"������[ %.2f ]Ԫ�Ķ��.';
      nStr := Format(nStr, [nCusName, Fields[0].AsFloat, nLimit]);

      if not QueryDlg(nStr, sAsk) then
        nLimit := 0;
      //xxxxx
    end;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set A_InMoney=A_InMoney+%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nVal, nCusID]);
    FDM.ExecuteSQL(nStr);

    {$IFNDEF  PayMentZhika}
    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,' +
            'M_Type,M_Payment,M_Money,M_Date,M_Man,M_Memo,M_RuZhang,M_ID) ' +
            'Values(''%s'',''%s'',''%s'',''%s'',''%s'',%.2f,%s,''%s'',''%s'',''%s'',''%s'')';
    {$ELSE}
    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,' +
            'M_Type,M_Payment,M_Money,M_Date,M_Man,M_Memo,M_RuZhang,M_ID,M_ZID) ' +
            'Values(''%s'',''%s'',''%s'',''%s'',''%s'',%.2f,%s,''%s'',''%s'',''%s'',''%s'',''%s'')';
    {$ENDIF}
    nStr := Format(nStr, [sTable_InOutMoney, nSaleMan, nCusID, nCusName, nType,
            nPayment, nVal, FDM.SQLServerNow, gSysParam.FUserID, nMemo, sFlag_Yes, nID, nZID]);
    FDM.ExecuteSQL(nStr);

    {$IFDEF  PayMentZhika}
    IF nZID<>'' then
    begin
      nStr := 'UPDate %s Set Z_FixedMoney=IsNull(Z_FixedMoney, 0)+(%.2f) Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nVal, nZID]);
      FDM.ExecuteSQL(nStr);
      //����ֽ����ֵ

      nData := Format('%s Ϊ %s ֽ�� %s ��ֵ %s Ԫ', [gSysParam.FUserName, nCusName, nZID, FloatToStr(nVal)]);
      FDM.WriteSysLog(sFlag_BillItem, nID, nData, False);
    end;
    {$ENDIF}

    if (nLimit > 0) and (
       not SaveCustomerCredit(nCusID, '�ؿ�ʱ���', -nLimit, Now)) then
    begin
      nStr := '����δ֪����,���³���ͻ�[ %s ]���ò���ʧ��.' + #13#10 +
              '���ֶ������ÿͻ����ö��.';
      nStr := Format(nStr, [nCusName]);
      ShowDlg(nStr, sHint);
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;

    {$IFDEF SendMsgInOutMoney}
    nStr := ' Select S_Name From %s Where S_ID = ''%s'' ';
    nStr := Format(nStr, [sTable_Salesman, nSaleMan]);

    with FDM.QueryTemp(nStr) do
    if (RecordCount > 0) then
    begin
      nSaleManName := Fields[0].AsString;
    end;
    nData := 'ҵ��Ա: '+nSaleManName+' �ͻ�����: '+nCusName+' �����: '+FloatToStr(nVal);
    SaveCustomerPaymentEvent(nCusID,nData,sFlag_DepKaiPiao,sFlag_Solution_OK,sFlag_DepXiaoShou);
    {$ENDIF}
    
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//�����տ������۲��ŵ���������Ϣ
procedure SaveCustomerPaymentEvent(const nSID,nEvent,
      nFrom,nSolution,nDepartment: string);
var
  nStr:string;
  nEID:string;
begin
  try
    nEID := nSID + FormatDateTime('YYYYMMDD',Now);
    nStr := 'Delete From %s Where E_ID=''%s''';
    nStr := Format(nStr, [sTable_ManualEvent, nEID]);

    FDM.ExecuteSQL(nStr);

    nStr := MakeSQLByStr([
        SF('E_ID', nEID),
        SF('E_Key', ''),
        SF('E_From', nFrom),
        SF('E_Event', nEvent),
        SF('E_Solution', nSolution),
        SF('E_Departmen', nDepartment),
        SF('E_Date', sField_SQLServer_Now, sfVal)
        ], sTable_ManualEvent, '', True);
    FDM.ExecuteSQL(nStr);
  except
    on E: Exception do
    begin
      WriteLog(e.message);
    end;
  end;
end;


//Desc: ����nCusID��һ�λؿ��¼
function SaveCustomerKPPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nPayment,nMemo: string; const nMoney: Double;
 const nCredit: Boolean): Boolean;
var nStr, nData,nSaleManName : string;
    nBool: Boolean;
    nVal,nLimit: Double;
begin
  Result := False;
  nVal := Float2Float(nMoney, cPrecision, False);
  //adjust float value

  {$IFNDEF NoCheckOnPayment}
  if nVal < 0 then
  begin
    nLimit := GetCustomerValidMoney(nCusID, False);
    //get money value
    
    if (nLimit <= 0) or (nLimit < -nVal) then
    begin
      nStr := '�ͻ�: %s ' + #13#10#13#10 +
              '��ǰ���Ϊ[ %.2f ]Ԫ,�޷�֧��[ %.2f ]Ԫ.';
      nStr := Format(nStr, [nCusName, nLimit, -nVal]);
      
      ShowDlg(nStr, sHint);
      Exit;
    end;
  end;
  {$ENDIF}

  nLimit := 0;
  //no limit

  if nCredit and (nVal > 0) and IsAutoPayCredit then
  begin
    nStr := 'Select A_CreditLimit From %s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nCusID]);

    with FDM.QueryTemp(nStr) do
    if (RecordCount > 0) and (Fields[0].AsFloat > 0) then
    begin
      if FloatRelation(nVal, Fields[0].AsFloat, rtGreater) then
           nLimit := Float2Float(Fields[0].AsFloat, cPrecision, False)
      else nLimit := nVal;

      nStr := '�ͻ�[ %s ]��ǰ���ö��Ϊ[ %.2f ]Ԫ,�Ƿ���?' +
              #32#32#13#10#13#10 + '���"��"������[ %.2f ]Ԫ�Ķ��.';
      nStr := Format(nStr, [nCusName, Fields[0].AsFloat, nLimit]);

      if not QueryDlg(nStr, sAsk) then
        nLimit := 0;
      //xxxxx
    end;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set A_InMoney=A_InMoney+%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nVal, nCusID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,' +
            'M_Type,M_Payment,M_Money,M_Date,M_Man,M_Memo,M_RuZhang) ' +
            'Values(''%s'',''%s'',''%s'',''%s'',''%s'',%.2f,%s,''%s'',''%s'',''%s'')';
    nStr := Format(nStr, [sTable_InOutMoney, nSaleMan, nCusID, nCusName, nType,
            nPayment, nVal, FDM.SQLServerNow, gSysParam.FUserID, nMemo,sFlag_No]);
    FDM.ExecuteSQL(nStr);

    if (nLimit > 0) and (
       not SaveCustomerCredit(nCusID, '�ؿ�ʱ���', -nLimit, Now)) then
    begin
      nStr := '����δ֪����,���³���ͻ�[ %s ]���ò���ʧ��.' + #13#10 +
              '���ֶ������ÿͻ����ö��.';
      nStr := Format(nStr, [nCusName]);
      ShowDlg(nStr, sHint);
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    
    {$IFDEF SendMsgInOutMoney}
    nStr := ' Select S_Name From %s Where S_ID = ''%s'' ';
    nStr := Format(nStr, [sTable_Salesman, nSaleMan]);

    with FDM.QueryTemp(nStr) do
    if (RecordCount > 0) then
    begin
      nSaleManName := Fields[0].AsString;
    end;
    nData := 'ҵ��Ա: '+nSaleManName+' �ͻ�����: '+nCusName+' �����: '+FloatToStr(nVal);
    SaveCustomerPaymentEvent(nCusID,nData,sFlag_DepKaiPiao,sFlag_Solution_OK,sFlag_DepXiaoShou);
    {$ENDIF}

    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ����nCusID��һ�����ż�¼
function SaveCustomerCredit(const nCusID,nMemo: string; const nCredit: Double;
 const nEndTime: TDateTime): Boolean;
var nStr: string;
    nVal, nMax : Double;
    nBool: Boolean;
begin
  Result:= False;
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nVal := Float2Float(nCredit, cPrecision, False);
    //adjust float value

    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_CreditVerify]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
         nStr := Fields[0].AsString
    else nStr := sFlag_No;

    if nStr = sFlag_Yes then //�����
    begin
      nStr := MakeSQLByStr([SF('C_CusID', nCusID),
              SF('C_Money', nVal, sfVal),
              SF('C_Man', gSysParam.FUserID),
              SF('C_Date', FDM.SQLServerNow, sfVal),
              SF('C_End', DateTime2Str(nEndTime)),
              SF('C_Memo',nMemo)
              ], sTable_CusCredit, '', True);
      FDM.ExecuteSQL(nStr);
    end else
    begin
      nStr := MakeSQLByStr([SF('C_CusID', nCusID),
              SF('C_Money', nVal, sfVal),
              SF('C_Man', gSysParam.FUserID),
              SF('C_Date', FDM.SQLServerNow, sfVal),
              SF('C_End', DateTime2Str(nEndTime)),
              SF('C_Verify', sFlag_Yes),
              SF('C_VerMan', gSysParam.FUserID),
              SF('C_VerDate', FDM.SQLServerNow, sfVal),
              SF('C_Memo',nMemo)
              ], sTable_CusCredit, '', True);
      FDM.ExecuteSQL(nStr);

      nStr := 'Update %s Set A_CreditLimit=A_CreditLimit+%.2f ' +
              'Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CusAccount, nVal, nCusID]);
      FDM.ExecuteSQL(nStr);
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Date: 2014-09-14
//Parm: �ͻ����
//Desc: ��֤nCusID�Ƿ����㹻��Ǯ,������û�й���
function IsCustomerCreditValid(const nCusID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_CustomerHasMoney, nCusID, '', @nOut) then
       Result := nOut.FData = sFlag_Yes
  else Result := False;
end;

//Date: 2014-10-13
//Desc: ͬ��ҵ��Ա��DLϵͳ
function SyncRemoteSaleMan: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncSaleMan, '', '', @nOut);
end;

//Date: 2014-10-13
//Desc: ͬ���û���DLϵͳ
function SyncRemoteCustomer: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncCustomer, '', '', @nOut);
end;

//Desc: ͬ����Ӧ�̵�DLϵͳ
function SyncRemoteProviders: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncProvider, '', '', @nOut);
end;

//Date: 2014-10-13
//Desc: ͬ��ԭ���ϵ�DLϵͳ
function SyncRemoteMeterails: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncMaterails, '', '', @nOut);
end;

//Date: 2014-09-25
//Parm: ���ƺ�
//Desc: ��ȡnTruck�ĳ�Ƥ��¼
function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetTruckPoundData, nTruck, '', @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nPoundData);
  //xxxxx
end;

//Date: 2014-09-25
//Parm: ��������
//Desc: ����nData��������
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems;const nLogin: Integer): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessCommand(cBC_SaveTruckPoundData, nStr, '', @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  nList := TStringList.Create;
  try
    {$IFDEF CapturePictureEx}
    CapturePictureEx(nTunnel, nLogin, nList);
    {$ELSE}
    CapturePicture(nTunnel, nList);
    //capture file
    {$ENDIF}

    for nIdx:=0 to nList.Count - 1 do
      SavePicture(nOut.FData, nData[0].FTruck,
                              nData[0].FStockName, nList[nIdx]);
    //save file
  finally
    nList.Free;
  end;
end;

//Date: 2014-10-02
//Parm: ͨ����
//Desc: ��ȡnTunnel��ͷ�ϵĿ���
function ReadPoundCard(const nTunnel: string; var nReader: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nReader:= '';
  //����

  if CallBusinessHardware(cBC_GetPoundCard, nTunnel, '', @nOut) then
  begin
    Result := Trim(nOut.FData);
    nReader:= Trim(nOut.FExtParam);
  end;
end;

//Date: 2018-04-27
//Parm: ͨ����
//Desc: ��ȡnTunnel��ͷ�ϵĿ���(���ӱ�ǩ)
function ReadPoundCardEx(var nReader: string;
    const nTunnel: string; nReadOnly: String = ''): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nReader:= '';
  //����

  if CallBusinessHardware(cBC_GetPoundCard, nTunnel, nReadOnly, @nOut)  then
  begin
    Result := Trim(nOut.FData);
    nReader:= Trim(nOut.FExtParam);
  end;
end;

//Date: 2017/5/18
//Parm: ���ƺ���
//Desc: ��ȡ�������õĵ��ӱ�ǩ
function GetTruckRealLabel(const nTruck: string): string;
var nStr: string;
begin
  Result := '';
  //Ĭ������

  nStr := 'Select Top 1 T_Card From %s ' +
          'Where T_Truck=''%s'' And T_CardUse=''%s'' And T_Card Is not NULL';
  nStr := Format(nStr, [sTable_Truck, nTruck, sFlag_Yes]);
  //ѡ��ó���һ���е��ӱ�ǩ�ļ�¼

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsString;
end;

//------------------------------------------------------------------------------
//Date: 2014-10-01
//Parm: ͨ��;����
//Desc: ��ȡ������������
function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean): Boolean;
var nIdx: Integer;
    nSLine,nSTruck: string;
    nListA,nListB: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    if nRefreshLine then
         nSLine := sFlag_Yes
    else nSLine := sFlag_No;

    Result := CallBusinessHardware(cBC_GetQueueData, nSLine, '', @nOut);
    if not Result then Exit;

    nListA.Text := PackerDecodeStr(nOut.FData);
    nSLine := nListA.Values['Lines'];
    nSTruck := nListA.Values['Trucks'];

    nListA.Text := PackerDecodeStr(nSLine);
    SetLength(nLines, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nLines[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FID       := Values['ID'];
      FName     := Values['Name'];
      FStock    := Values['Stock'];
      FValid    := Values['Valid'] <> sFlag_No;
      FPrinterOK:= Values['Printer'] <> sFlag_No;

      if IsNumber(Values['Weight'], False) then
           FWeight := StrToInt(Values['Weight'])
      else FWeight := 1;
    end;

    nListA.Text := PackerDecodeStr(nSTruck);
    SetLength(nTrucks, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nTrucks[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FTruck    := Values['Truck'];
      FLine     := Values['Line'];
      FBill     := Values['Bill'];

      if IsNumber(Values['Value'], True) then
           FValue := StrToFloat(Values['Value'])
      else FValue := 0;

      FInFact   := Values['InFact'] = sFlag_Yes;
      FIsRun    := Values['IsRun'] = sFlag_Yes;
           
      if IsNumber(Values['Dai'], False) then
           FDai := StrToInt(Values['Dai'])
      else FDai := 0;

      if IsNumber(Values['Total'], False) then
           FTotal := StrToInt(Values['Total'])
      else FTotal := 0;
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

//Date: 2014-10-01
//Parm: ͨ����;��ͣ��ʶ
//Desc: ��ͣnTunnelͨ���������
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nEnable then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  CallBusinessHardware(cBC_PrinterEnable, nTunnel, nStr, @nOut);
end;

//Date: 2014-10-07
//Parm: ����ģʽ
//Desc: �л�ϵͳ����ģʽΪnMode
function ChangeDispatchMode(const nMode: Byte): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessHardware(cBC_ChangeDispatchMode, IntToStr(nMode), '',
            @nOut);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: ֽ���Ƿ���Ҫ���
function IsZhiKaNeedVerify: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_ZhiKaVerify)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: �Ƿ��ӡֽ��
function IsPrintZK: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_PrintZK)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: ɾ�����ΪnZID��ֽ��
function DeleteZhiKa(const nZID: string): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Delete From %s Where Z_ID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKa, nZID]);
    Result := FDM.ExecuteSQL(nStr) > 0;

    nStr := 'Delete From %s Where D_ZID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaDtl, nZID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set M_ZID=M_ZID+''_d'' Where M_ZID=''%s''';
    nStr := Format(nStr, [sTable_InOutMoney, nZID]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    //commit if need
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ����nZID����Ϣ��nList��,�����ز�ѯ���ݼ�
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select zk.*,sm.S_Name,cus.C_Name From $ZK zk ' +
          ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          'Where Z_ID=''$ID''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
             MI('$Con', sTable_SaleContract), MI('$SM', sTable_Salesman),
             MI('$Cus', sTable_Customer), MI('$ID', nZID)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount = 1 then
  with nList.Items,Result do
  begin
    Add('ֽ�����:' + nList.Delimiter + FieldByName('Z_ID').AsString);
    Add('ҵ����Ա:' + nList.Delimiter + FieldByName('S_Name').AsString+ ' ');
    Add('�ͻ�����:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('��Ŀ����:' + nList.Delimiter + FieldByName('Z_Project').AsString + ' ');
    
    nStr := DateTime2Str(FieldByName('Z_Date').AsDateTime);
    Add('�쿨ʱ��:' + nList.Delimiter + nStr);
  end else
  begin
    Result := nil;
    nHint := 'ֽ������Ч';
  end;
end;

//Date: 2014-09-14
//Parm: ֽ����;�Ƿ�����
//Desc: ��ȡnZhiKa�Ŀ��ý�Ŷ
function GetZhikaValidMoney(nZhiKa: string; var nFixMoney: Boolean): Double;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetZhiKaMoney, nZhiKa, '', @nOut) then
  begin
    Result := StrToFloat(nOut.FData);
    nFixMoney := nOut.FExtParam = sFlag_Yes;
  end else Result := 0;
end;

//Desc: ��ȡnCID�û��Ŀ��ý��,�������ö�򾻶�
function GetCustomerValidMoney(nCID: string; const nLimit: Boolean;
 const nCredit: PDouble): Double;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nLimit then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  if CallBusinessCommand(cBC_GetCustomerMoney, nCID, nStr, @nOut) then
  begin
    Result := StrToFloat(nOut.FData);
    if Assigned(nCredit) then
      nCredit^ := StrToFloat(nOut.FExtParam);
    //xxxxx
  end else
  begin
    Result := 0;
    if Assigned(nCredit) then
      nCredit^ := 0;
    //xxxxx
  end;
end;

function VerifyTruckLicense(const nReader: string; nBill: TLadingBillItem;
                         var nMsg, nPos: string): Boolean;
var nStr, nDept: string;
    nNeedManu, nUpdate: Boolean;
    nTruck, nEvent, nPicName: string;
    nLastTime: TDateTime;
begin
  Result := False;
  nPos := sFlag_DepBangFang;
  nNeedManu := False;
  nDept := '';
  nTruck := nBill.Ftruck;

  nStr := ' Select D_Value From %s Where D_Name=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_EnableTruck]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nNeedManu := FieldByName('D_Value').AsString = sFlag_Yes;

      if nNeedManu then
      begin
        nMsg := '������[ %s ]����ʶ��������.';
        nMsg := Format(nMsg, [nReader]);
      end
      else
      begin
        nMsg := '������[ %s ]����ʶ���ѹر�.';
        nMsg := Format(nMsg, [nReader]);
        Result := True;
        Exit;
      end;
    end
    else
    begin
      Result := True;
      nMsg := '������[ %s ]δ���ó���ʶ��.';
      nMsg := Format(nMsg, [nReader]);
      Exit;
    end;
  end;

  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_TruckInNeedManu,nPos]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nNeedManu := FieldByName('D_Value').AsString = sFlag_Yes;

      if nNeedManu then
      begin
        nMsg := '������[ %s ]�󶨸�λ[ %s ]��Ԥ����:�˹���Ԥ������.';
        nMsg := Format(nMsg, [nReader, nPos]);
      end
      else
      begin
        nMsg := '������[ %s ]�󶨸�λ[ %s ]��Ԥ����:�˹���Ԥ�ѹر�.';
        nMsg := Format(nMsg, [nReader, nPos]);
        Result := True;
        Exit;
      end;
    end
    else
    begin
      Result := True;
      nMsg := '������[ %s ]�󶨸�λ[ %s ]δ���ø�Ԥ����,�޷����г���ʶ��.';
      nMsg := Format(nMsg, [nReader, nPos]);
      Exit;
    end;
  end;

  nStr := 'Select T_LastTime From %s Where T_Truck=''%s''  ';
  nStr := Format(nStr, [sTable_Truck, nTruck]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      if not nNeedManu then
        Result := True;
      Exit;
    end;

    nLastTime := FieldByName('T_LastTime').AsDateTime;
    WriteLog('ʶ��ʱ��'+DateTimeToStr(nLastTime));
    WriteLog('��ǰʱ��'+DateTimeToStr(Now));
    WriteLog('ʱ���'+FloatToStr(Now-nlastTime));
    if Now - nLastTime <= 0.02 then
    begin
      Result := True;
      nMsg := '����[ %s ]����ʶ��ɹ�,ץ�ĳ��ƺ�:[ %s ]';
      nMsg := Format(nMsg, [nTruck,nTruck]);
      Exit;
    end;
    //����ʶ��ɹ�
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nBill.FID+sFlag_ManualE]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      if FieldByName('E_Result').AsString = 'N' then
      begin
        nMsg := '����[ %s ]����ʶ��ʧ��,����Ա��ֹ';
        nMsg := Format(nMsg, [nTruck]);
        Exit;
      end;
      if FieldByName('E_Result').AsString = 'Y' then
      begin
        Result := True;
        nMsg := '����[ %s ]����ʶ��ʧ��,����Ա����';
        nMsg := Format(nMsg, [nTruck]);
        Exit;
      end;
      nUpdate := True;
    end
    else
    begin
      nMsg := '����[ %s ]����ʶ��ʧ��';
      nMsg := Format(nMsg, [nTruck]);
      nUpdate := False;
      if not nNeedManu then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  nEvent := '����[ %s ]����ʶ��ʧ��';
  nEvent := Format(nEvent, [nTruck]);

  nStr := SF('E_ID', nBill.FID+sFlag_ManualE);
  nStr := MakeSQLByStr([
          SF('E_ID', nBill.FID+sFlag_ManualE),
          SF('E_Key', nPicName),
          SF('E_From', nPos),
          SF('E_Result', 'Null', sfVal),

          SF('E_Event', nEvent),
          SF('E_Solution', sFlag_Solution_YN),
          SF('E_Departmen', nDept),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx
  FDM.ExecuteSQL(nStr);
end;

function GetTruckIsQueue(const nTruck: string): Boolean;
var nStr: string;
    nNow, nPDate, nMDate: TDateTime;
begin
  Result := False;
  //Ĭ�ϲ�����
  nStr := ' Select T_InQueue From %s Where T_Truck=''%s'' and T_InQueue Is Not Null ';
  nStr := Format(nStr, [sTable_ZTTrucks, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := True;
  end;
end;

function GetTruckIsOut(const nTruck: string): Boolean;
var nStr: string;
    nNow, nPDate, nMDate: TDateTime;
begin
  Result := False;
  //Ĭ�ϲ�����
  nStr := ' Select T_InQueue From %s Where T_Truck=''%s'' and T_InQueue Is Not Null and isnull(T_Valid,''Y'') = ''N'' ';
  nStr := Format(nStr, [sTable_ZTTrucks, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := True;
  end;
end;

//Date: 2014-10-16
//Parm: Ʒ���б�(s1,s2..)
//Desc: ��֤nStocks�Ƿ���Է���
function IsStockValid(const nStocks: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_CheckStockValid, nStocks, '', @nOut);
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ���潻����,���ؽ��������б�
function SaveBill(const nBillData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessSaleBill(cBC_SaveBills, nBillData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ɾ��nBillID����
function DeleteBill(const nBill: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_DeleteBill, nBill, '', @nOut);
end;

//Date: 2014-09-15
//Parm: ������;�³���
//Desc: �޸�nBill�ĳ���ΪnTruck.
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_ModifyBillTruck, nBill, nTruck, @nOut);
end;

//Date: 2014-09-30
//Parm: ������;ֽ��
//Desc: ��nBill������nNewZK�Ŀͻ�
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaleAdjust, nBill, nNewZK, @nOut);
end;

//Date: 2014-09-17
//Parm: ������;���ƺ�;У���ƿ�����
//Desc: ΪnBill�������ƿ�
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nBill;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Sale;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

function SaveWebOrderMatch(const nBillID, nWebOrderID, nBillType: string):Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := MakeSQLByStr([SF('WOM_WebOrderID'   , nWebOrderID),
                        SF('WOM_LID'          , nBillID),
                        SF('WOM_StatusType'   , c_WeChatStatusCreateCard),
                        SF('WOM_MsgType'      , cSendWeChatMsgType_AddBill),
                        SF('WOM_BillType'     , nBillType),
                        SF('WOM_deleted'      , sFlag_No)    ],
                        sTable_WebOrderMatch, '', True);
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);
    FDM.ADOConn.CommitTrans;
    Result := True;
  except
    FDM.ADOConn.RollbackTrans;
  end;
end;

//Date: 2016-12-30
//Parm: �ſ���;���ƺ�
//Desc: ΪnTruck���������۴ſ�
function SaveBillLSCard(const nCard,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaveBillLSCard, nCard, nTruck, @nOut);
end;

//���ݶ����Ż�ȡ������Ϣ
function Get_ShopOrderByNo(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessWechat(cBC_WX_get_shoporderbyNO, nXmlStr, '', '' , @nOut,False) then
    Result := nOut.FData;
end;

//Date: 2017-01-03
//Parm: �ͻ����;�ƻ��б�
//Desc: ��ȡnCusID�����ۼƻ�
function LoadSalePlan(const nCusID: string;var nPlans: TSalePlanItems): Boolean;
var nIdx: Integer;
    nListA,nListB: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_LoadSalePlan, nCusID, '', @nOut);
  if not Result then Exit;

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := DecodeBase64(nOut.FData);
    SetLength(nPlans, nListA.Count);

    for nIdx:=0 to nListA.Count-1 do
    begin
      nListB.Text := DecodeBase64(nListA[nIdx]);
      with nPlans[nIdx] do
      begin
        FSelected := False;
        FOrderNo := nListB.Values['billno'];
        FInterID := nListB.Values['inter'];
        FEntryID := nListB.Values['entry'];
        
        FStockID := nListB.Values['id'];
        FStockName := nListB.Values['name'];
        FTruck := nListB.Values['truck'];
        FValue := StrToFloat(nListB.Values['value']);
      end;
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;   
end;

//Date: 2014-09-17
//Parm: ��������;�ſ�
//Desc: ��nBill.nCard
function SaveBillCard(const nBill, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaveBillCard, nBill, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: �ſ���
//Desc: ע��nCard
function LogoutBillCard(const nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_LogoffCard, nCard, '', @nOut);
end;

//Date: 2014-09-17
//Parm: �ſ���;��λ;�������б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ľ������б�
function GetLadingBills(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nBills);
  //xxxxx
end;

//Date: 2014-09-18
//Parm: ��λ;�������б�;��վͨ��
//Desc: ����nPost��λ�ϵĽ���������
function SaveLadingBills(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem;const nLogin: Integer): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessSaleBill(cBC_SavePostBills, nStr, nPost, @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  if Assigned(nTunnel) then //��������
  begin
    nList := TStringList.Create;
    try
      {$IFDEF CapturePictureEx}
      CapturePictureEx(nTunnel, nLogin, nList);
      {$ELSE}
      CapturePicture(nTunnel, nList);
      //capture file
      {$ENDIF}

      for nIdx:=0 to nList.Count - 1 do
        SavePicture(nOut.FData, nData[0].FTruck,
                                nData[0].FStockName, nList[nIdx]);
      //save file
    finally
      nList.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015/9/19
//Parm: 
//Desc: ����ɹ����뵥
function SaveOrderBase(const nOrderData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrderBase, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

function DeleteOrderBase(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrderBase, nOrder, '', @nOut);
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ����ɹ���,���زɹ������б�
function SaveOrder(const nOrderData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrder, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ɾ��nBillID����
function DeleteOrder(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrder, nOrder, '', @nOut);
end;

//Date: 2014-09-17
//Parm: ������;���ƺ�;У���ƿ�����
//Desc: ΪnBill�������ƿ�
function SetOrderCard(const nOrder,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nOrder;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Provide;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2014-09-17
//Parm: ��������;�ſ�
//Desc: ��nBill.nCard
function SaveOrderCard(const nOrder, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_SaveOrderCard, nOrder, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: �ſ���
//Desc: ע��nCard
function LogoutOrderCard(const nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_LogOffOrderCard, nCard, '', @nOut);
end;

//Date: 2014-09-15
//Parm: ������;�³���
//Desc: �޸�nOrder�ĳ���ΪnTruck.
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_ModifyBillTruck, nOrder, nTruck, @nOut);
end;

//Date: 2014-09-17
//Parm: �ſ���;��λ;�������б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ľ������б�
function GetPurchaseOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_GetPostOrders, nCard, nPost, @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nBills);
  //xxxxx
end;

//Date: 2014-09-18
//Parm: ��λ;�������б�;��վͨ��
//Desc: ����nPost��λ�ϵĽ���������
function SavePurchaseOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem;const nLogin: Integer): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessPurchaseOrder(cBC_SavePostOrders, nStr, nPost, @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  if Assigned(nTunnel) then //��������
  begin
    nList := TStringList.Create;
    try
      {$IFDEF CapturePictureEx}
      CapturePictureEx(nTunnel, nLogin, nList);
      {$ELSE}
      CapturePicture(nTunnel, nList);
      //capture file
      {$ENDIF}

      for nIdx:=0 to nList.Count - 1 do
        SavePicture(nOut.FData, nData[0].FTruck,
                                nData[0].FStockName, nList[nIdx]);
      //save file
    finally
      nList.Free;
    end;
  end;
end;


//Date: 2014-09-17
//Parm: ��������; MCListBox;�ָ���
//Desc: ��nItem����nMC
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  with nItem,nMC do
  begin
    Clear;
    Add(Format('���ƺ���:%s %s', [nDelimiter, FTruck]));
    Add(Format('��ǰ״̬:%s %s', [nDelimiter, TruckStatusToStr(FStatus)]));

    Add(Format('%s ', [nDelimiter]));
    Add(Format('��������:%s %s', [nDelimiter, FId]));
    Add(Format('��������:%s %.3f ��', [nDelimiter, FValue]));
    if FType = sFlag_Dai then nStr := '��װ' else nStr := 'ɢװ';

    Add(Format('Ʒ������:%s %s', [nDelimiter, nStr]));
    Add(Format('Ʒ������:%s %s', [nDelimiter, FStockName]));
    
    Add(Format('%s ', [nDelimiter]));
    Add(Format('����ſ�:%s %s', [nDelimiter, FCard]));
    Add(Format('��������:%s %s', [nDelimiter, BillTypeToStr(FIsVIP)]));
    Add(Format('�ͻ�����:%s %s', [nDelimiter, FCusName]));
  end;
end;

//Date: 2014-09-17
//Parm: ��������; MCListBox;�ָ���
//Desc: ��nItem����nMC
procedure LoadOrderItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  with nItem,nMC do
  begin
    Clear;
    Add(Format('���ƺ���:%s %s', [nDelimiter, FTruck]));
    Add(Format('��ǰ״̬:%s %s', [nDelimiter, TruckStatusToStr(FStatus)]));

    Add(Format('%s ', [nDelimiter]));
    Add(Format('�ɹ�����:%s %s', [nDelimiter, FZhiKa]));
//    Add(Format('��������:%s %.3f ��', [nDelimiter, FValue]));
    if FType = sFlag_Dai then nStr := '��װ' else nStr := 'ɢװ';

    Add(Format('Ʒ������:%s %s', [nDelimiter, nStr]));
    Add(Format('Ʒ������:%s %s', [nDelimiter, FStockName]));
    
    Add(Format('%s ', [nDelimiter]));
    Add(Format('�ͻ��ſ�:%s %s', [nDelimiter, FCard]));
    Add(Format('��������:%s %s', [nDelimiter, BillTypeToStr(FIsVIP)]));
    Add(Format('�� Ӧ ��:%s %s', [nDelimiter, FCusName]));
  end;
end;

//------------------------------------------------------------------------------
//Desc: ÿ���������
function GetHYMaxValue: Double;
var nStr: string;
begin
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_HYValue]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsFloat
  else Result := 0;
end;

//Desc: ��ȡnNoˮ���ŵ��ѿ���
function GetHYValueByStockNo(const nNo: string): Double;
var nStr: string;
begin
  nStr := 'Select R_SerialNo,Sum(H_Value) From %s ' +
          ' Left Join %s on H_SerialNo= R_SerialNo ' +
          'Where R_SerialNo=''%s'' Group By R_SerialNo';
  nStr := Format(nStr, [sTable_StockRecord, sTable_StockHuaYan, nNo]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[1].AsFloat
  else Result := -1;
end;

//Desc: ���nWeek�Ƿ���ڻ����
function IsWeekValid(const nWeek: string; var nHint: string): Boolean;
var nStr: string;
begin
  nStr := 'Select W_End,$Now From $W Where W_NO=''$NO''';
  nStr := MacroValue(nStr, [MI('$W', sTable_InvoiceWeek),
          MI('$Now', FDM.SQLServerNow), MI('$NO', nWeek)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsDateTime + 1 > Fields[1].AsDateTime;
    if not Result then
      nHint := '�ý��������ѽ���';
    //xxxxx
  end else
  begin
    Result := False;
    nHint := '�ý�����������Ч';
  end;
end;

function IsWeekValidEx(const nWeek: string; var nHint: string; var nBegin,nEnd: TDateTime): Boolean;
var nStr: string;
begin
  nStr := 'Select W_Begin, W_End,$Now From $W Where W_NO=''$NO''';
  nStr := MacroValue(nStr, [MI('$W', sTable_InvoiceWeek),
          MI('$Now', FDM.SQLServerNow), MI('$NO', nWeek)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nBegin := Fields[0].AsDateTime;
    nEnd   := Fields[1].AsDateTime;

    Result := Fields[1].AsDateTime + 7 > Fields[2].AsDateTime;
    if not Result then
      nHint := '�ý��������ѽ���';
    //xxxxx
  end else
  begin
    Result := False;
    nHint := '�ý�����������Ч';
  end;
end;

//Desc: ���nWeek�Ƿ�������
function IsWeekHasEnable(const nWeek: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Top 1 * From $Req Where R_Week=''$NO''';
  nStr := MacroValue(nStr, [MI('$Req', sTable_InvoiceReq), MI('$NO', nWeek)]);
  Result := FDM.QueryTemp(nStr).RecordCount > 0;
end;

//Desc: ���nWeek����������Ƿ�������
function IsNextWeekEnable(const nWeek: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Top 1 * From $Req Where R_Week In ' +
          '( Select W_NO From $W Where W_Begin > (' +
          '  Select Top 1 W_Begin From $W Where W_NO=''$NO''))';
  nStr := MacroValue(nStr, [MI('$Req', sTable_InvoiceReq),
          MI('$W', sTable_InvoiceWeek), MI('$NO', nWeek)]);
  Result := FDM.QueryTemp(nStr).RecordCount > 0;
end;

//Desc: ���nWeeǰ��������Ƿ��ѽ������
function IsPreWeekOver(const nWeek: string): Integer;
var nStr: string;
begin
  nStr := 'Select Count(*) From $Req Where (R_ReqValue<>R_KValue) And ' +
          '(R_Week In ( Select W_NO From $W Where W_Begin < (' +
          '  Select Top 1 W_Begin From $W Where W_NO=''$NO'')))';
  nStr := MacroValue(nStr, [MI('$Req', sTable_InvoiceReq),
          MI('$W', sTable_InvoiceWeek), MI('$NO', nWeek)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsInteger
  else Result := 0;
end;

//Desc: �����û�������
function SaveCompensation(const nSaleMan,nCusID,nCusName,nPayment,nMemo: string;
 const nMoney: Double): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set A_Compensation=A_Compensation+%s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nMoney), nCusID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,M_Type,M_Payment,' +
            'M_Money,M_Date,M_Man,M_Memo) Values(''%s'',''%s'',''%s'',' +
            '''%s'',''%s'',%s,%s,''%s'',''%s'')';
    nStr := Format(nStr, [sTable_InOutMoney, nSaleMan, nCusID, nCusName,
            sFlag_MoneyFanHuan, nPayment, FloatToStr(nMoney),
            FDM.SQLServerNow, gSysParam.FUserID, nMemo]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ӡ��ʶΪnID�����ۺ�ͬ
procedure PrintSaleContractReport(const nID: string; const nAsk: Boolean);
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ���ۺ�ͬ?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select sc.*,S_Name,C_Name From $SC sc ' +
          '  Left Join $SM sm On sm.S_ID=sc.C_SaleMan ' +
          '  Left Join $Cus cus On cus.C_ID=sc.C_Customer ' +
          'Where sc.C_ID=''$ID''';

  nStr := MacroValue(nStr, [MI('$SC', sTable_SaleContract),
          MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
          MI('$ID', nID)]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s] �����ۺ�ͬ����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select * From %s Where E_CID=''%s''';
  nStr := Format(nStr, [sTable_SContractExt, nID]);
  FDM.QuerySQL(nStr);

  nStr := gPath + sReportDir + 'SaleContract.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
end;

//Desc: ��ӡֽ��
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡֽ��?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select zk.*,C_Name,S_Name From %s zk ' +
          ' Left Join %s cus on cus.C_ID=zk.Z_Customer' +
          ' Left Join %s sm on sm.S_ID=zk.Z_SaleMan ' +
          'Where Z_ID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKa, sTable_Customer, sTable_Salesman, nZID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := 'ֽ����Ϊ[ %s ] �ļ�¼����Ч';
    nStr := Format(nStr, [nZID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select * From %s Where D_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, nZID]);
  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] ��ֽ������ϸ';
    nStr := Format(nStr, [nZID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ZhiKa.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ�վ�
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�վ�?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_SysShouJu, nSID]);

  {$IFDEF ShouJuAddMID}
    nStr := 'SELECT M_Payment,a.* FROM Sys_ShouJu a ' +
            'Left Join Sys_CustomerInOutMoney b On S_MID=M_ID ' +
            'Where a.R_ID=%s ';
    nStr := Format(nStr, [nSID]);
  {$ENDIF}
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := 'ƾ����Ϊ[ %s ] ���վ�����Ч!!';
    nStr := Format(nStr, [nSID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ShouJu.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ�����
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
var nStr, nCusType: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�����?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From S_Customer Left Join S_Bill On C_ID=L_CusID '+
          'Where L_ID=''%s''  ';
  nStr := Format(nStr, [nBill]);
  //xxxxx
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount>0 then
    begin
      nCusType:= FieldByname('C_Type').AsString;
      nCusType:= StringReplace(nCusType, ' ', '', [rfReplaceAll]);
      nCusType:= StringReplace(nCusType, '=', '', [rfReplaceAll]);
    end;
  end;
  nCusType:= Format(',''%s'' As CusType ', [nCusType]);


  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //�������

  nStr := 'Select b.*,c.*,d.Z_Name'+ nCusType +' From %s b,%s c,%s d Where '+
          'b.L_Truck=c.T_Truck and b.L_ZhiKa=d.Z_ID and L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill,sTable_Truck,sTable_ZhiKa, nBill]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'LadingBill.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

// ��ι�ë����״̬����ֹ��δ������ɣ�˾������������
function AdjustBillStatus(const nID: string): Boolean;
var nstr:string;
begin
  Result:= True;
  nStr := 'UPDate S_Bill Set L_Status=(Case When L_Type=''D'' Then ''Z'' Else ''F'' End), L_NextStatus=''M''  '+
          'Where (L_Status=''M'' And L_NextStatus=''O'') And L_ID=''%s'' ';
  nStr := Format(nStr, [nID]);
  
  FDM.ExecuteSQL(nStr);
end;

//Date: 2012-4-1
//Parm: �ɹ�����;��ʾ;���ݶ���;��ӡ��
//Desc: ��ӡnOrder�ɹ�����
function PrintOrderReport(const nOrder: string;  const nAsk: Boolean;
                          const nMul: Boolean = False): Boolean;
var nStr: string;
    nDS: TDataSet;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�ɹ���?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  if nMul then
    nStr := 'Select * From %s oo Inner Join %s od on oo.O_ID=od.D_OID Where D_ID In (%s)'
  else
    nStr := 'Select * From %s oo Inner Join %s od on oo.O_ID=od.D_OID Where D_ID=''%s''';
  nStr := Format(nStr, [sTable_Order, sTable_OrderDtl, nOrder]);

  nDS := FDM.QueryTemp(nStr);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nStr := '�ɹ���[ %s ] ����Ч!!';
    nStr := Format(nStr, [nOrder]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + 'Report\PurchaseOrder.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2012-4-15
//Parm: ��������;�Ƿ�ѯ��;�Ƿ�������ӡ
//Desc: ��ӡnPound������¼
function PrintPoundReport(const nPound: string; nAsk: Boolean;
                          const nMul: Boolean = False): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ������?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;
  if nMul then
    nStr := 'Select * From %s Where P_ID In (%s)'
  else
    nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nPound]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���ؼ�¼[ %s ] ����Ч!!';
    nStr := Format(nStr, [nPound]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;

  if Result  then
  begin
    nStr := 'Update %s Set P_PrintNum=P_PrintNum+1 Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nPound]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Date: 2017-01-11
//Parm: �ɹ�����;�Ƿ񵯳�ѯ��
//Desc: ��ӡ�ɹ����յ�
function PrintRCOrderReport(const nID: string;  const nAsk: Boolean): Boolean;
var nStr: string;
    nDS: TDataSet;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�볧��?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where O_ID=''%s''';
  nStr := Format(nStr, [sTable_Order, nID]);

  nDS := FDM.QueryTemp(nStr);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nStr := '�볧��[ %s ] ����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + 'Report\ProvideRC.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ȡnStockƷ�ֵı����ļ�
function GetReportFileByStock(const nStock: string): string;
begin
  Result := GetPinYinOfStr(nStock);

  if Pos('dj', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42_DJ.fr3'
  else if Pos('gsysl', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan_gsl.fr3'
    
  else if (Pos('kzf', Result) > 0)or(Pos('kzwf', Result) > 0) then
    Result := gPath + sReportDir + 'HuaYan_kzf.fr3'
  {$IFNDEF HYJC}
  else if Pos('qz', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan_qz.fr3'
  {$ENDIF}
  else if Pos('32', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan32.fr3'
  else if Pos('42', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42.fr3'
  else if Pos('52', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan52.fr3'
  else if Pos('qzzx', Result) > 0 then
    Result := gPath + sReportDir + 'qzzx.fr3'
  else if Pos('fmh', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYanFMH.fr3'
  else if Pos('jzs', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYanJZS.fr3'
  else Result := '';
end;

//Desc: ��ӡ��ʶΪnHID�Ļ��鵥
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean;n28D: Boolean): Boolean;
var nStr,nSR,nCusType,nBill: string;
    nDS: TDataSet;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ���鵥?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;


  nStr:= 'Select * From $HY Where H_ID=$ID';
  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
                            MI('$ID', nHID)]);
  //xxxxx
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nBill:= FieldByName('H_Reporter').AsString;
  end;

  nStr := 'Select * From %s Left Join %s On L_CusID=C_ID Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, sTable_Customer, nBill]);
  nDS := FDM.QueryTemp(nStr);
  if Assigned(nDS) then
  if nDS.RecordCount > 0 then
  begin
    nCusType:= StringReplace((nDS.FieldByName('C_Type').AsString), ' ', '', [rfReplaceAll]);
    nCusType:= StringReplace(nCusType, '=', '', [rfReplaceAll]);
  end;
  nstr:= '';

  nSR := 'Select DATEPART(YEAR,R_Date) RTime,* From %s sr ' +
         ' Left Join %s sp on sp.P_ID=sr.R_PID';
  nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);

  {$IFNDEF HYPrintNum}
    nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
  {$ELSE}
    nStr := 'Select IsNull(H_PrintNum, 0)+1 PrintNum, hy.*,sr.*,C_Name From $HY hy ' +
  {$ENDIF}
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          {$IFDEF SRecordNeedDistinguish} ' And RTime=DATEPART(YEAR,H_BillDate) '+ {$ENDIF}
          ' Where H_ID in ($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nHID)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �Ļ��鵥��¼����Ч!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
  nStr := GetReportFileByStock(nStr);

  {$IFDEF BehalfConsignor}
  //���´�����
  if nCusType<>'' then
  begin
    nStr:= StringReplace(nStr, '.fr3', '_'+nCusType+'.fr3', [rfReplaceAll]);
    WriteLog(nStr);
  end;
  {$ENDIF}

  IF n28D then nStr:= StringReplace(nStr, '.fr3', '_28.fr3', [rfReplaceAll]);
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�:' + nStr;
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ��ʶΪnID�ĺϸ�֤
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ�ϸ�֤?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  {$IFDEF HeGeZhengSimpleData}
  nSR := 'Select * From %s hy ' +
         '  Left Join %s b On b.L_ID=hy.H_Reporter ' +
         '  Left Join %s sp On sp.P_Stock=b.L_StockName ' +
         'Where hy.H_ID in (%s)';
  nStr := Format(nSR, [sTable_StockHuaYan, sTable_Bill, sTable_StockParam, nHID]);
  {$ELSE}
  nSR := 'Select R_SerialNo,P_Stock,P_Name,P_QLevel From %s sr ' +
         ' Left Join %s sp on sp.P_ID=sr.R_PID';
  nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);

  nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          'Where H_ID in ($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nHID)]);
  //xxxxx
  {$ENDIF}

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �Ļ��鵥��¼����Ч!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

function PrintHeGeReportEx(const nLID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ�ϸ�֤?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nSR := 'Select sp.*,L_HYDan, isnull(b.L_OutFact,b.L_Date) as L_OutFact From %s b ' +
         '  Left Join %s sp On sp.P_Stock=b.L_StockName ' +
         'Where b.L_ID =''%s'' ';
  nStr := Format(nSR, [sTable_Bill, sTable_StockParam, nLID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �Ľ�����¼����Ч!!';
    nStr := Format(nStr, [nLID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2016-8-10
//Parm: ��������;��ʾ
//Desc: ��ӡnBill���ŵķ��˵�
function PrintBillFYDReport(const nBill: string;  const nAsk: Boolean): Boolean;
var nStr: string;
    nDS: TDataSet;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�ֳ����˵�?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s  Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  nDS := FDM.QueryTemp(nStr);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nStr := '������[ %s ] ����Ч!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + 'Report\BillFYD.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ��·��
function PrintBillLoadReport(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string; 
    nDS: TDataSet;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ��·��?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s  Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  nDS := FDM.QueryTemp(nStr);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nStr := '������[ %s ] ����Ч!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + 'Report\BillLoad.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;                                                 

//Date: 2015/1/18
//Parm: ���ƺţ����ӱ�ǩ���Ƿ����ã��ɵ��ӱ�ǩ
//Desc: ����ǩ�Ƿ�ɹ����µĵ��ӱ�ǩ
function SetTruckRFIDCard(nTruck: string; var nRFIDCard: string;
  var nIsUse: string; nOldCard: string=''): Boolean;
var nP: TFormCommandParam;
begin
  nP.FParamA := nTruck;
  nP.FParamB := nOldCard;
  nP.FParamC := nIsUse;
  CreateBaseFormItem(cFI_FormMakeRFIDCard, '', @nP);

  nRFIDCard := nP.FParamB;
  nIsUse    := nP.FParamC;
  Result    := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2016/8/7
//Parm: ���ƺ�
//Desc: �鿴�����ϴι���ʱ����
function GetTruckLastTime(const nTruck: string): Integer;
var nStr: string;
    nNow, nPDate, nMDate: TDateTime;
begin
  Result := -1;
  //Ĭ������

  nStr := 'Select Top 1 %s as T_Now,P_PDate,P_MDate ' +
          'From %s Where P_Truck=''%s'' Order By P_ID Desc';
  nStr := Format(nStr, [sField_SQLServer_Now, sTable_PoundLog, nTruck]);
  //ѡ�����һ�ι���

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nNow   := FieldByName('T_Now').AsDateTime;
    nPDate := FieldByName('P_PDate').AsDateTime;
    nMDate := FieldByName('P_MDate').AsDateTime;

    if nPDate > nMDate then
         Result := Trunc((nNow - nPDate) * 24 * 60 * 60)
    else Result := Trunc((nNow - nMDate) * 24 * 60 * 60);
  end;
end;

function IsStrictSanValue: Boolean;
var nSQL: string;
begin
  Result := False;

  nSQL := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, sFlag_StrictSanVal]);

  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
    Result := Fields[0].AsString = sFlag_Yes;
end;

function GetFQValueByStockNo(const nStock: string): Double;
var nSQL: string;
begin
  Result := 0;
  if nStock = '' then Exit;

  nSQL := 'Select Sum(L_Value) From %s Where L_Seal=''%s'' ' +
          'and L_Date > GetDate() - 30';   //һ�����ڵ��ܼ�
  nSQL := Format(nSQL, [sTable_Bill, nStock]);
  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
    Result := Fields[0].AsFloat;
end;

function VerifyFQSumValue: Boolean;
var nStr: string;
begin
  Result := False;
  //Ĭ�ϲ��ж�

  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_VerifyFQValue]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Fields[0].AsString = sFlag_Yes;
end;

function OpenDoorByReader(const nReader: string; nType: string = 'Y'): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessHardware(cBC_OpenDoorByReader, nReader, nType,
            @nOut, False);
end;

//------------------------------------------------------------------------------
//��ȡ�ͻ�ע����Ϣ
function getCustomerInfo(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_getCustomerInfo, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//�ͻ���΢���˺Ű�
function get_Bindfunc(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_get_Bindfunc, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//������Ϣ
function send_event_msg(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_send_event_msg, nData, '', '', @nOut,false) then
       Result := nOut.FData
  else Result := '';
end;

//�����̳��û�
function edit_shopclients(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_edit_shopclients, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//�����Ʒ
function edit_shopgoods(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_edit_shopgoods, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//��ȡ������Ϣ
function get_shoporders(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_get_shoporders, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//���¶���״̬
function complete_shoporders(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_complete_shoporders, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//------------------------------------------------------------------------------
//��ȡ���������Ϣ
function getAuditTruck(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_GetAuditTruck, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//------------------------------------------------------------------------------
//������˽���ϴ�
function UpLoadAuditTruck(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_UpLoadAuditTruck, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//------------------------------------------------------------------------------
//����ͼƬ
function DownLoadPic(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_DownLoadPic, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//------------------------------------------------------------------------------
//���ݳ��ƺŻ�ȡ����
function GetshoporderbyTruck(const nData: string): string;
var nOut: TWorkerWebChatData;
begin
  if CallBusinessWechat(cBC_WX_get_shoporderbyTruck, nData, '', '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2017-11-22
//Parm: ��������,�̳����뵥
//Desc: ����ɾ��������Ϣ
procedure SaveWebOrderDelMsg(const nLID, nBillType: string);
var nStr, nWebOrderID: string;
    nBool: Boolean;
begin
  nStr := 'Select WOM_WebOrderID From %s Where WOM_LID=''%s'' ';
  nStr := Format(nStr, [sTable_WebOrderMatch, nLID]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount <= 0 then
      Exit;
    //�ֹ���
    nWebOrderID := Fields[0].AsString;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Insert Into %s(WOM_WebOrderID,WOM_LID,WOM_StatusType,' +
            'WOM_MsgType,WOM_BillType) Values(''%s'',''%s'',%d,' +
            '%d,''%s'')';
    nStr := Format(nStr, [sTable_WebOrderMatch, nWebOrderID, nLID, c_WeChatStatusDeleted,
            cSendWeChatMsgType_DelBill, nBillType]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
  except
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2017-10-17
//Parm: ���ƺ�;��������
//Desc: ��nTruck����Ϊ����ΪnLen���ַ���
function GetTruckNO(const nTruck: WideString; const nLong: Integer): string;
var nStr: string;
    nIdx,nLen,nPos: Integer;
begin
  nPos := 0;
  nLen := 0;

  for nIdx:=Length(nTruck) downto 1 do
  begin
    nStr := nTruck[nIdx];
    nLen := nLen + Length(nStr);

    if nLen >= nLong then Break;
    nPos := nIdx;
  end;

  Result := Copy(nTruck, nPos, Length(nTruck));
  nIdx := nLong - Length(Result);
  Result := Result + StringOfChar(' ', nIdx);
end;

function GetValue(const nValue: Double): string;
var nStr: string;
begin
  nStr := Format('      %.2f', [nValue]);
  Result := Copy(nStr, Length(nStr) - 6 + 1, 6);
end;

//��֤�������ӱ�ǩ
function IsEleCardVaid(const nTruckNo: string): Boolean;
var
  nSql:string;
begin
  Result := True;

  nSql := 'select * from %s where T_Truck = ''%s'' ';
  nSql := Format(nSql,[sTable_Truck,nTruckNo]);

  with FDM.QueryTemp(nSql) do
  begin
    if recordcount>0 then
    begin
      if FieldByName('T_CardUse').AsString = sFlag_Yes then//����
      begin
        if (FieldByName('T_Card').AsString = '') and (FieldByName('T_Card2').AsString = '') then
        begin
          Result := False;
          Exit;
        end;
      end;
    end;
  end;
end;

//��֤�������ӱ�ǩ
function IsEleCardVaidEx(const nTruckNo: string): Boolean;
var
  nSql:string;
begin
  Result := False;

  nSql := 'select * from %s where T_Truck = ''%s'' ';
  nSql := Format(nSql,[sTable_Truck,nTruckNo]);

  with FDM.QueryTemp(nSql) do
  begin
    if recordcount>0 then
    begin
      if FieldByName('T_CardUse').AsString = sFlag_Yes then//����
      begin
        if (FieldByName('T_Card').AsString <> '') or (FieldByName('T_Card2').AsString <> '') then
        begin
          Result := True;
        end;
      end;
    end;
  end;
end;

//��֤�����Ƿ���Ҫ������ˮ
function IfStockHasLs(const nStockNo: string): Boolean;
var
  nSql:string;
begin
  Result := False;

  nSql := 'select * from %s where M_ID = ''%s'' ';
  nSql := Format(nSql,[sTable_Materails,nStockNo]);

  with FDM.QueryTemp(nSql) do
  begin
    if recordcount>0 then
    begin
      if FieldByName('M_HasLs').AsString = sFlag_Yes then//����
      begin
        Result := True;
      end;
    end;
  end;
end;

//�����Ƿ����δ��ɲɹ���
function IFHasOrder(const nTruck: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr :='select D_ID from %s where D_Status <> ''%s'' and D_Truck =''%s'' ';
  nStr := Format(nStr, [sTable_OrderDtl, sFlag_TruckOut, nTruck]);
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := True;
  end;
end;

procedure ProberShowTxt(const nTunnel, nText: string);
var nOut: TWorkerBusinessCommand;
begin
  CallBusinessHardware(cBC_ShowTxt, nTunnel, nText, @nOut);
end;

//Desc: ���������ض��ֶ�����(�ض�ʹ��)
function MakeSaleViewData: Boolean;
var nID: string;
    nStr: string;
    nList : TStrings;
    nIdx, nInt, nMax: Integer;
    nDataView: string;
begin
  nMax := 49;
  nDataView := ' (40 + 899*rand() / 100) ';

  nStr := 'Select D_Value, D_Memo From %s ' +
          'Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_DataView]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nInt := Abs(Fields[1].AsInteger - Fields[0].AsInteger) * 100 - 1;
    nDataView := ' (' + Fields[0].AsString + ' + ' + IntToStr(nInt) + '*rand() / 100) ';
  end;

  nList := TStringList.Create;
  try
    nStr := 'Select top 1000 L_ID , L_MValue From %s ' +
            'Where L_MValueView is null';
    nStr := Format(nStr, [sTable_Bill]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nID := Fields[0].AsString;

        if Fields[1].AsString = '' then
        begin
          Next;
          Continue;
        end;

        if Fields[1].AsFloat <= nMax then
        begin
          nStr := 'Update %s Set L_MValueview = L_MValue Where L_ID=''%s''';
          nStr := Format(nStr, [sTable_Bill, nID]);
          nList.Add(nStr);

          nStr := 'Update %s Set L_Valueview = L_Value Where L_ID=''%s''';
          nStr := Format(nStr, [sTable_Bill, nID]);
          nList.Add(nStr);

          nStr := 'Update a set a.P_MValueView = b.L_MValueView,'+
                  ' a.P_ValueView = b.L_ValueView from %s a, %s b'+
                  ' where  a.P_Bill = b.L_ID and b.L_ID=''%s''';
          nStr := Format(nStr, [sTable_PoundLog, sTable_Bill, nID]);
          nList.Add(nStr);
        end
        else
        begin
          nStr := 'Update %s Set L_MValueview = %s Where L_ID=''%s''';
          nStr := Format(nStr, [sTable_Bill, nDataView, nID]);
          nList.Add(nStr);

          nStr := 'Update %s Set L_Valueview = L_MValueView - L_PValue Where L_ID=''%s''';
          nStr := Format(nStr, [sTable_Bill, nID]);
          nList.Add(nStr);

          nStr := 'Update a set a.P_MValueView = b.L_MValueView,'+
                  ' a.P_ValueView = b.L_ValueView from %s a, %s b'+
                  ' where  a.P_Bill = b.L_ID and b.L_ID=''%s''';
          nStr := Format(nStr, [sTable_PoundLog, sTable_Bill, nID]);
          nList.Add(nStr);
        end;
        Next;
      end;
    end;

    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=0 to nList.Count - 1 do
      begin
        WriteLog('���ݵ���SQL:' + nList[nIdx]);
        FDM.ExecuteSQL(nList[nIdx]);
      end;
      FDM.ADOConn.CommitTrans;
    except
      On E: Exception do
      begin
        Result := False;
        FDM.ADOConn.RollbackTrans;
        WriteLog(E.Message);
      end;
    end;
  finally
    nList.Free;
  end;
end;

//Desc: ���ɲɹ��ض��ֶ�����(�ض�ʹ��)
function MakeOrderViewData: Boolean;
var nID: string;
    nStr: string;
    nList : TStrings;
    nIdx, nInt, nMax: Integer;
    nDataView: string;
begin
  nMax := 49;
  nDataView := ' (40 + 899*rand() / 100) ';

  nStr := 'Select D_Value, D_Memo From %s ' +
          'Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_DataView]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nMax := Fields[1].AsInteger;
    nInt := Abs(Fields[1].AsInteger - Fields[0].AsInteger) * 100 - 1;
    nDataView := ' (' + Fields[0].AsString + ' + ' + IntToStr(nInt) + '*rand() / 100) ';
  end;

  nList := TStringList.Create;
  try
    nStr := 'Select top 1000 D_ID ,D_MValue From %s ' +
            'Where D_MValueView is null';
    nStr := Format(nStr, [sTable_OrderDtl]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nID := Fields[0].AsString;

        if Fields[1].AsString = '' then
        begin
          Next;
          Continue;
        end;

        if Fields[1].AsFloat <= nMax then
        begin
          nStr := 'Update %s Set D_MValueview = D_MValue Where D_ID=''%s''';
          nStr := Format(nStr, [sTable_OrderDtl, nID]);
          nList.Add(nStr);

          nStr := 'Update %s Set D_Valueview = D_MValue - D_PValue Where D_ID=''%s''';
          nStr := Format(nStr, [sTable_OrderDtl, nID]);
          nList.Add(nStr);

          nStr := 'Update a set a.P_MValueView = b.D_MValueView,'+
                  ' a.P_ValueView = b.D_ValueView from %s a, %s b'+
                  ' where  a.P_Order = b.D_ID and b.D_ID=''%s''';
          nStr := Format(nStr, [sTable_PoundLog, sTable_OrderDtl, nID]);
          nList.Add(nStr);
        end
        else
        begin
          nStr := 'Update %s Set D_MValueview = %s Where D_ID=''%s''';
          nStr := Format(nStr, [sTable_OrderDtl, nDataView, nID]);
          nList.Add(nStr);

          nStr := 'Update %s Set D_Valueview = D_MValueView - D_PValue Where D_ID=''%s''';
          nStr := Format(nStr, [sTable_OrderDtl, nID]);
          nList.Add(nStr);

          nStr := 'Update a set a.P_MValueView = b.D_MValueView,'+
                  ' a.P_ValueView = b.D_ValueView from %s a, %s b'+
                  ' where  a.P_Order = b.D_ID and b.D_ID=''%s''';
          nStr := Format(nStr, [sTable_PoundLog, sTable_OrderDtl, nID]);
          nList.Add(nStr);
        end;
        Next;
      end;
    end;

    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=0 to nList.Count - 1 do
      begin
        WriteLog('���ݵ���SQL:' + nList[nIdx]);
        FDM.ExecuteSQL(nList[nIdx]);
      end;
      FDM.ADOConn.CommitTrans;
    except
      On E: Exception do
      begin
        Result := False;
        FDM.ADOConn.RollbackTrans;
        WriteLog(E.Message);
      end;
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2017-09-22
//Parm: ���̵�����
//Desc: ����̵���,���ض̵������б�
function SaveDDBases(const nDDData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessDuanDao(cBC_SaveBills, nDDData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2017-09-22
//Parm: �̵�����
//Desc: ɾ��nBillID����
function DeleteDDBase(const nBase: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessDuanDao(cBC_DeleteBill, nBase, '', @nOut);
end;

//Date: 2017-09-22
//Parm: �ſ���
//Desc: ע��nCard
function LogoutDDCard(const nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessDuanDao(cBC_LogoffCard, nCard, '', @nOut);
end;

//Date: 2019-07-22
//Parm: �̵����,�ſ���
//Desc: �󶨴ſ�nCard
function SaveDDCard(const nBID, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessDuanDao(cBC_SaveBillCard, nBID, nCard, @nOut);
end;

//Date: 2017-09-22
//Parm: �ſ���;��λ;�̵����б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ķ̵����б�
function GetDuanDaoItems(const nCard,nPost: string;
  var nBills: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessDuanDao(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nBills);
  //xxxxx
end;

function DeleteDDDetial(const nDID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessDuanDao(cBC_DeleteOrder, nDID, '', @nOut);
end;

function SetDDCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nBill;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_DuanDao;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2017-09-22
//Parm: �̵�ID;�Ƿ��ӡ
//Desc: ��ӡ�̵���ϸ
function PrintDuanDaoReport(const nID: string; nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�̵���?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where T_ID=''%s''';
  nStr := Format(nStr, [sTable_Transfer, nID]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '�̵���¼[ %s ] ����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'DuanDao.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2017-09-22
//Parm: ��λ;�̵����б�;��վͨ��
//Desc: ����nPost��λ�ϵĶ̵�������
function SaveDuanDaoItems(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem;const nLogin: Integer): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessDuanDao(cBC_SavePostBills, nStr, nPost, @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  if Assigned(nTunnel) then //��������
  begin
    nList := TStringList.Create;
    try
      {$IFDEF CapturePictureEx}
      CapturePictureEx(nTunnel, nLogin, nList);
      {$ELSE}
      CapturePicture(nTunnel, nList);
      //capture file
      {$ENDIF}

      for nIdx:=0 to nList.Count - 1 do
        SavePicture(nOut.FData, nData[0].FTruck,
                                nData[0].FStockName, nList[nIdx]);
      //save file
    finally
      nList.Free;
    end;
  end; 
end;

//Date: 2018-08-03
//Parm: ������ID
//Desc: ��ȡnReader��λ������
function ReadPoundReaderInfo(const nReader: string; var nDept: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := ''; nDept:= '';
  //����
  if CallBusinessHardware(cBC_GetPoundReaderInfo, nReader, '', @nOut)  then
  begin
    Result := Trim(nOut.FData);
    nDept:= Trim(nOut.FExtParam);
  end;
end;

//����ʶ����֤
function VerifySnapTruck(const nReader: string; nBill: TLadingBillItem;
                         var nMsg, nPos: string): Boolean;
var nStr, nDept: string;
    nNeedManu, nUpdate, nST: Boolean;
    nSnapTruck, nTruck, nEvent, nPicName: string;
    nLen: Integer;
begin
  Result := False;
  nPos := '';
  nNeedManu := False;
  nSnapTruck := '';
  nDept := '';
  nMsg := '';
  nLen := 0;
  nTruck := nBill.Ftruck;

  nPos := ReadPoundReaderInfo(nReader,nDept);

  if nPos = '' then
  begin
    Result := True;
    nStr := '������[ %s ]�󶨸�λΪ��,�޷�����ץ��ʶ��.';
    nStr := Format(nStr, [nReader]);
    WriteLog(nStr);
    Exit;
  end;

  nST := True;

  nStr := 'Select T_SnapTruck From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTruck]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nST := FieldByName('T_SnapTruck').AsString = sFlag_Yes;
    end;
  end;

  if not nST then
  begin
    Result := True;
    nMsg := '����[ %s ]������г���ʶ��.';
    nMsg := Format(nMsg, [nTruck]);
    Exit;
  end;

  nStr := 'Select D_Value,D_Index From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_TruckInNeedManu,nPos]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nNeedManu := FieldByName('D_Value').AsString = sFlag_Yes;
      nLen := FieldByName('D_Index').AsInteger;
      if nNeedManu then
      begin
        nStr := '������[ %s ]�󶨸�λ[ %s ]��Ԥ����:�˹���Ԥ������.';
        nStr := Format(nStr, [nReader, nPos]);
        WriteLog(nStr);
      end
      else
      begin
        nStr := '������[ %s ]�󶨸�λ[ %s ]��Ԥ����:�˹���Ԥ�ѹر�.';
        nStr := Format(nStr, [nReader, nPos]);
        WriteLog(nStr);
        Result := True;
        Exit;
      end;
    end
    else
    begin
      Result := True;
      nStr := '������[ %s ]�󶨸�λ[ %s ]δ���ø�Ԥ����,�޷�����ץ��ʶ��.';
      nStr := Format(nStr, [nReader, nPos]);
      WriteLog(nStr);
      Exit;
    end;
  end;

  nStr := 'Select * From %s Where S_ID=''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_SnapTruck, nPos]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      if not nNeedManu then
        Result := True;
      Exit;
    end;

    nPicName := '';

    First;

    while not Eof do
    begin
      nSnapTruck := FieldByName('S_Truck').AsString;
      if nPicName = '' then//Ĭ��ȡ����һ��ץ��
        nPicName := FieldByName('S_PicName').AsString;
      if Pos(nTruck,nSnapTruck) > 0 then
      begin
        Result := True;
        nPicName := FieldByName('S_PicName').AsString;
        //ȡ��ƥ��ɹ���ͼƬ·��
        nMsg := '����[ %s ]����ʶ��ɹ�,ץ�ĳ��ƺ�:[ %s ]';
        nMsg := Format(nMsg, [nTruck,nSnapTruck]);
        Exit;
      end;
      //����ʶ��ɹ�

      if nLen > 0 then//ģ��ƥ��
      begin
        if RightStr(nTruck,5) = RightStr(nSnapTruck,5) then
        begin
          Result := True;
          nPicName := FieldByName('S_PicName').AsString;
          //ȡ��ƥ��ɹ���ͼƬ·��
          nMsg := '����[ %s ]����ʶ��ɹ�,ץ�ĳ��ƺ�:[ %s ]';
          nMsg := Format(nMsg, [nTruck,nTruck]);
          Exit;
        end;
        //����ʶ��ɹ�
      end;
      Next;
    end;
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nBill.FID+sFlag_ManualE]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nMsg := '����[ %s ]����ʶ��ʧ��, ����ϵ������Ա';
      nMsg := Format(nMsg, [nTruck]);

      if FieldByName('E_Result').AsString = 'N' then
      begin
        nMsg := '����[ %s ]����ʶ��ʧ��,����Ա��ֹ';
        nMsg := Format(nMsg, [nTruck]);
        Exit;
      end;
      if FieldByName('E_Result').AsString = 'Y' then
      begin
        Result := True;
        nMsg := '����[ %s ]����ʶ��ʧ��,����Ա����';
        nMsg := Format(nMsg, [nTruck]);
        Exit;
      end;
      nUpdate := True;
    end
    else
    begin
      nMsg := '����[ %s ]����ʶ��ʧ��,���ƶ��������رճ���';
      nMsg := Format(nMsg, [nTruck]);
      nUpdate := False;
      if not nNeedManu then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  nEvent := '����[ %s ]����ʶ��ʧ��,���ƶ��������رճ���';
  nEvent := Format(nEvent, [nTruck]);

  nStr := SF('E_ID', nBill.FID+sFlag_ManualE);
  nStr := MakeSQLByStr([
          SF('E_ID', nBill.FID+sFlag_ManualE),
          SF('E_Key', nPicName),
          SF('E_From', nPos),
          SF('E_Result', 'Null', sfVal),

          SF('E_Event', nEvent),
          SF('E_Solution', sFlag_Solution_YN),
          SF('E_Departmen', nDept),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx
  FDM.ExecuteSQL(nStr);
end;

//������
function GetPersonWeight( var nWeight: Double): Boolean;
var nStr:string;
begin
  Result := True;

  nStr := 'Select * From %s Where D_Name=''PoundExtra''';
  nStr := Format(nStr, [sTable_SysDict]);
  //xxxxx
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nWeight := FieldByName('D_Value').Asfloat;
    end;
  end;
end;

function SaveSnapStatus(const nBill: TLadingBillItem; nStatus: string): Boolean;
var nStr: string;
begin
  Result := True;

  if nStatus = sFlag_No then
  begin
    nStr := 'UPDate %s set L_SnapStatus=''%s'' where L_ID=''%s''';
    nStr := format(nStr,[sTable_Bill, nStatus, nBill.FID]);
    FDM.ExecuteSQL(nStr);
  end
  else
  begin
    nStr := 'Select * From %s Where E_ID=''%s''';
    nStr := Format(nStr, [sTable_ManualEvent, nBill.FID+sFlag_ManualE]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount > 0 then
      begin
        if Trim(FieldByName('E_Result').AsString) <> '' then //����Ԥ������ʹ�ɹ�Ҳ���ٸ���
        begin
          Exit;
        end;
        nStr := 'update %s set L_SnapStatus=''%s'' where L_ID=''%s''';
        nStr := format(nStr,[sTable_Bill, nStatus, nBill.FID]);
        FDM.ExecuteSQL(nStr);

        nStr := 'Delete From %s Where E_ID=''%s''';
        nStr := Format(nStr, [sTable_ManualEvent, nBill.FID+sFlag_ManualE]);
        FDM.ExecuteSQL(nStr);
      end
      else
      begin
        nStr := 'update %s set L_SnapStatus=''%s'' where L_ID=''%s''';
        nStr := format(nStr,[sTable_Bill, nStatus, nBill.FID]);
        FDM.ExecuteSQL(nStr);
      end;
    end;
  end;
end;

procedure RemoteSnapDisPlay(const nPost, nText, nSucc: string);
var nOut: TWorkerBusinessCommand;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Values['text'] := nText;
    nList.Values['succ'] := nSucc;

    CallBusinessHardware(cBC_RemoteSnapDisPlay, nPost, PackerEncodeStr(nList.Text), @nOut);
  finally
    nList.Free;
  end;
end;

//Date: 2018-09-25
//Parm: ͨ��;��½ID;�б�
//Desc: ץ��nTunnel��ͼ��
procedure CapturePictureEx(const nTunnel: PPTTunnelItem;
                         const nLogin: Integer; nList: TStrings);
const
  cRetry = 2;
  //���Դ���
var nStr: string;
    nIdx,nInt: Integer;
    nErr: Integer;
    nPic: NET_DVR_JPEGPARA;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  nList.Clear;
  if not Assigned(nTunnel.FCamera) then Exit;
  //not camera
  if nLogin <= -1 then Exit;

  WriteLog(nTunneL.FID + '��ʼץ��');
  if not DirectoryExists(gSysParam.FPicPath) then
    ForceDirectories(gSysParam.FPicPath);
  //new dir

  if gSysParam.FPicBase >= 100 then
    gSysParam.FPicBase := 0;
  //clear buffer

  try

    nPic.wPicSize := nTunnel.FCamera.FPicSize;
    nPic.wPicQuality := nTunnel.FCamera.FPicQuality;

    for nIdx:=Low(nTunnel.FCameraTunnels) to High(nTunnel.FCameraTunnels) do
    begin
      if nTunnel.FCameraTunnels[nIdx] = MaxByte then continue;
      //invalid

      for nInt:=1 to cRetry do
      begin
        nStr := MakePicName();
        //file path

        gCameraNetSDKMgr.NET_DVR_CaptureJPEGPicture(nLogin,
                                   nTunnel.FCameraTunnels[nIdx],
                                   nPic, nStr);
        //capture pic

        nErr := gCameraNetSDKMgr.NET_DVR_GetLastError;

        if nErr = 0 then
        begin
          WriteLog('ͨ��'+IntToStr(nTunnel.FCameraTunnels[nIdx])+'ץ�ĳɹ�');
          nList.Add(nStr);
          Break;
        end;

        if nIdx = cRetry then
        begin
          nStr := 'ץ��ͼ��[ %s.%d ]ʧ��,������: %d';
          nStr := Format(nStr, [nTunnel.FCamera.FHost,
                   nTunnel.FCameraTunnels[nIdx], nErr]);
          WriteLog(nStr);
        end;
      end;
    end;
  except
  end;
end;

function InitCapture(const nTunnel: PPTTunnelItem; var nLogin: Integer): Boolean;
const
  cRetry = 2;
  //���Դ���
var nStr: string;
    nIdx,nInt: Integer;
    nErr: Integer;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  Result := False;
  if not Assigned(nTunnel.FCamera) then Exit;
  //not camera

  try
    nLogin := -1;
    gCameraNetSDKMgr.NET_DVR_SetDevType(nTunnel.FCamera.FType);
    //xxxxx

    gCameraNetSDKMgr.NET_DVR_Init;
    //xxxxx

    for nIdx:=1 to cRetry do
    begin
      nLogin := gCameraNetSDKMgr.NET_DVR_Login(nTunnel.FCamera.FHost,
                   nTunnel.FCamera.FPort,
                   nTunnel.FCamera.FUser,
                   nTunnel.FCamera.FPwd, nInfo);
      //to login

      nErr := gCameraNetSDKMgr.NET_DVR_GetLastError;
      if nErr = 0 then break;

      if nIdx = cRetry then
      begin
        nStr := '��¼�����[ %s.%d ]ʧ��,������: %d';
        nStr := Format(nStr, [nTunnel.FCamera.FHost, nTunnel.FCamera.FPort, nErr]);
        WriteLog(nStr);
        if nLogin > -1 then
         gCameraNetSDKMgr.NET_DVR_Logout(nLogin);
        gCameraNetSDKMgr.NET_DVR_Cleanup();
        Exit;
      end;
    end;
    Result := True;
  except

  end;
end;

function FreeCapture(nLogin: Integer): Boolean;
begin
  Result := False;
  try
    if nLogin > -1 then
     gCameraNetSDKMgr.NET_DVR_Logout(nLogin);
    gCameraNetSDKMgr.NET_DVR_Cleanup();

    Result := True;
  except

  end;
end;

function IsSealInfoDone(const nCardUse : string; nBill: TLadingBillItem): Boolean;
var nStr : string ;
    nCount, nInt: Integer;
    nVerifySeal: Boolean;//�Ƿ�У��
begin
  Result := True;
  nVerifySeal := False;

  if nCardUse <> sFlag_Sale then
    Exit;

  if nBill.FType <> sFlag_San then
    Exit;

  if nBill.FNextStatus <> sFlag_TruckBFM then
    Exit;

  nCount := 1;

  nStr := 'Select D_Value,D_ParamB From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SealCount]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nCount := Fields[0].AsInteger;
      nVerifySeal := Fields[1].AsString = sFlag_Yes;
    end;
  end;

  if not nVerifySeal then
    Exit;

  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_NoSealStock]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        if nBill.FStockNo = Fields[0].AsString then
          Exit;
        Next;
      end;
    end;
  end;

  nInt := 0;

  nStr := 'Select L_Seal1,L_Seal2,L_Seal3 From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill.FID]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      if Trim(Fields[0].AsString) <> '' then
       Inc(nInt);
      if Trim(Fields[1].AsString) <> '' then
       Inc(nInt);
      if Trim(Fields[2].AsString) <> '' then
       Inc(nInt);
    end;
  end;

  if nInt < nCount then
  begin
    WriteLog('�������' + nBill.FID + 'Ǧ����Ϣ������,��ֹ����');
    Result := False;
  end;
end;

function ShowLedText(nTunnel, nStr:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessHardware(cBC_ShowLedTxt, nTunnel, nStr,
            @nOut, False);
end;

//Date: 2017/6/14
//Parm: ���֤�ŵ�ǰ17λ
//Desc: ��ȡ���֤��У����
function GetIDCardNumCheckCode(nIDCardNum: string): string;
const
  cWIArray: Array[0..16] of Integer = (7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2);
  cModCode: array [0..10] of string = ('1','0','X','9','8','7','6','5','4','3','2');
var
  nIdx, nSum, nModResult: Integer;
begin
  Result := '';

  if Length(nIDCardNum) < 17 then
    Exit;

  nSum := 0;
  for nIdx := 0 to Length(cWIArray) - 1 do
  begin
    nSum := nSum + StrToInt(nIDCardNum[nIdx + 1]) * cWIArray[nIdx];
  end;  
  nModResult := nSum mod 11;
  Result := cModCode[nModResult];
end;

//Date: 2019-07-04
//Parm: �ɹ����Ϻ�;������
//Desc: ��ȡ�ɹ���������������״̬
function GetWlbYsStatus(const nStockNo,nOrderId: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_GetWlbYsStatus, nStockNo, nOrderId, @nOut);
end;


function SmallTOBig(small: real): string;
var
  SmallMonth, BigMonth: string;
  wei1, qianwei1: string[2];
  qianwei, dianweizhi, qian: integer;
  fs_bj: boolean;
begin
  if small < 0 then
    fs_bj := True
  else
    fs_bj := False;
  small      := abs(small);
  {------- �޸Ĳ�����ֵ����ȷ -------}
  {С������λ�ã���Ҫ�Ļ�Ҳ���ԸĶ�-2ֵ}
  qianwei    := -2;
  {ת���ɻ�����ʽ����Ҫ�Ļ�С�����Ӷ༸����}
  Smallmonth := formatfloat('0.00', small);
  {---------------------------------}
  dianweizhi := pos('.', Smallmonth);{С�����λ��}
  {ѭ��Сд���ҵ�ÿһλ����Сд���ұ�λ�õ����}
  for qian := length(Smallmonth) downto 1 do
  begin
    {��������Ĳ���С����ͼ���}
    if qian <> dianweizhi then
    begin
      {λ���ϵ���ת���ɴ�д}
      case StrToInt(Smallmonth[qian]) of
        1: wei1 := 'Ҽ';
        2: wei1 := '��';
        3: wei1 := '��';
        4: wei1 := '��';
        5: wei1 := '��';
        6: wei1 := '½';
        7: wei1 := '��';
        8: wei1 := '��';
        9: wei1 := '��';
        0: wei1 := '��';
      end;
      {�жϴ�дλ�ã����Լ�������real���͵����ֵ}
      case qianwei of
        -3: qianwei1 := '��';
        -2: qianwei1 := '��';
        -1: qianwei1 := '��';
        0: qianwei1  := 'Ԫ';
        1: qianwei1  := 'ʰ';
        2: qianwei1  := '��';
        3: qianwei1  := 'Ǫ';
        4: qianwei1  := '��';
        5: qianwei1  := 'ʰ';
        6: qianwei1  := '��';
        7: qianwei1  := 'Ǫ';
        8: qianwei1  := '��';
        9: qianwei1  := 'ʰ';
        10: qianwei1 := '��';
        11: qianwei1 := 'Ǫ';
      end;
      inc(qianwei);
      BigMonth := wei1 + qianwei1 + BigMonth;{��ϳɴ�д���}
    end;
  end;

  BigMonth := StringReplace(BigMonth, '��ʰ', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '���', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '��Ǫ', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '������', '', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '���', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '���', '', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '����', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '����', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '����', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '����', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '����', '��', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '��Ԫ', 'Ԫ', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '����', '��', [rfReplaceAll]);
  BigMonth := BigMonth + '��';
  BigMonth := StringReplace(BigMonth, '����', '��', [rfReplaceAll]);

  if BigMonth = 'Ԫ��' then
    BigMonth := '��Ԫ��';
  if copy(BigMonth, 1, 2) = 'Ԫ' then
    BigMonth := copy(BigMonth, 3, length(BigMonth) - 2);
  if copy(BigMonth, 1, 2) = '��' then
    BigMonth := copy(BigMonth, 3, length(BigMonth) - 2);
  if fs_bj = True then
    SmallTOBig := '- ' + BigMonth
  else
    SmallTOBig := BigMonth;
end;

function PrintShouJu(const nSID: string;
  const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
    nMoney: Double;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�վ�?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_InOutMoney, nSID]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nStr := 'ƾ����Ϊ[ %s ] ���վ�����Ч!!';
      nStr := Format(nStr, [nSID]);
      ShowMsg(nStr, sHint); Exit;
    end;
    nMoney := FieldByName('M_Money').AsFloat;
  end;


  nStr := gPath + sReportDir + 'ShouJu.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  nParam.FName := 'nMoney';
  nParam.FValue := SmallTOBig(nMoney);
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

end.
