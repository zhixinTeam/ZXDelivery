{*******************************************************************************
  作者: dmzn@163.com 2010-3-16
  描述: 纸卡预调价
*******************************************************************************}
unit UFormZhiKaPricePre;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckBox, cxTextEdit,
  dxLayoutControl, StdCtrls, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxLabel, dxSkinsCore, dxSkinsDefaultPainters,
  ExtCtrls, dxLayoutcxEditAdapters, dxLayoutControlAdapters;

type
  TfFormZKPricePre = class(TfFormNormal)
    EditStock: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditPrice: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditNew: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item9: TdxLayoutItem;
    EditStart: TcxDateEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    pnl1: TPanel;
    dxlytmLayout1Item82: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    Chk_1: TcxCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FZKList: TStrings;
    //纸卡列表
    FMainZK,FMainStock: string;
    //主纸卡号,品种
    procedure InitFormData;
    //载入数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormBase, UMgrControl, USysDB, USysConst, USysBusiness,
  UFormWait, UDataModule, DB, DateUtils;

class function TfFormZKPricePre.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormZKPricePre.Create(Application) do
  begin
    Caption := '纸卡预调价';
    FZKList.Text := nP.FParamB;
    InitFormData;
    
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormZKPricePre.FormID: integer;
begin
  Result := cFI_FormAdjustPricePre;
end;

procedure TfFormZKPricePre.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FZKList := TStringList.Create;
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormZKPricePre.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  FZKList.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormZKPricePre.InitFormData;
var nIdx: Integer; 
    nStock: string;
    nList: TStrings;
    nMin,nMax,nVal: Double;
    nMinYF,nMaxYF,nValYF: Double;
begin
  nList := TStringList.Create;
  try
    EditStart.Date := StrToDateTime(FormatDateTime('yyyy-MM-dd 00:00:00', IncDay(Now)));

    FMainZK := '';
    FMainStock := '';

    nMin := MaxInt;
    nMax := 0;
    nMinYF := MaxInt;  nMaxYF := 0;
    nStock := '';

    for nIdx:=FZKList.Count - 1 downto 0 do
    begin
      if not SplitStr(FZKList[nIdx], nList, 6, ';') then Continue;
      //明细记录号;单价;纸卡;品种名称
      if not IsNumber(nList[1], True) then Continue;

      // 销售单价
      nVal := StrToFloat(nList[1]);
      if nVal < nMin then nMin := nVal;
      if nVal > nMax then nMax := nVal;

      if nStock = '' then nStock := nList[4];
      if FMainStock = '' then FMainStock := nList[3];

      if FMainZK = '' then FMainZK := nList[2] else
      if FMainZK <> nList[2] then FMainZK := sFlag_No;
    end;

    ActiveControl := EditNew;
    EditStock.Text := nStock;

    Chk_1.Checked:= FZKList.Count>1 ;
    Chk_1.Enabled:= not(FZKList.Count>1) ;


    // 销售单价
    if nMin = nMax then
         EditPrice.Text := Format('%.2f 元/吨', [nMax])
    else EditPrice.Text := Format('%.2f - %.2f 元/吨', [nMin, nMax]);
  finally
    nList.Free;
  end;
end;

procedure TfFormZKPricePre.BtnOKClick(Sender: TObject);
var nStr,nStatus,nP,nAdd: string;
    nVal,nValYF: Double;
    nIdx: Integer;
    nList: TStrings;
begin
  if not (IsNumber(EditNew.Text, True) ) then
  begin
    EditNew.SetFocus;
    ShowMsg('请输入正确的销售单价', sHint); Exit;
  end;

  if (EditStart.Date < Now) then
  begin
    EditStart.SetFocus;
    ShowMsg('生效时间需大于当前时间', sHint); Exit;
  end;

  nStr := '请确认以下信息: ' + #13#10#13#10 +
          '品种名称: '+ EditStock.Text + #13#10 +
          '预调售价: '+ EditNew.Text +' 元/吨'+ #13#10 +
          '生效时间: '+ DateTime2Str(EditStart.Date)+ #13#10#13#10 +
          '新单价将在指定时间对选择记录生效,要继续吗?  ';
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    if FZKList.Count > 20 then
      ShowWaitForm(Self, '调价中,请稍候');
    nList := TStringList.Create;

    for nIdx:=FZKList.Count - 1 downto 0 do
    begin
      if not SplitStr(FZKList[nIdx], nList, 6, ';') then Continue;
      //明细记录号;单价;纸卡;品种ID、名称

      // 销售单价
      nVal := StrToFloat(EditNew.Text);
      nVal := Float2Float(nVal, cPrecision, True);

//      //运费单价
//      nValYF := StrToFloat(edt_NewYunFei.Text);
//      nValYF := Float2Float(nValYF, cPrecision, True);

      if Chk_1.Checked then
      begin
        if nVal>0 then  nAdd:= '涨价' else  nAdd:= '降价';

        nStr := 'UPDate %s Set D_NewPriceExeced=''N'', D_NextPrice= D_Price + (%.2f), D_NewPriceExecuteTime=''%s'', D_TJMan=''%s'' ' +
                'Where R_ID=%s ';
        nStr := Format(nStr, [sTable_ZhiKaDtl, nVal, DateTime2Str(EditStart.Date), gSysParam.FUserName, nList[0]]);
        FDM.ExecuteSQL(nStr);

        nStr := gSysParam.FUserName + ' 设置预调价将在 %s 对水泥品种[ %s ]、销售单价调整[ %s %s %.2f ]';
        nStr := Format(nStr, [DateTime2Str(EditStart.Date), nList[4], nList[1], nAdd, nVal ]);
      end
      else
      begin
        nStr := 'UPDate %s Set D_NewPriceExeced=''N'', D_NextPrice= %.2f, D_NewPriceExecuteTime=''%s'', D_TJMan=''%s'' ' +
                'Where R_ID=%s ';
        nStr := Format(nStr, [sTable_ZhiKaDtl, nVal, DateTime2Str(EditStart.Date), gSysParam.FUserName, nList[0]]);
        FDM.ExecuteSQL(nStr);

        nStr := gSysParam.FUserName + ' 设置预调价将在 %s 对水泥品种[ %s ]、销售单价调整[ %s -> %.2f ]';
        nStr := Format(nStr, [DateTime2Str(EditStart.Date), nList[4], nList[1], nVal ]);
      end;

      FDM.WriteSysLog(sFlag_ZhiKaItem, nList[2], nStr, False);
    end;

    FDM.ADOConn.CommitTrans;
    nIdx := MaxInt;
  except
    nIdx := -1;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('调价失败', sError);
  end;

  nList.Free;
  if FZKList.Count > 20 then CloseWaitForm;
  if nIdx = MaxInt then ModalResult := mrOk;
end;


initialization
  gControlManager.RegCtrl(TfFormZKPricePre, TfFormZKPricePre.FormID);

  
end.
