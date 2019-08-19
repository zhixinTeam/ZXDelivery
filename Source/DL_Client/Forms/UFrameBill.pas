{*******************************************************************************
  ����: dmzn@163.com 2009-6-22
  ����: �������
*******************************************************************************}
unit UFrameBill;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, Menus,
  UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters,
  cxCheckBox;

type
  TfFrameBill = class(TfFrameNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Edit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    dxLayout1Item10: TdxLayoutItem;
    CheckDelete: TcxCheckBox;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure CheckDeleteClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //ʱ������
    FUseDate: Boolean;
    //ʹ������
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure AfterInitFormData; override;
    {*��ѯSQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter;

//------------------------------------------------------------------------------
class function TfFrameBill.FrameID: integer;
begin
  Result := cFI_FrameBill;
end;

procedure TfFrameBill.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  InitDateRange(Name, FStart, FEnd);
  N12.Enabled := gSysParam.FIsAdmin;
end;

procedure TfFrameBill.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: ���ݲ�ѯSQL
function TfFrameBill.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  FEnableBackDB := True;

  {$IFDEF UseSelectDateTime}
  EditDate.Text := Format('%s �� %s', [DateTime2Str(FStart), DateTime2Str(FEnd)]);
  {$ELSE}
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
  {$ENDIF}

  {$IFDEF UseFreight}
  Result := 'Select distinct *,L_Value*L_Freight as TotalFreight From $Bill ';
  {$ELSE}
  Result := 'Select distinct * From $Bill ';
  {$ENDIF}
  //�����

  {$IFDEF AlwaysUseDate}
  if CheckDelete.Checked then
    Result := Result + 'Where (L_DelDate>=''$ST'' and L_DelDate <''$End'')'
  else
    Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')';
  nStr := ' And ';
  {$ELSE}
  if (nWhere = '') or FUseDate then
  begin
    if CheckDelete.Checked then
      Result := Result + 'Where (L_DelDate>=''$ST'' and L_DelDate <''$End'')'
    else
      Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')';
    nStr := ' And ';
  end else nStr := ' Where ';
  {$ENDIF}

  if nWhere <> '' then
    Result := Result + nStr + '(' + nWhere + ')';
  //xxxxx

  {$IFDEF UseSelectDateTime}
  Result := MacroValue(Result, [
            MI('$ST', DateTime2Str(FStart)), MI('$End', DateTime2Str(FEnd))]);
  {$ELSE}
  Result := MacroValue(Result, [
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  {$ENDIF}

  if CheckDelete.Checked then
       Result := MacroValue(Result, [MI('$Bill', sTable_BillBak)])
  else Result := MacroValue(Result, [MI('$Bill', sTable_Bill)]);
end;

procedure TfFrameBill.AfterInitFormData;
begin
  FUseDate := True;
end;

function TfFrameBill.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'L_Price';
end;

//Desc: ִ�в�ѯ
procedure TfFrameBill.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FUseDate := Length(EditLID.Text) <= 3;
    FWhere := 'L_ID like ''%' + EditLID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FUseDate := Length(EditCard.Text) <= 3;
    FWhere := Format('L_Truck like ''%%%s%%''', [EditCard.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: δ��ʼ����������
procedure TfFrameBill.N4Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('(L_Status=''%s'')', [sFlag_BillNew]);
   20: FWhere := 'L_OutFact Is Null'
   else Exit;
  end;

  FUseDate := False;
  InitFormData(FWhere);
end;

//Desc: ����ɸѡ
procedure TfFrameBill.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  {$IFDEF UseSelectDateTime}
  if ShowDateFilterForm(FStart, FEnd, True) then InitFormData('');
  {$ELSE}
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
  {$ENDIF}
end;

//Desc: ��ѯɾ��
procedure TfFrameBill.CheckDeleteClick(Sender: TObject);
begin
  InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: �������
procedure TfFrameBill.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormBill, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: ɾ��
procedure TfFrameBill.BtnDelClick(Sender: TObject);
var nStr, nID: string;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫɾ���ļ�¼', sHint); Exit;
  end;

  with nP do
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    nStr := Format('����дɾ��[ %s ]���ݵ�ԭ��', [nStr]);

    FCommand := cCmd_EditData;
    FParamA := nStr;
    FParamB := 320;
    FParamD := 2;

    nStr := SQLQuery.FieldByName('R_ID').AsString;
    FParamC := 'Update %s Set L_Memo=''$Memo'' Where R_ID=%s';
    FParamC := Format(FParamC, [sTable_Bill, nStr]);

    CreateBaseFormItem(cFI_FormMemo, '', @nP);
    if (FCommand <> cCmd_ModalResult) or (FParamA <> mrOK) then Exit;
  end;

  nID := SQLQuery.FieldByName('L_ID').AsString;

  if DeleteBill(nID) then
  begin
    GetCustomerValidMoney(SQLQuery.FieldByName('L_CusID').AsString);
    InitFormData(FWhere);
    ShowMsg('�������ɾ��', sHint);
  end;

  try
    SaveWebOrderDelMsg(nID,sFlag_Sale);
  except
    ShowMsg('����΢�Ŷ���Ϣ����ʧ��.',sHint);
    Exit;
  end;
  //����ɾ������
end;

//Desc: ��ӡ�����
procedure TfFrameBill.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintBillReport(nStr, False);
  end;
end;

procedure TfFrameBill.PMenu1Popup(Sender: TObject);
begin
  N3.Enabled := gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit);
  //���۵���

  {$IFDEF DYGL}
  N10.Visible := True;
  N11.Visible := True;
  //��ӡԤ�ᵥ�͹�·��
  {$ENDIF}
end;

//Desc: �޸�δ�������ƺ�
procedure TfFrameBill.N5Click(Sender: TObject);
var nStr,nTruck: string;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    {$IFDEF ForceMemo}
    with nP do
    begin
      nStr := SQLQuery.FieldByName('L_ID').AsString;
      nStr := Format('����д�޸�[ %s ]���ݳ��ƺŵ�ԭ��', [nStr]);

      FCommand := cCmd_EditData;
      FParamA := nStr;
      FParamB := 320;
      FParamD := 2;

      nStr := SQLQuery.FieldByName('R_ID').AsString;
      FParamC := 'Update %s Set L_Memo=''$Memo'' Where R_ID=%s';
      FParamC := Format(FParamC, [sTable_Bill, nStr]);

      CreateBaseFormItem(cFI_FormMemo, '', @nP);
      if (FCommand <> cCmd_ModalResult) or (FParamA <> mrOK) then Exit;
    end;
    {$ENDIF}

    nStr := SQLQuery.FieldByName('L_Truck').AsString;
    nTruck := nStr;
    if not ShowInputBox('�������µĳ��ƺ���:', '�޸�', nTruck, 15) then Exit;

    if (nTruck = '') or (nStr = nTruck) then Exit;
    //��Ч��һ��

    nStr := SQLQuery.FieldByName('L_ID').AsString;
    if ChangeLadingTruckNo(nStr, nTruck) then
    begin
      nStr := '�޸ĳ��ƺ�[ %s -> %s ].';
      nStr := Format(nStr, [SQLQuery.FieldByName('L_Truck').AsString, nTruck]);
      FDM.WriteSysLog(sFlag_BillItem, SQLQuery.FieldByName('L_ID').AsString, nStr, False);

      InitFormData(FWhere);
      ShowMsg('���ƺ��޸ĳɹ�', sHint);
    end;
  end;
end;

//Desc: �޸ķ�ǩ��
procedure TfFrameBill.N7Click(Sender: TObject);
var nStr,nID,nSeal,nSave: string;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    {$IFDEF ForceMemo}
    with nP do
    begin
      nStr := SQLQuery.FieldByName('L_ID').AsString;
      nStr := Format('����д�޸�[ %s ]���ݷ�ǩ�ŵ�ԭ��', [nStr]);

      FCommand := cCmd_EditData;
      FParamA := nStr;
      FParamB := 320;
      FParamD := 2;

      nStr := SQLQuery.FieldByName('R_ID').AsString;
      FParamC := 'Update %s Set L_Memo=''$Memo'' Where R_ID=%s';
      FParamC := Format(FParamC, [sTable_Bill, nStr]);

      CreateBaseFormItem(cFI_FormMemo, '', @nP);
      if (FCommand <> cCmd_ModalResult) or (FParamA <> mrOK) then Exit;
    end;
    {$ENDIF}

    {$IFDEF BatchInHYOfBill}
    nSave := 'L_HYDan';
    {$ELSE}
    nSave := 'L_Seal';
    {$ENDIF}

    nStr := SQLQuery.FieldByName(nSave).AsString;
    nSeal := nStr;
    if not ShowInputBox('�������µķ�ǩ���:', '�޸�', nSeal, 100) then Exit;

    if (nSeal = '') or (nStr = nSeal) then Exit;
    //��Ч��һ��
    nID := SQLQuery.FieldByName('L_ID').AsString;

    nStr := 'ȷ��Ҫ��������[ %s ]�ķ�ǩ�Ÿ�Ϊ[ %s ]��?';
    nStr := Format(nStr, [nID, nSeal]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Update %s Set %s=''%s'' Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nSave, nSeal, nID]);
    FDM.ExecuteSQL(nStr);

    nStr := '�޸ķ�ǩ��[ %s -> %s ].';
    nStr := Format(nStr, [SQLQuery.FieldByName(nSave).AsString, nSeal]);
    FDM.WriteSysLog(sFlag_BillItem, nID, nStr, False);

    InitFormData(FWhere);
    ShowMsg('��ǩ���޸ĳɹ�', sHint);
  end;
end;

//Desc: ���������
procedure TfFrameBill.N3Click(Sender: TObject);
var nStr,nTmp,nOldZhiKa: string;
    nP,nPMemo: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_AddData;
    CreateBaseFormItem(cFI_FormGetZhika, PopedomItem, @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    nStr      := SQLQuery.FieldByName('L_ZhiKa').AsString;
    nOldZhiKa := SQLQuery.FieldByName('L_ZhiKa').AsString;
    if nStr = nP.FParamB then
    begin
      ShowMsg('��ֽͬ�����ܵ���', sHint);
      Exit;
    end;

    nStr := 'Select C_ID,C_Name From %s,%s ' +
            'Where Z_ID=''%s'' And Z_Customer=C_ID';
    nStr := Format(nStr, [sTable_ZhiKa, sTable_Customer, nP.FParamB]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('ֽ����Ϣ��Ч', sHint);
        Exit;
      end;

      nStr := 'ϵͳ��ִ�������������,��ϸ����: ' + #13#10#13#10 +
              '��.�ӿͻ�: %s.%s' + #13#10 +
              '��.���ͻ�: %s.%s' + #13#10 +
              '��.Ʒ  ��: %s.%s' + #13#10 +
              '��.������: %.2f��' + #13#10#13#10 +
              'ȷ��Ҫִ������"��".';
      nStr := Format(nStr, [SQLQuery.FieldByName('L_CusID').AsString,
              SQLQuery.FieldByName('L_CusName').AsString,
              FieldByName('C_ID').AsString,
              FieldByName('C_Name').AsString,
              SQLQuery.FieldByName('L_StockNo').AsString,
              SQLQuery.FieldByName('L_StockName').AsString,
              SQLQuery.FieldByName('L_Value').AsFloat]);
      if not QueryDlg(nStr, sAsk) then Exit;

      {$IFDEF ForceMemo}
      with nPMemo do
      begin
        nStr := SQLQuery.FieldByName('L_ID').AsString;
        nStr := Format('����д����[ %s ]���ݵ�ԭ��', [nStr]);

        FCommand := cCmd_EditData;
        FParamA := nStr;
        FParamB := 320;
        FParamD := 2;

        nStr := SQLQuery.FieldByName('R_ID').AsString;
        FParamC := 'Update %s Set L_Memo=''$Memo'' Where R_ID=%s';
        FParamC := Format(FParamC, [sTable_Bill, nStr]);

        CreateBaseFormItem(cFI_FormMemo, '', @nPMemo);
        if (FCommand <> cCmd_ModalResult) or (FParamA <> mrOK) then Exit;
      end;
      {$ENDIF}

      nStr := SQLQuery.FieldByName('L_ID').AsString;
      if BillSaleAdjust(nStr, nP.FParamB) then
      begin
        nTmp := 'ִ�������������,��ϸ:�����[ %s ]ֽ��[ %s ]���۵�����ֽ��[ %s ].'+
                '�ӿͻ�: %s.%s.���ͻ�: %s.%s.Ʒ  ��: %s.%s.������: %.2f��.';
        nTmp := Format(nTmp, [nStr, nOldZhiKa, nP.FParamB,
                SQLQuery.FieldByName('L_CusID').AsString,
                SQLQuery.FieldByName('L_CusName').AsString,
                FieldByName('C_ID').AsString,
                FieldByName('C_Name').AsString,
                SQLQuery.FieldByName('L_StockNo').AsString,
                SQLQuery.FieldByName('L_StockName').AsString,
                SQLQuery.FieldByName('L_Value').AsFloat]);

        FDM.WriteSysLog(sFlag_BillItem, nStr, nTmp, False);
        InitFormData(FWhere);
        ShowMsg('�����ɹ�', sHint);
      end;
    end;
  end;
end;

procedure TfFrameBill.N10Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintBillLoadReport(nStr, False);
  end;
end;

procedure TfFrameBill.N11Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintBillFYDReport(nStr, False);
  end;
end;

procedure TfFrameBill.cxView1DblClick(Sender: TObject);
var nStr: string;
    nP: TFormCommandParam;
begin
  if (not CheckDelete.Checked) or
     (cxView1.DataController.GetSelectedCount < 1) then Exit;
  //ֻ�޸�ɾ����¼�ı�ע��Ϣ

  with nP do
  begin
    FCommand := cCmd_EditData;
    FParamA := SQLQuery.FieldByName('L_Memo').AsString;
    FParamB := 320;
    FParamD := 2;

    nStr := SQLQuery.FieldByName('R_ID').AsString;
    FParamC := 'Update %s Set L_Memo=''$Memo'' Where R_ID=%s';
    FParamC := Format(nP.FParamC, [sTable_BillBak, nStr]);

    CreateBaseFormItem(cFI_FormMemo, '', @nP);
    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
      InitFormData(FWhere);
    //display
  end;
end;

procedure TfFrameBill.N12Click(Sender: TObject);
var
  nStr, nID, nValue, nCusID: string;
  nDblValue,nMoney: Double;
  nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nID := SQLQuery.FieldByName('L_ID').AsString;
    nCusID := SQLQuery.FieldByName('L_CusId').AsString;
    
    nStr := 'ȷ��Ҫ�Խ�����[ %s ]���лص�������?';
    nStr := Format(nStr, [nID]);
    if not QueryDlg(nStr, sAsk) then Exit;
    
    {$IFDEF ForceMemo}
    with nP do
    begin
      nStr := Format('����д����[ %s ]�ص���ԭ��', [nID]);

      FCommand := cCmd_EditData;
      FParamA := nStr;
      FParamB := 320;
      FParamD := 2;

      nStr := SQLQuery.FieldByName('R_ID').AsString;
      FParamC := 'Update %s Set L_Memo=''$Memo'' Where R_ID=%s';
      FParamC := Format(FParamC, [sTable_Bill, nStr]);

      CreateBaseFormItem(cFI_FormMemo, '', @nP);
      if (FCommand <> cCmd_ModalResult) or (FParamA <> mrOK) then Exit;
    end;
    {$ENDIF}

    if not ShowInputBox('������ص�����,ע�⣺�ص�ʵ�ʶ���:',
                        '�޸�', nValue, 100) then Exit;

    if not IsNumber(nValue, True) then
    begin
      ShowMessage('��������ȷ�Ļص�����');
      Exit;
    end;
    //��Ч

    nDblValue := strtofloat(nValue) - SQLQuery.FieldByName('L_Value').asfloat;
    nMoney := nDblValue * SQLQuery.FieldByName('L_Price').asfloat;
    nValue := FloatToStr(nDblValue);

    FDM.ADOConn.BeginTrans;
    try
      nStr := 'insert into S_Bill(L_Value,L_MValue,L_ID,L_ZhiKa,L_Project,'+
              'L_Area,L_CusID,L_CusName,L_CusPY,L_SaleMan,L_Type,L_StockNo,'+
              'L_StockName,L_Price,L_Truck,L_Status,L_NextStatus,L_InTime,'+
              'L_InMan,L_PValue,L_PDate,L_PMan,L_MDate,L_MMan,L_LadeTime,'+
              'L_LadeMan,L_LadeLine,L_LineName,L_DaiTotal,L_DaiNormal,'+
              'L_DaiBuCha,L_OutFact,L_OutMan,L_Lading,L_IsVIP,L_HYDan,'+
              'L_PrintHY,L_EmptyOut,L_Man,L_Date,L_CusType) select '+nValue+
              ' as L_Value,L_PValue+'+nValue+' as L_MValue,'+
              'L_ID,L_ZhiKa,L_Project,L_Area,L_CusID,L_CusName,L_CusPY,'+
              'L_SaleMan,L_Type,L_StockNo,L_StockName,'+
              'L_Price,L_Truck,L_Status,L_NextStatus,L_InTime,L_InMan,L_PValue,'+
              'L_PDate,L_PMan,L_MDate,L_MMan,L_LadeTime,L_LadeMan,L_LadeLine,'+
              'L_LineName,L_DaiTotal,L_DaiNormal,L_DaiBuCha,L_OutFact,L_OutMan,'+
              'L_Lading,L_IsVIP,L_HYDan,L_PrintHY,L_EmptyOut,L_Man,L_Date,'+
              'L_CusType from S_Bill where L_ID=''%s''';
      nStr := Format(nStr,[nID]);
      FDM.ExecuteSQL(nStr);

      nStr := 'Update %s set A_OutMoney=A_OutMoney+%s where A_CID=''%s''';
      nStr := Format(nStr,[sTable_CusAccount ,FloatToStr(nMoney) ,nCusID]);
      FDM.ExecuteSQL(nStr);
 
      nStr := '����['+nID+']���лص�����.';
      FDM.WriteSysLog(sFlag_BillItem, nID, nStr, False);

      FDM.ADOConn.CommitTrans;
    except
      FDM.ADOConn.RollbackTrans;
      ShowMessage('�ص�����ʧ��.');
      Exit;
    end;

    InitFormData(FWhere);
    ShowMsg('�ص��ɹ�', sHint);
  end;
end;

procedure TfFrameBill.N13Click(Sender: TObject);
var
  nStr : string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    FDM.ADOConn.BeginTrans;
    try
      nStr := ' update S_Bill set L_Area= C_Area From ( ' +
        ' SELECT C_Area,Z_ID FROM S_ZhiKa lEFT JOIN S_Contract oN Z_CID=C_ID ' +
        ' Where C_Area <> '''')B  where L_Area='''' AND L_ZhiKa=Z_ID ';
      FDM.ExecuteSQL(nStr);

      FDM.ADOConn.CommitTrans;
    except
      FDM.ADOConn.RollbackTrans;
      ShowMessage('ͬ����������ʧ��.');
      Exit;
    end;

    InitFormData(FWhere);
    ShowMsg('ͬ����������ɹ�', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameBill, TfFrameBill.FrameID);
end.
