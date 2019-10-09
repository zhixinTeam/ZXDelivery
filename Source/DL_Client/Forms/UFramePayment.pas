{*******************************************************************************
  作者: dmzn@163.com 2009-7-15
  描述: 销售回款
*******************************************************************************}
unit UFramePayment;
{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxLayoutcxEditAdapters, Menus;

type
  TfFramePayment = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
  private
    { Private declarations }
    function PrintShouJu(const nSID: string; const nAsk: Boolean): Boolean;
    //打印收据
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UFormBase, UFormDateFilter,
  UDataModule, UDataReport;

//------------------------------------------------------------------------------
class function TfFramePayment.FrameID: integer;
begin
  Result := cFI_FramePayment;
end;

procedure TfFramePayment.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFramePayment.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFramePayment.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  
  Result := 'Select iom.*,sm.S_Name From $IOM iom ' +
            ' Left Join $SM sm On sm.S_ID=iom.M_SaleMan ' +
            'Where M_Type=''$HK'' ';
            
  if nWhere = '' then
       Result := Result + 'And (M_Date>=''$Start'' And M_Date <''$End'')'
  else Result := Result + 'And (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$SM', sTable_Salesman),
            MI('$IOM', sTable_InOutMoney), MI('$HK', sFlag_MoneyHuiKuan),
            MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 回款
procedure TfFramePayment.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FParamA := '';
  CreateBaseFormItem(cFI_FormPayment, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
    //PrintShouJu('',True);
  end;
end;

//Desc: 特定客户回款
procedure TfFramePayment.cxView1DblClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nP.FParamA := SQLQuery.FieldByName('M_CusID').AsString;
  CreateBaseFormItem(cFI_FormPayment, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: 纸卡回款
procedure TfFramePayment.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormPaymentZK, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: 日期筛选
procedure TfFramePayment.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFramePayment.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;
    
    FWhere := '(M_CusID like ''%%%s%%'' Or M_CusName like ''%%%s%%'')';
    FWhere := Format(FWhere, [EditID.Text, EditID.Text]);
    InitFormData(FWhere);
  end else
end;

procedure TfFramePayment.N1Click(Sender: TObject);
var
  nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('R_ID').AsString;
    PrintShouJu(nStr, False);
  end;
end;

function SmallTOBig(small: real): string;
var
  SmallMonth, BigMonth: string;
  wei1, qianwei1: string[2];
  qianwei, dianweizhi, qian: integer;
  fs_bj: boolean;
begin
  if small < 0 then
    fs_bj := True
  else
    fs_bj := False;
  small      := abs(small);
  {------- 修改参数令值更精确 -------}
  {小数点后的位置，需要的话也可以改动-2值}
  qianwei    := -2;
  {转换成货币形式，需要的话小数点后加多几个零}
  Smallmonth := formatfloat('0.00', small);
  {---------------------------------}
  dianweizhi := pos('.', Smallmonth);{小数点的位置}
  {循环小写货币的每一位，从小写的右边位置到左边}
  for qian := length(Smallmonth) downto 1 do
  begin
    {如果读到的不是小数点就继续}
    if qian <> dianweizhi then
    begin
      {位置上的数转换成大写}
      case StrToInt(Smallmonth[qian]) of
        1: wei1 := '壹';
        2: wei1 := '贰';
        3: wei1 := '叁';
        4: wei1 := '肆';
        5: wei1 := '伍';
        6: wei1 := '陆';
        7: wei1 := '柒';
        8: wei1 := '捌';
        9: wei1 := '玖';
        0: wei1 := '零';
      end;
      {判断大写位置，可以继续增大到real类型的最大值}
      case qianwei of
        -3: qianwei1 := '厘';
        -2: qianwei1 := '分';
        -1: qianwei1 := '角';
        0: qianwei1  := '元';
        1: qianwei1  := '拾';
        2: qianwei1  := '佰';
        3: qianwei1  := '仟';
        4: qianwei1  := '万';
        5: qianwei1  := '拾';
        6: qianwei1  := '佰';
        7: qianwei1  := '仟';
        8: qianwei1  := '亿';
        9: qianwei1  := '拾';
        10: qianwei1 := '佰';
        11: qianwei1 := '仟';
      end;
      inc(qianwei);
      BigMonth := wei1 + qianwei1 + BigMonth;{组合成大写金额}
    end;
  end;

  BigMonth := StringReplace(BigMonth, '零拾', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零佰', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零仟', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零角零分', '', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零角', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零分', '', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零零', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零零', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零零', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零亿', '亿', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零万', '万', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零元', '元', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '亿万', '亿', [rfReplaceAll]);
  BigMonth := BigMonth + '整';
  BigMonth := StringReplace(BigMonth, '分整', '分', [rfReplaceAll]);

  if BigMonth = '元整' then
    BigMonth := '零元整';
  if copy(BigMonth, 1, 2) = '元' then
    BigMonth := copy(BigMonth, 3, length(BigMonth) - 2);
  if copy(BigMonth, 1, 2) = '零' then
    BigMonth := copy(BigMonth, 3, length(BigMonth) - 2);
  if fs_bj = True then
    SmallTOBig := '- ' + BigMonth
  else
    SmallTOBig := BigMonth;
end;
function TfFramePayment.PrintShouJu(const nSID: string;
  const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印收据?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_InOutMoney, nSID]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '凭单号为[ %s ] 的收据已无效!!';
    nStr := Format(nStr, [nSID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ShouJu.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  nParam.FName := 'nMoney';
  nParam.FValue := SmallTOBig(SQLQuery.FieldByName('M_Money').AsFloat);
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

procedure TfFramePayment.PMenu1Popup(Sender: TObject);
begin
  {$IFNDEF HYJC}
  N1.Visible := False;
  {$ENDIF}
end;

initialization
  gControlManager.RegCtrl(TfFramePayment, TfFramePayment.FrameID);
end.
