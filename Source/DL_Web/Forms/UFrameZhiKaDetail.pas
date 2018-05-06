{*******************************************************************************
  ����: dmzn@163.com 2018-05-06
  ����: ֽ��������ϸ��ѯ
*******************************************************************************}
unit UFrameZhiKaDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, System.IniFiles,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, UFrameBase, Data.DB, Datasnap.DBClient,
  uniSplitter, uniBasicGrid, uniDBGrid, uniPanel, uniToolBar, uniGUIBaseClasses,
  uniEdit, uniLabel, Vcl.Menus, uniMainMenu, uniButton, uniBitBtn;

type
  TfFrameZhiKaDetail = class(TfFrameBase)
    Label1: TUniLabel;
    EditID: TUniEdit;
    Label2: TUniLabel;
    EditCus: TUniEdit;
    PMenu1: TUniPopupMenu;
    MenuItem1: TUniMenuItem;
    MenuItem2: TUniMenuItem;
    MenuItem8: TUniMenuItem;
    MenuItem4: TUniMenuItem;
    Label3: TUniLabel;
    EditDate: TUniEdit;
    BtnDateFilter: TUniBitBtn;
    MenuItem5: TUniMenuItem;
    MenuItem6: TUniMenuItem;
    MenuItem7: TUniMenuItem;
    MenuItem3: TUniMenuItem;
    MenuItemN3: TUniMenuItem;
    MenuItem11: TUniMenuItem;
    MenuItem12: TUniMenuItem;
    MenuItemN2: TUniMenuItem;
    MenuItem9: TUniMenuItem;
    MenuItem10: TUniMenuItem;
    MenuItem13: TUniMenuItem;
    MenuItem14: TUniMenuItem;
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnDateFilterClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
  private
    { Private declarations }
    FStart,FEnd: TDate;
    {*ʱ������*}
    FDateFilte: Boolean;
    //��������
    FValidFilte: Boolean;
    //������Ч״̬
    procedure OnDateFilter(const nStart,nEnd: TDate);
    //����ɸѡ
    procedure OnFreeByStock(const nStocks: string);
    //��Ʒ�ֶ���
    procedure OnZKPrice(const nRes: Integer);
    //���۽��
    function FreezeZK(const nFreeze: Boolean): Boolean;
    //����ѡ�������
    procedure SelectedZK(const nList: TStrings);
    //��ȡѡ��ֽ����
  public
    { Public declarations }
    procedure OnCreateFrame(const nIni: TIniFile); override;
    procedure OnDestroyFrame(const nIni: TIniFile); override;
    procedure AfterInitFormData; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //�������
  end;

implementation

{$R *.dfm}
uses
  Data.Win.ADODB, uniGUIVars, MainModule, uniGUIApplication, uniGUIForm,
  ULibFun, UManagerGroup, USysBusiness, UFormBase, USysDB, USysConst,
  UFormDateFilter, UFormZhiKaFreeze, UFormZhiKaPrice;

procedure TfFrameZhiKaDetail.OnCreateFrame(const nIni: TIniFile);
begin
  inherited;
  FDateFilte := True;
  FValidFilte := True;

  with DBGridMain do
    Options := Options + [dgMultiSelect, dgCheckSelect];
  //xxxxx

  MenuItem2.Enabled := HasPopedom2(sPopedom_Edit, FPopedom);
  MenuItem3.Enabled := HasPopedom2(sPopedom_Edit, FPopedom);
  MenuItem4.Enabled := HasPopedom2(sPopedom_Edit, FPopedom);

  MenuItem6.Enabled := HasPopedom2(sPopedom_Edit, FPopedom);
  MenuItem9.Enabled := HasPopedom2(sPopedom_Edit, FPopedom);
  MenuItem10.Enabled := HasPopedom2(sPopedom_Edit, FPopedom);

  InitDateRange(ClassName, FStart, FEnd);
  //xxxxxx
end;

procedure TfFrameZhiKaDetail.OnDestroyFrame(const nIni: TIniFile);
begin
  SaveDateRange(ClassName, FStart, FEnd);
  inherited;
end;

//Desc: ����ѡ�񴰷��ؽ��
procedure TfFrameZhiKaDetail.OnDateFilter(const nStart,nEnd: TDate);
begin
  FStart := nStart;
  FEnd := nEnd;
  InitFormData(FWhere);
end;

//Desc: ��Ʒ�ֶ��᷵�ؽ��
procedure TfFrameZhiKaDetail.OnFreeByStock(const nStocks: string);
begin
  InitFormData(FWhere);
end;

//Desc: ֽ�����۽��
procedure TfFrameZhiKaDetail.OnZKPrice(const nRes: Integer);
begin
  InitFormData(FWhere);
end;

