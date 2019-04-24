{*******************************************************************************
  ����: dmzn@163.com 2017-10-25
  ����: ΢�����ҵ������ݴ���
*******************************************************************************}
unit UWorkerBussinessWebchat;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, SysUtils, DB, ADODB, NativeXml, UBusinessWorker,
  UBusinessPacker, UBusinessConst, UMgrDBConn, UMgrParam, UFormCtrl, USysLoger,
  ZnMD5, ULibFun, USysDB, UMITConst, UMgrChannel, DateUtils, IdURI, HTTPApp,
  {$IFDEF WXChannelPool}Wechat_Intf, {$ELSE}WeChat_soap, {$ENDIF}IdHTTP,
  Graphics, uSuperObject;

const
  cHttpTimeOut          = 10;
  //HostUrl               = 'http://hnzhixinkeji.cn/zshop/ssp';  //'http://192.168.2.112/zshop/ssp';
  Cus_activeCode        = 'ZSHOP001';
  Cus_BindCode          = 'ZSHOP002';
  Cus_ShopOrder         = 'ZSHOP003';
  Cus_syncShopOrder     = 'ZSHOP004';

type
  TMITDBWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //������
    FDBConn: PDBWorker;
    //����ͨ��
    {$IFDEF WXChannelPool}
    FWXChannel: PChannelItem;
    {$ELSE} //΢��ͨ��
    FWXChannel: ReviceWS;
    {$ENDIF}
    FDataIn, FDataOut: PBWDataBase;
    //��γ���
    FDataOutNeedUnPack: Boolean;
    //��Ҫ���
    FPackOut: Boolean;
    procedure GetInOutData(var nIn, nOut: PBWDataBase); virtual; abstract;
    //�������
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //��֤���
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //����ҵ��
  public
    function DoWork(var nData: string): Boolean; override;
    //ִ��ҵ��
    procedure WriteLog(const nEvent: string);
    //��¼��־
  end;

  TBusWorkerBusinessWebchat = class(TMITDBWorker)
  private
    FListA, FListB, FListC: TStrings;
    //list
    FIn: TWorkerWebChatData;
    FOut: TWorkerWebChatData;
    //in out
    FIdHttp: TIdHTTP;
    FUrl: string;
  protected
    procedure ReQuestInit;
    procedure GetInOutData(var nIn, nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function UnPackIn(var nData: string): Boolean;
    procedure BuildDefaultXML;
    function FormatJson(nStrJson: string): string;
    procedure SaveAuditTruck(nList: TStrings; nStatus: string);
    function ParseDefault(var nData: string): Boolean;
    function GetTruckByLine(nStockNo: string): string;
    //����ˮ��Ʒ�ֻ�ȡ������ǰװ������
    function GetStockName(nStockNo: string): string;
    //��ȡ��������
    function GetCusName(nCusID: string): string;
    //��ȡ�ͻ�����


    function GetCustomerValidMoney(nCustomer: string): Double;
    //��ȡ�ͻ����ý�
    function GetCustomerValidMoneyFromK3(nCustomer: string): Double;
    //��ȡ�ͻ����ý�(K3)
    function GetInOutValue(nBegin, nEnd, nType: string): string;
    //��ȡ����������ͳ����������
    function SaveDBImage(const nDS: TDataSet; const nFieldName: string; const nStream: TMemoryStream): Boolean;
    function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
    //��ȡϵͳ�ֵ���
    function GetOrderList(var nData: string): Boolean;
    //��ȡ�����б� 4.2�����ѯ�����ͻ���ͬ����
    function GetOrderInfo(var nData: string): Boolean;
    //��ȡ������Ϣ

    function VerifyPrintCode(var nData: string): Boolean;
    //��֤������Ϣ
    function GetWaitingForloading(var nData: string): Boolean;
    //������װ��ѯ
    function GetPurchaseContractList(var nData: string): Boolean;
    //��ȡ�ɹ���ͬ�б������������µ�
    function Send_Event_Msg(var nData: string): boolean;
    //������Ϣ
    function Edit_Shopgoods(var nData: string): boolean;
    //������Ʒ
    function complete_shoporders(var nData: string): Boolean;
    //�޸Ķ���״̬
    function GetCusMoney(var nData: string): Boolean;
    //��ȡ�ͻ��ʽ�
    function GetInOutFactoryTotal(var nData: string): Boolean;
    //����������ѯ���ɹ������������۳�������
    function getDeclareCar(var nData: string): Boolean;
    //���س��������Ϣ
    function UpdateDeclareCar(var nData: string): Boolean;
    //������˽���ϴ����󶨻������ڿ�����
    function DownLoadPic(var nData: string): Boolean;
    //����ͼƬ
    function get_shoporderByTruck(var nData: string): boolean;
    //���ݳ��ƺŻ�ȡ������Ϣ



    function GetCustomerInfo(var nData: string): Boolean;                       // Dl--->WxService
    //��ȡ�ͻ�ע����Ϣ
    function edit_shopclients(var nData: string): Boolean;                      // Dl--->WxService
    //���̳ǿͻ�
    function Get_Shoporders(var nData: string): boolean;                        // Dl--->WxService
    //��ȡ������Ϣ
    function get_shoporderByNO(var nData: string): boolean;                     // Dl--->WxService
    //���ݶ����Ż�ȡ������Ϣ

                                                                                // WxService--->Dl
    function SearchClient(var nData: string): Boolean;
    function SearchContractOrder(var nData: string): Boolean;
    function SearchMateriel(var nData: string): Boolean;
    function SearchBill(var nData: string): Boolean;
    function CreateBill(var nData: string): Boolean;
    function SearchSecurityCode(var nData: string): Boolean;
    function QueryTruckQuery(var nData: string): Boolean;
    function BillStats(var nData: string): Boolean;
    function HYDanReport(var nData: string): Boolean;
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation

//Date: 2012-3-13
//Parm: ���������
//Desc: ��ȡ�������ݿ��������Դ
function TMITDBWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;
  FWXChannel := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    {$IFDEF WXChannelPool}
    FWXChannel := gChannelManager.LockChannel(cBus_Channel_Business, mtSoap);
    if not Assigned(FWXChannel) then
    begin
      nData := '����΢�ŷ���ʧ��(Wechat Web Service No Channel).';
      Exit;
    end;

    with FWXChannel^ do
    begin
      if not Assigned(FChannel) then
        FChannel := CoReviceWSImplService.Create(FMsg, FHttp);
      FHttp.TargetUrl := gSysParam.FSrvRemote;
    end; //config web service channel
    {$ENDIF}

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser := gSysParam.FAppFlag;
      FIP := gSysParam.FLocalIP;
      FMAC := gSysParam.FLocalMAC;
      FTime := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: ' + FunctionName + ' InData:' + FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then
      Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx

      Result := DoAfterDBWork(nData, True);
      if not Result then
        Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      if FPackOut then
      begin
        WriteLog('���');
        nData := FPacker.PackOut(FDataOut);
      end;

      {$IFDEF DEBUG}
      WriteLog('Fun: ' + FunctionName + ' OutData:' + FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end
    else
      DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
    {$IFDEF WXChannelPool}
    gChannelManager.ReleaseChannel(FWXChannel);
    {$ELSE}
    FWXChannel := nil;
    {$ENDIF}
  end;
end;

//Date: 2012-3-22
//Parm: �������;���
//Desc: ����ҵ��ִ����Ϻ����β����
function TMITDBWorker.DoAfterDBWork(var nData: string; nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: �������
//Desc: ��֤��������Ƿ���Ч
function TMITDBWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//Desc: ��¼nEvent��־
procedure TMITDBWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMITDBWorker, FunctionName, nEvent);
end;

//------------------------------------------------------------------------------
class function TBusWorkerBusinessWebchat.FunctionName: string;
begin
  Result := sBus_BusinessWebchat;
end;

constructor TBusWorkerBusinessWebchat.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;

  FidHttp := TIdHTTP.Create(nil);
  FidHttp.ConnectTimeout := cHttpTimeOut * 1000;
  FidHttp.ReadTimeout := cHttpTimeOut * 1000;
  inherited;
end;

destructor TBusWorkerBusinessWebchat.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  FreeAndNil(FidHttp);
  inherited;
end;

function TBusWorkerBusinessWebchat.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
    cWorker_GetPackerName:
      Result := sBus_BusinessWebchat;
  end;
end;

procedure TBusWorkerBusinessWebchat.GetInOutData(var nIn, nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
class function TBusWorkerBusinessWebchat.CallMe(const nCmd: Integer; const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var
  nStr: string;
  nIn: TWorkerWebChatData;
  nPacker: TBusinessPackerBase;
  nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessWebchat);
    nPacker.InitData(@nIn, True, False);
    //init

    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessWebchat);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
      nPacker.UnPackOut(nStr, nOut)
    else
      nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

function TBusWorkerBusinessWebchat.UnPackIn(var nData: string): Boolean;
var
  nNode, nTmp: TXmlNode;
begin
  Result := False;
  try
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nData);

    //nNode := FPacker.XMLBuilder.Root.FindNode('Head');
    nNode := FPacker.XMLBuilder.Root;
    if not (Assigned(nNode) and Assigned(nNode.FindNode('Command'))) then
    begin
      nData := '��Ч�����ڵ�(Head.Command Null).';
      Exit;
    end;

    if not Assigned(nNode.FindNode('RemoteUL')) then
    begin
      nData := '��Ч�����ڵ�(Head.RemoteUL Null).';
      Exit;
    end;

    nTmp := nNode.FindNode('Command');
    FIn.FCommand := StrToIntDef(nTmp.ValueAsString, 0);

    nTmp := nNode.FindNode('RemoteUL');
    FIn.FRemoteUL := nTmp.ValueAsString;

    nTmp := nNode.FindNode('Data');
    if Assigned(nTmp) then
      FIn.FData := nTmp.ValueAsString;

    if FIn.FCommand = cBC_WX_CreatLadingOrder then
    begin
      FListA.Clear;

      nTmp := nNode.FindNode('WebOrderID');
      if Assigned(nTmp) then
        FListA.Values['WebOrderID'] := nTmp.ValueAsString;

      nTmp := nNode.FindNode('Truck');
      if Assigned(nTmp) then
        FListA.Values['Truck'] := nTmp.ValueAsString;

      nTmp := nNode.FindNode('Value');
      if Assigned(nTmp) then
        FListA.Values['Value'] := nTmp.ValueAsString;

      nTmp := nNode.FindNode('Phone');
      if Assigned(nTmp) then
        FListA.Values['Phone'] := nTmp.ValueAsString;

      nTmp := nNode.FindNode('Unloading');
      if Assigned(nTmp) then
        FListA.Values['Unloading'] := nTmp.ValueAsString;

      nTmp := nNode.FindNode('IdentityID');
      if Assigned(nTmp) then
        FListA.Values['IdentityID'] := nTmp.ValueAsString;

    end
    else
    begin
      nTmp := nNode.FindNode('ExtParam');
      if Assigned(nTmp) then
        FIn.FExtParam := nTmp.ValueAsString;
    end;
  except

  end;
end;

//Date: 2012-3-22
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TBusWorkerBusinessWebchat.DoDBWork(var nData: string): Boolean;
begin
  UnPackIn(nData);
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;
  FPackOut := False;

  case FIn.FCommand of
    cBC_WX_VerifPrintCode:
      Result := VerifyPrintCode(nData);
    cBC_WX_WaitingForloading:
      Result := GetWaitingForloading(nData);
    cBC_WX_BillSurplusTonnage:
      Result := True;
    cBC_WX_GetOrderInfo:
      Result := GetOrderList(nData);
    cBC_WX_GetOrderList:
      Result := GetOrderList(nData);
    cBC_WX_CreatLadingOrder:
      Result := True;
    cBC_WX_GetPurchaseContract:
      Result := GetPurchaseContractList(nData);
    cBC_WX_getCustomerInfo:
      begin
        FPackOut := True;
        Result := GetCustomerInfo(nData);
      end;
//   cBC_WX_get_Bindfunc         : Result := BindCustomer(nData);
    cBC_WX_send_event_msg:
      begin
        FPackOut := True;
        Result := Send_Event_Msg(nData);
      end;
    cBC_WX_edit_shopclients:
      begin
        FPackOut := True;
        Result := Edit_ShopClients(nData);
      end;
    cBC_WX_edit_shopgoods:
      Result := Edit_Shopgoods(nData);
    cBC_WX_get_shoporders:
      Result := get_shoporders(nData);
    cBC_WX_complete_shoporders:
      begin
        FPackOut := True;
        Result := complete_shoporders(nData);
      end;
    cBC_WX_get_shoporderbyNO:
      begin
        FPackOut := True;
        Result := get_shoporderByNO(nData);
      end;
    cBC_WX_get_shopPurchasebyNO:
      begin
        FPackOut := True;
        Result := get_shoporderByNO(nData);
      end;
    cBC_WX_GetCusMoney:
      Result := GetCusMoney(nData);
    cBC_WX_GetInOutFactoryTotal:
      Result := GetInOutFactoryTotal(nData);
    cBC_WX_GetAuditTruck:
      begin
        FPackOut := True;
        Result := getDeclareCar(nData);
      end;
    cBC_WX_UpLoadAuditTruck:
      begin
        FPackOut := True;
        Result := UpdateDeclareCar(nData);
      end;
    cBC_WX_DownLoadPic:
      begin
        FPackOut := True;
        Result := DownLoadPic(nData);
      end;
    cBC_WX_get_shoporderbyTruck:
      begin
        FPackOut := True;
        Result := get_shoporderByTruck(nData);
      end;
  else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Code: %d Invalid Command).';
      nData := Format(nData, [FIn.FCommand]);
    end;
  end;
