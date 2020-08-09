unit UFramePurMatelTestItemSet;
      
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
  DBClient, StdCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, ExtCtrls;

type
  TfFramePurMatelTestItemSet = class(TfFrameNormal)
    cxspltr1: TcxSplitter;
    cxGrid2: TcxGrid;
    cxView2: TcxGridDBTableView;
    cxLevel2: TcxGridLevel;
    Clmn_MName: TcxGridDBColumn;
    Clmn_MID: TcxGridDBColumn;
    Qry_Sample: TADOQuery;
    Ds_Sample: TDataSource;
    dxLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    lbl1: TLabel;
    ClientDs1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    Clmn_ID: TcxGridDBColumn;
    procedure BtnAddClick(Sender: TObject);
  private
    FStart,FEnd: TDate;
    //时间区间
    FWeek : string;
  private
    function RefPurMatelSet : Boolean;
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurMatelTestItemSet: TfFramePurMatelTestItemSet;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, UMgrRemotePrint, USysLoger,
  UBusinessPacker, UFormPurchaseTotal, UFormPurchaseTotalUP;


class function TfFramePurMatelTestItemSet.FrameID: integer;
begin
  Result := cFI_FramePurSampleHYData;
end;

function TfFramePurMatelTestItemSet.RefPurMatelSet: Boolean;
VAR nStr :string;
begin
  Result:= True;
  //******************************************
  nStr := 'Select * From $SampleBatch '+
          'Where D_OutFact>=''$STime'' And D_OutFact<''$ETime''  ';

  nStr := MacroValue(nStr, [MI('$SampleBatch', sTable_OrderDtl),
                            MI('$STime', Date2Str(FStart)), MI('$ETime', Date2Str(FEnd))]);

  FDM.QueryData(Qry_Sample, nStr);
  //xxxxx
end;

function TfFramePurMatelTestItemSet.InitFormDataSQL(const nWhere: string): string;
VAR nYear, nMonth, nPreMonth:string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  Result := 'Select * From $OrderDtl  '+
            'Where D_OutFact>=''$S'' And D_OutFact<''$End'' Order by D_OutFact ';

  Result := MacroValue(Result, [MI('$OrderDtl', sTable_OrderDtl),
                                MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd))]);


  Result := 'Select * From $TotalUPPurSAP Where U_Week=''$Week'' And (U_PostTime>=''$STime'' and U_PostTime<''$ETime'' ) ';

  if (not gSysParam.FIsAdmin) then
  begin
    Result := Result + ' And (U_Man=''$UMan'' or U_ReverseMan=''$RMan'') ';
  end;

  Result := MacroValue(Result, [MI('$TotalUPPurSAP', sTable_TotalUPLoderSAP),
                                MI('$Week', FWeek), MI('$UMan', gSysParam.FUserName),
                                MI('$RMan', gSysParam.FUserName),
                                MI('$STime', Date2Str(FStart)), MI('$ETime', Date2Str(FEnd + 1)) ]);

  //xxxxx
  Result:= Result;
end;

procedure TfFramePurMatelTestItemSet.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
    nStr,nProID,nProName,nMID,nMName,nValue,nTrucks : string;
begin
  IF cxView1.ViewData.RecordCount<=0 then
  begin
    ShowMsg('请先选取物料', '提示');
    Exit;
  end;
  //*************
  nStr := Format('%s,%s,%s,%s,%s,%s', [nProID,nProName,nMID,nMName,nValue,nTrucks]);
  nP.FParamA := StringReplace(nStr, ' ', '@', [rfReplaceAll]);
  CreateBaseFormItem(cFI_FormPurSampleBatch, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;

end;

initialization
  gControlManager.RegCtrl(TfFramePurMatelTestItemSet, TfFramePurMatelTestItemSet.FrameID);



end.
