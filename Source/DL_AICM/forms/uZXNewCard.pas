{*******************************************************************************
  ����: juner11212436@163.com 2017-12-28
  ����: �����쿨����--������
*******************************************************************************}
unit uZXNewCard;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, Menus, StdCtrls, cxButtons, cxGroupBox,
  cxRadioGroup, cxTextEdit, cxCheckBox, ExtCtrls, dxLayoutcxEditAdapters,
  dxLayoutControl, cxDropDownEdit, cxMaskEdit, cxButtonEdit,
  USysConst, cxListBox, ComCtrls,Contnrs,UFormCtrl, UMgrSDTReader;

type

  TfFormNewCard = class(TForm)
    editWebOrderNo: TcxTextEdit;
    labelIdCard: TcxLabel;
    btnQuery: TcxButton;
    PanelTop: TPanel;
    PanelBody: TPanel;
    dxLayout1: TdxLayoutControl;
    BtnOK: TButton;
    BtnExit: TButton;
    EditValue: TcxTextEdit;
    EditCus: TcxTextEdit;
    EditCName: TcxTextEdit;
    EditStock: TcxTextEdit;
    EditSName: TcxTextEdit;
    EditTruck: TcxButtonEdit;
    EditType: TcxComboBox;
    EditPrice: TcxButtonEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxlytmLayout1Item3: TdxLayoutItem;
    dxlytmLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxlytmLayout1Item9: TdxLayoutItem;
    dxlytmLayout1Item10: TdxLayoutItem;
    dxGroupLayout1Group5: TdxLayoutGroup;
    dxlytmLayout1Item13: TdxLayoutItem;
    dxLayout1Item11: TdxLayoutItem;
    dxGroupLayout1Group6: TdxLayoutGroup;
    dxlytmLayout1Item12: TdxLayoutItem;
    dxLayout1Item8: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    pnlMiddle: TPanel;
    cxLabel1: TcxLabel;
    lvOrders: TListView;
    Label1: TLabel;
    btnClear: TcxButton;
    TimerAutoClose: TTimer;
    dxLayout1Group2: TdxLayoutGroup;
    PrintHY: TcxCheckBox;
    EditMemo: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    dxLayout1Item31: TdxLayoutItem;
    EditSJPinYin: TcxTextEdit;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Item32: TdxLayoutItem;
    EditSJName: TcxTextEdit;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item33: TdxLayoutItem;
    EditIdent: TcxTextEdit;
    dxLayout1Group6: TdxLayoutGroup;
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure lvOrdersClick(Sender: TObject);
    procedure editWebOrderNoKeyPress(Sender: TObject; var Key: Char);
    procedure btnClearClick(Sender: TObject);
    procedure EditSJPinYinKeyPress(Sender: TObject; var Key: Char);
    procedure EditIdentKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FAutoClose:Integer; //�����Զ��رյ���ʱ�����ӣ�
    FWebOrderIndex:Integer; //�̳Ƕ�������
    FWebOrderItems:array of stMallOrderItem; //�̳Ƕ�������
    FCardData:TStrings; //����ϵͳ���صĴ�Ʊ����Ϣ
    Fbegin:TDateTime;
    FListA : TStrings;
    procedure InitListView;
    procedure SetControlsReadOnly;
    function DownloadOrder(const nCard:string):Boolean;
    procedure Writelog(nMsg:string);
    procedure AddListViewItem(var nWebOrderItem:stMallOrderItem);
    procedure LoadSingleOrder;
    function IsRepeatCard(const nWebOrderItem:string):Boolean;
    function VerifyCtrl(Sender: TObject; var nHint: string): Boolean;
    function SaveBillProxy:Boolean;
    function SaveBillProxyPD: Boolean;
    function SaveWebOrderMatch(const nBillID,nWebOrderID,nBillType:string):Boolean;
    function CheckYYOrderState(const nWebOrderID:string; var nHint: string):Boolean;
    procedure GetSJInfo;
    //��ȡ˾����Ϣ
    procedure GetSJInfoEx;
    //��ȡ˾����Ϣ
    procedure GetSJName;
    //��ȡ˾������
    procedure SyncCard(const nCard: TIdCardInfoStr;const nReader: TSDTReaderItem);
  public
    { Public declarations }
    procedure SetControlsClear;
  end;

var
  fFormNewCard: TfFormNewCard;

implementation
uses
  ULibFun,UBusinessPacker,USysLoger,UBusinessConst,UFormMain,USysBusiness,USysDB,
  UAdjustForm,UFormBase,UDataReport,UDataModule,NativeXml,UMgrTTCEDispenser,UFormWait,
  DateUtils;
{$R *.dfm}

{ TfFormNewCard }

procedure TfFormNewCard.SetControlsClear;
var
  i:Integer;
  nComp:TComponent;
