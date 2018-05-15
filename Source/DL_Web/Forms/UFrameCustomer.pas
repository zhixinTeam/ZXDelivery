{*******************************************************************************
  作者: dmzn@163.com 2018-04-25
  描述: 客户管理
*******************************************************************************}
unit UFrameCustomer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, UFrameBase, uniGUITypes, uniLabel, uniEdit, Data.DB,
  Datasnap.DBClient, uniGUIClasses, uniBasicGrid, uniDBGrid, uniPanel,
  uniToolBar, uniGUIBaseClasses;

type
  TfFrameCustomer = class(TfFrameBase)
    EditName: TUniEdit;
    UniLabel1: TUniLabel;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    function InitFormDataSQL(const nWhere: string): string; override;
    //构建语句
  end;

implementation

{$R *.dfm}
uses
  uniGUIVars, MainModule, uniGUIApplication, uniGUIForm, UFormBase,
  UManagerGroup, USysBusiness, USysDB, USysConst;

function TfFrameCustomer.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Customer;
  if nWhere <> '' then
    Result := Result + ' where ' + nWhere;
  //xxxxx
end;

procedure TfFrameCustomer.BtnAddClick(Sender: TObject);
var nForm: TUniForm;
    nParam: TFormCommandParam;
begin
  nForm := SystemGetForm('TfFormCutomer', True);
  if not Assigned(nForm) then Exit;

  nParam.FCommand := cCmd_AddData;
  (nForm as TfFormBase).SetParam(nParam);

  nForm.ShowModal(
    procedure(Sender: TComponent; Result:Integer)
    begin
      if Result = mrok then
        InitFormData(FWhere);
      //refresh
    end);
  //show form
end;

procedure TfFrameCustomer.BtnEditClick(Sender: TObject);
var nForm: TUniForm;
    nParam: TFormCommandParam;
begin
  if DBGridMain.SelectedRows.Count < 1 then
  begin
    ShowMessage('请选择要修改的记录');
    Exit;
  end;

  nForm := SystemGetForm('TfFormCutomer', True);
  if not Assigned(nForm) then Exit;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := ClientDS.FieldByName('R_ID').AsString;
  (nForm as TfFormBase).SetParam(nParam);

  nForm.ShowModal(
    procedure(Sender: TComponent; Result:Integer)
    begin
      if Result = mrok then
        InitFormData(FWhere);
      //refresh
    end);
  //show form
end;

procedure TfFrameCustomer.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
    nList: TStrings;
begin
  if DBGridMain.SelectedRows.Count < 1 then
  begin
    ShowMessage('请选择要删除的记录');
    Exit;
  end;

  nStr := ClientDS.FieldByName('C_Name').AsString;
  nStr := Format('确定要删除名称为[ %s ]的客户吗?', [nStr]);
  MessageDlg(nStr, mtConfirmation, mbYesNo,
    procedure(Sender: TComponent; Res: Integer)
    begin
      if Res <> mrYes then Exit;
      //cancel

      nList := nil;
      try
        nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
        nStr := ClientDS.FieldByName('C_ID').AsString;

        nSQL := 'Delete From %s Where C_ID=''%s''';
        nSQL := Format(nSQL, [sTable_Customer, nStr]);
        nList.Add(nSQL);

        nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_CustomerItem, nStr]);
        nList.Add(nSQL);

        DBExecute(nList, nil, FDBType);
        gMG.FObjectPool.Release(nList);

        InitFormData(FWhere);
        ShowMessage('已成功删除记录');
      except
        on nErr: Exception do
        begin
          gMG.FObjectPool.Release(nList);
          ShowMessage('删除失败: ' + nErr.Message);
        end;
      end;
    end);
  //xxxxx
end;

procedure TfFrameCustomer.EditNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'C_Name like ''%%%s%%'' Or C_PY like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);
  end;
end;

initialization
  RegisterClass(TfFrameCustomer);
end.
