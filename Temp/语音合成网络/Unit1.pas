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
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Btn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  UMgrVoiceNet, USysLoger, UMemDataPool;

var
  gPath: string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');

  gMemDataManager := TMemDataManager.Create;
  gNetVoiceHelper := TNetVoiceManager.Create;
  gNetVoiceHelper.LoadConfig(gPath + 'NetVoice.xml');
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
       gNetVoiceHelper.StartVoice
  else gNetVoiceHelper.StopVoice;
end;

//Date: 2016-12-09
//Parm: 文本
//Desc: 按宽字节计算nText中有效内容的长度
function CalTextLength(const nText: string): Integer;
var nStr: string;
    nWStr: WideString;
    nIdx,nLen: Integer;
begin
  Result := 0;
  nWStr := nText;
  nLen := Length(nWStr);

  for nIdx:=1 to nLen do
  begin
    nStr := nWStr[nIdx];
    if IsDBCSLeadByte(byte(nStr[1])) or //double byte
       (nStr[1] in ['a'..'z', 'A'..'Z', '0'..'9']) then //single byte
      Inc(Result);
    //xxxxx
  end;
end;


procedure TForm1.Btn1Click(Sender: TObject);
begin
  gNetVoiceHelper.PlayVoice(Memo1.Text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  showmessage(IntToStr(CalTextLength(Memo1.Text)));
end;

end.
