unit UFramePurSampleBatch;

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
  DBClient, StdCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, cxCheckBox,
  ExtCtrls, Menus, cxGridCustomPopupMenu, cxGridPopupMenu;

type
  TfFramePurSampleBatch = class(TfFrameNormal)
    cxGrid2: TcxGrid;
    cxViewOrderDtl: TcxGridDBTableView;
    cxLevel2: TcxGridLevel;
    Qry_Sample: TADOQuery;
    Ds_Sample: TDataSource;
    dxLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    lbl1: TLabel;
    ClientDs1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    Clmn_Chk1: TcxGridDBColumn;
    Clmn_TruckNo: TcxGridDBColumn;
    Clmn_Provider: TcxGridDBColumn;
    Clmn_MName: TcxGridDBColumn;
    Clmn_OutDate: TcxGridDBColumn;
    Clmn_ID: TcxGridDBColumn;
    pnl1: TPanel;
    chk1: TCheckBox;
    Clmn_ProID: TcxGridDBColumn;
    Clmn_MID: TcxGridDBColumn;
    Clmn_Value: TcxGridDBColumn;
    cxLevel_Dtl: TcxGridLevel;
    cxView_Dtl: TcxGridDBTableView;
    Clmn_DID: TcxGridDBColumn;
    Clmn_ProName: TcxGridDBColumn;
    Clmn_MetName: TcxGridDBColumn;
    Clmn_xValue: TcxGridDBColumn;
    Qry_Dtl: TADOQuery;
    Ds_Dtl: TDataSource;
    Clmn_xTruck: TcxGridDBColumn;
    Clmn_OutTime: TcxGridDBColumn;
    Clmn_BatID: TcxGridDBColumn;
    cxspltr1: TcxSplitter;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxViewOrderDtlCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxViewOrderDtlMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure chk1Click(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure cxViewOrderDtlCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    FStart,FEnd: TDate;
    //时间区间
    FCurrCol, FNum:Integer;
    FID, FBatID : string;
    FRefDtl:Boolean;
  private
    procedure OnCreateFrame; override;
    function RefPurSampleBatch : Boolean;
    function RefPurBatDtl: Boolean;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure SelectAll(nAll: Boolean);
    function  IsSelectOne : Boolean;
    function  GetSelectInfo(var nIDs,nProID,nProName,nMID,nMName,nValue,nTrucks:string) : Boolean;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurSampleBatch: TfFramePurSampleBatch;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, USysLoger,
  UBusinessPacker;


class function TfFramePurSampleBatch.FrameID: integer;
begin
  Result := cFI_FramePurSampleBatch;
end;

procedure TfFramePurSampleBatch.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

function TfFramePurSampleBatch.RefPurSampleBatch: Boolean;
var nStr :string;
begin
  Result:= True;
  //******************************************
  try
    nStr := 'Select 0 Chk,* From $OrderDtl  '+
            'Where D_OutFact>=''$STime'' And D_OutFact<''$ETime'' Order by D_OutFact ';

    nStr := MacroValue(nStr, [MI('$OrderDtl', sTable_OrderDtl), MI('$RMan', gSysParam.FUserName),
                              MI('$STime', Date2Str(FStart)),   MI('$ETime', Date2Str(FEnd + 1)) ]);

    FDM.QueryData(Qry_Sample, nStr);
    //xxxxx
  finally
    ClientDs1.Data:= DataSetProvider1.Data;
  end;
end;

function TfFramePurSampleBatch.RefPurBatDtl: Boolean;
var nStr :string;
begin
  Result:= True;
  //******************************************
  nStr := 'Select * From $OrderDtl Where D_BatID is Not Null ';
  nStr := MacroValue(nStr, [ MI('$OrderDtl', sTable_OrderDtl) ]);

  FDM.QueryData(Qry_Dtl, nStr);
end;

function TfFramePurSampleBatch.InitFormDataSQL(const nWhere: string): string;
VAR nYear, nMonth, nPreMonth:string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $SampleBatch '+
            'Where S_Date>=''$STime'' And S_Date<''$ETime'' ' ;

  Result := MacroValue(Result, [MI('$SampleBatch', sTable_PurSampleBatch),
                            MI('$UMan', gSysParam.FUserName),
                            MI('$STime', Date2Str(FStart)), MI('$ETime', Date2Str(FEnd + 1))]);
  //xxxxx
  Result:= Result;

  if FRefDtl then RefPurSampleBatch;
  RefPurBatDtl;
end;

procedure TfFramePurSampleBatch.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  FRefDtl:= True;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFramePurSampleBatch.cxViewOrderDtlCellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  FCurrCol:= ACellViewInfo.Item.Index;
//  with Ds_Sample.DataSet do
//  begin
//    ClientDs1.Edit;
//    if FieldByName('Chk').AsInteger=0 then
//       FieldByName('Chk').AsInteger:= 1
//    else FieldByName('Chk').AsInteger:= 0;
//    ClientDs1.Post;
//  end;
end;

procedure TfFramePurSampleBatch.cxViewOrderDtlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var nRow: Integer;
begin
  if cxViewOrderDtl.ViewData.RecordCount<=0 then Exit;
  if FCurrCol = 0 then
  begin
    nRow := cxViewOrderDtl.DataController.FocusedRowIndex;

    if cxViewOrderDtl.ViewData.Records[nRow].Values[9]=null then
    begin
      if cxViewOrderDtl.ViewData.Records[nRow].Values[0] = '1' then
      begin
        cxViewOrderDtl.ViewData.Records[nRow].Values[0] := '0';
        FID := StringReplace(FID, ',' + cxViewOrderDtl.ViewData.Records[nRow].Values[1], '', [rfReplaceAll]);

        //if FID='' then FCusName:= '';
      end
      else
      begin
        cxViewOrderDtl.ViewData.Records[nRow].Values[0] := '1';
        FID   := FID + ',' + cxViewOrderDtl.ViewData.Records[nRow].Values[1];
        //FCusName := cxViewOrderDtl.ViewData.Records[nRow].Values[2] ;
      end;
    end
    else ShowMessage('该记录已组批、禁止再次选择');
  end;
end;

procedure TfFramePurSampleBatch.SelectAll(nAll: Boolean);
var nIdx:Integer;
begin
  for nIdx:= 0 to cxViewOrderDtl.ViewData.RecordCount-1 do
  begin
    if cxViewOrderDtl.ViewData.Records[nIdx].Values[9]<>null then
      Continue;

    if nAll then
      cxViewOrderDtl.ViewData.Records[nIdx].Values[0] := '1'
    else cxViewOrderDtl.ViewData.Records[nIdx].Values[0] := '0';
  end;
end;

procedure TfFramePurSampleBatch.chk1Click(Sender: TObject);
begin
  SelectAll(chk1.Checked);
end;

function TfFramePurSampleBatch.IsSelectOne : Boolean;
var nIdx:Integer;
begin
  Result:= False;
  for nIdx:= 0 to cxViewOrderDtl.ViewData.RecordCount-1 do
  begin
    if cxViewOrderDtl.ViewData.Records[nIdx].Values[0]='1' then
    begin
      Result:= True;
      Break;
    end;
  end;
end;

function TfFramePurSampleBatch.GetSelectInfo(var nIDs,nProID,nProName,nMID,nMName,nValue,nTrucks:string) : Boolean;
var nIdx, nSelect:Integer;
    nValuex:Double;
    nTruck:string;
begin
  Result:= False; nValuex:= 0;  FNum:= 0;
  //***********
  for nIdx:= 0 to cxViewOrderDtl.ViewData.RecordCount-1 do
  begin
    if cxViewOrderDtl.ViewData.Records[nIdx].Values[0]='1' then
    begin
      nSelect:= nSelect + 1;
      if nSelect<=4 then
      begin
        nTruck:= cxViewOrderDtl.ViewData.Records[nIdx].Values[2];
        if nTrucks='' then
             nTrucks := nTruck
        else
        begin
          if Pos(nTruck, nTrucks)=0 then
            nTrucks := nTrucks +'、'+ nTruck;
        end;
      end;

      FNum:= FNum + 1;
      if nIDs='' then nIDs:= cxViewOrderDtl.ViewData.Records[nIdx].Values[1]
      else nIDs:= nIDs +','+ cxViewOrderDtl.ViewData.Records[nIdx].Values[1];

      nProID  := cxViewOrderDtl.ViewData.Records[nIdx].Values[7];
      nProName:= cxViewOrderDtl.ViewData.Records[nIdx].Values[4];
      nMID    := cxViewOrderDtl.ViewData.Records[nIdx].Values[8];
      nMName  := cxViewOrderDtl.ViewData.Records[nIdx].Values[5];

      nValuex := nValuex + StrToFloat(cxViewOrderDtl.ViewData.Records[nIdx].Values[3]);
    end;
  end;

  if nSelect>4 then nTrucks:= nTrucks + '...';
  nValue:= FloatToStr(nValuex);
  Result:= True;
end;

procedure TfFramePurSampleBatch.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
    nStr,nIDs,nProID,nProName,nMID,nMName,nValue,nTrucks : string;
begin
  IF cxViewOrderDtl.ViewData.RecordCount<=0 then
  begin
    ShowMsg('请先筛选取样组批的记录', '提示');
    Exit;
  end;
  IF not IsSelectOne then
  begin
    ShowMsg('请先选择取样组批的记录', '提示');
    Exit;
  end;

  GetSelectInfo(nIDs,nProID,nProName,nMID,nMName,nValue,nTrucks);
  nIDs:= StringReplace(nIDs, ',', ''',''', [rfReplaceAll]);
  nIDs:= PackerEncodeStr( '''' + nIDs + '''' );
  //*************
  nStr := Format('%s,%s,%s,%s,%s,%s,%s,%s', [nProID,nProName,nMID,nMName,nValue,nTrucks,nIDs,IntToStr(FNum)]);
  nP.FParamA := StringReplace(nStr, ' ', '@', [rfReplaceAll]);
  CreateBaseFormItem(cFI_FormPurSampleBatch, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    FRefDtl:= False;
    InitFormData('');
  end;
end;

procedure TfFramePurSampleBatch.cxViewOrderDtlCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
VAR nStr:string;
begin
  inherited;
//  if FCurrHitTest<>nil then
//  if FCurrHitTest is TcxGridRecordCellHitTest then
//  begin
//    nHitTest:= AViewInfo.GetHitTest(nP);
//    if nHitTest<>nil then
//    if FCurrHitTest.Pos.Y= nHitTest.Pos.Y then
//      ACanvas.canvas.brush.color:= $C0C0C0;
//  end;

  if (AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('Chk').Index])='1' then
    ACanvas.Canvas.Font.Color := $4FA5FF;  //$C0C0C0;

  if (AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('D_BatID').Index])<>null then
    ACanvas.Canvas.Font.Color := $C0C0C0;

//  if AViewInfo.Focused then
//  begin
//    ARec := AViewInfo.Bounds;
//    ACanvas.canvas.brush.color:= $C0C0C0;
//    ACanvas.FillRect(ARec);
//  end;
end;

procedure TfFramePurSampleBatch.BtnDelClick(Sender: TObject);
var nStr, nBatID, nProID, nMID, nProName, nMName: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的组批记录', sHint);
    Exit;
  end;

  nBatID  := SQLQuery.FieldByName('S_BatID').AsString;
  nProID  := SQLQuery.FieldByName('S_ProID').AsString;
  nProName:= SQLQuery.FieldByName('S_ProName').AsString;
  nMID    := SQLQuery.FieldByName('S_MID').AsString;
  nMName  := SQLQuery.FieldByName('S_MName').AsString;
  ///*******************
  nStr := '将对如下组批信息执行撤销请确认:' + #13#10#13#10 +
              '※.组批编号: %s ' + #13#10 +
              '※.供　应　商: %s %s ' + #13#10 +
              '※.物料信息: %s %s ' + #13#10#13#10 +
              '是否确认撤销?';
  nStr := Format(nStr, [nBatID, nProID, nProName, nMID, nMName]);
  if not QueryDlg(nStr, sAsk) then Exit;

  try
    FDM.ADOConn.BeginTrans;
    //*****************************************
    nStr:= 'UPDate %s Set D_BatID=Null Where D_BatID=''%s''';
    nStr:= Format(nStr, [sTable_OrderDtl, nBatID]);
    FDM.ExecuteSQL(nStr);

    nStr:= 'Delete %s Where S_BatID=''%s''';
    nStr:= Format(nStr, [sTable_PurSampleBatch, nBatID]);
    FDM.ExecuteSQL(nStr);
    //*****************************************
    FDM.ADOConn.CommitTrans;

    ShowMsg('操作成功、已撤销组批', '提示');
    InitFormData('');
  except
    FDM.ADOConn.RollbackTrans;
  end;
end;

procedure TfFramePurSampleBatch.BtnEditClick(Sender: TObject);
VAR nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormPurSampleBatchEx, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    FRefDtl:= False;
    InitFormData('');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurSampleBatch, TfFramePurSampleBatch.FrameID);



end.
