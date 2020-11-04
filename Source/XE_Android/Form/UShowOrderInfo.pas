unit UShowOrderInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UAndroidFormBase, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, uTasks,
  UMITPacker,UClientWorker,UBusinessConst,USysBusiness,UMainFrom, FMX.ListBox,
  Androidapi.JNI.Toast, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TFrmShowOrderInfo = class(TfrmFormBase)
    Label6: TLabel;
    tmrGetOrder: TTimer;
    BtnCancel: TSpeedButton;
    BtnOK: TSpeedButton;
    EditKZValue: TEdit;
    Label10: TLabel;
    Label8: TLabel;
    lblTruck: TLabel;
    lblMate: TLabel;
    Label4: TLabel;
    lblProvider: TLabel;
    lblID: TLabel;
    Label1: TLabel;
    cbb_Reson: TComboBox;
    lbl1: TLabel;
    Btn_Refuse: TSpeedButton;
    edtMMo2: TEdit;
    lbl2: TLabel;
    tmr1: TTimer;
    procedure tmrGetOrderTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Btn_RefuseClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    { Private declarations }
    FSendOrderInfo:string;
    TCPClient : TIdTCPClient;
  private
    procedure LoadKJResons;
    procedure PrintPurOrder(nOrders: TLadingBillItem);
    procedure MakePurOrderOutFact;
  public
    { Public declarations }
  end;

var
  gCardNO: string;
  FrmShowOrderInfo: TFrmShowOrderInfo;

implementation
var
  gOrders: TLadingBillItems;

{$R *.fmx}

procedure TFrmShowOrderInfo.BtnCancelClick(Sender: TObject);
begin
  inherited;
  MainForm.Show;
  Self.Hide;
end;

procedure TFrmShowOrderInfo.MakePurOrderOutFact;
var xTask: TTaskType;
    nStr : string;
    nInt, nIdx : Integer;
begin
  SetLength(gOrders, 0);
  if not GetPurchaseOrders(gCardNO, 'O', gOrders) then
  begin
    Toast('获取磁卡关联订单失败');
    Exit;
  end;

  nInt := 0;
  for nIdx := Low(gOrders) to High(gOrders) do
  with gOrders[nIdx] do
  begin
    FSelected:= FNextStatus='O';
    if FSelected then Inc(nInt);
  end;

  if nInt<1 then
  begin
    nStr := '磁卡[%s]无需要出厂车辆';
    nStr := Format(nStr, [gCardNo]);

    Exit;
  end;

  if SavePurchaseOrders('O', gOrders) then
  begin
    {$IFDEF APPUseBluetoothPrint}
    PrintPurOrder(gOrders[0]);
    {$ENDIF}
    ShowMessage(gOrders[0].FTruck+' 出厂成功');
    MainForm.Show;
  end
  else ShowMessage('操作失败、请重试');
end;

procedure TFrmShowOrderInfo.PrintPurOrder(nOrders: TLadingBillItem);
var xTask: TTaskType;
    nStr : string;
    nVal : Double;
