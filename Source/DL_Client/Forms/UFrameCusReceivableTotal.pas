unit UFrameCusReceivableTotal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels, DateUtils,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, dxSkinsdxLCPainter, cxContainer, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxDropDownEdit, cxCalendar;

type
  TfFrameCusReceivableTotal = class(TfFrameNormal)
    dxLayout1Item1: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditEnd: TcxDateEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxButtonEdit1: TcxButtonEdit;
    dxlytmLayout1Item4: TdxLayoutItem;
    EditStart: TcxDateEdit;
  private
    { Private declarations }
    FStart,FEnd: TDate;
    //时间区间
  private
    function  LoadData: string;
    procedure OnCreateFrame; override;
    function  InitFormDataSQL(const nWhere: string): string; override;
    //查询SQL
    procedure AfterInitFormData; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFrameCusReceivableTotal: TfFrameCusReceivableTotal;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormDateFilter, USysPopedom, USysBusiness,
  UBusinessConst, USysConst, USysDB, UDataModule, UFormInputbox;



procedure TfFrameCusReceivableTotal.OnCreateFrame;
begin
  inherited;

  EditStart.Date:= StartOfTheMonth(Now);
  EditEnd.Date  := EndOfTheMonth(Now);
  dxLayout1Item1.Visible:= False;
  dxLayout1Item3.Visible:= False;
end;

class function TfFrameCusReceivableTotal.FrameID: integer;
begin
  Result := cFI_FrameCusReceivableTotal;
end;

function TfFrameCusReceivableTotal.LoadData: string;
var nList: TStrings;
    nStr : string;
    nIdx : Integer;
begin
  nList := TStringList.Create;
  try
    FStart:= EditStart.Date;
    FEnd  := EditEnd.Date;

    nStr := ' if object_id(''tempdb..#qichu'') is not null begin Drop Table #qichu end  ';
    nList.Add(nStr);

    nStr := 'Select A_CID as C_ID, CONVERT(Varchar(200), '''') As C_CusName,CONVERT(Decimal(15,2), A_InitMoney) as C_Init, CONVERT(Decimal(15,2), 0) C_InMoney,  ' +
            '	CONVERT(Decimal(15,2), 0) C_SaleMoney, CONVERT(Decimal(15,2), 0) C_FLMoney, CONVERT(Decimal(15,2), 0) C_AvailableMoney ' +
            ' into #qichu From %s ';
    nStr := Format(nStr, [sTable_CusAccount]);
    nList.Add(nStr);
    // 期初

    nStr := 'UPDate #qichu Set C_Init=C_Init+CusInMoney From ( ' +
            'Select M_CusID, IsNull(Sum(M_Money), 0) CusInMoney From %s ' +
            'Where M_Date<''$ST''  ' +
            'Group  by M_CusID ) a  Where M_CusID=C_ID ';
    nStr := Format(nStr, [sTable_InOutMoney]);
    nList.Add(nStr);
    //合并入金

    nStr := 'UPDate #qichu Set C_Init=C_Init- L_Money From ( ' +
            'Select L_CusID, IsNull(Sum((L_Price)*L_Value), 0) L_Money From %s ' +
            'Where L_OutFact<''$ST''  ' +
            'Group  by L_CusID ) a  Where L_CusID=C_ID ';
    nStr := Format(nStr, [sTable_Bill]);
    nList.Add(nStr);
    //合并出金 发货金额

    nStr := 'UPDate #qichu Set C_Init=C_Init- xMoney From ( ' +
            'Select S_CusID, -1*IsNull(Sum((S_Price+IsNull(S_YunFei, 0))*S_Value), 0) xMoney From %s ' +
            'Where S_Date<''$ST''  ' +
            'Group  by S_CusID ) a  Where S_CusID=C_ID ' ;
    nStr := Format(nStr, [sTable_InvSettle]);
    nList.Add(nStr);
    //合并返还

    nStr := 'UPDate #qichu Set C_InMoney=CusInMoney From (   ' +
            'Select M_CusID, IsNull(Sum(M_Money), 0) CusInMoney From %s  ' +
            'Where M_Date>=''$ST'' And M_Date<''$ED''  ' +
            'Group  by M_CusID ) a  Where M_CusID=C_ID  ';
    nStr := Format(nStr, [sTable_InOutMoney]);
    nList.Add(nStr);
    //期初金额


    nStr := 'UPDate #qichu Set C_SaleMoney=L_Money From ( ' +
            'Select L_CusID, Sum(CONVERT(Decimal(15,2), (L_Price)*L_Value)) L_Money From %s ' +
            'Where L_OutFact>=''$ST'' And L_OutFact<''$ED''  ' +
            'Group  by L_CusID ) a  Where L_CusID=C_ID  ';
    nStr := Format(nStr, [sTable_Bill]);
    nList.Add(nStr);
    //出金记录


    nStr := 'UPDate #qichu Set C_FLMoney=xMoney From ( ' +
            'Select S_CusID, Sum((ISNULL(S_Price,0)+ISNULL(S_YunFei,0))*ISNULL(S_Value, 0)*(-1)) xMoney From %s ' +
            'Where S_Date>=''$ST'' And S_Date<''$ED'' ' +
            'Group  by S_CusID ) a  Where S_CusID=C_ID ';
    nStr := Format(nStr, [sTable_InvSettle]);
    nList.Add(nStr);
    //结算返利

    nStr := 'UPDate #qichu Set C_CusName=C_Name From S_Customer a Where a.C_ID=#qichu.C_ID';
    nList.Add(nStr);
    //******
    nStr := 'UPDate #qichu Set C_AvailableMoney=C_Init+C_InMoney-C_SaleMoney-C_FLMoney';
    nList.Add(nStr);
    //计算结余

    nList.Text := MacroValue(nList.Text, [MI('$ST', Date2Str(FStart)),
                  MI('$ED', Date2Str(FEnd + 1))]);

    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=0 to nList.Count - 1 do
        FDM.ExecuteSQL(nList[nIdx]);
      //xxxxx

      FDM.ADOConn.CommitTrans;
    except
      FDM.ADOConn.RollbackTrans;
      raise;
    end;
    //xxxxx
  finally
    nList.Free;
  end;
end;

function TfFrameCusReceivableTotal.InitFormDataSQL(const nWhere: string): string;
begin
  LoadData;
  
  Result := 'Select * From #qichu Where C_CusName<>'''' Order by c_id';
  //xxxxx
end;

procedure TfFrameCusReceivableTotal.AfterInitFormData;
var nStr:string;
begin
  nStr := 'Drop Table #qichu';
  FDM.ExecuteSQL(nStr);
end;



initialization
  gControlManager.RegCtrl(TfFrameCusReceivableTotal, TfFrameCusReceivableTotal.FrameID);


end.
