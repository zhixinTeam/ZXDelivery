{*******************************************************************************
  作者: dmzn@163.com 2014-10-20
  描述: 自动称重通道项
*******************************************************************************}
unit UFramePoundAutoItem;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrPoundTunnels, UBusinessConst, UFrameBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, StdCtrls,
  UTransEdit, ExtCtrls, cxRadioGroup, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, ULEDFont, DateUtils, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox;

type
  TfFrameAutoPoundItem = class(TBaseFrame)
    GroupBox1: TGroupBox;
    EditValue: TLEDFontNum;
    GroupBox3: TGroupBox;
    ImageGS: TImage;
    Label16: TLabel;
    Label17: TLabel;
    ImageBT: TImage;
    Label18: TLabel;
    ImageBQ: TImage;
    ImageOff: TImage;
    ImageOn: TImage;
    HintLabel: TcxLabel;
    EditTruck: TcxComboBox;
    EditMID: TcxComboBox;
    EditPID: TcxComboBox;
    EditMValue: TcxTextEdit;
    EditPValue: TcxTextEdit;
    EditJValue: TcxTextEdit;
    Timer1: TTimer;
    EditBill: TcxComboBox;
    EditZValue: TcxTextEdit;
    GroupBox2: TGroupBox;
    RadioPD: TcxRadioButton;
    RadioCC: TcxRadioButton;
    EditMemo: TcxTextEdit;
    EditWValue: TcxTextEdit;
    RadioLS: TcxRadioButton;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    Timer2: TTimer;
    Timer_ReadCard: TTimer;
    TimerDelay: TTimer;
    MemoLog: TZnTransMemo;
    Timer_SaveFail: TTimer;
    Chk_PoundStatus: TcxCheckBox;
    Chk3: TcxCheckBox;
    Chk_UseSnapTruck: TcxCheckBox;
    Chk_StopUse: TcxCheckBox;
    tmr_ShowDefault: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer_ReadCardTimer(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
    procedure Timer_SaveFailTimer(Sender: TObject);
    procedure EditBillKeyPress(Sender: TObject; var Key: Char);
    procedure tmr_ShowDefaultTimer(Sender: TObject);
  private
    { Private declarations }
    FCardUsed: string;
    //卡片类型
    FLEDContent: string;
    //显示屏内容
    FIsWeighting, FIsSaving, FHasDaiWC: Boolean;
    //称重标识,保存标识
    FPoundTunnel: PPTTunnelItem;
    //磅站通道
    FLastGS,FLastBT,FLastBQ: Int64;
    //上次活动
    FBillItems: TLadingBillItems;
    FUIData,FInnerData: TLadingBillItem;
    //称重数据
    FLastCardDone: Int64;
    FLastCard, FCardTmp, FLastReader: string;
    //上次卡号, 临时卡号, 读卡器编号
    FIsAutoTruckIn : Boolean;
    //是否自动进厂
    FSampleIndex: Integer;
    FValueSamples: array of Double;
    //数据采样
    FVirPoundID: string;
    //虚拟地磅编号
    FBarrierGate: Boolean;
    //是否采用道闸
    FSaveResult, FTips: Boolean;
    //保存结果
    FEmptyPoundInit, FDoneEmptyPoundInit: Int64;
    //空磅计时,过磅保存后空磅
    FEmptyPoundIdleLong, FEmptyPoundIdleShort: Int64;
    FLogin: Integer;
    //摄像机登陆
    FIsChkPoundStatus : Boolean;
    procedure SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
    //界面数据
    procedure SetImageStatus(const nImage: TImage; const nOff: Boolean);
    //设置状态
    procedure SetTunnel(const nTunnel: PPTTunnelItem);
    //关联通道
    procedure OnPoundDataEvent(const nValue: Double);
    procedure OnPoundData(const nValue: Double);
    //读取磅重
    procedure LoadBillItems(const nCard: string);
    //读取交货单
    procedure InitSamples;
    procedure AddSample(const nValue: Double);
    function IsValidSamaple: Boolean;
    //处理采样
    function SavePoundSale: Boolean;
    function SavePoundData: Boolean;
    //保存称重
    procedure WriteLog(nEvent: string);
    //记录日志
    procedure PlayVoice(const nStrtext: string);
    //播放语音
    procedure LEDDisplay(const nContent: string);
    //LED显示
    function ChkPoundStatus:Boolean;
    function CheckMValue: Boolean;
    //验证毛重
    function CheckTruckMValue: Boolean;
    //验证车辆毛重
  public
    { Public declarations }
    class function FrameID: integer; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    //子类继承
    property PoundTunnel: PPTTunnelItem read FPoundTunnel write SetTunnel;
    //属性相关
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UFormBase, {$IFDEF HR1847}UKRTruckProber,{$ELSE}UMgrTruckProbe,{$ENDIF}
  UMgrRemoteVoice, UMgrVoiceNet, UDataModule, USysBusiness, UMgrLEDDisp,
  USysLoger, USysConst, USysDB,Dialogs;

const
  cFlag_ON    = 10;
  cFlag_OFF   = 20;

class function TfFrameAutoPoundItem.FrameID: integer;
begin
  Result := 0;
end;

procedure TfFrameAutoPoundItem.OnCreateFrame;
begin
  inherited;
  FPoundTunnel := nil;
  FIsWeighting := False;

  FLEDContent := '';
  FEmptyPoundInit := 0;
  FLogin := -1;
  {$IFDEF RemoteSnap}
  Chk_UseSnapTruck.Checked:= True;
  Chk3.Checked:= True;
  {$ENDIF}
end;

procedure TfFrameAutoPoundItem.OnDestroyFrame;
begin
  gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
  //关闭表头端口
  {$IFDEF CapturePictureEx}
  FreeCapture(FLogin);
  {$ENDIF}
  inherited;
end;

//Desc: 设置运行状态图标
procedure TfFrameAutoPoundItem.SetImageStatus(const nImage: TImage;
  const nOff: Boolean);
begin
  if nOff then
  begin
    if nImage.Tag <> cFlag_OFF then
    begin
      nImage.Tag := cFlag_OFF;
      nImage.Picture.Bitmap := ImageOff.Picture.Bitmap;
    end;
  end else
  begin
    if nImage.Tag <> cFlag_ON then
    begin
      nImage.Tag := cFlag_ON;
      nImage.Picture.Bitmap := ImageOn.Picture.Bitmap;
    end;
  end;
end;

procedure TfFrameAutoPoundItem.WriteLog(nEvent: string);
var nInt: Integer;
begin
  with MemoLog do
  try
    Lines.BeginUpdate;
    if Lines.Count > 20 then
     for nInt:=1 to 10 do
      Lines.Delete(0);
    //清理多余

    Lines.Add(DateTime2Str(Now) + #9 + nEvent);
  finally
    Lines.EndUpdate;
    Perform(EM_SCROLLCARET,0,0);
    Application.ProcessMessages;
  end;
end;

procedure WriteSysLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFrameAutoPoundItem, '自动称重业务', nEvent);
end;

//------------------------------------------------------------------------------
//Desc: 更新运行状态
procedure TfFrameAutoPoundItem.Timer1Timer(Sender: TObject);
begin
  SetImageStatus(ImageGS, GetTickCount - FLastGS > 5 * 1000);
  SetImageStatus(ImageBT, GetTickCount - FLastBT > 5 * 1000);
  SetImageStatus(ImageBQ, GetTickCount - FLastBQ > 5 * 1000);
end;

//Desc: 关闭红绿灯
procedure TfFrameAutoPoundItem.Timer2Timer(Sender: TObject);
begin
  Timer2.Tag := Timer2.Tag + 1;
  if Timer2.Tag < 10 then Exit;

  Timer2.Tag := 0;
  Timer2.Enabled := False;

  {$IFNDEF MITTruckProber}
    {$IFDEF HR1847}
    gKRMgrProber.TunnelOC(FPoundTunnel.FID,False);
    {$ELSE}
    gProberManager.TunnelOC(FPoundTunnel.FID,False);
    {$ENDIF}
  {$ENDIF}
end;

//Desc: 设置通道
procedure TfFrameAutoPoundItem.SetTunnel(const nTunnel: PPTTunnelItem);
begin
  FBarrierGate := False;
  FEmptyPoundIdleLong := -1;
  FEmptyPoundIdleShort:= -1;

  FPoundTunnel := nTunnel;
  SetUIData(True);

  {$IFDEF CapturePictureEx}
  if not InitCapture(FPoundTunnel,FLogin) then
    WriteLog('通道:'+ FPoundTunnel.FID+'初始化失败,错误码:'+IntToStr(FLogin))
  else
    WriteLog('通道:'+ FPoundTunnel.FID+'初始化成功,登陆ID:'+IntToStr(FLogin));
  {$ENDIF}
  FIsAutoTruckIn := False;

  if Assigned(FPoundTunnel.FOptions) then
  with FPoundTunnel.FOptions do
  begin
    FIsAutoTruckIn:= Values['IsAutoTruckIn']  = sFlag_Yes;
    FVirPoundID  := Values['VirPoundID'];
    FBarrierGate := Values['BarrierGate'] = sFlag_Yes;
    FEmptyPoundIdleLong := StrToInt64Def(Values['EmptyIdleLong'], 60);
    FEmptyPoundIdleShort:= StrToInt64Def(Values['EmptyIdleShort'], 5);
  end;
end;

//Desc: 重置界面数据
procedure TfFrameAutoPoundItem.SetUIData(const nReset,nOnlyData: Boolean);
var nStr: string;
    nInt: Integer;
    nVal: Double;
    nItem: TLadingBillItem;
begin
  if nReset then
  begin
    FillChar(nItem, SizeOf(nItem), #0);
    //init

    with nItem do
    begin
      FPModel := sFlag_PoundPD;
      FFactory := gSysParam.FFactNum;
    end;

    FUIData := nItem;
    FInnerData := nItem;
    if nOnlyData then Exit;

    SetLength(FBillItems, 0);
    EditValue.Text := '0.00';
    EditBill.Properties.Items.Clear;

    FIsSaving    := False;
    FEmptyPoundInit := 0;
                           
    if not FIsWeighting then
    begin
      gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
      //关闭表头端口

      Timer_ReadCard.Enabled := True;            
      //启动读卡
    end;
  end;

  with FUIData do
  begin
    EditBill.Text := FID;
    EditTruck.Text := FTruck;
    EditMID.Text := FStockName;
    EditPID.Text := FCusName;

    EditMValue.Text := Format('%.2f', [FMData.FValue]);
    EditPValue.Text := Format('%.2f', [FPData.FValue]);
    EditZValue.Text := Format('%.2f', [FValue]);

    if (FValue > 0) and (FMData.FValue > 0) and (FPData.FValue > 0) then
    begin
      nVal := FMData.FValue - FPData.FValue;
      EditJValue.Text := Format('%.2f', [nVal]);
      EditWValue.Text := Format('%.2f', [FValue - nVal]);
    end else
    begin
      EditJValue.Text := '0.00';
      EditWValue.Text := '0.00';
    end;

    RadioPD.Checked := FPModel = sFlag_PoundPD;
    RadioCC.Checked := FPModel = sFlag_PoundCC;
    RadioLS.Checked := FPModel = sFlag_PoundLS;

    RadioLS.Enabled := (FPoundID = '') and (FID = '');
    //已称过重量或销售,禁用临时模式
    RadioCC.Enabled := FID <> '';
    //只有销售有出厂模式

    EditBill.Properties.ReadOnly := (FID = '') and (FTruck <> '');
    EditTruck.Properties.ReadOnly := FTruck <> '';
    EditMID.Properties.ReadOnly := (FID <> '') or (FPoundID <> '');
    EditPID.Properties.ReadOnly := (FID <> '') or (FPoundID <> '');
    //可输入项调整

    EditMemo.Properties.ReadOnly := True;
    EditMValue.Properties.ReadOnly := not FPoundTunnel.FUserInput;
    EditPValue.Properties.ReadOnly := not FPoundTunnel.FUserInput;
    EditJValue.Properties.ReadOnly := True;
    EditZValue.Properties.ReadOnly := True;
    EditWValue.Properties.ReadOnly := True;
    //可输入量调整

    if FTruck = '' then
    begin
      EditMemo.Text := '';
      Exit;
    end;
  end;

  nInt := Length(FBillItems);
  if nInt > 0 then
  begin
    if nInt > 1 then
         nStr := '销售并单'
    else nStr := '销售';

    if FCardUsed = sFlag_Provide then nStr := '供应';

    if FUIData.FNextStatus = sFlag_TruckBFP then
    begin
      RadioCC.Enabled := False;
      EditMemo.Text := nStr + '称皮重';
    end else
    begin
      RadioCC.Enabled := True;
      EditMemo.Text := nStr + '称毛重';
    end;
  end else
  begin
    if RadioLS.Checked then
      EditMemo.Text := '车辆临时称重';
    //xxxxx

    if RadioPD.Checked then
      EditMemo.Text := '车辆配对称重';
    //xxxxx
  end;
end;

//Date: 2014-09-19
//Parm: 磁卡或交货单号
//Desc: 读取nCard对应的交货单
procedure TfFrameAutoPoundItem.LoadBillItems(const nCard: string);
var nRet: Boolean;
    nIdx,nInt: Integer;
    nBills: TLadingBillItems;
    nStr,nHint, nVoice, nLabel,nPos: string;
begin
  nStr := Format('读取到卡号[ %s ],开始执行业务.', [nCard]);
  WriteLog(nStr);

  FCardUsed := GetCardUsed(nCard);
  if FCardUsed = sFlag_Provide then
     nRet := GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills) else
  if FCardUsed=sFlag_DuanDao then
     nRet := GetDuanDaoItems(nCard, sFlag_TruckBFP, nBills) else
  if FCardUsed=sFlag_Sale then
     nRet := GetLadingBills(nCard, sFlag_TruckBFP, nBills)   
  else nRet := False;

  if (not nRet) or (Length(nBills) < 1)
  then
  begin
    nVoice := '读取磁卡信息失败,请联系管理员';
    PlayVoice(nVoice);
    WriteLog(nVoice);
    SetUIData(True);
    Exit;
  end;

  {$IFDEF RemoteSnap}
  if Chk_UseSnapTruck.Checked then
  begin
    WriteSysLog(format('对 %s %s 车牌验证 ',[nBills[0].FID, nBills[0].FTruck ]));

    if not VerifySnapTruck(FLastReader, nBills[0], nHint, nPos) then
    begin
      SaveSnapStatus(nBills[0], sFlag_No);
      RemoteSnapDisPlay(nPos, nHint,sFlag_No);
      WriteSysLog(nHint);

      if chk3.Checked then        // 禁止与订单不符车辆上磅
      begin
        PlayVoice(nHint);         // LEDDisplay('车牌识别失败,请移动车辆');
        SetUIData(True);
        Exit;
      end;
    end
    else
    begin
      SaveSnapStatus(nBills[0], sFlag_Yes);
      if nHint <> '' then
      begin
        RemoteSnapDisPlay(nPos, nHint,sFlag_Yes);
        WriteSysLog(nHint);
      end;
      WriteSysLog('车牌验证通过 '+nHint);
    end;
  end;
  {$ENDIF}

  nHint := '';
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    {$IFDEF TruckAutoIn}
    FIsAutoTruckIn:= True;
    {$ENDIF}

    if FIsAutoTruckIn then
    if FStatus=sFlag_TruckNone then
    begin
      WriteSysLog(Format('%s %s 做上磅自动进厂', [FID, FTruck]));
      if FCardUsed = sFlag_Provide then
      begin
        if SavePurchaseOrders(sFlag_TruckIn, nBills) then
        begin
          WriteSysLog(Format('原料车 %s %s 进厂成功', [FID, FTruck]));
          LoadBillItems(FCardTmp);
          Exit;
        end else
        begin
          WriteSysLog(Format('原料车 %s %s 进厂失败', [FID, FTruck]));
        end;
      end
      else
      if FCardUsed = sFlag_Sale then
      begin
        {$IFNDEF YNHT}
        if not GetTruckIsQueue(FTruck) then
        begin
          nStr := '[n1]%s 不在队列中、不能过磅,请等待';
          nStr := Format(nStr, [FTruck]);
          PlayVoice(nStr);
          Exit;
        end;
        if GetTruckIsOut(FTruck) then
        begin
          nStr := '[n1]%s已超时出队,请联系管理员处理';
          nStr := Format(nStr, [FTruck]);
          PlayVoice(nStr);
          Exit;
        end;
        {$ENDIF}
        
        if SaveLadingBills(sFlag_TruckIn, nBills) then
        begin
          WriteSysLog(Format('销售车 %s %s 进厂成功', [FID, FTruck]));
          LoadBillItems(FCardTmp);
          Exit;
        end else
        begin
          WriteSysLog(Format('销售车 %s %s 进厂失败', [FID, FTruck]));
        end;
      end;
    end;

    if (FStatus <> sFlag_TruckBFP) and (FNextStatus = sFlag_TruckZT) then
      FNextStatus := sFlag_TruckBFP;
    //状态校正
    {$IFDEF AllowMultiM}
    if (FCardUsed=sFlag_Sale)And(FStatus = sFlag_TruckBFM)  then
    begin
      FNextStatus := sFlag_TruckBFM;
      //销售允许多次过重
      AdjustBillStatus(FID);
      WriteSysLog(Format('车辆 %s 再次过毛重 ', [FTruck] ));
    end;
    {$ENDIF}

    FSelected := (FNextStatus = sFlag_TruckBFP) or
                 (FNextStatus = sFlag_TruckBFM);
    //可称重状态判定

    //供应类业务,且物流部未验收，则直接跳出循环
    {$IFDEF DoubleCheck}
    if (FCardUsed=sFlag_Provide) and (FNextStatus = sFlag_TruckBFM) and GetWlbYsStatus(FStockNo,FID) then
    begin
      nInt := 0;
      nVoice := '物流部未验收,车辆 %s 不能过磅';
      nVoice := Format(nVoice, [FTruck]);

      nStr := '※.单号:[ %s ] 状态: 物流部未验收';
      nstr := Format(nStr,[FID]);
      nHint := nStr;
      Break;
    end;
    {$ENDIF} 

    if FSelected then
    begin
      Inc(nInt);
      Continue;
    end;

    nStr := '※.单号:[ %s ] 状态:[ %-6s -> %-6s ]   ';
    if nIdx < High(nBills) then nStr := nStr + #13#10;

    nStr := Format(nStr, [FID,
            TruckStatusToStr(FStatus), TruckStatusToStr(FNextStatus)]);
    nHint := nHint + nStr;

    nVoice := '车辆 %s 不能过磅,应该去 %s ';
    nVoice := Format(nVoice, [FTruck, TruckStatusToStr(FNextStatus)]);
  end;

  if nInt = 0 then
  begin
    PlayVoice(nVoice);
    //车辆状态异常

    nHint := '该车辆当前不能过磅,详情如下: ' + #13#10#13#10 + nHint;
    WriteSysLog(nStr);
    SetUIData(True);
    Exit;
  end;

  {$IFDEF UseEnableStruck}
//  if nBills[0].FStatus=sFlag_TruckNone then
//  begin
//    if not VeriFyTruckLicense(FLastReader, nBills[0], nHint, nPos) then
//    begin
//      nVoice := '%s车牌识别失败,请移动车辆或联系管理员';
//      nVoice := Format(nVoice, [nBills[0].FTruck]);
//      PlayVoice(nHint);
//      WriteSysLog(nHint);
//      SetUIData(True);
//      Exit;
//    end
//    else
//    begin
//      if nHint <> '' then
//      begin
//        PlayVoice(nHint);
//        WriteSysLog(nHint);
//      end;
//    end;
//  end;
  {$ENDIF}

  EditBill.Properties.Items.Clear;
  SetLength(FBillItems, nInt);
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    if FSelected then
    begin
      FPoundID := '';
      //该标记有特殊用途

      if nInt = 0 then
           FInnerData := nBills[nIdx]
      else FInnerData.FValue := FInnerData.FValue + FValue;
      //累计量

      EditBill.Properties.Items.Add(FID);
      FBillItems[nInt] := nBills[nIdx];
      Inc(nInt);
    end;
  end;

  FInnerData.FPModel := sFlag_PoundPD;
  FUIData := FInnerData;
  SetUIData(False);

  nInt := GetTruckLastTime(FUIData.FTruck);
  if (nInt > 0) and (nInt < FPoundTunnel.FCardInterval) then
  begin
    nStr := '磅站[ %s.%s ]: 车辆[ %s ]需等待 %d 秒后才能过磅';
    nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
            FUIData.FTruck, FPoundTunnel.FCardInterval - nInt]);
    WriteSysLog(nStr);
    SetUIData(True);
    Exit;
  end;
  //指定时间内车辆禁止过磅

  if FVirPoundID <> '' then
  begin
    nLabel := GetTruckRealLabel(FUIData.FTruck);
    if nLabel <> '' then
    begin
      nHint := ReadPoundCardEx(nStr, FVirPoundID);
      if (nHint = '') or (Pos(nLabel, nHint) < 1) then
      begin
        nStr := '未识别电子签,请移动车辆.';
        PlayVoice(nStr);

        nStr := '磅站[ %s.%s ]: 车辆[ %s.%s ]电子标签不匹配[ %s ],禁止上磅';
        nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
                FUIData.FTruck, nLabel, nHint]);
        WriteSysLog(nStr);
        SetUIData(True);
        Exit;
      end;
    end;
  end;
  //判断车辆是否就位

  {$IFDEF SpecialControl}
  if not IsSealInfoDone(FCardUsed, FUIData) then
  begin
    nStr := '铅封信息不完整,无法过磅.';
    PlayVoice(nStr);

    SetUIData(True);
    Exit;
  end;
  {$ENDIF}  //铅封信息校验

  InitSamples;
  //初始化样本

  if not FPoundTunnel.FUserInput then
  if not gPoundTunnelManager.ActivePort(FPoundTunnel.FID,
         OnPoundDataEvent, True) then
  begin
    nHint := '连接地磅表头失败，请联系管理员检查硬件连接';
    WriteSysLog(nHint);

    nVoice := nHint;
    PlayVoice(nVoice);

    SetUIData(True);
    Exit;
  end;

  Timer_ReadCard.Enabled := False;
  FDoneEmptyPoundInit := 0;
  FIsWeighting := True;
  FSaveResult := True;
  //停止读卡,开始称重

  if FBarrierGate then
  begin
    {$IFDEF ZZSJ}
    if (FUIData.FStatus = sFlag_TruckIn) or
       (FUIData.FStatus = sFlag_TruckBFP) then
    begin
      nStr := '[n1]%s刷卡成功请上磅,并熄火停车,进厂请系好安全带,戴好安全帽';
      nStr := Format(nStr, [FUIData.FTruck]);
    end;
    {$ELSE}
    nStr := '[n1]%s刷卡成功请上磅,并熄火停车';
    nStr := Format(nStr, [FUIData.FTruck]);
    {$ENDIF}
    
    PlayVoice(nStr);
    //读卡成功，语音提示

    {$IFNDEF DEBUG}
    OpenDoorByReader(FLastReader);        FTips:= False;
    //打开主道闸
    {$ENDIF}
  end;
  //车辆上磅
