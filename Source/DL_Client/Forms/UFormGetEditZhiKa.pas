{*******************************************************************************
  作者: dmzn@163.com 2017-09-27
  描述: 开提货单
*******************************************************************************}
unit UFormGetEditZhiKa;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UBusinessConst, cxGraphics, cxControls, cxLookAndFeels, Dialogs,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMCListBox,
  dxLayoutControl, StdCtrls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, ADODB, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxLabel, dxLayoutcxEditAdapters;

type
  TfFormGetEditZhiKa = class(TfFormNormal)
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    GridOrders: TcxGrid;
    dxLayout1Item3: TdxLayoutItem;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    EditCus: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxView1Column1: TcxGridDBColumn;
    cxView1Column2: TcxGridDBColumn;
    cxView1Column3: TcxGridDBColumn;
    cxView1Column4: TcxGridDBColumn;
    cxView1Column5: TcxGridDBColumn;
    cxView1Column6: TcxGridDBColumn;
    Qry_1: TADOQuery;
    cxView1Column7: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditCusPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditCusKeyPress(Sender: TObject; var Key: Char);
    procedure cxView1DblClick(Sender: TObject);
  private
    FSearchKey:string;
  protected
    { Private declarations }
    FListA: TStrings;
    FBillItem: TLadingBillItem;
    //订单数据
    procedure InitFormData(const nCusName: string);
    //初始化
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst,
  USysBusiness;

class function TfFormGetEditZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormGetEditZhiKa.Create(Application) do
  try
    Caption := '销售订单';
    InitFormData('');

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    np.FParamB := FBillItem.FZhiKa;
    np.FParamC := FBillItem.FStockNo;
  finally
    Free;
  end;
end;

class function TfFormGetEditZhiKa.FormID: integer;
begin
  Result := cFI_FormGetEditZhika;
end;

procedure TfFormGetEditZhiKa.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  FListA := TStringList.Create;
  dxGroup1.AlignVert := avClient;
  LoadFormConfig(Self);

  for nIdx:=0 to cxView1.ColumnCount-1 do
    cxView1.Columns[nIdx].Tag := nIdx;
  InitTableView(Name, cxView1);
end;

procedure TfFormGetEditZhiKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(FListA);
  SaveFormConfig(Self);
  SaveUserDefineTableView(Name, cxView1);
end;

//------------------------------------------------------------------------------
procedure TfFormGetEditZhiKa.InitFormData(const nCusName: string);
var nStr, nC : string;
begin
  if nCusName='' then Exit;

  nC := 'Select C_ID From S_Customer Where C_Name like ''%%'+nCusName+'%%'' OR C_PY like ''%%'+nCusName+'%%''';

  nStr := 'Select * From %s Left Join %s On Z_ID=D_ZID Left Join S_Customer On Z_Customer=C_ID ' +
          'Where Z_Customer in (%s) And Z_ValidDays>%s And ' +
                'IsNull(Z_InValid, '''')<>''%s'' And ' +
                'IsNull(Z_Freeze, '''')<>''%s'' and Z_Verified=''%s'' Order By Z_ID';
  nStr := Format(nStr, [sTable_ZhiKa, sTable_ZhiKaDtl, nC, sField_SQLServer_Now,sFlag_Yes, sFlag_Yes, sFlag_Yes]);

  FDM.QueryData(ADOQuery1, nStr);
  if ADOQuery1.Active and (ADOQuery1.RecordCount = 1) then
  begin
    ActiveControl := BtnOK;
  end else
  begin
    ActiveControl := EditCus;
    EditCus.SelectAll;
  end;
end;

procedure TfFormGetEditZhiKa.EditCusPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr,nWhere: string;
    nIdx: Integer;
    nP: TFormCommandParam;
begin
  if AButtonIndex = 1 then
  begin
    InitFormData(EditCus.Text);
    ShowMsg('刷新成功', sHint);
    Exit;
  end;

  EditCus.Text := Trim(EditCus.Text);
  if EditCus.Text = '' then
  begin
    ShowMsg('请输入客户名称', sHint);
    Exit;
  end;

  if Trim(EditCus.Text)='' then
  begin
    nP.FParamA := EditCus.Text;
    CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    EditCus.Text:= nP.FParamC;
  end;

  InitFormData(EditCus.Text);
end;

procedure TfFormGetEditZhiKa.BtnOKClick(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount < 0 then
  begin
    ShowMsg('请选择订单', sHint);
    Exit;
  end;

  with ADOQuery1,FBillItem do
  begin
    FZhiKa       := FieldByName('Z_ID').AsString;
    FStockNo     := FieldByName('D_StockNo').AsString;
    FStockName   := FieldByName('D_StockName').AsString;
    FCusID       := FieldByName('C_ID').AsString;
    FCusName     := FieldByName('C_Name').AsString;
    FPrice       := FieldByName('D_Price').AsFloat;
  end;

  ModalResult := mrOk;
end;

procedure TfFormGetEditZhiKa.EditCusKeyPress(Sender: TObject;
  var Key: Char);
var nStr: string;
    nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    if FSearchKey='' then
    begin
      nP.FParamA := Trim(EditCus.Text);
      CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
      if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

      EditCus.Text:= nP.FParamC;
      FSearchKey  := nP.FParamC;
    end;

    InitFormData(EditCus.Text);
  end;
end;

procedure TfFormGetEditZhiKa.cxView1DblClick(Sender: TObject);
begin
  BtnOK.Click;
end;

initialization
  gControlManager.RegCtrl(TfFormGetEditZhiKa, TfFormGetEditZhiKa.FormID);
end.
