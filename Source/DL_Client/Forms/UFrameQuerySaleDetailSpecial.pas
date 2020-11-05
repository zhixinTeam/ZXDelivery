{*******************************************************************************
  作者: dmzn@163.com 2012-03-26
  描述: 发货明细        振新假账套删除、批量调拨用
*******************************************************************************}
unit UFrameQuerySaleDetailSpecial;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, IniFiles, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxSkinsCore, dxSkinsDefaultPainters, UFormBase,
  dxSkinscxPCPainter, cxGridCustomPopupMenu,
  cxGridPopupMenu, dxLayoutcxEditAdapters;

type
  TfFrameSaleDetailQuerySpecial = class(TfFrameNormal)
    cxtxtdt1: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxtxtdt2: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    pmPMenu1: TPopupMenu;
    mniN1: TMenuItem;
    cxtxtdt3: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxtxtdt4: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditBill: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure mniN1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FJBWhere: string;
    //交班条件
    FValue,FMoney: Double;
    //均价参数
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //查询SQL
    procedure SummaryItemsGetText(Sender: TcxDataSummaryItem;
      const AValue: Variant; AIsFooter: Boolean; var AText: String);
    //处理摘要
    function GetVal(const nRow: Integer; const nField: string): string;
    //获取指定字段
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormDateFilter, USysPopedom, USysBusiness,
  UBusinessConst, USysConst, USysDB, UDataModule, UFormInputbox;

class function TfFrameSaleDetailQuerySpecial.FrameID: integer;
begin
  Result := cFI_FrameSaleDetailQuerySpecial;
end;

procedure TfFrameSaleDetailQuerySpecial.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
  N2.Visible := False;
  {$IFDEF SendUnLoadPlace}
  if gSysParam.FIsAdmin then
    N2.Visible := True;
  {$ENDIF}
end;

procedure TfFrameSaleDetailQuerySpecial.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);            
  inherited;
end;

procedure TfFrameSaleDetailQuerySpecial.OnLoadGridConfig(const nIni: TIniFile);
var i,nCount: Integer;
begin
  with cxView1.DataController.Summary do
  begin
    nCount := FooterSummaryItems.Count - 1;
    for i:=0 to nCount do
      FooterSummaryItems[i].OnGetText := SummaryItemsGetText;
    //绑定事件

    nCount := DefaultGroupSummaryItems.Count - 1;
    for i:=0 to nCount do
      DefaultGroupSummaryItems[i].OnGetText := SummaryItemsGetText;
    //绑定事件
  end;

  inherited;
end;

