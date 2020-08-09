{*******************************************************************************
  ����: dmzn@163.com 2017-10-17
  ����: �������ۻص�
*******************************************************************************}
unit UFrameBatcodeRecord;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels, UFormInputbox,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxLCPainter, cxGridCustomPopupMenu,
  cxGridPopupMenu;

type
  TfFrameBatcodeRecord = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCode: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    pm1: TPopupMenu;
    N1: TMenuItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //ʱ������
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
    function GetVal(const nRow: Integer; const nField: string): string;
    //��ȡ�ֶ�ֵ
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysBusiness, USysConst, USysDB, UDataModule,
  UFormBase, UFormDateFilter;

class function TfFrameBatcodeRecord.FrameID: integer;
begin
  Result := cFI_FrameBatchRecord;
end;

procedure TfFrameBatcodeRecord.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);

  if FStart = Date() then
    FStart := Date() - 7;
  //one week
end;

procedure TfFrameBatcodeRecord.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;                        
end;

function TfFrameBatcodeRecord.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
  Result := 'Select * From ' + sTable_BatRecord;

  if nWhere = '' then
  begin
    nStr := '(R_FirstDate>=''%s'' and R_FirstDate<''%s'')';
    nStr := Format(nStr, [Date2Str(FStart), Date2Str(FEnd + 1)]);
    Result := Result + ' Where ' + nStr;
  end else
  begin
    Result := Result + ' Where (' + nWhere + ')';
  end;
end;

//Desc: ��ѯ
procedure TfFrameBatcodeRecord.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCode then
  begin
    EditCode.Text := Trim(EditCode.Text);
    if EditCode.Text = '' then Exit;

    FWhere := Format('R_Batcode Like ''%%%s%%''', [EditCode.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: ����ɸѡ
procedure TfFrameBatcodeRecord.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: ��ȡnRow��nField�ֶε�����
function TfFrameBatcodeRecord.GetVal(const nRow: Integer;
 const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.DataController.GetValue(
            cxView1.Controller.SelectedRows[nRow].RecordIndex,
            cxView1.GetColumnByFieldName(nField).Index);
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

//Desc: ������ӡ
procedure TfFrameBatcodeRecord.BtnAddClick(Sender: TObject);
var nStr: string;
    nIdx,nLen: Integer;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ��ӡ�ļ�¼', sHint); Exit;
  end;

  nStr := '';
  nLen := cxView1.DataController.GetSelectedCount - 1;

  for nIdx:=0 to nLen do
  begin
    if nIdx = nLen then
         nStr := nStr + '''' + GetVal(nIdx, 'R_Batcode') + ''''
    else nStr := nStr + '''' + GetVal(nIdx, 'R_Batcode') + ''','
  end;

  //PrintBillHD(nStr, False);
  //��ӡ�ص�
end;

procedure TfFrameBatcodeRecord.N1Click(Sender: TObject);
var nId, nStr, nCode, nKu: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nId  := SQLQuery.FieldByName('R_ID').AsString;
    nCode:= SQLQuery.FieldByName('R_BatCode').AsString;

    if not ShowInputBox('�������λ��:', '�޸�', nKu, 20) then Exit;

    nStr := 'UPDate %s Set R_KuWei=''%s'' Where R_ID=''%s''';
    nStr := Format(nStr, [sTable_BatRecord, nKu, nId]);

    FDM.ExecuteSQL(nStr);

    nStr:= Format(' %s  �������� %s ��λ��Ϊ %s ', [gSysParam.FUserName, nCode, nKu]);
    FDM.WriteSysLog(sFlag_BillItem, '', nStr, False);
    ShowMsg('�����ɹ�', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameBatcodeRecord, TfFrameBatcodeRecord.FrameID);
end.
