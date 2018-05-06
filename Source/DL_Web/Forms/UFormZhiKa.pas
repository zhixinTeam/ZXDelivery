{*******************************************************************************
  ����: dmzn@163.com 2018-05-05
  ����: ֽ������
*******************************************************************************}
unit UFormZhiKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Data.Win.ADODB,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, UFormBase, uniPanel, uniGUIBaseClasses, uniButton,
  uniEdit, uniLabel, uniMemo, uniMultiItem, uniComboBox, uniDateTimePicker,
  uniCheckBox, uniBasicGrid, uniStringGrid, uniGroupBox, uniBitBtn;

type
  TfFormZhiKa = class(TfFormBase)
    EditName: TUniEdit;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    EditCID: TUniEdit;
    UniLabel3: TUniLabel;
    EditProject: TUniEdit;
    EditSaleMan: TUniComboBox;
    UniLabel8: TUniLabel;
    UniLabel9: TUniLabel;
    EditCus: TUniComboBox;
    UniLabel13: TUniLabel;
    UniLabel14: TUniLabel;
    UniLabel6: TUniLabel;
    EditMoney: TUniEdit;
    EditDays: TUniDateTimePicker;
    Label1: TUniLabel;
    EditPayment: TUniComboBox;
    Grid1: TUniStringGrid;
    Label3: TUniLabel;
    BtnAdd: TUniBitBtn;
    BtnDel: TUniBitBtn;
    BtnGetContract: TUniBitBtn;
    Label2: TUniLabel;
    EditLading: TUniComboBox;
    procedure BtnOKClick(Sender: TObject);
    procedure EditSaleManChange(Sender: TObject);
    procedure Grid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure EditCIDKeyPress(Sender: TObject; var Key: Char);
    procedure BtnGetContractClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData(const nID: string);
    //��������
    procedure LoadContract(const nCID: string; const nQuery: TADOQuery);
    //��ȡ��ͬ
    function GetIDFromBox(const nBox: TUniComboBox): string;
    //��ȡ����
    procedure OnGetContract(const nContract: string);
    //������ͬ
  public
    { Public declarations }
    procedure OnCreateForm(Sender: TObject); override;
    function SetParam(const nParam: TFormCommandParam): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, UManagerGroup,
  Vcl.Grids, Vcl.StdCtrls, ULibFun, UFormGetContract, USysBusiness, USysRemote,
  USysDB, USysConst;

const
  giID    = 0;
  giName  = 1;
  giPrice = 2;
  giValue = 3;
  giType  = 4;
  giCheck = 5;
  //grid info:��������������

  cChecked = '��';

function fFormZhiKa: TfFormZhiKa;
begin
  Result := TfFormZhiKa(UniMainModule.GetFormInstance(TfFormZhiKa));
end;

procedure TfFormZhiKa.OnCreateForm(Sender: TObject);
begin
  with Grid1 do
  begin
    FixedCols := 2;
    RowCount := 0;
    Options := [goVertLine,goHorzLine,goEditing,goAlwaysShowEditor,goFixedColClick];
  end;

  InitFormData('');
end;

function TfFormZhiKa.SetParam(const nParam: TFormCommandParam): Boolean;
begin
  Result := inherited SetParam(nParam);
  case nParam.FCommand of
   cCmd_AddData:
    begin
      FParam.FParamA := '';
      InitFormData('');
    end;
   cCmd_EditData:
    begin
      BtnOK.Enabled := False;
      InitFormData(FParam.FParamA);
    end;
  end;
end;

//Date: 2018-05-03
//Parm: ��Ӧ�̱��
//Desc: ����nID��Ӧ�̵���Ϣ������
procedure TfFormZhiKa.InitFormData(const nID: string);
var nStr: string;
    nIdx: Integer;
    nQuery: TADOQuery;
