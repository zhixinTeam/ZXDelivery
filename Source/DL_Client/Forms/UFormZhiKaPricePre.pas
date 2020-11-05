{*******************************************************************************
  ����: dmzn@163.com 2010-3-16
  ����: ֽ��Ԥ����
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
    //ֽ���б�
    FMainZK,FMainStock: string;
    //��ֽ����,Ʒ��
    procedure InitFormData;
    //��������
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
    Caption := 'ֽ��Ԥ����';
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
      //��ϸ��¼��;����;ֽ��;Ʒ������
      if not IsNumber(nList[1], True) then Continue;

      // ���۵���
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


    // ���۵���
    if nMin = nMax then
         EditPrice.Text := Format('%.2f Ԫ/��', [nMax])
    else EditPrice.Text := Format('%.2f - %.2f Ԫ/��', [nMin, nMax]);
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
    ShowMsg('��������ȷ�����۵���', sHint); Exit;
  end;

  if (EditStart.Date < Now) then
  begin
    EditStart.SetFocus;
    ShowMsg('��Чʱ������ڵ�ǰʱ��', sHint); Exit;
  end;

  nStr := '��ȷ��������Ϣ: ' + #13#10#13#10 +
          'Ʒ������: '+ EditStock.Text + #13#10 +
          'Ԥ���ۼ�: '+ EditNew.Text +' Ԫ/��'+ #13#10 +
          '��Чʱ��: '+ DateTime2Str(EditStart.Date)+ #13#10#13#10 +
          '�µ��۽���ָ��ʱ���ѡ���¼��Ч,Ҫ������?  ';
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    if FZKList.Count > 20 then
      ShowWaitForm(Self, '������,���Ժ�');
    nList := TStringList.Create;

    for nIdx:=FZKList.Count - 1 downto 0 do
    begin
      if not SplitStr(FZKList[nIdx], nList, 6, ';') then Continue;
      //��ϸ��¼��;����;ֽ��;Ʒ��ID������

      // ���۵���
      nVal := StrToFloat(EditNew.Text);
      nVal := Float2Float(nVal, cPrecision, True);

//      //�˷ѵ���
//      nValYF := StrToFloat(edt_NewYunFei.Text);
//      nValYF := Float2Float(nValYF, cPrecision, True);

      if Chk_1.Checked then
      begin
        if nVal>0 then  nAdd:= '�Ǽ�' else  nAdd:= '����';

        nStr := 'UPDate %s Set D_NewPriceExeced=''N'', D_NextPrice= D_Price + (%.2f), D_NewPriceExecuteTime=''%s'', D_TJMan=''%s'' ' +
                'Where R_ID=%s ';
        nStr := Format(nStr, [sTable_ZhiKaDtl, nVal, DateTime2Str(EditStart.Date), gSysParam.FUserName, nList[0]]);
        FDM.ExecuteSQL(nStr);

        nStr := gSysParam.FUserName + ' ����Ԥ���۽��� %s ��ˮ��Ʒ��[ %s ]�����۵��۵���[ %s %s %.2f ]';
        nStr := Format(nStr, [DateTime2Str(EditStart.Date), nList[4], nList[1], nAdd, nVal ]);
      end
      else
      begin
        nStr := 'UPDate %s Set D_NewPriceExeced=''N'', D_NextPrice= %.2f, D_NewPriceExecuteTime=''%s'', D_TJMan=''%s'' ' +
                'Where R_ID=%s ';
        nStr := Format(nStr, [sTable_ZhiKaDtl, nVal, DateTime2Str(EditStart.Date), gSysParam.FUserName, nList[0]]);
        FDM.ExecuteSQL(nStr);

        nStr := gSysParam.FUserName + ' ����Ԥ���۽��� %s ��ˮ��Ʒ��[ %s ]�����۵��۵���[ %s -> %.2f ]';
        nStr := Format(nStr, [DateTime2Str(EditStart.Date), nList[4], nList[1], nVal ]);
      end;

      FDM.WriteSysLog(sFlag_ZhiKaItem, nList[2], nStr, False);
    end;

    FDM.ADOConn.CommitTrans;
    nIdx := MaxInt;
  except
    nIdx := -1;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('����ʧ��', sError);
  end;

  nList.Free;
  if FZKList.Count > 20 then CloseWaitForm;
  if nIdx = MaxInt then ModalResult := mrOk;
end;


initialization
  gControlManager.RegCtrl(TfFormZKPricePre, TfFormZKPricePre.FormID);

  
end.
