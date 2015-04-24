unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Btn1: TButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  UMgrVoiceNet, USysLoger;

var
  gPath: string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');

  gNetVoiceHelper := TNetVoiceManager.Create;
  gNetVoiceHelper.LoadConfig(gPath + 'NetVoice.xml');
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
       gNetVoiceHelper.StartVoice
  else gNetVoiceHelper.StopVoice;
end;

procedure TForm1.Btn1Click(Sender: TObject);
begin
  gNetVoiceHelper.PlayVoice(#9 + '²ØA-123' + #9 + 'ÆÓB-11123');
end;

end.
