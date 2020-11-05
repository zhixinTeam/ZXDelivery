unit UFramePurSampleHYData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, ADODB,
  cxLabel, UBitmapPanel, cxSplitter, dxLayoutControl, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, ComCtrls, ToolWin, Provider,
  DBClient, StdCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, ExtCtrls,
  dxLayoutcxEditAdapters, Menus, cxGridCustomPopupMenu, cxGridPopupMenu;

type
  TfFramePurSampleHYDataEx = class(TfFrameNormal)
    Qry_TestItems: TADOQuery;
    Ds_TestItems: TDataSource;
    dxLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    lbl1: TLabel;
    ClientDs1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    cxspltr1: TcxSplitter;
    lv1: TListView;
    edt_lst: TEdit;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure edt_lstChange(Sender: TObject);
    procedure edt_lstExit(Sender: TObject);
    procedure edt_lstKeyPress(Sender: TObject; var Key: Char);
    procedure lv1Click(Sender: TObject);
    procedure lv1CustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    FStart,FEnd: TDate;
    //时间区间
    FWeek : string;
    FStdID: string;
    FPoint : TPoint;
    FCurIndex : Integer;
  private
    procedure OnCreateFrame; override;
    function RefPurTestPlanItems : Boolean;
    function InitFormDataSQL(const nWhere: string): string; override;
    function GetHZ(nLV: TListView;nFormula :string):string;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurSampleHYDataEx: TfFramePurSampleHYDataEx;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,JclExprEval,
  USysConst, USysDB, USysBusiness, UFormDateFilter, UMgrRemotePrint, USysLoger,
  UBusinessPacker, UFormPurchaseTotal, UFormPurchaseTotalUP, UListViewControl, CommCtrl;


class function TfFramePurSampleHYDataEx.FrameID: integer;
begin
  Result := cFI_FramePurSampleHYData;
end;

procedure TfFramePurSampleHYDataEx.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

function TfFramePurSampleHYDataEx.RefPurTestPlanItems: Boolean;
var nItem : TStrings;
    nStr, nItemName : string;
begin
  Result:= True;
  try
    lv1.Clear;
    nItem := TStringList.Create;
    //******************************************
    nStr := 'Select * From $TestPlanItems Where I_PID=''$TestPID'' ';
    nStr := MacroValue(nStr, [MI('$TestPlanItems', sTable_PurTestPlanItems),
                              MI('$TestPID', FStdID)  ]);

    FDM.QueryData(Qry_TestItems, nStr);
    with Qry_TestItems do
    begin
      First;
      while not Eof do
      begin
        nItem.Clear;

        nItemName:= FieldByName('I_ItemsName').AsString;
        nItem.Add('');
        nItem.Add(FieldByName('I_Where').AsString);
        nItem.Add(FieldByName('I_Formula').AsString);
        //*************
        TListViewControl.AddItem(lv1, nItemName, nItem);

        Next;
      end;
    end;
  finally
    nItem.Free;
  end;
  //xxxxx
end;