begin
  editWebOrderNo.Clear;
  for i := 0 to dxLayout1.ComponentCount-1 do
  begin
    nComp := dxLayout1.Components[i];
    if nComp is TcxTextEdit then
    begin
      TcxTextEdit(nComp).Clear;
    end;
  end;
end;
procedure TfFormNewCard.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormNewCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FListA.Free;
  FCardData.Free;
  Action:=  caFree;
  fFormNewCard := nil;
  gSDTReaderManager.OnSDTEvent := nil;  
end;

procedure TfFormNewCard.FormShow(Sender: TObject);
begin
  SetControlsReadOnly;
  dxlytmLayout1Item13.Visible := False;
  EditTruck.Properties.Buttons[0].Visible := False;
  ActiveControl := editWebOrderNo;
  btnOK.Enabled := False;
  FAutoClose := gSysParam.FAutoClose_Mintue;
  TimerAutoClose.Interval := 60*1000;
  TimerAutoClose.Enabled := True;
  EditPrice.Properties.Buttons[0].Visible := False;
  dxLayout1Item11.Visible := False;
  {$IFDEF PrintHYEach}
  PrintHY.Checked := True;
  PrintHY.Enabled := False;
  {$ELSE}
  PrintHY.Checked := False;
  PrintHY.Enabled := True;
  {$ENDIF}

  {$IFDEF IdentCard}
  dxLayout1Item31.Visible := True;
  EditIdent.Text := '';
  dxLayout1Item32.Visible := True;
  EditSJPinYin.Text := '';
  dxLayout1Item33.Visible := True;
  EditSJName.Text := '';
  {$ELSE}
  dxLayout1Item31.Visible := False;
  EditIdent.Text := '';
  dxLayout1Item32.Visible := False;
  EditSJPinYin.Text := '';
  dxLayout1Item33.Visible := False;
  EditSJName.Text := '';
  {$ENDIF}
end;

procedure TfFormNewCard.SetControlsReadOnly;
var
  i:Integer;
  nComp:TComponent;
begin
  for i := 0 to dxLayout1.ComponentCount-1 do
  begin
    nComp := dxLayout1.Components[i];
    if nComp is TcxTextEdit then
    begin
      TcxTextEdit(nComp).Properties.ReadOnly := True;
    end;
  end;
  EditPrice.Properties.ReadOnly := True;
end;

procedure TfFormNewCard.TimerAutoCloseTimer(Sender: TObject);
begin
  if FAutoClose=0 then
  begin
    TimerAutoClose.Enabled := False;
    Close;
  end;
  Dec(FAutoClose);
end;

procedure TfFormNewCard.btnQueryClick(Sender: TObject);
var
  nCardNo,nStr:string;
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  btnQuery.Enabled := False;
  editWebOrderNo.SelectAll;
  try
    nCardNo := Trim(editWebOrderNo.Text);
    if nCardNo='' then
    begin
      nStr := '���������ɨ�趩����';
      ShowMsg(nStr,sHint);
      Writelog(nStr);
      Exit;
    end;
    lvOrders.Items.Clear;

    if IsRepeatCard(editWebOrderNo.Text) then
    begin
      nStr := '����'+editWebOrderNo.Text+'�ѳɹ��Ƶ��������ظ�����';
      ShowMsg(nStr,sHint);
      Writelog(nStr);
      Exit;
    end;

    if not DownloadOrder(nCardNo) then Exit;
    btnOK.Enabled := True;
  finally
    btnQuery.Enabled := True;
  end;
end;

function TfFormNewCard.DownloadOrder(const nCard: string): Boolean;
var
  nXmlStr,nData:string;
  nListA,nListB,nListC:TStringList;
  i:Integer;
  nWebOrderCount:Integer;
