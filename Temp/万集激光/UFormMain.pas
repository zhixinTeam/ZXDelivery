unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdGlobal,
  UMgrWJLaser, ExtCtrls, StdCtrls, DateUtils;

type
  TfFormMain = class(TForm)
    IdTCPClient1: TIdTCPClient;
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoLog(const nEvent: string);
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses UMgrRFID102, UMgrBXFontCard, UMgrTruckProbe, UHKDoorLED2, ULibFun, USysLoger;

var
  gPath: string;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogEvent := DoLog;
  gSysLoger.LogSync := True;

  gWJLaserManager := TWJLaserManager.Create;
  gWJLaserManager.LoadConfig('D:\Program Files\MyVCL\znlib\Hardware\WJLaser.xml');
  gWJLaserManager.StartService;
end;

procedure TfFormMain.DoLog(const nEvent: string);
begin
  Memo1.Lines.Add(nEvent)
end;

function ByHex(const nHex: string): string;
const cChars = [#32, #13, #10]; //spit char
var nStr: string;
    nIdx,nHi,nPos: Integer;
begin
  Result := '';
  nHi := Length(nHex);

  nPos := 1;
  for nIdx:=1 to nHi do
  begin
    if not (nHex[nIdx] in (['0'..'9','a'..'f', 'A'..'F'] + cChars)) then
    begin
      nPos := nIdx + 1;
      Continue;
    end;

    if (nHex[nIdx] in cChars) or (nIdx = nHi) then
    begin
      if not (nHex[nPos] in cChars) then
      begin
        if nHex[nIdx] in cChars then
             nStr := Copy(nHex, nPos, nIdx - nPos)
        else nStr := Copy(nHex, nPos, nIdx - nPos + 1);

        if Length(nStr) = 2 then
          Result := Result + Char(StrToInt('$' + nStr));
        //xxxxx
      end;

      nPos := nIdx;
    end else
    begin
      if nHex[nPos] in cChars then
        nPos := nIdx;
      //xxxxx
    end;
  end;
end;

function Str2Bytes(const nStr: string): TIdBytes;
var nIdx,nInt: Integer;
begin
  nInt := Length(nStr);
  SetLength(Result, nInt);

  if nInt > 0 then
  begin
    nInt := 1 + (0 - Low(Result));
    for nIdx := Low(Result) to High(Result) do
      Result[nIdx] := Ord(nStr[nIdx + nInt]);
    //xxxxx
  end;
end;

function LogHex(const nData: TIdBytes; const nPrefix: string = ''): string;
var nStr: string;
    nIdx: Integer;
begin
  nStr := '';
  for nIdx:=Low(nData) to High(nData) do
    nStr := nStr + IntToHex(nData[nIdx], 2) + ' ';
  Result := nPrefix + nStr;
end;

function VerifyData(var nData: TIdBytes; const nAppend: Boolean): Byte;
var nIdx,nLen: Integer;
begin
  Result := 0;
  nLen := High(nData) - 4; //末4位不参与计算
  if nLen < 2 then Exit;

  Result := nData[2];
  for nIdx:=3 to nLen do
    Result := Result xor nData[nIdx];
  //xxxxx

  if nAppend then
  begin
    nData[nLen + 1] := $00;
    nData[nLen + 2] := Result;
  end;
end;

procedure TfFormMain.Button1Click(Sender: TObject);
//var nStr: string;
//    nBuf: TIdBytes;
//begin
//  nStr := ByHex(Memo1.Text);
//  nBuf := Str2Bytes(nStr);
//  Memo2.Lines.Add(LogHex(nBuf));
//  
//  VerifyData(nBuf, True);
//  Memo2.Lines.Add(LogHex(nBuf))
begin
  ShowMessage(IntToStr(cLaserDataParse));
end;

end.
