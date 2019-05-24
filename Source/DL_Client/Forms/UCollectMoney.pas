unit UCollectMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, dxLayoutControl, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxLayoutcxEditAdapters, cxDropDownEdit, cxTextEdit,
  cxMaskEdit, cxButtonEdit;

type
  TfFrameCollectMoney = class(TfFrameNormal)
    editDate: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    editType: TcxComboBox;
    dxLayout1Item2: TdxLayoutItem;
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //ʱ������
    FUseDate: Boolean;
    //ʹ������
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFrameCollectMoney: TfFrameCollectMoney;

implementation

{$R *.dfm}

uses
  USysConst, UMgrControl, UFormDateFilter, USysDB, ULibFun, UDataModule;

class function TfFrameCollectMoney.FrameID: integer;
begin
  Result := cFI_FrameCollectMoney;
end;

function TfFrameCollectMoney.InitFormDataSQL(const nWhere: string): string;
var
  nStr, nTypeStr: string;
begin
  FEnableBackDB := True;
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
  if editType.ItemIndex = 0 then
    nTypeStr := ''
  else if editType.ItemIndex = 1 then
    nTypeStr := 'and b.C_Type=''A'''
  else if editType.ItemIndex = 2 then
    nTypeStr := 'and b.C_Type=''B''';

  nStr := 'Select M_CusID, M_CusName, SUM(Xj) Xj, SUM(Yh) Yh, SUM(Cd) Cd,'+
          ' SUM(Zz) Zz, SUM(Xj+Yh+Cd+Zz) Hj From ( '+
          ' Select M_CusID, M_CusName,'+
          ' Case When M_Payment=''�ֽ�'' then M_Money else 0.00 End Xj,'+
          ' Case When M_Payment=''���д��'' then M_Money else 0.00 End Yh,'+
          ' Case When M_Payment=''�жһ�Ʊ'' then M_Money else 0.00 End Cd,'+
          ' Case When M_Payment=''ת��'' then M_Money else 0.00 End Zz '+
          ' From Sys_CustomerInOutMoney a,S_Customer b '+
          ' Where a.M_CusID=b.C_ID '+ nTypeStr +
          ' and M_Date>=''%s'' And M_Date<''%s'' ) x '+
          ' Group by M_CusID, M_CusName '+
          ' Order by M_CusID ';
  Result := Format(nStr, [Date2Str(FStart), Date2Str(FEnd + 1)]);
end;

procedure TfFrameCollectMoney.cxButtonEdit1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFrameCollectMoney.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameCollectMoney.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

initialization
  gControlManager.RegCtrl(TfFrameCollectMoney, TfFrameCollectMoney.FrameID);
end.
