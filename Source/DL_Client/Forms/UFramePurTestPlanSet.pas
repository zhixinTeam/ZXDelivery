unit UFramePurTestPlanSet;
      
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels, IniFiles,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, dxSkinsdxLCPainter, cxContainer,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, ADODB,
  cxLabel, UBitmapPanel, cxSplitter, dxLayoutControl, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, ComCtrls, ToolWin, Provider,
  DBClient, StdCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, ExtCtrls,
  Menus, cxGridCustomPopupMenu, cxGridPopupMenu;

type
  TfFramePurTestPlanSet = class(TfFrameNormal)
    cxspltr1: TcxSplitter;
    Clmn_MName: TcxGridDBColumn;
    Clmn_MID: TcxGridDBColumn;
    Qry_Items: TADOQuery;
    Ds_Items: TDataSource;
    dxLayout1Item1: TdxLayoutItem;
    Edit_Name: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    lbl1: TLabel;
    Clmn_ID: TcxGridDBColumn;
    Panel1: TPanel;
    cxGrid2: TcxGrid;
    cxView2: TcxGridDBTableView;
    Clmn_ItemID: TcxGridDBColumn;
    Clmn_ItemName: TcxGridDBColumn;
    Clmn_ItemWhere: TcxGridDBColumn;
    cxLevel2: TcxGridLevel;
    Pnl_t: TPanel;
    btn3: TButton;
    btn4: TButton;
    Clmn_Formula: TcxGridDBColumn;
    procedure Edit_NamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure btn3Click(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure cxView2KeyPress(Sender: TObject; var Key: Char);
    procedure cxView2EditChanged(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem);
    procedure btn4Click(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure Edit_NameKeyPress(Sender: TObject; var Key: Char);
  private
    FStart,FEnd: TDate;
    //时间区间
    FWeek : string;
    FPID : string;
  private
    function RefPurTestItems : Boolean;
    function InitFormDataSQL(const nWhere: string): string; override;
  protected
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurTestPlanSet: TfFramePurTestPlanSet;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom, USysDataDict,
  USysConst, USysDB, USysBusiness, UFormDateFilter, USysLoger, USysGrid,
  UBusinessPacker;


class function TfFramePurTestPlanSet.FrameID: integer;
begin
  Result := cFI_FramePurTestPlanSet;
end;

function TfFramePurTestPlanSet.RefPurTestItems: Boolean;
VAR nStr :string;
begin
  Result:= True;
  if FPID='' then Exit;
  //******************************************
  try
    nStr := 'Select * From $PurItems Where I_PID=' + FPID ;
    nStr := MacroValue(nStr, [ MI('$PurItems', sTable_PurTestPlanItems) ]);

    FDM.QueryData(Qry_Items, nStr);
  finally
    //ClientDs1.Data:= DataSetProvider1.Data;
  end;
  //xxxxx
end;

function TfFramePurTestPlanSet.InitFormDataSQL(const nWhere: string): string;
VAR nStr :string;
begin
  Result := 'Select * From $PurTestPlan Where 1=1 ';
  Result := MacroValue(Result, [MI('$PurTestPlan', sTable_PurTestPlan)]);

  if nWhere<>'' then
    Result:= Result + ' And ' + nWhere;
  //xxxxx
  Result:= Result;
  RefPurTestItems;
end;

procedure TfFramePurTestPlanSet.OnLoadGridConfig(const nIni: TIniFile);
begin
//  gSysEntityManager.BuildViewColumn(cxView2, 'MAIN_S0201');
//  InitTableView(Name, cxView2, nIni);
end;

procedure TfFramePurTestPlanSet.Edit_NamePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  InitFormData(' P_Name like ''%'+trim(Edit_Name.Text)+'%'' ');
end;

procedure TfFramePurTestPlanSet.btn3Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    FPID:= SQLQuery.FieldByName('R_ID').AsString;
    nP.FParamA:= FPID;
    nP.FParamB:= FPID +'、'+SQLQuery.FieldByName('P_Name').AsString;

    CreateBaseFormItem(cFI_FormPurTestItemsSet, '', @nP);
    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      RefPurTestItems;
    end;
  end;
end;

procedure TfFramePurTestPlanSet.cxView1DblClick(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    FPID:= SQLQuery.FieldByName('R_ID').AsString;
    RefPurTestItems;
  end;
end;

procedure TfFramePurTestPlanSet.cxView2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;
  end;
end;

procedure TfFramePurTestPlanSet.cxView2EditChanged(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  //ClientDs1.ApplyUpdates(0);
end;

procedure TfFramePurTestPlanSet.btn4Click(Sender: TObject);
var nStr,nID: string;
begin
  if cxView2.DataController.GetSelectedCount > 0 then
  begin
    nID  := Qry_Items.FieldByName('R_ID').AsString;
    nStr := Qry_Items.FieldByName('I_ItemsName').AsString;
    nStr := Format('要删除检测项[ %s ]么?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_PurTestPlanItems, nID]);

    FDM.ExecuteSQL(nStr);
    RefPurTestItems;
  end;
end;

procedure TfFramePurTestPlanSet.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormPurTestPlanSet, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFramePurTestPlanSet.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('P_Name').AsString;
    nStr := Format('确定要删除该标准[ %s ]么?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_PurTestPlan, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

procedure TfFramePurTestPlanSet.Edit_NameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    InitFormData(' P_Name like ''%'+trim(Edit_Name.Text)+'%'' ');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurTestPlanSet, TfFramePurTestPlanSet.FrameID);



end.
