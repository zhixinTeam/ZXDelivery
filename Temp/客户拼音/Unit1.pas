unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
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
uses ULibFun;

procedure TForm1.Button1Click(Sender: TObject);
var nStr: string;
begin
  with ADOQuery1 do
  begin
    Close;
    SQL.Text := 'Select R_ID,C_Name From S_Customer';
    Open;

    if RecordCount < 1 then Exit;
    First;

    while not Eof do
    begin
      nStr := 'Update S_Customer Set C_PY=''%s'',C_XuNi=''N'' Where R_ID=%s';
      nStr := Format(nStr, [GetPinYinOfStr(Fields[1].AsString), Fields[0].AsString]);

      with ADOQuery2 do
      begin
        Close;
        SQL.Text := nStr;
        ExecSQL;
      end;

      Memo1.Lines.Add(nStr);
      Next;
    end;
  end;
end;

end.
