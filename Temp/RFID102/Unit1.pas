unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, USysLoger, UMgrRFID102, StdCtrls, ExtCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    IdTCPClient1: TIdTCPClient;
    Edit1: TEdit;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OnLog(const nStr: string);
    procedure OnCard(const nItem: PHYReaderItem);
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
  gSysLoger.LogEvent := OnLog;

  gHYReaderManager := THYReaderManager.Create;
  gHYReaderManager.LoadConfig(gPath + 'RFID102.xml');
  gHYReaderManager.OnCardEvent := OnCard;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  gHYReaderManager.StartReader
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  gHYReaderManager.StopReader;
end;

procedure TForm1.OnLog(const nStr: string);
begin
  Memo1.Lines.Add(nStr);
end;

procedure TForm1.OnCard(const nItem: PHYReaderItem);
begin
  gSysLoger.AddLog(nItem.FCard);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  gHYReaderManager.OpenDoor(Edit1.Text);
end;

end.
 