end;

//------------------------------------------------------------------------------
//Desc: 由定时读取交货单
procedure TfFrameAutoPoundItem.Timer_ReadCardTimer(Sender: TObject);
var nStr,nCard: string;
    nLast, nDoneTmp: Int64;
begin
  if FIsChkPoundStatus then Exit;
  if gSysParam.FIsManual then Exit;
  Timer_ReadCard.Tag := Timer_ReadCard.Tag + 1;
  if Timer_ReadCard.Tag < 2 then Exit;

  Timer_ReadCard.Tag := 0;
  if FIsWeighting then Exit;

  try
    WriteLog('正在读取磁卡号.');
    {$IFNDEF DEBUG}
    nCard := Trim(ReadPoundCard(FPoundTunnel.FID, FLastReader));
    {$ENDIF}
    if nCard = '' then Exit;

    if nCard <> FLastCard then
         nDoneTmp := 0
    else nDoneTmp := FLastCardDone;
    //新卡时重置

    {$IFDEF DEBUG}
    nStr := '磅站[ %s.%s ]: 读取到新卡号::: %s =>旧卡号::: %s';
    nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
            nCard, FLastCard]);
    WriteSysLog(nStr);
    {$ENDIF}

    if Chk_StopUse.Checked then
    begin
      PlayVoice('当前地磅已暂停使用、请选择其他地磅称重');
      Exit;
    end;

    nLast := Trunc((GetTickCount - nDoneTmp) / 1000);
    if (nDoneTmp <> 0) and (nLast < FPoundTunnel.FCardInterval)  then
    begin
      nStr := '磅站[ %s.%s ]: 磁卡[ %s ]需等待 %d 秒后才能过磅';
      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
              nCard, FPoundTunnel.FCardInterval - nLast]);
      WriteSysLog(nStr);

      PlayVoice('短时间内禁止频繁过磅、请等待');
      Exit;
    end;

    IF not Chk_PoundStatus.Checked then
    if Not ChkPoundStatus then Exit;
    //检查地磅状态 如不为空磅，则喊话 退出称重

    FCardTmp := nCard;
    EditBill.Text := nCard;
    LoadBillItems(EditBill.Text);
  except
    on E: Exception do
    begin
      nStr := Format('磅站[ %s.%s ]: ',[FPoundTunnel.FID,
              FPoundTunnel.FName]) + E.Message;
      WriteSysLog(nStr);

      SetUIData(True);
      //错误则重置
    end;
  end;
