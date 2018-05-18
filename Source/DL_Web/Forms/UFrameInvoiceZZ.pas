{*******************************************************************************
  作者: dmzn@163.com 2018-05-16
  描述: 销售扎帐
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
    procedure EditCustomerKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem1Click(Sender: TObject);
    procedure BtnWeekFilterClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
  private
    { Private declarations }
    FNowYear,FNowWeek,FWeekName: string;
    //当前周期
    procedure LoadWeek;
    //获取周期
  public
    { Public declarations }
    procedure OnCreateFrame(const nIni: TIniFile); override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //构建语句
  end;

implementation

{$R *.dfm}
uses
  Data.Win.ADODB, uniGUIVars, MainModule, uniGUIApplication, UManagerGroup,
  ULibFun, USysBusiness, USysDB, USysConst, UFormInvoiceGetWeek,
  UFormInvoiceZZAll;

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
  //构建表头

  UserDefineGrid(ClassName, DBGridMain, True, nIni);
  //自定义表头配置
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
      EditWeek.Text := '请选择结算周期'; Exit;
    end else
    begin
      nStr := '年份:[ %s ] 周期:[ %s ]';
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
    //xxxxx

    if nWhere = '' then
         Result := Result + nWeek
    else Result := Result + 'Where ( ' + nWhere + ' )';

    Result := MacroValue(Result, [MI('$Req', sTable_InvoiceReq),
              MI('$Week', sTable_InvoiceWeek), MI('$ZK', sTable_ZhiKa)]);
    //xxxxx
  end;
end;

procedure TfFrameInvoiceZZ.EditCustomerKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then Exit;
  Key := #0;

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'R_CusID Like ''%%%s%%'' Or R_Customer Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 载入默认周期
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
      InitFormData(FWhere);
    end);
  //xxxxx
end;

//Desc: 选择周期
procedure TfFrameInvoiceZZ.BtnWeekFilterClick(Sender: TObject);
begin
  LoadWeek;
end;

//------------------------------------------------------------------------------
procedure TfFrameInvoiceZZ.DBGridMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then PMenu1.Popup(X, Y, DBGridMain);
end;

//Desc: 快捷菜单
procedure TfFrameInvoiceZZ.MenuItem1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('C_XuNi=''%s''', [sFlag_Yes]);
   20: FWhere := '1=1';
  end;

  InitFormData(FWhere);
end;

initialization
  RegisterClass(TfFrameInvoiceZZ);
end.
