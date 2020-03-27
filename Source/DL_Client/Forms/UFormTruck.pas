{*******************************************************************************
  作者: dmzn@163.com 2014-11-25
  描述: 车辆档案管理
*******************************************************************************}
unit UFormTruck;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxLCPainter;

type
  TfFormTruck = class(TfFormNormal)
    EditTruck: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditOwner: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditPhone: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    CheckValid: TcxCheckBox;
    dxLayout1Item4: TdxLayoutItem;
    CheckVerify: TcxCheckBox;
    dxLayout1Item7: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item6: TdxLayoutItem;
    CheckUserP: TcxCheckBox;
    CheckVip: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    CheckGPS: TcxCheckBox;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    EditXTNum: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    dxlytm_MValueMax: TdxLayoutItem;
    edt_LimitedValue: TcxTextEdit;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    dxlytm_MValeMin: TdxLayoutItem;
    edt_LimitedValueMin: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditColor: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditType: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditStock: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    EditPF: TcxTextEdit;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Item16: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    { Protected declarations }
    FTruckID: string;
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
  ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst, USysBusiness;

class function TfFormTruck.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;
  
  with TfFormTruck.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      Caption := '车辆 - 添加';
      FTruckID := '';
    end;

    if nP.FCommand = cCmd_EditData then
    begin
      Caption := '车辆 - 修改';
      FTruckID := nP.FParamA;
    end;

    LoadFormData(FTruckID); 
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormTruck.FormID: integer;
begin
  Result := cFI_FormTrucks;
end;

procedure TfFormTruck.LoadFormData(const nID: string);
var nStr: string;
begin
  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Truck, nID]);
    FDM.QueryTemp(nStr);
  end;

  with FDM.SqlTemp do
  begin
    if (nID = '') or (RecordCount < 1) then
    begin
      CheckVerify.Checked := True;
      CheckValid.Checked := True;
      Exit;
    end;

    EditTruck.Text := FieldByName('T_Truck').AsString;     
    EditOwner.Text := FieldByName('T_Owner').AsString;
    EditPhone.Text := FieldByName('T_Phone').AsString;
    {$IFDEF UseTruckXTNum}
    EditXTNum.Text := FieldByName('T_XTNum').AsString;
    {$ENDIF}

    {$IFDEF LimitedLoadMValueChk}  //毛重限载控制
    edt_LimitedValue.Text:= FieldByName('T_Limited').AsString;
    edt_LimitedValueMin.Text:= FieldByName('T_LimitedMin').AsString;
    {$ELSE}
    dxlytm_MValueMax.Visible:= False;
    dxlytm_MValeMin.Visible:= False;
    edt_LimitedValue.Visible:= False;
    edt_LimitedValueMin.Visible:= False;
    {$ENDIF}

    CheckVerify.Checked := FieldByName('T_NoVerify').AsString = sFlag_No;
    CheckValid.Checked := FieldByName('T_Valid').AsString = sFlag_Yes;
    CheckUserP.Checked := FieldByName('T_PrePUse').AsString = sFlag_Yes;

    CheckVip.Checked   := FieldByName('T_VIPTruck').AsString = sFlag_TypeVIP;
    CheckGPS.Checked   := FieldByName('T_HasGPS').AsString = sFlag_Yes;
    EditType.Text := FieldByName('T_Type').AsString;
    EditColor.Text := FieldByName('T_PlateColor').AsString;
    EditStock.Text := FieldByName('T_Stock').AsString;
    EditPF.Text := FieldByName('T_PF').AsString;
    EditMemo.Text := FieldByName('T_Memo').AsString;
  end;
end;

//Desc: 保存
procedure TfFormTruck.BtnOKClick(Sender: TObject);
var nStr,nTruck,nU,nV,nP,nVip,nGps,nEvent: string;
  nXTNum: Double;
begin
  nTruck := UpperCase(Trim(EditTruck.Text));
  if nTruck = '' then
  begin
    ActiveControl := EditTruck;
    ShowMsg('请输入车牌号码', sHint);
    Exit;
  end;
  if FTruckID = '' then
  begin
    nStr := ' Select T_Truck from %s where T_Truck=''%s''';
    nStr := Format(nStr,[sTable_Truck, nTruck]);
    with FDM.QuerySQL(nStr) do
    begin
      if RecordCount>0 then
      begin
        ActiveControl := EditTruck;
        ShowMsg('已存在此车牌号码', sHint);
        Exit;
      end;
    end;
  end;

  {$IFDEF UseTruckXTNum}
  nXTNum := StrToFloatDef(EditXTNum.Text,0);
  {$ENDIF}

  if CheckValid.Checked then
       nV := sFlag_Yes
  else nV := sFlag_No;

  if CheckVerify.Checked then
       nU := sFlag_No
  else nU := sFlag_Yes;

  if CheckUserP.Checked then
       nP := sFlag_Yes
  else nP := sFlag_No;

  if CheckVip.Checked then
       nVip:=sFlag_TypeVIP
  else nVip:=sFlag_TypeCommon;

  if CheckGPS.Checked then
       nGps := sFlag_Yes
  else nGps := sFlag_No;

  if FTruckID = '' then
       nStr := ''
  else nStr := SF('R_ID', FTruckID, sfVal);

  nStr := MakeSQLByStr([SF('T_Truck', nTruck),
          SF('T_Owner', EditOwner.Text),
          SF('T_Phone', EditPhone.Text),
          SF('T_NoVerify', nU),
          SF('T_Valid', nV),
          SF('T_PrePUse', nP),
          SF('T_VIPTruck', nVip),
          SF('T_HasGPS', nGps),
          {$IFDEF UseTruckXTNum}
          SF('T_XTNum', FloatToStr(nXTNum)),
          {$ENDIF}
          SF('T_Type', EditType.Text),
          SF('T_PlateColor', EditColor.Text),
          SF('T_Stock', EditStock.Text),
          SF('T_PF', EditPF.Text),
          SF('T_Memo', EditMemo.Text),
          {$IFDEF LimitedLoadMValueChk}  //毛重限载控制
          SF('T_Limited', StrToFloatDef(edt_LimitedValue.Text,50)),
          SF('T_LimitedMin', StrToFloatDef(edt_LimitedValueMin.Text,20)),
          {$ENDIF}

          SF('T_LastTime', sField_SQLServer_Now, sfVal)
          ], sTable_Truck, nStr, FTruckID = '');
  FDM.ExecuteSQL(nStr);

  if FTruckID='' then
        nEvent := '添加[ %s ]档案信息.'
  else  nEvent := '修改[ %s ]档案信息.';
  nEvent := Format(nEvent, [nTruck]);
  FDM.WriteSysLog(sFlag_CommonItem, nTruck, nEvent);


  ModalResult := mrOk;
  ShowMsg('车辆信息保存成功', sHint);
end;

procedure TfFormTruck.FormCreate(Sender: TObject);
begin
  inherited;
  {$IFDEF UseTruckXTNum}
  dxLayout1Item11.Visible := True;
  {$ELSE}
  dxLayout1Item11.Visible := False;
  {$ENDIF}
end;

initialization
  gControlManager.RegCtrl(TfFormTruck, TfFormTruck.FormID);
end.