begin
  EditCID.ReadOnly := nID <> '';
  BtnGetContract.Enabled := not EditCID.ReadOnly;
  EditSaleMan.ReadOnly := True;
  EditCus.ReadOnly := True;

  if nID = '' then
  begin
    EditSaleMan.Style := csDropDownList;
    EditCus.Style := csDropDownList
  end else
  begin
    EditSaleMan.Style := csDropDown;
    EditCus.Style := csDropDown
  end;

  if EditSaleMan.Items.Count < 1 then
    LoadSaleMan(EditSaleMan.Items);
  //xxxxx

  if EditPayment.Items.Count < 1 then
    LoadSysDictItem(sFlag_PaymentItem, EditPayment.Items);
  //xxxxx

  nQuery := nil;
  if nID <> '' then
  try
    with TStringHelper do
    begin
      nStr := 'Select zk.*,S_Name,S_PY,C_Name From $ZK zk ' +
              ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan' +
              ' Left Join $Cus cus On cus.c_ID=zk.Z_Customer ' +
              'Where zk.R_ID=$ID';
      nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
              MI('$Cus', sTable_Customer), MI('$SM', sTable_Salesman),
              MI('$ID', nID)]);
      //xxxxx

      nQuery := LockDBQuery(FDBType);
      //get query
      
      with DBQuery(nStr, nQuery) do
      begin
        if RecordCount < 1 then
        begin
          nStr := '��¼��Ϊ[ %s ]��ֽ������Ч.';
          ShowMessage(Format(nStr, [nID]));
          Exit;
        end;

        BtnOK.Enabled := True;
        First;

        FParam.FParamB      := FieldByName('Z_ID').AsString;
        EditName.Text       := FieldByName('Z_Name').AsString;
        EditCID.Text        := FieldByName('Z_CID').AsString;
        EditProject.Text    := FieldByName('Z_Project').AsString;
        EditPayment.Text    := FieldByName('Z_Payment').AsString;
        EditMoney.Text      := FieldByName('Z_YFMoney').AsString;
        EditDays.DateTime   := FieldByName('Z_ValidDays').AsDateTime;

        nStr := FieldByName('Z_Lading').AsString;
        EditLading.ItemIndex := StrListIndex(nStr, EditLading.Items, 0, '.');

        EditSaleMan.Text  := FieldByName('Z_SaleMan').AsString + '.' +
                             FieldByName('S_Name').AsString;
        //xxxxxx

        EditCus.Text      := FieldByName('Z_Customer').AsString + '.' +
                             FieldByName('C_Name').AsString;
        //xxxxxx
      end;
    end;

    LoadContract(EditCID.Text, nQuery);
    //���غ�ͬ

    nStr := 'Select * From %s Where D_ZID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaDtl, FParam.FParamB]);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        nStr := FieldByName('D_StockNo').AsString;
        for nIdx := 0 to Grid1.RowCount-1 do
        if Grid1.Cells[0, nIdx] = nStr then //���ƥ��
        begin
          Grid1.Cells[giValue, nIdx] := FieldByName('D_Value').AsString;
          Grid1.Cells[giPrice, nIdx] := FieldByName('D_Price').AsString;
          Grid1.Cells[giCheck, nIdx] := cChecked;
          Break;
        end;

        Next;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-05-05
//Parm: ��ͬ���;��ѯ����
//Desc: ���ر��ΪnCID�ĺ�ͬ����
procedure TfFormZhiKa.LoadContract(const nCID: string; const nQuery: TADOQuery);
var nStr: string;
    nIdx: Integer;
    nBool: Boolean;
    nC: TADOQuery;