end;

//Date: 2017-10-28
//Desc: ��ʼ��XML����
procedure TBusWorkerBusinessWebchat.BuildDefaultXML;
begin
  with FPacker.XMLBuilder do
  begin
    Clear;
    VersionString := '1.0';
    EncodingString := 'utf-8';

    XmlFormat := xfCompact;
    Root.Name := 'DATA';
    //first node
  end;
end;

//Date: 2017-10-26
//Desc: ����Ĭ������
function TBusWorkerBusinessWebchat.ParseDefault(var nData: string): Boolean;
var
  nStr: string;
  nNode: TXmlNode;
begin
  with FPacker.XMLBuilder do
  begin
    Result := False;
    nNode := Root.FindNode('head');

    if not Assigned(nNode) then
    begin
      nData := '��Ч�����ڵ�(WebService-Response.head Is Null).';
      Exit;
    end;

    nStr := nNode.NodeByName('errcode').ValueAsString;
    if nStr <> '0' then
    begin
      nData := 'ҵ��ִ��ʧ��,����: %s.%s';
      nData := Format(nData, [nStr, nNode.NodeByName('errmsg').ValueAsString]);
      Exit;
    end;

    Result := True;
    //done
  end;
end;

function TBusWorkerBusinessWebchat.FormatJson(nStrJson: string): string;
begin
  Result := '';

  Result := StringReplace(nStrJson, '\"', '"', [rfReplaceAll]);
  Result := StringReplace(Result, ':"{', ':{', [rfReplaceAll]);
  Result := StringReplace(Result, '}"', '}', [rfReplaceAll]);
//  Result := '{"sspDL":' + Result + '}';
end;

//Date: 2017-10-25
//Desc: ��ȡ������΢���û��б�
function TBusWorkerBusinessWebchat.GetCustomerInfo(var nData: string): Boolean;
var
  nStr, szUrl: string;
  nIdx: Integer;
  ReJo, ParamJo, BodyJo, OneJo, ReBodyJo: ISuperObject;
  ArrsJa: TSuperArray;
  wParam: TStrings;
  ReStream: TStringStream;
begin
  Result   := False;
  wParam   := TStringList.Create;
  ReStream := TStringstream.Create('');
  ParamJo  := SO();
  BodyJo   := SO();
  try
    BodyJo.S['facSerialNo'] := gSysParam.FFactID;
    ParamJo.S['activeCode'] := Cus_activeCode;
    ParamJo.S['body']       := BodyJo.AsString;
    nStr                    := ParamJo.AsString;
   // nStr := Ansitoutf8(nStr);  

    WriteLog('΢���û��б���Σ�' + nStr);

    wParam.Clear;
    wParam.Add(nStr);
    
    //FidHttp������ʼ��
    ReQuestInit;

    szUrl := gSysParam.FSrvUrl + '/customer/searchShopCustomer';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := UTF8Decode(ReStream.DataString);
    WriteLog('΢���û��б����Σ�' + nStr);
    if nStr <> '' then
    begin
      FListA.Clear;
      FListB.Clear;
      ReJo    := SO(nStr);
      if ReJo = nil then Exit;

      if ReJo.S['code'] = '1' then
      begin
        ReBodyJo := So(ReJo['body'].AsString);
        ArrsJa   := ReBodyJo.A['customers'];
        for nIdx := 0 to ArrsJa.Length - 1 do
        begin
          OneJo  := SO(ArrsJa.S[nIdx]);
          with FListB do
          begin
            Values['Phone']  := OneJo.S['phone'];
            Values['BindID'] := OneJo.S['custSerialNo'];
            Values['Name']   := OneJo.S['realName'];
          end;
          FListA.Add(PackerEncodeStr(FListB.Text));
        end;
      end
      else
      begin
        WriteLog('΢���û��б���ѯʧ�ܣ�' + ReJo.S['msg']);
        Exit;
      end;
    end;

    Result := True;
    FOut.FData := FListA.Text;
    FOut.FBase.FResult := True;
  finally
    ReStream.Free;
    wParam.Free;
  end;
end;

//Date: 2017-10-27
//Desc: ��or����̳��˻�����
function TBusWorkerBusinessWebchat.edit_shopclients(var nData: string): Boolean;
var
  IsBind : Boolean;
  nStr, szUrl: string;
  ReJo, ParamJo, BodyJo: ISuperObject;
  ArrsJa: TSuperArray;
  wParam: TStrings;
  ReStream: TStringStream;
begin
  Result   := False;
  wParam   := TStringList.Create;
  ReStream := TStringstream.Create('');
  ParamJo  := SO();
  BodyJo   := SO();

  FListA.Text := PackerDecodeStr(FIn.FData);
  try
    BodyJo.S['atype'] := '0';
    BodyJo.S['type']  := '0';
    if FListA.Values['Action'] = 'add' then
      IsBind := True
    else
      IsBind := False;
    if IsBind  then
    begin
      BodyJo.S['type'] := '1';
      BodyJo.S['atype']:= '1';
    end;

    BodyJo.S['btype']         := FListA.Values['btype'];
    BodyJo.S['clientAccount'] := EncodeBase64(FListA.Values['Account']);
    BodyJo.S['clientName']    := EncodeBase64(FListA.Values['CusName']);
    BodyJo.S['clientNo']      := FListA.Values['CusID'];
    BodyJo.S['custPhone']     := FListA.Values['Phone'];   
    BodyJo.S['custSerialNo']  := FListA.Values['BindID'];    
    BodyJo.S['facSerialNo']   :=  gSysParam.FFactID;

    ParamJo.S['activeCode']  := Cus_BindCode;
    ParamJo.S['body']        := BodyJo.AsString;
    nStr                     := ParamJo.AsString;

   // nStr := Ansitoutf8(nStr);
    if IsBind then
      WriteLog('�̳�' + FListA.Values['Account'] + '�˻�����Σ�' + nStr)
    else
      WriteLog('�̳�' + FListA.Values['Account'] + '�˻������Σ�' + nStr);

    wParam.Clear;
    wParam.Add(nStr);
    
    //FidHttp������ʼ��
    ReQuestInit;

    szUrl := gSysParam.FSrvUrl + '/customer/relClientIAuth';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := UTF8Decode(ReStream.DataString);
    if IsBind then
      WriteLog('�̳�' + FListA.Values['Account'] + ' �˻��󶨳��Σ�' + nStr)
    else
      WriteLog('�̳�' + FListA.Values['Account'] + ' �˻������Σ�' + nStr);
    if nStr <> '' then
    begin
      ReJo := SO(nStr);

      if ReJo.S['code'] = '1' then
      begin
        Result := True;
        FOut.FData := sFlag_Yes;
        FOut.FBase.FResult := True;
      end
      else
      begin
        if IsBind then
          WriteLog('�������̳��˻�ʧ�ܣ�' + ReJo.S['msg'])
        else
          WriteLog('������̳��˻�ʧ�ܣ�' + ReJo.S['msg']);
        Result     := True;
        FOut.FData := ReJo.S['msg'];
        FOut.FBase.FResult := True;
      end;
    end;
  finally
    ReStream.Free;
    wParam.Free;
  end;
end;

//Date: 2017-10-28
//Parm: �ͻ����[FIn.FData]
//Desc: ��ȡ���ö����б�
function TBusWorkerBusinessWebchat.GetOrderList(var nData: string): Boolean;
var
  nStr, nType: string;
  nNode: TXmlNode;
  nValue, nMoney: Double;
begin
  Result := False;
  BuildDefaultXML;
  nMoney := 0;
  {$IFDEF UseCustomertMoney}
  nMoney := GetCustomerValidMoney(FIn.FData);
  {$ENDIF}

  {$IFDEF UseERP_K3}
  nMoney := GetCustomerValidMoneyFromK3(FIn.FData);
  {$ENDIF}

  nStr := 'select D_ZID,' +                     //���ۿ�Ƭ���
    '  D_Type,' +                           //����(��,ɢ)
    '  D_StockNo,' +                        //ˮ����
    '  D_StockName,' +                      //ˮ������
    '  D_Price,' +                          //����
    '  D_Value,' +                          //������
    '  Z_Man,' +                            //������
    '  Z_Date,' +                           //��������
    '  Z_Customer,' +                       //�ͻ����
    '  Z_Name,' +                           //�ͻ�����
    '  Z_Lading,' +                         //�����ʽ
    '  Z_CID ' +                            //��ͬ���
    'from %s a join %s b on a.Z_ID = b.D_ZID ' + 'where Z_Verified=''%s'' and (Z_InValid<>''%s'' or Z_InValid is null) ' + 'and Z_Customer=''%s''';
        //��������� ��Ч
  nStr := Format(nStr, [sTable_ZhiKa, sTable_ZhiKaDtl, sFlag_Yes, sFlag_Yes, FIn.FData]);
  WriteLog('��ȡ�����б�sql:' + nStr);
  with gDBConnManager.WorkerQuery(FDBConn, nStr), FPacker.XMLBuilder do
  begin
    if RecordCount < 1 then
    begin
      nData := '�ͻ�(%s)û�ж���,���Ȱ���.';
      nData := Format(nData, [FIn.FData]);

      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString := nData;
        NodeNew('MsgResult').ValueAsString := sFlag_No;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
      nData := FPacker.XMLBuilder.WriteToString;
      Exit;
    end;

    First;

    nNode := Root.NodeNew('head');
    with nNode do
    begin
      NodeNew('CusId').ValueAsString := FieldByName('Z_Customer').AsString;
      NodeNew('CusName').ValueAsString := GetCusName(FieldByName('Z_Customer').AsString);
      {$IFDEF WxShowCusMoney}
      NodeNew('CusMoney').ValueAsString := FloatToStr(nMoney);
      {$ENDIF}
    end;

    nNode := Root.NodeNew('Items');
    while not Eof do
    begin
      with nNode.NodeNew('Item') do
      begin
        if FieldByName('D_Type').AsString = 'D' then
          nType := '��װ'
        else
          nType := 'ɢװ';

        NodeNew('SetDate').ValueAsString := FieldByName('Z_Date').AsString;
        NodeNew('BillNumber').ValueAsString := FieldByName('D_ZID').AsString;
        NodeNew('StockNo').ValueAsString := FieldByName('D_StockNo').AsString;
        NodeNew('StockName').ValueAsString := FieldByName('D_StockName').AsString;
        NodeNew('StockType').ValueAsString := FieldByName('D_Type').AsString;

        nValue := FieldByName('D_Value').AsFloat;
        {$IFDEF UseCustomertMoney}
        try
          nValue := nMoney / FieldByName('D_Price').AsFloat;
          nValue := Float2PInt(nValue, cPrecision, False) / cPrecision;
        except
          nValue := 0;
        end;
        {$ENDIF}
        {$IFDEF UseERP_K3}
        try
          nValue := nMoney / FieldByName('D_Price').AsFloat;
          nValue := Float2PInt(nValue, cPrecision, False) / cPrecision;
        except
          nValue := 0;
        end;
        {$ENDIF}
        NodeNew('MaxNumber').ValueAsString := FloatToStr(nValue);
        NodeNew('SaleArea').ValueAsString := '';
      end;

      nExt;
    end;

    nNode := Root.NodeNew('EXMG');
    with nNode do
    begin
      NodeNew('MsgTxt').ValueAsString := 'ҵ��ִ�гɹ�';
      NodeNew('MsgResult').ValueAsString := sFlag_Yes;
      NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
    end;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  WriteLog('��ȡ�����б�����:' + nData);
  Result := True;
end;

function TBusWorkerBusinessWebchat.GetOrderInfo(var nData: string): Boolean;
begin

end;

//Date: 2017-11-14
//Parm: ��α��[FIn.FData]
//Desc: ��α��У��
function TBusWorkerBusinessWebchat.VerifyPrintCode(var nData: string): Boolean;
var
  nStr, nCode, nBill_id: string;
  nDs: TDataSet;
  nSprefix: string;
  nIdx, nIdlen: Integer;
