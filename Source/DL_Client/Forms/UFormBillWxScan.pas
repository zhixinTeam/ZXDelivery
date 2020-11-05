unit UFormBillWxScan;

interface

{$I Link.Inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, USysBusiness,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  Menus, ExtCtrls, cxButtons, cxTextEdit, cxCheckBox, cxMaskEdit,
  cxDropDownEdit, dxLayoutcxEditAdapters, dxLayoutControlAdapters;

type
  TCommonInfo = record
    FZhiKa: string;
    FCusID: string;
    FMoney: Double;
    FOnlyMoney: Boolean;
    FIDList: string;
    FShowPrice: Boolean;
    FPriceChanged: Boolean;

    FCard: string;
    FTruck: string;
    FPlan: PSalePlanItem;
  end;
  
  PMallOrderItem = ^stMallOrderItem;
  stMallOrderItem = record
    FCusID:string;
    FCusName:string;  
    FOrder_id:string;
    FOrdernumber:string;
    FGoodsID:string;
    FGoodstype:string;
    FGoodsname:string;
    FData:string;
    Ftracknumber:string;
    FYunTianOrderId:string;//云天系统订单号
    FfactoryName:string;   //工厂名称
    FdriverId:string;      //司机编号
    FdrvName:string;       //司机名称
    FdrvPhone:string;      //司机号码
    ForderDetailType:string; //订单类别：1：普通订单；2：同客户合单；3：非同客户拼单
    FType:string;   //销售或采购
    FXHSpot:string; //卸货地点
    FPrice:string;//单价  拼单用
    FStatus: string;      //订单状态 1：新订单   
  end;
  //网上商城订单明细

  TfFormBillWx = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    editWebOrderNo: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    btnQuery: TcxButton;
    dxlytmLayout1Item5: TdxLayoutItem;
    edt_CID: TcxTextEdit;
    dxlytmLayout1Item51: TdxLayoutItem;
    edt_CName: TcxTextEdit;
    dxLayout1Group3: TdxLayoutGroup;
    dxlytmLayout1Item52: TdxLayoutItem;
    edt_MID: TcxTextEdit;
    dxlytmLayout1Item53: TdxLayoutItem;
    edt_MName: TcxTextEdit;
    dxlytmLayout1Item54: TdxLayoutItem;
    edt_Truck: TcxTextEdit;
    dxlytmLayout1Item55: TdxLayoutItem;
    edt_Value: TcxTextEdit;
    dxlytmLayout1Item56: TdxLayoutItem;
    edt_IDCard: TcxTextEdit;
    dxlytmLayout1Item57: TdxLayoutItem;
    edt_Trucker: TcxTextEdit;
    dxLayout1Group4: TdxLayoutGroup;
    dxlytmLayout1Item58: TdxLayoutItem;
    edt_Memo: TcxTextEdit;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    Panel1: TPanel;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Item6: TdxLayoutItem;
    PrintHY: TcxCheckBox;
    dxLayout1Item7: TdxLayoutItem;
    cbb_BeltLine: TcxComboBox;
    procedure FormShow(Sender: TObject);
    procedure editWebOrderNoKeyPress(Sender: TObject; var Key: Char);
    procedure btnQueryClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    gInfo  : TCommonInfo;
    Fbegin : TDateTime;
    FWebOrderID    : string;
    FWebOrderIndex : Integer; //商城订单索引
    FWebOrderItems : array of stMallOrderItem; //商城订单数组
    FMType, FPrice : string;
  private
    procedure ClearFormData;
    function  IsRepeatCard(const nWebOrderItem: string): Boolean;
    function  GetStockInfo(const nZID,nMID: string): Boolean; //物料信息  价格、类型等
    procedure LoadFormData;
    function  DownloadOrder(const nCard: string): Boolean;
  public
    { Public declarations }
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormBillWx: TfFormBillWx;

implementation

{$R *.dfm}

uses
  ULibFun, DB, IniFiles, UMgrControl, UAdjustForm, UFormBase, UBusinessPacker,
  UDataModule, USysPopedom, USysDB, USysGrid, USysConst,
  UFormWait;

class function TfFormBillWx.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nBool : Boolean;
    nP: PFormCommandParam;
begin
  Result := nil;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;

  with TfFormBillWx.Create(Application) do
  try
    ClearFormData;
    //try load data

