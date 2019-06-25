unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UHKDoorLED, UHKDoorLED2, USysLoger, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure WriteLog(const nStr: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  gPath: string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogSync := True;
  gSysLoger.LogEvent := WriteLog;

  gHKCardManager := THKCardManager.Create;
  gHKCardManager.LoadConfig(gPath + 'HKDoorLED.xml');
  gHKCardManager.StartDiaplay;
end;

procedure TForm1.WriteLog(const nStr: string);
begin
  Memo1.Lines.Add(nStr);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  gHKCardManager.DisplayText('in', Edit1.Text, '', 2);
end;

end.
 