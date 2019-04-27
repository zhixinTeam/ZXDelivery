unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  gERelayManager.IsTunnelOK('T2');
end;

procedure TForm1.DoLog(const nStr: string);
begin
  Memo1.lines.Add(nStr);
end;

end.
 