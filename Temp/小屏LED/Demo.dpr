program Demo;

uses
  FastMM4,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UMgrBXFontCard in '..\..\..\..\Program Files\MyVCL\znlib\Hardware\UMgrBXFontCard.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
