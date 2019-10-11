unit SrvWebchat_Impl;

{----------------------------------------------------------------------------}
{ This unit was automatically generated by the RemObjects SDK after reading  }
{ the RODL file associated with this project .                               }
{                                                                            }
{ This is where you are supposed to code the implementation of your objects. }
{----------------------------------------------------------------------------}

{$I RemObjects.inc}

interface

uses
  Classes, SysUtils, uROServer, MIT_Service_Intf;

type
  { TSrvWebchat }
  TSrvWebchat = class(TRORemotable, ISrvWebchat)
  private
    FEvent: string;
    FTaskID: Int64;
    procedure WriteLog(const nLog: string);
  protected
    { ISrvWebchat methods }
    function Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
  end;

implementation

uses
  UROModule, UBusinessWorker, UTaskMonitor, USysLoger, UMITConst;


procedure TSrvWebchat.WriteLog(const nLog: string);
begin
  gSysLoger.AddLog(TSrvWebchat, 'Web平台服务对象', nLog);
end;

//Date: 2012-3-7
//Parm: 函数名;[in]参数,[out]输出数据
//Desc: 执行以nData为参数的nFunName函数
function TSrvWebchat.Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
var nWorker: TBusinessWorkerBase;
begin
  FEvent := Format('TSrvWebchat.Action( %s )', [nFunName]);
  FTaskID := gTaskMonitor.AddTask(FEvent, 10 * 1000);
  //new task

  nWorker := nil;
  try
    nWorker := gBusinessWorkerManager.LockWorker(nFunName);
    try
      if nWorker.FunctionName = '' then
      begin
        nData := '远程调用失败(Worker Is Null).';
        Result := False;
        Exit;
      end;
      Result := nWorker.WorkActive(nData);
      //do action

      with ROModule.LockModuleStatus^ do
      try
        FNumWebChat := FNumWebChat + 1;
      finally
        ROModule.ReleaseStatusLock;
      end;
    except
      on E:Exception do
      begin
        Result := False;
        nData := E.Message;
        WriteLog('Function:[ ' + nFunName + ' ]' + E.Message);

        with ROModule.LockModuleStatus^ do
        try
          FNumActionError := FNumActionError + 1;
        finally
          ROModule.ReleaseStatusLock;
        end;
      end;
    end;
    //666666
//    if (not Result) and (Pos(#10#13, nData) < 1) then
//    begin
//      nData := Format('来源: %s,%s' + #13#10 + '对象: %s',
//               [gSysParam.FAppFlag, gSysParam.FLocalName,
//               nWorker.FunctionName]) + #13#10#13#10 + nData;
//      //xxxxx
//    end;
  finally
    gTaskMonitor.DelTask(FTaskID);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

end.
