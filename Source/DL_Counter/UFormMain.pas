{*******************************************************************************
  ����: dmzn@163.com 2012-4-29
  ����: HXDeliveryǰ�˼�����
*******************************************************************************}
unit UFormMain;

{$I Link.Inc}
{$I js_inc.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  {$IFDEF ZJModBusTCPJSQ} UMultiJS_Reply_ZJ, {$ELSE}
  {$IFDEF MultiReplay}UMultiJS_Reply, {$ELSE}UMultiJS, {$ENDIF}  {$ENDIF}
  UMultiModBus_JS, UMgrdOPCTunnels, UFormLogin,
  USysConst, UFrameJS, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, ImgList, dxorgchr, cxSplitter, ComCtrls,
  ToolWin, ExtCtrls, UMemDataPool, dxSkinsCore, dxSkinsDefaultPainters,
  dOPCIntf, dOPCComn, dOPCDA, dOPC;

type
  TfFormMain = class(TForm)
    wPanel: TScrollBox;
    SBar: TStatusBar;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    BtnRefresh: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    cxSplitter1: TcxSplitter;
    BtnLog: TToolButton;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    dxChart1: TdxOrgChart;
    N2: TMenuItem;
    N3: TMenuItem;
    Timer1: TTimer;
    BtnCard: TToolButton;
    ToolButton4: TToolButton;
    ToolButton1: TToolButton;
    BtnPsw: TToolButton;
    ToolButton6: TToolButton;
    BtnSetPsw: TToolButton; 
    gOPCServer: TdOPCServer;
    procedure wPanelResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnLogClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure dxChart1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure dxChart1Click(Sender: TObject);
    procedure dxChart1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure dxChart1Collapsing(Sender: TObject; Node: TdxOcNode;
      var Allow: Boolean);
    procedure dxChart1DblClick(Sender: TObject);
    procedure BtnCardClick(Sender: TObject);
    procedure BtnPswClick(Sender: TObject);
    procedure BtnSetPswClick(Sender: TObject);
  private
    { Private declarations }
    FLastRefresh: Int64;
    //�ϴ�ˢ��
    FLines: TZTLineItems;
    FTrucks: TZTTruckItems;
    //��������
    FNodeFrom,FNodeTarget: TdxOcNode;
    //���ƽڵ�
    procedure InitFormData;
    //��ʼ��
    function GetLinePeerWeight(const nLine: string): Integer;
    //��ȡ����
    function FindCounter(const nTunnel: string): TfFrameCounter;
    //����ͨ��
    procedure RefreshData(const nRefreshLine: Boolean);
    //ˢ�¶���
    function FindNode(const nID: string): TdxOcNode;
    //�����ڵ�
    procedure InitZTLineItem(const nNode: TdxOcNode);
    procedure InitZTTruckItem(const nNode: TdxOcNode);
    //�ڵ���
    procedure LoadTunnelPanels;
    //�������
    procedure LoadTunnelPanelsEx;
    //�������
    procedure ResetPanelPosition;
    //����λ��
    procedure OnSyncChange(const nTunnel: PMultiJSTunnel);
    //�����䶯
    procedure OnSyncChangeEx(const nTunnel: PJSTunnel);
    //�����䶯
    //-----------------------------------------------------------------------
    procedure LoadPoundItemsOPC;
    procedure LoadJSPanels;
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;
  fFormLogin: TfFormLogin;
  


implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrChannel, UFormLog, UFormWait, UFormCard,
  USysLoger, USysMAC, USysDB, UMgrCodePrinter, UFormInputbox, UBase64,
  UFrame, UFrameJSEx;

procedure TfFormMain.FormCreate(Sender: TObject);
var nInt: Integer;
    nIni: TIniFile;
begin
  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig {$IFDEF UseJSLogin}, gPath + sDBConfig{$ENDIF});

  {$IFDEF UseJSLogin}
  Timer1.Enabled := False;
  fFormLogin:= TfFormLogin.Create(nil);
  fFormLogin.ShowModal;

  if not fFormLogin.FIsLogin then
    Application.Terminate;

  //fFormLogin.Close;
  
  Timer1.Enabled := True;
  fFormMain.Caption:= '��װװ��������    ' + gSysParam.FUserName + '  �ѵ�¼';
  {$ENDIF}

  gMemDataManager := TMemDataManager.Create;
  {$IFDEF ZJModBusTCPJSQ}
  //�����о�ModTcp������
  gZJMultiJSManager := TMultiJSManager.Create;
  BtnCard.Visible:= false;
  {$ELSE}
    {$IFNDEF UseOPC Mode}
        {$IFNDEF UseModbusJS}
        gMultiJSManager := TMultiJSManager.Create;
        //��ʼ��������
        {$ELSE}
        if not Assigned(gModbusJSManager) then
          gModbusJSManager := TModbusJSManager.Create;

        gMultiJSManager := TMultiJSManager.Create;
        {$ENDIF}
    {$ELSE}
        // OPCServer ��ʽ�������ͨ��
        if not Assigned(gOPCTunnelManager) then
        begin
          gOPCTunnelManager := TOPCTunnelManager.Create;
          gOPCTunnelManager.LoadConfig('Tunnels.xml');
        end;
    {$ENDIF}
  {$ENDIF}

  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    gChannelManager := TChannelManager.Create;
    gSysParam.FHardMonURL := nIni.ReadString('Config', 'HardURL', 'xx');
    {$IFDEF JSQUseMITService}
    gSysParam.FMITServiceURL := nIni.ReadString('Config', 'MITServiceURL', 'xx');
    {$ENDIF}
    gSysParam.FIsEncode := nIni.ReadString('Config', 'Encode', '1') = '1';
    nIni.Free;

    nIni := TIniFile.Create(gPath + sFormConfig);
    LoadFormConfig(Self, nIni);
    nInt := nIni.ReadInteger(Name, 'ChartHeight', 10);

    if nInt < 100 then
      nInt := 100;
    dxChart1.Height := nInt;

    {$IFDEF USE_MIT}
    //ToolBar1.Visible := True;
    BtnRefresh.Visible := True;
    BtnCard.Visible := True;
    {$IFDEF ZJModBusTCPJSQ}BtnCard.Visible:= false; {$ENDIF}
    {$ELSE}
    dxChart1.Visible := False;
    {$ENDIF}

    if not gSysParam.FIsEncode then
    begin
      BtnSetPsw.Visible := False;
      BtnPsw.Visible := False;
    end;
  finally
    nIni.Free;
  end;
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nPannel: TfFrameCounter;
    nIni: TIniFile;
    nIdx: Integer;
    nStr: string;
