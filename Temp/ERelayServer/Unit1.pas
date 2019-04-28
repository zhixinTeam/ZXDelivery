unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdContext, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    IdTCPServer1: TIdTCPServer;
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    procedure IdTCPServer1Execute(AContext: TIdContext);
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
uses IdGlobal, ULibFun;

const
  cERelay_FrameBegin       = Char($FF) + Char($FF) + Char($FF); //��ʼ֡ 
  cERelay_QueryStatus      = $01;       //״̬��ѯ(in)
  cERelay_RelaysOC         = $02;       //ͨ������(open close)
  cERelay_DataForward      = $03;       //485����ת��
  
  cERelay_SignIn_On        = $01;       //�������ź�
  cERelay_SignIn_Off       = $00;       //�������ź�
  cERelay_SignOut_Close    = $00;       //���:�ر�
  cERelay_SignOut_Open     = $01;       //���:��
  cERelay_SignOut_Ignore   = $02;       //���:����

function VerifyData(var nData: TIdBytes; const nLen: Integer): Byte;
var nIdx: Integer;
begin
  if nLen > 0 then
  begin
    Result := nData[0];
    for nIdx:=1 to nLen do
      Result := Result xor nData[nIdx];
    //xxxxx
  end else Result := 0;
end;

function StatusBytes: TIdBytes;
const
  cIn : array[0..23] of byte = (1,1,1,0,1,1,1,1,0,0,0,0,1,0,0,0,1,1,1,1,1,1,1,1);
  cOut: array[0..15] of Byte = (1,1,1,0,1,1,1,1,0,0,0,0,1,0,0,0);
var nIdx: Integer;
    nByte: Byte;
begin
  SetLength(Result, 0);
  for nIdx:=Low(cIn) to High(cIn) do
  begin
    nByte := SetNumberBit(nByte, nIdx mod 8 + 1, cIn[nIdx], Bit_8);
    if (nIdx+1) mod 8 = 0 then
      AppendByte(Result, nByte);
    //xxxxx
  end;

  for nIdx:=Low(cOut) to High(cOut) do
  begin
    nByte := SetNumberBit(nByte, nIdx mod 8 + 1, cOut[nIdx], Bit_8);
    if (nIdx+1) mod 8 = 0 then
      AppendByte(Result, nByte);
    //xxxxx
  end;
end;

procedure TForm1.IdTCPServer1Execute(AContext: TIdContext);
var nIdx,nInt,nLen: Integer;
    nBuf,nProtocol: TIdBytes;
begin
  with AContext.Connection.IOHandler do
  begin
    SetLength(nBuf, 0);
    while True do
    begin
      CheckForDataOnSource(10);
      //fill the output buffer with a timeout
        
      if InputBufferIsEmpty then
           Break
      else InputBuffer.ExtractToBytes(nBuf);
    end;
  end;

  nLen := Length(nBuf);
  if nLen < 1 then Exit;
  Memo1.Lines.Add(ToHex(nBuf));

  nIdx := 0;
  while nIdx < nLen do
  begin
    if (nBuf[nIdx] = $FF) and (nIdx+4 < nLen) and
       (nBuf[nIdx+1] = $FF) and (nBuf[nIdx+2] = $FF) then
    begin
      nInt := 6 + nBuf[nIdx+4]; //�������ݱ߽�
      if nIdx + nInt > nLen then
      begin
        Inc(nIdx);
        Continue;
      end;

      nProtocol := ToBytes(nBuf, nInt, nIdx);
      Inc(nIdx, nInt);
      nInt := High(nProtocol);
      if nProtocol[nInt] <> VerifyData(nProtocol, nInt-1) then Continue;

      case nProtocol[3] of
        cERelay_QueryStatus  : Memo1.Lines.Add('��ѯ״̬');
        cERelay_RelaysOC     : Memo1.Lines.Add('�������');
        cERelay_DataForward  : Memo1.Lines.Add('����ת��');
      end;

      if nProtocol[3] = cERelay_QueryStatus then
      begin
        SetLength(nBuf, 0);
        nBuf := ToBytes(cERelay_FrameBegin, Indy8BitEncoding);    //��ʼ֡
        AppendByte(nBuf, cERelay_QueryStatus);                    //������
        AppendByte(nBuf, 5);                                      //���ݳ���
        AppendBytes(nBuf, StatusBytes);                           //����
        AppendByte(nBuf, VerifyData(nBuf, Length(nBuf)-1));       //У��λ

        AContext.Connection.IOHandler.Write(nBuf);
      end;

      if nProtocol[3] = cERelay_RelaysOC then
      begin
        SetLength(nBuf, 0);
        nBuf := ToBytes(cERelay_FrameBegin, Indy8BitEncoding);    //��ʼ֡
        AppendByte(nBuf, cERelay_RelaysOC);                       //������
        AppendByte(nBuf, 1);                                      //���ݳ���
        AppendByte(nBuf, $01);                                    //����
        AppendByte(nBuf, VerifyData(nBuf, Length(nBuf)-1));       //У��λ

        AContext.Connection.IOHandler.Write(nBuf);
      end;

      if nProtocol[3] = cERelay_DataForward then
      begin
        SetLength(nBuf, 0);
        nBuf := ToBytes(cERelay_FrameBegin, Indy8BitEncoding);    //��ʼ֡
        AppendByte(nBuf, cERelay_DataForward);                    //������
        AppendByte(nBuf, 1);                                      //���ݳ���
        AppendByte(nBuf, $01);                                    //����
        AppendByte(nBuf, VerifyData(nBuf, Length(nBuf)-1));       //У��λ

        AContext.Connection.IOHandler.Write(nBuf);
      end;
    end else Inc(nIdx);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var nBytes: TIdBytes;
begin
  SetLength(nBytes, 0);
  ShowMessage(IntToStr(High(nBytes)));
end;

end.
