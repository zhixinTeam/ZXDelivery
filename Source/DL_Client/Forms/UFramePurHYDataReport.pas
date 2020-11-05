unit UFramePurHYDataReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, Menus, cxGridCustomPopupMenu, cxGridPopupMenu,
  dxLayoutcxEditAdapters;

type
  TfFramePurHYDataReport = class(TfFrameNormal)
    dxLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    Edit_Name: TcxButtonEdit;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FStart, FEnd: TDate;
    //时间区间
  private
    procedure OnCreateFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurHYDataReport: TfFramePurHYDataReport;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, USysLoger,
  UBusinessPacker;


class function TfFramePurHYDataReport.FrameID: integer;
begin
  Result := cFI_FramePurHYDataReport;
end;

procedure TfFramePurHYDataReport.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

function TfFramePurHYDataReport.InitFormDataSQL(const nWhere: string): string;
VAR nStr:string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select *,(Case When H_Value Is Not Null then CAST((1-H_Value/100.0)*S_Value AS Decimal(10,2)) else Null end) TrueValue, H_Value Water '+
            'From $SampleBatch a  '+
            'Left Join (   '+
            'Select H_BatID,H_Value,H_Result,I_ItemsName,I_Where From $PurHYDateItems b '+
            'Left Join $PurTestPlanItems c On H_ItemID=c.R_ID '+
            'Where I_ItemsName=''Water'' '+
            ') x On S_BatID=H_BatID  '+
            'Where S_TestDate>=''$STime'' And S_TestDate<''$ETime'' ' ;

  if nWhere<>'' then
    Result:= Result + ' And ' + nWhere ;

  Result := MacroValue(Result, [MI('$SampleBatch', sTable_PurSampleBatch),
                                MI('$PurTestPlan', sTable_PurTestPlan),
                                MI('$PurHYDateItems', sTable_PurHYDateItems),
                                MI('$PurTestPlanItems', sTable_PurTestPlanItems),
                                MI('$STime', Date2Str(FStart)),
                                MI('$ETime', Date2Str(FEnd + 1)) ]);
  //xxxxx
  nStr:= Result;
end;

procedure TfFramePurHYDataReport.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

initialization
  gControlManager.RegCtrl(TfFramePurHYDataReport, TfFramePurHYDataReport.FrameID);




end.
