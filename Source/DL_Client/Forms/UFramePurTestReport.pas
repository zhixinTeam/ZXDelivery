unit UFramePurTestReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, StdCtrls,
  dxLayoutControl, cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, Menus, cxGridCustomPopupMenu, cxGridPopupMenu,
  dxLayoutcxEditAdapters;

type
  TfFramePurTestReport = class(TfFrameNormal)
    dxLayout1Item1: TdxLayoutItem;
    Edit_Name: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    lbl1: TLabel;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    Qry_ItemData: TADOQuery;
    Ds_ItemData: TDataSource;
    cxLevel_2: TcxGridLevel;
    cxView_2: TcxGridDBTableView;
    Clmn_1: TcxGridDBColumn;
    Clmn_2: TcxGridDBColumn;
    Clmn_3: TcxGridDBColumn;
    procedure Edit_NamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxView_2CustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  private
    FStart, FEnd: TDate;
    //时间区间
  private
    procedure OnCreateFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    function RefPurTestItemsHYData: Boolean;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurTestReport: TfFramePurTestReport;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, USysLoger,
  UBusinessPacker;


class function TfFramePurTestReport.FrameID: integer;
begin
  Result := cFI_FramePurTestReport;
end;

procedure TfFramePurTestReport.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

function TfFramePurTestReport.RefPurTestItemsHYData: Boolean;
var nStr :string;
begin
  Result:= True;
  //******************************************
  nStr := 'Select a.R_ID HID, * From $PurHYDate a Left Join $PurTestPlanItems b On a.H_ItemID=B.R_ID ' +
          'Where 1=1 ';
  nStr := MacroValue(nStr, [ MI('$PurHYDate', sTable_PurHYDateItems),
                             MI('$PurTestPlanItems', sTable_PurTestPlanItems) ]);

  FDM.QueryData(Qry_ItemData, nStr);
end;

function TfFramePurTestReport.InitFormDataSQL(const nWhere: string): string;
VAR nYear, nMonth, nPreMonth:string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $SampleBatch a Left Join $PurTestPlan b On S_StdID=b.R_ID '+
            'Where S_TestDate>=''$STime'' And S_TestDate<''$ETime'' ' ;

  if nWhere<>'' then
    Result:= Result + ' And ' + nWhere ;

  Result := MacroValue(Result, [MI('$SampleBatch', sTable_PurSampleBatch),
                                MI('$PurTestPlan', sTable_PurTestPlan),
                                MI('$STime', Date2Str(FStart)),
                                MI('$ETime', Date2Str(FEnd + 1)) ]);
  //xxxxx
  RefPurTestItemsHYData;
end;

procedure TfFramePurTestReport.Edit_NamePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nStr: string;
begin
  nStr:= '((S_ProName=''$Data'') or (S_MName=''$Data'') or (S_BatID=''$Data''))';
  nstr:= MacroValue(nStr, [ MI('$Data', Trim(Edit_Name.Text))  ]);
  InitFormData(nstr);
end;

procedure TfFramePurTestReport.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;


procedure TfFramePurTestReport.cxView_2CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if (AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('H_Result').Index])='不合格' then
  begin
    ACanvas.Canvas.Font.Color := clWhite;
    ACanvas.Canvas.Brush.Color:= clRed;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurTestReport, TfFramePurTestReport.FrameID);



end.