begin
  nC := nil;
  with TStringHelper do
  try
    if Assigned(nQuery) then
         nC := nQuery
    else nC := LockDBQuery(FDBType);

    nBool := FParam.FCommand <> cCmd_EditData;
    if nBool then //�޸�ʱ�������
    begin
      nStr := 'Select sc.*,sm.S_Name,sm.S_PY,cus.C_Name as CusName,' +
              '$Now as S_Now From $SC sc' +
              ' Left Join $SM sm On sm.S_ID=sc.C_SaleMan' +
              ' Left Join $Cus cus On cus.C_ID=sc.C_Customer ' +
              'Where sc.C_ID=''$ID''';
      nStr := MacroValue(nStr, [MI('$SC', sTable_SaleContract),
              MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
              MI('$ID', nCID), MI('$Now', sField_SQLServer_Now)]);
      //xxxxx

      with DBQuery(nStr, nC) do
      if RecordCount > 0 then
      begin
        FParam.FParamC := nCID;
        nBool := FieldByName('C_XuNi').AsString = sFlag_Yes;
        EditSaleMan.ReadOnly := nBool;
        EditCus.ReadOnly := nBool;

        nStr := FieldByName('C_SaleMan').AsString + '.' +
                FieldByName('S_Name').AsString;
        if EditSaleMan.Items.IndexOf(nStr) < 0 then
          EditSaleMan.Items.Add(nStr);
        //xxxxx

        nStr := FieldByName('C_SaleMan').AsString;
        EditSaleMan.ItemIndex := StrListIndex(nStr, EditSaleMan.Items, 0, '.');

        nStr := FieldByName('C_Customer').AsString + '.' +
                FieldByName('CusName').AsString;
        if EditCus.Items.IndexOf(nStr) < 0 then
          EditCus.Items.Add(nStr);
        //xxxxx

        nStr := FieldByName('C_Customer').AsString;
        EditCus.ItemIndex := StrListIndex(nStr, EditCus.Items, 0, '.');

        EditDays.DateTime := FieldByName('S_Now').AsFloat +
                             FieldByName('C_ZKDays').AsInteger;
        //��ǰ + ʱ��
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From %s Where E_CID=''%s''';
    nStr := Format(nStr, [sTable_SContractExt, nCID]);

    with DBQuery(nStr, nC) do
    if RecordCount > 0 then
    begin
      if FParam.FParamC = '' then
        FParam.FParamC := nCID;
      //xxxxx
      
      Grid1.RowCount := RecordCount;
      nIdx := 0;
      First;

      while not Eof do
      begin
        Grid1.Cells[giID, nIdx] := FieldByName('E_StockNo').AsString;
        Grid1.Cells[giName, nIdx] := FieldByName('E_StockName').AsString;
        Grid1.Cells[giPrice, nIdx] := FieldByName('E_Price').AsString;
        Grid1.Cells[giValue, nIdx] := '0';
        Grid1.Cells[giType, nIdx] := FieldByName('E_Type').AsString;

        Inc(nIdx);
        Next;
      end;
    end;
  finally
    if not Assigned(nQuery) then
      ReleaseDBQuery(nC);
    //xxxxx
  end;
end;

function TfFormZhiKa.GetIDFromBox(const nBox: TUniComboBox): string;
begin
  Result := nBox.Text;
  Result := Copy(Result, 1, Pos('.', Result) - 1);
end;

procedure TfFormZhiKa.Grid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ACol = giCheck then
  begin
    if Grid1.Cells[giCheck, ARow] = cChecked then
         Grid1.Cells[giCheck, ARow] := ''
    else Grid1.Cells[giCheck, ARow] := cChecked;
  end;
end;

//Desc: ҵ��Ա���,ѡ��ͻ�
procedure TfFormZhiKa.EditSaleManChange(Sender: TObject);
var nStr: string;
begin
  nStr := GetIDFromBox(EditSaleMan);
  if nStr = '' then
  begin
    EditCus.Items.Clear;
    Exit;
  end;

  nStr := Format('C_SaleMan=''%s''', [nStr]);
  LoadCustomer(EditCus.Items, nStr);
end;

//Desc: ���غ�ͬ
procedure TfFormZhiKa.EditCIDKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditCID.Text := Trim(EditCID.Text);

    if EditCID.Text <> '' then
      LoadContract(EditCID.Text, nil);
    //xxxxx
  end;
end;

procedure TfFormZhiKa.OnGetContract(const nContract: string);
begin
  if nContract <> '' then
  begin
    EditCID.Text := nContract;
    LoadContract(nContract, nil);
  end;
end;

//Desc: ѡ���ͬ
procedure TfFormZhiKa.BtnGetContractClick(Sender: TObject);
begin
  ShowGetContractForm(OnGetContract);
end;

procedure TfFormZhiKa.BtnOKClick(Sender: TObject);
var nStr,nID,nVerify: string;
    nIdx: Integer;
    nBool: Boolean;
    nList: TStrings;
    nQuery: TADOQuery;
