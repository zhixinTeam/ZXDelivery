unit UFormEditBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxLCPainter, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxLabel, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMemo;

type
  TfFormEditBill = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    Edt_NCOrder: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    edt_PValue: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    edt_MValue: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item5: TdxLayoutItem;
    edt_StockName: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    edt_StockNo: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    edt_CusName: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    edt_CusId: TcxTextEdit;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item4: TdxLayoutItem;
    edt_Truck: TcxTextEdit;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Item11: TdxLayoutItem;
    edt_YunFei: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    edt_Price: TcxTextEdit;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Item14: TdxLayoutItem;
    edt_Bill: TcxTextEdit;
    dxLayout1Group6: TdxLayoutGroup;
    procedure EditCustomerPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure edt_YunFeiEditing(Sender: TObject; var CanEdit: Boolean);
  private
    { Private declarations }
    FZKPK, FPKDtl, FOldOrder, FNewOrder: string;
    FEdit:Boolean;
  private
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function  LoadBill(nId:string):Boolean;
    function  LoadZhiKaInfo(nZID,nMID:string):Boolean;
  public
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormEditBill: TfFormEditBill;

implementation

{$R *.dfm}
uses
  ULibFun, DB, IniFiles, UMgrControl, UAdjustForm, UFormBase, UBusinessPacker,
  UDataModule, USysPopedom, USysBusiness, USysDB, USysGrid, USysConst, NativeXml,
  UFormCtrl, UFormWait;


function GetLeftStr(SubStr, Str: string): string;
begin
   Result := Copy(Str, 1, Pos(SubStr, Str) - 1);
end;

function GetRightStr(SubStr, Str: string): string;
var
   i: integer;
begin
   i := pos(SubStr, Str);
   if i > 0 then
     Result := Copy(Str
       , i + Length(SubStr)
       , Length(Str) - i - Length(SubStr) + 1)
   else
     Result := '';
end;

class function TfFormEditBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nBool: Boolean;
    nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then                
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;

  with TfFormEditBill.Create(Application) do
  try
    FZKPK:= ''; FPKDtl:= '';  FEdit:= False;

    if nP.FParamB='Edit' then
    begin
      FEdit:= True;
      dxLayout1Item3.Visible:= False;
    end
    else
    begin
      dxLayout1Item6.Visible:= False;
      dxLayout1Item9.Visible:= False;
    end;

    LoadBill(nP.FParamA);

    ShowModal;
    nP.FParamA:= ModalResult;
  finally
    Free;
  end;
end;

class function TfFormEditBill.FormID: integer;
begin
  Result := cFI_FormEditBill;
end;

procedure TfFormEditBill.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(Name, 'FQLabel', '');
    if nStr <> '' then
      dxLayout1Item5.Caption := nStr;
    //xxxxx

  finally
    nIni.Free;
  end;
end;

procedure TfFormEditBill.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ReleaseCtrlData(Self);
end;