begin
  Result := False;
  FWebOrderIndex := 0;

  nXmlStr := PackerEncodeStr(nCard);

  FBegin := Now;
  nData := get_shoporderbyno(nXmlStr);
  if nData='' then
  begin
    ShowMsg('δ��ѯ�������̳Ƕ�����ϸ��Ϣ�����鶩�����Ƿ���ȷ',sHint);
    Writelog('δ��ѯ�������̳Ƕ�����ϸ��Ϣ�����鶩�����Ƿ���ȷ');
    Exit;
  end;
  Writelog('TfFormNewCard.DownloadOrder(nCard='''+nCard+''') ��ѯ�̳Ƕ���-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  //�������Ƕ�����Ϣ
  Writelog('get_shoporderbyno res:'+nData);

  {$IFDEF UseWXServiceEx}
    nListA := TStringList.Create;
    nListB := TStringList.Create;
    nListC := TStringList.Create;
    try
      nListA.Text := PackerDecodeStr(nData);

      nListB.Text := PackerDecodeStr(nListA.Values['details']);
      nWebOrderCount := nListB.Count;
      SetLength(FWebOrderItems,nWebOrderCount);
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
          AddListViewItem(FWebOrderItems[i]);
        end;
      end;
    finally
      nListC.Free;
      nListB.Free;
      nListA.Free;
    end;
  {$ELSE}
    nListA := TStringList.Create;
    nListB := TStringList.Create;
    try
      nListA.Text := nData;

      nWebOrderCount := nListA.Count;
      SetLength(FWebOrderItems,nWebOrderCount);
      for i := 0 to nWebOrderCount-1 do
      begin
        nListB.Text := PackerDecodeStr(nListA.Strings[i]);
        FWebOrderItems[i].FOrder_id := nListB.Values['order_id'];
        FWebOrderItems[i].FOrdernumber := nListB.Values['ordernumber'];
        FWebOrderItems[i].FGoodsID := nListB.Values['goodsID'];
        FWebOrderItems[i].FGoodstype := nListB.Values['goodstype'];
        FWebOrderItems[i].FGoodsname := nListB.Values['goodsname'];
        FWebOrderItems[i].FData := nListB.Values['data'];
        FWebOrderItems[i].Ftracknumber := nListB.Values['tracknumber'];
        FWebOrderItems[i].FYunTianOrderId := nListB.Values['fac_order_no'];
        AddListViewItem(FWebOrderItems[i]);
      end;
    finally
      nListB.Free;
      nListA.Free;
    end;
  {$ENDIF}
  LoadSingleOrder;
end;

procedure TfFormNewCard.Writelog(nMsg: string);
var
  nStr:string;
begin
  nStr := 'weborder[%s]clientid[%s]clientname[%s]sotckno[%s]stockname[%s]';
  nStr := Format(nStr,[editWebOrderNo.Text,EditCus.Text,EditCName.Text,EditStock.Text,EditSName.Text]);
  gSysLoger.AddLog(nStr+nMsg);
end;

procedure TfFormNewCard.AddListViewItem(
  var nWebOrderItem: stMallOrderItem);
var
  nListItem:TListItem;
begin
  nListItem := lvOrders.Items.Add;
  nlistitem.Caption := nWebOrderItem.FOrdernumber;

  nlistitem.SubItems.Add(nWebOrderItem.FGoodsID);
  nlistitem.SubItems.Add(nWebOrderItem.FGoodsname);
  nlistitem.SubItems.Add(nWebOrderItem.Ftracknumber);
  nlistitem.SubItems.Add(nWebOrderItem.FData);
  nlistitem.SubItems.Add(nWebOrderItem.FYunTianOrderId);
end;

procedure TfFormNewCard.InitListView;
var
  col:TListColumn;
begin
  lvOrders.ViewStyle := vsReport;
  col := lvOrders.Columns.Add;
  col.Caption := '���϶������';
  col.Width := 300;
  col := lvOrders.Columns.Add;
  col.Caption := 'ˮ���ͺ�';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := 'ˮ������';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := '�������';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := '�������';
  col.Width := 150;
  col := lvOrders.Columns.Add;
  col.Caption := '�������';
  col.Width := 250;
end;

procedure TfFormNewCard.FormCreate(Sender: TObject);
begin
  editWebOrderNo.Properties.MaxLength := gSysParam.FWebOrderLength;
  FCardData := TStringList.Create;
  if not Assigned(FDR) then
  begin
    FDR := TFDR.Create(Application);
  end;
  InitListView;
  gSysParam.FUserID := 'AICM';
  FListA := TStringList.Create;  
  gSDTReaderManager.OnSDTEvent := SyncCard;
end;

procedure TfFormNewCard.LoadSingleOrder;
var
  nOrderItem:stMallOrderItem;
  nRepeat, nIsSale : Boolean;
  nWebOrderID:string;
  nMsg,nStr:string;
begin
  nOrderItem := FWebOrderItems[FWebOrderIndex];
  nWebOrderID := nOrderItem.FOrdernumber;

  FBegin := Now;
  nRepeat := IsRepeatCard(nWebOrderID);

  if nRepeat then
  begin
    nMsg := '�˶����ѳɹ��쿨�������ظ�����';
    ShowMsg(nMsg,sHint);
    Writelog(nMsg);
    Exit;
  end;
  writelog('TfFormNewCard.LoadSingleOrder ����̳Ƕ����Ƿ��ظ�ʹ��-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');

  {$IFDEF UseWXServiceEx}
    if Pos('����',nOrderItem.FType) > 0 then
      nIsSale := True
    else
      nIsSale := False;

    if not nIsSale then
    begin
      nMsg := '�˶����������۶�����';
      ShowMsg(nMsg,sHint);
      Writelog(nMsg);
      Exit;
    end;

    if nOrderItem.FStatus <> '1' then
    begin
      if nOrderItem.FStatus = '0' then
        nMsg := '�˶���״̬δ֪'
      else if nOrderItem.FStatus = '6' then
        nMsg := '�˶�����ȡ��'
      else if nOrderItem.FStatus = '7' then
        nMsg := '�˶����ѹ���'
      else
        nMsg := '�˶�����ʹ��';
      ShowMsg(nMsg,sHint);
      Writelog(nMsg+nOrderItem.FStatus);
      Exit;
    end;

    //��������Ϣ
    //������Ϣ
    EditCus.Text    := '';
    EditCName.Text  := '';

    nStr := 'select Z_Customer,D_Price from %s a join %s b on a.Z_ID = b.D_ZID ' +
            'where Z_ID=''%s'' and D_StockNo=''%s'' ';

    nStr := Format(nStr,[sTable_ZhiKa,sTable_ZhiKaDtl,nOrderItem.FYunTianOrderId,nOrderItem.FGoodsID]);
    with fdm.QueryTemp(nStr) do
    begin
      if RecordCount = 1 then
      begin
        EditPrice.Text  := Fields[1].AsString;
      end;
    end;

    //�ᵥ��Ϣ
    EditType.ItemIndex := 0;
    EditStock.Text  := nOrderItem.FGoodsID;
    EditSName.Text  := nOrderItem.FGoodsname;
    EditValue.Text  := nOrderItem.FData;
    EditTruck.Text  := nOrderItem.Ftracknumber;
    {$IFDEF IdentCard}
    GetSJInfoEx;
    {$ENDIF}
    EditCus.Text    := nOrderItem.FCusID;
    EditCName.Text  := nOrderItem.FCusName;
    EditMemo.Text   := nOrderItem.FXHSpot;
  {$ELSE}
    //��������Ϣ
    //������Ϣ
    EditCus.Text    := '';
    EditCName.Text  := '';

    nStr := 'select Z_Customer,D_Price from %s a join %s b on a.Z_ID = b.D_ZID ' +
            'where Z_ID=''%s'' and D_StockNo=''%s'' ';

    nStr := Format(nStr,[sTable_ZhiKa,sTable_ZhiKaDtl,nOrderItem.FYunTianOrderId,nOrderItem.FGoodsID]);
    with fdm.QueryTemp(nStr) do
    begin
      if RecordCount = 1 then
      begin
        EditCus.Text    := Fields[0].AsString;
        EditPrice.Text  := Fields[1].AsString;
      end;
    end;

    nStr := 'Select C_Name From %s Where C_ID=''%s'' ';
    nStr := Format(nStr, [sTable_Customer, EditCus.Text]);
    with fdm.QueryTemp(nStr) do
    begin
      if RecordCount>0 then
      begin
        EditCName.Text  := Fields[0].AsString;
      end;
    end;

    //�ᵥ��Ϣ
    EditType.ItemIndex := 0;
    EditStock.Text  := nOrderItem.FGoodsID;
    EditSName.Text  := nOrderItem.FGoodsname;
    EditValue.Text := nOrderItem.FData;
    EditTruck.Text := nOrderItem.Ftracknumber;
  {$ENDIF}

  BtnOK.Enabled := not nRepeat;
end;

function TfFormNewCard.IsRepeatCard(const nWebOrderItem: string): Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := 'select * from %s where WOM_WebOrderID=''%s''';
  nStr := Format(nStr,[sTable_WebOrderMatch,nWebOrderItem]);
  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount>0 then
    begin
      Result := True;
    end;
  end;
end;

function TfFormNewCard.VerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    if not Result then
    begin
      nHint := '���ƺų���Ӧ����2λ';
      Writelog(nHint);
      Exit;
    end;
  end;
  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    if not Result then
    begin
      nHint := '����д��Ч�İ�����';
      Writelog(nHint);
      Exit;
    end;
  end;
end;

procedure TfFormNewCard.BtnOKClick(Sender: TObject);
var nIdx, nInt: Integer;
begin
  BtnOK.Enabled := False;
  try
    {$IFDEF UseWXServiceEx}
    nInt := 0;
    for nidx := Low(FWebOrderItems) to High(FWebOrderItems) do
    with FWebOrderItems[nidx] do
    begin
      if ForderDetailType = '3' then//ƴ��
        Inc(nInt);
    end;

    if nInt > 1 then
    begin
      if not SaveBillProxyPD then
      begin
        BtnOK.Enabled := True;
        Exit;
      end;
    end
    else
    begin
      if not SaveBillProxy then
      begin
        BtnOK.Enabled := True;
        Exit;
      end;
    end;
    {$ELSE}
    if not SaveBillProxy then
    begin
      BtnOK.Enabled := True;
      Exit;
    end;
    {$ENDIF}
    Close;
  except
  end;
end;

function TfFormNewCard.SaveBillProxy: Boolean;
var
  nHint,nMsg:string;
  nList,nTmp,nStocks: TStrings;
  nPrint,nInFact:Boolean;
  nBillData:string;
  nBillID :string;
  nWebOrderID:string;
  nNewCardNo:string;
  nidx:Integer;
  i:Integer;
  nRet: Boolean;
  nOrderItem:stMallOrderItem;
  nCard:string;
begin
  Result := False;
  nOrderItem  := FWebOrderItems[FWebOrderIndex];
  nWebOrderID := editWebOrderNo.Text;

  if Trim(EditValue.Text) = '' then
  begin
    ShowMsg('��ȡ���ϼ۸��쳣������ϵ����Ա',sHint);
    Writelog('��ȡ���ϼ۸��쳣������ϵ����Ա');
    Exit;
  end;

  if not VerifyCtrl(EditTruck,nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;

  {$IFDEF UseTruckXTNum}
    if not IsEnoughNum(EditTruck.Text, StrToFloatDef(EditValue.Text,0)) then
    begin
      ShowMsg('�������������ᵥ�����������ϵ����Ա', sHint);
      Exit;
    end;
  {$ENDIF}

  {$IFDEF ForceEleCard}
  {$IFDEF XXCJ}
  if not IsEleCardVaidEx(EditTruck.Text) then
  {$ELSE}
  if not IsEleCardVaid(EditTruck.Text) then
  {$ENDIF}
  begin
    ShowMsg('����δ������ӱ�ǩ����ӱ�ǩδ���ã�����ϵ����Ա', sHint); Exit;
  end;
  {$ENDIF}

  if not VerifyCtrl(EditValue,nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;

  {$IFDEF UseWebYYOrder}
  if not CheckYYOrderState(nWebOrderID, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;
  {$ENDIF}

  for nIdx:=0 to 3 do
  begin
    nCard := gDispenserManager.GetCardNo(gSysParam.FTTCEK720ID, nHint, False);
    if nCard <> '' then
      Break;
    Sleep(500);
  end;
  //�������ζ���,�ɹ����˳���
 // nCard := '123456';

  if nCard = '' then
  begin
    nMsg := '�����쳣,��鿴�Ƿ��п�.';
    ShowMsg(nMsg, sWarn);
    Exit;
  end;

  WriteLog('��ȡ����Ƭ: ' + nCard);
  //������Ƭ
  if not IsCardValid(nCard) then
  begin
    gDispenserManager.RecoveryCard(gSysParam.FTTCEK720ID, nHint);
    nMsg := '����' + nCard + '�Ƿ�,������,���Ժ�����ȡ��';
    WriteLog(nMsg);
    ShowMsg(nMsg, sWarn);
    Exit;
  end;
  
  if IFHasBill(EditTruck.Text) then
  begin
    ShowMsg('��������δ��ɵ������,�޷�����,����ϵ����Ա',sHint);
    Exit;
  end;

  //���������
  nStocks := TStringList.Create;
  nList := TStringList.Create;
  nTmp := TStringList.Create;
  try
    LoadSysDictItem(sFlag_PrintBill, nStocks);
    if Pos('ɢ',EditSName.Text) > 0 then
      nTmp.Values['Type'] := 'S'
    else
      nTmp.Values['Type'] := 'D';
    nTmp.Values['StockNO'] := EditStock.Text;
    nTmp.Values['StockName'] := EditSName.Text;
    nTmp.Values['Price'] := EditPrice.Text;
    nTmp.Values['Value'] := EditValue.Text;

    if PrintHY.Checked  then
         nTmp.Values['PrintHY'] := sFlag_Yes
    else nTmp.Values['PrintHY'] := sFlag_No;

    nList.Add(PackerEncodeStr(nTmp.Text));
    nPrint := nStocks.IndexOf(EditStock.Text) >= 0;

    with nList do
    begin
      Values['Bills'] := PackerEncodeStr(nList.Text);
      Values['ZhiKa'] := nOrderItem.FYunTianOrderId;
      Values['Truck'] := EditTruck.Text;
      Values['Lading'] := sFlag_TiHuo;
      Values['Memo']  := EmptyStr;
      Values['IsVIP'] := Copy(GetCtrlData(EditType),1,1);
      Values['Seal'] := '';
      Values['HYDan'] := '';
      Values['WebOrderID'] := nWebOrderID;
      {$IFDEF UseXHSpot}
      Values['L_XHSpot'] := EditMemo.Text;
      {$ENDIF}
      {$IFDEF IdentCard}
      Values['Ident'] := EditIdent.Text;
      Values['SJName']:= EditSJName.Text;
      {$ENDIF}
    end;
    nBillData := PackerEncodeStr(nList.Text);
    FBegin := Now;
    nBillID := SaveBill(nBillData);
    if nBillID = '' then
    begin
      nHint := '���������ʧ��';
      ShowMsg(nHint,sError);
      Writelog(nHint);
      Exit;
    end;
    writelog('TfFormNewCard.SaveBillProxy ���������['+nBillID+']-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
    FBegin := Now;
    SaveWebOrderMatch(nBillID,nWebOrderID,sFlag_Sale);
    writelog('TfFormNewCard.SaveBillProxy �����̳Ƕ�����-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  finally
    nStocks.Free;
    nList.Free;
    nTmp.Free;
  end;

  nRet := SaveBillCard(nBillID, nCard);

  if not nRet then
  begin
    nMsg := '����ſ�ʧ��,������.';
    ShowMsg(nMsg, sHint);
    Exit;
  end;

  nRet := gDispenserManager.SendCardOut(gSysParam.FTTCEK720ID, nHint);
  //����

  if nRet then
  begin
    nMsg := '�����[ %s ]�����ɹ�,����[ %s ],���պ����Ŀ�Ƭ';
    nMsg := Format(nMsg, [nBillID, nCard]);

    WriteLog(nMsg);
    ShowMsg(nMsg,sWarn);
  end
  else begin
    gDispenserManager.RecoveryCard(gSysParam.FTTCEK720ID, nHint);

    nMsg := '����[ %s ]��������ʧ��,�뵽��Ʊ�������¹���.';
    nMsg := Format(nMsg, [nCard]);

    WriteLog(nMsg);
    ShowMsg(nMsg,sWarn);
  end;
  Result := True;
  if nPrint then
    PrintBillReport(nBillID, True);
 //print report
end;

function TfFormNewCard.SaveBillProxyPD: Boolean;
var
  nHint,nMsg,nStr:string;
  nList,nTmp,nStocks: TStrings;
  nPrint,nInFact,nFixMoney:Boolean;
  nBillData:string;
  nBillID :string;
  nWebOrderID:string;
  nNewCardNo:string;
  nidx:Integer;
  i:Integer;
  nRet: Boolean;
  nOrderItem:stMallOrderItem;
  nCard:string;
  nZKMoney : Double;
begin
  Result := False;
  nOrderItem := FWebOrderItems[FWebOrderIndex];
  nWebOrderID := editWebOrderNo.Text;

  if Trim(EditPrice.Text) = '' then
  begin
    ShowMsg('��ȡ���ϼ۸��쳣������ϵ����Ա',sHint);
    Writelog('��ȡ���ϼ۸��쳣������ϵ����Ա');
    Exit;
  end;

  if not VerifyCtrl(EditTruck,nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;

  {$IFDEF ForceEleCard}
  {$IFDEF XXCJ}
  if not IsEleCardVaidEx(EditTruck.Text) then
  {$ELSE}
  if not IsEleCardVaid(EditTruck.Text) then
  {$ENDIF}
  begin
    ShowMsg('����δ������ӱ�ǩ����ӱ�ǩδ���ã�����ϵ����Ա', sHint); Exit;
  end;
  {$ENDIF}

  if not VerifyCtrl(EditValue,nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;

  for nIdx:=0 to 3 do
  begin
    nCard := gDispenserManager.GetCardNo(gSysParam.FTTCEK720ID, nHint, False);
    if nCard <> '' then
      Break;
    Sleep(500);
  end;
  //�������ζ���,�ɹ����˳���

  if nCard = '' then
  begin
    nMsg := '�����쳣,��鿴�Ƿ��п�.';
    ShowMsg(nMsg, sWarn);
    Exit;
  end;

  WriteLog('��ȡ����Ƭ: ' + nCard);
  //������Ƭ
  if not IsCardValid(nCard) then
  begin
    gDispenserManager.RecoveryCard(gSysParam.FTTCEK720ID, nHint);
    nMsg := '����' + nCard + '�Ƿ�,������,���Ժ�����ȡ��';
    WriteLog(nMsg);
    ShowMsg(nMsg, sWarn);
    Exit;
  end;

  if IFHasBill(EditTruck.Text) then
  begin
    ShowMsg('��������δ��ɵ������,�޷�����,����ϵ����Ա',sHint);
    Exit;
  end;

  for nidx := Low(FWebOrderItems) to High(FWebOrderItems) do
  with FWebOrderItems[nidx] do
  begin
    if ForderDetailType <> '3' then//����ƴ��
    begin
      ShowMsg('���뵥����ƴ������,�޷�����,����ϵ����Ա',sHint);
      Exit;
    end;
    nStr := 'select Z_Customer,D_Price from %s a join %s b on a.Z_ID = b.D_ZID ' +
            'where Z_ID=''%s'' and D_StockNo=''%s'' ';

    nStr := Format(nStr,[sTable_ZhiKa,sTable_ZhiKaDtl,FYunTianOrderId,FGoodsID]);
    with fdm.QueryTemp(nStr) do
    begin
      if RecordCount = 1 then
      begin
        FPrice  := Fields[1].AsString;
      end;
    end;

    if not IsNumber(FPrice, True) then
    begin
      ShowMsg('����' + FYunTianOrderId +'�۸��쳣,����ϵ����Ա',sHint);
      Exit;
    end;
    nZKMoney := GetZhikaValidMoney(FYunTianOrderId, nFixMoney);

    nMsg := '����' + FYunTianOrderId +'������' + FData + ',����' + FPrice +
              ',��ǰ���ý��' + FloatToStr(nZKMoney);
    Writelog(nMsg);
    if (StrToFloat(FPrice) * StrToFloat(FData)) > nZKMoney then
    begin
      ShowMsg( nMsg + ',����,�޷�����',sHint);
      Exit;
    end;
  end;

  FListA.Clear;
  for nidx := Low(FWebOrderItems) to High(FWebOrderItems) do
  with FWebOrderItems[nidx] do
  begin
    //���������
    nStocks := TStringList.Create;
    nList := TStringList.Create;
    nTmp := TStringList.Create;
    try
      LoadSysDictItem(sFlag_PrintBill, nStocks);
      if Pos('ɢ',FGoodsname) > 0 then
        nTmp.Values['Type'] := 'S'
      else
        nTmp.Values['Type'] := 'D';
      nTmp.Values['StockNO'] := FGoodsID;
      nTmp.Values['StockName'] := FGoodsname;
      nTmp.Values['Price'] := FPrice;
      nTmp.Values['Value'] := FData;

      if PrintHY.Checked  then
           nTmp.Values['PrintHY'] := sFlag_Yes
      else nTmp.Values['PrintHY'] := sFlag_No;

      nList.Add(PackerEncodeStr(nTmp.Text));
      nPrint := nStocks.IndexOf(FGoodsID) >= 0;

      with nList do
      begin
        Values['Bills'] := PackerEncodeStr(nList.Text);
        Values['ZhiKa'] := FYunTianOrderId;
        Values['Truck'] := EditTruck.Text;
        Values['Lading'] := sFlag_TiHuo;
        Values['Memo']  := EmptyStr;
        Values['IsVIP'] := Copy(GetCtrlData(EditType),1,1);
        Values['Seal'] := '';
        Values['HYDan'] := '';
        Values['WebOrderID'] := nWebOrderID;
        {$IFDEF UseXHSpot}
        Values['L_XHSpot'] := FXHSpot;
        {$ENDIF}
      end;
      nBillData := PackerEncodeStr(nList.Text);
      FBegin := Now;
      nBillID := SaveBill(nBillData);
      if nBillID = '' then
      begin
        nHint := '���������ʧ��';
        ShowMsg(nHint,sError);
        Writelog(nHint);
        Exit;
      end;
      writelog('TfFormNewCard.SaveBillProxy ���������['+nBillID+']-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
      FBegin := Now;
      SaveWebOrderMatch(nBillID,nWebOrderID,sFlag_Sale);
      writelog('TfFormNewCard.SaveBillProxy �����̳Ƕ�����-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
      FListA.Add(nBillID);
    finally
      nStocks.Free;
      nList.Free;
      nTmp.Free;
    end;
  end;

  for nidx := 0 to FListA.Count - 1 do
    nRet := SaveBillCard(FListA[nidx], nCard);

  if not nRet then
  begin
    nMsg := '����ſ�ʧ��,������.';
    ShowMsg(nMsg, sHint);
    Exit;
  end;

  nRet := gDispenserManager.SendCardOut(gSysParam.FTTCEK720ID, nHint);
  //����

  if nRet then
  begin
    nMsg := '�����[ %s ]�����ɹ�,����[ %s ],���պ����Ŀ�Ƭ';
    nMsg := Format(nMsg, [nBillID, nCard]);

    WriteLog(nMsg);
    ShowMsg(nMsg,sWarn);
  end
  else begin
    gDispenserManager.RecoveryCard(gSysParam.FTTCEK720ID, nHint);

    nMsg := '����[ %s ]��������ʧ��,�뵽��Ʊ�������¹���.';
    nMsg := Format(nMsg, [nCard]);

    WriteLog(nMsg);
    ShowMsg(nMsg,sWarn);
  end;
  Result := True;
  if nPrint then
  begin
    for nidx := 0 to FListA.Count - 1 do
      PrintBillReport(FListA[nidx], True);
      //print report
  end;
end;

function TfFormNewCard.SaveWebOrderMatch(const nBillID,
  nWebOrderID,nBillType: string):Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := MakeSQLByStr([
  SF('WOM_WebOrderID'   , nWebOrderID),
  SF('WOM_LID'          , nBillID),
  SF('WOM_StatusType'   , c_WeChatStatusCreateCard),
  SF('WOM_MsgType'      , cSendWeChatMsgType_AddBill),
  SF('WOM_BillType'     , nBillType),
  SF('WOM_deleted'     , sFlag_No)
  ], sTable_WebOrderMatch, '', True);
  fdm.ADOConn.BeginTrans;
  try
    fdm.ExecuteSQL(nStr);
    fdm.ADOConn.CommitTrans;
    Result := True;
  except
    fdm.ADOConn.RollbackTrans;
  end;
end;
procedure TfFormNewCard.lvOrdersClick(Sender: TObject);
var
  nSelItem:TListItem;
  i:Integer;
begin
  nSelItem := lvorders.Selected;
  if Assigned(nSelItem) then
  begin
    for i := 0 to lvOrders.Items.Count-1 do
    begin
      if nSelItem = lvOrders.Items[i] then
      begin
        FWebOrderIndex := i;
        LoadSingleOrder;
        Break;
      end;
    end;
  end;
end;

procedure TfFormNewCard.editWebOrderNoKeyPress(Sender: TObject;
  var Key: Char);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  if Key=Char(vk_return) then
  begin
    key := #0;
    if btnQuery.CanFocus then
      btnQuery.SetFocus;
    btnQuery.Click;
  end;
end;

procedure TfFormNewCard.btnClearClick(Sender: TObject);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  editWebOrderNo.Clear;
  ActiveControl := editWebOrderNo;
end;

procedure TfFormNewCard.EditSJPinYinKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    GetSJInfo;
  end;
end;

procedure TfFormNewCard.GetSJInfo;
var
  nStr : string;
begin
  nStr := 'Select D_Name, D_IDCard From %s Where (D_PinYin like ''%%%s%%'') or (D_PY like ''%%%s%%'') ';
  nStr := Format(nStr, [sTable_DriverWh, Trim(EditSJPinYin.Text) , Trim(EditSJPinYin.Text)]);
  with FDM.QueryTemp(nStr) do
  if Recordcount = 1 then
  begin
    EditSJName.Text := Fields[0].AsString;
    EditIdent.Text  := Fields[1].AsString;
  end;
end;

procedure TfFormNewCard.GetSJInfoEx;
var
  nStr : string;
begin
  nStr := 'Select D_Name, D_IDCard From %s Where (D_Truck like ''%%%s%%'') ';
  nStr := Format(nStr, [sTable_DriverWh, Trim(EditTruck.Text)]);
  with FDM.QueryTemp(nStr) do
  if Recordcount = 1 then
  begin
    EditSJName.Text := Fields[0].AsString;
    EditIdent.Text  := Fields[1].AsString;
  end;
end;


procedure TfFormNewCard.SyncCard(const nCard: TIdCardInfoStr;
  const nReader: TSDTReaderItem);
var nStr: string;
begin
  nStr := '��ȡ�����֤��Ϣ: [ %s ]=>[ %s.%s ]';
  nStr := Format(nStr, [nReader.FID, nCard.FName, nCard.FIdSN]);
  WriteLog(nStr);

  EditIdent.Text := nCard.FIdSN;
  GetSJName;
end;

procedure TfFormNewCard.GetSJName;
var
  nStr : string;
begin
  nStr := 'Select D_Name, D_PinYin From %s Where D_IDCard = ''%s'' ';
  nStr := Format(nStr, [sTable_DriverWh, Trim(EditIdent.Text)]);
  with FDM.QueryTemp(nStr) do
  if Recordcount > 0 then
  begin
    EditSJName.Text    := Fields[0].AsString;
    EditSJPinYin.Text  := Fields[1].AsString;
  end;
end;

procedure TfFormNewCard.EditIdentKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    GetSJName;
  end;
end;

function TfFormNewCard.CheckYYOrderState(const nWebOrderID: string;
  var nHint: string): Boolean;
var
  nStr : string;
begin
  Result := False;
  nHint  := '';
  
  nStr   := ' Select W_State From %s Where W_WebOrderID = ''%s'' ';
  nStr   := Format(nStr, [sTable_YYWebBill, nWebOrderID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if Fields[0].AsString = '1' then
    begin
      Result := True;
    end
    else
    begin
      nHint := '������ʧЧ!';
    end;
  end
  else
  begin
    nHint := '����������!';
  end;
end;

end.
