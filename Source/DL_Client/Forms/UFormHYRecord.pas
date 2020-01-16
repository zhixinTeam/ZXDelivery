{*******************************************************************************
  作者: dmzn@163.com 2009-07-20
  描述: 检验录入
*******************************************************************************}
unit UFormHYRecord;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, cxGraphics, StdCtrls, cxMaskEdit, cxDropDownEdit,
  cxMCListBox, cxMemo, dxLayoutControl, cxContainer, cxEdit, cxTextEdit,
  cxControls, cxButtonEdit, cxCalendar, ExtCtrls, cxPC, cxLookAndFeels,
  cxLookAndFeelPainters, cxGroupBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter;

type
  TfFormHYRecord = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditStock: TcxComboBox;
    dxLayoutControl1Item12: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    wPanel: TPanel;
    dxLayoutControl1Item4: TdxLayoutItem;
    Label17: TLabel;
    Label18: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Bevel2: TBevel;
    cxTextEdit29: TcxTextEdit;
    cxTextEdit30: TcxTextEdit;
    cxTextEdit31: TcxTextEdit;
    cxTextEdit32: TcxTextEdit;
    cxTextEdit33: TcxTextEdit;
    cxTextEdit34: TcxTextEdit;
    cxTextEdit35: TcxTextEdit;
    cxTextEdit36: TcxTextEdit;
    cxTextEdit37: TcxTextEdit;
    cxTextEdit38: TcxTextEdit;
    cxTextEdit39: TcxTextEdit;
    cxTextEdit40: TcxTextEdit;
    cxTextEdit41: TcxTextEdit;
    cxTextEdit42: TcxTextEdit;
    cxTextEdit43: TcxTextEdit;
    cxTextEdit47: TcxTextEdit;
    cxTextEdit48: TcxTextEdit;
    cxTextEdit49: TcxTextEdit;
    EditDate: TcxDateEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditMan: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group3: TdxLayoutGroup;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label34: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    cxTextEdit17: TcxTextEdit;
    cxTextEdit18: TcxTextEdit;
    cxTextEdit19: TcxTextEdit;
    cxTextEdit20: TcxTextEdit;
    cxTextEdit21: TcxTextEdit;
    cxTextEdit22: TcxTextEdit;
    cxTextEdit23: TcxTextEdit;
    cxTextEdit24: TcxTextEdit;
    cxTextEdit25: TcxTextEdit;
    cxTextEdit26: TcxTextEdit;
    cxTextEdit27: TcxTextEdit;
    cxTextEdit28: TcxTextEdit;
    cxTextEdit45: TcxTextEdit;
    cxTextEdit52: TcxTextEdit;
    cxTextEdit53: TcxTextEdit;
    cxTextEdit54: TcxTextEdit;
    Label41: TLabel;
    cxTextEdit55: TcxTextEdit;
    Label42: TLabel;
    cxTextEdit56: TcxTextEdit;
    Label43: TLabel;
    cxTextEdit57: TcxTextEdit;
    Label44: TLabel;
    cxTextEdit58: TcxTextEdit;
    Label1: TLabel;
    cxTextEdit1: TcxTextEdit;
    Label2: TLabel;
    cxTextEdit2: TcxTextEdit;
    Label3: TLabel;
    cxTextEdit3: TcxTextEdit;
    Label4: TLabel;
    cxTextEdit4: TcxTextEdit;
    cxGroupBox1: TcxGroupBox;
    Label5: TLabel;
    cxTextEdit5: TcxTextEdit;
    Label6: TLabel;
    cxTextEdit6: TcxTextEdit;
    Label7: TLabel;
    cxTextEdit7: TcxTextEdit;
    Label8: TLabel;
    cxTextEdit8: TcxTextEdit;
    cxGroupBox2: TcxGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    cxTextEdit9: TcxTextEdit;
    cxTextEdit10: TcxTextEdit;
    cxTextEdit11: TcxTextEdit;
    cxTextEdit12: TcxTextEdit;
    Label13: TLabel;
    cxTextEdit13: TcxTextEdit;
    Label14: TLabel;
    cxTextEdit14: TcxTextEdit;
    Label15: TLabel;
    cxTextEdit15: TcxTextEdit;
    Label16: TLabel;
    cxTextEdit16: TcxTextEdit;
    Label33: TLabel;
    cxTextEdit44: TcxTextEdit;
    Label35: TLabel;
    cxTextEdit46: TcxTextEdit;
    Label36: TLabel;
    cxTextEdit50: TcxTextEdit;
    Label37: TLabel;
    cxTextEdit51: TcxTextEdit;
    Label45: TLabel;
    cxTextEdit59: TcxTextEdit;
    Label46: TLabel;
    cxTextEdit60: TcxTextEdit;
    Label47: TLabel;
    cxTextEdit61: TcxTextEdit;
    dxlytmLayoutControl1Item5: TdxLayoutItem;
    EditCXDate: TcxDateEdit;
    dxLayoutControl1Group4: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditStockPropertiesEditValueChanged(Sender: TObject);
    procedure cxTextEdit17KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FRecordID: string;
    //合同编号
    FPrefixID: string;
    //前缀编号
    FIDLength: integer;
    //前缀长度
    procedure InitFormData(const nID: string);
    //载入数据
    procedure GetData(Sender: TObject; var nData: string);
    function SetData(Sender: TObject; const nData: string): Boolean;
    //数据处理
  public
    { Public declarations }
  end;