begin
  {$IFNDEF debug}
  if not QueryDlg('ȷ��Ҫ�رռ�������?', '��ʾ') then
  begin
    Action := caNone; Exit;
  end;
  {$ENDIF}

  {$IFNDEF ZJModBusTCPJSQ}
  {$IFNDEF UseOPCMode}
  ShowWaitForm(Self, 'ֹͣ����');
  try
    {$IFNDEF UseModbusJS}
    if Assigned(gMITReader) then
    begin
      gMITReader.StopMe;
      gMITReader := nil;
    end;

    gMultiJSManager.StopJS;
    {$ELSE}
    if Assigned(gMITReaderEx) then
    begin
      gMITReaderEx.StopMe;
      gMITReaderEx := nil;
    end;
    {$ENDIF}
    Sleep(500);
  finally
    CloseWaitForm;
  end;
  {$ENDIF}
  {$ELSE}gZJMultiJSManager.StopJS;
  {$ENDIF}

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteInteger(Name, 'ChartHeight', dxChart1.Height);
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  {$IFNDEF ZJModBusTCPJSQ}
  {$IFNDEF UseOPCMode}
  nIni := TIniFile.Create(gPath + sPConfigFile);
  try
    for nIdx := 0 to wPanel.ControlCount -1   do
    begin
      nPannel := wPanel.controls[nIdx] as TfFrameCounter;

      nStr := Trim(nPannel.EditCode.Text);
      {$IFNDEF UseModbusJS}
      if Length(nStr) > 0 then
        nIni.WriteString('Tunnel', nPannel.FTunnel.FID, nStr);
      {$ELSE}
      if Length(nStr) > 0 then
        nIni.WriteString('Tunnel', nPannel.FTunnelEx.FID, nStr);
      {$ENDIF}
    end;
  finally
    nIni.Free;
  end;
  //��¼ÿ����������Ϣ
  {$ENDIF}
  {$ENDIF}
