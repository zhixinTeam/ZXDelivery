unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    EditTunnel: TLabeledEdit;
    EditTxt: TLabeledEdit;
    BtnSend: TButton;
    GroupBox2: TGroupBox;
    EditTunnel2: TLabeledEdit;
    BtnDisplay: TButton;
    BtnISOK: TButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
    procedure BtnDisplayClick(Sender: TObject);
    procedure BtnISOKClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoLog(const nStr: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  USysLoger, UMgrTruckProbe, UMgrERelayPLC;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gSysLoger := TSysLoger.Create(ExtractFilePath(Application.ExeName) + 'Logs\');
  gSysLoger.LogSync := True;
  gSysLoger.LogEvent := DoLog;

  gERelayManager := TERelayManager.Create;
  gERelayManager.LoadConfig('D:\Program Files\MyVCL\znlib\Hardware\ERelayPLC.xml');
  gERelayManager.StartService;
end;

procedure TForm1.DoLog(const nStr: string);
begin
  Memo1.lines.Add(nStr);
end;

procedure TForm1.BtnDisplayClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nIn,nOut: TERelayAddress;
begin
  nIdx := gERelayManager.FindTunnel(EditTunnel2.Text);
  if nIdx < 0 then
  begin
    Memo1.Lines.Add(EditTunnel2.Text + '不存在');
    Exit;
  end;

  nIdx := gERelayManager.Tunnels[nIdx].FHost;
  if gERelayManager.QueryStatus(gERelayManager.Hosts[nIdx].FID, nIn,nOut) then
  begin
    nStr := '';
    for nIdx:=Low(nIn) to High(nIn) do
     if nIn[nIdx] <> cERelay_Null then
      nStr := nStr + IntToStr(nIn[nIdx]) + ' ';
    Memo1.Lines.Add('输入: ' + nStr);

    nStr := '';
    for nIdx:=Low(nOut) to High(nOut) do
     if nOut[nIdx] <> cERelay_Null then
      nStr := nStr + IntToStr(nOut[nIdx]) + ' ';
    Memo1.Lines.Add('输出: ' + nStr);
  end;
end;

procedure TForm1.BtnSendClick(Sender: TObject);
begin
  gERelayManager.ShowText(EditTunnel.Text, EditTxt.Text);
end;

procedure TForm1.BtnISOKClick(Sender: TObject);
begin
  if gERelayManager.IsTunnelOK(EditTunnel2.Text) then
       Memo1.Lines.Add(EditTunnel2.Text + ' 正常')
  else Memo1.Lines.Add(EditTunnel2.Text + ' 不正常')
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
       gERelayManager.OpenTunnel(EditTunnel2.Text)
  else gERelayManager.CloseTunnel(EditTunnel2.Text);
end;

end.
 