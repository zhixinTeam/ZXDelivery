unit UFramePurSampleHYDataEx;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, dxSkinsdxLCPainter, cxContainer,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, ADODB,
  cxLabel, UBitmapPanel, cxSplitter, dxLayoutControl, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, ComCtrls, ToolWin, Provider,
  DBClient, StdCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, ExtCtrls, Grids,
  Menus, cxGridCustomPopupMenu, cxGridPopupMenu;

type
  TParam = record
    FName : string;
    FValue: string;
    FIdx  : Integer;
  end;
  TArrParam= Array of TParam;

  TfFramePurSampleHYData = class(TfFrameNormal)
    Qry_TestItems: TADOQuery;
    Ds_TestItems: TDataSource;
    dxLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    lbl1: TLabel;
    ClientDs1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    cxspltr1: TcxSplitter;
    Pnl_1: TPanel;
    strngrd_Items: TStringGrid;
    Pnl_2: TPanel;
    btn1: TButton;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure strngrd_ItemsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strngrd_ItemsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure strngrd_ItemsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btn1Click(Sender: TObject);
  private
    FStart,FEnd: TDate;
    //时间区间
    FWeek : string;
    FStdID,FBatID: string;
    FPoint : TPoint;
    FCurIndex : Integer;
    FArrParam : TArrParam;
  private
    procedure OnCreateFrame; override;
    function RefPurHYDataItems: Boolean;
    function RefPurTestPlanItems : Boolean;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure IniStringGrid;
    function GetHZ(nLV: TListView; nFormula :string):string;
    function GetItemResult(nPreName,nPreValue, nPreWhere:string):string;
    function GetStringGridHZ(nItems: TStringGrid; nFormula :string):string;
    function SortItemsToArr(nItems: TStringGrid):Boolean ;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurSampleHYData: TfFramePurSampleHYData;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,JclExprEval,
  USysConst, USysDB, USysBusiness, UFormDateFilter, USysLoger,
  UBusinessPacker, UListViewControl, CommCtrl;


class function TfFramePurSampleHYData.FrameID: integer;
begin
  Result := cFI_FramePurSampleHYData;
end;

procedure TfFramePurSampleHYData.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  IniStringGrid;
end;

procedure TfFramePurSampleHYData.IniStringGrid;
begin
  //strngrd_Items.RowCount := 0;
  //***************
  strngrd_Items.Cells[0, 0] := '检测项';
  strngrd_Items.Cells[1, 0] := '检测值';
  strngrd_Items.Cells[2, 0] := '检测结果';
  strngrd_Items.Cells[3, 0] := '条件';
  strngrd_Items.Cells[4, 0] := '公式';
  strngrd_Items.Cells[5, 0] := 'ItemID';

  strngrd_Items.ColWidths[0] := 123;
  strngrd_Items.ColWidths[1] := 80;
  strngrd_Items.ColWidths[2] := 100;
  strngrd_Items.ColWidths[3] := 123;
  strngrd_Items.ColWidths[4] := 200;
  strngrd_Items.ColWidths[5] := 0;
end;

function TfFramePurSampleHYData.RefPurHYDataItems: Boolean;
var nItem : TStrings;
    nStr, nItemName : string;
    nRow, nCol : Integer;
begin
  Result:= True;
  try
    nItem := TStringList.Create;
    //******************************************
    nStr := 'Select b.R_ID ItemID, * From $PurHYDateItems a '+
            'Left Join $Items b On a.H_ItemID=b.R_ID ' +
            'Where H_BatID=''$BatID'' ';
    nStr := MacroValue(nStr, [MI('$PurHYDateItems', sTable_PurHYDateItems),
                              MI('$Items', sTable_PurTestPlanItems),
                              MI('$BatID', FBatID)  ]);

    FDM.QueryData(Qry_TestItems, nStr);
    with Qry_TestItems do
    begin
      First;

      strngrd_Items.RowCount:= RecordCount + 1;
      for nRow:= 1 to RecordCount do
      begin
        strngrd_Items.Cells[0,nRow]:= FieldByName('I_ItemsName').AsString;
        strngrd_Items.Cells[1,nRow]:= FieldByName('H_Value').AsString;
        strngrd_Items.Cells[2,nRow]:= FieldByName('H_Result').AsString;
        strngrd_Items.Cells[3,nRow]:= FieldByName('I_Where').AsString;
        strngrd_Items.Cells[4,nRow]:= FieldByName('I_Formula').AsString;
        strngrd_Items.Cells[5,nRow]:= FieldByName('ItemID').AsString;
        Next;
      end;
    end;
  finally
    nItem.Free;
  end;
