unit UFrameSaleAndMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, dxLayoutControl, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxLayoutcxEditAdapters, StdCtrls, cxButtonEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit;

type
  TfFrameDaySalesHj = class(TfFrameNormal)
    editType: TcxComboBox;
    dxLayout1Item1: TdxLayoutItem;
    editDate: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    Button1: TButton;
    dxLayout1Item3: TdxLayoutItem;
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //ʱ������
    FUseDate: Boolean;
    //ʹ������
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFrameDaySalesHj: TfFrameDaySalesHj;

implementation

{$R *.dfm}

uses
  USysConst, UMgrControl, UFormDateFilter, USysDB, ULibFun, UDataModule;

class function TfFrameDaySalesHj.FrameID: integer;
begin
  Result := cFI_FrameSaleAndMoney;
end;

procedure TfFrameDaySalesHj.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

procedure TfFrameDaySalesHj.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameDaySalesHj.cxButtonEdit1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then
    EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

procedure TfFrameDaySalesHj.Button1Click(Sender: TObject);
var
  nStr, nSQL:string;
  nDayStart, nDayEnd, nIdx: Integer;
  nStart, nEnd, nDay : string;
begin
  nStr := '�ò���������Ҫһ��ʱ��,�����ĵȺ�.' + #13#10 +
          'Ҫ������?';
  if not QueryDlg(nStr, sAsk) then Exit;

  FEnableBackDB := true;
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
  if FormatDateTime('YYYYMM',FStart) <> FormatDateTime('YYYYMM',FEnd) then
  begin
    ShowMessage('��ѡ����ͬ�·ݽ���ͳ��.');
    editDate.SetFocus;
    exit;
  end;

  nSQL := 'select * from %s where D_Name=''%s''';
  nSQL := Format(nSQL,[sTable_SysDict,sFlag_StockItem]);
  with FDM.QueryTemp(nSQL) do
  begin
    First;
    nStr := '';
    while not Eof do
    begin
      nStr := nStr +
          'C_'+fieldbyname('D_ParamB').AsString+' Decimal(15,2) Default 0,';
      Next;
    end;
  end;
  FDM.ADOConn.BeginTrans;
  try
    //���ɱ�ṹ
    nSQL := 'create table #SaleAndMoney (S_Date varchar(20), '+
            'C_Xj Decimal(15,2) Default 0,C_Yh Decimal(15,2) Default 0,'+
            'C_Cd Decimal(15,2) Default 0,C_Zz Decimal(15,2) Default 0,'+
            'C_Hj Decimal(15,2) Default 0,C_TotalMoney Decimal(15,2) Default 0,' +
            nStr +'C_TotalSale Decimal(15,2) Default 0)';
    FDM.ExecuteSQL(nSQL);

    nDayStart := StrToInt(FormatDateTime('dd',FStart));
    nDayEnd := StrToInt(FormatDateTime('dd',FEnd));

    //��������
    for nIdx := nDayStart to nDayEnd do
    begin
      nSQL := 'Insert into #SaleAndMoney(S_Date)values(''%s'')';
      nSQL := Format(nSQL,[IntToStr(nIdx)]);
      FDM.ExecuteSQL(nSQL);
    end;

    //�ͻ�����   
    if editType.ItemIndex = 0 then
      nStr := ''
    else if editType.ItemIndex = 1 then
      nStr := ' C_Type=''A'' and '
    else if editType.ItemIndex = 2 then
      nStr := ' C_Type=''B'' and ';

    //������ͳ��
    for nIdx := nDayStart to nDayEnd do
    begin
      nStart := FormatDateTime('yyyy-mm-',FStart)+IntToStr(nIdx);
      nEnd := FormatDateTime('yyyy-mm-',FStart)+IntToStr(nIdx+1);
      nDay := IntToStr(nIdx);
      //�ֽ�
      nSQL := 'UPDate #SaleAndMoney Set C_XJ=M_Xj from ('+
              'select sum(M_Money) M_Xj From Sys_CustomerInOutMoney ,S_Customer where M_CusID=C_ID and '+
              nStr + 'M_Payment=''%s'' and M_Date>=''%s'' and M_Date<''%s'')'+
              ' x where S_Date=''%s''';

      nSQL := Format(nSQL,['�ֽ�', nStart, nEnd, nDay]);
      FDM.ExecuteSQL(nSQL);

      //���д��
      nSQL := 'UPDate #SaleAndMoney Set C_Yh=M_Xj from ('+
              'select sum(M_Money) M_Xj From Sys_CustomerInOutMoney ,S_Customer where M_CusID=C_ID and '+
              nStr + 'M_Payment=''%s'' and M_Date>=''%s'' and M_Date<''%s'')'+
              ' x where S_Date=''%s''';

      nSQL := Format(nSQL,['���д��', nStart, nEnd, nDay]);
      FDM.ExecuteSQL(nSQL);

      //�жһ�Ʊ
      nSQL := 'UPDate #SaleAndMoney Set C_Cd=M_Xj from ('+
              'select sum(M_Money) M_Xj From Sys_CustomerInOutMoney ,S_Customer where M_CusID=C_ID and '+
              nStr + 'M_Payment=''%s'' and M_Date>=''%s'' and M_Date<''%s'')'+
              ' x where S_Date=''%s''';

      nSQL := Format(nSQL,['�жһ�Ʊ', nStart, nEnd, nDay]);
      FDM.ExecuteSQL(nSQL);

      //ת��
      nSQL := 'UPDate #SaleAndMoney Set C_Zz=M_Xj from ('+
              'select sum(M_Money) M_Xj From Sys_CustomerInOutMoney ,S_Customer where M_CusID=C_ID and '+
              nStr + 'M_Payment=''%s'' and M_Date>=''%s'' and M_Date<''%s'')'+
              ' x where S_Date=''%s''';

      nSQL := Format(nSQL,['ת��', nStart, nEnd, nDay]);
      FDM.ExecuteSQL(nSQL);

      //ѭ�����ϼ�������
      if editType.ItemIndex = 0 then
        nStr := ''
      else if editType.ItemIndex = 1 then
        nStr := ' L_CusType=''A'' and '
      else if editType.ItemIndex = 2 then
        nStr := ' L_CusType=''B'' and ';

      nSQL := 'select * from %s where D_Name=''%s''';
      nSQL := Format(nSQL,[sTable_SysDict,sFlag_StockItem]);
      with FDM.QueryTemp(nSQL) do
      begin
        First;
        while not Eof do
        begin
          nSQL := 'UPDate #SaleAndMoney Set C_%s=L_Money from ('+
                  'select SUM(L_Value*L_Price) L_Money from S_Bill where '+nStr+
                  ' L_OutFact>=''%s'' and L_OutFact<''%s'' and L_StockNo=''%s'''+
                  ') x where S_Date=''%s''';
          nSQL := Format(nSQL,[FieldByName('D_ParamB').AsString,
                  nStart, nEnd, FieldByName('D_ParamB').AsString, nDay]);
          FDM.ExecuteSQL(nSQL);

          nSQL := 'UPDate #SaleAndMoney Set C_TotalSale=C_TotalSale+'+
                  'C_%s where S_Date=''%s''';
          nSQL := Format(nSQL,[FieldByName('D_ParamB').AsString,nDay]);
          FDM.ExecuteSQL(nSQL);

          Next;
        end;
      end;

    end;
    FDM.ADOConn.CommitTrans;

    nSQL := 'Select * From #SaleAndMoney order by S_Date';
    FDM.QueryData(SQLQuery, nSQL, FEnableBackDB);

    nSQL := 'Drop Table #SaleAndMoney';
    FDM.ExecuteSQL(nSQL);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMessage('��ѯˮ��ؿ����ͳ�Ʊ���ʧ��.');
    exit;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameDaySalesHj, TfFrameDaySalesHj.FrameID);
end.
