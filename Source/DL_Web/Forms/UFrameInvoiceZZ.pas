{*******************************************************************************
  ����: dmzn@163.com 2018-05-16
  ����: ��������
*******************************************************************************}
unit UFrameInvoiceZZ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, System.IniFiles,
  uniGUIForm, UFrameBase, Vcl.Menus, uniMainMenu, uniButton, uniBitBtn, uniEdit,
  uniLabel, Data.DB, Datasnap.DBClient, uniGUIClasses, uniBasicGrid, uniDBGrid,
  uniPanel, uniToolBar, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses;

type
  TfFrameInvoiceZZ = class(TfFrameBase)
    PMenu1: TUniPopupMenu;
    MenuItem1: TUniMenuItem;
    Label2: TUniLabel;
    EditCustomer: TUniEdit;
    Label3: TUniLabel;
    EditWeek: TUniEdit;
    BtnWeekFilter: TUniBitBtn;
    N1: TUniMenuItem;
    N2: TUniMenuItem;
    N3: TUniMenuItem;
    procedure EditCustomerKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnWeekFilterClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    FNowYear,FNowWeek,FWeekName: string;
    //��ǰ����
    procedure LoadWeek;
    //��ȡ����
  public
    { Public declarations }
    procedure OnCreateFrame(const nIni: TIniFile); override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //�������
  end;

implementation

{$R *.dfm}
uses
  Data.Win.ADODB, uniGUIVars, MainModule, uniGUIApplication, UManagerGroup,
  ULibFun, USysBusiness, USysDB, USysConst, UFormBase, UFormInvoiceGetWeek,
  UFormInvoiceZZAll, UFormSysLog;

procedure TfFrameInvoiceZZ.OnCreateFrame(const nIni: TIniFile);
begin
  MenuItem1.Enabled := BtnEdit.Enabled;
  FNowYear := '';
  FNowWeek := '';
  FWeekName := '';
  LoadWeek;
end;

procedure TfFrameInvoiceZZ.OnLoadGridConfig(const nIni: TIniFile);
begin
  BuildDBGridColumn('SW_ZHAZHANG', DBGridMain, FilterColumnField());
  //������ͷ

  UserDefineGrid(ClassName, DBGridMain, True, nIni);
  //�Զ����ͷ����
end;

function TfFrameInvoiceZZ.InitFormDataSQL(const nWhere: string): string;
var nInt: Integer;
    nStr,nWeek: string;
begin
  with TStringHelper,TDateTimeHelper do
  begin
    if (FNowYear = '') and (FNowWeek = '') then
    begin
      Result := '';
      EditWeek.Text := '��ѡ���������'; Exit;
    end else
    begin
      nStr := '���:[ %s ] ����:[ %s ]';
      EditWeek.Text := Format(nStr, [FNowYear, FWeekName]);

      if FNowWeek = '' then
      begin
        nWeek := 'Where (W_Begin>=''$S'' and ' +
                 'W_Begin<''$E'') or (W_End>=''$S'' and W_End<''$E'') ' +
                 'Order By W_Begin';
        nInt := StrToInt(FNowYear);

        nWeek := MacroValue(nWeek, [MI('$W', sTable_InvoiceWeek),
                MI('$S', IntToStr(nInt)), MI('$E', IntToStr(nInt+1))]);
        //xxxxx
      end else
      begin
        nWeek := Format('Where R_Week=''%s''', [FNowWeek]);
      end;
    end;

    Result := 'Select req.*,W_Name,Z_Name,Z_Project From $Req req ' +
              ' Left Join $Week On W_NO=req.R_Week ' +
              ' Left Join $ZK On Z_ID=req.R_ZhiKa ';
    Result := Result + nWeek;

    if nWhere <> '' then
      Result := Result + ' And ( ' + nWhere + ' )';
    //xxxxx

    Result := MacroValue(Result, [MI('$Req', sTable_InvoiceReq),
              MI('$Week', sTable_InvoiceWeek), MI('$ZK', sTable_ZhiKa)]);
    //xxxxx
  end;
end;

//Desc: ����Ĭ������
procedure TfFrameInvoiceZZ.LoadWeek;
var nParam: TFormCommandParam;
begin
  with nParam do
  begin
    FCommand := cCmd_GetData;
    FParamA := FNowYear;
    FParamB := FNowWeek;
  end;

  ShowInvoiceGetWeekForm(nParam,
    procedure(const nResult: Integer; const nParam: PFormCommandParam)
    begin
      FNowYear := nParam.FParamA;
      FNowWeek := nParam.FParamB;
      FWeekName := nParam.FParamC;
      InitFormData(FWhere);
    end);
  //xxxxx
end;

procedure TfFrameInvoiceZZ.BtnAddClick(Sender: TObject);
begin
  ShowInvoiceZZAllForm(FNowYear, FNowWeek, FWeekName,
    procedure(const nResult: Integer; const nParam: PFormCommandParam)
    begin
      FNowYear := nParam.FParamA;
      FNowWeek := nParam.FParamB;
      FWeekName := nParam.FParamC;

      FWhere := '';
      InitFormData(FWhere);
    end);
  //xxxxx
end;

//Desc: �޸ļ۲�
procedure TfFrameInvoiceZZ.BtnEditClick(Sender: TObject);
var nForm: TUniForm;
    nParam: TFormCommandParam;
begin
  if DBGridMain.SelectedRows.Count < 1 then
  begin
    ShowMessage('��ѡ��Ҫ�޸ĵļ�¼');
    Exit;
  end;

  nForm := SystemGetForm('TfFormInvoiceFLSet', True);
  if not Assigned(nForm) then Exit;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := ClientDS.FieldByName('R_ID').AsString;
  (nForm as TfFormBase).SetParam(nParam);

  nForm.ShowModal(
    procedure(Sender: TComponent; Result:Integer)
    begin
      if Result = mrok then
        InitFormData(FWhere);
      //refresh
    end);
  //show form
end;

//Desc: ѡ������
procedure TfFrameInvoiceZZ.BtnWeekFilterClick(Sender: TObject);
begin
  LoadWeek;
end;

procedure TfFrameInvoiceZZ.EditCustomerKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then Exit;
  Key := #0;

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'R_CusPY Like ''%%%s%%'' Or R_Customer Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameInvoiceZZ.DBGridMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then PMenu1.Popup(X, Y, DBGridMain);
end;

//Desc: �۲��޸ļ�¼
procedure TfFrameInvoiceZZ.N2Click(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if DBGridMain.SelectedRows.Count > 0 then
  begin
    nParam.FCommand := cCmd_ViewSysLog;
    nParam.FParamA := '2008-08-08';
    nParam.FParamB := '2050-12-12';

    nParam.FParamC := ClientDS.FieldByName('R_ZhiKa').AsString;
    nStr := 'L_Group=''$Group'' And L_ItemID=''$ID''';
    with TStringHelper do
    nParam.FParamD := MacroValue(nStr, [MI('$Group', sFlag_ZhiKaItem),
                      MI('$ID', nParam.FParamC)]);
    //��������

    ShowSystemLog(nParam);
  end;
end;

//Desc: δ���
procedure TfFrameInvoiceZZ.N3Click(Sender: TObject);
begin
  FWhere := '(R_Value<>R_KValue) And (R_KPrice <> 0)';
  InitFormData(FWhere);
end;

initialization
  RegisterClass(TfFrameInvoiceZZ);
end.