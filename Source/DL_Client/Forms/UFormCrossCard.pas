{*******************************************************************************
  ����: juner11212436@163.com 2019-09-02
  ����: ͨ�дſ�����
*******************************************************************************}
unit UFormCrossCard;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CPort, CPortTypes, UFormNormal, UFormBase, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit,
  dxLayoutControl, StdCtrls, cxGraphics, cxMemo, cxMaskEdit, cxDropDownEdit,
  cxCheckBox, ComCtrls, cxListView;

type
  TfFormCrossCard = class(TfFormNormal)
    EditTruck: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    ComPort1: TComPort;
    dxLayout1Item12: TdxLayoutItem;
    cxLabel2: TcxLabel;
    EditUse: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditFreeze: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditCType: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditUTime: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FBuffer: string;
    //���ջ���
    procedure ActionComPort(const nStop: Boolean);
    procedure QueryCard(const nCardNo: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, USysBusiness, USmallFunc, USysConst,USysDB,
  UDataModule, UFormCtrl, UBusinessPacker;

type
  TReaderType = (ptT800, pt8142);
  //��ͷ����

  TReaderItem = record
    FType: TReaderType;
    FPort: string;
    FBaud: string;
    FDataBit: Integer;
    FStopBit: Integer;
    FCheckMode: Integer;
  end;
var
  gReaderItem: TReaderItem;
  //ȫ��ʹ��

class function TfFormCrossCard.FormID: integer;
begin
  Result := CFI_FormCrossCard;
end;

class function TfFormCrossCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormCrossCard.Create(Application) do
  try
    ActionComPort(False);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfFormCrossCard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ActionComPort(True);
end;

//------------------------------------------------------------------------------
//Desc: ���ڲ���
procedure TfFormCrossCard.ActionComPort(const nStop: Boolean);
var nInt: Integer;
    nIni: TIniFile;
begin
  if nStop then
  begin
    ComPort1.Close;
    Exit;
  end;

  with ComPort1 do
  begin
    with Timeouts do
    begin
      ReadTotalConstant := 100;
      ReadTotalMultiplier := 10;
    end;

    nIni := TIniFile.Create(gPath + 'Reader.Ini');
    with gReaderItem do
    try
      nInt := nIni.ReadInteger('Param', 'Type', 1);
      FType := TReaderType(nInt - 1);

      FPort := nIni.ReadString('Param', 'Port', '');
      FBaud := nIni.ReadString('Param', 'Rate', '4800');
      FDataBit := nIni.ReadInteger('Param', 'DataBit', 8);
      FStopBit := nIni.ReadInteger('Param', 'StopBit', 0);
      FCheckMode := nIni.ReadInteger('Param', 'CheckMode', 0);

      Port := FPort;
      BaudRate := StrToBaudRate(FBaud);

      case FDataBit of
       5: DataBits := dbFive;
       6: DataBits := dbSix;
       7: DataBits :=  dbSeven else DataBits := dbEight;
      end;

      case FStopBit of
       2: StopBits := sbTwoStopBits;
       15: StopBits := sbOne5StopBits
       else StopBits := sbOneStopBit;
      end;

      if FPort <> '' then
      begin
        ComPort1.Open;
        EditCard.Properties.ReadOnly := True;
      end;
    finally
      nIni.Free;
    end;
  end;
end;

procedure TfFormCrossCard.ComPort1RxChar(Sender: TObject; Count: Integer);
var nStr: string;
    nIdx,nLen: Integer;
begin
  ComPort1.ReadStr(nStr, Count);
  FBuffer := FBuffer + nStr;

  nLen := Length(FBuffer);
  if nLen < 7 then Exit;

  for nIdx:=1 to nLen do
  begin
    if (FBuffer[nIdx] <> #$AA) or (nLen - nIdx < 6) then Continue;
    if (FBuffer[nIdx+1] <> #$FF) or (FBuffer[nIdx+2] <> #$00) then Continue;

    nStr := Copy(FBuffer, nIdx+3, 4);
    EditCard.Text := ParseCardNO(nStr, True);
    QueryCard(EditCard.Text);
    FBuffer := '';

    Exit;
  end;
end;

//Desc: ����ſ�
procedure TfFormCrossCard.BtnOKClick(Sender: TObject);
var nStr, nTruck: string;
begin
  if Trim(EditCard.Text) = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('��ˢ��', sHint);
    Exit;
  end;

  EditTruck.Text := Trim(EditTruck.Text);

  if EditTruck.Text = '' then
  begin
    EditTruck.SetFocus;
    ShowMsg('�����복�ƺ�', sHint);
    Exit;
  end;

  nStr := 'select * from %s where c_TruckNo=''%s''';
  nStr := Format(nStr,[sTable_Card,EditTruck.Text]);
  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount > 0 then
    begin
      ShowMsg('����' + EditTruck.Text + '����ʹ�ôſ�'
              + FieldByName('C_Card').AsString + ',����ע��',sHint);
      Exit;
    end;
  end;

  nTruck := '';
  nStr := 'select * from %s where c_card=''%s''';
  nStr := Format(nStr,[sTable_Card,EditCard.Text]);
  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount<=0 then
    begin
      ShowMsg('�ſ�����Ч',sHint);
      Exit;
    end;
    nTruck := Trim(FieldByName('C_TruckNo').AsString);
  end;

  if (Pos('ʹ��', EditUse.Text) > 0) or (Pos('��ʧ', EditUse.Text) > 0)
     or (Pos('�Ѷ���', EditFreeze.Text) > 0) then
  begin
    ShowMsg('�ſ��޷�ʹ��,���Ƚ���ע��', sHint);
    Exit;
  end;

  if (nTruck <> '') and (nTruck <> EditTruck.Text) then
  begin
    ShowMsg(nTruck + '����ʹ�øÿ�', sHint);
    Exit;
  end;

  nStr := 'Update %s Set c_used=''%s'',c_TruckNo=''%s'',C_Status=''%s'',C_Date=%s Where c_card=''%s''';
  nStr := Format(nStr, [sTable_Card, sFlag_Tx, EditTruck.Text,
                        sFlag_CardUsed, sField_SQLServer_Now, EditCard.Text]);
  FDM.ExecuteSQL(nStr);

  ModalResult := mrOk;
end;

procedure TfFormCrossCard.QueryCard(const nCardNo: string);
var nSQL: string;
begin
  BtnOK.Enabled := False;
  nSql := 'select * from %s where c_card=''%s''';
  nSql := Format(nSql,[sTable_Card,EditCard.Text]);
  with FDM.QuerySQL(nSql) do
  begin
    if RecordCount<=0 then
    begin
      ShowMsg('�ſ�����Ч',sHint);
      Exit;
    end;

    EditUTime.Text := '';
    EditUse.Text := '';
    EditFreeze.Text := '';
    EditCType.Text := '';
    EditTruck.Text := '';
    if FieldByName('C_Status').AsString = sFlag_CardUsed then
    begin
      EditUse.Text := FieldByName('C_Status').AsString + '��ʹ����';
      EditUTime.Text := FieldByName('C_Date').AsString;
    end
    else
    if FieldByName('C_Status').AsString = sFlag_CardIdle then
      EditUse.Text := FieldByName('C_Status').AsString + '������'
    else
    if FieldByName('C_Status').AsString = sFlag_CardLoss then
      EditUse.Text := FieldByName('C_Status').AsString + '����ʧ'
    else
    if FieldByName('C_Status').AsString = sFlag_CardInvalid then
      EditUse.Text := FieldByName('C_Status').AsString + '��ע��'
    else
      EditUse.Text := FieldByName('C_Status').AsString;

    if FieldByName('C_Freeze').AsString = sFlag_Yes then
      EditFreeze.Text := FieldByName('C_Freeze').AsString + '���Ѷ���'
    else
      EditFreeze.Text := FieldByName('C_Freeze').AsString + '��δ����';

    if FieldByName('c_used').AsString=sflag_sale then
    begin
      EditCType.Text := FieldByName('c_used').AsString + '������';
    end
    else if FieldByName('c_used').AsString=sFlag_Provide then begin
      EditCType.Text := FieldByName('c_used').AsString + '����Ӧ';
    end
    else if FieldByName('c_used').AsString=sFlag_Mul then begin
      EditCType.Text := FieldByName('c_used').AsString + '����ʱ����';
    end
    else if FieldByName('c_used').AsString=sFlag_Tx then begin
      EditCType.Text := FieldByName('c_used').AsString + '��ͨ�п�';
    end;

    EditTruck.Text := FieldByName('C_TruckNo').AsString;
  end;
  BtnOK.Enabled := True;
end;

initialization
  gControlManager.RegCtrl(TfFormCrossCard, TfFormCrossCard.FormID);
end.