end;


function TfFramePurSampleHYData.RefPurTestPlanItems: Boolean;
var nItem : TStrings;
    nStr, nItemName : string;
    nRow, nCol : Integer;
begin
  Result:= True;
  try
    nItem := TStringList.Create;
    //******************************************
    nStr := 'Select * From $TestPlanItems Where I_PID=''$TestPID'' ';
    nStr := MacroValue(nStr, [MI('$TestPlanItems', sTable_PurTestPlanItems),
                              MI('$TestPID', FStdID)  ]);

    FDM.QueryData(Qry_TestItems, nStr);
    with Qry_TestItems do
    begin
      First;

      strngrd_Items.RowCount:= RecordCount+1;
      for nRow:= 1 to RecordCount do
      begin
        strngrd_Items.Cells[0,nRow]:= FieldByName('I_ItemsName').AsString;
        strngrd_Items.Cells[1,nRow]:= '';
        strngrd_Items.Cells[2,nRow]:= '';
        strngrd_Items.Cells[3,nRow]:= FieldByName('I_Where').AsString;
        strngrd_Items.Cells[4,nRow]:= FieldByName('I_Formula').AsString;
        strngrd_Items.Cells[5,nRow]:= FieldByName('R_ID').AsString;

        Next;
      end;
    end;
  finally
    nItem.Free;
  end;
  //xxxxx
end;