function TfFrameSaleDetailQuerySpecial.InitFormDataSQL(const nWhere: string): string;
begin
  {$IFDEF EnableBackupDB} FEnableBackDB := True; {$ENDIF}
  //启用备份数据库
  {$IFDEF UseSelectDateTime}
  EditDate.Text := Format('%s 至 %s', [DateTime2Str(FStart), DateTime2Str(FEnd)]);
  {$ELSE}
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  {$ENDIF}

  {$IFDEF CastMoney}
  Result := 'Select *,CAST((L_Value * L_Price) as decimal(38, 2)) as L_Money, ' +
            {$IFDEF UseFreight}
            'L_Price-L_Freight as L_NetPrice,(L_Price-L_Freight)*L_Value as L_NetMoney,'+
            'L_Value*L_Freight as TotalFreight,L_Value-L_MValue+L_PValue as ValueDiff,'+
            {$ENDIF}
            '(P_MValue-P_PValue) As P_NetWeight From $Bill b ' +
            'left join $Pound P on P.P_Bill = b.L_ID '+
            'left join S_ZhiKa z on b.L_ZhiKa=z.Z_ID ';
  {$ELSE}
  Result := 'Select *,(L_Value*L_Price) as L_Money From $Bill b ';
  {$ENDIF}

  if FJBWhere = '' then
  begin
    Result := Result + 'Where (L_OutFact>=''$S'' and L_OutFact <''$End'')';

    if nWhere <> '' then
      Result := Result + ' And (' + nWhere + ')';
    //xxxxx
  end else
  begin
    Result := Result + ' Where (' + FJBWhere + ')';
  end;
  {$IFDEF UseSelectDateTime}
    {$IFDEF CastMoney}
    Result := MacroValue(Result, [MI('$Bill', sTable_Bill), MI('$Pound', sTable_PoundLog),
              MI('$S', DateTime2Str(FStart)), MI('$End', DateTime2Str(FEnd))]);
    {$ELSE}
    Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
              MI('$S', DateTime2Str(FStart)), MI('$End', DateTime2Str(FEnd))]);
    {$ENDIF}
  {$ELSE}
    {$IFDEF CastMoney}
    Result := MacroValue(Result, [MI('$Bill', sTable_Bill), MI('$Pound', sTable_PoundLog),
              MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
    {$ELSE}
    Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
              MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
    {$ENDIF}
  {$ENDIF}
  //xxxxx
end;

//Desc: 过滤字段
function TfFrameSaleDetailQuerySpecial.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'L_Price;L_Money';
end;

//Desc: 日期筛选
procedure TfFrameSaleDetailQuerySpecial.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  {$IFDEF UseSelectDateTime}
  if ShowDateFilterForm(FStart, FEnd, True) then InitFormData(FWhere);
  {$ELSE}
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
  {$ENDIF}
end;

//Desc: 执行查询
procedure TfFrameSaleDetailQuerySpecial.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text,EditBill.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'b.L_Truck like ''%%%s%%''';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end;

  if Sender = EditBill then
  begin
    EditBill.Text := Trim(EditBill.Text);
    if EditBill.Text = '' then Exit;

    FWhere := 'b.L_ID like ''%%%s%%''';
    FWhere := Format(FWhere, [EditBill.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 交接班查询
procedure TfFrameSaleDetailQuerySpecial.mniN1Click(Sender: TObject);
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := '(L_OutFact>=''%s'' and L_OutFact <''%s'')';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE),
                sFlag_BillPick, sFlag_BillPost]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

//Desc: 处理均价
procedure TfFrameSaleDetailQuerySpecial.SummaryItemsGetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: String);
var nStr: string;
begin
  nStr := TcxGridDBColumn(TcxGridTableSummaryItem(Sender).Column).DataBinding.FieldName;
  try
    if CompareText(nStr, 'L_Value') = 0 then FValue := SplitFloatValue(AText);
    if CompareText(nStr, 'L_Money') = 0 then FMoney := SplitFloatValue(AText);

    if CompareText(nStr, 'L_Price') = 0 then
    begin
      if FValue = 0 then
           AText := '均价: 0.00元'
      else AText := Format('均价: %.2f元', [Round(FMoney / FValue * cPrecision) / cPrecision]);
    end;
  except
    //ignor any error
  end;
end;

procedure TfFrameSaleDetailQuerySpecial.N1Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    for nIdx := 0 to cxView1.DataController.RowCount - 1  do
    begin

      nStr := GetVal(nIdx,'L_ID');
      if nStr = '' then
        Continue;

      nList.Add(nStr);
    end;
    nStr := AdjustListStrFormat2(nList, '''', True, ',', False);
    PrintBillReport(nStr, False);
  finally
    nList.Free;
  end;
end;

//Desc: 获取nRow行nField字段的内容
function TfFrameSaleDetailQuerySpecial.GetVal(const nRow: Integer;
 const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.DataController.GetValue(
            cxView1.Controller.SelectedRows[nRow].RecordIndex,
            cxView1.GetColumnByFieldName(nField).Index);
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

procedure TfFrameSaleDetailQuerySpecial.N2Click(Sender: TObject);
var nStr,nID,nPlace: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_SPlace').AsString;
    nPlace := nStr;
    if not ShowInputBox('请输入新的发货地点:', '修改', nPlace, 100) then Exit;

    if (nPlace = '') or (nStr = nPlace) then Exit;
    //无效或一致
    nID := SQLQuery.FieldByName('L_ID').AsString;

    nStr := 'Update %s Set L_SPlace=''%s'' Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nPlace, nID]);
    FDM.ExecuteSQL(nStr);

    nStr := '销售单[ %s ]修改发货地点[ %s -> %s ].';
    nStr := Format(nStr, [nID, SQLQuery.FieldByName('L_SPlace').AsString, nPlace]);
    FDM.WriteSysLog(sFlag_BillItem, nID, nStr, False);

    InitFormData(FWhere);
    ShowMsg('发货地点修改成功', sHint);
  end;
end;

procedure TfFrameSaleDetailQuerySpecial.BtnDelClick(Sender: TObject);
var nStr, nRID, nLID: string;
    nIdx, nX : Integer;
    nList: TStrings;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  if not QueryDlg('确定要执行删除操作么？', sAsk) then
    Exit;

  nList := TStringList.Create;
  for nIdx:=0 to cxView1.DataController.GetSelectedCount - 1 do
  begin
//    nX:= cxView1.DataController.GetSelectedRowIndex(nIdx);
//    nRID := cxView1.DataController.Values[nX,cxView1.GetColumnByFieldName('R_ID').Index] ;

    nRID:= GetVal(nIdx, 'R_ID');
    if (nRID = '') then Continue;

    nStr := Format('%s;%s', [nRID, nLID]);
    nList.Add(nRID);
  end;

  nLID:= nList.text;
  nLID:= StringReplace(nLID, #$A, '', [rfReplaceAll]);
  nLID:= StringReplace(nLID, #$D, ',', [rfReplaceAll]);
  nLID:= Copy(nLID, 1, Length(nLID)-1);
  nStr := 'Delete S_Bill Where R_ID In (%s)';
  nStr := Format(nStr, [nLID]);
                         
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);

    //校正出金
    nStr := ' UPDate Sys_CustomerAccount set A_OutMoney = L_Money From( ' +
                  ' Select Sum(L_Money) L_Money, L_CusID from ( ' +
                  ' select isnull(L_Value,0) * isnull(L_Price,0) as L_Money, L_CusID from S_Bill ' +
                  ' where L_OutFact Is not Null ) t Group by L_CusID) b where A_CID = b.L_CusID ';
    FDM.ExecuteSQL(nStr);

    //校正冻结资金
    nStr := ' UPDate Sys_CustomerAccount set A_FreezeMoney = L_Money From( ' +
                  ' Select Sum(L_Money) L_Money, L_CusID from ( ' +
                  ' select isnull(L_Value,0) * isnull(L_Price,0) as L_Money, L_CusID from S_Bill ' +
                  ' where L_OutFact Is  Null ) t Group by L_CusID) b where A_CID = b.L_CusID ';
    FDM.ExecuteSQL(nStr);

    //校正冻结资金
    nStr := ' UPDate Sys_CustomerAccount Set A_FreezeMoney = 0 ' +
            ' Where A_CID  not in (select L_CusID from S_Bill Where L_OutFact Is Null Group by L_CusID ) ';
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    //
    InitFormData(FWhere);
    ShowMsg('提货单已删除', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除失败.',sHint);
    Exit;
  end;
end;


procedure TfFrameSaleDetailQuerySpecial.BtnAddClick(Sender: TObject);
var nStr:string;
    nP: TFormCommandParam;
begin
  try
    if cxView1.DataController.GetSelectedCount > 0 then
    begin
      nP.FParamA := SQLQuery.FieldByName('L_ID').AsString;
      nP.FParamB := 'Edit';
      
      CreateBaseFormItem(cFI_FormEditBill, '', @nP);
      if (nP.FParamA = mrOK) then Exit;
      
      InitFormData(FWhere);
    end;
  finally
  end;
end;

procedure TfFrameSaleDetailQuerySpecial.BtnEditClick(Sender: TObject);
var nStr:string;
    nP: TFormCommandParam;
begin
  try
    if cxView1.DataController.GetSelectedCount > 0 then
    begin
      nP.FParamA := SQLQuery.FieldByName('L_ID').AsString;
      nP.FParamB := 'Allocation';

      CreateBaseFormItem(cFI_FormEditBill, '', @nP);
      if (nP.FParamA = mrOK) then Exit;

      InitFormData(FWhere);
    end;
  finally
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSaleDetailQuerySpecial, TfFrameSaleDetailQuerySpecial.FrameID);

end.
