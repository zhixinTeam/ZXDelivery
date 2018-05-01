{*******************************************************************************
  作者: dmzn@163.com 2018-04-23
  描述: 业务定义单元
*******************************************************************************}
unit USysBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, ComCtrls, Controls, Messages, Forms, SysUtils, IniFiles,
  Data.DB, Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, System.SyncObjs,
  //----------------------------------------------------------------------------
  uniGUIAbstractClasses, uniGUITypes, uniGUIClasses, uniGUIBaseClasses,
  uniGUISessionManager, uniGUIApplication, uniTreeView, uniGUIForm, uniDBGrid,
  //----------------------------------------------------------------------------
  UBaseObject, UManagerGroup, ULibFun, USysDB, USysConst, USysFun;

procedure GlobalSyncLock;
procedure GlobalSyncRelease;
//全局同步锁定
procedure RegObjectPoolTypes;
//注册缓冲池对象

function LockDBConn(const nType: TAdoConnectionType = ctMain): TADOConnection;
procedure ReleaseDBconn(const nConn: TADOConnection);
function LockDBQuery(const nType: TAdoConnectionType = ctMain): TADOQuery;
procedure ReleaseDBQuery(const nQuery: TADOQuery);
//数据库链路
function DBQuery(const nStr: string; const nQuery: TADOQuery;
  const nClientDS: TClientDataSet = nil): TDataSet;
function DBExecute(const nStr: string; const nCmd: TADOQuery = nil;
  const nType: TAdoConnectionType = ctMain): Integer; overload;
function DBExecute(const nList: TStrings; const nCmd: TADOQuery = nil;
  const nType: TAdoConnectionType = ctMain): Integer; overload;
//数据库操作
procedure DSClientDS(const nDS: TDataSet; const nClientDS: TClientDataSet);
//数据集转换

function SystemGetForm(const nClass: string): TUniForm;
//根据类名称获取窗体对像
function UserConfigFile: TIniFile;
//用户自定义配置文件
function ParseCardNO(const nCard: string; const nHex: Boolean): string;
//格式化磁卡编号
procedure LoadSystemMemoryStatus(const nList: TStrings; const nFriend: Boolean);
//加载系统内存状态
procedure ReloadSystemMemory(const nResetAllSession: Boolean);
//重新加载系统缓存数据

procedure LoadMenuItems(const nForce: Boolean);
//载入菜单数据
procedure BuidMenuTree(const nTree: TUniTreeView; nEntity: string = '');
//构建菜单树
function GetMenuItemID(const nIdx: Integer): string;
//获取指定菜单标识
function GetMenuByModule(const nModule: string): string;
function GetModuleByMenu(const nMenu: string): string;
//菜单与模块互查

procedure LoadFactoryList(const nForce: Boolean);
//载入工厂列表
procedure GetFactoryList(const nList: TStrings);
function GetFactory(const nIdx: Integer; var nFactory: TFactoryItem): Boolean;
//检索工厂列表

procedure LoadPopedomList(const nForce: Boolean);
//载入权限列表
function GetPopedom(const nMenu: string): string;
function HasPopedom(const nMenu,nPopedom: string): Boolean;
function HasPopedom2(const nPopedom,nAll: string): Boolean;
//是否有指定权限

procedure LoadEntityList(const nForce: Boolean);
//载入数据字典列表
procedure BuildDBGridColumn(const nEntity: string; const nGrid: TUniDBGrid;
  const nFilter: string = '');
//构建表格列
procedure UserDefineGrid(const nForm: string; const nGrid: TUniDBGrid;
  const nLoad: Boolean; const nIni: TIniFile = nil);
//用户自定义表格

implementation

uses
  MainModule, ServerModule;

var
  gSyncLock: TCriticalSection;
  //全局用同步锁定

//------------------------------------------------------------------------------
//Date: 2018-04-23
//Desc: 全局同步锁定
procedure GlobalSyncLock;
begin
  gSyncLock.Enter;
end;

//Date: 2018-04-23
//Desc: 全局同步锁定接触
procedure GlobalSyncRelease;
begin
  gSyncLock.Leave;
end;

