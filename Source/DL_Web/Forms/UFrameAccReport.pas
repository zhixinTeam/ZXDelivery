unit UFrameAccReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFrameBase, Data.DB, Datasnap.DBClient,
  uniGUIClasses, uniBasicGrid, uniDBGrid, uniPanel, uniToolBar,
  uniGUIBaseClasses, uniLabel, uniEdit, uniButton, uniBitBtn, uniMultiItem,
  uniComboBox, System.IniFiles, Data.Win.ADODB;

type
  TfFrameAccReport = class(TfFrameBase)
    BtnDateFilter: TUniBitBtn;
    EditDate: TUniEdit;
    Label3: TUniLabel;
    editType: TUniComboBox;
    UniLabel1: TUniLabel;
    UniButton1: TUniButton;
    procedure BtnDateFilterClick(Sender: TObject);
    procedure UniButton1Click(Sender: TObject);
  private
    { Private declarations }
    FStart,FEnd: TDate;
    {*时间区间*}
    procedure OnDateFilter(const nStart,nEnd: TDate);
    //日期筛选
  public
    { Public declarations }
    procedure OnCreateFrame(const nIni: TIniFile); override;
    procedure OnDestroyFrame(const nIni: TIniFile); override;
  end;

var
  fFrameAccReport: TfFrameAccReport;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, ULibFun, USysDB, USysConst,
  UManagerGroup, UFormDateFilter, USysBusiness;

procedure TfFrameAccReport.BtnDateFilterClick(Sender: TObject);
begin
  ShowDateFilterForm(FStart, FEnd, OnDateFilter);
end;

procedure TfFrameAccReport.OnCreateFrame(const nIni: TIniFile);
var nY,nM,nD: Word;
begin
  inherited;
  InitDateRange(ClassName, FStart, FEnd);

  if FStart = FEnd then
  begin
    DecodeDate(Date(), nY, nM, nD);
    FStart := EncodeDate(nY, nM, 1);

    if nM < 12 then
         FEnd := EncodeDate(nY, nM+1, 1) - 1
    else FEnd := EncodeDate(nY+1, 1, 1) - 1;
  end;
end;

procedure TfFrameAccReport.OnDateFilter(const nStart, nEnd: TDate);
begin
  FStart := nStart;
  FEnd := nEnd;
  InitFormData(FWhere);
end;

procedure TfFrameAccReport.OnDestroyFrame(const nIni: TIniFile);
begin
  SaveDateRange(ClassName, FStart, FEnd);
  inherited;
end;


procedure TfFrameAccReport.UniButton1Click(Sender: TObject);
var
  nStr, nSQL:string;
  //nDayStart, nDayEnd, nIdx: Integer;
  //nStart, nEnd, nDay : string;
  nQuery: TADOQuery;
  nList: TStrings;
