unit UFormPurSampleBatchEx;

// 中间品添加组批
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxLabel, cxTextEdit, cxMaskEdit, cxButtonEdit, cxGroupBox;

type
  TMeterailsParam = record
    FID   : string;
    FName : string;
  end;
  
  TfFormPurSampleBatchEx = class(TfFormNormal)
    cxlbl_BZ: TcxLabel;
    dxlytmLayout1Item31: TdxLayoutItem;
    dxlytmLayout1Item33: TdxLayoutItem;
    cxlbl3: TcxLabel;
    dxlytmLayout1Item34: TdxLayoutItem;
    cxgrpbx2: TcxGroupBox;
    dxLayout1Item3: TdxLayoutItem;
    Edt_SID: TcxButtonEdit;
    EditMName: TcxButtonEdit;
    dxlytmLayout1Item4: TdxLayoutItem;
    dxlytmLayout1Item42: TdxLayoutItem;
    cxgrpbx3: TcxGroupBox;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    procedure Edt_InspectionStandardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure EditMNameKeyPress(Sender: TObject; var Key: Char);
  private
    FID, FStdID:string;
    FMeterail: TMeterailsParam;
  private
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormPurSampleBatchEx: TfFormPurSampleBatchEx;

implementation

{$R *.dfm}

uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst, UFormCtrl,
  USysBusiness, UBusinessPacker;


function GetLeftStr(SubStr, Str: string): string;
begin
   Result := Copy(Str, 1, Pos(SubStr, Str) - 1);
end;
//-------------------------------------------

function GetRightStr(SubStr, Str: string): string;
var
   i: integer;
begin
   i := pos(SubStr, Str);
   if i > 0 then
     Result := Copy(Str
       , i + Length(SubStr)
       , Length(Str) - i - Length(SubStr) + 1)
   else
     Result := '';
end;
//-------------------------------------------

class function TfFormPurSampleBatchEx.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormPurSampleBatchEx.Create(Application) do
  try
    FillChar(FMeterail, 1, #0);
    //************************************
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormPurSampleBatchEx.FormID: integer;
begin
  Result := cFI_FormPurSampleBatchEx;
end;

procedure TfFormPurSampleBatchEx.Edt_InspectionStandardPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  nP.FParamA := Edt_SID.Text;

  if Pos('、', Edt_SID.Text)>0 then
    nP.FParamA := GetRightStr('、', Edt_SID.Text);

  CreateBaseFormItem(cFI_FormGetInspStandard, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOk) then
  begin
    FStdID:= nP.FParamB;
    FID:= FormatDateTime('yyyyMMDDHHNNSSZZZ', Now);
    Edt_SID.Text := nP.FParamB +'、'+nP.FParamC;
    cxlbl_BZ.Caption:= '检验标准：' + nP.FParamC;
  end;
end;

procedure TfFormPurSampleBatchEx.BtnOKClick(Sender: TObject);
var nStr, nSID : string;
begin
  try
    FDM.ADOConn.BeginTrans;
    //*****************************************
    nStr := MakeSQLByStr([
            SF('S_BatID', FID),
            SF('S_StdID', FStdID),
            SF('S_ProName', '中间品'),
            SF('S_MID',   FMeterail.FID),
            SF('S_MName', FMeterail.FName),
            SF('S_Man', gSysParam.FUserName),
            SF('S_Date', sField_SQLServer_Now, sfVal)
            ], sTable_PurSampleBatch, nStr, True);
    FDM.ExecuteSQL(nStr);
    //*****************************************
    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
  except
    FDM.ADOConn.RollbackTrans;
  end;
end;

procedure TfFormPurSampleBatchEx.EditMNameKeyPress(Sender: TObject;
  var Key: Char);
var nP: TFormCommandParam;
begin
  inherited;
  if (Key = Char(VK_RETURN)) OR (Key = Char(VK_SPACE))then
  begin
    Key := #0;

    nP.FParamA := EditMName.Text;
    CreateBaseFormItem(cFI_FormGetMeterail, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
    with FMeterail do
    begin
      FID := nP.FParamB;
      FName:=nP.FParamC;

      EditMName.Text := FName;
    end;

    EditMName.SelectAll;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormPurSampleBatchEx, TfFormPurSampleBatchEx.FormID);

end.
