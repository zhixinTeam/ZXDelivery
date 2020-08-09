unit UFormPurTestItemsSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxMemo, cxLabel, cxTextEdit, cxMaskEdit, cxButtonEdit;

type
  TfFormPurTestItemsSet = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    Edt_1: TcxButtonEdit;
    cxlbl1: TcxLabel;
    dxlytmLayout1Item4: TdxLayoutItem;
    Mmo_1: TcxMemo;
    dxlytmLayout1Item42: TdxLayoutItem;
    dxlytmLayout1Item41: TdxLayoutItem;
    Mmo_GS: TcxMemo;
    procedure BtnOKClick(Sender: TObject);
  private
    FPlanID : string;
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormPurTestItemsSet: TfFormPurTestItemsSet;

implementation

{$R *.dfm}


uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst, UFormCtrl,
  USysBusiness;

class function TfFormPurTestItemsSet.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormPurTestItemsSet.Create(Application) do
  try
    FPlanID := nP.FParamA;
    cxlbl1.Caption := '标准信息：' + nP.FParamB;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormPurTestItemsSet.FormID: integer;
begin
  Result := cFI_FormPurTestItemsSet;
end;

procedure TfFormPurTestItemsSet.BtnOKClick(Sender: TObject);
var nStr,nItemName,nWhere,nFormula:string;
begin
  nItemName:= Trim(Edt_1.Text);
  nWhere   := Trim(Mmo_1.Text);
  nFormula := Trim(Mmo_GS.Text);
  if nItemName='' then
  begin
    ShowMsg('请录入检测项名称', sHint);
    Exit;
  end;

  if FPlanID='' then
  begin
    ShowMsg('请重新选择标准后在操作', sHint);
    Exit;
  end;

  nStr := MakeSQLByStr([
          SF('I_PID', FPlanID),
          SF('I_ItemsName', nItemName),
          SF('I_Where', nWhere),
          SF('I_Formula', nFormula),
          SF('I_Man', gSysParam.FUserName),
          SF('I_Date', sField_SQLServer_Now, sfVal)
          ], sTable_PurTestPlanItems, '', True);
  FDM.ExecuteSQL(nStr);

  ModalResult := mrOk;
  ShowMsg('信息保存成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormPurTestItemsSet, TfFormPurTestItemsSet.FormID);


end.
