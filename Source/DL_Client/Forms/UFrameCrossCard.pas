{*******************************************************************************
  ����: juner11212436@163.com 2019-09-02
  ����: ͨ�п���ѯ
*******************************************************************************}
unit UFrameCrossCard;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, dxLayoutControl, cxMaskEdit, cxButtonEdit, cxTextEdit,
  ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, Menus;

type
  TfFrameCrossCard = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule,
  UFormBase, USysBusiness, UFormCtrl;

class function TfFrameCrossCard.FrameID: integer;
begin
  Result := cFI_FrameCrossCard;
end;

function TfFrameCrossCard.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Card;
  Result := Result + ' Where (C_TruckNo is not Null or C_TruckNo <> '''')';
  Result := Result + ' Order By C_Date';
end;

//Desc: ���
procedure TfFrameCrossCard.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormCrossCard, '', @nP);

  InitFormData('');
end;

//Desc: �޸�
procedure TfFrameCrossCard.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('C_TruckNo').AsString;
    CreateBaseFormItem(cFI_FormCrossCard, '', @nP);

    InitFormData(FWhere);
  end;
end;

//Desc: ɾ��
procedure TfFrameCrossCard.BtnDelClick(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    ShowMsg('��֧��ɾ��', sHint);
  end;
end;

//Desc: ��ѯ
procedure TfFrameCrossCard.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'C_TruckNo like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameCrossCard.N1Click(Sender: TObject);
var nStr,nTruck,nCard: string;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nTruck := SQLQuery.FieldByName('C_TruckNo').AsString;
    nCard  := SQLQuery.FieldByName('C_Card').AsString;

    nStr := 'ȷ��Ҫע������[ %s ]�Ĵſ�[ %s ]��?';
    nStr := Format(nStr, [nTruck, nCard]);

    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Update %s Set C_TruckNo='''',C_Status=''%s'',C_Freeze=''%s'',' +
            'c_used=''%s'' Where C_TruckNo=''%s''';
    nStr := Format(nStr, [sTable_Card, sFlag_CardIdle, sFlag_No, sFlag_No, nTruck]);
    FDM.ExecuteSQL(nStr);

    InitFormData(FWhere);
    ShowMsg('ע���ɹ�', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameCrossCard, TfFrameCrossCard.FrameID);
end.
