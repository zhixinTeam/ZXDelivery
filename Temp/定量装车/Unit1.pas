unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CPort, UMgrBasisWeight;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Timer1: TTimer;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    procedure Dolog(const nStr: string);
    procedure OnStatus(const nTunnel: PBWTunnel);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  USysLoger, UMgrTTCEDispenser, UMgrPoundTunnels, IdGlobal, ULibFun;

var
  gPath: string;

procedure TForm1.Dolog(const nStr: string);
begin
  Memo1.Lines.Add(nStr);
end;

function WhenParsePoundWeight(const nPort: PPTPortItem): Boolean;
var nIdx,nLen: Integer;
    nVerify: Word;
    nBuf: TIdBytes;
begin
  Result := False;
  nBuf := ToBytes(nPort.FCOMBuff, Indy8BitEncoding);
  nLen := Length(nBuf) - 2;
  if nLen < 52 then Exit; //48-51为磅重数据

  nVerify := 0;
  nIdx := 0;

  while nIdx < nLen do
  begin
    nVerify := nBuf[nIdx] + nVerify;
    Inc(nIdx);
  end;

  if (nBuf[nLen] <> (nVerify shr 8 and $00ff)) or
     (nBuf[nLen+1] <> (nVerify and $00ff)) then Exit;
  //校验失败

  nPort.FCOMData := IntToStr(StrToInt('$' +
    IntToHex(nBuf[51], 2) + IntToHex(nBuf[50], 2) +
    IntToHex(nBuf[49], 2) + IntToHex(nBuf[48], 2)));
  //毛重显示数据

  Result := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath);
  gSysLoger.LogSync := True;
  gSysLoger.LogEvent := Dolog;

  gBasisWeightManager := TBasisWeightManager.Create;
  with gBasisWeightManager do
  begin
    TunnelManager.OnUserParseWeight := WhenParsePoundWeight;
    OnStatusEvent := OnStatus;
    
    LoadConfig(gPath + 'Tunnels.xml');
    StartService;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gBasisWeightManager.StopService;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if gBasisWeightManager.IsTunnelBusy('HX01') then
       ShowMessage('busy')
  else ShowMessage('not busy')
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  gBasisWeightManager.StartWeight('B2', 'TH1801', 35, 0, 'P1=aaa;P2=bbb;P3=ccc');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  gBasisWeightManager.StopWeight('B2');
end;

procedure TForm1.OnStatus(const nTunnel: PBWTunnel);
begin
  case nTunnel.FStatusNew of
   bsInit      : Dolog('初始化:' + nTunnel.FID);
   bsNew       : Dolog('新添加:' + nTunnel.FID);
   bsStart     : Dolog('开始称重:' + nTunnel.FID);
   bsClose     : Dolog('称重关闭:' + nTunnel.FID);
   bsDone      : Dolog('称重完成:' + nTunnel.FID);
   bsStable    : Dolog('数据平稳:' + nTunnel.FID);
   bsProcess   : Dolog('装车中:' + nTunnel.FID + ' ' + FloatToStr(nTunnel.FValTunnel));
  end;

  Dolog(nTunnel.FParams.Values['Name'] + nTunnel.FParams.Values['Age']);

  if nTunnel.FStatusNew = bsStable then
    //nTunnel.FStableDone := False;
  //未处理成功,等待再次触发
end;

procedure TForm1.Button4Click(Sender: TObject);
var nBuf,nAll: TIdBytes;
begin
  SetLength(nAll, 0);
  SetLength(nBuf, 3);

  AppendBytes(nAll, nBuf);
  Memo1.Text := ToHex(nAll);
end;

end.