end;

//Desc: ��ʱ��ʼ��
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  InitFormData;
  //��ʼ��

  {$IFNDEF ZJModBusTCPJSQ}
    {$IFDEF UseOPCMode}
    Exit;
    {$ENDIF}
    {$IFDEF USE_MIT}
      {$IFNDEF UseModbusJS}
      gMITReader := TMITReader.Create(OnSyncChange);
      {$ELSE}
      gMITReaderEx := TMITReaderEx.Create(OnSyncChangeEx);
      gMITReader   := TMITReader.Create(OnSyncChange);
      {$ENDIF}
    {$ELSE}
      with gMultiJSManager do
      begin
        ChangeSync := OnSyncChange;
        //QueryEnable := True;
        StartJS;
      end;
    {$ENDIF}
  {$ENDIF}
end;

//Desc: ϵͳ���ݳ�ʼ��
procedure TfFormMain.InitFormData;
begin
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');

  {$IFDEF ZJModBusTCPJSQ}
  gZJMultiJSManager.LoadFile(gPath + 'JSQ_ModeBusTCP.xml');
  gZJMultiJSManager.StartJS;
  LoadJSPanels;
  ResetPanelPosition;
  {$ELSE}
  {$IFNDEF UseOPCMode}  // OPCͨѶ
    {$IFNDEF UseModbusJS}
    gMultiJSManager.LoadFile(gPath + 'JSQ.xml');
    {$ELSE}
    if FileExists(gPath + 'ModBusTCPJS.xml') then
      gModbusJSManager.LoadConfig(gPath + 'ModBusTCPJS.xml');
    {$ENDIF}

    if FileExists(gPath + 'CodePrinter.xml') then
      gCodePrinterManager.LoadConfig(gPath + 'CodePrinter.xml');

    {$IFNDEF UseModbusJS}
    LoadTunnelPanels;
    {$ELSE}
    LoadTunnelPanelsEx;
    {$ENDIF}
    ResetPanelPosition;
  {$ELSE}
    try
      LoadPoundItemsOPC;
      ResetPanelPosition;
      gOPCServer.Active := True;
    except
    end;
  {$ENDIF}
  {$ENDIF}
  //******
  with gSysParam do
  begin
    FLocalMAC   := MakeActionID_MAC;
    GetLocalIPConfig(FLocalName, FLocalIP);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����������
procedure TfFormMain.LoadTunnelPanels;
var i,nIdx: Integer;
    nPannel: TfFrameCounter;
    nHost: PMultiJSHost;
    nTunnel: PMultiJSTunnel;
    nIni: TIniFile;
begin
  {$IFNDEF ZJModBusTCPJSQ}
  for nIdx:=0 to gMultiJSManager.Hosts.Count - 1 do
  begin
    nHost := gMultiJSManager.Hosts[nIdx];
    for i:=0 to nHost.FTunnel.Count - 1 do
    begin
      nTunnel := nHost.FTunnel[i];
      nPannel := TfFrameCounter.Create(Self);
      nPannel.Name := Format('fFrameCounter_%d%d', [nIdx, i]);

      nPannel.Parent := wPanel;
      nPannel.FTunnel := nTunnel;
      nPannel.GroupBox1.Caption := nTunnel.FName;

      nIni := TIniFile.Create(gPath + sPConfigFile);
      nPannel.EditCode.Text := nIni.ReadString('Tunnel', nTunnel.FID, '');
      nIni.Free;
      //������Ϣ

      if gSysParam.FIsEncode then
      begin
        nPannel.BtnStart.Enabled := False;
        nPannel.BtnClear.Enabled := False;
        nPannel.BtnPause.Enabled := False;
      end;
    end;
  end;
  {$ENDIF}
end;