begin
  nSprefix := '';
  nIdlen := 0;
  Result := False;
  nCode := FIn.FData;

  BuildDefaultXML;
  if nCode = '' then
  begin
    nData := '��α��Ϊ��.';
    with FPacker.XMLBuilder.Root.NodeNew('EXMG') do
    begin
      NodeNew('MsgTxt').ValueAsString := nData;
      NodeNew('MsgResult').ValueAsString := sFlag_No;
      NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
    end;
    nData := FPacker.XMLBuilder.WriteToString;
    Exit;
  end;

  nStr := 'Select B_Prefix, B_IDLen From %s ' + 'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_BillNo]);
  nDs := gDBConnManager.WorkerQuery(FDBConn, nStr);

  if nDs.RecordCount > 0 then
  begin
    nSprefix := nDs.FieldByName('B_Prefix').AsString;
    nIdlen := nDs.FieldByName('B_IDLen').AsInteger;
    nIdlen := nIdlen - length(nSprefix);
  end;

  //�����������
  nBill_id := nSprefix + Copy(nCode, 1, 6) + //YYMMDD
    Copy(nCode, 12, Length(nCode) - 11); //XXXX
  {$IFDEF CODECOMMON}
  //�����������
  nBill_id := nSprefix + Copy(nCode, 1, 6) + //YYMMDD
    Copy(nCode, 12, Length(nCode) - 11); //XXXX
  {$ENDIF}

  {$IFDEF UseERP_K3}
  nBill_id := nSprefix + Copy(nCode, Length(nCode) - nIdlen + 1, nIdlen);
  {$ENDIF}

  //��ѯ���ݿ�
  nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusName,L_Type,L_StockNo,' +
          'L_StockName,L_Truck,L_Value,L_Price,L_ZKMoney,L_Status,' +
          'L_NextStatus,L_Card,L_IsVIP,L_PValue,L_MValue,l_project,l_area,' +
          'l_hydan,l_outfact From $Bill b ';
  nStr := nStr + 'Where L_ID=''$CD''';
  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$CD', nBill_id)]);
  WriteLog('��α���ѯSQL:' + nStr);

  nDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
  if nDs.RecordCount < 1 then
  begin
    nData := 'δ��ѯ�������Ϣ.';
    with FPacker.XMLBuilder.Root.NodeNew('EXMG') do
    begin
      NodeNew('rspDesc').ValueAsString := nData;
      NodeNew('rspCode').ValueAsString := sFlag_No;
      NodeNew('serialID').ValueAsString := IntToStr(FIn.FCommand);
    end;
    nData := FPacker.XMLBuilder.WriteToString;
    Exit;
  end;

  with FPacker.XMLBuilder do
  begin
    with Root.NodeNew('Items') do
    begin

      nDs.First;

      while not nDs.eof do
        with NodeNew('Item') do
        begin
          NodeNew('billNo').ValueAsString := nDs.FieldByName('L_ID').AsString;
          NodeNew('PROJECT').ValueAsString := nDs.FieldByName('L_ZhiKa').AsString;
          NodeNew('clientNo').ValueAsString := nDs.FieldByName('L_CusID').AsString;
          NodeNew('clientName').ValueAsString := nDs.FieldByName('L_CusName').AsString;
          NodeNew('licensePlate').ValueAsString := nDs.FieldByName('L_Truck').AsString;
          NodeNew('StockNo').ValueAsString := nDs.FieldByName('L_StockNo').AsString;
          NodeNew('StockName').ValueAsString := nDs.FieldByName('L_StockName').AsString;
          NodeNew('workplate').ValueAsString := nDs.FieldByName('L_Project').AsString;
          NodeNew('area').ValueAsString := nDs.FieldByName('l_area').AsString;
          NodeNew('hydan').ValueAsString := nDs.FieldByName('l_hydan').AsString;
          NodeNew('realQuantity').ValueAsString := nDs.FieldByName('L_Value').AsString;

          if Trim(nDs.FieldByName('l_outfact').AsString) = '' then
            NodeNew('realTime').ValueAsString := 'δ����'
          else
            NodeNew('realTime').ValueAsString := FormatDateTime('yyyy-mm-dd', nDs.FieldByName('l_outfact').AsDateTime);

          nDs.Next;
        end;
    end;

    with Root.NodeNew('EXMG') do
    begin
      NodeNew('MsgTxt').ValueAsString := 'ҵ��ִ�гɹ�';
      NodeNew('MsgResult').ValueAsString := sFlag_Yes;
      NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
    end;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  WriteLog('��α���ѯ����:' + nData);
  Result := True;
end;

//Date: 2017-11-15
//Desc: ������Ϣ
function TBusWorkerBusinessWebchat.Send_Event_Msg(var nData: string): Boolean;
var
  nStr: string;
begin
  Result := False;
  FListA.Text := PackerDecodeStr(FIn.FData);

  nStr := '<?xml version="1.0" encoding="UTF-8"?>' + '<DATA>' + '<head>' + '<Factory>%s</Factory>' + '<ToUser>%s</ToUser>' + '<MsgType>%s</MsgType>' + '</head>' + '<Items>' + '	  <Item>' + '	      <BillID>%s</BillID>' + '	      <Card>%s</Card>' + '	      <Truck>%s</Truck>' + '	      <StockNo>%s</StockNo>' + '	      <StockName>%s</StockName>' + '	      <CusID>%s</CusID>' + '	      <CusName>%s</CusName>' + '	      <CusAccount>0</CusAccount>' + '	      <MakeDate></MakeDate>' + '	      <MakeMan></MakeMan>' + '	      <TransID></TransID>' + '	      <TransName></TransName>' + '	      <Searial></Searial>' + '	      <OutFact></OutFact>' + '	      <OutMan></OutMan>' + '        <NetWeight>%s</NetWeight>' + '	  </Item>	' + '</Items>' + '</DATA>';
  nStr := Format(nStr, [gSysParam.FFactID, FListA.Values['CusID'], FListA.Values['MsgType'], FListA.Values['BillID'], FListA.Values['Card'], FListA.Values['Truck'], FListA.Values['StockNo'], FListA.Values['StockName'], FListA.Values['CusID'], FListA.Values['CusName'], FListA.Values['Value']]);
  WriteLog('�����̳�ģ����Ϣ���' + nStr);
  FWXChannel := GetReviceWS(gSysParam.FSrvRemote);
  nStr := FWXChannel.mainfuncs('send_event_msg', nStr);
  WriteLog('�����̳�ģ����Ϣ����' + nStr);
  with FPacker.XMLBuilder do
  begin
    ReadFromString(nStr);
    if not ParseDefault(nData) then
    begin
      WriteLog('����΢����Ϣʧ��:' + nData + 'Ӧ��:' + nStr);
      Exit;
    end;
  end;

  Result := True;
  FOut.FData := sFlag_Yes;
  FOut.FBase.FResult := True;
end;

function TBusWorkerBusinessWebchat.complete_shoporders(var nData: string): Boolean;
var
  nStr, nSql, ncontractNo: string;
  nDBConn: PDBWorker;
  nIdx: Integer;
  nNetWeight: Double;
  szUrl: string;
  ReJo, ParamJo, BodyJo, OneJo, JoA : ISuperObject;  
  ArrsJa: TSuperArray;
  wParam: TStrings;
  ReStream: TStringStream;
begin
  Result := False;
  FListA.Text := PackerDecodeStr(FIn.FData);
  nNetWeight := 0;
  nDBConn := nil;

  with gParamManager.ActiveParam^ do
  begin
    try
      nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
      if not Assigned(nDBConn) then
      begin
        Exit;
      end;
      if not nDBConn.FConn.Connected then
        nDBConn.FConn.Connected := True;

      //���۾���
      nSql := 'select L_Value, L_ZhiKa,l_status from %s where l_id=''%s''';
      nSql := Format(nSql, [sTable_Bill, FListA.Values['WOM_LID']]);
      with gDBConnManager.WorkerQuery(nDBConn, nSql) do
      begin
        if recordcount > 0 then
        begin
          if FieldByName('l_status').AsString = sFlag_TruckOut then
            nNetWeight := FieldByName('L_Value').asFloat;
          ncontractNo:= FieldByName('L_ZhiKa').AsString;
        end;
      end;
      //�ɹ�����
      if nNetWeight < 0.0001 then
      begin
        nSql := 'select a.d_mvalue, a.d_pvalue, a.d_status, b.O_BID  from %s a left join %s b on a.D_OID=b.O_ID where a.d_oid=''%s'' ';
        nSql := Format(nSql, [sTable_OrderDtl, sTable_Order , FListA.Values['WOM_LID']]);
        with gDBConnManager.WorkerQuery(nDBConn, nSql) do
        begin
          if recordcount > 0 then
          begin
            if FieldByName('d_status').AsString = sFlag_TruckOut then
              nNetWeight := FieldByName('D_MValue').asFloat - FieldByName('D_PValue').asFloat;
          end;
        end;

        nSql := 'select  b.O_BID  from  %s b  where b.O_ID=''%s'' ';
        nSql := Format(nSql, [sTable_Order , FListA.Values['WOM_LID']]);
        with gDBConnManager.WorkerQuery(nDBConn, nSql) do
        begin
          if recordcount > 0 then
          begin
            ncontractNo:= FieldByName('O_BID').AsString;
          end;
        end;
      end;
    finally
      gDBConnManager.ReleaseConnection(nDBConn);
    end;
  end;

  wParam   := TStringList.Create;
  ReStream := TStringstream.Create('');
  ParamJo  := SO();
  BodyJo   := SO();
  OneJo    := SO();
  JoA      :=SO('[]');

  FListA.Text := PackerDecodeStr(FIn.FData);
  try
    OneJo.S['billNo']           := FListA.Values['WOM_LID'];
    OneJo.S['contractNo']       := ncontractNo;
    OneJo.S['realQuantity']     := FloatToStr(nNetWeight);
    JoA.AsArray.add(OneJo);

    BodyJo.S['orderNo']         := FListA.Values['WOM_WebOrderID'];
    if FListA.Values['WOM_StatusType'] = '0' then
      BodyJo.S['status']        := '2'
    else if FListA.Values['WOM_StatusType'] = '1' then
      BodyJo.S['status']        := '4';
    BodyJo.S['facSerialNo']     := gSysParam.FFactID;
    BodyJo.S['realQuantity']    := FloatToStr(nNetWeight);
    BodyJo.O['billOrderDetail'] := JoA;
    ParamJo.S['activeCode']     := Cus_syncShopOrder;
    ParamJo.S['body']           := BodyJo.AsString;
    nStr                        := ParamJo.AsString;

    WriteLog(' �̳Ƕ���ͬ����Σ�' + nStr);

    //nStr := UTF8Encode(nStr);
    wParam.Clear;
    wParam.Add(nStr);
    
    //FidHttp������ʼ��
    ReQuestInit;

    szUrl := gSysParam.FSrvUrl + '/order/syncShopOrder';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := UTF8Decode(ReStream.DataString);
    WriteLog(' �̳Ƕ���ͬ�����Σ�' + nStr);
    if nStr <> '' then
    begin
      ReJo := SO(nStr);

      if ReJo['code'].AsString = '1' then
      begin
        Result             := True;
        FOut.FData         := sFlag_Yes;
        FOut.FBase.FResult := True;
      end
      else WriteLog(' �̳Ƕ���ͬ��ʧ�ܣ�' + ReJo['msg'].AsString);
    end;
  finally
    ReStream.Free;
    wParam.Free;
  end;
end;

function TBusWorkerBusinessWebchat.Edit_Shopgoods(var nData: string): boolean;
begin
  Result := True;
  FOut.FData := sFlag_Yes;
  FOut.FBase.FResult := True;
end;

function TBusWorkerBusinessWebchat.Get_Shoporders(var nData: string): boolean;
var
  nStr, szUrl: string;
  nIdx: Integer;
  ReJo, ParamJo, HeaderJo, BodyJo, OneJo: ISuperObject;
  ArrsJa: TSuperArray;
  wParam: TStrings;
  ReStream: TStringStream;
begin
  Result := False;
  wParam := TStringList.Create;
  ReStream := TStringstream.Create('');
  ParamJo := SO();
  HeaderJo := SO();
  BodyJo := SO();
  FListA.Text := PackerDecodeStr(FIn.FData);

  try
    //**********************
    BodyJo.S['facSerialNo'] := 'zxygc171223111220640999';   //gSysParam.FFactID;
    BodyJo.S['searchType'] := '1';             //  1 ������   2 ���ƺ�
    BodyJo.S['queryWord'] := '1533096003378'; //FListA.Values['ID'];

    ParamJo.S['activeCode']  := Cus_ShopOrder;
    ParamJo.S['body'] := BodyJo.AsString;
    nStr := ParamJo.AsString;

    WriteLog('΢���û��б���Σ�' + nStr);

    wParam.Clear;
    wParam.Add(nStr);
    //FidHttp������ʼ��
    ReQuestInit;
    
    szUrl := gSysParam.FSrvUrl + '/order/searchShopOrder';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := UTF8Decode(ReStream.DataString);
    WriteLog('�����б���ѯ���Σ�' + nStr);
    if nStr <> '' then
    begin
      FListA.Clear;
      FListB.Clear;
      ReJo := SO(nStr);
      if ReJo = nil then Exit;
      
      if ReJo['code'].AsString = '1' then
      begin
        ArrsJa := ParamJo['Data'].AsArray;

        for nIdx := 0 to ArrsJa.Length - 1 do
        begin
          OneJo := SO(ArrsJa[nIdx].AsString);

          with FListB do
          begin
            Values['order_id']    := OneJo['order_id'].AsString;
            Values['ordernumber'] := OneJo['ordernumber'].AsString;
            Values['goodsID']     := OneJo['goodsID'].AsString;
            Values['goodstype']   := OneJo['goodstype'].AsString;
            Values['goodsname']   := OneJo['goodsname'].AsString;
            Values['data']        := OneJo['data'].AsString;
          end;

          FListA.Add(PackerEncodeStr(FListB.Text));
        end;
        nData := PackerEncodeStr(FListA.Text);
      end
      else
      begin
        WriteLog('�����б���ѯʧ�ܣ�' + OneJo['msg'].AsString);
        Exit;
      end;
    end;

    Result := True;
    FOut.FData := nData;
    FOut.FBase.FResult := True;
  finally
    ReStream.Free;
    wParam.Free;
  end;
end;

function TBusWorkerBusinessWebchat.Get_ShoporderByNO(var nData: string): boolean;
var
  nStr, nWebOrder, szUrl: string;
  ReJo, ParamJo, BodyJo, OneJo, ReBodyJo : ISuperObject;
  ArrsJa: TSuperArray;
  wParam, FListD, FListE : TStrings;
  ReStream: TStringStream;
  nIdx: Integer;
