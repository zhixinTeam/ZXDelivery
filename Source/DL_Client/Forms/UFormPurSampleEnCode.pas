unit UFormPurSampleEnCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxButtonEdit, dxLayoutControl, StdCtrls, dxLayoutcxEditAdapters;

type
  TfFormPurSampleEnCode = class(TfFormNormal)
    dxlytm_Code: TdxLayoutItem;
    Edt_Code: TcxButtonEdit;
    procedure BtnOKClick(Sender: TObject);
  private
    FID:string;
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormPurSampleEnCode: TfFormPurSampleEnCode;

implementation

{$R *.dfm}

uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst, UFormCtrl,
  USysBusiness;

class function TfFormPurSampleEnCode.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormPurSampleEnCode.Create(Application) do
  try
    FID := nP.FParamA;
    Edt_Code.Text := nP.FParamB;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormPurSampleEnCode.FormID: integer;
begin
  Result := cFI_FormPurSampleEnCode;
end;


procedure TfFormPurSampleEnCode.BtnOKClick(Sender: TObject);
var nStr,nWhere:string;
begin
  nStr:= Trim(Edt_Code.Text);
  if nStr='' then
  begin
    ShowMsg('请录入加密编码', sHint);
    Exit;
  end;

  nWhere:= ' R_ID=' + FID;
  nStr := MakeSQLByStr([
          SF('S_Encode', nStr),
          SF('S_EncodeMan', gSysParam.FUserName),
          SF('S_EncodeDate', sField_SQLServer_Now, sfVal)
          ], sTable_PurSampleBatch, nWhere, False);
  FDM.ExecuteSQL(nStr);

  ModalResult := mrOk;
  ShowMsg('设置成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormPurSampleEnCode, TfFormPurSampleEnCode.FormID);


end.
