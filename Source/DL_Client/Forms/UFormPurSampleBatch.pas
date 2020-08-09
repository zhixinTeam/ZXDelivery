unit UFormPurSampleBatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxLabel, cxTextEdit, cxMaskEdit, cxButtonEdit, cxGroupBox;

type
  TfFormPurSampleBatch = class(TfFormNormal)
    cxlbl_BZ: TcxLabel;
    dxlytmLayout1Item31: TdxLayoutItem;
    dxlytmLayout1Item33: TdxLayoutItem;
    cxlbl3: TcxLabel;
    cxgrpbx1: TcxGroupBox;
    dxlytmLayout1Item35: TdxLayoutItem;
    cxlbl_ProInfo: TcxLabel;
    dxlytmLayout1Item34: TdxLayoutItem;
    cxgrpbx2: TcxGroupBox;
    dxLayout1Item3: TdxLayoutItem;
    Edt_SID: TcxButtonEdit;
    cxlbl_MaInfo: TcxLabel;
    cxlbl_Value: TcxLabel;
    cxlbl_Trucks: TcxLabel;
    cxlbl_Num: TcxLabel;
    procedure Edt_InspectionStandardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
  private
    FIDs,FNum,FProID,FProName,FMID,FMName,FTrucks,FValue:string;
    FID, FStdID:string;
  private
    procedure ShowData;
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormPurSampleBatch: TfFormPurSampleBatch;

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

class function TfFormPurSampleBatch.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
    nData : TStrings;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormPurSampleBatch.Create(Application) do
  try
    nData := TStringList.Create;

    nData.Delimiter:= ',';
    nData.CommaText:= nP.FParamA;

    FProID   := nData[0];
    FProName := nData[1];
    FMID     := nData[2];
    FMName   := nData[3];
    FValue   := nData[4];
    FTrucks  := nData[5];
    FIDs     := PackerDecodeStr(nData[6]);
    FNum     := nData[7];

    ShowData;
    //************************************
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
    nData.free;
  end;
end;

class function TfFormPurSampleBatch.FormID: integer;
begin
  Result := cFI_FormPurSampleBatch;
end;

procedure TfFormPurSampleBatch.ShowData;
begin
  cxlbl_ProInfo.Caption:= '供应商名：' + FProID +'、'+ FProName;
  cxlbl_MaInfo.Caption := '取样物料：' + FMID +'、'+ FMName;
  cxlbl_Value.Caption  := '组批总量：' + FValue + ' 吨';
  cxlbl_Trucks.Caption := '送货车辆：' + FTrucks;
  cxlbl_Num.Caption    := '合计车数：' + FNum;
end;


procedure TfFormPurSampleBatch.Edt_InspectionStandardPropertiesButtonClick(
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

procedure TfFormPurSampleBatch.BtnOKClick(Sender: TObject);
var nStr, nSID : string;
begin
  try
    FDM.ADOConn.BeginTrans;
    //*****************************************
    nStr := MakeSQLByStr([
            SF('S_BatID', FID),
            SF('S_StdID', FStdID),
            SF('S_ProID', FProID),
            SF('S_ProName', FProName),
            SF('S_MID', FMID),
            SF('S_MName', FMName),
            SF('S_Value', FValue),
            SF('S_Trucks', FTrucks),
            SF('S_Man', gSysParam.FUserName),
            SF('S_Date', sField_SQLServer_Now, sfVal)
            ], sTable_PurSampleBatch, nStr, True);
    FDM.ExecuteSQL(nStr);

    nStr:= 'UPDate %s Set D_BatID=''%s'' Where D_ID in (%s)';
    nStr:= Format(nStr, [sTable_OrderDtl, FID, FIDs]);
    FDM.ExecuteSQL(nStr);
    //*****************************************
    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
  except
    FDM.ADOConn.RollbackTrans;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormPurSampleBatch, TfFormPurSampleBatch.FormID);

end.
