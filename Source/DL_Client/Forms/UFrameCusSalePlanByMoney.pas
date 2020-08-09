{*******************************************************************************
  作者: dmzn@163.com 2009-09-04
  描述: 销售客户限量控制（金额）
*******************************************************************************}
unit UFrameCusSalePlanByMoney;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels, UFormBase,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxSkinsCore, dxSkinsDefaultPainters, USysPopedom,
  dxSkinscxPCPainter, dxSkinsdxLCPainter, cxGridCustomPopupMenu,
  cxGridPopupMenu;

type
  TfFrameCusSalePlanByMoney = class(TfFrameNormal)
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, USysBusiness,
  UFormInputbox, Dialogs;

class function TfFrameCusSalePlanByMoney.FrameID: integer;
begin
  Result := cFI_FrameCusSalePlanByMoney;
end;

function TfFrameCusSalePlanByMoney.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From $CA Where 1=1 ';
  //xxxxx

  if Trim(EditCustomer.Text)<>'' then
    Result:= Result + 'And X_CName=''$Name''';

  Result := MacroValue(Result, [MI('$CA', sTable_CusSalePlanByMoney),
                                MI('$Name', Trim(EditCustomer.Text))]);
  //xxxxx
end;

//Desc: 执行查询  
procedure TfFrameCusSalePlanByMoney.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  InitFormData('');
end;

procedure TfFrameCusSalePlanByMoney.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand:= cCmd_AddData;
  CreateBaseFormItem(cFI_FormCusSalePlanByMoney, PopedomItem, @nParam);
  BtnRefresh.Click;
end;

procedure TfFrameCusSalePlanByMoney.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand:= cCmd_EditData;
  nParam.FParamA := SQLQuery.FieldByName('R_ID').AsString;
  CreateBaseFormItem(cFI_FormCusSalePlanByMoney, PopedomItem, @nParam);
  BtnRefresh.Click;
end;

procedure TfFrameCusSalePlanByMoney.BtnDelClick(Sender: TObject);
var nStr, nID: string;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  if not QueryDlg('确定要执行删除操作么？', sAsk) then
    Exit;

  nID := SQLQuery.FieldByName('R_ID').AsString;
  nStr := 'Delete %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_CusSalePlanByMoney, nID]);
  FDM.ExecuteSQL(nStr);
  BtnRefresh.Click;
end;

initialization
  gControlManager.RegCtrl(TfFrameCusSalePlanByMoney, TfFrameCusSalePlanByMoney.FrameID);
  
end.
