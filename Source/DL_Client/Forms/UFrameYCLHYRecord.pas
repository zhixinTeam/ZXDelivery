{*******************************************************************************
  ����: dmzn@163.com 2009-7-22
  ����: �����¼
*******************************************************************************}
unit UFrameYCLHYRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, UFrameNormal,
  Menus, UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameYCLHYRecord = class(TfFrameNormal)
    EditStock: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxView1DblClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    FStart,FEnd: TDate;
    //ʱ������
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //��ʼ������
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, USysFun, USysConst, USysGrid, USysDB, UMgrControl,
  UFormDateFilter, UFormYCLHYRecord;

class function TfFrameYCLHYRecord.FrameID: integer;
begin
  Result := cFI_FrameYCLStockRecord;
end;

procedure TfFrameYCLHYRecord.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameYCLHYRecord.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameYCLHYRecord.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select sr.*,P_Stock From $SR sr' +
            ' Left Join $SP sp On sp.P_ID=sr.R_PID ';

  if nWhere = '' then
       Result := Result + 'Where (R_Date>=''$Start'' and R_Date<''$End'')'
  else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$SR', sTable_YCLRecord),
            MI('$SP', sTable_YCLParam), MI('$Start', DateTime2Str(FStart)),
            MI('$End', DateTime2Str(FEnd + 1))]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: ���
procedure TfFrameYCLHYRecord.BtnAddClick(Sender: TObject);
begin
  if ShowStockRecordAddForm then InitFormData('');
end;

//Desc: �༭
procedure TfFrameYCLHYRecord.BtnEditClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ�༭�ļ�¼', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('R_ID').AsString;
  if ShowStockRecordEditForm(nStr) then InitFormData(FWhere);
end;

//Desc: ɾ��
procedure TfFrameYCLHYRecord.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫɾ���ļ�¼', sHint); Exit;
  end;

  if not QueryDlg('ȷ��Ҫɾ�����Ϊ[ ' + nStr + ' ]�ļ����¼��', sAsk) then Exit;
  nStr := SQLQuery.FieldByName('R_ID').AsString;
  nSQL := 'Delete From %s Where R_ID=%s';
  nSQL := Format(nSQL, [sTable_YCLRecord, nStr]);

  FDM.ExecuteSQL(nSQL);
  InitFormData(FWhere);
  ShowMsg('��¼�ѳɹ�ɾ��', sHint);
end;

//Desc: ����ɸѡ
procedure TfFrameYCLHYRecord.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: ��ѯ
procedure TfFrameYCLHYRecord.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'R_SerialNo like ''%%' + EditID.Text + '%%''';
    InitFormData(FWhere);
  end else

  if Sender = EditStock then
  begin
    EditStock.Text := Trim(EditStock.Text);
    if EditStock.Text = '' then Exit;

    FWhere := 'P_Stock like ''%%' + EditStock.Text + '%%''';
    InitFormData(FWhere);
  end else
end;

//Desc: �鿴
procedure TfFrameYCLHYRecord.cxView1DblClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('R_ID').AsString;
    ShowStockRecordViewForm(nStr);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameYCLHYRecord, TfFrameYCLHYRecord.FrameID);
end.
