{*******************************************************************************
  作者: dmzn@163.com 2007-10-09
  描述: 项目通用函数定义单元
*******************************************************************************}
unit USysFun;

interface

uses
  Windows, Classes, ComCtrls, Controls, Messages, Forms, SysUtils, IniFiles,
  UManagerGroup, ULibFun, USysConst, Registry, Data.DB, Data.Win.ADODB,
  uniStatusBar;

procedure ShowMsgOnLastPanelOfStatusBar(const nStatusBar: TUniStatusBar;
  const nMsg: string);
//在状态栏显示信息

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure LoadSysParameter(const nIni: TIniFile = nil);
//载入系统配置参数
function MakeFrameName(const nFrameID: integer): string;
//创建Frame名称

function ReplaceGlobalPath(const nStr: string): string;
//替换nStr中的全局路径

procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
//载入列表表头宽度
function MakeListViewColumnInfo(const nLv: TListView): string;
//组合列表表头宽度信息
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
//组合选中的项的数据

function ParseCardNO(const nCard: string; const nHex: Boolean): string;
//格式化磁卡编号

procedure RegObjectPoolTypes;
//注册对象池
function LockDBConn(const nType: TAdoConnectionType): TADOConnection;
procedure RelaseDBconn(const nConn: TADOConnection);
function LockDBQuery(const nType: TAdoConnectionType): TADOQuery;
procedure RelaseDBQuery(const nQuery: TADOQuery);
//数据库链路
function DBQuery(const nStr: string; const nQuery: TADOQuery): TDataSet;
function DBExecute(const nStr: string; const nCmd: TADOQuery): Integer;
//数据库操作

implementation

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2007-01-09
//Desc: 初始化运行环境
procedure InitSystemEnvironment;
begin
  Randomize;
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: 载入系统配置参数
procedure LoadSysParameter(const nIni: TIniFile = nil);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSysParam, nTmp do
    begin
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //程序标识决定以下所有参数

      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');
    end;

    with gServerParam, nTmp do
    begin
      FPort := ReadInteger('Server', 'Port', 8077);
      FExtJS := ReadString('Server', 'JS_Ext', '');
      FUniJS := ReadString('Server', 'JS_Uni', '');

      FDBMain := ReadString('Database', 'Main', '');
      FDBWorkOn := ReadString('Database', 'WorkOn', '');
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: 依据FrameID生成组件名
function MakeFrameName(const nFrameID: integer): string;
begin
  Result := 'Frame' + IntToStr(nFrameID);
end;

//Desc: 替换nStr中的全局路径
function ReplaceGlobalPath(const nStr: string): string;
var nPath: string;
begin
  nPath := gPath;
  if Copy(nPath, Length(nPath), 1) = '\' then
    System.Delete(nPath, Length(nPath), 1);
  Result := StringReplace(nStr, '$Path', nPath, [rfReplaceAll, rfIgnoreCase]);
end;

//------------------------------------------------------------------------------
//Desc: 在全局状态栏最后一个Panel上显示nMsg消息
procedure ShowMsgOnLastPanelOfStatusBar(const nStatusBar: TUniStatusBar;
  const nMsg: string);
begin
  if Assigned(nStatusBar) and (nStatusBar.Panels.Count > 0) then
  begin
    nStatusBar.Panels[nStatusBar.Panels.Count - 1].Text := nMsg;
    //Application.ProcessMessages;
  end;
end;

//Date: 2007-11-30
//Parm: 宽度信息;列表
//Desc: 载入nList的表头宽度
procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
var nList: TStrings;
    i,nCount: integer;
begin
  if nLv.Columns.Count > 0 then
  begin
    nList := TStringList.Create;
    try
      if TStringHelper.Split(nWidths, nList, nLv.Columns.Count, ';') then
      begin
        nCount := nList.Count - 1;
        for i:=0 to nCount do
         if TStringHelper.IsNumber(nList[i], False) then
          nLv.Columns[i].Width := StrToInt(nList[i]);
      end;
    finally
      nList.Free;
    end;
  end;
end;

