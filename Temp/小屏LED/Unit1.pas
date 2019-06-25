unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FHandle: DWORD;
    FListA,FListB: TStrings;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  ULibFun, USysLoger, UMgrBXFontCard, IdGlobal;

var
  gPath: string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath + 'Config.ini', gPath + 'Form.ini');
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');

  FListA := TStringList.Create;
  FListB := TStringList.Create;

  gBXFontCardManager := TBXFontCardManager.Create;
  gBXFontCardManager.LoadConfig(gPath + 'BXFontLED.xml');
  gBXFontCardManager.StartService;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FListA.Free;
  FListB.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
var nStr: string;
    nMode:TBXDisplayMode;
begin
  if Random(200) / 2 = 0 then
       nStr := ''
  else nStr := 'out';

   gBXFontCardManager.InitDisplayMode(nMode);
   nMode.FDisplayMode := 4;
   nMode.FNewLine := 0;
   gBXFontCardManager.Display(Edit1.Text, Edit2.Text, nStr, 2, 3, @nMode, @nMode);
end;

end.
