{*******************************************************************************
  ����: dmzn@163.com 2014-11-25
  ����: �����Ϣ����
*******************************************************************************}
unit UFormKDInfo;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox;

type
  TfFormKDInfo = class(TfFormNormal)
    EditKDInfo: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FKDInfo: string;
    procedure LoadFormData(const nID: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst;

class function TfFormKDInfo.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;
  
  with TfFormKDInfo.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      Caption := '��� - ���';
      FKDInfo := '';
    end;

    if nP.FCommand = cCmd_EditData then
    begin
      Caption := '��� - �޸�';
      FKDInfo := nP.FParamA;
    end;

    LoadFormData(FKDInfo); 
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormKDInfo.FormID: integer;
begin
  Result := cFI_FormKDInfo;
end;

procedure TfFormKDInfo.LoadFormData(const nID: string);
var nStr: string;
begin
  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_KDInfo, nID]);
    FDM.QueryTemp(nStr);
  end;

  with FDM.SqlTemp do
  begin
    if (nID = '') or (RecordCount < 1) then
    begin
      Exit;
    end;

    EditKDInfo.Text := FieldByName('S_KDName').AsString;
  end;
end;

//Desc: ����
procedure TfFormKDInfo.BtnOKClick(Sender: TObject);
var nStr,nKDInfo,nU,nV,nP,nVip,nGps,nEvent: string;
begin
  nKDInfo := UpperCase(Trim(EditKDInfo.Text));
  if nKDInfo = '' then
  begin
    ActiveControl := EditKDInfo;
    ShowMsg('��������', sHint);
    Exit;
  end;
  if FKDInfo = '' then
  begin
    nStr := ' select S_KDName from %s where S_KDName=''%s''';
    nStr := Format(nStr,[sTable_KDInfo, nKDInfo]);
    with FDM.QuerySQL(nStr) do
    begin
      if RecordCount>0 then
      begin
        ActiveControl := EditKDInfo;
        ShowMsg('�Ѵ��ڴ˿��', sHint);
        Exit;
      end;
    end;
  end;
  
  if FKDInfo = '' then
       nStr := ''
  else nStr := SF('R_ID', FKDInfo, sfVal);

  nStr := MakeSQLByStr([SF('S_KDName', nKDInfo)
          ], sTable_KDInfo, nStr, FKDInfo = '');
  FDM.ExecuteSQL(nStr);

  if FKDInfo = '' then
        nEvent := '���[ %s ]�����Ϣ.'
  else  nEvent := '�޸�[ %s ]�����Ϣ.';
  nEvent := Format(nEvent, [nKDInfo]);
  FDM.WriteSysLog(sFlag_CommonItem, nKDInfo, nEvent);


  ModalResult := mrOk;
  ShowMsg('�����Ϣ����ɹ�', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormKDInfo, TfFormKDInfo.FormID);
end.
