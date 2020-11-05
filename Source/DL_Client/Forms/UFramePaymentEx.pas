{*******************************************************************************
  ����: dmzn@163.com 2009-7-15
  ����: ���ۻؿ�
*******************************************************************************}
unit UFramePaymentEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, Menus, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxLayoutcxEditAdapters, cxGridCustomPopupMenu,
  cxGridPopupMenu;

type
  TfFramePaymentEx = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
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
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UFormBase, UFormDateFilter,
  UDataModule;

//------------------------------------------------------------------------------
class function TfFramePaymentEx.FrameID: integer;
begin
  Result := cFI_FramePaymentEx;
end;

procedure TfFramePaymentEx.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFramePaymentEx.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFramePaymentEx.InitFormDataSQL(const nWhere: string): string;
begin
  {$IFDEF EnableBackupDB} FEnableBackDB := True; {$ENDIF}
  //���ñ������ݿ�
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
  
  Result := 'Select iom.*,sm.S_Name From $IOM iom ' +
            ' Left Join $SM sm On sm.S_ID=iom.M_SaleMan ' +
            'Where M_Type=''$HK'' And isnull(M_RuZhang,''Y'') <> ''Y'' ';
            
  if nWhere = '' then
       Result := Result + 'And (M_Date>=''$Start'' And M_Date <''$End'')'
  else Result := Result + 'And (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$SM', sTable_Salesman),
            MI('$IOM', sTable_InOutMoney), MI('$HK', sFlag_MoneyHuiKuan),
            MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: �ؿ�
procedure TfFramePaymentEx.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FParamA := '';
  CreateBaseFormItem(cFI_FormKPPayment, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: �ض��ͻ��ؿ�
procedure TfFramePaymentEx.cxView1DblClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nP.FParamA := SQLQuery.FieldByName('M_CusID').AsString;
  CreateBaseFormItem(cFI_FormKPPayment, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: ֽ���ؿ�
procedure TfFramePaymentEx.BtnEditClick(Sender: TObject);
begin
  //
end;

//Desc: ����ɸѡ
procedure TfFramePaymentEx.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: ִ�в�ѯ
procedure TfFramePaymentEx.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;
    
    FWhere := '(M_CusID like ''%%%s%%'' Or M_CusName like ''%%%s%%'')';
    FWhere := Format(FWhere, [EditID.Text, EditID.Text]);
    InitFormData(FWhere);
  end else
end;

procedure TfFramePaymentEx.N1Click(Sender: TObject);
var
  nStr, nRID, nRuZhang : string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nRID     := SQLQuery.FieldByName('R_ID').AsString;
    nRuZhang := SQLQuery.FieldByName('M_RuZhang').AsString;

    nStr := 'ȷ��Ҫ����ʱ�ؿ��¼[ %s ]��������ȷ����?';
    nStr := Format(nStr, [nRID]);
    if not QueryDlg(nStr, sAsk) then Exit;

    FDM.ADOConn.BeginTrans;
    try
      nStr := ' update %s set M_RuZhang= ''%s'' where R_ID = %s ';
      nStr := Format(nStr, [sTable_InOutMoney, sFlag_Yes, nRID]);
      FDM.ExecuteSQL(nStr);

      FDM.ADOConn.CommitTrans;
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('����ȷ��ʧ��.', sHint);
      Exit;
    end;

    InitFormData(FWhere);
    ShowMsg('����ȷ�ϳɹ�', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePaymentEx, TfFramePaymentEx.FrameID);
end.