//Desc: ���ü������λ��
procedure TfFormMain.ResetPanelPosition;
var nIdx  : Integer;
    nL,nT,nNum : Integer;
    {$IFDEF ZJModBusTCPJSQ}
      nCtrl : TFrameJSEx;
    {$ELSE}
      {$IFDEF UseOPCMode} nCtrl : TFrameOPCJS;
      {$ELSE} nCtrl : TfFrameCounter;
      {$ENDIF}
    {$ENDIF}
begin
  nT := 0;
  nL := 0;
  nNum := 0;

  for nIdx:=0 to wPanel.ControlCount - 1 do
  begin
    {$IFDEF ZJModBusTCPJSQ}
      if wPanel.Controls[nIdx] is TFrameJSEx then
          nCtrl := wPanel.Controls[nIdx] as TFrameJSEx;
    {$ELSE}
      if wPanel.Controls[nIdx] is {$IFNDEF UseOPCMode}TfFrameCounter{$ELSE} TFrameOPCJS{$ENDIF} then
          nCtrl := wPanel.Controls[nIdx] as {$IFNDEF UseOPCMode}TfFrameCounter{$ELSE} TFrameOPCJS{$ENDIF};
    {$ENDIF}

    if nCtrl=nil then Continue;

    if ((nL + nCtrl.Width) > wPanel.ClientWidth) and (nNum > 0) then
    begin
      nL := 0;
      nNum := 0;
      nT := nT + nCtrl.Height;
    end;

    nCtrl.Top := nT;
    nCtrl.Left := nL;

    Inc(nNum);
    nL := nL + nCtrl.Width;
  end;
end;

//Date: 2012-4-29
//Parm: ͨ��
//Desc: ����nTunnelͨ�����
function TfFormMain.FindCounter(const nTunnel: string): TfFrameCounter;
var nIdx: Integer;
    nPanel: TfFrameCounter;
begin
  Result := nil;

  for nIdx:=0 to wPanel.ControlCount - 1 do
  if wPanel.Controls[nIdx] is TfFrameCounter then
  begin
    nPanel := wPanel.Controls[nIdx] as TfFrameCounter;
    {$IFNDEF UseModbusJS}
    if CompareText(nTunnel, nPanel.FTunnel.FID) = 0 then
    begin
      Result := nPanel;
      Exit;
    end;
    {$ELSE}
    if CompareText(nTunnel, nPanel.FTunnelEx.FID) = 0 then
    begin
      Result := nPanel;
      Exit;
    end;
    {$ENDIF}
  end;
end;

//Desc: ��ʾͨ������
procedure TfFormMain.OnSyncChange(const nTunnel: PMultiJSTunnel);
var nPanel: TfFrameCounter;
begin
  nPanel := FindCounter(nTunnel.FID);
  if Assigned(nPanel) then
  begin
    nPanel.LabelHint.Caption := IntToStr(nTunnel.FHasDone);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.wPanelResize(Sender: TObject);
begin
  ResetPanelPosition;
end;

procedure TfFormMain.BtnLogClick(Sender: TObject);
begin
  ShowLogForm;
end;

//Desc: ������ʶΪnID�Ľڵ�
function TfFormMain.FindNode(const nID: string): TdxOcNode;
var nIdx: Integer;
    nP: TdxOcNode;
begin
  Result := nil;
  nP := dxChart1.GetFirstNode;

  while Assigned(nP) do
  begin
    nIdx := Integer(nP.Data);
    //��������

    if nP.Level = 0 then
    begin
      if CompareText(nID, FLines[nIdx].FID) = 0 then
      begin
        Result := nP;
        Exit;
      end;
    end else
    begin
      if CompareText(nID, FTrucks[nIdx].FTruck) = 0 then
      begin
        Result := nP;
        Exit;
      end;
    end;

    nP := nP.GetNext;
  end;
end;

//Desc: ����װ���߽ڵ���
procedure TfFormMain.InitZTLineItem(const nNode: TdxOcNode);
var nInt: Integer;
begin
  nNode.Width := 75;
  nNode.Height := 32;

  nInt := Integer(nNode.Data);
  with FLines[nInt] do
  begin
    nNode.Text := FName;
    if FValid then
         nNode.Color := clWhite
    else nNode.Color := clSilver;
  end;
end;