    ShowModal;
  finally
    Free;
  end;
end;

class function TfFormBillWx.FormID: integer;
begin
  Result := cFI_FormBillWXScan;
end;

//Desc: 清空数据
procedure TfFormBillWx.ClearFormData;
begin
  editWebOrderNo.Text:= '';

  edt_CID.Text:= '';     edt_CName.Text:= '';
  edt_MID.Text:= '';     edt_MName.Text:= '';
  edt_Truck.Text:= '';   edt_Value.Text:= '';
  edt_Trucker.Text:= ''; edt_IDCard.Text:= '';
  edt_Memo.Text:= '';
end;

function TfFormBillWx.IsRepeatCard(const nWebOrderItem: string): Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := 'Select * From %s Where WOM_WebOrderID=''%s''';
  nStr := Format(nStr,[sTable_WebOrderMatch, nWebOrderItem]);
  with FDM.QueryTemp(nStr) do
  begin
    Result := RecordCount>0;
  end;
end;

function TfFormBillWx.GetStockInfo(const nZID,nMID: string): Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := 'Select * From %s Where D_ZID=''%s'' And D_StockNo=''%s'' ';
  nStr := Format(nStr, [sTable_ZhiKaDtl, nZID,nMID]);
  with FDM.QueryTemp(nStr) do
  begin
    Result := RecordCount>0;
    if Result then
    begin
      First;

      FMType:= FieldByName('D_Type').AsString;       //类型
      FPrice:= FieldByName('D_Price').AsString;      //价格
    end;
  end;
end;

//Desc: 载入数据
procedure TfFormBillWx.LoadFormData;
var
  nOrderItem : stMallOrderItem;
  nRepeat, nIsSale : Boolean;
  nMsg,nStr, nWebOrderID:string;
begin
  nOrderItem := FWebOrderItems[FWebOrderIndex];
  nWebOrderID := nOrderItem.FOrdernumber;

  FBegin := Now;
  if IsRepeatCard(nWebOrderID) then
  begin
    ShowMessage('此订单已成功办卡，请勿重复操作');
    Exit;
  end;
                                                       
  if FWebOrderID<>nOrderItem.FOrdernumber then
  begin
    ShowMessage(Format('扫码单号：%s 与查询订单：%s 不符，订单异常，请重试',
                              [FWebOrderID,nOrderItem.FOrdernumber]));
    Exit;
  end;

  if not (Pos('销售',nOrderItem.FType) > 0) then
  begin
    ShowMessage('此订单不是销售订单！');
    Exit;
  end;

  if nOrderItem.FStatus <> '1' then
  begin
      if nOrderItem.FStatus = '0' then
        nMsg := '此订单状态未知'
      else if nOrderItem.FStatus = '6' then
        nMsg := '此订单已取消'
      else if nOrderItem.FStatus = '7' then
        nMsg := '此订单已过期'
      else  nMsg := '此订单已使用';
      
      ShowMsg(nMsg, sHint);
      Exit;
  end;

  //填充界面信息
  //基本信息
  ClearFormData;
  //提单信息
  editWebOrderNo.Text:= FWebOrderID;
  edt_CID.Text    := nOrderItem.FCusID;
  edt_CName.Text  := nOrderItem.FCusName;
  edt_MID.Text    := nOrderItem.FGoodsID;
  edt_MName.Text  := nOrderItem.FGoodsname;
  edt_Value.Text  := nOrderItem.FData;
  edt_Truck.Text  := nOrderItem.Ftracknumber;
  edt_Memo.Text   := nOrderItem.FXHSpot;

  GetStockInfo(nOrderItem.FYunTianOrderId, nOrderItem.FGoodsID);
  if FPrice='' then
  begin
    ShowMessage('获取纸卡 %s 信息失败、无法开单');
    Exit;
  end;
  btnOK.Enabled := True;  btnok.SetFocus;
end;

procedure TfFormBillWx.FormShow(Sender: TObject);
begin
  inherited;
  ActiveControl := editWebOrderNo;
  BtnOK.Enabled:= False;
end;

procedure TfFormBillWx.editWebOrderNoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=Char(vk_return) then
  begin
    key := #0;
    if btnQuery.CanFocus then
      btnQuery.SetFocus;
    btnQuery.Click;
  end;
end;

procedure TfFormBillWx.btnQueryClick(Sender: TObject);
var nStr : string;
begin
  btnQuery.Enabled := False;
  try
    FWebOrderID := Trim(editWebOrderNo.Text);
    if FWebOrderID='' then
    begin
      ShowMsg('请先输入或扫描订单号', sHint);
      Exit;
    end;

