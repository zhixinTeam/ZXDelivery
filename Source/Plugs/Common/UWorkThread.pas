unit UWorkThread;

interface

uses
  Classes, SysUtils, DateUtils, UMgrDBConn, UWaitItem, IdGlobal;

type
  TWorkThread = class(TThread)
  private
    FDBConn: PDBWorker;
    //数据通道
  private
    procedure DelPoundPictures;
    procedure SearchOutTimeSanFHTruck;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
  end;

implementation

uses  USysLoger, ULibFun, USysDB;


function DateTimeToMilliseconds(const ADateTime: TDateTime): Int64;
var
  LTimeStamp: TTimeStamp;
begin
  LTimeStamp := DateTimeToTimeStamp(ADateTime);
  Result := LTimeStamp.Date;
  Result := (Result * MSecsPerDay) + LTimeStamp.Time;
end;

// 分钟差
function xMinutesBetween(const ANow, AThen: TDateTime): Int64;
begin
  Result := (DateTimeToMilliseconds(ANow) - DateTimeToMilliseconds(AThen))
    div (MSecsPerSec * SecsPerMin);
end;

// 秒数差
function xSecsBetween(const ANow, AThen: TDateTime): Int64;
begin
  Result := (DateTimeToMilliseconds(ANow) - DateTimeToMilliseconds(AThen))
    div (MSecsPerSec);
end;

//*********************************************************************************************
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TWorkThread, '定时任务线程', nEvent);
end;

constructor TWorkThread.Create;
begin
  inherited Create(False);
  FreeOnTerminate := False;
end;

destructor TWorkThread.Destroy;
begin
  inherited;
end;

procedure TWorkThread.Execute;
var LastDelPicTime, LastTimeA : TDateTime;
begin
  LastDelPicTime:= IncHour(Now, -10);
  LastTimeA:= IncHour(Now, -10);
  Sleep(10*1000);
  //等待数据连接管理器初始化
  //****************************************
  while not Terminated do
  begin
    try
      try
//        if xMinutesBetween(Now, LastDelPicTime) > 5 then
//        begin
//          DelPoundPictures;
//          LastDelPicTime:= Now;
//        end;

        if xMinutesBetween(Now, LastTimeA) > 30 then
        begin
          SearchOutTimeSanFHTruck;
          LastTimeA:= Now;
        end;

      except
        on Ex:Exception do
        begin
          WriteLog(Ex.Message);
        end;
      end;
    finally
      Sleep(1000);
    end;
  end;
end;

/// 删除图片 保留最近N 天
procedure TWorkThread.DelPoundPictures;
var nStr, nDay:string;
    FErrNum:Integer;
begin
  Exit;
  try
    FDBConn := gDBConnManager.GetConnection('local_db', FErrNum);
    if not Assigned(FDBConn) then
    begin
      WriteLog('连接数据库失败(DBConn Is Null).');
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db
    //********************************************************
    //********************************************************

    nStr := 'Select * From Sys_Dict Where D_Name=''PoundPicRetainDay'' ';
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount<1 then
        nDay:= '60'
      else nDay:= FieldByName('D_Value').AsString;
    end;

    nStr := 'Delete Sys_Picture Where R_ID IN ( '+
              'Select Top 1000 R_ID From Sys_Picture '+
              'Where IsSave=1 And P_Date< DATEADD(Day, -'+nDay+',GetDate())  )';
    gDBConnManager.WorkerExec(FDBConn, nStr);
  finally
    if Assigned(FDBConn) then
      gDBConnManager.ReleaseConnection(FDBConn);
  end;
end;

/// 查询放灰超时车辆
procedure TWorkThread.SearchOutTimeSanFHTruck;
var nStr, nSQL, nEID, nTime:string;
    FErrNum:Integer;
begin
  try
    FDBConn := gDBConnManager.GetConnection('local_db', FErrNum);
    if not Assigned(FDBConn) then
    begin
      WriteLog('连接数据库失败(DBConn Is Null).');
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db
    //********************************************************
    //********************************************************

    nStr := 'Select * From Sys_Dict Where D_Name=''SanLadingOutTime'' ';
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount<1 then
        nTime:= '60'
      else nTime:= FieldByName('D_Value').AsString;
    end;

    nStr := 'Insert into S_LadingOutTime(L_ID, L_Date,MINUTENum) Select L_ID, L_LadeTime, DateDiff(MINUTE,isNull(L_LadeTime,GetDate()),GETDATE()) TimeOut '+
            'From S_Bill Where L_Status=''F'' And DateDiff(MINUTE,isNull(L_LadeTime,GetDate()),GETDATE())>'+nTime;
    gDBConnManager.WorkerExec(FDBConn, nStr);
                                   
    //***************************
    nEID:= DateTime2Str(Now)+'>>';
    nStr:= '超时装车车辆信息已刷新、请及时查看';
    nSQL:= ' If Not Exists (Select * From Sys_ManualEvent Where E_ID='''+nEID+''')  '+
             '      Insert Into Sys_ManualEvent(E_ID, E_From, E_Event, E_Solution, E_Departmen, E_Date) '+
             '      Select ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', CONVERT(Varchar(20), GETDATE(), 120)  ';
    nSQL:= Format(nSQL, [nEID, sFlag_DepSys, nStr, sFlag_Solution_YNt, sFlag_DepJianZhuang]);
    gDBConnManager.WorkerExec(FDBConn, nSql);
  finally
    if Assigned(FDBConn) then
      gDBConnManager.ReleaseConnection(FDBConn);
  end;
end;


end.
 