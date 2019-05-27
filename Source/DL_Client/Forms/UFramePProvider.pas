{*******************************************************************************
  ����: dmzn@163.com 2009-7-2
  ����: ��Ӧ��
*******************************************************************************}
unit UFramePProvider;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, Menus;

type
  TfFrameProvider = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    FListA: TStrings;
    function IsCanDel(const nID:string) : Boolean;
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    //�����ͷ�
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase, USysBusiness,
  UBusinessPacker;

class function TfFrameProvider.FrameID: integer;
begin
  Result := cFI_FrameProvider;
end;

procedure TfFrameProvider.OnCreateFrame;
begin
  inherited;
  FListA := TStringList.Create;
end;

procedure TfFrameProvider.OnDestroyFrame;
begin
  FListA.Free;
  inherited;
end;

function TfFrameProvider.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Provider;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  Result := Result + ' Order By P_Name';
end;

//Desc: ���
procedure TfFrameProvider.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormProvider, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: �޸�
procedure TfFrameProvider.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('P_ID').AsString;
    CreateBaseFormItem(cFI_FormProvider, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

//Desc: ɾ��
procedure TfFrameProvider.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('P_Name').AsString;

    if not IsCanDel(SQLQuery.FieldByName('P_ID').AsString) then
    begin
      ShowMsg('��Ӧ��[ '+nStr+' ]�Ѱ�Ʒ�֣���ɾ��Ʒ�ְ󶨺���ɾ����Ӧ��',sWarn);
      Exit;
    end;
    nStr := Format('ȷ��Ҫɾ����Ӧ��[ %s ]��?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Provider, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

//Desc: ��ѯ
procedure TfFrameProvider.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'P_Name like ''%%%s%%'' Or P_PY like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameProvider.N1Click(Sender: TObject);
begin
  inherited;
  SyncRemoteProviders;
  BtnRefresh.Click;
end;

procedure TfFrameProvider.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  {$IFDEF SyncRemote}
  N1.Visible := True;
  {$ENDIF}

  {$IFDEF MicroMsg}
  N2.Enabled := BtnEdit.Enabled;
  N3.Enabled := BtnEdit.Enabled;
  {$ELSE}
  N2.Visible := False;
  N3.Visible := False;
  {$ENDIF}
end;

procedure TfFrameProvider.N2Click(Sender: TObject);
var
  nWechartAccount:string;
  nParam: TFormCommandParam;
  nPID,nPName,nPhone:string;
  nBindcustomerid:string;
  nStr,nMsg:string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ��ͨ�ļ�¼', sHint);
    Exit;
  end;
  {$IFDEF UseWXServiceEx}
    nWechartAccount := SQLQuery.FieldByName('P_WechartAccount').AsString;
    if nWechartAccount<>'' then
    begin
      ShowMsg('�̳��˻�['+nWechartAccount+']�Ѵ���', sHint);
      Exit;
    end;
    nParam.FCommand := cCmd_AddData;
    CreateBaseFormItem(cFI_FormGetWXAccount, PopedomItem, @nParam);

    if (nParam.FCommand <> cCmd_ModalResult) or (nParam.FParamA <> mrOK) then Exit;

    nBindcustomerid  := nParam.FParamB;
    nWechartAccount  := nParam.FParamC;
    nPhone           := nParam.FParamD;
    nPID      := SQLQuery.FieldByName('P_ID').AsString;
    nPName    := SQLQuery.FieldByName('P_Name').AsString;

    with FListA do
    begin
      Clear;
      Values['Action']   := 'add';
      Values['BindID']   := nBindcustomerid;
      Values['Account']  := nWechartAccount;
      Values['CusID']    := nPID;
      Values['CusName']  := nPName;
      Values['Memo']     := sFlag_Provide;
      Values['Phone']    := nPhone;
      Values['btype']    := '2';
    end;
    nMsg := edit_shopclients(PackerEncodeStr(FListA.Text));
    if nMsg <> sFlag_Yes then
    begin
       ShowMsg('�����̳��˻�ʧ�ܣ�'+nMsg,sHint);
       Exit;
    end;

    //call remote
    nStr := 'update %s set P_WechartAccount=''%s'',P_Phone=''%s'',P_custSerialNo=''%s'' where P_ID=''%s''';
    nStr := Format(nStr,[sTable_Provider,nWechartAccount, nPhone, nBindcustomerid, nPID]);
  {$ELSE}
    nWechartAccount := SQLQuery.FieldByName('P_WechartAccount').AsString;
    if nWechartAccount<>'' then
    begin
      ShowMsg('�̳��˻�['+nWechartAccount+']�Ѵ���', sHint);
      Exit;
    end;
    nParam.FCommand := cCmd_AddData;
    CreateBaseFormItem(cFI_FormGetWXAccount, PopedomItem, @nParam);

    if (nParam.FCommand <> cCmd_ModalResult) or (nParam.FParamA <> mrOK) then Exit;

    nBindcustomerid  := nParam.FParamB;
    nWechartAccount  := nParam.FParamC;
    nPhone           := nParam.FParamD;
    nPID      := SQLQuery.FieldByName('P_ID').AsString;
    nPName    := SQLQuery.FieldByName('P_Name').AsString;

    with FListA do
    begin
      Clear;
      Values['Action']   := 'add';
      Values['BindID']   := nBindcustomerid;
      Values['Account']  := nWechartAccount;
      Values['CusID']    := nPID;
      Values['CusName']  := nPName;
      Values['Memo']     := sFlag_Provide;
    end;

    if edit_shopclients(PackerEncodeStr(FListA.Text)) <> sFlag_Yes then Exit;
    //call remote
    nStr := 'update %s set P_WechartAccount=''%s'',P_Phone=''%s'' where P_ID=''%s''';
    nStr := Format(nStr,[sTable_Provider,nWechartAccount, nPhone, nPID]);
  {$ENDIF}
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);
    FDM.ADOConn.CommitTrans;
    ShowMsg('��Ӧ�� [ '+nPName+' ] �����̳��˻��ɹ���',sHint);
    InitFormData(FWhere);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('�����̳��˻�ʧ��', 'δ֪����');
  end;
end;

procedure TfFrameProvider.N3Click(Sender: TObject);
var
  nWechartAccount:string;
  nPID:string;
  nStr:string;
  nPName,nMsg,nPhone,nBindID:string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫȡ���ļ�¼', sHint);
    Exit;
  end;
  {$IFDEF UseWXServiceEx}
    nWechartAccount := SQLQuery.FieldByName('P_WechartAccount').AsString;
    if nWechartAccount='' then
    begin
      ShowMsg('�̳��˻�������', sHint);
      Exit;
    end;

    nPID     := SQLQuery.FieldByName('P_ID').AsString;
    nPName   := SQLQuery.FieldByName('P_Name').AsString;
    nPhone   := SQLQuery.FieldByName('P_Phone').AsString;
    nBindID  := SQLQuery.FieldByName('P_custSerialNo').AsString;

    with FListA do
    begin
      Clear;
      Values['Action']   := 'del';
      Values['Account']  := nWechartAccount;
      Values['CusID']    := nPID;
      Values['CusName']  := nPName;
      Values['Memo']     := sFlag_Provide;
      Values['Phone']    := nPhone;
      Values['BindID']   := nBindID;
      Values['btype']    := '2';
    end;
    nMsg := edit_shopclients(PackerEncodeStr(FListA.Text));
    if nMsg <> sFlag_Yes then
    begin
       ShowMsg('ȡ�������̳��˻�ʧ�ܣ�'+nMsg,sHint);
       Exit;
    end;
    //call remote

    nStr := 'update %s set P_WechartAccount='''',P_Phone='''',P_custSerialNo='''' where P_ID=''%s''';
    nStr := Format(nStr,[sTable_Provider,nPID]);
  {$ELSE}
    nWechartAccount := SQLQuery.FieldByName('P_WechartAccount').AsString;
    if nWechartAccount='' then
    begin
      ShowMsg('�̳��˻�������', sHint);
      Exit;
    end;

    nPID := SQLQuery.FieldByName('P_ID').AsString;
    nPName := SQLQuery.FieldByName('P_Name').AsString;

    with FListA do
    begin
      Clear;
      Values['Action']   := 'del';
      Values['Account']  := nWechartAccount;
      Values['CusID']    := nPID;
      Values['CusName']  := nPName;
      Values['Memo']     := sFlag_Provide;
    end;

    if edit_shopclients(PackerEncodeStr(FListA.Text)) <> sFlag_Yes then Exit;
    //call remote

    nStr := 'update %s set P_WechartAccount='''',P_Phone='''' where P_ID=''%s''';
    nStr := Format(nStr,[sTable_Provider,nPID]);
  {$ENDIF}
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);
    FDM.ADOConn.CommitTrans;
    ShowMsg('��Ӧ�� [ '+nPName+' ] ȡ���̳��˻����� �ɹ���',sHint);
    InitFormData(FWhere);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('ȡ���̳��˻����� ʧ��', 'δ֪����');
  end;
end;

function TfFrameProvider.IsCanDel(const nID:string): Boolean;
var
  nStr:string;
begin
  Result := True;
  nStr := ' select R_ID from %s where B_ProID = ''%s'' ';
  nStr := Format(nStr,[sTable_OrderBase,nID]);
  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      Result := False;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameProvider, TfFrameProvider.FrameID);
end.