//Desc: ���ó����ڵ���
procedure TfFormMain.InitZTTruckItem(const nNode: TdxOcNode);
var nInt: Integer;
begin
  nNode.Width := 75;
  nNode.Height := 32;
  
  nInt := Integer(nNode.Data);
  with FTrucks[nInt] do
  begin
    nNode.Text := FTruck;
    nNode.Shape := shRoundRect;

    if FInFact then
    begin
      if FIsRun then
           nNode.Color := clGreen
      else nNode.Color := clSkyBlue;
    end else nNode.Color := clSilver;
  end;
end;

//Desc: ��ȡnNode���һ���ڵ�
function GetLastChild(const nNode: TdxOcNode): TdxOcNode;
var nTmp: TdxOcNode;
begin
  Result := nNode.GetFirstChild;
  if not Assigned(Result) then
    Result := nNode;
  //xxxxx

  while Assigned(Result) do
  begin
    nTmp := Result.GetFirstChild;
    if Assigned(nTmp) then
         Result := nTmp
    else Break;
  end;
end;

//Desc: ��ȡnLine�ߵĴ���
function TfFormMain.GetLinePeerWeight(const nLine: string): Integer;
var nIdx: Integer;
begin
  Result := 50;

  for nIdx:=Low(FLines) to High(FLines) do
  if CompareText(nLine, FLines[nIdx].FID) = 0 then
  begin
    Result := FLines[nIdx].FWeight;
    Break;
  end;
end;

//Desc: ˢ������
procedure TfFormMain.RefreshData(const nRefreshLine: Boolean);
var nIdx: Integer;
    nP: TdxOcNode;
    nPanel: TfFrameCounter;
begin
  ShowWaitForm(Self, '��ȡ����');
  try
    if not LoadTruckQueue(FLines, FTrucks, nRefreshLine) then Exit;
    FLastRefresh := GetTickCount;
  finally
    CloseWaitForm;
  end;

  dxChart1.BeginUpdate;
  try
    dxChart1.Clear;
    for nIdx:=Low(FLines) to High(FLines) do
    begin
      nP := dxChart1.AddChild(nil, Pointer(nIdx));
      InitZTLineItem(nP);
    end;

    for nIdx:=Low(FTrucks) to High(FTrucks) do
    begin
      nP := FindNode(FTrucks[nIdx].FLine);
      if not Assigned(nP) then Continue;

      nP := dxChart1.AddChild(GetLastChild(nP), Pointer(nIdx));
      InitZTTruckItem(nP);
      if not FTrucks[nIdx].FIsRun then Continue;

      nPanel := FindCounter(FTrucks[nIdx].FLine);
      if Assigned(nPanel) and (nPanel.BtnStart.Enabled) then
      begin
        nPanel.FBill := FTrucks[nIdx].FBill;
        nPanel.FPeerWeight := GetLinePeerWeight(FTrucks[nIdx].FLine);
        nPanel.EditTruck.Text := FTrucks[nIdx].FTruck;

        if FTrucks[nIdx].FTotal < 1 then
        begin
          nPanel.EditDai.Text := IntToStr(FTrucks[nIdx].FDai);
          nPanel.EditTon.Text := Format('%.3f', [FTrucks[nIdx].FValue]);
        end else
        begin
          nPanel.EditDai.Text := '0';
        end;
      end;
    end;
  finally
    dxChart1.FullExpand;
    dxChart1.EndUpdate;
  end;
end;

//Desc: ˢ�¶���
procedure TfFormMain.BtnRefreshClick(Sender: TObject);
begin
  if GetTickCount - FLastRefresh >= 2 * 1000 then
       RefreshData(False)
  else ShowMsg('�벻ҪƵ��ˢ��', sHint);
end;

//------------------------------------------------------------------------------
//Desc: Ȩ��
procedure TfFormMain.PMenu1Popup(Sender: TObject);
var nP: TPoint;
    nNode: TdxOcNode;