//Date: 2007-11-30
//Parm: 列表
//Desc: 组合nLv的表头宽度信息
function MakeListViewColumnInfo(const nLv: TListView): string;
var i,nCount: integer;
begin
  Result := '';
  nCount := nLv.Columns.Count - 1;

  for i:=0 to nCount do
  if i = nCount then
       Result := Result + IntToStr(nLv.Columns[i].Width)
  else Result := Result + IntToStr(nLv.Columns[i].Width) + ';';
end;

//Date: 2007-11-30
//Parm: 列表;列表;是否全部组合
//Desc: 组合nLv中的信息,填充到nList中
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
var i,nCount: integer;
begin
  nList.Clear;
  nCount := nLv.Items.Count - 1;

  for i:=0 to nCount do
  if nAll or nLv.Items[i].Selected then
  begin
    nList.Add(nLv.Items[i].Caption + sLogField +
      TStringHelper.Combine(nLv.Items[i].SubItems, sLogField));
    //combine items's data
  end;
end;

//Date: 2012-4-22
//Parm: 16位卡号数据
//Desc: 格式化nCard为标准卡号
function ParseCardNO(const nCard: string; const nHex: Boolean): string;
var nInt: Int64;
    nIdx: Integer;
begin
  if nHex then
  begin
    Result := '';
    for nIdx:=1 to Length(nCard) do
      Result := Result + IntToHex(Ord(nCard[nIdx]), 2);
    //xxxxx
  end else Result := nCard;

  nInt := StrToInt64('$' + Result);
  Result := IntToStr(nInt);
  Result := StringOfChar('0', 12 - Length(Result)) + Result;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-20
//Desc: 注册对象池
procedure RegObjectPoolTypes;
begin
  with gMG.FObjectPool do
  begin
    NewClass(TADOConnection,
      function():TObject begin Result := TADOConnection.Create(nil); end);
    //ado conn

    NewClass(TADOQuery,
      function():TObject begin Result := TADOQuery.Create(nil); end);
    //ado query
  end;
end;

//Date: 2018-04-20
//Parm: 连接类型
//Desc: 获取数据库链路
function LockDBConn(const nType: TAdoConnectionType): TADOConnection;
var nStr: string;
begin
  Result := gMG.FObjectPool.Lock(TADOConnection) as TADOConnection;
  with Result do
  begin
    if nType = ctMain then
         nStr := gServerParam.FDBMain
    else nStr := gServerParam.FDBWorkOn;

    if Result.ConnectionString <> nStr then
    begin
      Connected := False;
      ConnectionString := nStr;
      LoginPrompt := False;
    end;
  end;
end;

//Date: 2018-04-20
//Parm: 连接对象
//Desc: 释放链路
procedure RelaseDBconn(const nConn: TADOConnection);
begin
  gMG.FObjectPool.Release(nConn);
end;

//Date: 2018-04-20
//Parm: 连接类型
//Desc: 获取查询对象
function LockDBQuery(const nType: TAdoConnectionType): TADOQuery;
var nStr: string;
begin
  Result := gMG.FObjectPool.Lock(TADOQuery) as TADOQuery;
  with Result do
  begin
    if nType = ctMain then
         nStr := gServerParam.FDBMain
    else nStr := gServerParam.FDBWorkOn;

    Close;
    Connection := gMG.FObjectPool.Lock(TADOConnection) as TADOConnection;

    if Connection.ConnectionString <> nStr then
    with Connection do
    begin
      Connected := False;
      ConnectionString := nStr;
      LoginPrompt := False;
    end;
  end;
end;

//Date: 2018-04-20
//Parm: 查询对象
//Desc: 释放查询对象
procedure RelaseDBQuery(const nQuery: TADOQuery);
begin
  gMG.FObjectPool.Release(nQuery.Connection);
  gMG.FObjectPool.Release(nQuery);
end;

//Date: 2018-04-20
//Parm: SQL;查询对象
//Desc: 在nQuery上执行查询
function DBQuery(const nStr: string; const nQuery: TADOQuery): TDataSet;
begin
  nQuery.Close;
  nQuery.SQL.Text := nStr;
  nQuery.Open;

  Result := nQuery;
  //result
end;

//Date: 2018-04-20
//Parm: SQL;操作对象
//Desc: 在nCmd上执行写入操作
function DBExecute(const nStr: string; const nCmd: TADOQuery): Integer;
begin
  nCmd.Close;
  nCmd.SQL.Text := nStr;
  Result := nCmd.ExecSQL;
end;

end.


