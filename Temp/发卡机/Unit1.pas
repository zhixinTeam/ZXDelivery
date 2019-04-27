unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CPort;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComPort1: TComPort;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure Dolog(const nStr: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses {UMgrTTCEK720,} USysLoger, UMgrTTCEDispenser, UMgrPoundTunnels;

var
  gPath: string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath);
  gSysLoger.LogSync := True;
  gSysLoger.LogEvent := Dolog;

  gDispenserManager := TDispenserManager.Create;
  gDispenserManager.LoadConfig(gPath + 'TTCE_K720.xml');
  gDispenserManager.StartDispensers;

  //gK720ReaderManager := TK720ReaderManager.Create;
  //gK720ReaderManager.LoadConfig(gPath + 'RFID102.xml');
  //gK720ReaderManager.StartReader;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  gDispenserManager.StopDispensers;
end;

procedure TForm1.Dolog(const nStr: string);
begin
  Memo1.Lines.Add(nStr);
end;

procedure TForm1.Button1Click(Sender: TObject);
var nStr: string;
begin
  memo1.Lines.Add(gDispenserManager.GetCardNo('gateA', nStr));
  if nStr <> '' then
    memo1.Lines.Add(nStr);
  //xxxxx
end;

procedure TForm1.Button2Click(Sender: TObject);
var nStr: string;
begin
  gDispenserManager.RecoveryCard('gateA', nStr);
  if nStr <> '' then
    memo1.Lines.Add(nStr);
  //xxxxx
end;

procedure TForm1.Button3Click(Sender: TObject);
var nStr: string;
begin
  gDispenserManager.SendCardOut('gateA', nStr);
  if nStr <> '' then
    memo1.Lines.Add(nStr);
  //xxxxx
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var nStr: string;
begin
  if gDispenserManager.GetCardNo('gateA', nStr, False) <> '' then
    gDispenserManager.SendCardOut('gateA', nStr);
  //xxxxx
end;

end.