begin
  ActiveControl := dxChart1;
  GetCursorPos(nP);
  nP := dxChart1.ScreenToClient(nP);

  nNode := dxChart1.GetNodeAt(nP.X, nP.Y);
  dxChart1.Selected := nNode;

  N1.Enabled := Assigned(dxChart1.Selected) and (dxChart1.Selected.Level > 0);
  //�Ƴ�����
  N3.Enabled := Assigned(dxChart1.Selected) and (dxChart1.Selected.Level = 0)
                and (dxChart1.Selected.Count > 0);
  //�������
end;

//Desc: ����
procedure TfFormMain.N1Click(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  nInt := Integer(dxChart1.Selected.Data);
  nStr := Format('�Ƿ�Ҫ������[ %s ]�Ƴ�����?', [FTrucks[nInt].FTruck]);
  if not QueryDlg(nStr, sAsk) then Exit;

  with FTrucks[nInt] do
  begin
    nStr := 'Update %s Set T_Valid=''%s'' Where T_Bill=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, sFlag_No, FBill]);

    RemoteExecuteSQL(nStr);
    RefreshData(False);
    ShowMsg('���ӳɹ�', sHint);
  end;
end;

procedure TfFormMain.N3Click(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  nInt := Integer(dxChart1.Selected.Data);
  nStr := Format('�Ƿ�Ҫ��[ %s ]�����г����Ƴ�����?', [FLines[nInt].FName]);
  if not QueryDlg(nStr, sAsk) then Exit;

  with FLines[nInt] do
  begin
    nStr := 'Update %s Set T_Valid=''%s'' Where T_Line=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, sFlag_No, FID]);

    RemoteExecuteSQL(nStr);
    RefreshData(False);
    ShowMsg('���ӳɹ�', sHint);
  end;
end;

//------------------------------------------------------------------------------ 
procedure TfFormMain.dxChart1Collapsing(Sender: TObject; Node: TdxOcNode;
  var Allow: Boolean);
begin
  Allow := Node.Level = 0;
end;

procedure TfFormMain.dxChart1Click(Sender: TObject);
begin
  if Assigned(dxChart1.Selected) and (dxChart1.Selected.Level = 1) then
       FNodeFrom := dxChart1.Selected.Parent
  else FNodeFrom := nil;

  FNodeTarget := nil;
end;

procedure TfFormMain.dxChart1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var nStr: string;
    nInt: Integer;
    nNode: TdxOcNode;
    nPanel: TfFrameCounter;
begin
  FNodeTarget := nil;
  Accept := Assigned(FNodeFrom);
  
  if not Accept then Exit;
  nInt := Integer(FNodeFrom.Data); //�׳���ѡ��

  nPanel := FindCounter(FLines[nInt].FID);
  Accept := (not Assigned(nPanel)) or nPanel.BtnStart.Enabled;
  if not Accept then Exit;          //�����������ر�

  nNode := dxChart1.GetNodeAt(X, Y);
  Accept := Assigned(nNode) and (nNode.Level = 0);
  if not Accept then Exit;          //Ŀ���׽ڵ�

  nInt := Integer(nNode.Data);
  nStr := FLines[nInt].FStock;

  nInt := Integer(FNodeFrom.Data);
  Accept := CompareText(nStr, FLines[nInt].FStock) = 0;
  if not Accept then Exit;          //Ŀ��Ʒ�ֲ�ƥ��

  FNodeTarget := nNode;
  //��ЧĿ��
end;

procedure TfFormMain.dxChart1EndDrag(Sender, Target: TObject; X,
  Y: Integer);
var nStr: string;
    nInt: Integer;
    nFrom,nTo: string;
    nSFrom,nSTo: string;
begin
  if not Assigned(FNodeFrom) then Exit;
  if not Assigned(FNodeTarget) then Exit;
  //xxxxx
  if FNodeFrom = FNodeTarget then Exit;
  //ԭ��δ��

  nInt := Integer(FNodeFrom.Data);
  nFrom := FLines[nInt].FID;
  nSFrom := FLines[nInt].FName;

  nInt := Integer(FNodeTarget.Data);
  nTo := FLines[nInt].FID;
  nSTo := FLines[nInt].FName;

  nStr := 'Update %s Set T_Line=''%s'' Where T_Line=''%s'' ';
  nStr := Format(nStr, [sTable_ZTTrucks, nTo, nFrom]);
  RemoteExecuteSQL(nStr);

  nStr := '�ѳɹ���������[ %s ]�ƶӵ�[ %s ],��Ⱥ������Ч.';
  nStr := Format(nStr, [nSFrom, nSTo]);
  ShowDlg(nStr, sHint);
end;

//Desc: ��ʾװ����Ϣ
procedure TfFormMain.dxChart1DblClick(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  if not Assigned(dxChart1.Selected) then Exit;
  if dxChart1.Selected.Level < 1 then Exit;
  //not truck node

  nInt := Integer(dxChart1.Selected.Data);
  with FTrucks[nInt] do
  begin
    if not FInFact then
    begin
      ShowMsg('�ó���δ����', sHint);
      Exit;
    end;

    nStr := '����[ %s ]װ����Ϣ����:' + #13#10#13#10 +
            ' ��.��������: %.2f ��' + #13#10 +
            ' ��.Ӧװ����: %d ��' + #13#10 +
            ' ��.��װ����: %d ��' + #13#10 +
            ' ��.ʣ�����: %d ��' + #13#10#13#10 +
            '����Ϣ������ʱ���ӳ����,����ˢ�¶��к��ѯ.';
    nStr := Format(nStr, [FTruck, FValue, FDai, FTotal, FDai - FTotal]);
    ShowDlg(nStr, sHint);
  end;
end;

//Desc: ˢ��
procedure TfFormMain.BtnCardClick(Sender: TObject);
begin
  if ShowCardForm then
  begin
    Sleep(3 * 1000);
    RefreshData(False);               
    ShowMsg('��ˢ�¶�����Ч', '�����ɹ�');
  end;
end;

procedure TfFormMain.BtnPswClick(Sender: TObject);
var nPannel: TfFrameCounter;
    nStr, nPswConf: string;
    nHost: PMultiJSHost;
    i,nIdx: Integer;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sPConfigFile);
  try
    nPswConf := nIni.ReadString('Config', 'pwd', 'xx');

    if not ShowInputPWDBox('����������: ', sHint, nStr) then Exit;
    if Length(nStr) < 1 then
    begin
      ShowWaitForm(Self, '���벻��Ϊ��!');
      Sleep(2000);
      CloseWaitForm;
      Exit;
    end;

    if (nStr <> DecodeBase64(nPswConf)) and
       (nStr <> 'dladmin') then //Ĭ������:dladmin
    begin
      ShowWaitForm(Self, '�������');
      Sleep(2000);
      CloseWaitForm;
      Exit;
    end;
  finally
    nIni.Free;
  end;

  {$IFNDEF ZJModBusTCPJSQ}
  {$IFNDEF UseModbusJS}
  for nIdx:=0 to gMultiJSManager.Hosts.Count - 1 do
  begin
    nHost := gMultiJSManager.Hosts[nIdx];
    for i:=0 to nHost.FTunnel.Count - 1 do
    begin
      nPannel := FindComponent(Format('fFrameCounter_%d%d', [nIdx, i]))
                 as TfFrameCounter;
      nPannel.BtnStart.Enabled := True;
      nPannel.BtnClear.Enabled := True;
      nPannel.BtnPause.Enabled := True;
    end;
  end;
  {$ELSE}
  for nIdx:=0 to gModbusJSManager.FHostList.Count - 1 do
  begin
    nPannel := FindComponent(Format('fFrameCounter_%d%d', [nIdx, nIdx]))
               as TfFrameCounter;
    nPannel.BtnStart.Enabled := True;
    nPannel.BtnClear.Enabled := True;
    nPannel.BtnPause.Enabled := True;
  end;
  {$ENDIF}
  {$ENDIF}

  BtnSetPsw.Enabled := True;
  //�����޸�����
end;

procedure TfFormMain.BtnSetPswClick(Sender: TObject);
var nStr :string ;
    nIni: TIniFile;
begin
  if not ShowInputPWDBox('����������: ', sHint, nStr) then Exit;

  nIni := TIniFile.Create(gPath + sPConfigFile);
  nIni.WriteString('Config','PWD',EncodeBase64(nStr));
  nIni.Free;
end;

procedure TfFormMain.LoadTunnelPanelsEx;
var nIdx: Integer;
    nPannel: TfFrameCounter;
    nTunnel: PJSTunnel;
    nIni: TIniFile;
begin
  for nIdx:=0 to gModbusJSManager.FHostList.Count - 1 do
  begin
    nTunnel := gModbusJSManager.FHostList[nIdx];

    nPannel := TfFrameCounter.Create(Self);
    nPannel.Name := Format('fFrameCounter_%d%d', [nIdx, nIdx]);

    nPannel.Parent := wPanel;
    nPannel.FTunnelEx := nTunnel;
    nPannel.GroupBox1.Caption := nTunnel.FName;

    nIni := TIniFile.Create(gPath + sPConfigFile);
    nPannel.EditCode.Text := nIni.ReadString('Tunnel', nTunnel.FID, '');
    nIni.Free;
    //������Ϣ

    if gSysParam.FIsEncode then
    begin
      nPannel.BtnStart.Enabled := False;
      nPannel.BtnClear.Enabled := False;
      nPannel.BtnPause.Enabled := False;
    end;
  end;
end;

procedure TfFormMain.OnSyncChangeEx(const nTunnel: PJSTunnel);
var nPanel: TfFrameCounter;
begin
  nPanel := FindCounter(nTunnel.FID);
  if Assigned(nPanel) then
  begin
    nPanel.LabelHint.Caption := IntToStr(nTunnel.FHasDone);
  end;
end;
//----------------------------------------------------OPC

procedure TfFormMain.LoadPoundItemsOPC;
var nIdx: Integer;
    nT: PPTOPCItem;
begin
  with gOPCTunnelManager do
  begin
    for nIdx:= 0 to Tunnels.Count-1 do
    begin
      gOPCServer.OPCGroups.Add('Group' + IntToStr(nIdx));
    end;
    
    for nIdx:= 0 to Tunnels.Count-1 do
    begin
      if nIdx > 5 then
      begin
        ShowMsg('�������ͨ��', '����');
        Exit;
      end;
      nT := Tunnels[nIdx];
      //tunnel

      if nT.FEnable <> 'Y' then
      begin
        Continue;
      end;

      with TFrameOPCJS.Create(Self) do
      begin
        Name := 'fFrameOPCCtrl' + IntToStr(nIdx);
        Parent := wPanel;

        FrameId := nIdx;

        GroupBox1.Caption    := nT.FName;
        lblTunnelName.Caption:= nT.FName;
        OPCTunnel := nT;

        if gOPCServer.ServerName = '' then
          gOPCServer.ServerName := nT.FServer;

        if gOPCServer.ComputerName = '' then
          gOPCServer.ComputerName := nT.FComputer;

        with gOPCServer.OPCGroups[nIdx].OPCItems do
        begin
          AddItem(nT.FValueSet);
        end;
        FSysLoger:= gSysLoger;
        btnSendDai.Enabled:= False;
      end;
    end;
  end;
end;


//Desc: ����������
procedure TfFormMain.LoadJSPanels;
var nIdx, nIdxA: Integer;
    nHost: PMultiJSHost;
    nTunnel: PMultiJSTunnel;
    nIni: TIniFile;
begin
  {$IFDEF ZJModBusTCPJSQ}
  for nIdx:=0 to gZJMultiJSManager.Hosts.Count - 1 do
  begin
    nHost := gZJMultiJSManager.Hosts[nIdx];
    for nIdxA:= 0 to nHost.FTunnel.Count - 1 do
    begin
      nTunnel := nHost.FTunnel[nIdxA];
      //tunnel

      with TFrameJSEx.Create(Self) do
      begin
        Name := 'fFrameZJJSCtrl' + IntToStr(nIdxA);
        Parent := wPanel;

        FrameId := nIdx;
        lbl_DaiNum.Caption   := '';
        GroupBox1.Caption    := nTunnel.FName;
        lblTunnelName.Caption:= nTunnel.FName;
        FTunnel.FID   := nTunnel.FID;
        FTunnel.FName := nTunnel.FName;

        FSysLoger:= gSysLoger;
        btnSendDai.Enabled:= False;
      end;
    end;
  end;
  {$ENDIF}
end;


end.