begin            
  if FParam.FParamC = '' then
  begin
    ShowMessage('����д��ͬ���'); 
    Exit;
  end;

  nID := GetIDFromBox(EditCus);
  if nID = '' then
  begin
    ShowMessage('��ѡ��ͻ�'); 
    Exit;
  end;

  if EditDays.DateTime <= Date() then
  begin
    ShowMessage('����д��Ч��ʱ��'); 
    Exit;
  end;

  with TStringHelper do
  if (not IsNumber(EditMoney.Text, True)) or
     (StrToFloat(EditMoney.Text) < 0) then
  begin
    ShowMessage('Ԥ���������ֵ');
    Exit;
  end;

  for nIdx := 0 to Grid1.RowCount - 1 do
  with TStringHelper do
  begin
    if Grid1.Cells[giCheck, nIdx] <> cChecked then Continue;
    if (not IsNumber(Grid1.Cells[giPrice, nIdx], True)) or
       (StrToFloat(Grid1.Cells[giPrice, nIdx]) <= 0) then
    begin
      nStr := 'Ʒ��[ %s ]������Ч.';
      ShowMessage(Format(nStr, [Grid1.Cells[giName, nIdx]]));
      Exit;
    end;
  end;

  nList := nil;
  nQuery := nil;
  with TSQLBuilder,TStringHelper,TDateTimeHelper do
  try
    nBool := FParam.FCommand <> cCmd_EditData;
    if nBool then
    begin
      nID := GetSerialNo(sFlag_BusGroup, sFlag_ZhiKa, False);
      if nID = '' then Exit;      
    end else nID := FParam.FParamB;
    //new id

    nVerify := sFlag_Yes;
    if nBool then
    begin
      nQuery := LockDBQuery(FDBType);
      if IsZhiKaNeedVerify(nQuery) then
        nVerify := sFlag_No;
      //xxxxx
    end;

    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;    
    nStr := SF('R_ID', FParam.FParamA, sfVal);

    nStr := MakeSQLByStr([
      SF_IF([SF('Z_ID', nID), ''], nBool),
      SF('Z_Name', EditName.Text),
      SF('Z_CID', FParam.FParamC),
      SF('Z_Project', EditProject.Text),
      SF('Z_Payment', EditPayment.Text),
      
      SF('Z_Lading', GetIDFromBox(EditLading)),
      SF('Z_ValidDays', Date2Str(EditDays.DateTime)),
      SF('Z_YFMoney', EditMoney.Text, sfVal),
      SF('Z_Man', UniMainModule.FUserConfig.FUserID),
      SF('Z_Date', sField_SQLServer_Now, sfVal),
      
      SF_IF([SF('Z_Customer', GetIDFromBox(EditCus)), ''], nBool),
      SF_IF([SF('Z_SaleMan', GetIDFromBox(EditSaleMan)), ''], nBool),
      SF_IF([SF('Z_Verified', nVerify), ''], nBool)
      ], sTable_ZhiKa, nStr, nBool);
    nList.Add(nStr);

    if not nBool then
    begin
      nStr := 'Delete From %s Where D_ZID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKaDtl, nID]);
      nList.Add(nStr);
    end;

    for nIdx:=0 to Grid1.RowCount-1 do
    begin
      if Grid1.Cells[giCheck, nIdx] <> cChecked then Continue;
      //no selected

      nStr := MakeSQLByStr([SF('D_ZID', nID),
              SF('D_Type', Grid1.Cells[giType, nIdx]),
              SF('D_StockNo', Grid1.Cells[giID, nIdx]),
              SF('D_StockName', Grid1.Cells[giName, nIdx]),
              SF('D_Price', Grid1.Cells[giPrice, nIdx], sfVal),

              SF_IF([SF('D_Value', Grid1.Cells[giValue, nIdx], sfVal),
                     'D_Value=0'], IsNumber(Grid1.Cells[giValue, nIdx], True))
              //xxxxx
              ], sTable_ZhiKaDtl, '', True);
      nList.Add(nStr);
    end;

    DBExecute(nList, nil, ctWork);
    ModalResult := mrOk;
  finally
    gMG.FObjectPool.Release(nList);
    ReleaseDBQuery(nQuery);
  end;
end;

initialization
  RegisterClass(TfFormZhiKa);
end.