    if IsRepeatCard(FWebOrderID) then
    begin
      nStr := '订单 '+ FWebOrderID +' 已成功制单，请勿重复操作';
      ShowMsg(nStr,sHint);
      Exit;
    end;

    if not DownloadOrder(FWebOrderID) then Exit;
    LoadFormData;

  finally
    btnQuery.Enabled := True;
  end;
end;

function TfFormBillWx.DownloadOrder(const nCard: string): Boolean;
var
  nXmlStr,nData:string;
  nListA,nListB,nListC:TStringList;
  i:Integer;
  nWebOrderCount:Integer;
begin
  Result := False;
  FWebOrderIndex := 0;

  FBegin := Now;
  nData := Get_ShopOrderByNo(PackerEncodeStr(nCard));

//  nData:= 'ZGV0YWlscz1XVEo0Y0ZwWE5UQlViVVowV2xReWVUUnpjbFV3ZEVsT1EyMU9jMkZYVm5Wa1JUVjJVRlYwU1UxRVFUVk5aekJMV1RJNWRXUklTbWhaTTFKUFlub3hZ'+
//      'Vk42UlRWTlJHdDVUWHBCZDAxbk1FdGlWMFl3V2xoS2NGcFhlRTlaVnpGc1VGWkRhSEJGVFRCTmFUUXhkRkI2V0hOTmRYVjRUMEZPUTIweGFHUkhWbmxoVjFaelZHMDRP'+
//      'VTFxUVhoUFZFRjZUVlJWZDAxRVNVNURiVGw1V2tkV2VWSkhWakJaVjJ4elUxVlJPVTE2U1RWRVVYQjJZMjFTYkdOclVteGtSMFp3WWtaU05XTkhWVGxOVVRCTFkxaFdh'+
//      'R0p1VW5Ca1NHczVUbWN3UzJNelVtaGtTRlo2VUZSRlRrTm5QVDBOQ2c9PQ0KZHJpdmVySWQ9ODUNCmRydk5hbWU9us7s08u4DQpkcnZQaG9uZT0xNTIzNjM2OTg3NA0K'+
//      'ZmFjdG9yeU5hbWU9w8+16rmks6cNCmxpY2Vuc2VQbGF0ZT3JwkIzNjc1NQ0Kb3JkZXJJZD0zNDgNCm9yZGVyTm89MTkxMDEwMDE5Mg0Kc3RhdGU90MK2qbWlDQp0b3Rh'+
//      'bFF1YW50aXR5PTYNCnR5cGU9z/rK2w0Kb3JkZXJSZW1hcms9MTENCg0K';
  if nData='' then
  begin
    ShowMsg('未查询到网上商城订单详细信息，请检查订单号是否正确', sHint);
    Exit;
  end;

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  nListC := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(nData);

    nListB.Text := PackerDecodeStr(nListA.Values['details']);
    nWebOrderCount := nListB.Count;
    SetLength(FWebOrderItems, nWebOrderCount);
    for i := 0 to nWebOrderCount-1 do
    begin
        nListC.Text := PackerDecodeStr(nListB[i]);

        FWebOrderItems[i].FOrder_id     := nListA.Values['orderId'];
        FWebOrderItems[i].FOrdernumber  := nListA.Values['orderNo'];
        FWebOrderItems[i].Ftracknumber  := nListA.Values['licensePlate'];
        FWebOrderItems[i].FfactoryName  := nListA.Values['factoryName'];
        FWebOrderItems[i].FdriverId     := nListA.Values['driverId'];
        FWebOrderItems[i].FdrvName      := nListA.Values['drvName'];
        FWebOrderItems[i].FdrvPhone     := nListA.Values['FdrvPhone'];
        FWebOrderItems[i].FType         := nListA.Values['type'];
        FWebOrderItems[i].FXHSpot       := nListA.Values['orderRemark'];
        FWebOrderItems[i].FPrice        := '';
        with nListC do
        begin
          FWebOrderItems[i].FCusID          := Values['clientNo'];
          FWebOrderItems[i].FCusName        := Values['clientName'];
          FWebOrderItems[i].FGoodsID        := Values['materielNo'];
          FWebOrderItems[i].FGoodstype      := Values['orderDetailType'];
          FWebOrderItems[i].FGoodsname      := Values['materielName'];
          FWebOrderItems[i].FData           := Values['quantity'];
          FWebOrderItems[i].ForderDetailType:= Values['orderDetailType'];
          FWebOrderItems[i].FYunTianOrderId := Values['contractNo'];
          FWebOrderItems[i].FStatus         := Values['status'];
        end;
    end;