begin
  FillChar(xTask, SizeOf(TTaskType), #0);
  //*********
  nVal:= nOrders.FMData.FValue - nOrders.FPData.FValue - nOrders.FKZValue;
  if nOrders.FYSValid='N' then nVal:= 0 ;

  nStr:= '　河南省太阳石集团水泥有限公司'+#13#10 +
         '　　　　　 原料验收单'+#13#10 +
         '————————————————'+#13#10 +
         '供 应 商：%s' +#13#10 +
         '订单编号：%s' +#13#10 +
         '采购单号：%s' +#13#10 +
         '物料名称：%s' +#13#10 +
         '车牌号码：%s' +#13#10 +
         '车辆毛重：%.2f　吨'+#13#10 +
         '车辆皮重：%.2f　吨'+#13#10 +
         '验收扣杂：%.2f　吨'+#13#10 +
         '净　　重：%.2f　吨'+#13#10#13#10 +
         '备　　注：%s'+#13#10 +
         '　　　　　%s'+#13#10#13#10 +
         '验收日期：%s'+#13#10#13#10 +
         '白联:客户联   红联:运输联   黄联:签收联';
   nStr:= Format(nStr,[ nOrders.FCusName,nOrders.FZhiKa,nOrders.FID,
                        nOrders.FStockName,nOrders.FTruck,
                        nOrders.FMData.FValue,nOrders.FPData.FValue,
                        nOrders.FKZValue,nVal,nOrders.FMemo,
                        nOrders.FMemo2, FormatDateTime('yyyy-MM-dd hh:mm:ss', Now)  ]);

  xTask.ItemId  := '';
  xTask.nCardMM := nStr;
  //**************************************************
  if Assigned(gBlthThread) then
    gBlthThread.PriorityTaskManager.AddTask(xTask);
end;

procedure TFrmShowOrderInfo.BtnOKClick(Sender: TObject);
VAR nAutoOutFact:Boolean;
    nInt, nIdx:Integer;
    nStr : string;
begin
  inherited;

  if not GetPurchaseOrders(gCardNO, 'X', gOrders) then
  begin
    BtnCancelClick(Self);
    Exit;
  end;

  nInt := 0;
  for nIdx := Low(gOrders) to High(gOrders) do
  with gOrders[nIdx] do
  begin
    FSelected := (FNextStatus='X') or (FNextStatus='M');
    if FSelected then Inc(nInt);
  end;

  if nInt<1 then
  begin
    nStr := '磁卡[%s]无需要验收车辆';
    nStr := Format(nStr, [gCardNo]);

    ShowMessage(nStr);
    Exit;
  end;

  if Length(gOrders)>0 then
  with gOrders[0] do
  begin
    nAutoOutFact:= FAutoDoP='Y';
    FKZValue := StrToFloatDef(EditKZValue.Text, 0);
    FYSValid := 'Y';     //收货
    FMemo    := cbb_Reson.items[cbb_Reson.ItemIndex];           //扣杂备注
    FMemo2   := Trim(edtMMo2.Text);

    if (FKZValue>0)And(FMemo='') then
    begin
      Toast('您已做扣杂处理、需选择扣杂原因');
      Exit;
    end;

    if (FKZValue=0)And(FMemo<>'') then
    begin
      Toast('您已做扣杂处理、需填写扣杂数量');
      Exit;
    end;

    if SavePurchaseOrders('X', gOrders) then
    begin
      ShowMessage('验收成功');
      {$IFDEF YNHT_GL}
      FSendOrderInfo:= Format('%s,%s,%s', [FID, FTruck, FCusName]);
      tmr1.Enabled:= True;
      {$ENDIF}

      {$IFDEF HXTYS}
      if nAutoOutFact then MakePurOrderOutFact;
      {$ENDIF}
      MainForm.Show;
    end
    else ShowMessage('验收失败、请重试');
  end;
end;

procedure TFrmShowOrderInfo.Btn_RefuseClick(Sender: TObject);
VAR nAutoOutFact:Boolean;
begin
  if Length(gOrders)>0 then
  with gOrders[0] do
  begin
    nAutoOutFact:= FAutoDoP='Y';
    FMemo   := cbb_Reson.items[cbb_Reson.ItemIndex];           //扣杂备注
    FMemo2  := Trim(edtMMo2.Text);
    FYSValid:= 'N';     //拒收

    if (FMemo='') then
    begin
      Toast('需选择拒收原因');
      Exit;
    end;

    if SavePurchaseOrders('X', gOrders) then
    begin
      ShowMessage('操作成功、已拒收');
      if nAutoOutFact then MakePurOrderOutFact;
      MainForm.Show;
    end
    else ShowMessage('验收失败、请重试');
  end;
end;

procedure TFrmShowOrderInfo.LoadKJResons;
VAR nResons:string;
    nList: TStringList;
    nIdx:Integer;
begin
  {$IFDEF LoadKJReson}
  GetKJReson(nResons);
  {$ELSE}
  nResons:= ' , ,' + '杂质过多,水分过多';
  {$ENDIF}

  nList := TStringList.Create;
  nList.CommaText:= nResons;
  cbb_Reson.Items.Clear;

  for nIdx := 0 to nList.Count-1 do
  begin
    cbb_Reson.Items.Add( nList[nIdx] );
  end;
  cbb_Reson.ItemIndex:= -1;
end;

procedure TFrmShowOrderInfo.FormActivate(Sender: TObject);
begin
  inherited;
  lblID.Text       := '';
  lblProvider.Text := '';
  lblMate.Text     := '';
  lblTruck.Text    := '';
  EditKZValue.Text := '0.00';

  tmrGetOrder.Enabled := True;
  SetLength(gOrders, 0);

  LoadKJResons;
end;

procedure TFrmShowOrderInfo.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  {if Key = vkHardwareBack then//如果按下物理返回键
  begin
    MessageDlg('确认退出吗？', System.UITypes.TMsgDlgType.mtConfirmation,
      [System.UITypes.TMsgDlgBtn.mbOK, System.UITypes.TMsgDlgBtn.mbCancel], -1,

      procedure(const AResult: TModalResult)
      begin
        if AResult = mrOK then BtnCancelClick(Self);
      end
      );
      //退出程序

    Key := 0;//必须的，不然按否也会退出
    Exit;
  end;    }
end;

procedure TFrmShowOrderInfo.FormShow(Sender: TObject);
begin
  inherited;
  lblID.Text       := '';
  lblProvider.Text := '';
  lblMate.Text     := '';
  lblTruck.Text    := '';
  EditKZValue.Text := '0.00';

  BtnOK.Enabled := False;
  Btn_Refuse.Enabled := False;
  tmrGetOrder.Enabled := True;
  SetLength(gOrders, 0);
end;

procedure TFrmShowOrderInfo.tmr1Timer(Sender: TObject);
var SStream: TStringStream;
begin
  if FSendOrderInfo='' then Exit;

  if Not Assigned(TCPClient) then
    TCPClient:= TIdTCPClient.Create(nil);

  TCPClient.Host:= '192.168.11.247';
  TCPClient.Port:= 52386;
  try
    try
      if not TCPClient.Connected then
        TCPClient.Connect;

      FSendOrderInfo:= Trim(FSendOrderInfo);
      FSendOrderInfo:= Char($3D) + FSendOrderInfo + Char($3B);

      SStream := TStringStream.Create(FSendOrderInfo, TEncoding.ANSI);    //  TEncoding.UTF8  TEncoding.Default  ASCII
      //LogHex(nData);

      TCPClient.Socket.Write( SStream, SStream.Size );
      Toast('已将相关信息上传分析仪服务端');
    except
      on Ex: Exception do
      begin
        Toast('上传数据到分析仪错误!:'+Ex.Message);
      end;
    end;
  finally
    TCPClient.Disconnect;
    FSendOrderInfo:= '';
    Sleep(200);
  end;
end;

procedure TFrmShowOrderInfo.tmrGetOrderTimer(Sender: TObject);
var nIdx, nInt: Integer;
    nStr : string;
begin
  tmrGetOrder.Enabled := False;

  if not GetPurchaseOrders(gCardNO, 'X', gOrders) then
  begin
    BtnCancelClick(Self);
    Exit;
  end;

  nInt := 0;
  for nIdx := Low(gOrders) to High(gOrders) do
  with gOrders[nIdx] do
  begin
    FSelected := (FNextStatus='X') or (FNextStatus='M');
    if FSelected then Inc(nInt);
  end;

  if nInt<1 then
  begin
    nStr := '磁卡[%s]无需要验收车辆';
    nStr := Format(nStr, [gCardNo]);

    ShowMessage(nStr);
    Exit;
  end;

  with gOrders[0] do
  begin
    lblID.Text       := FID;
    lblProvider.Text := FCusName;
    lblMate.Text     := FStockName;
    lblTruck.Text    := FTruck;

    EditKZValue.Text := FloatToStr(FKZValue);
  end;

  BtnOK.Enabled      := True;
  Btn_Refuse.Enabled := True;
end;

end.