function TfFramePurSampleHYDataEx.InitFormDataSQL(const nWhere: string): string;
VAR nYear, nMonth, nPreMonth:string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  //**************
  Result := 'Select * From $SampleBatch '+
            'Where S_Encode<>'''' And S_Date>=''$STime'' And S_Date<''$ETime'' ' ;

  Result := MacroValue(Result, [
              MI('$SampleBatch', sTable_PurSampleBatch),
              MI('$UMan', gSysParam.FUserName),
              MI('$STime', Date2Str(FStart)), MI('$ETime', Date2Str(FEnd + 1))]);
  //xxxx
end;

procedure TfFramePurSampleHYDataEx.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFramePurSampleHYDataEx.cxView1CellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  if cxView1.ViewData.RecordCount<=0 then Exit;
  
  FStdID:= SQLQuery.FieldByName('S_StdID').AsString;
  RefPurTestPlanItems;
end;

procedure TfFramePurSampleHYDataEx.edt_lstChange(Sender: TObject);
begin
  lv1.Selected.SubItems[FCurIndex - 1] := edt_lst.Text;
end;

procedure TfFramePurSampleHYDataEx.edt_lstExit(Sender: TObject);
begin
  if edt_lst.Text <> '' then
  begin
      lv1.Selected.SubItems[FCurIndex-1] := edt_lst.Text;
  end;
  edt_lst.Visible := False;
end;

procedure TfFramePurSampleHYDataEx.edt_lstKeyPress(Sender: TObject;
  var Key: Char);
var nIdx:Integer;
    nP: TPoint;
begin
  if Key = #13 then
  begin
    Key := #0;
    edt_lst.Visible:= False;

    lv1.SetFocus;
    if lv1.ItemIndex<lv1.Items.Count-2 then
    begin
      lv1.ItemIndex := lv1.ItemIndex+1;  //设置选中

      SetCursorPos(FPoint.X,FPoint.Y+17);
    end
    else
    begin
      lv1.ItemIndex := 0;  //设置选中

      nP.X:= 150; nP.Y:= 35;
      MapWindowPoints(lv1.Handle, Handle, nP, 1);
      nP:= ClientToScreen(nP);
                                                   //Mmo_1.Lines.Add(Format('nP:%d,%d',[nP.X,nP.Y]));
      SetCursorPos(nP.X, nP.Y);
    end;

    Mouse_Event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
    Mouse_Event(MOUSEEVENTF_LEFTUP,0,0,0,0);
  end;
end;

function TfFramePurSampleHYDataEx.GetHZ(nLV: TListView;nFormula :string):string;
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

procedure TfFramePurSampleHYDataEx.lv1Click(Sender: TObject);
var
  W, X, nCount: Integer;
  Rect: TRect;
  Pos: TPoint;
  nCol: Integer;
  ColSet:set of 0..3;//屏蔽列段
  nFormula : string;
begin
  ColSet:=[0,2,3];
  if Assigned(lv1.Selected) then//判断双击的区域是否为有效区域
  begin
    if lv1.Selected.Caption='∑' then
    begin
      nFormula:= lv1.Selected.SubItems.Strings[2];
      if nFormula<>'' then
      begin
        lv1.Selected.SubItems.Strings[0] := GetHZ(lv1, nFormula);
      end;

      Exit;
    end;

    if lv1.Selected.SubItems.Strings[2]<>'' then
      Exit;

    //**********************************************************
    
      FPoint:= Mouse.CursorPos;
      Pos := lv1.ScreenToClient(Mouse.CursorPos);
    //Mmo_1.Lines.Add(Format('listPoint:%d,%d FPoint:%d,%d',[Pos.X,Pos.Y,FPoint.X,FPoint.Y]));
      nCount := lv1.Columns.Count;
      X := -GetScrollPos(lv1.Handle, SB_HORZ);

      for nCol := 0 to nCount - 1 do
      begin
        W := ListView_GetColumnWidth(lv1.Handle, nCol);
        if Pos.X <= X + W then
        begin
          Break;
        end;
        X := X + W;
      end;

      FCurIndex := nCol;
      if nCol = nCount then
      begin
        Exit;
      end;

      if (nCol in ColSet) then
      begin
        Exit; //第1,2,3,4列不允许编辑，nCol     就是选定哪一列
      end;

      if X < 0 then
      begin
        exit;
        W := W + X;
        X := 0;
      end;

      Rect := lv1.Selected.DisplayRect(drBounds);
      Pos.X := X-lv1.Left;
      Pos.Y := Rect.Top;
      MapWindowPoints(lv1.Handle, Handle, Pos, 1);

      edt_lst.SetBounds(Pos.X, Pos.Y, W-2, Rect.Bottom- Rect.Top + 2);

      edt_lst.Parent := lv1;
      edt_lst.Top  := lv1.Selected.Top;
      edt_lst.Text := lv1.Selected.SubItems[FCurIndex-1];
      edt_lst.Color:= clWhite;
      edt_lst.Visible := True;
      edt_lst.SetFocus;
  end;
end;

procedure TfFramePurSampleHYDataEx.lv1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Selected then
    Sender.Canvas.Brush.Color := $1890FF;

  if Item.Caption='∑' then
    Sender.Canvas.Brush.Color := $7FFFAA;

end;

initialization
  gControlManager.RegCtrl(TfFramePurSampleHYDataEx, TfFramePurSampleHYDataEx.FrameID);



end.
