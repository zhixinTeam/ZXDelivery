unit UShowOrderInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UAndroidFormBase, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, uTasks,
  UMITPacker,UClientWorker,UBusinessConst,USysBusiness,UMainFrom, FMX.ListBox,
  Androidapi.JNI.Toast;

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
    procedure tmrGetOrderTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Btn_RefuseClick(Sender: TObject);
  private
    { Private declarations }
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
    Toast('��ȡ�ſ���������ʧ��');
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
    nStr := '�ſ�[%s]����Ҫ��������';
    nStr := Format(nStr, [gCardNo]);

    Exit;
  end;

  if SavePurchaseOrders('O', gOrders) then
  begin
    {$IFDEF APPUseBluetoothPrint}
    PrintPurOrder(gOrders[0]);
    {$ENDIF}
    ShowMessage(gOrders[0].FTruck+' �����ɹ�');
    MainForm.Show;
  end
  else ShowMessage('����ʧ�ܡ�������');
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

  nStr:= '������ʡ̫��ʯ����ˮ�����޹�˾'+#13#10 +
         '���������� ԭ�����յ�'+#13#10 +
         '��������������������������������'+#13#10 +
         '�� Ӧ �̣�%s' +#13#10 +
         '������ţ�%s' +#13#10 +
         '�ɹ����ţ�%s' +#13#10 +
         '�������ƣ�%s' +#13#10 +
         '���ƺ��룺%s' +#13#10 +
         '����ë�أ�%.2f����'+#13#10 +
         '����Ƥ�أ�%.2f����'+#13#10 +
         '���տ��ӣ�%.2f����'+#13#10 +
         '�������أ�%.2f����'+#13#10#13#10 +
         '������ע��%s'+#13#10 +
         '����������%s'+#13#10#13#10 +
         '�������ڣ�%s'+#13#10#13#10 +
         '����:�ͻ���   ����:������   ����:ǩ����';
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
    nStr := '�ſ�[%s]����Ҫ���ճ���';
    nStr := Format(nStr, [gCardNo]);

    ShowMessage(nStr);
    Exit;
  end;

  if Length(gOrders)>0 then
  with gOrders[0] do
  begin
    nAutoOutFact:= FAutoDoP='Y';
    FKZValue := StrToFloatDef(EditKZValue.Text, 0);
    FYSValid := 'Y';     //�ջ�
    FMemo    := cbb_Reson.items[cbb_Reson.ItemIndex];           //���ӱ�ע
    FMemo2   := Trim(edtMMo2.Text);

    if (FKZValue>0)And(FMemo='') then
    begin
      Toast('���������Ӵ�����ѡ�����ԭ��');
      Exit;
    end;

    if (FKZValue=0)And(FMemo<>'') then
    begin
      Toast('���������Ӵ�������д��������');
      Exit;
    end;

    if SavePurchaseOrders('X', gOrders) then
    begin
      ShowMessage('���ճɹ�');

      if nAutoOutFact then MakePurOrderOutFact;
      MainForm.Show;
    end
    else ShowMessage('����ʧ�ܡ�������');
  end;
end;

procedure TFrmShowOrderInfo.Btn_RefuseClick(Sender: TObject);
VAR nAutoOutFact:Boolean;
begin
  if Length(gOrders)>0 then
  with gOrders[0] do
  begin
    nAutoOutFact:= FAutoDoP='Y';
    FMemo    := cbb_Reson.items[cbb_Reson.ItemIndex];           //���ӱ�ע
    FMemo2   := Trim(edtMMo2.Text);
    FYSValid:= 'N';     //����

    if (FMemo='') then
    begin
      Toast('��ѡ�����ԭ��');
      Exit;
    end;

    if SavePurchaseOrders('X', gOrders) then
    begin
      ShowMessage('�����ɹ����Ѿ���');
      if nAutoOutFact then MakePurOrderOutFact;
      MainForm.Show;
    end
    else ShowMessage('����ʧ�ܡ�������');
  end;
end;

procedure TFrmShowOrderInfo.LoadKJResons;
VAR nResons:string;
    nList: TStringList;
    nIdx:Integer;
begin
  GetKJReson(nResons);

  nList := TStringList.Create;
  nList.CommaText:= nResons;
  cbb_Reson.Items.Clear;

  for nIdx := 0 to nList.Count-1 do
  begin
    cbb_Reson.Items.Add( nList[nIdx] );
  end;
  cbb_Reson.ItemIndex:= 0;
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
  {if Key = vkHardwareBack then//������������ؼ�
  begin
    MessageDlg('ȷ���˳���', System.UITypes.TMsgDlgType.mtConfirmation,
      [System.UITypes.TMsgDlgBtn.mbOK, System.UITypes.TMsgDlgBtn.mbCancel], -1,

      procedure(const AResult: TModalResult)
      begin
        if AResult = mrOK then BtnCancelClick(Self);
      end
      );
      //�˳�����

    Key := 0;//����ģ���Ȼ����Ҳ���˳�
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
    nStr := '�ſ�[%s]����Ҫ���ճ���';
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