//Date: 2018-04-20
//Desc: 注册对象池
procedure RegObjectPoolTypes;
var nCD: PAdoConnectionData;
begin
  with gMG.FObjectPool do
  begin
    NewClass(TADOConnection,
      function(var nData: Pointer):TObject
      begin
        Result := TADOConnection.Create(nil);
        New(nCD);
        nData := nCD;

        nCD.FConnUser := '';
        nCD.FConnStr := '';
      end,

      procedure(const nObj: TObject; const nData: Pointer)
      begin
        Dispose(PAdoConnectionData(nData));
      end);
    //ado conn

    NewClass(TADOQuery,
      function(var nData: Pointer):TObject
      begin
        Result := TADOQuery.Create(nil);
      end);
    //ado query

    NewClass(TDataSetProvider,
      function(var nData: Pointer):TObject
      begin
        Result := TDataSetProvider.Create(nil);
      end,

      procedure(const nObj: TObject; const nData: Pointer)
      begin
        //nothing
      end);
    //data provider
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-20
//Parm: 连接类型
//Desc: 获取数据库链路
function LockDBConn(const nType: TAdoConnectionType): TADOConnection;
var nStr: string;
    nCD: PAdoConnectionData;
begin
  GlobalSyncLock;
  try
    if nType = ctMain then
         nStr := gServerParam.FDBMain
    else nStr := gAllFactorys[UniMainModule.FUserConfig.FFactory].FDBWorkOn;
  finally
    GlobalSyncRelease;
  end;

  Result := gMG.FObjectPool.Lock(TADOConnection, nil, @nCD,
    function(const nObj: TObject; const nData: Pointer): Boolean
    begin
      Result := (not Assigned(nData)) or
                (PAdoConnectionData(nData).FConnUser = nStr);
    end) as TADOConnection;
  //相同连接优先

  with Result do
  begin
    if nCD.FConnUser <> nStr then
    begin
      nCD.FConnUser := nStr;
      //user data

      Connected := False;
      ConnectionString := nStr;
      LoginPrompt := False;
    end;

    if not Connected then
      Connected := True;
    //xxxxx
  end;
end;

//Date: 2018-04-20
//Parm: 连接对象
//Desc: 释放链路
procedure ReleaseDBconn(const nConn: TADOConnection);
begin
  if Assigned(nConn) then
  begin
    gMG.FObjectPool.Release(nConn);
  end;
end;

//Date: 2018-04-20
//Parm: 连接类型
//Desc: 获取查询对象
function LockDBQuery(const nType: TAdoConnectionType): TADOQuery;
begin
  Result := gMG.FObjectPool.Lock(TADOQuery) as TADOQuery;
  with Result do
  begin
    Close;
    Connection := LockDBConn(nType);
  end;
end;

//Date: 2018-04-20
//Parm: 查询对象
//Desc: 释放查询对象
procedure ReleaseDBQuery(const nQuery: TADOQuery);
begin
  if Assigned(nQuery) then
  begin
    try
      if nQuery.Active then
        nQuery.Close;
      //xxxxx
    except
      //ignor any error
    end;

    gMG.FObjectPool.Release(nQuery.Connection);
    gMG.FObjectPool.Release(nQuery);
  end;
end;

//Date: 2018-04-20
//Parm: SQL;查询对象
//Desc: 在nQuery上执行查询
function DBQuery(const nStr: string; const nQuery: TADOQuery;
  const nClientDS: TClientDataSet): TDataSet;
begin
  try
    if not nQuery.Connection.Connected then
      nQuery.Connection.Connected := True;
    //xxxxx
    
    nQuery.Close;
    nQuery.SQL.Text := nStr;
    nQuery.Open;

    Result := nQuery;
    //result

    if Assigned(nClientDS) then
      DSClientDS(Result, nClientDS);
    //xxxxx
  except
    nQuery.Connection.Connected := False;
    raise;
  end;
end;

//Date: 2018-04-28
//Parm: 本地数据集;远程数据集
//Desc: 将nDS转换为nClientDS
procedure DSClientDS(const nDS: TDataSet; const nClientDS: TClientDataSet);
var nProvider: TDataSetProvider;
begin
  nProvider := nil;
  try
    nProvider := gMG.FObjectPool.Lock(TDataSetProvider) as TDataSetProvider;
    nProvider.DataSet := nDS;

    if nClientDS.Active then
      nClientDS.EmptyDataSet;
    nClientDS.Data := nProvider.Data;

    nClientDS.LogChanges := False;
    nProvider.DataSet := nil;
    //xxxxx
  finally
    gMG.FObjectPool.Release(nProvider);
  end;
