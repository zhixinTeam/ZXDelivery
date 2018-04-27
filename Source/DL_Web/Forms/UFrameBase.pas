{*******************************************************************************
  作者: dmzn@163.com 2018-04-25
  描述: Frame基类
*******************************************************************************}
unit UFrameBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, MainModule, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniToolBar, uniGUIBaseClasses, uniPanel, Data.DB,
  Data.Win.ADODB, Datasnap.DBClient, uniBasicGrid, uniDBGrid, uniSplitter,
  System.IniFiles, uniTimer;

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
    SplitterTop: TUniSplitter;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
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
  ULibFun, USysBusiness, USysConst, USysDB;

procedure TfFrameBase.UniFrameCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FMenuID := GetMenuByModule(ClassName);
  FPopedom := GetPopedom(FMenuID);

  OnLoadPopedom;
  //加载权限

  nIni := nil;
  try
    nIni := UserConfigFile;
    PanelQuick.Height := nIni.ReadInteger(ClassName, 'PanelQuick', 50);

    OnLoadGridConfig(nIni);
    //载入用户配置
    OnCreateFrame(nIni);
    //子类处理
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.UniFrameDestroy(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := nil;
  try
    nIni := UserConfigFile;
    nIni.WriteInteger(ClassName, 'PanelQuick', PanelQuick.Height);

    OnSaveGridConfig(nIni);
    //保存用户配置
    OnDestroyFrame(nIni);
    //子类处理
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.OnCreateFrame(const nIni: TIniFile);
begin

end;

procedure TfFrameBase.OnDestroyFrame(const nIni: TIniFile);
begin

end;

//Desc: 读取权限
procedure TfFrameBase.OnLoadPopedom;
var nIni: TIniFile;
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

end;

procedure TfFrameBase.OnSaveGridConfig(const nIni: TIniFile);
begin

end;

//Desc: 过滤不显示
function TfFrameBase.FilterColumnField: string;
begin
  Result := '';
end;

procedure TfFrameBase.InitFormData(const nWhere: string;
  const nQuery: TADOQuery);
begin

end;

function TfFrameBase.InitFormDataSQL(const nWhere: string): string;
begin

end;

procedure TfFrameBase.AfterInitFormData;
begin

end;

procedure TfFrameBase.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
begin

end;

end.
