unit UFormPurTestPlanSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, dxLayoutcxEditAdapters;

type
  TfFormPurTestPlanSet = class(TfFormNormal)
    Edt_1: TcxButtonEdit;
    dxlytmLayout1Item3: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
  private
    FID:string;
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormPurTestPlanSet: TfFormPurTestPlanSet;

implementation

{$R *.dfm}

uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst, UFormCtrl,
  USysBusiness;

class function TfFormPurTestPlanSet.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormPurTestPlanSet.Create(Application) do
  try
    FID := nP.FParamA;
    Edt_1.Text := nP.FParamB;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormPurTestPlanSet.FormID: integer;
begin
  Result := cFI_FormPurTestPlanSet;
end;

procedure TfFormPurTestPlanSet.BtnOKClick(Sender: TObject);
var nStr:string;
begin
  nStr:= Trim(Edt_1.Text);
  if nStr='' then
  begin
    ShowMsg('请录入方案名称、方便您区分数据', sHint);
    Exit;
  end;

  nStr := MakeSQLByStr([
          SF('P_Name', nStr),
          SF('P_Man', gSysParam.FUserName),
          SF('P_Date', sField_SQLServer_Now, sfVal)
          ], sTable_PurTestPlan, nStr, True);
  FDM.ExecuteSQL(nStr);

  ModalResult := mrOk;
  ShowMsg('车辆信息保存成功', sHint);
end;


initialization
  gControlManager.RegCtrl(TfFormPurTestPlanSet, TfFormPurTestPlanSet.FormID);


end.