    Result:= true;
  finally
    nListC.Free;
    nListB.Free;
    nListA.Free;
  end;
end;

procedure TfFormBillWx.BtnOKClick(Sender: TObject);
var nList : TStrings;
    nBills, nStr : string;
    nRe   : Boolean;
begin
  try
    if FWebOrderID='' then
    begin
      ShowMsg('无效的提货码',sHint);
      Exit;
    end;

    if IsRepeatCard(FWebOrderID) then
    begin
      nStr := '订单 '+ FWebOrderID +' 已成功制单，请勿重复操作';
      ShowMsg(nStr,sHint);
      Exit;
    end;

    nList:= TStringList.Create;
    nList.Clear;

    with nList do
    begin
      Values['Type']      := FMType;
      Values['StockNO']   := edt_MID.Text;
      Values['StockName'] := edt_MName.Text;
      Values['Seal']      := '';                   ///封签号
      Values['Price']     := FPrice;
      Values['Value']     := edt_Value.Text;
      Values['PrintGLF']  := sFlag_No;

      if PrintHY.Checked  then
           Values['PrintHY'] := sFlag_Yes
      else Values['PrintHY'] := sFlag_No;

      Values['IsPlan'] := sFlag_No;

      nBills           := PackerEncodeStr(PackerEncodeStr(nList.Text));
      Clear;
      ///***************************
      Values['Bills']    := nBills;
      Values['ZhiKa']    := FWebOrderItems[0].FYunTianOrderId;
      Values['Truck']    := edt_Truck.Text;
      Values['Ident']    := edt_IDCard.Text;
      {$IFDEF MoreBeltLine}Values['BeltLine'] := cbb_BeltLine.Text;{$ENDIF}

      Values['Lading']   := 'T';
      Values['IsVIP']    := 'C';
      Values['BuDan']    := 'N';
      Values['Card']     := '';       //厂内零售业务
      Values['WebOrderID'] := FWebOrderID; 
    end;

    BtnOK.Enabled := False;
    try
      ShowWaitForm(Self, '正在保存', True);
      gInfo.FIDList := SaveBill(PackerEncodeStr(nList.Text));
    finally
      BtnOK.Enabled := True;
      CloseWaitForm;
    end;

    if gInfo.FIDList = '' then Exit;
    SaveWebOrderMatch(gInfo.FIDList, FWebOrderID, sFlag_Sale);
    if SetBillCard(gInfo.FIDList, edt_Truck.Text, True) then
    begin
      //办理磁卡
      nRe:= True;
    end;
  finally
    nList.free;
    if nRe then Close;
  end;
end;

procedure TfFormBillWx.FormCreate(Sender: TObject);
var nStr:string;
begin
  {$IFDEF MoreBeltLine}
  //不同生产线不同批次
  dxLayout1Item7.Visible := True;
  cbb_BeltLine.Text:= '';
  {$ELSE}
  dxLayout1Item7.Visible := False;
  {$ENDIF}
  {$IFDEF MoreBeltLine}
  if cbb_BeltLine.Properties.Items.Count < 1 then
  begin
    nStr := 'Select * From %s Where D_Name=''BeltLineItem''';
    nStr := Format(nStr, [sTable_SysDict]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;
      cbb_BeltLine.Properties.Items.Clear;
      while not Eof do
      begin
        cbb_BeltLine.Properties.Items.Add(FieldByName('D_Memo').AsString);
        Next;
      end;
    end;
  end;
  cbb_BeltLine.Text:= gSysParam.FDefaultBeltLine;
  {$ENDIF}

  
end;

procedure TfFormBillWx.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  gSysParam.FDefaultBeltLine:= cbb_BeltLine.Text;
end;

initialization
  gControlManager.RegCtrl(TfFormBillWx, TfFormBillWx.FormID);

end.
