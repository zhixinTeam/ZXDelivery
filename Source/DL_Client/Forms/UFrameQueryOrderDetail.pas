{*******************************************************************************
  ����: fendou116688@163.com 2015/8/10
  ����: �ɹ�������ϸ
*******************************************************************************}
unit UFrameQueryOrderDetail;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameOrderDetailQuery = class(TfFrameNormal)
    cxtxtdt1: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxtxtdt2: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    pmPMenu1: TPopupMenu;
    mniN1: TMenuItem;
    cxtxtdt3: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxtxtdt4: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditBill: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure mniN1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //ʱ������
    FJBWhere: string;
    //��������
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //��ѯSQL
    function GetVal(const nRow: Integer; const nField: string): string;
    //��ȡָ���ֶ�
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormDateFilter, USysPopedom, USysBusiness,
  UBusinessConst, USysConst, USysDB, UDataModule, UFormInputbox;

class function TfFrameOrderDetailQuery.FrameID: integer;
begin
  Result := cFI_FrameOrderDetailQuery;
end;

procedure TfFrameOrderDetailQuery.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
  N7.Visible := False;
  N8.Visible := False;
  {$IFDEF SendUnLoadPlace}
  if gSysParam.FIsAdmin then
  begin
    N7.Visible := True;
    N8.Visible := True;
  end;
  {$ENDIF}
end;

procedure TfFrameOrderDetailQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameOrderDetailQuery.InitFormDataSQL(const nWhere: string): string;
begin
  {$IFDEF SpecialControl}
  MakeOrderViewData;
  {$ENDIF}

  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
  Result := 'Select *,(D_MValue-D_PValue-D_KZValue) as D_NetWeight ' +
            'From $OD od Inner Join $OO oo on od.D_OID=oo.O_ID ';
  //xxxxxx

  if FJBWhere = '' then
  begin
    Result := Result + 'Where (D_OutFact>=''$S'' and D_OutFact <''$End'')';

    if nWhere <> '' then
      Result := Result + ' And (' + nWhere + ')';
    //xxxxx
  end else
  begin
    Result := Result + ' Where (' + FJBWhere + ')';
  end;

  Result := MacroValue(Result, [MI('$OD', sTable_OrderDtl),MI('$OO', sTable_Order),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;


//Desc: ����ɸѡ
procedure TfFrameOrderDetailQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: ִ�в�ѯ
procedure TfFrameOrderDetailQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'D_ProPY like ''%%%s%%'' Or D_ProName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'oo.O_Truck like ''%%%s%%''';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end;

  if Sender = EditBill then
  begin
    EditBill.Text := Trim(EditBill.Text);
    if EditBill.Text = '' then Exit;

    FWhere := 'od.D_ID like ''%%%s%%''';
    FWhere := Format(FWhere, [EditBill.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: ���Ӱ��ѯ
procedure TfFrameOrderDetailQuery.mniN1Click(Sender: TObject);
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := '(D_OutFact>=''%s'' and D_OutFact <''%s'')';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE)]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;
//------------------------------------------------------------------------------
//Date: 2015/8/13
//Parm: 
//Desc: ��ѯδ���
procedure TfFrameOrderDetailQuery.N2Click(Sender: TObject);
begin
  inherited;
  try
    FJBWhere := '(D_OutFact Is Null And D_DStatus<>''%s'')';
    FJBWhere := Format(FJBWhere, [sFlag_OrderDel]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;
//------------------------------------------------------------------------------
//Date: 2015/8/13
//Parm: 
//Desc: ɾ��δ��ɼ�¼
procedure TfFrameOrderDetailQuery.N3Click(Sender: TObject);
var nStr: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('D_ID').AsString;
    if not QueryDlg('ȷ��ɾ���ö���ô?', sWarn) then Exit;

    //nSQL := MacroValue()
  end;

  N2.Click;
end;

procedure TfFrameOrderDetailQuery.N5Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ�༭�ļ�¼', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    for nIdx := 0 to cxView1.DataController.RowCount - 1  do
    begin

      nStr := GetVal(nIdx,'D_ID');
      if nStr = '' then
        Continue;

      nList.Add(nStr);
    end;

    nStr := AdjustListStrFormat2(nList, '''', True, ',', False);
    PrintOrderReport(nStr, False, True);
  finally
    nList.Free;
  end;
end;

//Desc: ��ȡnRow��nField�ֶε�����
function TfFrameOrderDetailQuery.GetVal(const nRow: Integer;
 const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.ViewData.Rows[nRow].Values[
            cxView1.GetColumnByFieldName(nField).Index];
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

procedure TfFrameOrderDetailQuery.N7Click(Sender: TObject);
var nStr,nID,nPlace: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('D_SPlace').AsString;
    nPlace := nStr;
    if not ShowInputBox('�������µķ����ص�:', '�޸�', nPlace, 100) then Exit;

    if (nPlace = '') or (nStr = nPlace) then Exit;
    //��Ч��һ��
    nID := SQLQuery.FieldByName('D_ID').AsString;

    nStr := 'Update %s Set D_SPlace=''%s'' Where D_ID=''%s''';
    nStr := Format(nStr, [sTable_OrderDtl, nPlace, nID]);
    FDM.ExecuteSQL(nStr);

    nStr := '�ɹ���[ %s ]�޸ķ����ص�[ %s -> %s ].';
    nStr := Format(nStr, [nID, SQLQuery.FieldByName('D_SPlace').AsString, nPlace]);
    FDM.WriteSysLog(sFlag_BillItem, nID, nStr, False);

    InitFormData(FWhere);
    ShowMsg('�����ص��޸ĳɹ�', sHint);
  end;
end;

procedure TfFrameOrderDetailQuery.N8Click(Sender: TObject);
var nStr,nID,nPlace: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('D_UPlace').AsString;
    nPlace := nStr;
    if not ShowInputBox('�������µ��ջ��ص�:', '�޸�', nPlace, 100) then Exit;

    if (nPlace = '') or (nStr = nPlace) then Exit;
    //��Ч��һ��
    nID := SQLQuery.FieldByName('D_ID').AsString;

    nStr := 'Update %s Set D_UPlace=''%s'' Where D_ID=''%s''';
    nStr := Format(nStr, [sTable_OrderDtl, nPlace, nID]);
    FDM.ExecuteSQL(nStr);

    nStr := '�ɹ���[ %s ]�޸��ջ��ص�[ %s -> %s ].';
    nStr := Format(nStr, [nID, SQLQuery.FieldByName('D_UPlace').AsString, nPlace]);
    FDM.WriteSysLog(sFlag_BillItem, nID, nStr, False);

    InitFormData(FWhere);
    ShowMsg('�ջ��ص��޸ĳɹ�', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameOrderDetailQuery, TfFrameOrderDetailQuery.FrameID);
end.