end;

//Date: 2018-04-20
//Parm: SQL;连接类型;操作对象
//Desc: 在nCmd上执行写入操作
function DBExecute(const nStr: string; const nCmd: TADOQuery;
  const nType: TAdoConnectionType): Integer;
var nC: TADOQuery;
begin
  nC := nil;
  try
    if Assigned(nCmd) then
         nC := nCmd
    else nC := LockDBQuery(nType);

    if not nC.Connection.Connected then
      nC.Connection.Connected := True;
    //xxxxx

    with nC do
    try
      Close;
      SQL.Text := nStr;
      Result := ExecSQL;
    except
      nC.Connection.Connected := False;
      raise;
    end;
  finally
    if not Assigned(nCmd) then
      ReleaseDBQuery(nC);
    //xxxxx
  end;
end;

function DBExecute(const nList: TStrings; const nCmd: TADOQuery = nil;
  const nType: TAdoConnectionType = ctMain): Integer;
var nIdx: Integer;
    nC: TADOQuery;
begin
  nC := nil;
  try
    if Assigned(nCmd) then
         nC := nCmd
    else nC := LockDBQuery(nType);

    if not nC.Connection.Connected then
      nC.Connection.Connected := True;
    //xxxxx

    Result := 0;
    try
      nC.Connection.BeginTrans;
      //trans start

      for nIdx := 0 to nList.Count-1 do
      with nC do
      begin
        Close;
        SQL.Text := nList[nIdx];
        Result := Result + ExecSQL;
      end;

      nC.Connection.CommitTrans;
      //commit
    except
      on nErr: Exception do
      begin
        nC.Connection.RollbackTrans;
        nC.Connection.Connected := False;
        raise;
      end;
    end;

  finally
    if not Assigned(nCmd) then
      ReleaseDBQuery(nC);
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
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

//Date: 2018-04-24
//Parm: 列表;友好格式
//Desc: 将内存状态数据加载到列表中
procedure LoadSystemMemoryStatus(const nList: TStrings; const nFriend: Boolean);
begin
  GlobalSyncLock;
  try
    nList.BeginUpdate;
    nList.Clear;

    with TObjectStatusHelper do
    begin
      AddTitle(nList, 'System Buffer');
      nList.Add(FixData('All Users:', gAllUsers.Count));
      nList.Add(FixData('All Menus:', Length(gAllMenus)));
      nList.Add(FixData('All Popedoms:', Length(gAllPopedoms)));
      nList.Add(FixData('All Entitys:', Length(gAllEntitys)));
      nList.Add(FixData('All Factorys:', Length(gAllFactorys)));
    end;

    gMG.FObjectPool.GetStatus(nList, nFriend);
    gMG.FObjectManager.GetStatus(nList, nFriend);
  finally
    GlobalSyncRelease;
    nList.EndUpdate;
  end;
end;

//Date: 2018-04-24
//Parm: 断开全部会话
//Desc: 重载缓存,断开全部连接
procedure ReloadSystemMemory(const nResetAllSession: Boolean);
var nStr: string;
    nIdx: Integer;
    nList: TUniGUISessions;
begin
  if nResetAllSession then
  begin
    nList := UniServerModule.SessionManager.Sessions;
    try
      nList.Lock;
      for nIdx := nList.SessionList.Count-1 downto 0 do
      begin
        nStr := '管理员更新系统,请重新登录';
        TUniGUISession(nList.SessionList[nIdx]).Terminate(nStr);
      end;
    finally
      nList.Unlock;
    end;
  end;

  GlobalSyncLock;
  try
    LoadFactoryList(True);
    //载入工厂列表
    LoadPopedomList(True);
    //加载权限列表
    LoadMenuItems(True);
    //载入菜单项
    LoadEntityList(True);
    //载入数据字典
  finally
    GlobalSyncRelease;
  end;
end;