function TfFramePurSampleHYData.InitFormDataSQL(const nWhere: string): string;
VAR nYear, nMonth, nPreMonth:string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  //**************
  Result := 'Select * From $SampleBatch '+
            'Where S_Date>=''$STime'' And S_Date<''$ETime'' '
            {$IFNDEF PurHYNoUseEncode}+'And S_Encode<>'''''{$ENDIF} ;

  Result := MacroValue(Result, [
              MI('$SampleBatch', sTable_PurSampleBatch),
              MI('$UMan', gSysParam.FUserName),
              MI('$STime', Date2Str(FStart)), MI('$ETime', Date2Str(FEnd + 1))]);
  //xxxx
end;

procedure TfFramePurSampleHYData.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFramePurSampleHYData.cxView1CellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  if cxView1.ViewData.RecordCount<=0 then Exit;

  FStdID:= SQLQuery.FieldByName('S_StdID').AsString;
  FBatID:= SQLQuery.FieldByName('S_BatID').AsString;
  //***********
  if SQLQuery.FieldByName('S_Test').AsString='Y' then
       RefPurHYDataItems
  else RefPurTestPlanItems;
end;

function TfFramePurSampleHYData.GetHZ(nLV: TListView;nFormula :string):string;
var nIdx, I:Integer;
    nEvaluator: TCompiledEvaluator;
    nName,nValue :string;
    nReValue:Double;
begin
  Result:= '';
  nEvaluator:= TCompiledEvaluator.Create;
  try
    for I := 0 to nLV.Items.Count - 1 do
    begin
      if nLV.Items[I].Caption = '' then Continue;
      if nLV.Items[I].Caption = '∑' then Continue;

      nName := nLV.Items[I].Caption;
      nValue:= nLV.Items[I].SubItems[0];

      if nValue='' then
        Exit;

      nFormula:= StringReplace(nFormula, nName, nValue, [rfReplaceAll]);
    end;

    try
      nEvaluator.Compile(nFormula);
      nReValue:= nEvaluator.Evaluate;
      Result:= Format('%2f',[nReValue]);
    except
      ShowMsg('进行公式计算时发生错误', '提示');
    end;
  except
    ShowMsg('进行公式计算时发生错误', '提示');
  end;
end;

function TfFramePurSampleHYData.GetItemResult(nPreName,nPreValue, nPreWhere:string):string;
var nStr:string;
begin
  try
    if (Pos('≥', nPreWhere)=1)or
        (Pos('≤', nPreWhere)=1) then
    begin
      nPreWhere:= nPreName + nPreWhere;
    end;

    nStr := StringReplace(nPreWhere, nPreName, nPreValue, [rfReplaceAll]);
    nStr := StringReplace(nStr, '≥', '>=', [rfReplaceAll]);
    nStr := StringReplace(nStr, '≤', '<=', [rfReplaceAll]);
    nStr := 'Select  Case When ' + nStr + ' Then ''合格'' Else ''不合格'' End';

    with FDM.QueryTemp(nStr) do
    begin
      First;
      Result:= Fields[0].AsString;
    end;
  except
    ShowMsg('计算单项值时、发生错误：' + nStr, '提示');
  end;
end;

function TfFramePurSampleHYData.SortItemsToArr(nItems: TStringGrid):Boolean ;
  function GetItemIdx(nItem:string;nArr : TArrParam):Integer;
  var i : Integer;
  begin
    Result:= 0;
    for i:= 0 to Length(nArr)-1 do
    begin
      if (Pos(nItem, FArrParam[i].FName)>0)AND
          (nItem<>FArrParam[i].FName) then
        Result:= Result + 1;
    end;
  end;

  // 按被包含次数从最小到大排序
  procedure InsertSort(var N : TArrParam);
  var
    I,J:Integer;
    nTem:TParam;
  begin
     for I := 1 to High(N) do
     begin
       for J := I downto 1 do
       begin
         if N[J-1].FIdx>N[J].FIdx then
         begin
           nTem  := N[J-1];
           N[J-1]:= N[J];
           N[J]  := nTem;
         end;
       end;
     end;
  end;

var nCol, nRow:Integer;
begin
  Result:= True;
  SetLength(FArrParam, nItems.RowCount);

  for nRow := 0 to nItems.RowCount - 1 do
  begin
    for nCol := 0 to nItems.ColCount - 1 do
    begin
      FArrParam[nRow].FName := nItems.Cells[0, nRow];
      FArrParam[nRow].FValue:= nItems.Cells[1, nRow];
      FArrParam[nRow].FIdx  := 0;
    end;
  end;

  for nRow:= 0 to Length(FArrParam)-1 do
  begin
    FArrParam[nRow].FIdx := GetItemIdx(FArrParam[nRow].FName, FArrParam);
  end;

  InsertSort(FArrParam);
end;

function TfFramePurSampleHYData.GetStringGridHZ(nItems: TStringGrid; nFormula:string):string;
var nCol, nRow:Integer;
    nEvaluator: TCompiledEvaluator;
    nName,nValue :string;
    nReValue:Double;
begin
  Result:= '';
  nEvaluator:= TCompiledEvaluator.Create;
  try
    SortItemsToArr(nItems);
    for nRow := 0 to High(FArrParam) do
    begin
        if FArrParam[nRow].FValue = '' then Continue;

        nName := FArrParam[nRow].FName;
        nValue:= FArrParam[nRow].FValue;

        if nValue='' then
          Exit;

        nFormula:= StringReplace(nFormula, nName, nValue, [rfReplaceAll]);
    end;

    nFormula:= StringReplace(nFormula, '=', '', [rfReplaceAll]);
    try
      nEvaluator.Compile(nFormula);
      nReValue:= nEvaluator.Evaluate;
      Result:= Format('%2f',[nReValue]);
    except
      ShowMsg('进行公式计算时发生错误、需检查是否完全录入了公式所需项数值', '提示');
    end;
  except
    ShowMsg('进行公式计算时发生错误', '提示');
  end;
end;

procedure TfFramePurSampleHYData.strngrd_ItemsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var nFormula,nPreName,nPreValue,nPreWhere : string;
    nCol, nRow, nPreRow : Integer;
begin
  case Key of
    VK_RETURN:
//      if TStringGrid(Sender).Col + 1 < TStringGrid(Sender).ColCount then
//        TStringGrid(Sender).Col := TStringGrid(Sender).Col + 1
//      else
      begin
        TStringGrid(Sender).Col := TStringGrid(Sender).FixedCols;
        if TStringGrid(Sender).Row + 1 < TStringGrid(Sender).RowCount then
             TStringGrid(Sender).Row := TStringGrid(Sender).Row + 1
        else TStringGrid(Sender).Row := TStringGrid(Sender).FixedRows;

        nCol:= TStringGrid(Sender).Col;
        nRow:= TStringGrid(Sender).Row;
        nFormula := strngrd_Items.Cells[4, nRow];

        if nRow>0 then
        begin
          nPreRow:= nRow-1;
          nPreValue:= strngrd_Items.Cells[1, nPreRow];
          nPreWhere:= strngrd_Items.Cells[3, nPreRow];
          nPreName := strngrd_Items.Cells[0, nPreRow];

          if ((nPreWhere<>'')and(nPreWhere<>'条件'))and
              (TStringGrid(Sender).Cells[1, nPreRow]<>'') then
          begin
            TStringGrid(Sender).Options := TStringGrid(Sender).Options - [goEditing];
            TStringGrid(Sender).Cells[2, nPreRow]:= GetItemResult(nPreName,nPreValue,nPreWhere);
            //单项判定
          end;

          if (nFormula<>'')and(TStringGrid(Sender).Cells[1, nRow-1]<>'') then
          begin
            //TStringGrid(Sender).Options := TStringGrid(Sender).Options - [goEditing];
            TStringGrid(Sender).Cells[1, nRow]:= GetStringGridHZ(strngrd_Items, nFormula);
            //公式计算
          end;
        end;
      end;
  end;
end;

procedure TfFramePurSampleHYData.strngrd_ItemsDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var nFontColor,nBrushColor:TColor;
begin
  try
    nFontColor := clBlack;   
    nBrushColor:= clWhite;

    with Sender as TStringGrid do
    begin
      if (Cells[0, ARow]='∑')or(Cells[4, ARow]<>'') then
      begin
        nFontColor := clBlack;   //字体颜色
        nBrushColor:= clBtnFace; //背景  合格绿  4DC86F     不合格红  FF0000
      end;

      if (Cells[2, ARow]='不合格') then
      begin
        nFontColor := clWhite;   //字体颜色
        nBrushColor:= $000000FF; //背景  合格绿  4DC86F     不合格红  FF0000
      end;
      if (Cells[2, ARow]='合格') then
      begin
        nFontColor := clWhite;   //字体颜色
        nBrushColor:= $006FC84D; //背景  合格绿  4DC86F     不合格红  FF0000
      end;
    end;

    if ARow=0 then
    begin
      nFontColor := clWhite;   //字体颜色
      nBrushColor:= $00B96D3E; //背景  合格绿  4DC86F     不合格红  FF0000
    end;
  finally
    with Sender as TStringGrid do
    begin
      Canvas.Font.Color := nFontColor;   //字体颜色
      Canvas.Brush.color:= nBrushColor;  //背景  合格绿  4DC86F     不合格红  FF0000
      Canvas.FillRect(Rect);
      Canvas.TextOut(Rect.Left+2,Rect.Top+2,strngrd_Items.Cells[acol,ARow]);
    end;
  end;
end;

procedure TfFramePurSampleHYData.strngrd_ItemsSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  TStringGrid(Sender).Options := TStringGrid(Sender).Options - [goEditing];

  if ACol=1 then
  begin
    if (strngrd_Items.Cells[0,ARow]<>'∑') then
    begin
      TStringGrid(Sender).Options := TStringGrid(Sender).Options + [goEditing];
    end;
  end;
end;

procedure TfFramePurSampleHYData.btn1Click(Sender: TObject);
var nCol,nRow,nIdx:Integer;
    nStr, nItemID,nValue,nResult : string;
    nlist:TStrings;
begin
  nlist:= TStringList.Create;

  nStr := 'Delete %s Where H_BatID=''%s'' ';
  nStr := Format(nStr, [sTable_PurHYDateItems, FBatID]);
  nlist.Add(nStr);
  //**********
  for nRow := 1 to strngrd_Items.RowCount-1 do
  begin
    nItemID := strngrd_Items.Cells[5,nRow];        // strngrd_Items.Cells[nCol,nRow]
    nValue  := strngrd_Items.Cells[1,nRow];
    nResult := strngrd_Items.Cells[2,nRow];

    nStr := 'Insert Into %s(H_BatID,H_ItemID,H_Value,H_Result) ' +
                    'Values(''%s'', ''%s'', ''%s'', ''%s'') ';
    nStr := Format(nStr, [sTable_PurHYDateItems,FBatID, nItemID, nValue, nResult]);
    nlist.Add(nStr);
  end;

  nStr := 'UPDate %s Set S_Test=''Y'',S_TestMan=''%s'',S_TestDate=GetDate() ' +
          'Where S_BatID=''%s'' ';
  nStr := Format(nStr, [sTable_PurSampleBatch, gSysParam.FUserName ,FBatID]);
  nlist.Add(nStr);
  /// 更新组批化验录入信息

  FDM.ADOConn.BeginTrans;
  try
    for nIdx:= 0 to nlist.Count - 1 do
      FDM.ExecuteSQL(nlist[nIdx]);

    FDM.ADOConn.CommitTrans;
    ShowMsg('已保存数据', '提示');
    BtnRefresh.Click;
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('保存数据失败', '提示');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurSampleHYData, TfFramePurSampleHYData.FrameID);



end.