begin
  with TDateTimeHelper do
    EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  nQuery := nil;
  nList := nil;
  with TDateTimeHelper do
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;

    nQuery := LockDBQuery(FDBType);

    nSQL := 'select * from %s where D_Name=''%s''';
    nSQL := Format(nSQL,[sTable_SysDict,sFlag_StockItem]);
    with DBQuery(nStr, nQuery) do
    begin
      First;
      nStr := '';
      while not Eof do
      begin
        nStr := nStr +
            'CONVERT(Decimal(15,2), 0) C_'+fieldbyname('D_ParamB').AsString+
            'Num,CONVERT(Decimal(15,2), 0) C_'+fieldbyname('D_ParamB').AsString+
            'Price,CONVERT(Decimal(15,2), 0) C_'+fieldbyname('D_ParamB').AsString+
            'Money,';
        Next;
      end;
    end;

    //生成表结构
    nSQL := 'Select A_CID as C_ID, C_Name,CONVERT(Decimal(15,2), A_InitMoney) as C_Init,'+
          nStr + 'CONVERT(Decimal(15,2), 0) C_Num,CONVERT(Decimal(15,2), 0) C_Money,'+
          'CONVERT(Decimal(15,2), 0) C_Xj,CONVERT(Decimal(15,2), 0) C_Yh,'+
          'CONVERT(Decimal(15,2), 0) C_Cd,CONVERT(Decimal(15,2), 0) C_Zz,'+
          'CONVERT(Decimal(15,2), 0) C_Hj,CONVERT(Decimal(15,2), 0) C_Ysk,'+
          'CONVERT(Decimal(15,2), 0) C_Sk,CONVERT(Decimal(15,2), 0) C_Total'+
          ' into #qichu From Sys_CustomerAccount,S_Customer '+
          ' where A_CID=C_ID ' ;

    //客户类型
    if editType.ItemIndex = 1 then
      nSQL := nSQL + ' and C_Type=''A'''
    else if editType.ItemIndex = 2 then
      nSQL := nSQL + ' and C_Type=''B''';

    nStr := 'if object_id(''tempdb..#qichu'') is not null begin Drop Table #qichu end';
    nList.Add(nStr);

    nList.Add(nSQL);

    nSQL := 'UPDate #qichu Set C_Init=C_Init+CusInMoney From ( '+
            ' Select M_CusID, IsNull(Sum(M_Money), 0) CusInMoney '+
            ' From Sys_CustomerInOutMoney Where M_Date<''%s'' Group by M_CusID'+
            ' ) a Where M_CusID=C_ID ';
    nSQL := Format(nSQL,[Date2Str(FStart)]);
    nList.Add(nSQL);

    //计算C_Init, 减去出金
    nSQL := 'UPDate #qichu Set C_Init=C_Init- L_Money From ('+
            ' Select L_CusID, IsNull(Sum(L_Price*L_Value), 0) L_Money '+
            ' From S_Bill Where L_OutFact<''%s''  Group  by L_CusID '+
            ' ) a  Where L_CusID=C_ID ';
    nSQL := Format(nSQL,[Date2Str(FStart)]);
    nList.Add(nSQL);

    //更新C_Hj收款小计
    nSQL := 'UPDate #qichu Set C_Hj=CusInMoney From ('+
            ' Select M_CusID, IsNull(Sum(M_Money), 0) CusInMoney '+
            ' From Sys_CustomerInOutMoney  Where M_Date>=''%s'' And M_Date<''%s'''+
            ' Group by M_CusID ) a Where M_CusID=C_ID ';
    nSQL := Format(nSQL, [Date2Str(FStart), Date2Str(FEnd + 1)]);
    nList.Add(nSQL);

    //更新C_Xj 现金收款
    nSQL := 'UPDate #qichu Set C_XJ=CusInMoney From ('+
            ' Select M_CusID, IsNull(Sum(M_Money), 0) CusInMoney,M_Payment '+
            ' From Sys_CustomerInOutMoney  Where M_Date>=''%s'' And M_Date<''%s'''+
            ' Group by M_CusID, M_Payment)a Where M_CusID=C_ID And M_Payment=''%s''';
    nSQL := Format(nSQL, [Date2Str(FStart), Date2Str(FEnd + 1), '现金']);
    nList.Add(nSQL);

    //更新C_Yh 银行存款
    nSQL := 'UPDate #qichu Set C_Yh=CusInMoney From ('+
            ' Select M_CusID, IsNull(Sum(M_Money), 0) CusInMoney,M_Payment '+
            ' From Sys_CustomerInOutMoney  Where M_Date>=''%s'' And M_Date<''%s'''+
            ' Group by M_CusID, M_Payment)a Where M_CusID=C_ID And M_Payment=''%s''';
    nSQL := Format(nSQL, [Date2Str(FStart), Date2Str(FEnd + 1), '银行存款']);
    nList.Add(nSQL);

    //更新C_Cd 承兑汇票收款
    nSQL := 'UPDate #qichu Set C_Cd=CusInMoney From ('+
            ' Select M_CusID, IsNull(Sum(M_Money), 0) CusInMoney,M_Payment '+
            ' From Sys_CustomerInOutMoney  Where M_Date>=''%s'' And M_Date<''%s'''+
            ' Group by M_CusID, M_Payment)a Where M_CusID=C_ID And M_Payment=''%s''';
    nSQL := Format(nSQL, [Date2Str(FStart), Date2Str(FEnd + 1), '承兑汇票']);
    nList.Add(nSQL);

    //更新C_Zz 转账
    nSQL := 'UPDate #qichu Set C_Zz=CusInMoney From ('+
            ' Select M_CusID, IsNull(Sum(M_Money), 0) CusInMoney,M_Payment '+
            ' From Sys_CustomerInOutMoney  Where M_Date>=''%s'' And M_Date<''%s'''+
            ' Group by M_CusID, M_Payment)a Where M_CusID=C_ID And M_Payment=''%s''';
    nSQL := Format(nSQL, [Date2Str(FStart), Date2Str(FEnd + 1), '转账']);
    nList.Add(nSQL);

    //更新各品种销量和总价
    nSQL := 'select * from %s where D_Name=''%s''';
    nSQL := Format(nSQL,[sTable_SysDict,sFlag_StockItem]);
    with DBQuery(nStr, nQuery) do
    begin
      First;
      while not Eof do
      begin
        //更新销量和总价
        nSQL := 'UPDate #qichu Set C_%sNum=CNum,C_%sMoney=CMoney From ('+
                ' Select L_CusID, IsNull(Sum(L_Value), 0) CNum, IsNull(Sum(L_Price*L_Value), 0) cmoney '+
                ' From S_Bill Where L_OutFact>=''%s'' and L_OutFact<''%s'' and L_StockNo=''%s'''+
                ' Group  by L_CusID ) a  Where L_CusID=C_ID ';
        nSQL := Format(nSQL,[FieldByName('D_ParamB').AsString,
                            FieldByName('D_ParamB').AsString,
                            Date2Str(FStart), Date2Str(FEnd + 1),
                            FieldByName('D_ParamB').AsString]);
        nList.Add(nSQL);

        //更新均价,总销量,总价
        nSQL := 'UPDate #qichu Set C_%sPrice=C_%sMoney / C_%sNum,'+
                'C_Num=C_Num+C_%sNum, C_Money=C_Money+C_%sMoney where C_%sNum<>0';
        nSQL := Format(nSQL,[FieldByName('D_ParamB').AsString,
                            FieldByName('D_ParamB').AsString,
                            FieldByName('D_ParamB').AsString,
                            FieldByName('D_ParamB').AsString,
                            FieldByName('D_ParamB').AsString,
                            FieldByName('D_ParamB').AsString]);
        nList.Add(nSQL);

        Next;
      end;
    end;

    DBExecute(nList, nQuery);
    //生成报表

    nSQL := 'Select * From #qichu order by c_id';
    DBQuery(nStr, nQuery, ClientDS);

    nSQL := 'Drop Table #qichu';
    DBExecute(nStr, nQuery);
  finally
    ReleaseDBQuery(nQuery);
    ClientDS.EnableControls;
  end;
end;

initialization
  RegisterClass(TfFrameAccReport);

end.