//Date: 2018-04-24
//Parm: 窗体类名
//Desc: 获取nClass类的对象
function SystemGetForm(const nClass: string): TUniForm;
var nCls: TClass;
begin
  nCls := GetClass(nClass);
  if Assigned(nCls) then
       Result := TUniForm(UniMainModule.GetFormInstance(nCls))
  else Result := nil;
end;

//Date: 2018-04-26
//Desc: 用户自定义配置
function UserConfigFile: TIniFile;
var nStr,nFile: string;
    nIdx: Integer;
begin
  nStr := gPath + 'users\';
  if not DirectoryExists(nStr) then
    ForceDirectories(nStr);
  //new folder

  with TEncodeHelper,UniMainModule do
    nFile := EncodeBase64(FUserConfig.FUserID);
  //encode

  for nIdx := 1 to Length(nFile) do
   if CharInSet(nFile[nIdx], ['a'..'z', 'A'..'Z','0'..'9']) then
    nStr := nStr + nFile[nIdx];
  //number & charactor

  Result := TIniFile.Create(nStr + '.ini');
  if not FileExists(nStr) then
  begin
    Result.WriteString('Config', 'User', UniMainModule.FUserConfig.FUserID);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-23
//Parm: 强制加载
//Desc: 读取数据库菜单项
procedure LoadMenuItems(const nForce: Boolean);
var nStr: string;
    nIdx: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  try
    nIdx := Length(gAllMenus);
    if (nIdx > 0) and (not nForce) then Exit;

    nQuery := LockDBQuery(ctMain);
    //get query

    nStr := 'Select * From %s ' +
         'Where M_ProgID=''%s'' And M_NewOrder>=0 And M_Title<>''-'' ' +
         'Order By M_NewOrder ASC';
    nStr := Format(nStr, [sTable_Menu, gSysParam.FProgID]);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      SetLength(gAllMenus, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gAllMenus[nIdx] do
        begin
          FEntity    := FieldByName('M_Entity').AsString;
          FMenuID    := FieldByName('M_MenuID').AsString;
          FPMenu     := FieldByName('M_PMenu').AsString;
          FTitle     := FieldByName('M_Title').AsString;
          FImgIndex  := FieldByName('M_ImgIndex').AsInteger;
          FFlag      := FieldByName('M_Flag').AsString;
          FAction    := FieldByName('M_Action').AsString;
          FFilter    := FieldByName('M_Filter').AsString;
          FNewOrder  := FieldByName('M_NewOrder').AsFloat;
          FLangID    := 'cn';
        end;

        Inc(nIdx);
        Next;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-04-23
//Parm: 列表树;实体名称
//Desc: 构建菜单列表到nTree
procedure BuidMenuTree(const nTree: TUniTreeView; nEntity: string);
var nIdx,nInt: Integer;
    nGroup: Integer;
    nItem: TuniTreeNode;

  //Desc: 该组队nItem是否有可读权限
  function HasPopedom(const nMItem: string): Boolean;
  var i: Integer;
  begin
    Result := UniMainModule.FUserConfig.FIsAdmin;
    if Result then Exit;
    
    with gAllPopedoms[nGroup] do
    begin
      for i := Low(FPopedom) to High(FPopedom) do
      if CompareText(nMItem, FPopedom[i].FItem) = 0 then
      begin 
        Result := Pos(sPopedom_Read, FPopedom[i].FPopedom) > 0;
        Exit;
      end;
    end;
  end;

  //Desc: 构建子节点
  procedure MakeChileMenu(const nParent: TuniTreeNode);
  var i,nTag: Integer;
      nSub: TuniTreeNode;
  begin
    for i := 0 to nInt do
    with gAllMenus[i] do
    begin
      if CompareText(FEntity, nEntity) <> 0 then Continue;
      //not match entity

      nTag := Integer(nParent.Data);
      if CompareText(FPMenu, gAllMenus[nTag].FMenuID) <> 0 then Continue;
      //not sub item

      if not HasPopedom(MakeMenuID(FEntity, FMenuID)) then Continue;
      //no popedom

      nSub := nTree.Items.AddChild(nParent, FTitle);
      nSub.Data := Pointer(i);
      MakeChileMenu(nSub);
    end;
  end;
begin
  if nEntity='' then
    nEntity := 'MAIN';
  //main menu

  GlobalSyncLock;
  try
    nTree.Items.BeginUpdate;
    nTree.Items.Clear;
    nGroup := -1;

    for nIdx := Low(gAllPopedoms) to High(gAllPopedoms) do
    if gAllPopedoms[nIdx].FID = UniMainModule.FUserConfig.FGroupID then
    begin
      nGroup := nIdx;
      Break;
    end;

    if nGroup < 0 then
    begin
      nTree.Items.AddChild(nil, '权限不足');
      Exit;
    end;

    nInt := Length(gAllMenus)-1;
    for nIdx := 0 to nInt do
    with gAllMenus[nIdx] do
    begin
      if CompareText(FEntity, nEntity) <> 0 then Continue;
      //not match entity
      if (FMenuID = '') or (FPMenu <> '') then Continue;
      //not root item
      if not HasPopedom(MakeMenuID(FEntity, FMenuID)) then Continue;
      //no popedom

      nItem := nTree.Items.AddChild(nil, FTitle);
      nItem.Data := Pointer(nIdx);
    end;

    nItem := nTree.Items.GetFirstNode;
    while Assigned(nItem) do
    begin
      MakeChileMenu(nItem);
      nItem := nItem.GetNextSibling;
    end;
  finally
    GlobalSyncRelease;
    nTree.Items.EndUpdate;
  end;

  {$IFDEF DEBUG}
  nTree.FullExpand;
  {$ENDIF}
end;

//Date: 2018-04-24
//Parm: 菜单项索引
//Desc: 获取nIdx的菜单标识
function GetMenuItemID(const nIdx: Integer): string;
begin
  GlobalSyncLock;
  try
    Result := '';
    if (nIdx >= Low(gAllMenus)) and (nIdx <= High(gAllMenus)) then
     with gAllMenus[nIdx] do
      Result := MakeMenuID(FEntity, FMenuID);
    //xxxxx
  finally
    GlobalSyncRelease;
  end;
end;

//Date: 2018-04-26
//Parm: 模块名称
//Desc: 检索模块为nModule的菜单项
function GetMenuByModule(const nModule: string): string;
var nIdx: Integer;
begin
  with UniMainModule do
  begin
    Result := '';
    //init

    for nIdx := Low(FMenuModule) to High(FMenuModule) do
    with FMenuModule[nIdx] do
    begin
      if CompareText(nModule, FModule) = 0 then
      begin
        Result := FMenuID;
        Exit;
      end;
    end;
  end;
end;

//Date: 2018-04-26
//Parm: 菜单项
//Desc: 检索菜单项为nMenu的模块
function GetModuleByMenu(const nMenu: string): string;
var nIdx: Integer;
begin
  with UniMainModule do
  begin
    Result := '';
    //init

    for nIdx := Low(FMenuModule) to High(FMenuModule) do
    with FMenuModule[nIdx] do
    begin
      if CompareText(nMenu, FModule) = 0 then
      begin
        Result := FModule;
        Exit;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-24
//Parm: 强制更新
//Desc: 加载工厂列表到内存
procedure LoadFactoryList(const nForce: Boolean);
var nStr: string;
    nIdx: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  try
    nIdx := Length(gAllFactorys);
    if (nIdx > 0) and (not nForce) then Exit;

    nQuery := LockDBQuery(ctMain);
    //get query

    nStr := 'Select * From %s Where F_Valid=''%s'' Order By F_Index ASC';
    nStr := Format(nStr, [sTable_Factorys, sFlag_Yes]);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      SetLength(gAllFactorys, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gAllFactorys[nIdx] do
        begin
          FFactoryID  := FieldByName('F_ID').AsString;
          FFactoryName:= FieldByName('F_Name').AsString;
          FMITServURL := FieldByName('F_MITUrl').AsString;
          FHardMonURL := FieldByName('F_HardUrl').AsString;
          FWechatURL  := FieldByName('F_WechatUrl').AsString;
          FDBWorkOn   := FieldByName('F_DBConn').AsString;
        end;

        Inc(nIdx);
        Next;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-04-24
//Parm: 列表
//Desc: 加载工厂列表到nList中
procedure GetFactoryList(const nList: TStrings);
var nIdx: Integer;
begin
  GlobalSyncLock;
  try
    nList.BeginUpdate;
    nList.Clear;

    for nIdx := Low(gAllFactorys) to High(gAllFactorys) do
     with gAllFactorys[nIdx] do
      nList.AddObject(FFactoryID + '.' + FFactoryName, Pointer(nIdx));
    //xxxxx
  finally
    GlobalSyncRelease;
    nList.EndUpdate;
  end;
end;

//Date: 2018-04-24
//Parm: 索引;工厂数据
//Desc: 读取nIdx的数据到nFactory
function GetFactory(const nIdx: Integer; var nFactory: TFactoryItem): Boolean;
begin
  GlobalSyncLock;
  try
    Result := (nIdx >= Low(gAllFactorys)) and (nIdx <= High(gAllFactorys));
    if Result then
      nFactory := gAllFactorys[nIdx];
    //xxxxx
  finally
    GlobalSyncRelease;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-24
//Parm: 强制加载
//Desc: 加载权限到内存
procedure LoadPopedomList(const nForce: Boolean);
var nStr: string;
    nIdx,nInt: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  try
    nIdx := Length(gAllPopedoms);
    if (nIdx > 0) and (not nForce) then Exit;

    nQuery := LockDBQuery(ctMain);
    //get query
    nStr := 'Select * From ' + sTable_Group;

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      SetLength(gAllPopedoms, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gAllPopedoms[nIdx] do
        begin
          FID       := FieldByName('G_ID').AsString;
          FName     := FieldByName('G_NAME').AsString;
          FDesc     := FieldByName('G_DESC').AsString;
          SetLength(FPopedom, 0);
        end;

        Inc(nIdx);
        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From ' + sTable_Popedom;
    //权限表

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      for nIdx := Low(gAllPopedoms) to High(gAllPopedoms) do
      with gAllPopedoms[nIdx] do
      begin
        nInt := 0;
        First;

        while not Eof do
        begin
          if FieldByName('P_Group').AsString = FID then
            Inc(nInt);
          Next;
        end;

        SetLength(FPopedom, nInt);
        nInt := 0;
        First;

        while not Eof do
        begin
          if FieldByName('P_Group').AsString = FID then
          begin
            with FPopedom[nInt] do
            begin
              FItem := FieldByName('P_Item').AsString;
              FPopedom := FieldByName('P_Popedom').AsString;
            end;

            Inc(nInt);
          end;

          Next;
        end;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-04-26
//Parm: 菜单项
//Desc: 获取当前用户对nMenu所拥有的权限
function GetPopedom(const nMenu: string): string;
var nIdx,nGroup: Integer;
begin
  with UniMainModule do
  try
    GlobalSyncLock;
    Result := '';
    nGroup := -1;

    for nIdx := Low(gAllPopedoms) to High(gAllPopedoms) do
    if gAllPopedoms[nIdx].FID = FUserConfig.FGroupID then
    begin
      nGroup := nIdx;
      Break;
    end;

    if nGroup < 0 then Exit;
    //no group match

    with gAllPopedoms[nGroup] do
    begin
      for nIdx := Low(FPopedom) to High(FPopedom) do
      if CompareText(nMenu, FPopedom[nIdx].FItem) = 0 then
      begin
        Result := FPopedom[nIdx].FPopedom;
        Exit;
      end;
    end;
  finally
    GlobalSyncRelease;
  end;
end;

//Date: 2018-04-26
//Parm: 菜单项;权限项
//Desc: 判断当前用户对nMenu是否有nPopedom权限
function HasPopedom(const nMenu,nPopedom: string): Boolean;
begin
  with UniMainModule do
  begin
    Result := FUserConfig.FIsAdmin or (Pos(nPopedom, GetPopedom(nMenu)) > 0);
  end;
end;

//Date: 2018-04-26
//Parm: 权限项;权限组
//Desc: 检测nAll中是否有nPopedom权限项
function HasPopedom2(const nPopedom,nAll: string): Boolean;
begin
  with UniMainModule do
  begin
    Result := FUserConfig.FIsAdmin or (Pos(nPopedom, nAll) > 0);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-04-26
//Parm: 强制刷新
//Desc: 载入数据字典
procedure LoadEntityList(const nForce: Boolean);
var nStr: string;
    nIdx,nInt: Integer;
    nQuery: TADOQuery;
begin
  nQuery := nil;
  try
    nIdx := Length(gAllEntitys);
    if (nIdx > 0) and (not nForce) then Exit;

    nQuery := LockDBQuery(ctMain);
    //get query

    nStr := 'Select * From %s Where E_ProgID=''%s''';
    nStr := Format(nStr, [sTable_Entity, gSysParam.FProgID]);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      SetLength(gAllEntitys, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      begin
        with gAllEntitys[nIdx] do
        begin
          FEntity := FieldByName('E_Entity').AsString;
          FTitle  := FieldByName('E_Title').AsString;
          SetLength(FDictItem, 0);
        end;

        Inc(nIdx);
        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nStr := 'Select * From %s Order By D_Index ASC';
    nStr := Format(nStr, ['Sys_DataDict']);

    with DBQuery(nStr, nQuery) do
    if RecordCount > 0 then
    begin
      for nIdx := Low(gAllEntitys) to High(gAllEntitys) do
      with gAllEntitys[nIdx] do
      begin
        nStr := gSysParam.FProgID + '_' + FEntity;
        nInt := 0;
        First;

        while not Eof do
        begin
          if CompareText(nStr, FieldByName('D_Entity').AsString) = 0 then
            Inc(nInt);
          Next;
        end;

        if nInt < 1 then Continue;
        //no entity detail

        SetLength(FDictItem, nInt);
        nInt := 0;
        First;

        while not Eof  do
        begin
          if CompareText(nStr, FieldByName('D_Entity').AsString) = 0 then
          with FDictItem[nInt] do
          begin
            FItemID  := FieldByName('D_ItemID').AsInteger;
            FTitle   := FieldByName('D_Title').AsString;
            FAlign   := TAlignment(FieldByName('D_Align').AsInteger);
            FWidth   := FieldByName('D_Width').AsInteger;
            FIndex   := FieldByName('D_Index').AsInteger;
            FVisible := StrToBool(FieldByName('D_Visible').AsString);
            FLangID  := FieldByName('D_LangID').AsString;

            with FDBItem do
            begin
              FTable := FieldByName('D_DBTable').AsString;
              FField := FieldByName('D_DBField').AsString;
              FIsKey := StrToBool(FieldByName('D_DBIsKey').AsString);

              FType  := TFieldType(FieldByName('D_DBType').AsInteger);
              FWidth := FieldByName('D_DBWidth').AsInteger;
              FDecimal:= FieldByName('D_DBDecimal').AsInteger;
            end;

            with FFormat do
            begin
              FStyle  := TDictFormatStyle(FieldByName('D_FmtStyle').AsInteger);
              FData   := FieldByName('D_FmtData').AsString;
              FFormat := FieldByName('D_FmtFormat').AsString;
              FExtMemo:= FieldByName('D_FmtExtMemo').AsString;
            end;

            with FFooter do
            begin
              FDisplay := FieldByName('D_FteDisplay').AsString;
              FFormat := FieldByName('D_FteFormat').AsString;
              FKind := TDictFooterKind(FieldByName('D_FteKind').AsInteger);
              FPosition := TDictFooterPosition(FieldByName('D_FtePositon').AsInteger);
            end;

            Inc(nInt);
          end;

          Next;
        end;
      end;
    end;
  finally
    ReleaseDBQuery(nQuery);
  end;
end;

//Date: 2018-04-26
//Parm: 实体名称;列表;排除字段
//Desc: 使用数据字典nEntity构建nGrid的表头
procedure BuildDBGridColumn(const nEntity: string; const nGrid: TUniDBGrid;
 const nFilter: string);
var i,nIdx: Integer;
    nList: TStrings;
begin
  with nGrid do
  begin
    BorderStyle := ubsDefault;
    LoadMask.Message := '加载数据';

    Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowSelect,
                dgRowSelect, dgColumnMove];
    //选项控制

    ReadOnly := True;
  end;

  nList := nil;
  try
    GlobalSyncLock;
    nGrid.Columns.BeginUpdate;
    nIdx := -1;
    //init

    for i := Low(gAllEntitys) to High(gAllEntitys) do
    if CompareText(nEntity, gAllEntitys[i].FEntity) = 0 then
    begin
      nIdx := i;
      Break;
    end;

    if nIdx < 0 then Exit;
    //no entity match

    if nFilter <> '' then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      TStringHelper.Split(nFilter, nList, 0, ';');
    end;

    with gAllEntitys[nIdx],nGrid do
    begin
      Columns.Clear;
      //clear first

      for i := Low(FDictItem) to High(FDictItem) do
      with FDictItem[i] do
      begin
        if not FVisible then Continue;

        if Assigned(nList) and (nList.IndexOf(FDBItem.FField) >= 0) then
          Continue;
        //字段被过滤,不予显示

        with Columns.Add do
        begin
          Alignment := FAlign;
          FieldName := FDBItem.FField;

          Title.Alignment := FAlign;
          Title.Caption := FTitle;
          Width := FWidth;
          Tag := i;
        end;
      end;
    end;
  finally
    GlobalSyncRelease;
    gMG.FObjectPool.Release(nList);
    nGrid.Columns.EndUpdate;
  end;
end;

//Date: 2018-04-27
//Parm: 窗体名;表格;读取
//Desc: 读写nForm.nGrid的用户配置
procedure UserDefineGrid(const nForm: string; const nGrid: TUniDBGrid;
  const nLoad: Boolean; const nIni: TIniFile = nil);
var nStr: string;
    i,j,nCount: Integer;
    nTmp: TIniFile;
    nList: TStrings;
begin
  nTmp := nil;
  nList := nil;

  with TStringHelper do
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := UserConfigFile;

    nCount := nGrid.Columns.Count - 1;
    //column num

    if nLoad then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      nStr := nTmp.ReadString(nForm, 'GridWidth_' + nGrid.Name, '');

      if Split(nStr, nList, nGrid.Columns.Count) then
      begin
        for i := 0 to nCount do
         if IsNumber(nList[i], False) then
          nGrid.Columns[i].Width := StrToInt(nList[i]);
        //apply width
      end;

      nStr := nTmp.ReadString(nForm, 'GridVisible_' + nGrid.Name, '');
      if Split(nStr, nList, nGrid.Columns.Count) then
      begin
        for i := 0 to nCount do
          nGrid.Columns[i].Visible := nList[i] = '1';
        //apply visible
      end;

      nStr := nTmp.ReadString(nForm, 'GridIndex_' + nGrid.Name, '');
      if Split(nStr, nList, nGrid.Columns.Count) then
      begin
        for i := 0 to nCount do
        begin
          if not IsNumber(nList[i], False) then Continue;
          //not valid

          for j := 0 to nCount do
          if nGrid.Columns[j].Tag = StrToInt(nList[i]) then
          begin
            nGrid.Columns[j].Index := i;
            Break;
          end;
        end;
      end;
    end else
    begin
      nStr := '';
      for i := 0 to nCount do
      begin
        nStr := nStr + IntToStr(nGrid.Columns[i].Tag);
        if i <> nCount then nStr := nStr + ';';
      end;
      nTmp.WriteString(nForm, 'GridIndex_' + nGrid.Name, nStr);

      nStr := '';
      for i := 0 to nCount do
      begin
        nStr := nStr + IntToStr(nGrid.Columns[i].Width);
        if i <> nCount then nStr := nStr + ';';
      end;
      nTmp.WriteString(nForm, 'GridWidth_' + nGrid.Name, nStr);

      nStr := '';
      for i := 0 to nCount do
      begin
        if nGrid.Columns[i].Visible then
             nStr := nStr + '1'
        else nStr := nStr + '0';
        if i <> nCount then nStr := nStr + ';';
      end;
      nTmp.WriteString(nForm, 'GridVisible_' + nGrid.Name, nStr);
    end;
  finally
    gMG.FObjectPool.Release(nList);
    if not Assigned(nIni) then
      nTmp.Free;
    //xxxxx
  end;
end;

initialization
  gSyncLock := TCriticalSection.Create;
finalization
  FreeAndNil(gSyncLock);
end.