function TfFrameZhiKaDetail.InitFormDataSQL(const nWhere: string): string;
begin
  with TStringHelper,TDateTimeHelper do
  begin
    EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
    //xxxxx

    Result := 'Select sm.*,zk.*,zd.*,ht.*,zd.R_ID as D_RID,' +
              'C_PY,C_Name,D_Price-D_PPrice As D_ZDPrice From $ZK zk ' +
              ' Left Join $SM sm on sm.S_ID=zk.Z_SaleMan' +
              ' Left Join $Cus cus on cus.C_ID=zk.Z_Customer' +
              ' Left Join $ZD zd on zd.D_ZID=zk.Z_ID ' +
              ' Left join $HT ht on zk.Z_CID=ht.C_ID ';
    //xxxxx

    if nWhere = '' then
         Result := Result + ' Where (1 = 1)'
    else Result := Result + ' Where (' + nWhere + ')';

    if FValidFilte then
      Result := Result + ' and (IsNull(Z_InValid, '''')<>''$Yes''' +
                         ' and Z_ValidDays>$Now)';
    //xxxxx

    if FDateFilte then
      Result := Result + ' and (Z_Date>=''$STT'' and Z_Date<''$End'')';
    //xxxxx

    Result := MacroValue(Result, [MI('$ZK', sTable_ZhiKa), MI('$Yes', sFlag_Yes),
              MI('$ZD', sTable_ZhiKaDtl), MI('$SM', sTable_Salesman),
              MI('$Cus', sTable_Customer), MI('$Now', sField_SQLServer_Now),
              MI('$STT', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1)),
              MI('$HT', sTable_SaleContract)]);
    //xxxxx
  end;
end;

procedure TfFrameZhiKaDetail.AfterInitFormData;
begin
  FDateFilte := True;
  FValidFilte := True;
end;

//Desc: ����ɸѡ
procedure TfFrameZhiKaDetail.BtnDateFilterClick(Sender: TObject);
begin
  ShowDateFilterForm(FStart, FEnd, OnDateFilter);
end;

