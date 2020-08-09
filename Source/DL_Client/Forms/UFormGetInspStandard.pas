unit UFormGetInspStandard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB;

type
  TfFormGetInspStandard = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    Edit_Txt: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    GridOrders: TcxGrid;
    cxView1: TcxGridDBTableView;
    cxView1Column1: TcxGridDBColumn;
    cxView1Column2: TcxGridDBColumn;
    cxLevel1: TcxGridLevel;
    btn_Search: TButton;
    dxlytmLayout1Item5: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    procedure btn_SearchClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure cxView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    FIID,FIName,FMInfo:string;
  private
    procedure InitFormData(const nWhere: string);
    //≥ı ºªØ
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormGetInspStandard: TfFormGetInspStandard;

implementation

{$R *.dfm}

uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst,
  USysBusiness;


class function TfFormGetInspStandard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormGetInspStandard.Create(Application) do
  try
    Edit_Txt.Text := nP.FParamA;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    
    nP.FParamB := FIID;
    nP.FParamC := FIName;
    nP.FParamD := FMInfo;
  finally
    Free;
  end;
end;

class function TfFormGetInspStandard.FormID: integer;
begin
  Result := cFI_FormGetInspStandard;
end;

procedure TfFormGetInspStandard.InitFormData(const nWhere: string);
var nStr : string;
    nScale:Double;
begin
  nStr := 'Select * From %s Where 1=1 ';
  nStr := Format(nStr, [sTable_PurTestPlan]);

  if nWhere <> '' then
    nStr := nStr + nWhere;
  FDM.QueryData(ADOQuery1, nStr);

  if ADOQuery1.Active and (ADOQuery1.RecordCount = 1) then
  begin
    ActiveControl := BtnOK;
  end;
end;

procedure TfFormGetInspStandard.btn_SearchClick(Sender: TObject);
var nWhere, nStr : string;
begin
  nStr:= Trim(Edit_Txt.Text);
  nWhere:= ' And ( P_Name Like ''%%'+nStr+'%%'' ) ';
  InitFormData(nWhere);
end;

procedure TfFormGetInspStandard.BtnOKClick(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    FIID  := ADOQuery1.FieldByName('R_ID').AsString;
    FIName:= ADOQuery1.FieldByName('P_Name').AsString;
  end;

  ModalResult := mrOk;
end;

procedure TfFormGetInspStandard.cxView1CellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  BtnOK.Click;
end;

initialization
  gControlManager.RegCtrl(TfFormGetInspStandard, TfFormGetInspStandard.FormID);


end.