begin
  Result := False;
  nWebOrder := PackerDecodeStr(FIn.FData);
  wParam := TStringList.Create;
  FListD := TStringList.Create;
  FListE := TStringList.Create;
  ReStream := TStringstream.Create('');
  ParamJo := SO();
  BodyJo := SO();
  try
    BodyJo.S['searchType'] := '1';             //  1 ������   2 ���ƺ�
    BodyJo.S['queryWord']  := nWebOrder;
    BodyJo.S['facSerialNo']:= gSysParam.FFactID; //'zxygc171223111220640999';

    ParamJo.S['activeCode']  := Cus_ShopOrder;
    ParamJo.S['body'] := BodyJo.AsString;
    nStr := ParamJo.AsString;
    //nStr := Ansitoutf8(nStr);
    WriteLog('��ȡ������Ϣ���:' + nStr);

    wParam.Clear;
    wParam.Add(nStr);
    //FidHttp������ʼ��
    ReQuestInit;
    
    szUrl := gSysParam.FSrvUrl + '/order/searchShopOrder';
    FidHttp.Post(szUrl, wParam, ReStream);
    nStr := UTF8Decode(ReStream.DataString);
    WriteLog('��ȡ������Ϣ����:' + nStr);

    if nStr <> '' then
    begin
      FListA.Clear;
      FListB.Clear;
      FListD.Clear;
      FListE.Clear;
      ReJo := SO(nStr);
      if ReJo = nil then Exit;

      if ReJo.S['code'] = '1' then
      begin
        ReBodyJo := SO(ReJo.S['body']);
        if ReBodyJo = nil then Exit;

        ArrsJa := ReBodyJo['details'].AsArray;
        for nIdx := 0 to ArrsJa.Length - 1 do
        begin
          OneJo := SO(ArrsJa[nIdx].AsString);

          with FListE do
          begin
            Values['clientName']      := OneJo.S['clientName'];
            Values['clientNo']        := OneJo.S['clientNo'];
            Values['contractNo']      := OneJo.S['contractNo'];
            Values['engineeringSite'] := OneJo.S['engineeringSite'];
            Values['materielName']    := OneJo.S['materielName'];
            Values['materielNo']      := OneJo.S['materielNo'];
            Values['orderDetailID']   := OneJo.S['orderDetailID'];
            Values['orderDetailType'] := OneJo.S['orderDetailType'];
            Values['quantity']        := OneJo.S['quantity'];
            Values['status']          := OneJo.S['status'];
            Values['transportUnit']   := OneJo.S['transportUnit'];
          end;

          FListD.Add(PackerEncodeStr(FListE.Text));
        end;
        
        FListB.Values['details']      := PackerEncodeStr(FListD.Text);
        FListB.Values['driverId']     := ReBodyJo.S['driverId'];
        FListB.Values['drvName']      := ReBodyJo.S['drvName'];
        FListB.Values['drvPhone']     := ReBodyJo.S['drvPhone'];
        FListB.Values['factoryName']  := ReBodyJo.S['factoryName'];
        FListB.Values['licensePlate'] := ReBodyJo.S['licensePlate'];
        FListB.Values['orderId']      := ReBodyJo.S['orderId'];
        FListB.Values['orderNo']      := ReBodyJo.S['orderNo'];
        FListB.Values['state']        := ReBodyJo.S['state'];
        FListB.Values['totalQuantity']:= ReBodyJo.S['totalQuantity'];
        FListB.Values['type']         := ReBodyJo.S['type'];
        FListB.Values['realTime']     := ReBodyJo.S['realTime'];

        nStr := StringReplace(FListB.Text, '\n', #13#10, [rfReplaceAll]);
        FListA.Add(nStr);

        nData := PackerEncodeStr(FListA.Text);

        Result             := True;
        FOut.FData         := nData;
        FOut.FBase.FResult := True;
      end
      else WriteLog('������Ϣʧ�ܣ�' + ReJo.S['msg']);
    end;
  finally
    ReStream.Free;
    wParam.Free;
    FListD.Free;
    FListE.Free;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2017-11-20
//Parm: ����
//Desc: ������װ��ѯ
function TBusWorkerBusinessWebchat.GetWaitingForloading(var nData: string): Boolean;
var
  nStr: string;
  nNode: TXmlNode;
begin
  Result := False;

  BuildDefaultXML;

  nStr := 'Select Z_StockNo, COUNT(*) as Num From %s Where Z_Valid=''%s'' group by Z_StockNo';
  nStr := Format(nStr, [sTable_ZTLines, sFlag_Yes]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr), FPacker.XMLBuilder do
  begin
    if RecordCount < 1 then
    begin
      nData := '����(%s)δ������Чװ����.';
      nData := Format(nData, [gSysParam.FFactID]);
      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString := nData;
        NodeNew('MsgResult').ValueAsString := sFlag_No;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
      nData := FPacker.XMLBuilder.WriteToString;

      Exit;
    end;

    First;

    nNode := Root.NodeNew('Items');
    while not Eof do
    begin
      with nNode.NodeNew('Item') do
      begin
        NodeNew('StockName').ValueAsString := GetStockName(FieldByName('Z_StockNo').AsString);
        NodeNew('LineCount').ValueAsString := FieldByName('Num').AsString;
        NodeNew('TruckCount').ValueAsString := GetTruckByLine(FieldByName('Z_StockNo').AsString);
      end;

      nExt;
    end;

    nNode := Root.NodeNew('EXMG');
    with nNode do
    begin
      NodeNew('MsgTxt').ValueAsString := 'ҵ��ִ�гɹ�';
      NodeNew('MsgResult').ValueAsString := sFlag_Yes;
      NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
    end;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  Result := True;
end;

//------------------------------------------------------------------------------
//Date: 2017-11-20
//Parm: ˮ������
//Desc: ��ȡ��ǰ��Ʒ��ˮ������װ������
function TBusWorkerBusinessWebchat.GetTruckByLine(nStockNo: string): string;
var
  nStr, nGroup, nSQL, nGroupID: string;
  nDBWorker: PDBWorker;
  nCount: Integer;
begin
  Result := '0';
  nCount := 0;

  nDBWorker := nil;
  try
    nStr := 'Select * From %s Where T_Valid=''%s'' And T_StockNo=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, sFlag_Yes, nStockNo]);

    with gDBConnManager.SQLQuery(nStr, nDBWorker) do
    begin
      nCount := RecordCount;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if nCount <= 0 then//���ܴ�������ӳ��
  begin
    nGroup := '';
    nGroupID := '';

    nDBWorker := nil;
    try
      nStr := 'Select M_Group From %s Where M_Status=''%s'' And M_ID=''%s''';
      nStr := Format(nStr, [sTable_StockMatch, sFlag_Yes, nStockNo]);

      with gDBConnManager.SQLQuery(nStr, nDBWorker) do
      begin
        if RecordCount > 0 then
          nGroupID := Fields[0].AsString;
      end;
    finally
      gDBConnManager.ReleaseConnection(nDBWorker);
    end;

    if Length(nGroupID) > 0 then
    begin
      nDBWorker := nil;
      try
        nStr := 'Select M_ID From %s Where M_Status=''%s'' And M_Group=''%s''';
        nStr := Format(nStr, [sTable_StockMatch, sFlag_Yes, nGroupID]);

        with gDBConnManager.SQLQuery(nStr, nDBWorker) do
        begin

          First;
          while not Eof do
          begin
            nGroup := nGroup + Fields[0].AsString + ',';
            nExt;
          end;
          if Copy(nGroup, Length(nGroup), 1) = ',' then
            System.Delete(nGroup, Length(nGroup), 1);
        end;
        nSQL := AdjustListStrFormat(nGroup, '''', True, ',', False);
      finally
        gDBConnManager.ReleaseConnection(nDBWorker);
      end;

      nDBWorker := nil;
      try
        nStr := 'Select * From %s Where T_Valid=''%s'' And T_StockNo In (%s)';
        nStr := Format(nStr, [sTable_ZTTrucks, sFlag_Yes, nSQL]);

        WriteLog('��ѯ������װSQL:' + nStr);
        with gDBConnManager.SQLQuery(nStr, nDBWorker) do
        begin
          nCount := RecordCount;
        end;
      finally
        gDBConnManager.ReleaseConnection(nDBWorker);
      end;
    end;
  end;
  Result := IntToStr(nCount);
end;

//Date: 2017-10-01
//Parm: �ֵ���;�б�
//Desc: ��SysDict�ж�ȡnItem�������,����nList��
function TBusWorkerBusinessWebchat.LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
var
  nStr: string;
  nDBWorker: PDBWorker;
begin
  nDBWorker := nil;
  try
    nList.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict), MI('$Name', nItem)]);

    Result := gDBConnManager.SQLQuery(nStr, nDBWorker);

    if Result.RecordCount > 0 then
      with Result do
      begin
        First;

        while not Eof do
        begin
          nList.Add(FieldByName('D_Value').AsString);
          nExt;
        end;
      end
    else
      Result := nil;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date: 2017-10-28
//Parm: �ͻ����[FIn.FData]
//Desc: ��ȡ���ö����б�
function TBusWorkerBusinessWebchat.GetPurchaseContractList(var nData: string): Boolean;
var
  nStr, nProID: string;
  nNode: TXmlNode;
begin
  Result := False;

  nProID := Trim(FIn.FData);
  BuildDefaultXML;

  nStr := 'Select *,(B_Value-B_SentValue-B_FreezeValue) As B_MaxValue From %s PB ' +
          'left join %s PM on PM.M_ID = PB.B_StockNo ' +
          'where ((B_Value-B_SentValue>0) or (B_Value=0)) And B_BStatus=''%s'' ' + 'and B_ProID=''%s''';
  nStr := Format(nStr, [sTable_OrderBase, sTable_Materails, sFlag_Yes, nProID]);
  WriteLog('��ȡ�ɹ������б�sql:' + nStr);

  with gDBConnManager.WorkerQuery(FDBConn, nStr), FPacker.XMLBuilder do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('δ��ѯ����Ӧ��[ %s ]��Ӧ�Ķ�����Ϣ.', [FIn.FData]);

      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString := nData;
        NodeNew('MsgResult').ValueAsString := sFlag_No;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
      nData := FPacker.XMLBuilder.WriteToString;
      Exit;
    end;

    First;

    nNode := Root.NodeNew('head');
    with nNode do
    begin
      NodeNew('ProvId').ValueAsString := FieldByName('B_ProID').AsString;
      NodeNew('ProvName').ValueAsString := FieldByName('B_ProName').AsString;
    end;

    nNode := Root.NodeNew('Items');
    while not Eof do
    begin
      with nNode.NodeNew('Item') do
      begin
        NodeNew('SetDate').ValueAsString := DateTime2Str(FieldByName('B_Date').AsDateTime);
        NodeNew('BillNumber').ValueAsString := FieldByName('B_ID').AsString;
        NodeNew('StockNo').ValueAsString := FieldByName('B_StockNo').AsString;
        NodeNew('StockName').ValueAsString := FieldByName('B_StockName').AsString;
        NodeNew('MaxNumber').ValueAsString := FieldByName('B_MaxValue').AsString;
        {$IFDEF KuangFa}
        NodeNew('HasLs').ValueAsString := FieldByName('M_HasLs').AsString;
        {$ELSE}
        NodeNew('HasLs').ValueAsString := sFlag_No;
        {$ENDIF}
      end;

      nExt;
    end;

    nNode := Root.NodeNew('EXMG');
    with nNode do
    begin
      NodeNew('MsgTxt').ValueAsString := 'ҵ��ִ�гɹ�';
      NodeNew('MsgResult').ValueAsString := sFlag_Yes;
      NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
    end;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  WriteLog('��ȡ�ɹ������б�����:' + nData);
  Result := True;
end;

function TBusWorkerBusinessWebchat.GetCusName(nCusID: string): string;
var
  nStr: string;
  nDBWorker: PDBWorker;
begin
  Result := '';

  nDBWorker := nil;
  try
    nStr := 'Select C_Name From %s Where C_ID=''%s'' ';
    nStr := Format(nStr, [sTable_Customer, nCusID]);

    with gDBConnManager.SQLQuery(nStr, nDBWorker) do
    begin
      Result := Fields[0].AsString;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date: 2018-01-05
//Desc: ��ȡָ���ͻ��Ŀ��ý��
function TBusWorkerBusinessWebchat.GetCustomerValidMoney(nCustomer: string): Double;
var
  nStr: string;
  nUseCredit: Boolean;
  nVal, nCredit: Double;
begin
  Result := 0;
  nUseCredit := False;

  nStr := 'Select MAX(C_End) From %s ' + 'Where C_CusID=''%s'' and C_Money>=0 and C_Verify=''%s''';
  nStr := Format(nStr, [sTable_CusCredit, nCustomer, sFlag_Yes]);
  WriteLog('����SQL:' + nStr);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    nUseCredit := (Fields[0].AsDateTime > Str2Date('2000-01-01')) and (Fields[0].AsDateTime > Now());
  //����δ����

  nStr := 'Select * From %s Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_CusAccount, nCustomer]);
  WriteLog('�û��˻�SQL:' + nStr);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      Exit;
    end;

    nVal := FieldByName('A_InitMoney').AsFloat + FieldByName('A_InMoney').AsFloat - FieldByName('A_OutMoney').AsFloat - FieldByName('A_Compensation').AsFloat - FieldByName('A_FreezeMoney').AsFloat;
    //xxxxx
    WriteLog('�û��˻����:' + FloatToStr(nVal));
    nCredit := FieldByName('A_CreditLimit').AsFloat;
    nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;
    WriteLog('�û��˻�����:' + FloatToStr(nCredit));
    if nUseCredit then
      nVal := nVal + nCredit;
    WriteLog('�û��˻����ý�:' + FloatToStr(nVal));
    Result := Float2PInt(nVal, cPrecision, False) / cPrecision;
  end;
end;

//Date: 2018-01-05
//Desc: ��ȡָ���ͻ��Ŀ��ý��
function TBusWorkerBusinessWebchat.GetCustomerValidMoneyFromK3(nCustomer: string): Double;
var
  nStr, nCusID: string;
  nUseCredit: Boolean;
  nVal, nCredit: Double;
  nDBWorker: PDBWorker;
begin
  Result := 0;
  nUseCredit := False;

  nStr := 'Select MAX(C_End) From %s ' + 'Where C_CusID=''%s'' and C_Money>=0 and C_Verify=''%s''';
  nStr := Format(nStr, [sTable_CusCredit, FIn.FData, sFlag_Yes]);
  WriteLog('����SQL:' + nStr);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    nUseCredit := (Fields[0].AsDateTime > Str2Date('2000-01-01')) and (Fields[0].AsDateTime > Now());
  //����δ����

  nStr := 'Select A_FreezeMoney,A_CreditLimit,C_Param From %s,%s ' + 'Where A_CID=''%s'' And A_CID=C_ID';
  nStr := Format(nStr, [sTable_Customer, sTable_CusAccount, FIn.FData]);
  WriteLog('�û��˻�SQL:' + nStr);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      Exit;
    end;

    nCusID := FieldByName('C_Param').AsString;
    nVal := FieldByName('A_FreezeMoney').AsFloat;
    nCredit := FieldByName('A_CreditLimit').AsFloat;
  end;

  nDBWorker := nil;
  try
    nStr := 'DECLARE @return_value int, @Credit decimal(28, 10),' + '@Balance decimal(28, 10)' + 'Execute GetCredit ''%s'' , @Credit output , @Balance output ' + 'select @Credit as Credit , @Balance as Balance , ' + '''Return Value'' = @return_value';
    nStr := Format(nStr, [nCusID]);

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_K3) do
    begin
      if RecordCount < 1 then
      begin
        nStr := 'K3���ݿ��ϱ��Ϊ[ %s ]�Ŀͻ��˻�������.';
        nStr := Format(nStr, [nCustomer]);
        WriteLog(nStr);
        Exit;
      end;

      nVal := -(FieldByName('Balance').AsFloat) - nVal;
      if nUseCredit then
      begin
        nCredit := FieldByName('Credit').AsFloat + nCredit;
        nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;
        nVal := nVal + nCredit;
      end;

      WriteLog('�û��˻����ý�:' + FloatToStr(nVal));

      Result := Float2PInt(nVal, cPrecision, False) / cPrecision;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date: 2018-01-11
//Parm: �ͻ���[FIn.FData]
//Desc: ��ȡ�ͻ��ʽ�
function TBusWorkerBusinessWebchat.GetCusMoney(var nData: string): Boolean;
var
  nMoney: Double;
begin
  Result := False;
  BuildDefaultXML;

  nMoney := 0;
  {$IFDEF UseCustomertMoney}
  nMoney := GetCustomerValidMoney(FIn.FData);
  {$ENDIF}

  {$IFDEF UseERP_K3}
  nMoney := GetCustomerValidMoneyFromK3(FIn.FData);
  {$ENDIF}

  with FPacker.XMLBuilder do
  begin
    with Root.NodeNew('Items') do
    begin
      with NodeNew('Item') do
      begin
        NodeNew('Money').ValueAsString := FloatToStr(nMoney);
      end;
    end;

    with Root.NodeNew('EXMG') do
    begin
      NodeNew('MsgTxt').ValueAsString := 'ҵ��ִ�гɹ�';
      NodeNew('MsgResult').ValueAsString := sFlag_Yes;
      NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
    end;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  WriteLog('�ͻ��ʽ��ѯ����:' + nData);
  Result := True;
end;

//����������ѯ���ɹ������������۳�������
function TBusWorkerBusinessWebchat.GetInOutFactoryTotal(var nData: string): Boolean;
var
  nStr, nExtParam: string;
  nType, nStartDate, nEndDate: string;
  nPos: Integer;
  nNode: TXmlNode;
  nStartTime, nEndTime: string;
  nDt: TDateTime;
begin
  Result := True;
  BuildDefaultXML;

  nType := Trim(fin.FData);
  nExtParam := Trim(FIn.FExtParam);
  with FPacker.XMLBuilder do
  begin
    if (nType = '') or (nExtParam = '') then
    begin
      nData := Format('��ѯ����������쳣:[ %s ].', [nType + ',' + nExtParam]);

      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString := nData;
        NodeNew('MsgResult').ValueAsString := sFlag_No;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
      nData := FPacker.XMLBuilder.WriteToString;
      Exit;
    end;
  end;

  nPos := Pos('and', nExtParam);
  if nPos > 0 then
  begin
    nStartDate := Copy(nExtParam, 1, nPos - 1) + ' 00:00:00';
    nEndDate := Copy(nExtParam, nPos + 3, Length(nExtParam) - nPos - 2) + ' 23:59:59';
  end;

  nStr := 'Select D_Memo, D_Value From %s Where D_Name =''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_WxItem]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      nStartTime := '';
      nEndTime := '';

      First;

      while not Eof do
      begin
        if Fields[0].AsString = sFlag_InOutBegin then
          nStartTime := Fields[1].AsString;

        if Fields[0].AsString = sFlag_InOutEnd then
          nEndTime := Fields[1].AsString;

        nExt;
      end;

      if (Length(nStartTime) > 0) and (Length(nEndTime) > 0) then
      begin
        nPos := Pos('and', nExtParam);
        if nPos > 0 then
        begin
          nStartDate := Copy(nExtParam, 1, nPos - 1);
          nEndDate := Copy(nExtParam, nPos + 3, Length(nExtParam) - nPos - 2);
        end;
        WriteLog('ʱ�䴦����ʼֵ:��ʼ' + nStartDate + '����' + nEndDate);
        if nStartDate = nEndDate then
        begin
          nStartDate := nStartDate + nStartTime;
          try
            nDt := StrToDateTime(nStartDate);
            nDt := IncDay(nDt, 1);
            nEndDate := FormatDateTime('YYYY-MM-DD', nDt) + nEndTime;
          except
            on E: Exception do
            begin
              nEndDate := nEndDate + ' 23:59:59';
              WriteLog('����ʱ�䴦���쳣:' + e.Message);
            end;
          end;
        end
        else
        begin
          nStartDate := nStartDate + nStartTime;
          nEndDate := nEndDate + nEndTime;
        end;
      end;
    end;
  end;

  WriteLog('��ѯ������ʱ������:' + '��ʼ:' + nStartDate + '����:' + nEndDate);

  FListA.Text := GetInOutValue(nStartDate, nEndDate, nType);

  nStr := 'EXEC SP_InOutFactoryTotal ''' + nType + ''',''' + nStartDate + ''',''' + nEndDate + ''' ';

  with gDBConnManager.WorkerQuery(FDBConn, nStr), FPacker.XMLBuilder do
  begin
    if RecordCount < 1 then
    begin
      nData := 'δ��ѯ�������Ϣ.';

      with Root.NodeNew('EXMG') do
      begin
        NodeNew('MsgTxt').ValueAsString := nData;
        NodeNew('MsgResult').ValueAsString := sFlag_No;
        NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
      end;
      nData := FPacker.XMLBuilder.WriteToString;
      Exit;
    end;

    First;

    nNode := Root.NodeNew('head');
    with nNode do
    begin
      NodeNew('DValue').ValueAsString := FListA.Values['DValue'];
      NodeNew('SValue').ValueAsString := FListA.Values['SValue'];
      NodeNew('TotalValue').ValueAsString := FListA.Values['TotalValue'];
    end;

    nNode := Root.NodeNew('Items');
    while not Eof do
    begin
      with nNode.NodeNew('Item') do
      begin
        NodeNew('StockName').ValueAsString := FieldByName('StockName').AsString;
        NodeNew('TruckCount').ValueAsString := FieldByName('TruckCount').AsString;
        NodeNew('StockValue').ValueAsString := FieldByName('StockValue').AsString;
      end;

      nExt;
    end;

    nNode := Root.NodeNew('EXMG');
    with nNode do
    begin
      NodeNew('MsgTxt').ValueAsString := 'ҵ��ִ�гɹ�';
      NodeNew('MsgResult').ValueAsString := sFlag_Yes;
      NodeNew('MsgCommand').ValueAsString := IntToStr(FIn.FCommand);
    end;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  WriteLog('��ѯ������ͳ�Ʒ���:' + nData);
  Result := True;
end;

function TBusWorkerBusinessWebchat.GetInOutValue(nBegin, nEnd, nType: string): string;
var
  nStr, nTable: string;
  nDBWorker: PDBWorker;
  nDValue, nSValue, nTotalValue: Double;
begin
  Result := '';
  nDValue := 0;
  nSValue := 0;
  nTotalValue := 0;

  nDBWorker := nil;
  try
    nStr := 'select distinct L_type as Stock_Type, SUM(L_Value) as Stock_Value from %s ' + ' where L_OutFact >= ''%s'' and L_OutFact <= ''%s'' group by L_Type ';

    if nType = 'SZ' then
      nStr := 'select distinct L_type as Stock_Type, SUM(L_Value) as Stock_Value from %s ' + ' where L_InTime >= ''%s'' and L_InTime <= ''%s'' and L_Status <> ''O'' group by L_Type '
    else if nType = 'P' then
      nStr := 'select distinct D_Type as Stock_Type ,SUM(D_Value) as Stock_Value from %s ' + ' where D_OutFact >= ''%s'' and D_OutFact <= ''%s'' group by D_Type '
    else if nType = 'PZ' then
      nStr := 'select distinct D_Type as Stock_Type ,SUM(D_Value) as Stock_Value from %s ' + ' where D_MDate >= ''%s'' and D_MDate <= ''%s'' and D_Status <> ''O'' group by D_Type ';
    if Pos('P', nType) > 0 then
      nTable := sTable_OrderDtl
    else
      nTable := sTable_Bill;
    nStr := Format(nStr, [nTable, nBegin, nEnd]);

    WriteLog('��ѯ����ͳ��SQL:' + nStr);
    with gDBConnManager.SQLQuery(nStr, nDBWorker) do
    begin
      First;
      while not Eof do
      begin
        nTotalValue := nTotalValue + Fields[1].AsFloat;
        nStr := Fields[0].AsString;
        if nStr = sFlag_Dai then
          nDValue := Fields[1].AsFloat
        else if nStr = sFlag_San then
          nSValue := Fields[1].AsFloat;

        nExt;
      end;
    end;
    FListB.Clear;
    FListB.Values['DValue'] := FormatFloat('0.00', nDValue);
    FListB.Values['SValue'] := FormatFloat('0.00', nSValue);
    FListB.Values['TotalValue'] := FormatFloat('0.00', nTotalValue);
    Result := FListB.Text;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

function TBusWorkerBusinessWebchat.GetStockName(nStockNo: string): string;
var
  nStr: string;
  nDBWorker: PDBWorker;
begin
  Result := '';

  nDBWorker := nil;
  try
    nStr := 'Select Z_Stock From %s Where Z_StockNo=''%s'' ';
    nStr := Format(nStr, [sTable_ZTLines, nStockNo]);

    with gDBConnManager.SQLQuery(nStr, nDBWorker) do
    begin
      Result := Fields[0].AsString;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date: 2018-01-17
//Desc: ��ȡ�ֻ����ᱨ������Ϣ
function TBusWorkerBusinessWebchat.getDeclareCar(var nData: string): Boolean;
var
  nStr, nStatus: string;
  nIdx: Integer;
  nNode, nRoot: TXmlNode;
  nInit: Int64;
begin
  Result := False;
  nStatus := PackerDecodeStr(FIn.FData);

  nStr := '<?xml version="1.0" encoding="UTF-8"?>' + '<DATA>' + '<head><Factory>%s</Factory>' + '<Status>%s</Status>' + '</head>' + '</DATA>';
  nStr := Format(nStr, [gSysParam.FFactID, nStatus]);
  WriteLog('��ȡ�ᱨ������Ϣ���:' + nStr);

  Result := False;
  FWXChannel := GetReviceWS(gSysParam.FSrvRemote);
  nStr := FWXChannel.mainfuncs('getDeclareCar', nStr);

  WriteLog('��ȡ�ᱨ������Ϣ����:' + nStr);

  with FPacker.XMLBuilder do
  begin
    ReadFromString(nStr);
    if not ParseDefault(nData) then
      Exit;
    nRoot := Root.FindNode('items');

    if not Assigned(nRoot) then
    begin
      nData := '��Ч�����ڵ�(WebService-Response.items Is Null).';
      Exit;
    end;

    nInit := GetTickCount;
    FListA.Clear;
    FListB.Clear;
    for nIdx := 0 to nRoot.NodeCount - 1 do
    begin
      nNode := nRoot.Nodes[nIdx];
      if CompareText('item', nNode.Name) <> 0 then
        Continue;

      with FListB, nNode do
      begin
        Values['uniqueIdentifier'] := NodeByName('uniqueIdentifier').ValueAsString;
        Values['serialNo'] := NodeByName('serialNo').ValueAsString;
        Values['carNumber'] := NodeByName('carNumber').ValueAsString;
        Values['drivingLicensePath'] := NodeByName('drivingLicensePath').ValueAsString;
        Values['custName'] := NodeByName('custName').ValueAsString;
        Values['custPhone'] := NodeByName('custPhone').ValueAsString;
        Values['tare'] := NodeByName('tare').ValueAsString;
      end;
      SaveAuditTruck(FlistB, nStatus);
      FListA.Add(PackerEncodeStr(FListB.Text));
      //new item
    end;
  end;
  WriteLog('���泵��������ݺ�ʱ: ' + IntToStr(GetTickCount - nInit) + 'ms');
  Result := True;
  FOut.FData := FListA.Text;
  FOut.FBase.FResult := True;
end;

procedure TBusWorkerBusinessWebchat.SaveAuditTruck(nList: TStrings; nStatus: string);
var
  nStr: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Delete From %s Where A_ID=''%s'' ';
    nStr := Format(nStr, [sTable_AuditTruck, nList.Values['uniqueIdentifier']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := MakeSQLByStr([SF('A_ID', nList.Values['uniqueIdentifier']), SF('A_Serial', nList.Values['serialNo']), SF('A_Truck', nList.Values['carNumber']), SF('A_WeiXin', nList.Values['custName']), SF('A_Phone', nList.Values['custPhone']), SF('A_LicensePath', nList.Values['drivingLicensePath']), SF('A_Status', nStatus), SF('A_Date', sField_SQLServer_Now, sfVal), SF('A_PValue', nList.Values['tare'])], sTable_AuditTruck, '', True);
    //xxxxx

    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2009-7-4
//Parm: ���ݼ�;�ֶ���;ͼ������
//Desc: ��nImageͼ�����nDS.nField�ֶ�
function TBusWorkerBusinessWebchat.SaveDBImage(const nDS: TDataSet; const nFieldName: string; const nStream: TMemoryStream): Boolean;
var
  nField: TField;
  nBuf: array[1..MAX_PATH] of Char;
begin
  Result := False;
  nField := nDS.FindField(nFieldName);
  if not (Assigned(nField) and (nField is TBlobField)) then
    Exit;

  try
    if not Assigned(nStream) then
    begin
      nDS.Edit;
      TBlobField(nField).Clear;
      nDS.Post;
      Result := True;
      Exit;
    end;

    nDS.Edit;
    nStream.Position := 0;
    TBlobField(nField).LoadFromStream(nStream);

    nDS.Post;
    Result := True;
  except
    if nDS.State = dsEdit then
      nDS.Cancel;
  end;
end;

//Date: 2018-01-22
//Desc: ������˽���ϴ�����or������ڿ�����
function TBusWorkerBusinessWebchat.UpdateDeclareCar(var nData: string): Boolean;
var
  nStr: string;
begin
  Result := False;
  FListA.Text := PackerDecodeStr(FIn.FData);

  nStr := '<?xml version="1.0" encoding="UTF-8"?>' + '<DATA>' + '<head>' + '<UniqueIdentifier>%s</UniqueIdentifier>' + '<AuditStatus>%s</AuditStatus>' + '<AuditRemark>%s</AuditRemark>' + '<AuditUserName>%s</AuditUserName>' + '<IsLongTermCar>%s</IsLongTermCar>' + '</head>' + '</DATA>';
  nStr := Format(nStr, [FListA.Values['ID'], FListA.Values['Status'], FListA.Values['Memo'], FListA.Values['Man'], FListA.Values['Type']]);
  //xxxxx

  WriteLog('��˽�����' + nStr);

  FWXChannel := GetReviceWS(gSysParam.FSrvRemote);
  nStr := FWXChannel.mainfuncs('updateDeclareCar', nStr);

  WriteLog('��˽������' + nStr);

  with FPacker.XMLBuilder do
  begin
    ReadFromString(nStr);
    if not ParseDefault(nData) then
      Exit;
  end;

  Result := True;
  FOut.FData := sFlag_Yes;
  FOut.FBase.FResult := True;
end;

//Date: 2018-01-22
//Desc: ����ͼƬ
function TBusWorkerBusinessWebchat.DownLoadPic(var nData: string): Boolean;
var
  nID, nStr: string;
  nIdx: Int64;
  nDS: TDataSet;
  nIdHTTP: TIdHTTP;
  nStream: TMemoryStream;
begin
  Result := False;
  nID := PackerDecodeStr(FIn.FData);

  nStr := 'Select * From %s Where A_ID=''%s'' ';
  nStr := Format(nStr, [sTable_AuditTruck, nID]);

  nDS := gDBConnManager.WorkerQuery(FDBConn, nStr);

  if nDS.RecordCount < 1 then
  begin
    nStr := Format('δ��ѯ������%s�����Ϣ!', [nID]);
    WriteLog(nStr);
    Exit;
  end;

  if nDS.FieldByName('A_LicensePath').AsString = '' then
  begin
    nStr := Format('����%s��Ƭ·��Ϊ��!', [nID]);
    WriteLog(nStr);
    Exit;
  end;

  nIdx := GetTickCount;

  nIdHTTP := nil;
  nStream := nil;
  try
    nIdHTTP := TIdHTTP.Create;
    nStream := TMemoryStream.Create;

    nIdHTTP.Get(nDS.FieldByName('A_LicensePath').AsString, nStream);
    nStream.Position := 0;

    SaveDBImage(nDS, 'A_License', nStream);

    nIdHTTP.Free;
    nStream.Free;
  except
    if Assigned(nIdHTTP) then
      nIdHTTP.Free;
    if Assigned(nStream) then
      nStream.Free;
    Exit;
  end;
  WriteLog('���س���ͼƬ��ʱ: ' + IntToStr(GetTickCount - nIdx) + 'ms');

  Result := True;
  FOut.FData := sFlag_Yes;
  FOut.FBase.FResult := True;
end;

//Date: 2018-01-22
//Desc: ͨ�����ƺŻ�ȡ����
function TBusWorkerBusinessWebchat.Get_ShoporderByTruck(var nData: string): boolean;
var
  nStr, nTruck: string;
  nNode, nTmp: TXmlNode;
  nInt: Integer;
begin
  Result := False;
  nTruck := PackerDecodeStr(FIn.FData);

  nStr := '<?xml version="1.0" encoding="UTF-8"?>' + '<DATA>' + '<head><Factory>%s</Factory>' + '<CarNumber>%s</CarNumber>' + '</head>' + '</DATA>';
  nStr := Format(nStr, [gSysParam.FFactID, nTruck]);
  WriteLog('��ȡ������Ϣ���:' + nStr);

  FWXChannel := GetReviceWS(gSysParam.FSrvRemote);
  nStr := FWXChannel.mainfuncs('getShopOrderByDriverNumber', nStr);
  WriteLog('��ȡ������Ϣ���ν���ǰ:' + nStr);

  with FPacker.XMLBuilder do
  begin
    ReadFromString(nStr);
    if not ParseDefault(nData) then
      Exit;

    nNode := Root.FindNode('Items');
    if not (Assigned(nNode)) then
    begin
      nData := '��Ч�����ڵ�(Items Null).';
      Exit;
    end;

    FListA.Clear;
    FListB.Clear;
    for nInt := 0 to nNode.NodeCount - 1 do
    begin
      nTmp := nNode.Nodes[nInt];

      if not (Assigned(nTmp)) then
        Continue;

      if Assigned(nTmp.NodeByName('order_id')) then
        FListB.Values['order_id'] := nTmp.NodeByName('order_id').ValueAsString;

      if Assigned(nTmp.NodeByName('order_type')) then
        FListB.Values['order_type'] := nTmp.NodeByName('order_type').ValueAsString;

      if Assigned(nTmp.NodeByName('fac_order_no')) then
        FListB.Values['fac_order_no'] := nTmp.NodeByName('fac_order_no').ValueAsString;

      if Assigned(nTmp.NodeByName('ordernumber')) then
        FListB.Values['ordernumber'] := nTmp.NodeByName('ordernumber').ValueAsString;

      if Assigned(nTmp.NodeByName('goodsID')) then
        FListB.Values['goodsID'] := nTmp.NodeByName('goodsID').ValueAsString;

      if Assigned(nTmp.NodeByName('goodstype')) then
        FListB.Values['goodstype'] := nTmp.NodeByName('goodstype').ValueAsString;

      if Assigned(nTmp.NodeByName('goodsname')) then
        FListB.Values['goodsname'] := nTmp.NodeByName('goodsname').ValueAsString;

      if Assigned(nTmp.NodeByName('tracknumber')) then
        FListB.Values['tracknumber'] := nTmp.NodeByName('tracknumber').ValueAsString;

      if Assigned(nTmp.NodeByName('data')) then
        FListB.Values['data'] := nTmp.NodeByName('data').ValueAsString;

      nStr := StringReplace(FListB.Text, '\n', #13#10, [rfReplaceAll]);

      {$IFDEF UseUTFDecode}
      nStr := UTF8Decode(nStr);
      {$ENDIF}
      WriteLog('��ȡ������Ϣ���ν����:' + nStr);

      FListA.Add(nStr);
    end;
    nData := PackerEncodeStr(FListA.Text);
  end;

  Result := True;
  FOut.FData := nData;
  FOut.FBase.FResult := True;
end;


// �����ͻ�������ѯ
function TBusWorkerBusinessWebchat.SearchClient(var nData: string): Boolean;
var nStr, nCusNo : string;
    nRoot, nNode : TXmlNode;
    nReDs: TDataSet;
begin
  Result := False;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('�ͻ�������ѯ��Σ�'+nData);
      ReadFromString(nData);
      if not ParseDefault(nData) then Exit;

      try
        nRoot := Root.FindNode('body');
        nCusNo:= nRoot.NodeByName('clientNo').ValueAsString;
      except
        nData:= '���������������!';
        Exit;
      end;

      nStr := ' Select C_ID,  C_Name, C_Phone, C_Account, ''2'' C_Type From %s ' +
              ' Where C_ID= ''%s'' Union ' +
              ' Select P_ID C_ID, P_Name C_Name, P_Phone C_Phone, '' C_Account, ''1'' C_Type From %s ' +
              ' Where P_ID= ''%s'' ';
      nStr := Format(nStr, [sTable_Customer, nCusNo, sTable_Provider, nCusNo]);
      //*****
      nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
      if nReDs.RecordCount < 1 then
      begin
        nData:= Format('δ��ѯ���ͻ� %s ��Ϣ!', [nCusNo]);
        Exit;
      end;

      nNode:= Root.NodeNew('body');
      with nNode, nReDs do
      begin
        NodeNew('facSerialNo').ValueAsString:= gSysParam.FFactID;
        NodeNew('clientNo').ValueAsString   := FieldByName('C_ID').AsString;
        NodeNew('clientName').ValueAsString := FieldByName('C_Name').AsString;
        NodeNew('btype').ValueAsString      := FieldByName('C_Type').AsString;
        NodeNew('custSerialNo').ValueAsString := FieldByName('C_ID').AsString;
        NodeNew('status').ValueAsString     := '1';
        NodeNew('custPhone').ValueAsString  := FieldByName('C_Phone').AsString;
        NodeNew('clientAccount').ValueAsString := FieldByName('C_Account').AsString;
      end;
    finally
      begin
        nNode := Root.NodeNew('header');
        with nNode do
        begin
          NodeNew('rspCode').ValueAsString := sFlag_Yes;
          NodeNew('rspDesc').ValueAsString := 'ҵ��ִ�гɹ�';
        end;
      end;
    end;
  end;
  nData := FPacker.XMLBuilder.WriteToString;
  WriteLog('�ͻ�������ѯ����:' + nData);
  Result := True;
end;

// �����ͻ�������ѯ
function TBusWorkerBusinessWebchat.SearchContractOrder(var nData: string): Boolean;
var nStr, nCusNo, nType : string;
    nRoot, nNode, nheader, nbody : TXmlNode;
    nReDs: TDataSet;
    nMoney : Double;
begin
  Result:= False;  nMoney:= 0;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('�ͻ�������ѯ��Σ�'+nData);
      nCusNo:= FIn.FData;

      //************************************************************************
      //************************************************************************
      Root.Clear;
      nheader:= Root.NodeNew('header');
      with nheader do
      begin
        NodeNew('rspCode').ValueAsString:= '1';
        NodeNew('rspDesc').ValueAsString:= nData;
      end;

      nMoney := GetCustomerValidMoney(nCusNo);
      {$IFDEF UseERP_K3}
      nMoney := GetCustomerValidMoneyFromK3(nCusNo);
      {$ENDIF}

      if nType='1' then
      begin
        nStr := ' Select *, Case When(D_Type=''D'')then 1 else 2 end MType, '+
                          'Case When(ISNULL(Z_OnlyMoney, '''')=''Y'') then CONVERT(Decimal(15,2), (%g/ISNULL(D_Price, 10000))) '+
                          'else CONVERT(Decimal(15,2), (%g/ISNULL(D_Price, 10000))) End MaxValue From %s Left Join %s On D_ZID=Z_ID '+
                ' Where Z_Customer= ''%s'' ';
        nStr := Format(nStr, [sTable_ZhiKa, sTable_ZhiKaDtl, nMoney, nMoney, nCusNo]);
      end
      else
      begin
        nStr := ' Select *,(B_Value-B_SentValue-B_FreezeValue) As B_MaxValue From %s Where B_ProID= ''%s'' ';
        nStr := Format(nStr, [sTable_OrderBase, nCusNo]);
      end;
      //*****
      nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
      if nReDs.RecordCount < 1 then
      begin
        nData:= Format('δ��ѯ���ͻ� %s ��Ϣ!', [nCusNo]);
        Exit;
      end;

      nNode:= Root.NodeNew('body');
      with nNode, nReDs do
      begin
        if nType='1' then
        begin
          NodeNew('contractNo').ValueAsString   := FieldByName('Z_ID').AsString;
          NodeNew('contractTime').ValueAsString := FormatDateTime('yyMMddHHmmss', FieldByName('Z_Date').AsDateTime);
          NodeNew('materielNo').ValueAsString   := FieldByName('D_StockNo').AsString;
          NodeNew('materielName').ValueAsString := FieldByName('D_StockNoName').AsString;
          NodeNew('maxCapacity').ValueAsString  := FieldByName('MaxValue').AsString;
          NodeNew('engineeringSite').ValueAsString := FieldByName('Z_Project').AsString;
          NodeNew('materielType').ValueAsString := FieldByName('MType').AsString;
        end
        else
        begin
          NodeNew('contractNo').ValueAsString   := FieldByName('B_ID').AsString;
          NodeNew('contractTime').ValueAsString := FormatDateTime('yyMMddHHmmss', FieldByName('B_Date').AsDateTime);
          NodeNew('materielNo').ValueAsString   := FieldByName('B_StockNo').AsString;
          NodeNew('materielName').ValueAsString := FieldByName('B_StockNoName').AsString;
          NodeNew('maxCapacity').ValueAsString  := FieldByName('B_MaxValue').AsString;
          NodeNew('engineeringSite').ValueAsString := FieldByName('B_Project').AsString;
          NodeNew('materielType').ValueAsString := '1';;
        end;
      end;
      nData := '�����ɹ�';
      Result:= True;
    finally
      begin
        with Root.FindNode('header') do
        begin
          if Result then NodeNew('rspCode').ValueAsString:= '0'
          else NodeNew('rspCode').ValueAsString:= '1';

          NodeNew('rspDesc').ValueAsString:= nData;
        end;

        nData := FPacker.XMLBuilder.WriteToString;
        WriteLog('�ͻ�������ѯ����:' + nData);
      end;
    end;
  end;
end;

// ����������Ϣ��ѯ
function TBusWorkerBusinessWebchat.SearchMateriel(var nData: string): Boolean;
var nStr, nMtlNo, nMType, nWh : string;
    nRoot, nNode, nheader, nbody : TXmlNode;
    nReDs: TDataSet;
begin
  Result := False;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('������Ϣ��ѯ��Σ�'+nData);
      ReadFromString(nData);
      if not ParseDefault(nData) then Exit;

      try
        nRoot := Root.FindNode('body');
        nMtlNo:= nRoot.NodeByName('materielNo').ValueAsString;
        nMType:= nRoot.NodeByName('materielType').ValueAsString;
      except
        on Ex : Exception do
        begin
          nData:= '���������������!';
          WriteLog(nData+' '+Ex.Message);
          Exit;
        end;
      end;

      //************************************************************************
      //************************************************************************
      Root.Clear;
      nheader:= Root.NodeNew('header');
      with nheader do
      begin
        NodeNew('rspCode').ValueAsString:= '1';
        NodeNew('rspDesc').ValueAsString:= nData;
      end;

      if nMtlNo<>'' then nWh:= ' And (M_ID='''+nMtlNo+''') ';
      if nMType<>'' then nWh:= nWh + ' And (MType='''+nMtlNo+''') ';

      nStr := ' Select *, Case When(MType=''D'')then 1 else 2 end M_Type From ( ' + 
              ' Select D_ParamB M_ID, D_Value M_Name, D_Memo MType, 1 BusType From ''%s'' Where D_Name=''StockItem''  ' +
              ' Union ' +
              ' Select M_ID, M_Name, ''S'' MType, 2 BusType From ''%s'' ' +
              ' Where 1=1 ' + nWh +
              ' Order by MType';
      nStr := Format(nStr, [sTable_SysDict, sTable_Materails]);
      //*****
      nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
      if nReDs.RecordCount < 1 then
      begin
        nData:= 'δ��ѯ�����������Ϣ!';
        Exit;
      end;

      nNode:= Root.NodeNew('body');
      nNode.NodeNew('facSerialNo').ValueAsString:= gSysParam.FFactID;
      nNode.NodeNew('materiels').ValueAsString:= '';

      with nReDs do
      begin
        First;
        while not nReDs.Eof do
        begin
          nNode:= Root.NodeNew('materiel');
          with nNode do
          begin
            NodeNew('materielNo').ValueAsString   := FieldByName('M_ID').AsString;
            NodeNew('materielName').ValueAsString := FieldByName('M_Name').AsString;
            NodeNew('materielType').ValueAsString := FieldByName('M_Type').AsString;
            NodeNew('businessType').ValueAsString := FieldByName('BusType').AsString;
          end;
        end;
      end;
      nData := '�����ɹ�';
      Result:= True;
    finally
      begin
        with Root.FindNode('header') do
        begin
          if Result then NodeNew('rspCode').ValueAsString:= '0'
          else NodeNew('rspCode').ValueAsString:= '1';

          NodeNew('rspDesc').ValueAsString:= nData;
        end;

        nData := FPacker.XMLBuilder.WriteToString;
        WriteLog('������Ϣ����:' + nData);
      end;
    end;
  end;
end;

// �������۶�����Ϣ��ѯ
function TBusWorkerBusinessWebchat.SearchBill(var nData: string): Boolean;
var nStr, nBillNo : string;
    nRoot, nNode, nheader, nbody : TXmlNode;
    nReDs: TDataSet;
begin
  Result := False;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('���۶�����ѯ��Σ�'+nData);
      ReadFromString(nData);
      if not ParseDefault(nData) then Exit;

      try
        nRoot := Root.FindNode('body');
        nBillNo:= nRoot.NodeByName('billNo').ValueAsString;

        if nBillNo='' then
        begin
          nData:= '����д�������!';
          Exit;
        end;
      except
        on Ex : Exception do
        begin
          nData:= '���������������!';
          WriteLog(nData+' '+Ex.Message);
          Exit;
        end;
      end;

      //************************************************************************
      //************************************************************************
      Root.Clear;
      nheader:= Root.NodeNew('header');
      with nheader do
      begin
        NodeNew('rspCode').ValueAsString:= '1';
        NodeNew('rspDesc').ValueAsString:= nData;
      end;

      nStr := ' Select * From ''%s'' Where L_ID=''%s''  ';
      nStr := Format(nStr, [sTable_Bill, nBillNo]);
      //*****
      nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
      if nReDs.RecordCount < 1 then
      begin
        nData:= 'δ��ѯ����ص���!';
        Exit;
      end;

      nNode:= Root.NodeNew('body');
      with nReDs do
      begin
        First;
        while not nReDs.Eof do
        begin
          with nNode do
          begin
            NodeNew('facSerialNo').ValueAsString:= gSysParam.FFactID;
            NodeNew('billNo').ValueAsString     := FieldByName('L_ID').AsString;

            if FieldByName('L_Status').AsString='O' then
              NodeNew('status').ValueAsString := '300'

            else if ((FieldByName('L_Status').AsString='I')or
                    (FieldByName('L_Status').AsString='P')or
                    (FieldByName('L_Status').AsString='M')Or
                    (FieldByName('L_Status').AsString='F')Or
                    (FieldByName('L_Status').AsString='Z')) then
              NodeNew('status').ValueAsString := '200'

            else if (FieldByName('M_L_StatusID').AsString='')and
                    (FieldByName('L_Card').AsString<>'') then
              NodeNew('status').ValueAsString := '100'

            else NodeNew('status').ValueAsString := '0';

            NodeNew('realQuantity').ValueAsString := FieldByName('L_Value').AsString;
          end;
        end;
      end;
      nData := '�����ɹ�';
      Result:= True;
    finally
      begin
        with Root.FindNode('header') do
        begin
          if Result then NodeNew('rspCode').ValueAsString:= '0'
          else NodeNew('rspCode').ValueAsString:= '1';

          NodeNew('rspDesc').ValueAsString:= nData;
        end;

        nData := FPacker.XMLBuilder.WriteToString;
        WriteLog('���۶�����Ϣ����:' + nData);
      end;
    end;
  end;
end;

// ���������
function TBusWorkerBusinessWebchat.CreateBill(var nData: string): Boolean;
var nStr, nBillNo : string;
    nRoot, nDetails, nDetail, nItem, nheader, nbody : TXmlNode;
    nReDs: TDataSet;
    nIdx : Integer;
begin
  Result := False;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('�����������Σ�'+nData);
      ReadFromString(nData);
      if not ParseDefault(nData) then Exit;

      try
        nRoot := Root.FindNode('body');
        nBillNo:= nRoot.NodeByName('orderNo').ValueAsString;
        nBillNo:= nRoot.NodeByName('ctype').ValueAsString;
        nBillNo:= nRoot.NodeByName('type').ValueAsString;
        nBillNo:= nRoot.NodeByName('orderID').ValueAsString;
        nBillNo:= nRoot.NodeByName('totalQuantity').ValueAsString;
        nBillNo:= nRoot.NodeByName('drvName').ValueAsString;
        nBillNo:= nRoot.NodeByName('drvPhone').ValueAsString;
        nBillNo:= nRoot.NodeByName('licensePlate').ValueAsString;
        nBillNo:= nRoot.NodeByName('makeTime').ValueAsString;

        nBillNo:= nRoot.NodeByName('totalQuantity').ValueAsString;
        nBillNo:= nRoot.NodeByName('totalQuantity').ValueAsString;
      except
        on Ex : Exception do
        begin
          nData:= '���������������!';
          WriteLog(nData+' '+Ex.Message);
          Exit;
        end;
      end;
      
      //************************************************************************
      //************************************************************************
      Root.Clear;
      nheader:= Root.NodeNew('header');
      with nheader do
      begin
        NodeNew('rspCode').ValueAsString:= '1';
        NodeNew('rspDesc').ValueAsString:= nData;
      end;

      nStr := ' Select * From ''%s'' Where L_ID=''%s''  ';
      nStr := Format(nStr, [sTable_Bill, nBillNo]);
      //*****
      nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
      if nReDs.RecordCount < 1 then
      begin
        nData:= 'δ��ѯ����ص���!';
        Exit;
      end;

      nDetails:= Root.FindNode('details');
      for nIdx:= 0 to nDetails.NodeCount-1 do
      begin
        nItem := nDetails[nIdx];

        FListB.Clear;
        with FListB, nItem do
        begin
          //Values['DtlID']  := NodeByName('orderDetailID').ValueAsString;
          Values['DtlType']   := NodeByName('orderDetailType').ValueAsString;
          Values['CusID']     := NodeByName('clientNo').ValueAsString;
          Values['CusName']   := NodeByName('clientName').ValueAsString;
          Values['ZID']       := NodeByName('contractNo').ValueAsString;
          Values['StockID']   := NodeByName('materielNo').ValueAsString;
          Values['StockName'] := NodeByName('materielName').ValueAsString;
          Values['Value']     := NodeByName('quantity').ValueAsString;
        end;
        FListA.Add(FListB.Text);
      end;
      PackerEncodeStr(FListA.Text);

      nData := '�����ɹ�';
      Result:= True;
    finally
      begin
        with Root.FindNode('header') do
        begin
          if Result then NodeNew('rspCode').ValueAsString:= '0'
          else NodeNew('rspCode').ValueAsString:= '1';

          NodeNew('rspDesc').ValueAsString:= nData;
        end;

        nData := FPacker.XMLBuilder.WriteToString;
        WriteLog('�������������:' + nData);
      end;
    end;
  end;
end;

// �������۶�����α���ѯ�����Σ�
function TBusWorkerBusinessWebchat.SearchSecurityCode(var nData: string): Boolean;
var nStr, nFacID, nSeCode : string;
    nRoot, nNode, nheader, nbody : TXmlNode;
    nReDs: TDataSet;
begin
  Result := False;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('��α���ѯ��Σ�'+nData);
      ReadFromString(nData);
      if not ParseDefault(nData) then Exit;

      try
        nRoot := Root.FindNode('body');
        nFacID := nRoot.NodeByName('facSerialNo').ValueAsString;
        nSeCode:= nRoot.NodeByName('securityCode').ValueAsString;

        if nFacID<>gSysParam.FFactID then
        begin
          nData:= '����ID�뵱ǰ������Ϣ��ƥ�䣬����!';
          Exit;
        end;
      except
        on Ex : Exception do
        begin
          nData:= '���������������!';
          WriteLog(nData+' '+Ex.Message);
          Exit;
        end;
      end;

      Root.Clear;
      nheader:= Root.NodeNew('header');
      with nheader do
      begin
        NodeNew('rspCode').ValueAsString:= '1';
        NodeNew('rspDesc').ValueAsString:= nData;
      end;

      nStr := ' Select * From ''%s'' Where R_SerialNo=''%s''  ';
      nStr := Format(nStr, [sTable_StockRecord, nSeCode]);
      //*****
      nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
      if nReDs.RecordCount < 1 then
      begin
        nData:= 'δ��ѯ����ص���!';
        Exit;
      end;

      nbody:= Root.NodeNew('body');
      with nReDs, nbody do
      begin
        NodeNew('facSerialNo').ValueAsString:= gSysParam.FFactID;
        NodeNew('clientNo').ValueAsString   := FieldByName('L_ID').AsString;
        NodeNew('realQuantity').ValueAsString := FieldByName('L_Value').AsString;
      end;
      nData := '�����ɹ�';
      Result:= True;
    finally
      begin
        with Root.FindNode('header') do
        begin
          if Result then NodeNew('rspCode').ValueAsString:= '0'
          else NodeNew('rspCode').ValueAsString:= '1';

          NodeNew('rspDesc').ValueAsString:= nData;
        end;

        nData := FPacker.XMLBuilder.WriteToString;
        WriteLog('��α���ѯ����:' + nData);
      end;
    end;
  end;
end;

// ����������Ϣ��ѯ
function TBusWorkerBusinessWebchat.QueryTruckQuery(var nData: string): Boolean;
var nStr, nFacID, nTruckNo, nTruckLine, nTruckRanking : string;
    nRoot, nheader, nbody, nPrincipalQueue, nQueues, nQueue : TXmlNode;
    nReDs, nDataDs: TDataSet;
begin
  Result := False;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('�������в�ѯ��Σ�'+nData);
      ReadFromString(nData);
      if not ParseDefault(nData) then Exit;

      try
        nRoot := Root.FindNode('body');
        nFacID  := nRoot.NodeByName('facSerialNo').ValueAsString;
        nTruckNo:= nRoot.NodeByName('licensePlate').ValueAsString;

        if nFacID<>gSysParam.FFactID then
        begin
          nData:= '����ID�뵱ǰ������Ϣ��ƥ�䣬����!';
          Exit;
        end;
      except
        on Ex : Exception do
        begin
          nData:= '���������������!';
          WriteLog(nData+' '+Ex.Message);
          Exit;
        end;
      end;

      Root.Clear;
      nheader:= Root.NodeNew('header');
      with nheader do
      begin
        NodeNew('rspCode').ValueAsString:= '1';
        NodeNew('rspDesc').ValueAsString:= nData;
      end;

      nbody  := Root.NodeNew('body');
      with nbody do
      begin
        NodeNew('facSerialNo').ValueAsString:= gSysParam.FFactID;
        //************************************************************************ �������ڳ�����Ϣ
        if nTruckNo<>'' then
        begin
          nStr := ' Select * From ''%s'' Where L_Status<>''O'' And L_Truck=''%s'' ';
          nStr := Format(nStr, [sTable_Bill, nTruckNo]);
          //*****
          nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
          if nReDs.RecordCount < 1 then
          begin
            nData:= 'δ��ѯ���ó���������Ϣ!';
            Exit;
          end;

          nStr := ' Select * From ''%s'' Where T_Truck=''%s'' ';
          nStr := Format(nStr, [sTable_ZTTrucks, nTruckNo]);
          //*****
          nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
          if nReDs.RecordCount < 1 then
          begin
            nData:= 'δ��ѯ���ó���������Ϣ!';
            Exit;
          end;
          nTruckLine:= nReDs.FieldByName('T_Line').AsString;

          nStr := ' Select ROW_NUMBER() over(order by T_InFact) RID, * From ''%s'' '+
                  ' Where T_Line=''%s''  Order by T_InFact ';
          nStr := Format(nStr, [sTable_ZTTrucks, nTruckLine]);
          //*****
          nDataDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
          with nDataDs do
          while not Eof do
          begin
            if FieldByName('T_Truck').AsString=nTruckNo then
            begin
              nTruckRanking:= FieldByName('RID').AsString;
              Break;
            end;
            Next;
          end;

          with NodeNew('principalQueue') do
          begin
            NodeNew('materielName').ValueAsString:= nDataDs.FieldByName('T_Stock').AsString;
            NodeNew('lineChannel').ValueAsString := nTruckLine;
            NodeNew('truckCount').ValueAsInteger := nDataDs.RecordCount;
            NodeNew('currentRanking').ValueAsString:= nTruckRanking;
          end;
        end;

        //************************************************************************  ȫ��������Ϣ
        //nStr := 'Select T_Stock, T_Line, COUNT(*) From %s Where T_Line is Not Null Group by T_Stock, T_Line ';
        nStr := 'Select Z_ID, Z_Name, Z_StockNo, Z_Stock, T_Line, ' +
                '	Case When (T_Line IS Null) then 0 else COUNT(*) end LCount From %s ' +
                'Left Join %s on Z_ID=T_Line ' +
                'Group by Z_ID, Z_Name, Z_StockNo, Z_Stock, T_Line ';
        nStr := Format(nStr, [sTable_ZTLines, sTable_ZTTrucks]);
        nDataDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
        if nDataDs.RecordCount>0 then
        with nDataDs do
        begin
          First;
          nQueues:= NodeNew('queues');
          with nQueues do
          begin
            while not Eof do
            begin
              nQueue:= NodeNew('queue');
              with nQueue do
              begin
                NodeNew('materielName').ValueAsString:= FieldByName('Z_Stock').AsString;
                NodeNew('lineChannel').ValueAsString := FieldByName('Z_Name').AsString;
                NodeNew('truckCount').ValueAsInteger := FieldByName('LCount').AsInteger;
              end;
              Next;
            end;
          end;
        end;
      end;
      nData := '�����ɹ�';
      Result:= True;
    finally
      begin
        nheader:= Root.FindNode('header');
        with nheader do
        begin
          if Result then NodeNew('rspCode').ValueAsString:= '0'
          else NodeNew('rspCode').ValueAsString:= '1';

          NodeNew('rspDesc').ValueAsString:= nData;
        end;

        nData := FPacker.XMLBuilder.WriteToString;
        WriteLog('�������в�ѯ����:' + nData);
      end;
    end;
  end;
end;

// �������ۡ��ɹ�ͳ����Ϣ��ѯ
function TBusWorkerBusinessWebchat.BillStats(var nData: string): Boolean;
var nStr, nFacID, nSType, nSDate, nEDate, nType : string;
    nRoot, nheader, nbody, nStatItems, nStatItem : TXmlNode;
    nReDs : TDataSet;
begin
  Result := False;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('���ۡ��ɹ�ͳ�Ʋ�ѯ��Σ�'+nData);
      ReadFromString(nData);
      if not ParseDefault(nData) then Exit;

      try
        nRoot := Root.FindNode('body');
        nFacID := nRoot.NodeByName('facSerialNo').ValueAsString;
        nSType := nRoot.NodeByName('statType').ValueAsString;
        nSDate := nRoot.NodeByName('startDate').ValueAsString;
        nEDate := nRoot.NodeByName('endDate').ValueAsString;

        if nFacID<>gSysParam.FFactID then
        begin
          nData:= '����ID�뵱ǰ������Ϣ��ƥ�䣬����!';
          Exit;
        end;
      except
        on Ex : Exception do
        begin
          nData:= '���������������!';
          WriteLog(nData+' '+Ex.Message);
          Exit;
        end;
      end;

      Root.Clear;
      nheader:= Root.NodeNew('header');
      with nheader do
      begin
        NodeNew('rspCode').ValueAsString:= '1';
        NodeNew('rspDesc').ValueAsString:= nData;
      end;

      nbody  := Root.NodeNew('body');
      with nbody do
      begin
        NodeNew('facSerialNo').ValueAsString:= gSysParam.FFactID;
        NodeNew('statType').ValueAsString   := nSType;
        //************************************************************************
        if nSType<>'S' then         //*************  ���۳���
        begin
          nStr := ' Select L_StockNo, L_StockName, L_Type, SUM(L_Value) L_Value, COUNT(*) L_Count From %s ' +
                  ' Where  L_OutFact>=''%s 00:00:00'' and L_OutFact<=''%s 23:59:59'' ' +
                  ' Group  by L_StockNo, L_StockName, L_Type ';
          nStr := Format(nStr, [sTable_Bill, nSDate, nEDate]);
        end
        else if nSType<>'SZ' then   //*************  ���۽���
        begin
          nStr := ' Select L_StockNo, L_StockName, L_Type, SUM(L_Value) L_Value, COUNT(*) L_Count From %s ' +
                  ' Where  L_InTime>=''%s 00:00:00'' and L_InTime<=''%s 23:59:59'' ' +
                  ' Group  by L_StockNo, L_StockName, L_Type ';
          nStr := Format(nStr, [sTable_Bill, nSDate, nEDate]);
        end
        else if nSType<>'P' then    //*************  �ɹ�����
        begin
          nStr := ' Select D_StockNo, D_StockName, D_Type, SUM(D_MValue-D_PValue-ISNULL(D_KZValue, 0)) D_Value, COUNT(*) D_Count From %s ' +
                  ' Where  D_InTime>=''%s 00:00:00'' and D_InTime<=''%s 23:59:59'' ' +
                  ' Group  by D_StockNo, D_StockName, D_Type ';
          nStr := Format(nStr, [sTable_Bill, nSDate, nEDate]);
        end
        else if nSType<>'PZ' then    //*************  �ɹ�����
        begin
          nStr := ' Select D_StockNo, D_StockName, D_Type, SUM(D_MValue-D_PValue-ISNULL(D_KZValue, 0)) D_Value, COUNT(*) D_Count From %s ' +
                  ' Where  D_OutFact>=''%s 00:00:00'' and D_OutFact<=''%s 23:59:59'' ' +
                  ' Group  by D_StockNo, D_StockName, D_Type ';
          nStr := Format(nStr, [sTable_Bill, nSDate, nEDate]);
        end;


        nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
        if nReDs.RecordCount < 1 then
        begin
          nData:= 'δ��ѯ�������Ϣ!';
          Exit;
        end;

        nStatItems:= NodeNew('statItems');
        with nStatItems, nReDs do
        begin
            First;
            while not Eof do
            begin
                nStatItem:= NodeNew('statItem');
                with nStatItem do
                begin
                  if FieldByName('L_Type').AsString='D' then
                    nType:= '1' else nType:= '2';

                  NodeNew('materielNo').ValueAsString    := FieldByName('L_StockNo').AsString;
                  NodeNew('materielName').ValueAsString  := FieldByName('L_StockName').AsString;
                  NodeNew('materielType').ValueAsString  := nType;
                  NodeNew('truckCount').ValueAsInteger   := FieldByName('L_Count').AsInteger;
                  NodeNew('totalQuantity').ValueAsInteger:= FieldByName('L_Value').AsInteger;
                end;
                Next;
            end;
        end;
      end;
      nData := '�����ɹ�';
      Result:= True;
    finally
      begin
        with Root.FindNode('header') do
        begin
          if Result then NodeNew('rspCode').ValueAsString:= '0'
          else NodeNew('rspCode').ValueAsString:= '1';

          NodeNew('rspDesc').ValueAsString:= nData;
        end;

        nData := FPacker.XMLBuilder.WriteToString;
        WriteLog('���ۡ��ɹ�ͳ�Ʋ�ѯ����:' + nData);
      end;
    end;
  end;
end;

// �������۶������鵥��ѯ
function TBusWorkerBusinessWebchat.HYDanReport(var nData: string): Boolean;
var nStr, nFacID, nbillNo, nRptType : string;
    nRoot, nheader, nbody, nItems, nItem : TXmlNode;
    nReDs : TDataSet;
begin
  Result := False;
  with FPacker.XMLBuilder do
  begin
    try
      WriteLog('���鵥��ѯ��Σ�'+nData);
      ReadFromString(nData);
      if not ParseDefault(nData) then Exit;

      try
        nRoot := Root.FindNode('body');
        nFacID  := nRoot.NodeByName('facSerialNo').ValueAsString;
        nRptType:= nRoot.NodeByName('reportType').ValueAsString;
        nbillNo := nRoot.NodeByName('billNo').ValueAsString;

        if nFacID<>gSysParam.FFactID then
        begin
          nData:= '����ID�뵱ǰ������Ϣ��ƥ�䣬����!';
          Exit;
        end;
      except
        on Ex : Exception do
        begin
          nData:= '���������������!';
          WriteLog(nData+' '+Ex.Message);
          Exit;
        end;
      end;

      Root.Clear;
      nheader:= Root.NodeNew('header');
      with nheader do
      begin
        NodeNew('rspCode').ValueAsString:= '1';
        NodeNew('rspDesc').ValueAsString:= nData;
      end;

      nbody  := Root.NodeNew('body');
      with nbody do
      begin
        NodeNew('facSerialNo').ValueAsString:= gSysParam.FFactID;
        NodeNew('reportType').ValueAsString := nRptType;
        //************************************************************************
        nStr := ' Select hy.*,sr.*,C_Name From %s HY   ' +
                ' Left Join %s cus on cus.C_ID=HY.H_Custom  ' +
                ' Left Join (  ' +
                '  Select * From S_StockRecord sr Left Join S_StockParam sp on sp.P_ID=sr.R_PID ' +
                '  ) sr on sr.R_SerialNo=H_SerialNo ' +
                ' Where H_Reporter=''%s'' ';
        nStr := Format(nStr, [sTable_StockHuaYan, sTable_Customer, sTable_StockRecord,
                              sTable_StockParam, nbillNo]);
        nReDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
        if nReDs.RecordCount < 1 then
        begin
          nData:= 'δ��ѯ�������Ϣ!';
          Exit;
        end;

        nItems:= NodeNew('reportResults');
        with nItems, nReDs do
        begin
            First;
            while not Eof do
            begin
                nItem:= NodeNew('reportResult');
                with nItem do
                begin
                  NodeNew('CusID').ValueAsString    := FieldByName('H_Custom').AsString;
                  NodeNew('CusName').ValueAsString  := FieldByName('H_CusName').AsString;
                  NodeNew('SerialNo').ValueAsString := FieldByName('R_SerialNo').AsString;
                  NodeNew('RPID').ValueAsString     := FieldByName('R_PID').AsString;
                  NodeNew('Rso3').ValueAsString     := FieldByName('R_SO3').AsString;
                  NodeNew('ShaoShi').ValueAsString  := FieldByName('R_ShaoShi').AsString;
                  NodeNew('ChuNing').ValueAsString  := FieldByName('R_ChuNing').AsString;
                  NodeNew('ZhongNing').ValueAsString:= FieldByName('R_ZhongNing').AsString;
                end;
                Next;
            end;
        end;
      end;
      nData := '�����ɹ�';
      Result:= True;
    finally
      begin
        with Root.FindNode('header') do
        begin
          if Result then NodeNew('rspCode').ValueAsString:= '0'
          else NodeNew('rspCode').ValueAsString:= '1';

          NodeNew('rspDesc').ValueAsString:= nData;
        end;

        nData := FPacker.XMLBuilder.WriteToString;
        WriteLog('���鵥��ѯ����:' + nData);
      end;
    end;
  end;
end;


procedure TBusWorkerBusinessWebchat.ReQuestInit;
begin
  //****************************
  FidHttp.Request.Clear;
  FidHttp.Request.Accept := 'application/json, text/javascript, */*; q=0.01';
  FidHttp.Request.AcceptLanguage := 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
  FidHttp.Request.ContentType    := 'application/json;Charset=UTF-8';
  FidHttp.Request.Connection     := 'keep-alive';
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerBusinessWebchat, sPlug_ModuleBus);

end.