procedure TfFrameZhiKaDetail.EditIDKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then Exit;
  Key := #0;

  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FDateFilte := Length(EditID.Text) <= 3;
    FValidFilte := False;

    FWhere := Format('Z_ID Like ''%%%s%%''', [EditID.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := Format('C_PY Like ''%%%s%%'' or C_Name Like ''%%%s%%''',
              [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameZhiKaDetail.DBGridMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then PMenu1.Popup(X, Y, DBGridMain);
end;

//Desc: ����,�ⶳ
procedure TfFrameZhiKaDetail.MenuItem2Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: if not FreezeZK(True) then Exit;
   20: if not FreezeZK(False) then Exit;
   30: begin
         FValidFilte := False;
         FWhere := 'Z_InValid=''$Yes'' Or Z_ValidDays<=%s';
         FWhere := Format(FWhere, [sField_SQLServer_Now]);
       end;
   40: begin
         FValidFilte := False;
         FWhere := '1=1';
       end;
   50: begin
         FDateFilte := False;
         FValidFilte := False;
         FWhere := Format('Z_TJStatus=''%s''', [sFlag_TJing]);
       end else Exit;
  end;

  InitFormData(FWhere);
end;

//Desc: �������
procedure TfFrameZhiKaDetail.MenuItem9Click(Sender: TObject);
var nIdx,nLen: Integer;
    nList: TStrings;
    nStr,nRID,nFlag: string;
    nBK: TBookmark;
begin
  nLen := DBGridMain.SelectedRows.Count - 1;
  if nLen < 0 then Exit;

  nBK := nil;
  nList := nil;
  try
    if TComponent(Sender).Tag = 10 then
         nFlag := sFlag_Yes
    else nFlag := sFlag_No;

    ClientDS.DisableControls;
    nBK := ClientDS.GetBookmark; //backup
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;

    for nIdx:=DBGridMain.SelectedRows.Count - 1 downto 0 do
    begin
      ClientDS.Bookmark := DBGridMain.SelectedRows[nIdx];
      nRID := ClientDS.FieldByName('D_RID').AsString;
      if nRID = '' then Continue;

      nStr := 'Update %s Set D_TPrice=''%s'' Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZhiKaDtl, nFlag, nRID]);
      nList.Add(nStr);
    end;

    DBExecute(nList, nil, FDBType);
    //write
  finally
    gMG.FObjectPool.Release(nList);
    //xxxxx

    if Assigned(nBK) then
    begin
      if ClientDS.BookmarkValid(nBK) then
        ClientDS.GotoBookmark(nBK); //restore
      ClientDS.FreeBookmark(nBK);
    end;

    ClientDS.EnableControls;
    InitFormData(FWhere);
    //reload
  end;
end;

//Desc: ��Ʒ�ֶ���
procedure TfFrameZhiKaDetail.MenuItem4Click(Sender: TObject);
begin
  ShowZKFreezeForm(OnFreeByStock);
end;

//Desc: ��ȡѡ��ֽ���б�
procedure TfFrameZhiKaDetail.SelectedZK(const nList: TStrings);
var nIdx: Integer;
    nBK: TBookmark;
begin
  nList.Clear;
  nBK := nil;
  try
    ClientDS.DisableControls;
    nBK := ClientDS.GetBookmark;
    //backup

    for nIdx:=DBGridMain.SelectedRows.Count - 1 downto 0 do
    begin
      ClientDS.Bookmark := DBGridMain.SelectedRows[nIdx];
      nList.Add(ClientDS.FieldByName('Z_ID').AsString);
    end;
  finally
    if Assigned(nBK) then
    begin
      if ClientDS.BookmarkValid(nBK) then
        ClientDS.GotoBookmark(nBK); //restore
      ClientDS.FreeBookmark(nBK);
    end;
    ClientDS.EnableControls;
  end;
end;

//Desc: ���ᵱǰѡ�е������
function TfFrameZhiKaDetail.FreezeZK(const nFreeze: Boolean): Boolean;
var nStr: string;
    nIdx: Integer;
    nListA,nListB: TStrings;
begin
  Result := False;
  if DBGridMain.SelectedRows.Count < 1 then Exit;

  nListA := nil;
  nListB := nil;
  try
    nListA := gMG.FObjectPool.Lock(TStrings) as TStrings;
    SelectedZK(nListA);
    if nListA.Count < 1 then Exit;

    nListB := gMG.FObjectPool.Lock(TStrings) as TStrings;
    for nIdx:=nListA.Count - 1 downto 0 do
    begin
      if nFreeze then
      begin
        nStr := 'Update %s Set Z_TJStatus=''%s'' Where Z_ID=''%s'' and ' +
                'IsNull(Z_InValid,'''')<>''%s'' And Z_ValidDays>%s';
        nStr := Format(nStr, [sTable_ZhiKa, sFlag_TJing, nListA[nIdx],
                sFlag_Yes, sField_SQLServer_Now]);
        nListB.Add(nStr); //������
      end else
      begin
        nStr := 'Update %s Set Z_TJStatus=''%s'' Where Z_ID=''%s'' and ' +
                'Z_TJStatus=''%s''';
        nStr := Format(nStr, [sTable_ZhiKa, sFlag_TJOver, nListA[nIdx],
                sFlag_TJing]);
        nListB.Add(nStr); //���۽���
      end;
    end;

    DBExecute(nListB, nil, FDBType);
    Result := True;
  finally
    gMG.FObjectPool.Release(nListA);
    gMG.FObjectPool.Release(nListB);
  end;
end;

//Desc: ����
procedure TfFrameZhiKaDetail.MenuItem6Click(Sender: TObject);
var nIdx,nLen: Integer;
    nList: TStrings;
    nBK: TBookmark;
    nStr,nRID,nZID,nStock,nType: string;
begin
  nLen := DBGridMain.SelectedRows.Count - 1;
  if nLen < 0 then Exit;

  nBK := nil;
  nList := nil;
  try
    ClientDS.DisableControls;
    nBK := ClientDS.GetBookmark;
    //backup

    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nLen := DBGridMain.SelectedRows.Count - 1;

    for nIdx:= 0 to nLen do
    begin
      ClientDS.Bookmark := DBGridMain.SelectedRows[nIdx];
      nRID := ClientDS.FieldByName('D_RID').AsString;
      nZID := ClientDS.FieldByName('Z_ID').AsString;
      if (nRID = '') or (nZID = '') then Continue;

      nStr := ClientDS.FieldByName('Z_TJStatus').AsString;
      if nStr <> sFlag_TJing then
      begin
        nStr := '����ǰ��Ҫ����ֽ��,��¼[ %s ]������Ҫ��.';
        nStr := Format(nStr, [nRID]);
        ShowMessage(nStr); Exit;
      end;

      if nIdx = 0 then
      begin
        nType := ClientDS.FieldByName('D_Type').AsString;
        nStock := ClientDS.FieldByName('D_StockNO').AsString;
      end else
      begin
        if (ClientDS.FieldByName('D_Type').AsString <> nType) or
           (ClientDS.FieldByName('D_StockNO').AsString <> nStock) then
        begin
          nStr := 'ֻ��ͬƷ�ֵ�ˮ�����ͳһ����,��¼[ %s ]������Ҫ��.';
          nStr := Format(nStr, [nRID]);
          ShowMessage(nStr); Exit;
        end;
      end;

      nStr := Format('%s;%s;%s;%s;%s', [nRID,
              ClientDS.FieldByName('D_Price').AsString,
              nZID, nStock, ClientDS.FieldByName('D_StockName').AsString]);
      nList.Add(nStr);
    end;

    if nList.Count < 1 then
    begin
      ShowMessage('ѡ�м�¼��Ч'); Exit;
    end;

    ShowZKPriceForm(nList.Text, OnZKPrice);
    //ִ�е���
  finally
    gMG.FObjectPool.Release(nList);
    //xxxxx

    if Assigned(nBK) then
    begin
      if ClientDS.BookmarkValid(nBK) then
        ClientDS.GotoBookmark(nBK); //restore
      ClientDS.FreeBookmark(nBK);
    end;

    ClientDS.EnableControls;
  end;
end;

initialization
  RegisterClass(TfFrameZhiKaDetail);
end.