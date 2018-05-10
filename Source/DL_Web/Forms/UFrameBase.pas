{*******************************************************************************
  作者: dmzn@163.com 2018-04-25
  描述: Frame基类
*******************************************************************************}
unit UFrameBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, MainModule, USysConst, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniToolBar, uniGUIBaseClasses, uniPanel, Data.DB,
  Data.Win.ADODB, Datasnap.DBClient, uniBasicGrid, uniDBGrid, uniSplitter,
  System.IniFiles, uniTimer, uniImage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfFrameBase = class(TUniFrame)
    PanelWork: TUniContainerPanel;
    UniToolBar1: TUniToolBar;
    BtnAdd: TUniToolButton;
    BtnEdit: TUniToolButton;
    BtnDel: TUniToolButton;
    UniToolButton4: TUniToolButton;
    BtnRefresh: TUniToolButton;
    BtnPrint: TUniToolButton;
    BtnPreview: TUniToolButton;
    BtnExport: TUniToolButton;
    UniToolButton10: TUniToolButton;
    UniToolButton11: TUniToolButton;
    BtnExit: TUniToolButton;
    PanelQuick: TUniSimplePanel;
    DBGridMain: TUniDBGrid;
    ClientDS: TClientDataSet;
    DataSource1: TDataSource;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FDBType: TAdoConnectionType;
    //数据连接
    FMenuID: string;
    FPopedom: string;
    {*权限项*}
    FWhere: string;
    {*过滤条件*}
    procedure OnCreateFrame(const nIni: TIniFile); virtual;
    procedure OnDestroyFrame(const nIni: TIniFile); virtual;
    procedure OnLoadPopedom; virtual;
    {*基类函数*}
    function FilterColumnField: string; virtual;
    procedure OnLoadGridConfig(const nIni: TIniFile); virtual;
    procedure OnSaveGridConfig(const nIni: TIniFile); virtual;
    {*表格配置*}
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); virtual;
    procedure InitFormData(const nWhere: string = '';
     const nQuery: TADOQuery = nil); virtual;
    function InitFormDataSQL(const nWhere: string): string; virtual;
    procedure AfterInitFormData; virtual;
    {*载入数据*}
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  ULibFun, USysBusiness, USysDB, uniPageControl;

procedure TfFrameBase.UniFrameCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FDBType := ctWork;
  FMenuID := GetMenuByModule(ClassName);
  FPopedom := GetPopedom(FMenuID);
  OnLoadPopedom; //加载权限

  nIni := nil;
  try
    nIni := UserConfigFile;
    //PanelQuick.Height := nIni.ReadInteger(ClassName, 'PanelQuick', 50);

    OnLoadGridConfig(nIni);
    //载入用户配置
    OnCreateFrame(nIni);
    //子类处理
  finally
    nIni.Free;
  end;

  InitFormData;
  //初始化数据
end;

procedure TfFrameBase.UniFrameDestroy(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := nil;
  try
    nIni := UserConfigFile;
    //nIni.WriteInteger(ClassName, 'PanelQuick', PanelQuick.Height);

    OnSaveGridConfig(nIni);
    //保存用户配置
    OnDestroyFrame(nIni);
    //子类处理
  finally
    nIni.Free;
  end;

  if ClientDS.Active then
    ClientDS.EmptyDataSet;
  //清空数据集
end;

procedure TfFrameBase.OnCreateFrame(const nIni: TIniFile);
begin

end;

procedure TfFrameBase.OnDestroyFrame(const nIni: TIniFile);
begin

end;

//Desc: 读取权限
procedure TfFrameBase.OnLoadPopedom;
begin
  BtnAdd.Enabled      := HasPopedom2(sPopedom_Add, FPopedom);
  BtnEdit.Enabled     := HasPopedom2(sPopedom_Edit, FPopedom);
  BtnDel.Enabled      := HasPopedom2(sPopedom_Delete, FPopedom);
  BtnPrint.Enabled    := HasPopedom2(sPopedom_Print, FPopedom);
  BtnPreview.Enabled  := HasPopedom2(sPopedom_Preview, FPopedom);
  BtnExport.Enabled   := HasPopedom2(sPopedom_Export, FPopedom);

  BuildDBGridColumn(FMenuID, DBGridMain, FilterColumnField());
  //构建表头
end;

procedure TfFrameBase.OnLoadGridConfig(const nIni: TIniFile);
begin
  UserDefineGrid(ClassName, DBGridMain, True, nIni);
end;

procedure TfFrameBase.OnSaveGridConfig(const nIni: TIniFile);
begin
  UserDefineGrid(ClassName, DBGridMain, False, nIni);
end;

//Desc: 过滤不显示
function TfFrameBase.FilterColumnField: string;
begin
  Result := '';
end;

//Desc: 构建数据载入SQL语句
function TfFrameBase.InitFormDataSQL(const nWhere: string): string;
begin
  Result := '';
end;

//Desc: 载入界面数据
procedure TfFrameBase.InitFormData(const nWhere: string;
  const nQuery: TADOQuery);
var nStr: string;
    nBool: Boolean;
    nC: TADOQuery;
begin
  nC := nil;
  try
    if Assigned(nQuery) then
         nC := nQuery
    else nC := LockDBQuery(FDBType);

    nBool := True;
    OnInitFormData(nBool, nWhere, nQuery);
    if not nBool then Exit;

    nStr := InitFormDataSQL(nWhere);
    if nStr = '' then Exit;

    DBQuery(nStr, nC, ClientDS);
    //query data
  finally
    if not Assigned(nQuery) then
      ReleaseDBQuery(nC);
    AfterInitFormData;
  end
end;

//Desc: 数据载入后
procedure TfFrameBase.AfterInitFormData;
begin

end;

//Desc: 执行数据查询
procedure TfFrameBase.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
begin

end;

//------------------------------------------------------------------------------
//Desc: 关闭
procedure TfFrameBase.BtnExitClick(Sender: TObject);
var nSheet: TUniTabSheet;
begin
  nSheet := Parent as TUniTabSheet;
  nSheet.Close;
end;

//Desc: 刷新
procedure TfFrameBase.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  InitFormData(FWhere);
end;

end.