end;

//Desc: 保存销售
function TfFrameAutoPoundItem.SavePoundSale: Boolean;
var nStr,nStrSql: string;
    nVal,nNet,nMValue,nPMVal: Double;
    nMoney: Double;
    nFixMoney, nLimitedMValueChk: Boolean;
begin
  Result := False; FHasDaiWC:= False;
  //init

  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
  begin
    if FUIData.FPData.FValue <= 0 then
    begin
      WriteLog('请先称量皮重');
      Exit;
    end;

    nNet := GetTruckEmptyValue(FUIData.FTruck);
    nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

    if (nNet > 0) and (Abs(nVal) > gSysParam.FPoundSanF) then
    begin
      {$IFDEF AutoPoundInManual}
      nStr := '车辆[%s]实时皮重误差较大,请通知司机检查车厢';
      nStr := Format(nStr, [FUIData.FTruck]);
      PlayVoice(nStr);

      nStr := '车辆[ %s ]实时皮重误差较大,详情如下:' + #13#10#13#10 +
              '※.实时皮重: %.2f吨' + #13#10 +
              '※.历史皮重: %.2f吨' + #13#10 +
              '※.误差量: %.2f公斤' + #13#10#13#10 +
              '是否继续保存?';
      nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
              nNet, nVal]);
      if not QueryDlg(nStr, sAsk) then Exit;
      {$ELSE}
      nStr := '车辆[ %s ]实时皮重误差较大,详情如下:' + #13#10 +
              '※.实时皮重: %.2f吨' + #13#10 +
              '※.历史皮重: %.2f吨' + #13#10 +
              '※.误差量: %.2f公斤' + #13#10 +
              '允许过磅,请选是;禁止过磅,请选否.';
      nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
              nNet, nVal]);

      if not VerifyManualEventRecord(FUIData.FID + sFlag_ManualB, nStr,
        sFlag_Yes, False) then
      begin
        AddManualEventRecord(FUIData.FID + sFlag_ManualB, FUIData.FTruck, nStr,
            sFlag_DepBangFang, sFlag_Solution_YN, sFlag_DepDaTing, True);
        WriteSysLog(nStr);

        nStr := '[n1]%s皮重超出预警,请下磅联系开票员处理后再次过磅';
        nStr := Format(nStr, [FUIData.FTruck]);
        PlayVoice(nStr);
        Exit;
      end;
      {$ENDIF}
    end;
  end else
  begin
    if FUIData.FMData.FValue <= 0 then
    begin
      WriteLog('请先称量毛重');
      Exit;
    end;
  end;

  if FUIData.FNextStatus = sFlag_TruckBFM then
  begin
    if (FUIData.FMData.FValue > 0) then
      if not CheckMValue then Exit;
    //启用毛重上限
    {$IFDEF LimitedLoadMaxValue}
    if (FUIData.FMData.FValue > 0) then
      if not CheckTruckMValue then Exit;
    {$ENDIF}
  end;

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) then
  begin
    {$IFDEF LimitedLoadMValueChk}
    // 毛重限载检查
    nLimitedMValueChk:= False;
    nMValue:= FUIData.FMData.FValue;
    GetLimitedLoadMValueChk(nLimitedMValueChk, nMValue,FUIData.FTruck);

    if nLimitedMValueChk then
    begin
      if nMValue>0 then
      begin
        if nMValue>1000 then
        begin
          nMValue:= nMValue/1000.00;
          nStr:= Format('%s 毛重超载 %g 吨、本次称重无效', [ FUIData.FTruck, nMValue]);
        end
        else nStr:= Format('%s 毛重超载 %g 公斤、本次称重无效', [ FUIData.FTruck, nMValue]);
        
        WriteSysLog(nStr);   FSaveResult:= False;
        PlayVoice(nStr);
        Exit;
      end
      else if nMValue<0 then
      begin
        nMValue:= -1*nMValue;

        if nMValue>1000 then
        begin
          nMValue:= nMValue/1000.00;
          nStr:= Format('%s 毛重低于最小载量请补货 %g 吨、本次称重无效', [ FUIData.FTruck, nMValue]);
        end
        else nStr:= Format('%s 毛重低于最小载量请补货 %g 公斤、本次称重无效', [ FUIData.FTruck, nMValue]);

        WriteSysLog(nStr);
        PlayVoice(nStr);     FSaveResult:= False;
        Exit;
      end;
    end;
    {$ENDIF}

    {$IFDEF AutoEmptyOutChk}
    if (FUIData.FNextStatus = sFlag_TruckBFM) then //出厂模式,过重车
    with FUIData do
    begin
      nPMVal:= (FUIData.FMData.FValue - FUIData.FPData.FValue)*1000;
      if (Abs(nPMVal)<= gSysParam.FEmpTruckWc) then
      begin
        // 判断为空车出厂
        WriteSysLog(Format('单号：%s 净重：%.2f 公斤 符合空车出净重 %.2f 公斤以内要求  予以空车出厂标示',
                                  [FBillItems[0].FID, nPMVal, gSysParam.FEmpTruckWc]));
        FBillItems[0].FYSValid:= 'Y';
        //*****************
        nStrSql := 'UPDate %s Set L_EmptyOut=''Y'' Where L_ID=''%s''  ';
        nStrSql := Format(nStrSql, [sTable_Bill, FBillItems[0].FID]);
        FDM.ExecuteSQL(nStrSql);

        //*********************************************************
        nStr := '[ %s ]符合空车出厂,详情如下:' + #13#10 +
                '※.单据号: %s' + #13#10 +
                '※.开单量: %.2f 吨' + #13#10 +
                '※.净  重: %.2f 公斤' + #13#10 +
                '请确认.';
        nStr := Format(nStr, [FTruck, FID, FValue, nPMVal]);

        AddManualEventRecord(FID + sFlag_ManualD, FTruck, nStr,
          sFlag_DepBangFang , sFlag_Solution_OK, sFlag_DepDaTing, True);
        //xxxxx
      end;
    end;
    {$ENDIF}

    if FBillItems[0].FYSValid <> sFlag_Yes then //判断是否空车出厂
    begin
      if FUIData.FPData.FValue > FUIData.FMData.FValue then
      begin
        WriteLog('皮重应小于毛重');
        Exit;
      end;

      nNet := FUIData.FMData.FValue - FUIData.FPData.FValue;
      //净重
      nVal := nNet * 1000 - FInnerData.FValue * 1000;
      //与开票量误差(公斤)

      with gSysParam,FBillItems[0] do
      begin
        {$IFDEF DaiStepWuCha}
        if FType = sFlag_Dai then
        begin
          GetPoundAutoWuCha(FPoundDaiZ, FPoundDaiF, FInnerData.FValue);
          //计算误差
        end;
        {$ELSE}
        if FDaiPercent and (FType = sFlag_Dai) then
        begin
          if nVal > 0 then
               FPoundDaiZ := Float2Float(FInnerData.FValue * FPoundDaiZ_1 * 1000,
                                         cPrecision, False)
          else FPoundDaiF := Float2Float(FInnerData.FValue * FPoundDaiF_1 * 1000,
                                         cPrecision, False);
        end;
        {$ENDIF}
        //增加输出日志
        if (FType = sFlag_Dai) then
        begin
          nStr := '单号[ %s ]车辆[%s]开单量: %.2f吨,装车量: %.2f吨,误差量: %.2f公斤,误差范围:%.2f ~ %.2f';
          nStr := Format(nStr, [FID, FTruck, FInnerData.FValue, nNet, nVal,FPoundDaiF,FPoundDaiZ]);
          WriteSysLog(nStr);
          {$IFDEF DaiWCInManual}
            nStr := '车辆[ %s ]存在未处理的误差量较大的信息:' + #13#10 +
                    '检测完毕后,请点确认重新过磅.';
            nStr := Format(nStr, [FTruck]);

            if not VerifyManualEventRecordEx(FID + sFlag_ManualC, nStr) then
            begin
              nStr := '车辆[ %s ]存在未处理的误差量较大的信息:' + #13#10 +
                    '检测完毕后,请点确认重新过磅.';
              nStr := Format(nStr, [FTruck]);
              PlayVoice(nStr);

              nStr := GetTruckNO(FTruck) + '请去包装点包';
              LEDDisplay(nStr);

              {$IFDEF ProberShow}
                {$IFDEF MITTruckProber}
                ProberShowTxt(FPoundTunnel.FID, nStr);
                {$ELSE}
                gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
                {$ENDIF}
              {$ENDIF}
              Exit;
            end;
          {$ENDIF}
        end;
        if ((FType = sFlag_Dai) and (
            ((nVal > 0) and (FPoundDaiZ > 0) and (nVal > FPoundDaiZ)) or
            ((nVal < 0) and (FPoundDaiF > 0) and (-nVal > FPoundDaiF)))) then
        begin
          {$IFDEF AutoPoundInManual}
          FHasDaiWC:= True;
          nStr := '车辆[%s]实际装车量误差较大，请通知司机点验包数';
          nStr := Format(nStr, [FTruck]);
          PlayVoice(nStr);

          nStr := '车辆[ %s ]实际装车量误差较大,详情如下:' + #13#10#13#10 +
                  '※.开单量: %.2f吨' + #13#10 +
                  '※.装车量: %.2f吨' + #13#10 +
                  '※.误差量: %.2f公斤';

          if FDaiWCStop then
          begin
            nStr := nStr + #13#10#13#10 + '请通知司机点验包数.';
            nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, nVal]);

            ShowDlg(nStr, sHint);
            Exit;
          end else
          begin
            nStr := nStr + #13#10#13#10 + '是否继续保存?';
            nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, nVal]);
            if not QueryDlg(nStr, sAsk) then Exit;
          end;
          {$ELSE}
          FHasDaiWC:= True;
          nStr := '车辆[ %s ]实际装车量误差较大,详情如下:' + #13#10 +
                  '※.开单量: %.2f吨' + #13#10 +
                  '※.装车量: %.2f吨' + #13#10 +
                  '※.误差量: %.2f公斤' + #13#10 +
                  '检测完毕后,请点确认重新过磅.';
          nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, nVal]);

          if not VerifyManualEventRecord(FID + sFlag_ManualC, nStr) then
          begin
            AddManualEventRecord(FID + sFlag_ManualC, FTruck, nStr,
              sFlag_DepBangFang, sFlag_Solution_YN, sFlag_DepJianZhuang, True);
            WriteSysLog(nStr);

            nStr := '车辆[n1]%s净重[n2]%.2f吨,开票量[n2]%.2f吨,'+
                    '误差量[n2]%.2f公斤,请去包装点包';
            nStr := Format(nStr, [FTruck, nNet, FInnerData.FValue, nVal]);
            PlayVoice(nStr);

            nStr := GetTruckNO(FTruck) + '请去包装点包';
            LEDDisplay(nStr);

            {$IFDEF ProberShow}
              {$IFDEF MITTruckProber}
              ProberShowTxt(FPoundTunnel.FID, nStr);
              {$ELSE}
              gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
              {$ENDIF}
            {$ENDIF}
            Exit;
          end;
          {$ENDIF}
        end;

        if (FType = sFlag_San) and IsStrictSanValue and
           FloatRelation(FValue, nNet, rtLess, cPrecision) then
        begin
          nStr := '车辆[n1]%s[p500]净重[n2]%.2f吨[p500]开票量[n2]%.2f吨,请卸货';
          nStr := Format(nStr, [FTruck, Float2Float(nNet, cPrecision, True),
                  Float2Float(FValue, cPrecision, True)]);
          WriteSysLog(nStr);
          PlayVoice(nStr);
          Exit;
        end;
      end;
    end
    else
    begin
      nNet := FUIData.FMData.FValue;
      nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

      if (nNet > 0) and (Abs(nVal) > gSysParam.FEmpTruckWc) then
      begin
        nVal := nVal - gSysParam.FEmpTruckWc;
        nStr := '车辆[n1]%s[p500]空车出厂超差[n2]%.2f公斤,请司机联系司磅管理员检查车厢';
        nStr := Format(nStr, [FBillItems[0].FTruck, Float2Float(nVal, cPrecision, True)]);
        WriteSysLog(nStr);
        PlayVoice(nStr);
        Exit;
      end;
    end;
  end;


  if FBillItems[0].FYSValid = sFlag_Yes then //空车出厂
    PlayVoice(Format('%s 空车出厂', [FBillItems[0].FTruck]));

  with FBillItems[0] do
  begin
    FPModel := FUIData.FPModel;
    FFactory := gSysParam.FFactNum;

    with FPData do
    begin
      FStation := FPoundTunnel.FID;
      FValue := FUIData.FPData.FValue;
      FOperator := gSysParam.FUserID;
    end;

    with FMData do
    begin
      FStation := FPoundTunnel.FID;
      FValue := FUIData.FMData.FValue;
      FOperator := gSysParam.FUserID;

      {$IFDEF MValueAddPersonWeight}
      if FNextStatus = sFlag_TruckBFM then
      begin
        nMValue:= 0;
        GetPersonWeight(nMValue);
        FValue := FUIData.FMData.FValue + nMValue;
      end;
      {$ENDIF}
    end;

    WriteSysLog(Format('自动称重销售单 单号：%s  %s  %s 毛重：%.2f 皮重：%.2f ', [
              FBillItems[0].FID, FBillItems[0].FTruck, FUIData.FStockName, FMData.FValue, FPData.FValue]));
    FPoundID := sFlag_Yes;
    //标记该项有称重数据
    FSaveResult := SaveLadingBills(FNextStatus, FBillItems, FPoundTunnel, FLogin);
    Result := FSaveResult;
    //保存称重
  end;