function ShowStockRecordAddForm: Boolean;
function ShowStockRecordEditForm(const nID: string): Boolean;
procedure ShowStockRecordViewForm(const nID: string);
procedure CloseStockRecordForm;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, USysDB, USysConst, UDataReport;

var
  gForm: TfFormHYRecord = nil;
  //全局使用

//------------------------------------------------------------------------------
//Desc: 添加
function ShowStockRecordAddForm: Boolean;
begin
  with TfFormHYRecord.Create(Application) do
  begin
    FRecordID := '';
    Caption := '检验记录 - 添加';

    InitFormData('');
    Result := ShowModal = mrOK;                                  
    Free;
  end;
end;

//Desc: 修改
function ShowStockRecordEditForm(const nID: string): Boolean;
begin
  with TfFormHYRecord.Create(Application) do
  begin
    FRecordID := nID;
    Caption := '检验记录 - 修改';

    InitFormData(nID);
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: 查看
procedure ShowStockRecordViewForm(const nID: string);
begin
  if not Assigned(gForm) then
  begin
    gForm := TfFormHYRecord.Create(Application);
    gForm.Caption := '检验记录 - 查看';
    gForm.FormStyle := fsStayOnTop;
    gForm.BtnOK.Visible := False;
  end;

  with gForm  do
  begin
    FRecordID := nID;
    InitFormData(nID);
    if not Showing then Show;
  end;
end;

procedure CloseStockRecordForm;
begin
  FreeAndNil(gForm);
end;

//------------------------------------------------------------------------------
procedure TfFormHYRecord.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  ResetHintAllForm(Self, 'E', sTable_StockRecord);
  //重置表名称
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'SN');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;
end;

procedure TfFormHYRecord.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

procedure TfFormHYRecord.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormHYRecord.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end else

  if Key = VK_DOWN then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end else

  if Key = VK_UP then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 1, 0);
  end;
end;

procedure TfFormHYRecord.cxTextEdit17KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormHYRecord.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditDate then
    nData := DateTime2Str(EditDate.Date)
  else if Sender = EditCXDate then
  begin
    nData := DateTime2Str(EditCXDate.Date)
  end;
end;

function TfFormHYRecord.SetData(Sender: TObject; const nData: string): Boolean;
begin
  if Sender = EditDate then
  begin
    EditDate.Date := Str2DateTime(nData);
    Result := True;
  end
  else if Sender = EditCXDate then
  begin
    EditCXDate.Date := Str2DateTime(nData);
    Result := True;
  end
  else Result := False;
end;

