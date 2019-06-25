unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UMosMQTT, TMS.MQTT.Global,
  TMS.MQTT.Client;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    TMSMQTTClient1: TTMSMQTTClient;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FMQTTClient: TMQTTClient;
    procedure WriteLog(const nEvent: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  UMosquitto, ULibFun, UManagerGroup;

procedure TForm1.FormCreate(Sender: TObject);
begin
  with TApplicationHelper do
  begin
    gPath := ExtractFilePath(Application.ExeName);
    gMG.FLogManager.SyncMainUI := True;
    gMG.FLogManager.SyncSimple := WriteLog;
    gMG.FLogManager.StartService(gPath + 'Logs\');
  end;

  FMQTTClient := TMQTTClient.Create(Self);
  with FMQTTClient do
  begin
    ServerHost := '118.89.157.37';
    ServerPort := 8031;
    UserName := 'dmzn';
    Password := 'dmzn';
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gMG.RunBeforApplicationHalt;
  FMQTTClient.Disconnect;
end;

procedure TForm1.WriteLog(const nEvent: string);
begin
  Memo1.Lines.Add(nEvent)
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FMQTTClient.AddTopic(Edit1.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  FMQTTClient.Publish(edit1.Text, edit2.Text);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
       FMQTTClient.ConnectBroker
  else FMQTTClient.Disconnect;
end;

end.