function TfFormEditBill.LoadBill(nId:string):Boolean;
var nStr : string;
begin
  nStr := ' Select * From S_Bill Where L_id='''+nId+''' ';
  //信息
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      Edt_NCOrder.Text  := FieldByName('L_ZhiKa').AsString;
      edt_Bill.Text     := FieldByName('L_ID').AsString;
      edt_CusId.Text    := FieldByName('L_CusID').AsString;
      edt_CusName.Text  := FieldByName('L_CusName').AsString;

      edt_StockNo.Text  := FieldByName('L_StockNo').AsString;
      edt_StockName.Text:= FieldByName('L_StockName').AsString;
      edt_Price.Text    := FieldByName('L_Price').AsString;
      //edt_YunFei.Text   := FieldByName('L_YunFei').AsString;

      edt_Truck.Text   := FieldByName('L_Truck').AsString;
      edt_PValue.Text   := FieldByName('L_PValue').AsString;
      edt_MValue.Text   := FieldByName('L_MValue').AsString;
    end;
  end;

  FOldOrder:= Format('%s %s %s %s 皮重 %s 毛重 %s ', [Edt_NCOrder.Text, edt_Truck.Text,
        edt_CusId.Text, edt_CusName.Text, edt_PValue.Text, edt_MValue.Text]);
end;

function TfFormEditBill.LoadZhiKaInfo(nZID,nMID:string):Boolean;
var nStr : string;
begin
  nStr := ' Select * From S_Zhika Left Join S_ZhikaDtl On Z_ID=D_ZID '+
          'Left Join S_Customer On Z_Customer=C_ID '+
          'Where Z_ID='''+nZID+''' And D_StockNo='''+nMID+''' ';
  //信息
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      Edt_NCOrder.Text  := FieldByName('Z_ID').AsString;
      edt_CusId.Text    := FieldByName('C_ID').AsString;
      edt_CusName.Text  := FieldByName('C_Name').AsString;

      edt_StockNo.Text  := FieldByName('D_StockNo').AsString;
      edt_StockName.Text:= FieldByName('D_StockName').AsString;
      edt_Price.Text    := FieldByName('D_Price').AsString;
      edt_YunFei.Text   := FieldByName('D_YunFei').AsString;

    end;
  end;
end;

procedure TfFormEditBill.EditCustomerPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: PFormCommandParam;
begin
  try
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);

    CreateBaseFormItem(cFI_FormGetEditZhika, '', nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then
      Exit;

    LoadZhiKaInfo(nP.FParamB, nP.FParamC);
  finally
    Dispose(nP);
  end;
end;

function GetBillDtlInfo(nId : string): string;
var nList : TStrings;
begin
  Result:= '';
  nList:= TStringList.Create;
  try
    //***********
    nList.Values['Proc'] := 'delete';
    nList.Values['ID'] := nId;

    Result:= EncodeBase64(nList.Text);
  finally
    nList.Free;
  end;
end;

procedure TfFormEditBill.BtnOKClick(Sender: TObject);
var nSQL, nStr, nMsg, nData, nS, nY: string;
    nVal : Double;
begin
  if FEdit then
  begin
    nVal := StrToFloatDef(edt_MValue.Text, 0)-StrToFloatDef(edt_PValue.Text, 0);
    IF nVal<0 then
    begin
      ShowMsg('操作失败：请检查毛重、皮重是否正确', sError);
      Exit;
    end;
  end;

  FDM.ADOConn.BeginTrans;
  try
    if FEdit then
    begin
      nSQL := 'UPDate S_Bill Set L_ZhiKa=''%s'', L_StockNo=''%s'', L_StockName=''%s'', L_Price=%s,'+
                                ' L_PValue=%g, L_MValue=%g, L_Truck=''%s'' '+
              'Where L_ID=''%s'' ';

      nSQL := Format(nSQL, [Edt_NCOrder.Text, edt_StockNo.Text, edt_StockName.Text, edt_Price.Text,
                            StrToFloatDef(edt_PValue.Text, 0), StrToFloatDef(edt_MValue.Text, 0), edt_Truck.Text,
                            edt_Bill.Text]);
      FDM.ExecuteSQL(nSQL);

      nSQL := 'UPDate S_Bill Set L_Value=L_MValue-L_PValue Where ' +GetRightStr('Where',nSQL);
      FDM.ExecuteSQL(nSQL);
    end
    else
    begin
      nSQL := 'UPDate S_Bill Set L_ZhiKa=''%s'', L_StockNo=''%s'', L_StockName=''%s'', L_Price=%s, '+
                                ' L_CusId=''%s'', L_CusName=''%s'', L_Truck=''%s'' '+
              'Where L_ID=''%s'' ';

      nSQL := Format(nSQL, [Edt_NCOrder.Text, edt_StockNo.Text, edt_StockName.Text, edt_Price.Text,
                            edt_CusId.Text, edt_CusName.Text, edt_Truck.Text, edt_Bill.Text]);

      FDM.ExecuteSQL(nSQL);
    end;

    nSQL := MakeSQLByStr([SF('P_CusID', edt_CusId.Text),
                          SF('P_CusName', edt_CusName.Text),
                          SF('P_MID', edt_StockNo.Text),
                          SF('P_MName', edt_StockName.Text),
                          SF('P_Truck', edt_Truck.Text),
                          SF('P_PValue', StrToFloatDef(edt_PValue.Text, 0), sfVal),
                          SF('P_MValue', StrToFloatDef(edt_MValue.Text, 0), sfVal)
                          ], sTable_PoundLog, SF('P_Bill', edt_Bill.Text), False);
    FDM.ExecuteSQL(nSQL);
    //更新磅单

    FNewOrder:= Format('%s %s %s %s 皮重 %s 毛重 %s ', [Edt_NCOrder.Text, edt_Truck.Text,
                          edt_CusId.Text, edt_CusName.Text, edt_PValue.Text, edt_MValue.Text]);
    nStr:= Format(' %s 修改销售单 调整前[ %s ] 调整后[ %s ]',
                  [gSysParam.FUserName, FOldOrder, FNewOrder]);
    FDM.WriteSysLog(sFlag_BillItem, '', nStr, False);


    //校正出金
    nStr := ' UPDate Sys_CustomerAccount set A_OutMoney = L_Money From( ' +
                  ' Select Sum(L_Money) L_Money, L_CusID from ( ' +
                  ' select isnull(L_Value,0) * isnull(L_Price,0) as L_Money, L_CusID from S_Bill ' +
                  ' where L_OutFact Is not Null ) t Group by L_CusID) b where A_CID = b.L_CusID ';
    FDM.ExecuteSQL(nStr);

    //校正冻结资金
    nStr := ' UPDate Sys_CustomerAccount set A_FreezeMoney = L_Money From( ' +
                  ' Select Sum(L_Money) L_Money, L_CusID from ( ' +
                  ' select isnull(L_Value,0) * isnull(L_Price,0) as L_Money, L_CusID from S_Bill ' +
                  ' where L_OutFact Is  Null ) t Group by L_CusID) b where A_CID = b.L_CusID ';
    FDM.ExecuteSQL(nStr);

    //校正冻结资金
    nStr := ' UPDate Sys_CustomerAccount Set A_FreezeMoney = 0 ' +
            ' Where A_CID  not in (select L_CusID from S_Bill Where L_OutFact Is Null Group by L_CusID ) ';
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('修改成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('修改失败', '未知原因');
  end;
end;

procedure TfFormEditBill.edt_YunFeiEditing(Sender: TObject;
  var CanEdit: Boolean);
begin
  if Trim(edt_YunFei.Text)='' then
    edt_YunFei.Text:= '0';
end;

initialization
  gControlManager.RegCtrl(TfFormEditBill, TfFormEditBill.FormID);

end.
