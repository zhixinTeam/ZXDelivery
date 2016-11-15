unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
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
  ULibFun, UFormCtrl;

const
  sTable_Customer     = 'S_Customer';                //客户信息
  sTable_CusAccount   = 'Sys_CustomerAccount';       //客户账户

procedure TForm1.FormResize(Sender: TObject);
begin
  Memo1.Height := Trunc( (ClientHeight - Panel1.Height) / 2 );
end;

function AdjustStr(const nStr: string): string;
begin
  Result := StringReplace(nStr, '"', '', [rfReplaceAll]);
end;

procedure TForm1.Button1Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    Memo2.Clear;
    //xxxxx

    for nIdx:=0 to Memo1.Lines.Count - 1 do
    begin
      nStr := Trim(Memo1.Lines[nIdx]);
      if not SplitStr(nStr, nList, 3, #9) then Continue;
      //xxxxx

      if not IsNumber(nList[2], True) then Continue;
      //非金额

      nStr := 'Update %s Set A_InMoney=%s Where A_CID=''%s''' + #9#9 + '--%d';
      nStr := Format(nStr, [sTable_CusAccount, nList[2], nList[0], Memo2.Lines.Count+1]);
      Memo2.Lines.Add(nStr);
    end;
  finally
    nList.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    Memo2.Clear;
    //xxxxx

    for nIdx:=0 to Memo1.Lines.Count - 1 do
    begin
      nStr := Trim(Memo1.Lines[nIdx]);
      if not SplitStr(nStr, nList, 3, #9) then Continue;
      //xxxxx

      if not IsNumber(nList[2], True) then Continue;
      //非金额

      nStr := MakeSQLByStr([SF('M_CusID', nList[0]),
              SF('M_CusName', nList[1]),
              SF('M_Type', 'R'),
              SF('M_Payment', '2014结余'),
              SF('M_Money', nList[2], sfVal),
              SF('M_Man', 'admin'),
              SF('M_Date', 'getDate()', sfVal),
              SF('M_Memo', '2015 init')
              ], 'Sys_CustomerInOutMoney', '', True);
      Memo2.Lines.Add(nStr);
    end;

    nStr := 'Update Sys_CustomerInOutMoney Set M_SaleMan=(Select C_SaleMan From ' +
            'S_Customer Where C_ID=M_CusID)';
    Memo2.Lines.Add(nStr);
  finally
    nList.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var nStr,nType: string;
    nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    Memo2.Text := 'Delete From Sys_Dict Where D_Name=''StockItem''';
    //xxxxx

    for nIdx:=0 to Memo1.Lines.Count - 1 do
    begin
      nStr := Trim(Memo1.Lines[nIdx]);
      if not SplitStr(nStr, nList, 3, ';') then Continue;
      //xxxxx

      nList.Text := StringReplace(nList.Text, '"', '', [rfReplaceAll]);
      //xxxxx

      if (Pos('袋装', nList[1]) > 0) then
           nType := 'D'
      else nType := 'S';

      nStr := MakeSQLByStr([SF('D_Name', 'StockItem'),
              SF('D_Desc', nList[2]),
              SF('D_Value', nList[1]),
              SF('D_Memo', nType),
              SF('D_ParamB', nList[0])
              ], 'Sys_Dict', '', True);
      Memo2.Lines.Add(nStr);
    end;
  finally
    nList.Free;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    Memo2.Text := 'Delete From S_Card';
    //xxxxx

    for nIdx:=0 to Memo1.Lines.Count - 1 do
    begin
      nStr := Trim(Memo1.Lines[nIdx]);
      if not SplitStr(nStr, nList, 2, ',') then Continue;
      //xxxxx

      nStr := MakeSQLByStr([SF('C_Card2', nList[1]),
              SF('C_Card3', nList[0]),
              SF('C_Status', 'I'),
              SF('C_Freeze', 'N'),
              SF('C_Man', 'admin'),
              SF('C_Date', 'getDate()', sfVal),
              SF('C_Used', 'S')
              ], 'S_Card', '', True);
      Memo2.Lines.Add(nStr);
    end;
  finally
    nList.Free;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    Memo2.Clear;
    //xxxxx

    for nIdx:=0 to Memo1.Lines.Count - 1 do
    begin
      nStr := Trim(Memo1.Lines[nIdx]);
      if not SplitStr(nStr, nList, 3, #9) then Continue;
      //xxxxx

      if not IsNumber(nList[2], True) then Continue;
      //非金额

      nStr := 'Insert Into %s(C_ID, C_Name, C_PY, C_Xuni) ' +
              'Values(''%s'', ''%s'', ''%s'', ''N'')' + #9#9 + '--%d';
      nStr := Format(nStr, [sTable_Customer, nList[0], nList[1],
              GetPinYinOfStr(nList[1]), Memo2.Lines.Count+1]);
      Memo2.Lines.Add(nStr);
      //客户信息

      nStr := MakeSQLByStr([SF('A_CID', nList[0]),
              SF('A_InitMoney', -StrToFloat(nList[2]), sfVal),
              SF('A_Date', 'getDate()', sfVal)
              ], sTable_CusAccount, '', True);

      nStr := nStr + #9#9 + '--%d';
      nStr := Format(nStr, [Memo2.Lines.Count+1]);
      Memo2.Lines.Add(nStr);
      //客户资金
    end;
  finally
    nList.Free;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Memo2.Lines.SaveToFile(ExtractFilePath(ParamStr(0)) + 'SaveFile.txt');
end;

end.