end;

//------------------------------------------------------------------------------
//Desc: 原材料或临时
function TfFrameAutoPoundItem.SavePoundData: Boolean;
var nNextStatus: string;
begin
  Result := False;
  //init

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) then
  begin
    if FUIData.FPData.FValue > FUIData.FMData.FValue then
    begin
      WriteLog('皮重应小于毛重');
      Exit;
    end;
  end;

  WriteSysLog(Format('自动称重原料单 单号：%s  %s  %s  毛重：%.2f  皮重：%.2f', [FBillItems[0].FID, FBillItems[0].FTruck, FUIData.FStockName,
                                                                        FUIData.FMData.FValue, FUIData.FPData.FValue]));

  nNextStatus := FBillItems[0].FNextStatus;
  //暂存过磅状态

  SetLength(FBillItems, 1);
  FBillItems[0] := FUIData;
  //复制用户界面数据

  with FBillItems[0] do
  begin
    FFactory := gSysParam.FFactNum;
    //xxxxx

    if FNextStatus = sFlag_TruckBFP then
         FPData.FStation := FPoundTunnel.FID
    else FMData.FStation := FPoundTunnel.FID;
  end;
  
  if FCardUsed = sFlag_Provide then
       FSaveResult := SavePurchaseOrders(nNextStatus, FBillItems,FPoundTunnel, FLogin)
  else FSaveResult := SaveDuanDaoItems(nNextStatus, FBillItems, FPoundTunnel, FLogin);
  //保存称重
  Result := FSaveResult;
