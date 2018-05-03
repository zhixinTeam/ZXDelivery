{*******************************************************************************
  作者: dmzn@163.com 2018-05-03
  描述: 远程业务调用
*******************************************************************************}
unit USysRemote;

{$I Link.Inc}
interface

uses
  Windows, Classes, UClientWorker, UManagerGroup, UBusinessConst,
  ULibFun, USysDB, USysConst, USysFun;

function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean = True): string;
//获取串行编号

implementation

//Date: 2018-05-03
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的业务命令对象
function CallBusinessCommand(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessCommand) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;

//Date: 2018-05-03
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessSaleBill(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessSaleBill) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;

//Date: 2018-05-03
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessPurchaseOrder(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessPurchaseOrder) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;

//Date: 2018-05-03
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessHardware(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessHardware) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;


//Date: 2018-05-03
//Parm: 命令;数据;参数;服务地址;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessWechat(const nCmd: Integer; const nData,nExt,nSrvURL: string;
  const nOut: PWorkerWebChatData; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerWebChatData;
    nWorker: TClient2MITWorker;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;
    nIn.FRemoteUL := nSrvURL;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    nWorker := gMG.FObjectPool.Lock(TClientBusinessWechat) as TClient2MITWorker;
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      nWorker.WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2018-05-03
//Parm: 分组;对象;使用日期编码模式
//Desc: 依据nGroup.nObject生成串行编号
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean): string;
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nList.Values['Group'] := nGroup;
    nList.Values['Object'] := nObject;

    if nUseDate then
         nStr := sFlag_Yes
    else nStr := sFlag_No;

    if CallBusinessCommand(cBC_GetSerialNO, nList.Text, nStr, @nOut) then
      Result := nOut.FData;
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

end.


