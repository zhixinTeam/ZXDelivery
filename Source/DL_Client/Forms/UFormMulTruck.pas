{*******************************************************************************
  作者: dmzn@163.com 2014-11-25
  描述: 车辆档案管理
*******************************************************************************}
unit UFormMulTruck;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox;

type
  TfFormMulTruck = class(TfFormNormal)
    CheckValid: TcxCheckBox;
    dxLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    EditXTNum: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    { Protected declarations }
    FTruckID: string;
    FListA,   FListB: TStrings;
    procedure LoadFormData(const nID: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst;

class function TfFormMulTruck.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;
  
  with TfFormMulTruck.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      Exit;
    end;

    if nP.FCommand = cCmd_EditData then
    begin
      Caption := '车辆 - 批量修改';
      FListA.Text := nP.FParamA;
      FListB.Text := nP.FParamB;
    end;

    LoadFormData(FListA.Text);
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormMulTruck.FormID: integer;
begin
  Result := cFI_FormMulTrucks;
end;

procedure TfFormMulTruck.LoadFormData(const nID: string);
begin
  CheckValid.Checked := True;
end;

//Desc: 保存
procedure TfFormMulTruck.BtnOKClick(Sender: TObject);
var nStr,nTruck,nU,nV,nP,nVip,nGps,nEvent: string;
  nXTNum: Double;
  nIdx: Integer;
  nPF: TFormCommandParam;
begin
  with nPF do
  begin
    nStr := '请填写批量修改原因';

    FCommand := cCmd_AddData;
    FParamA := nStr;
    FParamB := 320;
    FParamD := 2;

    CreateBaseFormItem(cFI_FormMemo, '', @nPF);
    if (FCommand <> cCmd_ModalResult) or (FParamA <> mrOK) then Exit;
  end;
  for nIdx := 0 to FListA.Count - 1 do
  begin
    nTruck := FListA[nIdx];
    {$IFDEF UseTruckXTNum}
    nXTNum := StrToFloatDef(EditXTNum.Text,0);
    {$ENDIF}

    if CheckValid.Checked then
         nV := sFlag_Yes
    else nV := sFlag_No;

//    if CheckVerify.Checked then
//         nU := sFlag_No
//    else nU := sFlag_Yes;
//
//    if CheckUserP.Checked then
//         nP := sFlag_Yes
//    else nP := sFlag_No;
//
//    if CheckVip.Checked then
//         nVip:=sFlag_TypeVIP
//    else nVip:=sFlag_TypeCommon;
//
//    if CheckGPS.Checked then
//         nGps := sFlag_Yes
//    else nGps := sFlag_No;

    nStr := SF('R_ID', nTruck, sfVal);

    nStr := MakeSQLByStr([
            SF('T_Memo', nPF.FParamB),
            SF('T_Valid', nV),
            {$IFDEF UseTruckXTNum}
            SF('T_XTNum', FloatToStr(nXTNum)),
            {$ENDIF}
            SF('T_LastTime', sField_SQLServer_Now, sfVal)
            ], sTable_Truck, nStr, False);
    FDM.ExecuteSQL(nStr);

    nEvent := '批量修改车辆档案信息:[ %s ]';
    nEvent := Format(nEvent, [FListB[nIdx]]);

    if CheckValid.Checked then
      nEvent := nEvent + '[ 允许开单 ]'
    else
      nEvent := nEvent + '[ 禁止开单 ]';

//    if CheckUserP.Checked then
//      nEvent := nEvent + '[ 启用预制皮重 ]'
//    else
//      nEvent := nEvent + '[ 关闭预制皮重 ]';
//
//    if CheckVip.Checked then
//      nEvent := nEvent + '[ 设置为VIP车辆 ]'
//    else
//      nEvent := nEvent + '[ 设置为普通车辆 ]';
//
//    if CheckVerify.Checked then
//      nEvent := nEvent + '[ 开启停车场校验 ]'
//    else
//      nEvent := nEvent + '[ 关闭停车场校验 ]';
//
//    if CheckGPS.Checked then
//      nEvent := nEvent + '[ 开启GPS校验 ]'
//    else
//      nEvent := nEvent + '[ 关闭GPS校验 ]';

    nEvent := nEvent + '备注:[ ' + nPF.FParamB + ' ]';
    FDM.WriteSysLog(sFlag_CommonItem, FListB[nIdx], nEvent);
  end;

  ModalResult := mrOk;
  ShowMsg('车辆信息保存成功', sHint);
end;

procedure TfFormMulTruck.FormCreate(Sender: TObject);
begin
  inherited;
  {$IFDEF UseTruckXTNum}
  dxLayout1Item11.Visible := True;
  {$ELSE}
  dxLayout1Item11.Visible := False;
  {$ENDIF}
  FListA    := TStringList.Create;
  FListB    := TStringList.Create;
end;

procedure TfFormMulTruck.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FListA.Free;
  FListB.Free;
  inherited;
end;

initialization
  gControlManager.RegCtrl(TfFormMulTruck, TfFormMulTruck.FormID);
end.
