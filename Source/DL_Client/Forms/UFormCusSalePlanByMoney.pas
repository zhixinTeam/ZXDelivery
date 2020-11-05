unit UFormCusSalePlanByMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, DateUtils,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, UFormBase,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxButtonEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxCalendar,
  dxLayoutcxEditAdapters;

type
  TfFormCusSalePlanByMoney = class(TfFormNormal)
    dxlytmLayout1Item3: TdxLayoutItem;
    Edt_CName: TcxButtonEdit;
    dxlytmLayout1Item31: TdxLayoutItem;
    edt_Money: TcxTextEdit;
    dxlytmLayout1Item32: TdxLayoutItem;
    Edt_CID: TcxButtonEdit;
    dxlytmLayout1Item33: TdxLayoutItem;
    DateETime: TcxDateEdit;
    dxlytmLayout1Item34: TdxLayoutItem;
    DateSTime: TcxDateEdit;
    procedure Edt_CNameKeyPress(Sender: TObject; var Key: Char);
    procedure Edt_CNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
  private
    FP: PFormCommandParam;
  private
    procedure LoadPlanSet(nID:string);
    procedure SaveSet(IsNew: boolean);
    procedure InitFormData;
    //载入数据
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
      
    class function FormID: integer; override;
  end;

var
  fFormCusSalePlanByMoney: TfFormCusSalePlanByMoney;

implementation

{$R *.dfm}

uses
  DB, IniFiles, ULibFun, UMgrControl, UAdjustForm, UDataModule,
  USysDB, USysConst, USysBusiness;
  

class function TfFormCusSalePlanByMoney.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin 
  Result := nil;

  with TfFormCusSalePlanByMoney.Create(Application) do
  try
    Caption := '销售限量（金额）';
    FP := nParam;

    if FP.FCommand=cCmd_AddData then
    begin
      InitFormData;
    end
    else if FP.FCommand=cCmd_EditData then
    begin
      LoadPlanSet(FP.FParamA);
    end;

    ShowModal;
  finally
    Free;
  end;
end;

class function TfFormCusSalePlanByMoney.FormID: integer;
begin
  Result := cFI_FormCusSalePlanByMoney;
end;

procedure TfFormCusSalePlanByMoney.LoadPlanSet(nID:string);
var nStr:string;
begin
  nStr:= 'Select * From %s Where R_ID=%s';
  nStr:= Format(nStr,[sTable_CusSalePlanByMoney,nID]);
  with FDM.QueryTemp(nStr) do
  begin
    Edt_CID.Text  := FieldByName('X_CID').AsString;
    Edt_CName.Text:= FieldByName('X_CName').AsString;
    edt_Money.Text:= FieldByName('X_Money').AsString;
    DateSTime.Date:= FieldByName('X_STime').AsDateTime;
    DateETime.Date:= FieldByName('X_ETime').AsDateTime;
  end;
end;

procedure TfFormCusSalePlanByMoney.InitFormData;
begin
  Edt_CID.Text  := '';
  Edt_CName.Text:= '';
  edt_Money.Text:= '';
  DateSTime.Date:= Now;
  DateETime.Date:= IncDay(Now, 1);
end;

procedure TfFormCusSalePlanByMoney.Edt_CNameKeyPress(Sender: TObject; var Key: Char);
var nStr: string;
    nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    nP.FParamA := GetCtrlData(Edt_CName);
    
    if nP.FParamA = '' then
      nP.FParamA := Edt_CName.Text;
    //xxxxx

    CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    SetCtrlData(Edt_CID, nP.FParamB);
    SetCtrlData(Edt_CName, nP.FParamC);
  end;
end;

procedure TfFormCusSalePlanByMoney.Edt_CNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then
    Exit;

  SetCtrlData(Edt_CID, nP.FParamB);
  SetCtrlData(Edt_CName, nP.FParamC);
end;

procedure TfFormCusSalePlanByMoney.SaveSet(IsNew: boolean);
var nStrSql : string;
begin
  if IsNew then
  begin
    //*******************************
    if (StrToIntDef(Trim(edt_Money.Text), 0) >= 0) then
    begin
      nStrSql := 'Insert Into $Table (X_CID,X_CName,X_Money,X_STime,X_ETime)' +
                        ' Select ''$CID'', ''$CName'', $Money, ''$STime'', ''$ETime''';
      nStrSql := MacroValue(nStrSql, [MI('$Table', sTable_CusSalePlanByMoney),
                                      MI('$CID',   Trim(Edt_CID.Text) ), MI('$CName', Trim(Edt_CName.Text) ),
                                      MI('$Money', Trim(edt_Money.Text) ),
                                      MI('$STime', DateTime2Str(DateSTime.Date) ),
                                      MI('$ETime', DateTime2Str(DateETime.Date) )]);
      FDM.ExecuteSQL(nStrSql);
      Close;
    end
    else ShowMsg('需输入有效金额！', sHint);
  end
  else
  begin
    if (StrToIntDef(Trim(edt_Money.Text), 0) >= 0) then
    begin
      nStrSql := 'UPDate $Table Set X_CID=''$CID'' ,X_CName=''$CName'', X_Money=$Money,X_STime=''$STime'',X_ETime=''$ETime'' '+
                            ' Where R_ID=$RID ';
      nStrSql := MacroValue(nStrSql, [MI('$Table', sTable_CusSalePlanByMoney), MI('$RID', FP.FParamA),
                                      MI('$CID',   Trim(Edt_CID.Text) ), MI('$CName', Trim(Edt_CName.Text) ),
                                      MI('$Money', Trim(edt_Money.Text) ),
                                      MI('$STime', DateTime2Str(DateSTime.Date) ),
                                      MI('$ETime', DateTime2Str(DateETime.Date) )]);
      FDM.ExecuteSQL(nStrSql);
      Close;
    end
    else ShowMsg('需输入有效金额！', sHint);
  end;
end;

procedure TfFormCusSalePlanByMoney.BtnOKClick(Sender: TObject);
begin
  SaveSet(FP.FCommand=cCmd_AddData);
end;

initialization
  gControlManager.RegCtrl(TfFormCusSalePlanByMoney, TfFormCusSalePlanByMoney.FormID);

end.