end;

//Desc: 读取表头数据
procedure TfFrameAutoPoundItem.OnPoundDataEvent(const nValue: Double);
begin
  try
    if FIsSaving then Exit;
    //正在保存。。。

    OnPoundData(nValue);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      SetUIData(True);
    end;
  end;
end;

//Desc: 处理表头数据
procedure TfFrameAutoPoundItem.OnPoundData(const nValue: Double);
var nRet: Boolean;
    nInt: Int64;
    nStr, nOPenDoor: string;
begin
  FLastBT := GetTickCount;
  EditValue.Text := Format('%.2f', [nValue]);

  if FIsChkPoundStatus  then Exit;
  //检查地磅状态
  if not FIsWeighting then Exit;
  //不在称重中
  if gSysParam.FIsManual then Exit;
  //手动时无效

  if nValue < FPoundTunnel.FPort.FMinValue then //空磅
  begin
    if FEmptyPoundInit = 0 then
      FEmptyPoundInit := GetTickCount;
    nInt := GetTickCount - FEmptyPoundInit;

    if not FTips then
    if ((FEmptyPoundIdleLong * 1000 - nInt) <= 20 * 1000) then
    begin
      nStr:= Format('称重即将超时、%s 请在 20 秒内上磅', [ FUIData.FTruck ]);
      PlayVoice(nStr);
      WriteSysLog(nStr);
      FTips:= True;
    end;
    if (nInt > FEmptyPoundIdleLong * 1000) then
    begin
      FIsWeighting :=False;
      Timer_SaveFail.Enabled := True;

      WriteSysLog(Format('%s %s 刷卡后司机无响应,退出称重.' , [FPoundTunnel.FID, FPoundTunnel.FName]));
      PlayVoice('系统退出称重、如需上磅称重请重新刷卡');
      Exit;
    end;
    //上磅时间,延迟重置

    if (nInt > FEmptyPoundIdleShort * 1000) and   //保证空磅
       (FDoneEmptyPoundInit>0) and (GetTickCount-FDoneEmptyPoundInit>nInt) then
    begin
      FIsWeighting :=False;
      Timer_SaveFail.Enabled := True;

      WriteSysLog('司机已下磅,退出称重.');
      Exit;
    end;
    //上次保存成功后,空磅超时,认为车辆下磅

    Exit;
  end else
  begin
    FEmptyPoundInit := 0;
    if FDoneEmptyPoundInit > 0 then
      FDoneEmptyPoundInit := GetTickCount;
    //车辆称重完毕后，未下磅
  end;

  AddSample(nValue);
  if not IsValidSamaple then Exit;
  //样本验证不通过

  if Length(FBillItems) < 1 then Exit;
  //无称重数据

  //if FCardUsed = sFlag_Provide then
  //临时过磅也对调重量
  if FCardUsed <> sFlag_Sale then
  begin
    if FInnerData.FPData.FValue > 0 then
    begin
      if nValue <= FInnerData.FPData.FValue then
      begin
        FUIData.FPData := FInnerData.FMData;
        FUIData.FMData := FInnerData.FPData;

        FUIData.FPData.FValue := nValue;
        FUIData.FNextStatus := sFlag_TruckBFP;
        //切换为称皮重
      end else
      begin
        FUIData.FPData := FInnerData.FPData;
        FUIData.FMData := FInnerData.FMData;

        FUIData.FMData.FValue := nValue;
        FUIData.FNextStatus := sFlag_TruckBFM;
        //切换为称毛重
      end;
    end else FUIData.FPData.FValue := nValue;
  end else
  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
       FUIData.FPData.FValue := nValue
  else FUIData.FMData.FValue := nValue;

  SetUIData(False);
  //更新界面

  {$IFDEF MITTruckProber}
    if not IsTunnelOK(FPoundTunnel.FID) then
  {$ELSE}
    {$IFDEF HR1847}
    if not gKRMgrProber.IsTunnelOK(FPoundTunnel.FID) then
    {$ELSE}
      {$IFNDEF TruckProberEx}
      if not gProberManager.IsTunnelOK(FPoundTunnel.FID) then
      {$ELSE}
      if not gProberManager.IsTunnelOKEx(FPoundTunnel.FID) then
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
  begin
    nStr := '车辆未停到位,请移动车辆.';
    PlayVoice(nStr);
    LEDDisplay(nStr);
    WriteSysLog(nStr);

    InitSamples;
    Exit;
  end;

  FIsSaving := True;

  if FCardUsed = sFlag_Sale then
       nRet := SavePoundSale
  else nRet := SavePoundData;

  if nRet then
  begin
    {$IFDEF XXMD}
    if (FCardUsed = sFlag_Sale) and (FBillItems[0].FType = sFlag_Dai)
       and (FBillItems[0].FNextStatus = sFlag_TruckBFM) then
      nStr := GetTruckNO(FUIData.FTruck) + '票重:' +
              GetValue(StrToFloatDef(EditZValue.Text,0))
    else
      nStr := GetTruckNO(FUIData.FTruck) + '称重完成';
    LEDDisplay(nStr);
    {$ELSE}
    if (FCardUsed = sFlag_Sale) and (FBillItems[0].FType = sFlag_Dai)
       and (FBillItems[0].FNextStatus = sFlag_TruckBFM) then
      nStr := GetTruckNO(FUIData.FTruck) + '票重:' +
              GetValue(StrToFloatDef(EditZValue.Text,0))
    else
      nStr := GetTruckNO(FUIData.FTruck) + '重量:' + GetValue(nValue);
    LEDDisplay(nStr);
    {$ENDIF}

    {$IFDEF ProberShow}
      {$IFDEF MITTruckProber}
      ProberShowTxt(FPoundTunnel.FID, nStr);
      {$ELSE}
      gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
      {$ENDIF}
    {$ENDIF}

    TimerDelay.Enabled := True
  end
  else
  begin
    if not FSaveResult then
    begin
      nStr := GetTruckNO(FUIData.FTruck) + '数据保存失败';
      {$IFDEF MITTruckProber}
      ProberShowTxt(FPoundTunnel.FID, nStr);
      {$ELSE}
      gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
      {$ENDIF}

      nStr := '数据保存失败,请重新过磅.';
      {$IFDEF XPDS}
      PlayVoice(nStr);
      {$ELSE}
        {$IFDEF PoundOpenBackGate}
        if gSysParam.FPoundOpenBackGate then
          nStr := nStr + ',请倒车下磅';
        {$ENDIF}

        {$IFDEF HasDaiWCNoOpenGate}
        if not FHasDaiWC then   {$ENDIF}
        OpenDoorByReader(FLastReader, nOPenDoor);
        //打开副道闸

        PlayVoice(nStr);
        begin
          nOPenDoor:= sFlag_No; //默认打开副道闸
          {$IFDEF PoundOpenBackGate}
            if gSysParam.FPoundOpenBackGate then
              nOPenDoor:=  sFlag_Yes; //特殊情况过磅失败打开主道闸(后杆)
          {$ENDIF}
          OpenDoorByReader(FLastReader, nOPenDoor);
          //打开副道闸
        end;
      {$ENDIF}
    end;

    Timer_SaveFail.Enabled := True;
  end;

  if FBarrierGate and FSaveResult then
  begin
    nOPenDoor:= sFlag_No; //默认打开副道闸
    {$IFDEF PoundOpenBackGate}
      if (not nRet) and gSysParam.FPoundOpenBackGate then
        nOPenDoor:=  sFlag_Yes; //特殊情况过磅失败打开主道闸(后杆)
    {$ENDIF}

    OpenDoorByReader(FLastReader, nOPenDoor);
    //打开副道闸
  end;
