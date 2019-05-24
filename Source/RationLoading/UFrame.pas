unit UFrame;
{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient,PLCController, ULEDFont, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, UMgrPoundTunnels,
  ExtCtrls, IdTCPServer, IdContext, IdGlobal, UBusinessConst, ULibFun,
  Menus, cxButtons, UMgrSendCardNo, USysLoger, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxSpinEdit, DateUtils;

type
  TFrame1 = class(TFrame)
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    btnPause: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton1: TToolButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    EditValue: TLEDFontNum;
    GroupBox3: TGroupBox;
    cxLabel4: TcxLabel;
    EditBill: TcxComboBox;
    cxLabel5: TcxLabel;
    EditTruck: TcxComboBox;
    cxLabel7: TcxLabel;
    EditCusID: TcxComboBox;
    cxLabel8: TcxLabel;
    EditStockID: TcxComboBox;
    cxLabel6: TcxLabel;
    EditMaxValue: TcxTextEdit;
    cxLabel1: TcxLabel;
    editPValue: TcxTextEdit;
    cxLabel2: TcxLabel;
    editZValue: TcxTextEdit;
    editNetValue: TLEDFontNum;
    editBiLi: TLEDFontNum;
    cxLabel3: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    IncTon: TcxSpinEdit;
    BtnStop: TButton;
    ControlTimer: TTimer;
    cxLabel11: TcxLabel;
    IncMin: TcxSpinEdit;
    BtnStart: TButton;
    LblWarn: TcxLabel;
    BtnSaveMValue: TButton;
    BtnClean: TButton;
    procedure ControlTimerTimer(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure IncMinPropertiesChange(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure BtnCleanClick(Sender: TObject);
    procedure BtnSaveMValueClick(Sender: TObject);
  private
    { Private declarations }
    FUserCtrl: Boolean;           //�ֶ�����
    FCardUsed: string;            //��Ƭ����
    FUIData: TLadingBillItem;     //��������
    FPoundTunnel: PPTTunnelItem;  //��վͨ��
    FSaveMValue: Boolean;         //�Ƿ��Ѿ�����ë��
    FCard : string;
    procedure SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
    //���ý�������
    procedure OnPoundDataEvent(const nValue: Double);
    procedure OnPoundData(const nValue: Double);
    //��ȡ����
    procedure SetTunnel(const Value: PPTTunnelItem);
    procedure WriteLog(const nEvent: string);
    function CalControlTime: Boolean;
  public
    FrameId:Integer;              //PLCͨ��
    FIsBusy: Boolean;             //ռ�ñ�ʶ
    FSysLoger : TSysLoger;
    Fcontroller:TPLCController;
    FTCPSer:TIdTCPServer;
    FSpd: Integer;//�Ż��ٶ�(��)
    FPreKd: Double;//Ԥ����
    FTimeControl: Boolean;//�Ƿ����ö�ʱ
    property PoundTunnel: PPTTunnelItem read FPoundTunnel write SetTunnel;
    procedure LoadBillItems(const nCard: string);
    //��ȡ������
    procedure StopPound;
  end;

implementation

{$R *.dfm}

uses
   USysBusiness, USysDB, USysConst, UDataModule, UFormInputbox;

//Parm: �ſ��򽻻�����
//Desc: ��ȡnCard��Ӧ�Ľ�����
procedure TFrame1.LoadBillItems(const nCard: string);
var
  nStr, nHint, nTmp: string;
  nIdx: integer;
  nBills: TLadingBillItems;
  nRet: Boolean;
begin
  FCard := nCard;
  FCardUsed := GetCardUsed(nCard);
  if FCardUsed=sFlag_Provide then
       nRet := GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills)
  else nRet := GetLadingBills(nCard, sFlag_TruckBFP, nBills);

  if (not nRet) or (Length(nBills) < 1) then
  begin
    nStr := '��ȡ�ſ���Ϣʧ��,����ϵ����Ա';
    WriteLog(nStr);
    SetUIData(True);
    Exit;
  end;

  //��ȡ�������ֵ
  //nBills[0].FMData.FValue := StrToFloatDef(GetLimitValue(nBills[0].FTruck),0);

  FUIData := nBills[0];

  FTimeControl := False;
  FPreKd := 0;
  LblWarn.Caption := '';

  if Assigned(FPoundTunnel.FOptions) And
     (UpperCase(FPoundTunnel.FOptions.Values['SPT']) <> '') then
  begin
    FTimeControl := True;
    FSpd := StrToIntDef(FPoundTunnel.FOptions.Values['SPT'],5);
    FPreKd := StrToFloatDef(FPoundTunnel.FOptions.Values['PreKd'],0.05);
  end
  else
  begin
    cxLabel1.Visible := False;
    IncMin.Visible := False;
  end;

  if Assigned(FPoundTunnel.FOptions) then
  begin
    FPreKd := StrToFloatDef(FPoundTunnel.FOptions.Values['PreKd'],0.05);
  end;

  SetUIData(False);

  ControlTimer.Tag := 20;//init;

  if not FPoundTunnel.FUserInput then
  if not gPoundTunnelManager.ActivePort(FPoundTunnel.FID,
         OnPoundDataEvent, True) then
  begin
    nHint := '���ӵذ���ͷʧ�ܣ�����ϵ����Ա���Ӳ������';
    WriteLog(nHint);
    SetUIData(True);
    Exit;
  end;

  if FTimeControl  then
  begin
    if CalControlTime then
      ControlTimer.Enabled := True
    else
    begin
      ControlTimer.Enabled := False;
      StopPound;
      Exit;
    end;
  end;

  FIsBusy := True;
  FSaveMValue := False;

end;

procedure TFrame1.SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
var
  nItem: TLadingBillItem;
begin
  if nReset then
  begin
    FillChar(nItem, SizeOf(nItem), #0);
    nItem.FFactory := gSysParam.FFactNum;

    FUIData := nItem;
    if nOnlyData then Exit;

    EditValue.Text := '0.00';
    editNetValue.Text := '0.00';
    editBiLi.Text := '0';
    EditBill.Properties.Items.Clear;
  end;

  with FUIData do
  begin
    EditBill.Text := FID;
    EditTruck.Text := FTruck;
    EditStockID.Text := FStockName;
    EditCusID.Text := FCusName;

    EditMaxValue.Text := Format('%.2f', [FMData.FValue]);
    EditPValue.Text := Format('%.2f', [FPData.FValue]);
    EditZValue.Text := Format('%.2f', [FValue]);
  end;
end;

procedure TFrame1.OnPoundDataEvent(const nValue: Double);
begin
  try
    OnPoundData(nValue);
  except
    on E: Exception do
    begin
      WriteLog(Format('��վ[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      SetUIData(True);
    end;
  end;
end;

procedure TFrame1.OnPoundData(const nValue: Double);
var
  nStr: string;
  nPValue, nZValue, nNetValue, nBiLi, nManuValue : Double;
  nFD: integer;
begin
  nPValue := StrToFloat(editPValue.Text);    //Ƥ��
  nZValue := StrToFloat(editZValue.Text);    //Ʊ��
  nNetValue := nValue - nPValue;             //����

  nManuValue := IncTon.Value;                //�˹���Ԥ��

  nBiLi := 0;
  if nZValue > 0 then
    nBiLi := nNetValue/nZValue *100;                //��ɱ���

  EditValue.Text := Format('%.2f', [nValue]);
  editNetValue.Text := Format('%.2f',[nNetValue]);
  editBiLi.Text := Format('%.2f',[nBiLi]);

  //��ʱֹͣ�Ż�
  if FTimeControl and ( ControlTimer.Tag <= 0 ) then
  begin
    StopPound;
    writelog(GroupBox1.Caption+' װ����ʱ,�Զ�����ָֹͣ��,ʱ�䣺'+formatdatetime('yyyy-mm-dd HH:MM:ss',Now));
    //ShowMsg('��������,�Զ�����ָֹͣ��.',sHint);
    Exit;
  end;

  //������������ֹͣ�Ż�
  if (nValue+0.1 > FUIData.FMData.FValue) and (FUIData.FMData.FValue>1) then
  begin
    StopPound;
    writelog(GroupBox1.Caption+' ��������,�Զ�����ָֹͣ��,ʱ�䣺'+formatdatetime('yyyy-mm-dd HH:MM:ss',Now));
    //ShowMsg('��������,�Զ�����ָֹͣ��.',sHint);
    Exit;
  end;
  //�ﵽ�����ֹͣ�Ż�
  if (nNetValue - nManuValue +0.1 > FUIData.FValue * (1 - FPreKd)) and (FUIData.FValue > 0.1) then
  begin
    StopPound;
    LblWarn.Caption := FUIData.FTruck + '�ﵽ�����,����ֹͣ����';
    writelog(GroupBox1.Caption+' �ﵽ�����,�Զ�����ָֹͣ��,ʱ�䣺'+formatdatetime('yyyy-mm-dd HH:MM:ss',Now));
    Exit;
  end;

end;

procedure TFrame1.WriteLog(const nEvent: string);
begin
  FSysLoger.AddLog(TFrame, '����װ������Ԫ', nEvent);
end;

procedure TFrame1.SetTunnel(const Value: PPTTunnelItem);
begin
  FPoundTunnel := Value;
  SetUIData(true);
  FUserCtrl := false;
end;

procedure TFrame1.StopPound;
begin
  LineClose(FPoundTunnel.FID, sFlag_Yes);
  {$IFNDEF SXDY}
  SetUIData(true);
  {$ENDIF}
  FIsBusy := False;
  ControlTimer.Enabled := False;
  BtnStop.Caption := 'ֹͣ';
  writelog(GroupBox1.Caption+' ֹͣ����, ʱ�䣺'+formatdatetime('yyyy-mm-dd HH:MM:ss',Now));
end;

function TFrame1.CalControlTime: Boolean;
var nValue : Double;
begin
  Result := False;
  try
    nValue := StrToFloatDef(editZValue.Text,0) * (1 - FPreKd) * FSpd + IncMin.Value * 60;
    if Trim(FUIData.FLadeTime) <> '' then
      nValue := nValue - SecondsBetween(Now, StrToDateTime(FUIData.FLadeTime));
    ControlTimer.Tag := Round(nValue);

    Result := ControlTimer.Tag > 0;

    if not Result then
      LblWarn.Caption := FUIData.FTruck + '���ʱ��:' + FUIData.FLadeTime
                         + '�����ʱ';
  except
    on E: Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

procedure TFrame1.ControlTimerTimer(Sender: TObject);
var nStr, nTmp: string;
begin
  ControlTimer.Tag := ControlTimer.Tag - 1;

//  nStr := FUIData.FTruck + StringOfChar(' ', 12 - Length(FUIData.FTruck));
//  nTmp := '����ʱ';
//  nStr := nStr + nTmp + IntToStr(ControlTimer.Tag);
//  //xxxxx
//
//  ShowLedText(FPoundTunnel.FID,nStr);

  BtnStop.Caption := IntToStr(ControlTimer.Tag) + '���ֹͣ,���ֹͣ';
  if ControlTimer.Tag <= 0 then
    StopPound;
end;

procedure TFrame1.BtnStopClick(Sender: TObject);
begin
  StopPound;
end;

procedure TFrame1.IncMinPropertiesChange(Sender: TObject);
begin
  CalControlTime;
end;

procedure TFrame1.BtnStartClick(Sender: TObject);
var nStr: string;
begin
  nStr := FCard;
  if not ShowInputBox('������ſ���:', '��ʾ', nStr) then Exit;
  LineClose(FPoundTunnel.FID, sFlag_No);
  LoadBillItems(nStr);
end;

procedure TFrame1.BtnCleanClick(Sender: TObject);
begin
  if not FSaveMValue then
    if not QueryDlg('������δ����,ȷ��Ҫ������', sAsk) then Exit;
  SetUIData(True);
end;

procedure TFrame1.BtnSaveMValueClick(Sender: TObject);
var
  nRet: Boolean;
  nBills: TLadingBillItems;
  nStr:string;
begin
  SetLength(nBills, 1);
  nBills[0] := FUIData;
  nBills[0].FPoundID := sFlag_Yes;
  with nBills[0].FMData do
  begin
    FValue := StrToFloat(EditValue.Text);
    FDate := Now;
    FOperator := FPoundTunnel.FName;
  end;
  try
    nRet := SaveLadingBills(nstr,sFlag_TruckBFM, nBills, FPoundTunnel);
    if not nRet then
    begin
      nStr := '��������ʧ��, ����: '+nstr;
      ShowMessage(nstr);
      writelog(nstr);
      exit;
    end;
  finally
    LoadBillItems(FCard);
  end;

  FSaveMValue := True;
end;

end.
