unit UShowFHBillInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UAndroidFormBase, FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation,
  UBusinessConst, USysBusiness, UMainFrom, UGlobal, Androidapi.JNI.Toast;

type
  TFrmShowFHBillInfo = class(TfrmFormBase)
    Label6: TLabel;
    Label8: TLabel;
    lblTruck: TLabel;
    lblMName: TLabel;
    Label4: TLabel;
    lblCusName: TLabel;
    lblLID: TLabel;
    Label1: TLabel;
    BtnOK: TSpeedButton;
    BtnCancel: TSpeedButton;
    cbb_Place: TComboBox;
    lbl1: TLabel;
    tmr1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure LoadLadePlace;
  private
    FOrders: TLadingBillItems;
  public
    FCardNo: string;
  end;

var
  FrmShowFHBillInfo: TFrmShowFHBillInfo;

implementation

{$R *.fmx}

procedure TFrmShowFHBillInfo.BtnCancelClick(Sender: TObject);
begin
  inherited;
  MainForm.Show;
  Self.Hide;
end;

procedure TFrmShowFHBillInfo.BtnOKClick(Sender: TObject);
var nStr:string;
begin
  inherited;
  if Length(FOrders)>0 then
  with FOrders[0] do
  begin
    nStr:= cbb_Place.items[cbb_Place.ItemIndex];
    FLadeLine    := GetLeftStr('、',nStr);
    FLadeLineName:= GetRightStr('、',nStr);

    if (FLadeLine='')or(FLadeLineName='') then
    begin
      Toast('需选择装车堆场');
      Exit;
    end;

    if SaveLadingBills('F', FOrders) then
    begin
      ShowMessage(lblTruck.Text+' 确认装车成功');
      MainForm.Show;
    end
    else ShowMessage('操作失败');
  end;
end;

procedure TFrmShowFHBillInfo.FormActivate(Sender: TObject);
begin
  inherited;
  lblLID.Text     := '';
  lblCusName.Text := '';
  lblMName.Text   := '';
  lblTruck.Text   := '';

  tmr1.Enabled := True;
  SetLength(FOrders, 0);
  LoadLadePlace;
end;

procedure TFrmShowFHBillInfo.LoadLadePlace;
VAR nData:string;
    nList: TStringList;
    nIdx:Integer;
begin
  GetLadePlace(nData);
  nList := TStringList.Create;
  nList.CommaText:= nData;

  cbb_Place.Items.Clear;
  for nIdx := 0 to nList.Count-1 do
  begin
    cbb_Place.Items.Add( nList[nIdx] );
  end;
end;

procedure TFrmShowFHBillInfo.tmr1Timer(Sender: TObject);
var nIdx, nInt: Integer;
    nStr : string;
begin
  tmr1.Enabled := False;

  if not GetLadingBills(FCardNo, 'F', FOrders) then
  begin
    BtnCancelClick(Self);
    Exit;
  end;

  nInt := 0;
  for nIdx := Low(FOrders) to High(FOrders) do
  with FOrders[nIdx] do
  begin
    FSelected := (FNextStatus='F') or (FNextStatus='M');
    if FSelected then Inc(nInt);
  end;

  if nInt<1 then
  begin
    nStr := '磁卡 %s 没有需要 装车 车辆';
    nStr := Format(nStr, [FCardNo]);

    ShowMessage(nStr);
    Exit;
  end;

  with FOrders[0] do
  begin
    lblLID.Text     := FID;
    lblCusName.Text := FCusName;
    lblMName.Text   := FStockName;
    lblTruck.Text   := FTruck;
  end;

  BtnOK.Enabled := True;
end;

end.
