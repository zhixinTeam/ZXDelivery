{*******************************************************************************
  作者: dmzn@163.com 2018-04-20
  描述: 用户全局主模块
*******************************************************************************}
unit MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, uniGUIBaseClasses, uniGUIClasses,
  uniImageList, uniGUIForm, System.SyncObjs, USysConst;

type
  TUniMainModule = class(TUniGUIMainModule)
    ImageListSmall: TUniNativeImageList;
    ImageListBar: TUniNativeImageList;
    procedure UniGUIMainModuleCreate(Sender: TObject);
    procedure UniGUIMainModuleDestroy(Sender: TObject);
    procedure UniGUIMainModuleBeforeLogin(Sender: TObject;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    FMainForm: TUniForm;
    //主窗体
    FUserConfig: TSysParam;
    //系统参数
    FMenuModule: TMenuModuleItems;
    //菜单模块
  end;

function UniMainModule: TUniMainModule;
//入口函数

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication, USysBusiness;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

procedure TUniMainModule.UniGUIMainModuleCreate(Sender: TObject);
var nIdx: Integer;
begin
  FUserConfig := gSysParam;
  //复制全局参数
  with FUserConfig,UniSession do
  begin
    FLocalIP   := RemoteIP;
    FLocalName := RemoteHost;
    FUserAgent := UserAgent;
    FOSUser    := SystemUser;
  end;

  GlobalSyncLock;
  try
    //for nIdx := gAllUsers.Count-1 downto 0 do
    // if PSysParam(gAllUsers[nIdx]).FLocalIP = FUserConfig.FLocalIP then
    //  FUserConfig := PSysParam(gAllUsers[nIdx])^;
    //restore

    gAllUsers.Add(@FUserConfig);
  finally
    GlobalSyncRelease;
  end;

  SetLength(FMenuModule, gMenuModule.Count);
  for nIdx := 0 to gMenuModule.Count-1 do
    FMenuModule[nIdx] := PMenuModuleItem(gMenuModule[nIdx])^;
  //准备菜单模块映射
end;

procedure TUniMainModule.UniGUIMainModuleDestroy(Sender: TObject);
var nIdx: Integer;
begin
  GlobalSyncLock;
  try
    nIdx := gAllUsers.IndexOf(@FUserConfig);
    if nIdx >= 0 then
      gAllUsers.Delete(nIdx);
    //xxxxx
  finally
    GlobalSyncRelease;
  end;
end;

procedure TUniMainModule.UniGUIMainModuleBeforeLogin(Sender: TObject;
  var Handled: Boolean);
begin
  Handled := FUserConfig.FUserID <> '';
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