//Date: 2009-6-2
//Parm: 记录编号
//Desc: 载入nID供应商的信息到界面
procedure TfFormHYRecord.InitFormData(const nID: string);
var nStr: string;
begin
  EditDate.Date := Now;
  EditCXDate.Date := Now;
  EditMan.Text := gSysParam.FUserID;
  
  if EditStock.Properties.Items.Count < 1 then
  begin
    nStr := 'P_ID=Select P_ID,P_Stock From %s';
    nStr := Format(nStr, [sTable_StockParam]);

    FDM.FillStringsData(EditStock.Properties.Items, nStr, -1, '、');
    AdjustStringsItem(EditStock.Properties.Items, False);
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_StockRecord, nID]);
    LoadDataToForm(FDM.QuerySQL(nStr), Self, '', SetData);
  end
  else
  begin
    cxTextEdit55.Text:= '脱硫石膏';
    cxTextEdit57.Text:= '粉煤灰,石灰石,矿渣微粉';
    cxTextEdit25.Text:= '合格';
  end;
  {$IFDEF JZZJ}
  //突出显示检测项
  Label24.Font.Color:= clRed; Label24.Font.Style:= [fsBold];
  Label31.Font.Color:= clRed; Label31.Font.Style:= [fsBold];
  Label32.Font.Color:= clRed; Label32.Font.Style:= [fsBold];
  Label22.Font.Color:= clRed; Label22.Font.Style:= [fsBold];
  Label29.Font.Color:= clRed; Label22.Font.Style:= [fsBold];
  Label27.Font.Color:= clRed; Label27.Font.Style:= [fsBold];
  Label28.Font.Color:= clRed; Label28.Font.Style:= [fsBold];
  Label30.Font.Color:= clRed; Label30.Font.Style:= [fsBold];
  Label40.Font.Color:= clRed; Label40.Font.Style:= [fsBold];
  Label23.Font.Color:= clRed; Label23.Font.Style:= [fsBold];

  Label42.Font.Color:= clRed; Label42.Font.Style:= [fsBold];
  Label44.Font.Color:= clRed; Label44.Font.Style:= [fsBold];
  {$ENDIF}
end;

//Desc: 设置类型
procedure TfFormHYRecord.EditStockPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  if FRecordID = '' then
  begin
    nStr := 'Select * From %s Where R_PID=''%s''';
    nStr := Format(nStr, [sTable_StockParamExt, GetCtrlData(EditStock)]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), wPanel);
  end;

  nStr := 'Select P_Stock From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_StockParam, GetCtrlData(EditStock)]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       nStr := GetPinYinOfStr(Fields[0].AsString)
  else nStr := '';                                    

  if Pos('kzf', nStr) > 0 then //矿渣粉
  begin
    Label24.Caption := '密度g/cm:';
    Label19.Caption := '流动度比:';
    Label22.Caption := '含 水 量:';
    Label21.Caption := '石膏掺量:';
    Label34.Caption := '助 磨 剂:';
    Label18.Caption := '7天活性指数:';
    Label26.Caption := '28天活性指数:';
  end else
  begin
    Label24.Caption := '氧 化 镁:';
    Label19.Caption := '碱 含 量:';
    Label22.Caption := '细    度:';
    Label21.Caption := '稠    度:';
    Label34.Caption := '游 离 钙:';
    Label18.Caption := '3天抗折强度:';
    Label26.Caption := '28天抗折强度:';
  end;

  cxTextEdit55.Text:= '脱硫石膏';
  cxTextEdit57.Text:= '粉煤灰,石灰石,矿渣微粉';
  cxTextEdit25.Text:= '合格';
end;

//Desc: 生成随机编号
procedure TfFormHYRecord.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  Exit;
  EditID.Text := FDM.GetSerialID(FPrefixID, sTable_StockRecord, 'R_SerialNo');
end;

//Desc: 保存数据
procedure TfFormHYRecord.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('请填写有效的水泥编号', sHint); Exit;
  end;

  if EditStock.ItemIndex < 0 then
  begin
    EditStock.SetFocus;
    ShowMsg('请填写有效的品种', sHint); Exit;
  end;

  if FRecordID = '' then
  begin
    nStr := 'Select Count(*) From %s Where R_SerialNo=''%s''';
    nStr := Format(nStr, [sTable_StockRecord, EditID.Text]);
    //查询编号是否存在

    with FDM.QueryTemp(nStr) do
    if Fields[0].AsInteger > 0 then
    begin
      EditID.SetFocus;
      ShowMsg('该编号的记录已经存在', sHint); Exit;
    end;

    nSQL := MakeSQLByForm(Self, sTable_StockRecord, '', True, GetData);
  end else
  begin
    EditID.Text := FRecordID;
    nStr := 'R_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_StockRecord, nStr, False, GetData);
  end;

  {$IFDEF JZZJ} nSQL:= StringReplace(nSQL, '''''', 'Null', [rfReplaceAll]);{$ENDIF}

  FDM.ExecuteSQL(nSQL);
  ModalResult := mrOK;
  ShowMsg('数据已保存', sHint);
end;

end.
