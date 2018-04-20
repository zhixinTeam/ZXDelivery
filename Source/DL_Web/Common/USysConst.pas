{*******************************************************************************
  作者: dmzn@ylsoft.com 2018-03-15
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引
  cRecMenuMax           = 5;                         //最近使用导航区最大条目数

type
  TAdoConnectionType = (ctMain, ctWork);
  //连接类型

  PSysParam = ^TSysParam;
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

    FUserID     : string;                            //用户标识
    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FGroupID    : string;                            //所在组
    FIsAdmin    : Boolean;                           //是否管理员
    FIsNormal   : Boolean;                           //帐户是否正常

    FLocalIP    : string;                            //本机IP
    FLocalMAC   : string;                            //本机MAC
    FLocalName  : string;                            //本机名称
    FMITServURL : string;                            //业务服务
    FHardMonURL : string;                            //硬件守护
    FWechatURL  : string;                            //微信服务
    
    FFactNum    : string;                            //工厂编号
    FSerialID   : string;                            //电脑编号
    FDepartment : string;                            //所属部门
  end;
  //系统参数

  TServerParam = record
    FPort       : Integer;                           //服务端口
    FExtJS      : string;                            //ext脚本目录
    FUniJS      : string;                            //uni脚本目录
    FDBMain     : string;                            //主数据库连接
    FDBWorkOn   : string;                            //工作数据库
  end;

  TModuleItemType = (mtFrame, mtForm);
  //模块类型

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //菜单名称
    FModule: integer;                                //模块标识
    FItemType: TModuleItemType;                      //模块类型
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gServerParam: TServerParam;                        //服务器参数

  gUserList: TThreadList;                            //登录用户列表
  gMenuModule: TList = nil;                          //菜单模块映射表

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sImageDir           = 'Images\';                   //图片目录
  sReportDir          = 'Report\';                   //报表目录
  sBackupDir          = 'Backup\';                   //备份目录
  sBackupFile         = 'Bacup.idx';                 //备份索引
  sCameraDir          = 'Camera\';                   //抓拍目录

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节
  sDBConfig           = 'DBConn.ini';                //数据连接
  sDBConfig_bk        = 'isbk';                      //备份库

  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件 

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

implementation

//------------------------------------------------------------------------------
//Desc: 添加菜单模块映射项
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: 菜单模块映射表
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  //AddMenuModuleItem('MAIN_A01', cFI_FormIncInfo, mtForm);
  //AddMenuModuleItem('MAIN_A02', cFI_FrameSysLog);
end;

//Desc: 清理模块列表
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  InitMenuModuleList;
  gUserList := TThreadList.Create;
finalization
  FreeAndNil(gUserList);
  ClearMenuModuleList;
end.


