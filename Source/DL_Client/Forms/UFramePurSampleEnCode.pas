unit UFramePurSampleEnCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, dxSkinsdxLCPainter, cxContainer, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, dxLayoutControl, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, cxTextEdit, cxMaskEdit,
  cxButtonEdit, Menus, cxGridCustomPopupMenu, cxGridPopupMenu;

type
  TfFramePurSampleEnCode = class(TfFrameNormal)
    dxLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxlytmLayout1Item2: TdxLayoutItem;
    Edt_Code: TcxButtonEdit;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    FStart,FEnd: TDate;
    //时间区间
  private
    procedure OnCreateFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurSampleEnCode: TfFramePurSampleEnCode;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, USysLoger,
  UBusinessPacker;


class function TfFramePurSampleEnCode.FrameID: integer;
begin
  Result := cFI_FramePurSampleEnCode;
end;

procedure TfFramePurSampleEnCode.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

function TfFramePurSampleEnCode.InitFormDataSQL(const nWhere: string): string;
VAR nYear, nMonth, nPreMonth:string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $SampleBatch Where S_Date>=''$STime'' And S_Date<''$ETime'' ' ;

  Result := MacroValue(Result, [MI('$SampleBatch', sTable_PurSampleBatch),
                            MI('$UMan', gSysParam.FUserName),
                            MI('$STime', Date2Str(FStart)), MI('$ETime', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFramePurSampleEnCode.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFramePurSampleEnCode.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FParamA:= SQLQuery.FieldByName('R_ID').AsString;
    nP.FParamB:= SQLQuery.FieldByName('S_Encode').AsString;

    CreateBaseFormItem(cFI_FormPurSampleEnCode, '', @nP);
    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData('');
    end;
  end;
end;

procedure TfFramePurSampleEnCode.BtnEditClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('S_BatID').AsString;

    nStr := Format('确定要撤销取样记录[ %s ]的加密编码么?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'UPDate %s Set S_EnCode=Null Where R_ID=%s';
    nStr := Format(nStr, [sTable_PurSampleBatch, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurSampleEnCode, TfFramePurSampleEnCode.FrameID);



end.
