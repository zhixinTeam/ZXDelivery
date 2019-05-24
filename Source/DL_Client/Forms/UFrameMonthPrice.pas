unit UFrameMonthPrice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, dxLayoutControl, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, StdCtrls;

type
  TfFrameMonthPrice = class(TfFrameNormal)
    Button1: TButton;
    dxLayout1Item1: TdxLayoutItem;
    Button2: TButton;
    dxLayout1Item2: TdxLayoutItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFrameMonthPrice: TfFrameMonthPrice;

implementation

{$R *.dfm}

uses
  USysConst, UMgrControl, UFormDateFilter, USysDB, ULibFun, UDataModule;

class function TfFrameMonthPrice.FrameID: integer;
begin
  Result := cFI_FrameMonthPrice;
end;

procedure TfFrameMonthPrice.Button1Click(Sender: TObject);
var
  nStr, nSQL, nDateStart, nDateEnd: string;
  nMonth, nIdx: Integer;
begin
  nStr := '�ò���������Ҫһ��ʱ��,�����ĵȺ�.' + #13#10 +
          'Ҫ������?';
  if not QueryDlg(nStr, sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr :='update %s set M_Valid=''%s'' where M_Valid<>''%s''';
    nStr := Format(nStr,[sTable_MonthPrice,sFlag_No,sFlag_No]);
    FDM.ExecuteSQL(nStr);
    //��ʷ��¼�÷�
    nStr := 'select * from %s where B_Group=''%s''';
    nStr := Format(nStr,[sTable_BaseInfo,sFlag_AreaItem]);
    with FDM.QueryTemp(nStr) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'insert into %s(M_Area, M_Man, M_Date)values(''%s'',''%s'',''%s'')';
        nSQL := Format(nSQL,[sTable_MonthPrice,FieldByName('B_Text').AsString,
                gSysParam.FUserName, DateTime2Str(Now)]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
      nSQL := 'insert into %s(M_Area, M_Man, M_Date)values(''%s'',''%s'',''%s'')';
        nSQL := Format(nSQL,[sTable_MonthPrice,'ƽ��',
                gSysParam.FUserName, DateTime2Str(Now)]);
      FDM.ExecuteSQL(nSQL);
    end;
    //���������Ϣ
    
    nMonth := StrToInt(FormatDateTime('mm',Now));
    for nIdx := 1 to nMonth do
    begin
      nDateStart := FormatDateTime('yyyy-',Now)+ IntToStr(nIdx) +'-1';
      nDateEnd := FormatDateTime('yyyy-',Now)+ IntToStr(nIdx+1) +'-1';

      nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price'+
              ' from %s where L_OutFact>=''%s'' and L_OutFact<''%s''';
      nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
      with FDM.QueryTemp(nStr) do
      begin
        nSQL := 'update %s set M_'+inttostr(nIdx)+'M=%s where M_Area=''%s'' and M_Valid=''Y''';
        nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),'ƽ��']);
        FDM.ExecuteSQL(nSQL);
      end;

      nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price, '+
              'L_Area as L_GroupItem from %s '+
              'where L_OutFact>=''%s'' and L_OutFact<''%s'' '+
              'group by L_Area';
      nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
      with FDM.QueryTemp(nStr) do
      begin
        First;
        while not Eof do
        begin
          nSQL := 'update %s set M_'+inttostr(nIdx)+'M=%s where M_Area=''%s'' and M_Valid=''Y''';
          nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),
                  FieldByName('L_GroupItem').AsString]);
          FDM.ExecuteSQL(nSQL);
          Next;
        end;
      end;
    end;

    //����ܼ�
    nDateStart := FormatDateTime('yyyy-',Now)+ '1-1';
    nDateEnd := FormatDateTime('yyyy-mm-dd',strtodate(FormatDateTime('yyyy-',(Now))+ '12-31')+1);

    nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price'+
            ' from %s where L_OutFact>=''%s'' and L_OutFact<''%s''';
    nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
    with FDM.QueryTemp(nStr) do
    begin
      nSQL := 'update %s set M_YearM=%s where M_Area=''%s'' and M_Valid=''Y''';
      nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),'ƽ��']);
      FDM.ExecuteSQL(nSQL);
    end;

    nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price, '+
            'L_Area as L_GroupItem from %s '+
            'where L_OutFact>=''%s'' and L_OutFact<''%s'' '+
            'group by L_Area';
    nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
    with FDM.QueryTemp(nStr) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'update %s set M_yearM=%s where M_Area=''%s'' and M_Valid=''Y''';
        nSQL := Format(nSQL,[sTable_MonthPrice,
                FloatToStr(FieldByName('L_Price').AsFloat),
                FieldByName('L_GroupItem').AsString]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
    end;

    FDM.ADOConn.CommitTrans;

    nSQL := 'select * from %s where M_Valid=''%s''';
    nSQL := Format(nSQL,[sTable_MonthPrice,sFlag_Yes]);

    FEnableBackDB := true;
    FDM.QueryData(SQLQuery, nSQL, FEnableBackDB);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMessage('�¾����۷���ͳ��ʧ��.');
    Exit;
  end;
end;

procedure TfFrameMonthPrice.Button2Click(Sender: TObject);
var
  nStr, nSQL, nDateStart,nDateEnd:string;
  nIdx, nMonth: Integer;
begin
  nStr := '�ò���������Ҫһ��ʱ��,�����ĵȺ�.' + #13#10 +
          'Ҫ������?';
  if not QueryDlg(nStr, sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr :='update %s set M_Valid=''%s'' where M_Valid<>''%s''';
    nStr := Format(nStr,[sTable_MonthPrice,sFlag_No,sFlag_No]);
    FDM.ExecuteSQL(nStr);
    //��ʷ��¼�÷�
    nStr := 'select * from %s where D_Name=''%s''';
    nStr := Format(nStr,[sTable_SysDict,sFlag_StockItem]);
    with FDM.QueryTemp(nStr) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'insert into %s(M_Area, M_Man, M_Date)values(''%s'',''%s'',''%s'')';
        nSQL := Format(nSQL,[sTable_MonthPrice,FieldByName('D_Value').AsString,
                gSysParam.FUserName, DateTime2Str(Now)]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;

      nSQL := 'insert into %s(M_Area, M_Man, M_Date)values(''%s'',''%s'',''%s'')';
      nSQL := Format(nSQL,[sTable_MonthPrice,'D',
                           gSysParam.FUserName, DateTime2Str(Now)]);
      FDM.ExecuteSQL(nSQL);
      nSQL := 'insert into %s(M_Area, M_Man, M_Date)values(''%s'',''%s'',''%s'')';
      nSQL := Format(nSQL,[sTable_MonthPrice,'S',
                           gSysParam.FUserName, DateTime2Str(Now)]);
      FDM.ExecuteSQL(nSQL);
      nSQL := 'insert into %s(M_Area, M_Man, M_Date)values(''%s'',''%s'',''%s'')';
      nSQL := Format(nSQL,[sTable_MonthPrice,'A',
                           gSysParam.FUserName, DateTime2Str(Now)]);
      FDM.ExecuteSQL(nSQL);
      nSQL := 'insert into %s(M_Area, M_Man, M_Date)values(''%s'',''%s'',''%s'')';
      nSQL := Format(nSQL,[sTable_MonthPrice,'B',
                           gSysParam.FUserName, DateTime2Str(Now)]);
      FDM.ExecuteSQL(nSQL);
      nSQL := 'insert into %s(M_Area, M_Man, M_Date)values(''%s'',''%s'',''%s'')';
      nSQL := Format(nSQL,[sTable_MonthPrice,'ƽ��',
                           gSysParam.FUserName, DateTime2Str(Now)]);
      FDM.ExecuteSQL(nSQL);
    end;
    //���������Ϣ

    //�����Ϻϼ�
    nMonth := StrToInt(FormatDateTime('mm',Now));
    for nIdx := 1 to nMonth do    //ѭ���¶�
    begin
      nDateStart := FormatDateTime('yyyy-',Now)+ IntToStr(nIdx) +'-1';
      nDateEnd := FormatDateTime('yyyy-',Now)+ IntToStr(nIdx+1) +'-1';

      nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price'+
              ' from %s where L_OutFact>=''%s'' and L_OutFact<''%s''';
      nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
      with FDM.QueryTemp(nStr) do
      begin
        nSQL := 'update %s set M_'+inttostr(nIdx)+'M=%s where M_Area=''%s'' and M_Valid=''Y''';
        nSQL := Format(nSQL,[sTable_Monthprice,FloatToStr(FieldByName('L_Price').AsFloat),'ƽ��']);
        FDM.ExecuteSQL(nSQL);
      end;

      //������ѭ��
      nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price, '+
              'L_StockName as L_GroupItem from %s '+
              'where L_OutFact>=''%s'' and L_OutFact<''%s'' '+
              'group by L_StockName';
      nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
      with FDM.QueryTemp(nStr) do
      begin
        First;
        while not Eof do
        begin
          nSQL := 'update %s set M_'+inttostr(nIdx)+'M=%s where M_Area=''%s'' and M_Valid=''Y''';
          nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),
                  FieldByName('L_GroupItem').AsString]);
          FDM.ExecuteSQL(nSQL);
          Next;
        end;
      end;                                

      //����װɢװѭ��
      nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price, '+
              'L_Type as L_GroupItem from %s '+
              'where L_OutFact>=''%s'' and L_OutFact<''%s'' '+
              'group by L_Type';
      nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
      with FDM.QueryTemp(nStr) do
      begin
        First;
        while not Eof do
        begin
          nSQL := 'update %s set M_'+inttostr(nIdx)+'M=%s where M_Area=''%s'' and M_Valid=''Y''';
          nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),
                  FieldByName('L_GroupItem').AsString]);
          FDM.ExecuteSQL(nSQL);
          Next;
        end;
      end;

      //��A��B��ѭ��
      nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price, '+
              'L_CusType as L_GroupItem from %s '+
              'where L_OutFact>=''%s'' and L_OutFact<''%s'' '+
              'group by L_CusType';
      nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
      with FDM.QueryTemp(nStr) do
      begin
        First;
        while not Eof do
        begin
          nSQL := 'update %s set M_'+inttostr(nIdx)+'M=%s where M_Area=''%s'' and M_Valid=''Y''';
          nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),
                  FieldByName('L_GroupItem').AsString]);
          FDM.ExecuteSQL(nSQL);
          Next;
        end;
      end;
    end;

    //����ܼ�
    nDateStart := FormatDateTime('yyyy-',Now)+ '1-1';
    nDateEnd := FormatDateTime('yyyy-mm-dd',strtodate(FormatDateTime('yyyy-',(Now))+ '12-31')+1);

    nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price'+
            ' from %s where L_OutFact>=''%s'' and L_OutFact<''%s''';
    nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
    with FDM.QueryTemp(nStr) do
    begin
      nSQL := 'update %s set M_YearM=%s where M_Area=''%s'' and M_Valid=''Y''';
      nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),'ƽ��']);
      FDM.ExecuteSQL(nSQL);
    end;

    //������ѭ��
    nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price, '+
            'L_StockName as L_GroupItem from %s '+
            'where L_OutFact>=''%s'' and L_OutFact<''%s'' '+
            'group by L_StockName';
    nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
    with FDM.QueryTemp(nStr) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'update %s set M_yearM=%s where M_Area=''%s'' and M_Valid=''Y''';
        nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),
                FieldByName('L_GroupItem').AsString]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
    end;
    //����װɢװѭ��
    nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price, '+
            'L_Type as L_GroupItem from %s '+
            'where L_OutFact>=''%s'' and L_OutFact<''%s'' '+
            'group by L_Type';
    nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
    with FDM.QueryTemp(nStr) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'update %s set M_yearM=%s where M_Area=''%s'' and M_Valid=''Y''';
        nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),
                FieldByName('L_GroupItem').AsString]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
    end;

    //��A��B��ѭ��
    nStr := 'select SUM(L_Value*(L_Price-L_Freight))/sum(L_Value) as L_Price, '+
            'L_CusType as L_GroupItem from %s '+
            'where L_OutFact>=''%s'' and L_OutFact<''%s'' '+
            'group by L_CusType';
    nStr := Format(nStr,[sTable_Bill,nDateStart,nDateEnd]);
    with FDM.QueryTemp(nStr) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'update %s set M_yearM=%s where M_Area=''%s'' and M_Valid=''Y''';
        nSQL := Format(nSQL,[sTable_MonthPrice,FloatToStr(FieldByName('L_Price').AsFloat),
                FieldByName('L_GroupItem').AsString]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
    end;

    FDM.ADOConn.CommitTrans;

    nSQL := 'select * from %s where M_Valid=''%s''';
    nSQL := Format(nSQL,[sTable_MonthPrice,sFlag_Yes]);

    FEnableBackDB := true;
    FDM.QueryData(SQLQuery, nSQL, FEnableBackDB);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMessage('�����۷���ͳ��ʧ��.');
    Exit;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameMonthPrice, TfFrameMonthPrice.FrameID);  
end.