end;

procedure TfFrameAutoPoundItem.TimerDelayTimer(Sender: TObject);
begin
  try
    TimerDelay.Enabled := False;
    WriteSysLog(Format('%s 对车辆[ %s ]称重完毕.', [FPoundTunnel.FID, FUIData.FTruck]));
    PlayVoice(#9 + FUIData.FTruck);
    //播放语音                                   

    FLastCard     := FCardTmp;
    FLastCardDone := GetTickCount;
    FDoneEmptyPoundInit := GetTickCount;
    //保存状态

    if not FBarrierGate then
      FIsWeighting := False;
    //磅上无道闸时，即时过磅完毕

    {$IFDEF MITTruckProber}
        TunnelOC(FPoundTunnel.FID, True);
    {$ELSE}
      {$IFDEF HR1847}
      gKRMgrProber.TunnelOC(FPoundTunnel.FID, True);
      {$ELSE}
      gProberManager.TunnelOC(FPoundTunnel.FID, True);
      {$ENDIF}
    {$ENDIF} //开红绿灯

    Timer2.Enabled := True;  FIsWeighting := False;      tmr_ShowDefault.Enabled:= True;
    SetUIData(True);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化样本
procedure TfFrameAutoPoundItem.InitSamples;
var nIdx: Integer;
begin
  SetLength(FValueSamples, FPoundTunnel.FSampleNum);
  FSampleIndex := Low(FValueSamples);

  for nIdx:=High(FValueSamples) downto FSampleIndex do
    FValueSamples[nIdx] := 0;
  //xxxxx
end;

//Desc: 添加采样
procedure TfFrameAutoPoundItem.AddSample(const nValue: Double);
begin
  FValueSamples[FSampleIndex] := nValue;
  Inc(FSampleIndex);

  if FSampleIndex >= FPoundTunnel.FSampleNum then
    FSampleIndex := Low(FValueSamples);
  //循环索引
end;

//Desc: 验证采样是否稳定
function TfFrameAutoPoundItem.IsValidSamaple: Boolean;
var nIdx: Integer;
    nVal: Integer;
begin
  Result := False;

  for nIdx:=FPoundTunnel.FSampleNum-1 downto 1 do
  begin
    if FValueSamples[nIdx] < 0.02 then Exit;
    //样本不完整

    nVal := Trunc(FValueSamples[nIdx] * 1000 - FValueSamples[nIdx-1] * 1000);
    if Abs(nVal) >= FPoundTunnel.FSampleFloat then Exit;
    //浮动值过大
  end;

  Result := True;
end;

procedure TfFrameAutoPoundItem.PlayVoice(const nStrtext: string);
begin
  {$IFNDEF DEBUG}
  if (Assigned(FPoundTunnel.FOptions)) and
     (CompareText('NET', FPoundTunnel.FOptions.Values['Voice']) = 0) then
       gNetVoiceHelper.PlayVoice(nStrtext, FPoundTunnel.FID, 'pound')
  else gVoiceHelper.PlayVoice(nStrtext);
  {$ENDIF}
end;

procedure TfFrameAutoPoundItem.Timer_SaveFailTimer(Sender: TObject);
var nOPenDoor: string;
begin
  inherited;
  try
    FDoneEmptyPoundInit := GetTickCount;
    Timer_SaveFail.Enabled := False;
    SetUIData(True);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

procedure TfFrameAutoPoundItem.EditBillKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  try
    Key := #0;
    EditBill.Text := Trim(EditBill.Text);

    if FIsWeighting or EditBill.Properties.ReadOnly or
       (EditBill.Text = '') then
    begin
      SwitchFocusCtrl(ParentForm, True);
      Exit;
    end;

    {$IFDEF DEBUG}
    FCardTmp := EditBill.Text;
    LoadBillItems(EditBill.Text);
    {$ENDIF}
  finally
    EditBill.Enabled := True;
  end;
end;

procedure TfFrameAutoPoundItem.LEDDisplay(const nContent: string);
begin
  {$IFDEF BFLED}
  WriteSysLog(Format('LEDDisplay:%s.%s', [FPoundTunnel.FID, nContent]));
  if Assigned(FPoundTunnel.FOptions) And
     (UpperCase(FPoundTunnel.FOptions.Values['LEDEnable'])='Y') then
  begin
    if FLEDContent = nContent then Exit;
    FLEDContent := nContent;
    gDisplayManager.Display(FPoundTunnel.FID, nContent);
  end;
  {$ENDIF}
end;

function TfFrameAutoPoundItem.ChkPoundStatus:Boolean;
var nIdx:Integer;
    nHint : string;
begin
  Result:= True;
  try
    try
      FIsChkPoundStatus:= True;
      if not FPoundTunnel.FUserInput then
      if not gPoundTunnelManager.ActivePort(FPoundTunnel.FID,
             OnPoundDataEvent, True) then
      begin
        nHint := '检查地磅：连接地磅表头失败，请联系管理员检查硬件连接';
        WriteSysLog(nHint);
        PlayVoice(nHint);
      end;

      for nIdx:= 0 to 5 do
      begin
        Sleep(500);  Application.ProcessMessages;
        if StrToFloatDef(Trim(EditValue.Text), -1) > 0.02 then
        begin
          Result:= False;
          nHint := '检查地磅：地磅称重重量 %s ,不能进行称重作业';
          nhint := Format(nHint, [EditValue.Text]);
          WriteSysLog(nHint);

          PlayVoice('不能进行称重作业,无关车辆、人员请立即下榜');
          Break;
        end;
      end;

      if nIdx>5 then
        WriteSysLog('地磅状态检查通过');
    except
      on Ex: Exception do
      begin
        Result:= False;
        WriteLog('地磅状态检查异常：' + Ex.Message);
      end;
    end;
  finally
    FIsChkPoundStatus:= False;
    SetUIData(True);
  end;
end;

function TfFrameAutoPoundItem.CheckMValue: Boolean;
var nStr, nStatus: string;
    nVal: Double;
begin
  Result := True;
  nStr   := ' Select S_MValueMax From %s ';
  nStr   := Format(nStr, [sTable_SaleMValueInfo]);

  with FDM.QueryTemp(nStr),FUIData do
  if RecordCount > 0 then
  begin
    nVal := Fields[0].AsFloat;
    if nVal <= 0 then Exit;

    Result := nVal >= FUIData.FMData.FValue;
    if Result then Exit;

    nStr := '车辆[ %s ]重车超过上限,详情如下:' + #13#10 +
            '※.毛重上限: %.2f吨' + #13#10 +
            '※.当前毛重: %.2f吨' + #13#10 +
            '※.超 重 量: %.2f吨' + #13#10 +
            '是否允许过磅?';
    nStr := Format(nStr, [FTruck, nVal, FMData.FValue, FMData.FValue-nVal]);

    Result := VerifyManualEventRecord(FID + sFlag_ManualF, nStr, sFlag_Yes, False);
    if Result then Exit; //管理员放行

    AddManualEventRecord(FID + sFlag_ManualF, FTruck, nStr, sFlag_DepBangFang,
      sFlag_Solution_YN, sFlag_DepDaTing, True);
    WriteSysLog(nStr);
    

    nStr := '[n1]%s毛重%.2f吨,请返回卸料.';
    nStr := Format(nStr, [FTruck, FMData.FValue]);
    PlayVoice(nStr);

    nStr := GetTruckNO(FTruck) + '请返回卸料';
    LEDDisplay(nStr);
    Result := False;
  end;
end;

function TfFrameAutoPoundItem.CheckTruckMValue: Boolean;
var nStr, nStatus: string;
    nVal: Double;
begin
  Result := True;
  nVal   := 0;
  nStr   := ' Select T_Limited From %s Where T_Truck = ''%s''  ';
  nStr   := Format(nStr, [sTable_Truck, FUIData.FTruck]);

  with FDM.QueryTemp(nStr),FUIData do
  if RecordCount > 0 then
  begin
    nVal := Fields[0].AsFloat;
    if nVal <= 0 then Exit;

    Result := nVal >= FUIData.FMData.FValue;
    if Result then Exit;

    nStr := '车辆[ %s ]重车超过上限,详情如下:' + #13#10 +
            '※.毛重上限: %.2f吨' + #13#10 +
            '※.当前毛重: %.2f吨' + #13#10 +
            '※.超 重 量: %.2f吨' + #13#10 +
            '是否允许过磅?';
    nStr := Format(nStr, [FTruck, nVal, FMData.FValue, FMData.FValue-nVal]);

    Result := VerifyManualEventRecord(FID + sFlag_ManualF, nStr, sFlag_Yes, False);
    if Result then Exit; //管理员放行

    AddManualEventRecord(FID + sFlag_ManualF, FTruck, nStr, sFlag_DepBangFang,
      sFlag_Solution_YN, sFlag_DepBangFang, True);
    WriteSysLog(nStr);
    

    nStr := '[n1]%s毛重%.2f吨,请返回卸料.';
    nStr := Format(nStr, [FTruck, FMData.FValue]);
    PlayVoice(nStr);

    nStr := GetTruckNO(FTruck) + '请返回卸料';
    LEDDisplay(nStr);
    Result := False;
  end;
end;

procedure TfFrameAutoPoundItem.tmr_ShowDefaultTimer(Sender: TObject);
var nStr:string;
begin
  tmr_ShowDefault.Enabled:= False;
  nStr:= gSysParam.FPoundLEDTxt;
  {$IFDEF MITTruckProber}
    ProberShowTxt(FPoundTunnel.FID, nStr);
  {$ELSE}
    gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
  {$ENDIF}
end;

end.
