{*******************************************************************************
  作者: dmzn@163.com 2016-12-30
  描述: 模块业务对象
*******************************************************************************}
unit UWorkerBusinessOrder;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  UWorkerBusiness, UBusinessConst, UMgrDBConn, ULibFun, UFormCtrl, USysLoger,
  USysDB, UMITConst;

type
  TWorkerBusinessOrders = class(TMITDBWorker)
  private
    FListA,FListB,FListC,FListD: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton

    function SaveOrderBase(var nData: string):Boolean;
    function DeleteOrderBase(var nData: string):Boolean;
    function SaveOrder(var nData: string):Boolean;
    function DeleteOrder(var nData: string): Boolean;
    function SaveOrderCard(var nData: string): Boolean;
    function LogoffOrderCard(var nData: string): Boolean;
    function ChangeOrderTruck(var nData: string): Boolean;
    //修改车牌号
    function GetGYOrderValue(var nData: string): Boolean;
    //获取供应可收货量
    function GetKJReson(var nData: string): Boolean;
    //扣减原因

    function GetPostOrderItems(var nData: string): Boolean;
    //获取岗位采购单
    function SavePostOrderItems(var nData: string): Boolean;
    //保存岗位采购单
    function VerifyManualEventRecord(const nEID: string; var nHint: string;
      const nWant: string = sFlag_Yes; const nUpdateHint: Boolean = True): Boolean;
    //检查事件是否通过处理
    function AddManualEventRecord(const nEID,nKey,nEvent:string;
      const nFrom: string = sFlag_DepBangFang ;
      const nSolution: string = sFlag_Solution_YN;
      const nDepartmen: string = sFlag_DepDaTing;
      const nReset: Boolean = False; const nMemo: string = ''): Boolean;
    //添加待处理事项记录
    {$IFDEF  DoubleCheck}
    function GetYSRules(var nData: string):Boolean;
    function SaveWlbYS(var nData: string):Boolean;
    //保存物流部验收状态
    function GetWlbYsStatus(var nData: string):Boolean;
    //获取化验室验收结果
    {$ENDIF}
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation

class function TWorkerBusinessOrders.FunctionName: string;
begin
  Result := sBus_BusinessPurchaseOrder;
end;

constructor TWorkerBusinessOrders.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  FListD := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessOrders.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  FreeAndNil(FListD);
  inherited;
end;

function TWorkerBusinessOrders.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessOrders.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2015-8-5
//Parm: 输入数据
//Desc: 执行nData业务指令
function TWorkerBusinessOrders.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := '业务执行成功.';
  end;

  case FIn.FCommand of
   cBC_SaveOrder            : Result := SaveOrder(nData);
   cBC_DeleteOrder          : Result := DeleteOrder(nData);
   cBC_SaveOrderBase        : Result := SaveOrderBase(nData);
   cBC_DeleteOrderBase      : Result := DeleteOrderBase(nData);
   cBC_SaveOrderCard        : Result := SaveOrderCard(nData);
   cBC_LogoffOrderCard      : Result := LogoffOrderCard(nData);
   cBC_ModifyBillTruck      : Result := ChangeOrderTruck(nData);
   cBC_GetPostOrders        : Result := GetPostOrderItems(nData);
   cBC_SavePostOrders       : Result := SavePostOrderItems(nData);
   cBC_GetGYOrderValue      : Result := GetGYOrderValue(nData);

   cBC_GetKJReson           : Result := GetKJReson(nData);

   {$IFDEF  DoubleCheck}
   cBC_SaveWlbYS            : Result := SaveWlbYS(nData);
   cBC_GetWlbYsStatus       : Result := GetWlbYsStatus(nData);
   cBC_GetYSRules           : Result := GetYSRules(nData);
   {$ENDIF}
   else
    begin
      Result := False;
      nData := '无效的业务代码(Invalid Command).';
    end;
  end;
end;


function TWorkerBusinessOrders.SaveOrderBase(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nOut: TWorkerBusinessCommand;
begin
  FListA.Text := PackerDecodeStr(FIn.FData);
  //unpack Order

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    FListC.Values['Group'] :=sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_OrderBase;
    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := FOut.FData + nOut.FData + ',';
    //combine Order

    nStr := MakeSQLByStr([SF('B_ID', nOut.FData),
            SF('B_BStatus', FListA.Values['IsValid']),

            SF('B_Project', FListA.Values['Project']),
            SF('B_Area', FListA.Values['Area']),

            SF('B_Value', StrToFloat(FListA.Values['Value']),sfVal),
            SF('B_RestValue', StrToFloat(FListA.Values['Value']),sfVal),
            SF('B_LimValue', StrToFloat(FListA.Values['LimValue']),sfVal),
            SF('B_WarnValue', StrToFloat(FListA.Values['WarnValue']),sfVal),

            SF('B_SentValue', 0,sfVal),
            SF('B_FreezeValue', 0,sfVal),

            SF('B_ProID', FListA.Values['ProviderID']),
            SF('B_ProName', FListA.Values['ProviderName']),
            SF('B_ProPY', GetPinYinOfStr(FListA.Values['ProviderName'])),

            SF('B_SaleID', FListA.Values['SaleID']),
            SF('B_SaleMan', FListA.Values['SaleMan']),
            SF('B_SalePY', GetPinYinOfStr(FListA.Values['SaleMan'])),

            SF('B_StockType', sFlag_San),
            SF('B_StockNo', FListA.Values['StockNO']),
            SF('B_StockName', FListA.Values['StockName']),
            {$IFDEF DDChangeOrder}
            SF('B_OrderBz', FListA.Values['OrderBz']),
            {$ENDIF}
            SF('B_Man', FIn.FBase.FFrom.FUser),
            SF('B_Date', sField_SQLServer_Now, sfVal)
            ], sTable_OrderBase, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nIdx := Length(FOut.FData);
    if Copy(FOut.FData, nIdx, 1) = ',' then
      System.Delete(FOut.FData, nIdx, 1);
    //xxxxx
    
    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;
//------------------------------------------------------------------------------
//Date: 2015/9/19
//Parm: 
//Desc: 删除采购申请单
function TWorkerBusinessOrders.DeleteOrderBase(var nData: string): Boolean;
var nStr,nP: string;
    nIdx: Integer;
begin
  Result := False;
  //init

  nStr := 'Select Count(*) From %s Where O_BID=''%s''';
  nStr := Format(nStr, [sTable_Order, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if Fields[0].AsInteger > 0 then
    begin
      nData := '采购申请单[ %s ]已使用.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_OrderBase]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('B_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //所有字段,不包括删除

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $OB($FL,B_DelMan,B_DelDate) ' +
            'Select $FL,''$User'',$Now From $OO Where B_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$OB', sTable_OrderBaseBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$OO', sTable_OrderBase), MI('$ID', FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Delete From %s Where B_ID=''%s''';
    nStr := Format(nStr, [sTable_OrderBase, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2020/6/08
//Parm: 
//Desc: 获取扣减原因
function TWorkerBusinessOrders.GetKJReson(var nData: string): Boolean;
var nSQL, nReson : string;
begin
  Result := True;
  //init

  nSQL := 'Select * From $dict Where D_Name=''$Name''';
  nSQL := MacroValue(nSQL, [MI('$dict', sTable_SysDict),
                            MI('$Name', 'KJResonItem') ]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    while not Eof do
    begin
      nReson:= nReson + ',' + FieldByName('D_Value').AsString;

      Next;
    end;
  end;
  FOut.FData := PackerEncodeStr(nReson);
end;

//------------------------------------------------------------------------------
//Date: 2015/9/20
//Parm: 
//Desc: 获取供应可收货量
function TWorkerBusinessOrders.GetGYOrderValue(var nData: string): Boolean;
var nSQL: string;
    nVal, nSent, nLim, nWarn, nFreeze,nMax: Double;
begin
  Result := False;
  //init

  nSQL := 'Select B_Value,B_SentValue,B_RestValue, ' +
          'B_LimValue,B_WarnValue,B_FreezeValue ' +
          'From $OrderBase b1 inner join $Order o1 on b1.B_ID=o1.O_BID ' +
          'Where O_ID=''$ID''';
  nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
          MI('$Order', sTable_Order), MI('$ID', FIn.FData)]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount<1 then
    begin
      nData := '采购申请单[%s]信息已丢失';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nVal    := FieldByName('B_Value').AsFloat;
    nSent   := FieldByName('B_SentValue').AsFloat;
    nLim    := FieldByName('B_LimValue').AsFloat;
    nWarn   := FieldByName('B_WarnValue').AsFloat;
    nFreeze := FieldByName('B_FreezeValue').AsFloat;

    nMax := nVal - nSent - nFreeze;
  end;  

  with FListB do
  begin
    Clear;

    if nVal>0 then
         Values['NOLimite'] := sFlag_No
    else Values['NOLimite'] := sFlag_Yes;

    Values['MaxValue']    := FloatToStr(nMax);
    Values['LimValue']    := FloatToStr(nLim);
    Values['WarnValue']   := FloatToStr(nWarn);
    Values['FreezeValue'] := FloatToStr(nFreeze);
  end;

  FOut.FData := PackerEncodeStr(FListB.Text);
  Result := True;
end;

//Date: 2015-8-5
//Desc: 保存采购单
function TWorkerBusinessOrders.SaveOrder(var nData: string): Boolean;
var nStr, nOId: string;
    nIdx: Integer;
    nVal: Double;
    nOut: TWorkerBusinessCommand;
begin
  FListA.Text := PackerDecodeStr(FIn.FData);
  nVal := StrToFloat(FListA.Values['Value']);
  //unpack Order

  nStr := FListA.Values['Truck'];
  TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo,nStr, '',@nOut);
  //保存车牌号

  {$IFDEF BusinessOnly}
  nStr := 'Select R_ID,T_Bill,T_StockNo,T_Type,T_InFact,T_Valid From %s ' +
          'Where T_Truck=''%s'' ';
  nStr := Format(nStr, [sTable_ZTTrucks, FListA.Values['Truck']]);
  //还在队列中车辆

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      nStr := '车辆[ %s ]在未完成[ %s ]交货单之前禁止开单.';
      nData := Format(nStr, [FListA.Values['Truck'], FieldByName('T_Bill').AsString]);
      Exit;
    end;
  end;
  {$ENDIF}
  {$IFDEF OrderOnlyOneCard}    
  nStr := 'select O_ID from %s where O_Truck=''%s'' and O_Card<>'''' ';
  nStr := Format(nStr,[sTable_Order, FListA.Values['Truck']]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount>0 then
    begin
      Result := False;
      FOut.FBase.FResult := False;
      nStr := '车辆[ %s ]在未完成[ %s ]采购单之前禁止开单.';
      nData := Format(nStr, [FListA.Values['Truck'], FieldByName('O_ID').AsString]);
      Fout.FBase.FErrDesc := nData;
      Exit;
    end;
  end;
  {$ENDIF}

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    FListC.Values['Group']  := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_Order;

    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);

    nOId:= nOut.FData;
    //xxxxx

    FOut.FData := FOut.FData + nOut.FData + ',';
    //combine Order

    nStr := MakeSQLByStr([SF('O_ID', nOut.FData),

            SF('O_CType', FListA.Values['CardType']),
            SF('O_Project', FListA.Values['Project']),
            SF('O_Area', FListA.Values['Area']),

            SF('O_BID', FListA.Values['SQID']),
            SF('O_Value', nVal,sfVal),

            SF('O_ProID', FListA.Values['ProviderID']),
            SF('O_ProName', FListA.Values['ProviderName']),
            SF('O_ProPY', GetPinYinOfStr(FListA.Values['ProviderName'])),

            SF('O_SaleID', FListA.Values['SaleID']),
            SF('O_SaleMan', FListA.Values['SaleMan']),
            SF('O_SalePY', GetPinYinOfStr(FListA.Values['SaleMan'])),

            SF('O_Type', sFlag_San),
            SF('O_StockNo', FListA.Values['StockNO']),
            SF('O_StockName', FListA.Values['StockName']),

            {$IFDEF KuangFa}
            SF('O_KFValue', FListA.Values['KFValue']),
            SF('O_KFLS', FListA.Values['KFLS']),
            {$ENDIF}

            {$IFDEF UseKuangDian}
            SF('O_KD', FListA.Values['KD']),
            {$ENDIF}

            {$IFDEF PurYSAfterAutoPoundP}
            SF('O_AutoDoP', FListA.Values['AutoPoundP']),
            {$ENDIF}

            SF('O_Truck', FListA.Values['Truck']),
            SF('O_Man', FIn.FBase.FFrom.FUser),
            SF('O_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Order, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    if FListA.Values['CardType'] = sFlag_OrderCardL then
    begin
      nStr := 'Update %s Set B_FreezeValue=B_FreezeValue+%.2f ' +
              'Where B_ID = ''%s'' and B_Value>0';
      nStr := Format(nStr, [sTable_OrderBase, nVal,FListA.Values['SQID']]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    if FListA.Values['BuDan'] = sFlag_Yes then //补单
    begin
      FListC.Clear;
      FListC.Values['Group'] := sFlag_BusGroup;
      FListC.Values['Object'] := sFlag_OrderDtl;

      if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      nStr := MakeSQLByStr([
              SF('D_ID', nOut.FData),
              SF('D_OID', nOId),
              SF('D_Truck', FListA.Values['Truck']),
              SF('D_ProID', FListA.Values['ProviderID']),
              SF('D_ProName', FListA.Values['ProviderName']),
              SF('D_ProPY', GetPinYinOfStr(FListA.Values['ProviderName'])),

              SF('D_Type', sFlag_San),
              SF('D_StockNo', FListA.Values['StockNO']),
              SF('D_StockName', FListA.Values['StockName']),

              SF('D_Status', sFlag_TruckOut),
              SF('D_NextStatus', ''),
              SF('D_InMan', ''),
              SF('D_InTime', sField_SQLServer_Now, sfVal),
              SF('D_PMan', FIn.FBase.FFrom.FUser),
              SF('D_MMan', FIn.FBase.FFrom.FUser),
              SF('D_YMan', ''),
              SF('D_PValue', FListA.Values['PValue']),
              SF('D_Value', nVal,sfVal),
              SF('D_KZValue', '0')
              ], sTable_OrderDtl, '', True);

      gDBConnManager.WorkerExec(FDBConn, nStr);

      nStr:= 'UPDate P_OrderDtl Set D_MValue=D_Value+D_PValue, D_InTime= DATEADD(MI, 2, D_InTime), D_YSResult=''Y'' '+
             'Where D_ID='''+nOut.FData+'''';
      gDBConnManager.WorkerExec(FDBConn, nStr);

      nStr:= 'UPDate P_OrderDtl Set D_MDate= DATEADD(MI, 0, D_InTime) Where D_ID='''+nOut.FData+'''';
      gDBConnManager.WorkerExec(FDBConn, nStr);

      nStr:= 'UPDate P_OrderDtl Set D_YTime= DATEADD(MI, 0, D_MDate)  Where D_ID='''+nOut.FData+'''';
      gDBConnManager.WorkerExec(FDBConn, nStr);

      nStr:= 'UPDate P_OrderDtl Set D_PDate= DATEADD(MI, 0, D_YTime)  Where D_ID='''+nOut.FData+'''';
      gDBConnManager.WorkerExec(FDBConn, nStr);

      nStr:= 'UPDate P_OrderDtl Set D_OutFact= DATEADD(MI, 0, D_PDate) Where D_ID='''+nOut.FData+'''';
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    nIdx := Length(FOut.FData);
    if Copy(FOut.FData, nIdx, 1) = ',' then
      System.Delete(FOut.FData, nIdx, 1);
    //xxxxx
    
    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2015-8-5
//Desc: 保存采购单
function TWorkerBusinessOrders.DeleteOrder(var nData: string): Boolean;
var nStr,nP: string;
    nIdx: Integer;
begin
  Result := False;
  //init

  nStr := 'Select Count(*) From %s Where D_OID=''%s''';
  nStr := Format(nStr, [sTable_OrderDtl, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if Fields[0].AsInteger > 0 then
    begin
      nData := '采购单[ %s ]已使用.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_Order]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('O_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //所有字段,不包括删除

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $OB($FL,O_DelMan,O_DelDate) ' +
            'Select $FL,''$User'',$Now From $OO Where O_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$OB', sTable_OrderBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$OO', sTable_Order), MI('$ID', FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Delete From %s Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: 采购订单[FIn.FData];磁卡号[FIn.FExtParam]
//Desc: 为采购单绑定磁卡
function TWorkerBusinessOrders.SaveOrderCard(var nData: string): Boolean;
var nStr,nSQL: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    if FIn.FData <> '' then
    begin
      nSQL := 'Update %s Set O_Card=Null Where O_Card=''%s''';
      nSQL := Format(nSQL, [sTable_Order, FIn.FExtParam]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nSQL := 'Update %s Set D_Card=Null Where D_Card=''%s''';
      nSQL := Format(nSQL, [sTable_OrderDtl, FIn.FExtParam]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nSQL := 'Update %s Set C_Status=''%s'', C_Used=Null Where C_Card=''%s''';
      nSQL := Format(nSQL, [sTable_Card, sFlag_CardInvalid, FIn.FExtParam]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nStr := AdjustListStrFormat(FIn.FData, '''', True, ',', False);
      //重新计算列表

      nSQL := 'Update %s Set O_Card=''%s'' Where O_ID In(%s)';
      nSQL := Format(nSQL, [sTable_Order, FIn.FExtParam, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nSQL := 'Update %s Set D_Card=''%s'' Where D_OID In(%s) and D_OutFact Is NULL';
      nSQL := Format(nSQL, [sTable_OrderDtl, FIn.FExtParam, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    nStr := 'Select Count(*) From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FExtParam]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if Fields[0].AsInteger < 1 then
    begin
      nStr := MakeSQLByStr([SF('C_Card', FIn.FExtParam),
              SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Provide),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, '', True);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else
    begin
      nStr := Format('C_Card=''%s''', [FIn.FExtParam]);
      nStr := MakeSQLByStr([SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Provide),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, nStr, False);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2015-8-5
//Desc: 保存采购单
function TWorkerBusinessOrders.LogoffOrderCard(var nData: string): Boolean;
var nStr: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set O_Card=Null Where O_Card=''%s''';
    nStr := Format(nStr, [sTable_Order, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Update %s Set D_Card=Null Where D_Card=''%s''';
    nStr := Format(nStr, [sTable_OrderDtl, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Update %s Set C_Status=''%s'', C_Used=Null Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, sFlag_CardInvalid, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessOrders.ChangeOrderTruck(var nData: string): Boolean;
var nStr: string;
begin
  //Result := False;
  //Init

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set O_Truck=''%s'' Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, FIn.FExtParam, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //更新修改信息

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: 磁卡号[FIn.FData];岗位[FIn.FExtParam]
//Desc: 获取特定岗位所需要的交货单列表
function TWorkerBusinessOrders.GetPostOrderItems(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nIsOrder: Boolean;
    nBills: TLadingBillItems;
begin
  Result := False;
  nIsOrder := False;

  nStr := 'Select B_Prefix, B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_Order]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nIsOrder := (Pos(Fields[0].AsString, FIn.FData) = 1) and
               (Length(FIn.FData) = Fields[1].AsInteger);
    //前缀和长度都满足采购单编码规则,则视为采购单号
  end;

  if not nIsOrder then
  begin
    nStr := 'Select C_Status,C_Freeze From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FData]);
    //card status

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('磁卡[ %s ]信息已丢失.', [FIn.FData]);
        Exit;
      end;

      if Fields[0].AsString <> sFlag_CardUsed then
      begin
        nData := '磁卡[ %s ]当前状态为[ %s ],无法提货.';
        nData := Format(nData, [FIn.FData, CardStatusToStr(Fields[0].AsString)]);
        Exit;
      end;

      if Fields[1].AsString = sFlag_Yes then
      begin
        nData := '磁卡[ %s ]已被冻结,无法提货.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;
    end;
  end;

  nStr := 'Select O_ID,O_Card,O_ProID,O_ProName,O_Type,O_StockNo,' +
          'O_StockName,O_Truck,O_Value ' +
          {$IFDEF PurYSAfterAutoPoundP} ',O_AutoDoP ' +{$ENDIF}
          'From $OO oo ';
  //xxxxx

  if nIsOrder then
       nStr := nStr + 'Where O_ID=''$CD'''
  else nStr := nStr + 'Where O_Card=''$CD''';

  nStr := MacroValue(nStr, [MI('$OO', sTable_Order),MI('$CD', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      if nIsOrder then
           nData := '采购单[ %s ]已无效.'
      else nData := '磁卡号[ %s ]无订单';

      nData := Format(nData, [FIn.FData]);
      Exit;
    end else
    with FListA do
    begin
      Clear;

      Values['O_ID']         := FieldByName('O_ID').AsString;
      Values['O_ProID']      := FieldByName('O_ProID').AsString;
      Values['O_ProName']    := FieldByName('O_ProName').AsString;
      Values['O_Truck']      := FieldByName('O_Truck').AsString;

      Values['O_Type']       := FieldByName('O_Type').AsString;
      Values['O_StockNo']    := FieldByName('O_StockNo').AsString;
      Values['O_StockName']  := FieldByName('O_StockName').AsString;

      Values['O_Card']       := FieldByName('O_Card').AsString;
      Values['O_Value']      := FloatToStr(FieldByName('O_Value').AsFloat);

      {$IFDEF PurYSAfterAutoPoundP}
      Values['AutoDoP']      := FieldByName('O_AutoDoP').AsString;
      {$ENDIF}
    end;
  end;

  {$IFDEF SendUnLoadPlace}
  nStr := 'Select D_ID,D_OID,D_PID,D_YLine,D_Status,D_NextStatus,' +
          'D_KZValue,D_Memo,D_YSResult,D_UPlace,D_SPlace,' +
          'P_PStation,P_PValue,P_PDate,P_PMan,' +
          'P_MStation,P_MValue,P_MDate,P_MMan ' +
          'From $OD od Left join $PD pd on pd.P_Order=od.D_ID ' +
          'Where D_OutFact Is Null And D_OID=''$OID''';
  //xxxxx
  {$ELSE}
    {$IFDEF UseYCLHY}
    nStr := 'Select D_ID,D_OID,D_PID,D_YLine,D_Status,D_NextStatus,D_SerialNo,' +
            'D_KZValue,D_Memo,D_YSResult,' +
            'P_PStation,P_PValue,P_PDate,P_PMan,' +
            'P_MStation,P_MValue,P_MDate,P_MMan ' +
            'From $OD od Left join $PD pd on pd.P_Order=od.D_ID ' +
            'Where D_OutFact Is Null And D_OID=''$OID''';
    {$ELSE}
    nStr := 'Select D_ID,D_OID,D_PID,D_YLine,D_Status,D_NextStatus,' +
            'D_KZValue,D_Memo,D_YSResult,' +
            'P_PStation,P_PValue,P_PDate,P_PMan,' +
            'P_MStation,P_MValue,P_MDate,P_MMan ' +
            'From $OD od Left join $PD pd on pd.P_Order=od.D_ID ' +
            'Where D_OutFact Is Null And D_OID=''$OID''';
    {$ENDIF}
  //xxxxx
  {$ENDIF}

  nStr := MacroValue(nStr, [MI('$OD', sTable_OrderDtl),
                            MI('$PD', sTable_PoundLog),
                            MI('$OID', FListA.Values['O_ID'])]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then
    begin
      SetLength(nBills, 1);

      with nBills[0], FListA do
      begin
        FZhiKa      := Values['O_ID'];
        FCusID      := Values['O_ProID'];
        FCusName    := Values['O_ProName'];
        FTruck      := Values['O_Truck'];

        FType       := Values['O_Type'];
        FStockNo    := Values['O_StockNo'];
        FStockName  := Values['O_StockName'];
        FValue      := StrToFloat(Values['O_Value']);
        FAutoDoP    := Values['AutoDoP'];

        FCard       := Values['O_Card'];
        FStatus     := sFlag_TruckNone;
        FNextStatus := sFlag_TruckNone;

        FSelected := True;
      end;  
    end else
    begin
      SetLength(nBills, RecordCount);

      nIdx := 0;

      First; 
      while not Eof do
      with nBills[nIdx], FListA do
      begin
        FID         := FieldByName('D_ID').AsString;
        FZhiKa      := FieldByName('D_OID').AsString;
        FPoundID    := FieldByName('D_PID').AsString;

        FCusID      := Values['O_ProID'];
        FCusName    := Values['O_ProName'];
        FTruck      := Values['O_Truck'];

        FType       := Values['O_Type'];
        FStockNo    := Values['O_StockNo'];
        FStockName  := Values['O_StockName'];
        FValue      := StrToFloat(Values['O_Value']);
        FAutoDoP    := Values['AutoDoP'];

        FCard       := Values['O_Card'];
        FStatus     := FieldByName('D_Status').AsString;
        FNextStatus := FieldByName('D_NextStatus').AsString;

        if (FStatus = '') or (FStatus = sFlag_BillNew) then
        begin
          FStatus     := sFlag_TruckNone;
          FNextStatus := sFlag_TruckNone;
        end;

        with FPData do
        begin
          FStation  := FieldByName('P_PStation').AsString;
          FValue    := FieldByName('P_PValue').AsFloat;
          FDate     := FieldByName('P_PDate').AsDateTime;
          FOperator := FieldByName('P_PMan').AsString;
        end;

        with FMData do
        begin
          FStation  := FieldByName('P_MStation').AsString;
          FValue    := FieldByName('P_MValue').AsFloat;
          FDate     := FieldByName('P_MDate').AsDateTime;
          FOperator := FieldByName('P_MMan').AsString;
        end;

        FKZValue  := FieldByName('D_KZValue').AsFloat;
        FMemo     := FieldByName('D_Memo').AsString;
        FYSValid  := FieldByName('D_YSResult').AsString;
        {$IFDEF UseYCLHY}
        FSerialNo := FieldByName('D_SerialNo').AsString;
        {$ENDIF}
        if Assigned(FindField('D_UPlace')) then
          FUPlace := FieldByName('D_UPlace').AsString;

        if Assigned(FindField('D_SPlace')) then
          FSPlace := FieldByName('D_SPlace').AsString;

        FSelected := True;

        Inc(nIdx);
        Next;
      end;
    end;    
  end;

  FOut.FData := CombineBillItmes(nBills);
  Result := True;
end;

//Date: 2014-09-18
//Parm: 交货单[FIn.FData];岗位[FIn.FExtParam]
//Desc: 保存指定岗位提交的交货单列表
function TWorkerBusinessOrders.SavePostOrderItems(var nData: string): Boolean;
var nVal, nValWC, nPrePValue,nMValue: Double;
    nIdx: Integer;
    nStr,nSQL,nDID: string;
    nPreValue: Double;
    nPound: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
    nOutEx: TWorkerBusinessCommand;
begin
  Result := False;
  AnalyseBillItems(FIn.FData, nPound);
  //解析数据

  FListA.Clear;
  //用于存储SQL列表

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckIn then //进厂
  begin
    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_OrderDtl;

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
        FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx
    with nPound[0] do
    begin
      {$IFDEF UseYCLHY}
      FListD.Clear;
      FListD.Values['Group']  := sFlag_BusGroup;
      FListD.Values['Object'] := FStockNo;

      if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListD.Text, sFlag_Yes, @nOutEx) then
        raise Exception.Create(nOutEx.FData);
      //xxxxx
      {$ENDIF}
      
      nPreValue := 0;
      nStr := 'Select T_PrePValue From %s Where T_Truck = ''%s'' and isnull(T_PrePUse,''N'') = ''Y''  ';
      nStr := Format(nStr, [sTable_Truck, FTruck]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        nPreValue := Fields[0].AsFloat;
      end;

      if nPreValue = 0 then
      begin
        nSQL := MakeSQLByStr([
              SF('D_ID', nOut.FData),
              SF('D_Card', FCard),
              SF('D_OID', FZhiKa),
              SF('D_Truck', FTruck),
              SF('D_ProID', FCusID),
              SF('D_ProName', FCusName),
              SF('D_ProPY', GetPinYinOfStr(FCusName)),

              SF('D_Type', FType),
              SF('D_StockNo', FStockNo),
              SF('D_StockName', FStockName),
              {$IFDEF UseYCLHY}
              SF('D_SerialNo', nOutEx.FData),
              {$ENDIF}
              SF('D_Status', sFlag_TruckIn),
              SF('D_NextStatus', sFlag_TruckBFP),
              SF('D_InMan', FIn.FBase.FFrom.FUser),
              SF('D_InTime', sField_SQLServer_Now, sfVal)
              ], sTable_OrderDtl, '', True);
        FListA.Add(nSQL);
      end
      else
      begin
        nDID := nOut.FData;
        nSQL := MakeSQLByStr([
              SF('D_ID', nOut.FData),
              SF('D_Card', FCard),
              SF('D_OID', FZhiKa),
              SF('D_Truck', FTruck),
              SF('D_ProID', FCusID),
              SF('D_ProName', FCusName),
              SF('D_ProPY', GetPinYinOfStr(FCusName)),

              SF('D_Type', FType),
              SF('D_StockNo', FStockNo),
              SF('D_StockName', FStockName),
              {$IFDEF UseYCLHY}
              SF('D_SerialNo', nOutEx.FData),
              {$ENDIF}
              SF('D_Status', sFlag_TruckBFP),
              SF('D_NextStatus', sFlag_TruckBFM),
              SF('D_PValue', nPreValue, sfVal),
              SF('D_PDate', sField_SQLServer_Now, sfVal),
              SF('D_InMan', FIn.FBase.FFrom.FUser),
              SF('D_InTime', sField_SQLServer_Now, sfVal)
              ], sTable_OrderDtl, '', True);
        FListA.Add(nSQL);
        
        FListC.Clear;
        FListC.Values['Group']  := sFlag_BusGroup;
        FListC.Values['Object'] := sFlag_PoundID;

        if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
                FListC.Text, sFlag_Yes, @nOut) then
          raise Exception.Create(nOut.FData);
        //xxxxx

        FOut.FData := nOut.FData;
        //返回榜单号,用于拍照绑定
        with nPound[0] do
        begin
          FStatus     := sFlag_TruckBFP;
          FNextStatus := sFlag_TruckBFM;

          nSQL := MakeSQLByStr([
                SF('P_ID', nOut.FData),
                SF('P_Type', sFlag_Provide),
                SF('P_Order', nDID),
                SF('P_Truck', FTruck),
                SF('P_CusID', FCusID),
                SF('P_CusName', FCusName),
                SF('P_MID', FStockNo),
                SF('P_MName', FStockName),
                SF('P_MType', FType),
                SF('P_LimValue', 0),
                SF('P_PValue', nPreValue, sfVal),
                SF('P_PDate', sField_SQLServer_Now, sfVal),
                SF('P_FactID', FFactory),
                SF('P_PStation', FPData.FStation),
                SF('P_Direction', '进厂'),
                SF('P_PModel', FPModel),
                SF('P_Status', sFlag_TruckBFP),
                SF('P_Valid', sFlag_Yes),
                SF('P_PrintNum', 1, sfVal)
                ], sTable_PoundLog, '', True);
          FListA.Add(nSQL);
        end;
      end;
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFP then //称量皮重
  begin
    FListB.Clear;
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        FListB.Add(Fields[0].AsString);
        Next;
      end;
    end;

    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_PoundID;

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := nOut.FData;
    //返回榜单号,用于拍照绑定
    with nPound[0] do
    begin
      FStatus := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckXH;

      if FListB.IndexOf(FStockNo) >= 0 then
        FNextStatus := sFlag_TruckBFM;
      //现场不发货直接过重

      nSQL := MakeSQLByStr([
            SF('P_ID', nOut.FData),
            SF('P_Type', sFlag_Provide),
            SF('P_Order', FID),
            SF('P_Truck', FTruck),
            SF('P_CusID', FCusID),
            SF('P_CusName', FCusName),
            SF('P_MID', FStockNo),
            SF('P_MName', FStockName),
            SF('P_MType', FType),
            SF('P_LimValue', 0),
            SF('P_PValue', FPData.FValue, sfVal),
            SF('P_PDate', sField_SQLServer_Now, sfVal),
            SF('P_PMan', FIn.FBase.FFrom.FUser),
            SF('P_FactID', FFactory),
            SF('P_PStation', FPData.FStation),
            SF('P_Direction', '进厂'),
            SF('P_PModel', FPModel),
            SF('P_Status', sFlag_TruckBFP),
            SF('P_Valid', sFlag_Yes),
            SF('P_PrintNum', 1, sfVal)
            ], sTable_PoundLog, '', True);
      FListA.Add(nSQL);

      nSQL := MakeSQLByStr([
              SF('D_Status', FStatus),
              SF('D_NextStatus', FNextStatus),
              SF('D_PValue', FPData.FValue, sfVal),
              SF('D_PDate', sField_SQLServer_Now, sfVal),
              SF('D_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL);
    end;  

  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckXH then //验收现场
  begin
    with nPound[0] do
    begin
      FStatus := sFlag_TruckXH;
      FNextStatus := sFlag_TruckBFM;

      nStr := SF('P_Order', FID);

      //where
      nSQL := MakeSQLByStr([
                SF('P_KZValue', FKZValue, sfVal)
                ], sTable_PoundLog, nStr, False);
        //验收扣杂
       FListA.Add(nSQL);


      {$IFDEF UseYCLHY}
      nSQL := MakeSQLByStr([
              SF('D_Status', FStatus),
              SF('D_NextStatus', FNextStatus),
              SF('D_YTime', sField_SQLServer_Now, sfVal),
              SF('D_YMan', FIn.FBase.FFrom.FUser),
              SF('D_KZValueEx', FKZValue, sfVal),
              SF('D_YSResult', FYSValid),
              SF('D_Unload',   FHKRecord),
              {$IFDEF SendUnLoadPlace}
              SF('D_UPlace', FUPlace),
              SF('D_SPlace', FSPlace),
              {$ENDIF}
              SF('D_Memo', FMemo)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL);
      {$ELSE}
      nSQL := MakeSQLByStr([
              SF('D_Status', FStatus),
              SF('D_NextStatus', FNextStatus),
              SF('D_YTime', sField_SQLServer_Now, sfVal),
              SF('D_YMan', FIn.FBase.FFrom.FUser),
              SF('D_KZValue', FKZValue, sfVal),
              SF('D_YSResult', FYSValid),
              SF('D_Unload',   FHKRecord),
              {$IFDEF YSAddMemo}
              SF('D_YLineName', FMemo2),
              {$ENDIF}
              {$IFDEF SendUnLoadPlace}
              SF('D_UPlace', FUPlace),
              SF('D_SPlace', FSPlace),
              {$ENDIF}
              SF('D_Memo', FMemo)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL);
      {$ENDIF}

      if FNewOrder <> '' then//切换申请单
      begin
        nSQL := MakeSQLByStr([
                SF('D_ProID', FCusID),
                SF('D_ProName', FCusName),
                SF('D_ProPY', GetPinYinOfStr(FCusName)),
                SF('D_StockNo', FStockNo),
                SF('D_StockName', FStockName)
                ], sTable_OrderDtl, SF('D_ID', FID), False);
        FListA.Add(nSQL);
        WriteLog('切换申请单更新采购明细SQL:' + nSQL);

        nSQL := MakeSQLByStr([
                SF('O_BID', FNewOrder),
                SF('O_ProID', FCusID),
                SF('O_ProName', FCusName),
                SF('O_ProPY', GetPinYinOfStr(FCusName)),
                SF('O_StockNo', FStockNo),
                SF('O_StockName', FStockName)
                ], sTable_Order, SF('O_ID', FZhiKa), False);
        FListA.Add(nSQL);
        WriteLog('切换申请单更新采购单SQL:' + nSQL);
        nSQL := MakeSQLByStr([
                SF('P_CusID', FCusID),
                SF('P_CusName', FCusName),
                SF('P_MID', FStockNo),
                SF('P_MName', FStockName)
                ], sTable_PoundLog, nStr, False);
        FListA.Add(nSQL);
        WriteLog('切换申请单更新采购磅单SQL:' + nSQL);
      end;

      {$IFDEF PurYSAfterAutoPoundP}
      //对设置自动结算订单做重量结算（太阳石）
        nStr := 'Select * From %s Where O_ID=''%s'' ';
        nStr := Format(nStr, [sTable_Order, FZhiKa]);
        with gDBConnManager.WorkerQuery(FDBConn, nStr) do
        if RecordCount > 0 then
        begin
          First;
          FAutoDoP:= FieldByName('O_AutoDoP').AsString;
        end;
                                  
      IF FAutoDoP = sFlag_Yes then
      begin
        WriteLog(Format('采购单：%s %s 已设置自动结算皮重',[FZhiKa, FID]));

        nStr := 'Select isNull(T_PrePValue, 0) PrePValue From %s Where T_Truck=''%s''';
        nStr := Format(nStr, [sTable_Truck, FTruck]);
        with gDBConnManager.WorkerQuery(FDBConn, nStr) do
        if RecordCount > 0 then
        begin
          First;
          nPrePValue:= FieldByName('PrePValue').AsFloat;
        end;
        WriteLog(Format('采购单：%s %s 预置皮重: %g ',[FID, FTruck, nPrePValue]));

        if nPrePValue>0 then
        begin
          if FMData.FValue>FPData.FValue then
            nMValue:= FMData.FValue
          else nMValue:=FPData.FValue;

          nVal:= nMValue-nPrePValue-FKZValue;
          if FYSValid='N' then nVal:= 0;
          //如果拒收，净重为 0
          
          nSQL := MakeSQLByStr([
                  SF('D_Status', sFlag_TruckBFM),
                  SF('D_NextStatus', sFlag_TruckOut),
                  SF('D_PValue', nPrePValue, sfVal),
                  SF('D_PDate', sField_SQLServer_Now, sfVal),
                  SF('D_PMan', '系统预置'),
                  SF('D_MValue', nMValue, sfVal),
                  SF('D_MDate', DateTime2Str(FPData.FDate)),
                  SF('D_MMan', FPData.FOperator),
                  SF('D_Value', nVal, sfVal)
                  ], sTable_OrderDtl, SF('D_ID', FID), False);
          FListA.Add(nSQL);

          nSQL := 'UPDate Sys_PoundLog Set P_PDate=D_PDate, P_PValue=D_PValue, P_PMan=D_PMan, ' +
                                          'P_MDate=D_MDate, P_MValue=D_MValue, P_MMan=D_MMan,P_KZValue=D_KZValue ' +
                  'From P_OrderDtl Where P_Order=D_ID And P_Order='''+FID+'''';
          FListA.Add(nSQL);
          //更新称重记录

          nSQL := 'UPDate $OrderBase Set B_SentValue=B_SentValue+$Val, B_FreezeValue=B_FreezeValue-$KDVal ' +
                  'Where B_ID = (select O_BID From $Order Where O_ID=''$ID'')';
          nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
                                    MI('$Order', sTable_Order),MI('$ID', FZhiKa),
                                    MI('$Val', FloatToStr(nVal)),
                                    MI('$KDVal', FloatToStr(FValue))  ]);
          FListA.Add(nSQL);
          //调整已收货量、冻结量；

          WriteLog(Format('采购单：%s %s 系统自动做重量结算',[FID, FTruck]));
        end;
      end;
      {$ENDIF}
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFM then //称量毛重
  begin
    with nPound[0] do
    begin
      nStr := SF('P_Order', FID);
      //where

      nVal := FMData.FValue - FPData.FValue -FKZValue;

      if FYSValid='N' then nVal:= 0;
      //如果拒收，净重为 0
      
      if FNextStatus = sFlag_TruckBFP then
      begin
        nSQL := MakeSQLByStr([
                SF('P_PValue', FPData.FValue, sfVal),
                SF('P_PDate', sField_SQLServer_Now, sfVal),
                SF('P_PMan', FIn.FBase.FFrom.FUser),
                SF('P_PStation', FPData.FStation),
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', DateTime2Str(FMData.FDate)),
                SF('P_MMan', FMData.FOperator),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //称重时,由于皮重大,交换皮毛重数据
        FListA.Add(nSQL);

        nSQL := MakeSQLByStr([
                SF('D_Status', sFlag_TruckBFM),
                SF('D_NextStatus', sFlag_TruckOut),
                SF('D_PValue', FPData.FValue, sfVal),
                SF('D_PDate', sField_SQLServer_Now, sfVal),
                SF('D_PMan', FIn.FBase.FFrom.FUser),
                SF('D_MValue', FMData.FValue, sfVal),
                SF('D_MDate', DateTime2Str(FMData.FDate)),
                SF('D_MMan', FMData.FOperator),
                SF('D_Value', nVal, sfVal)
                ], sTable_OrderDtl, SF('D_ID', FID), False);
        FListA.Add(nSQL);

      end else
      begin
        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //xxxxx
        FListA.Add(nSQL);

        nSQL := MakeSQLByStr([
                SF('D_Status', sFlag_TruckBFM),
                SF('D_NextStatus', sFlag_TruckOut),
                SF('D_MValue', FMData.FValue, sfVal),
                SF('D_MDate', sField_SQLServer_Now, sfVal),
                SF('D_MMan', FMData.FOperator),
                SF('D_Value', nVal, sfVal)
                ], sTable_OrderDtl, SF('D_ID', FID), False);
        FListA.Add(nSQL);
      end;

      if FYSValid <> sFlag_NO then  //验收成功，调整已收货量
      begin
        nSQL := 'Update $OrderBase Set B_SentValue=B_SentValue+$Val ' +
                'Where B_ID = (select O_BID From $Order Where O_ID=''$ID'')';
        nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
                MI('$Order', sTable_Order),MI('$ID', FZhiKa),
                MI('$Val', FloatToStr(nVal))]);
        FListA.Add(nSQL);
        //调整已收货；
      end;

      nSQL := 'Update $OrderBase Set B_FreezeValue=B_FreezeValue-$KDVal ' +
              'Where B_ID = (select O_BID From $Order Where O_ID=''$ID'''+
              ' And O_CType= ''L'') and B_Value>0';
      nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
              MI('$Order', sTable_Order),MI('$ID', FZhiKa),
              MI('$KDVal', FloatToStr(FValue))]);
      FListA.Add(nSQL);
      //调整冻结量

      nSQL := 'Select P_ID From %s Where P_Order=''%s'' And P_MValue Is Null';
      nSQL := Format(nSQL, [sTable_PoundLog, FID]);
      //未称毛重记录

      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      if RecordCount > 0 then
      begin
        FOut.FData := Fields[0].AsString;
      end;
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckOut then
  begin
    //恒宇建材
    {$IFDEF HYJC}
    nSQL := 'select * from %s where D_Name=''%s'' and D_Value=''%s''';
    nSQL := Format(nSQL,[sTable_SysDict,sFlag_CheckPurNetWC,nPound[0].FStockNo]);
    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if recordcount >0 then
    begin
      nValWC := FieldByName('D_ParamA').asfloat;
      nSQL := 'select * from %s where D_ID=''%s''';
      nSQL := Format(nSQL,[sTable_OrderDtl,nPound[0].FID]);
      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      begin
        //误差量超过设定值，则推送事件提醒
        if nValWC < Abs(FieldByName('D_Value').AsFloat - nPound[0].FValue)*1000 then
        begin
          nValWC := Abs(FieldByName('D_Value').AsFloat - nPound[0].FValue)*1000;
          nStr := '车辆[ %s ]实时皮重误差较大,详情如下:' + #13#10 +
              '※.实际净重: %.2f吨' + #13#10 +
              '※.票重: %.2f吨' + #13#10 +
              '※.误差量: %.2f公斤' + #13#10 +
              '允许出厂,请选是;禁止过磅,请选否.';
          nStr := Format(nStr,[nPound[0].FTruck,FieldByName('D_Value').AsFloat,
                  nPound[0].FValue,nValWC]);

          if not VerifyManualEventRecord(nPound[0].FID + sFlag_ManualC, nStr,
            sFlag_Yes, False) then
          begin
            AddManualEventRecord(nPound[0].FID + sFlag_ManualC, nPound[0].FTruck, nStr,
                sFlag_DepDaTing, sFlag_Solution_YN, sFlag_DepDaTing, True);
            nData := nStr;
            WriteLog(nStr);
            Exit;
          end;
        end;
      end;
    end;
    {$ENDIF}

    with nPound[0] do
    begin
      nSQL := MakeSQLByStr([SF('D_Status', sFlag_TruckOut),
              SF('D_NextStatus', ''),
              SF('D_Card', ''),
              SF('D_OutFact', sField_SQLServer_Now, sfVal),
              SF('D_OutMan', FIn.FBase.FFrom.FUser)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL); //更新采购单
    end;

    {$IFDEF UseERP_K3}
    {$IFNDEF NoSyncPurK3}
    nStr := nPound[0].FID;
    if not TWorkerBusinessCommander.CallMe(cBC_SyncStockOrder, nStr, '', @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;
    {$ENDIF}
    {$ENDIF}

    nSQL := 'Select O_CType,O_Card From %s Where O_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Order, nPound[0].FZhiKa]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      nStr := FieldByName('O_Card').AsString;
      if FieldByName('O_CType').AsString = sFlag_OrderCardL then
      if not CallMe(cBC_LogOffOrderCard, nStr, '', @nOut) then
      begin
        nData := nOut.FData;
        Exit;
      end;
    end;
    //如果是临时卡片，则注销卡片
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;

  if FIn.FExtParam = sFlag_TruckBFM then //称量毛重
  begin
    if Assigned(gHardShareData) then
      gHardShareData('TruckOut:' + nPound[0].FCard);
    //磅房处理自动出厂
  end;
end;

//Date: 2014-09-15
//Parm: 命令;数据;参数;输出
//Desc: 本地调用业务对象
class function TWorkerBusinessOrders.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nPacker.InitData(@nIn, True, False);
    //init
    
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(FunctionName);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

{$IFDEF DoubleCheck}
function TWorkerBusinessOrders.GetYSRules(var nData: string): Boolean;
var
  nStr:string;
begin
  Result := true;
  nStr := 'select * from %s where M_ID=''%s''';
  nStr := Format(nStr,[sTable_Materails,FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if recordcount = 0 then
    begin
      Result := False;
      nData := '不存在该[ %s ]物料品种.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    FOut.FData := FieldByName('M_YS2Times').AsString;
    FOut.FExtParam := FieldByName('M_HYSYS').AsString;
  end;
end;

function TWorkerBusinessOrders.SaveWlbYS(var nData: string): Boolean;
var
  nPound: TLadingBillItems;
  nSQL: string;
begin
  Result := False;
  
  AnalyseBillItems(FIn.FData, nPound);
  with nPound[0] do
  begin
    try
      nSQL := MakeSQLByStr([
                SF('D_WlbYTime', sField_SQLServer_Now, sfVal),
                SF('D_WlbYMan', FIn.FBase.FFrom.FUser),
                SF('D_WlbYS', FYSValid)
                ], sTable_OrderDtl, SF('D_ID', FID), False);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
      Result := True;
    except
      raise;
    end;
  end;
end;

function TWorkerBusinessOrders.GetWlbYsStatus(var nData: string): Boolean;
var
  nStr: string;
begin
  Result := False;
  nStr := 'select * from %s where M_ID=''%s''';
  nStr := Format(nStr,[sTable_Materails,FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if FieldByName('M_YS2Times').AsString = sFlag_Yes then
    begin
      nStr := 'select * from %s where D_ID=''%s''';
      nStr := Format(nStr,[sTable_OrderDtl,FIn.FExtParam]);
      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      begin
        if FieldByName('D_WlbYS').AsString <> sFlag_Yes then
          Result := True;
      end;
    end;
  end;
end;
{$ENDIF}

function TWorkerBusinessOrders.VerifyManualEventRecord(const nEID: string;
  var nHint: string; const nWant: string;
  const nUpdateHint: Boolean): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select E_Result, E_Event From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nEID]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := Trim(FieldByName('E_Result').AsString);
    if nStr = '' then
    begin
      if nUpdateHint then
        nHint := FieldByName('E_Event').AsString;
      Exit;
    end;

    if nStr <> nWant then
    begin
      if nUpdateHint then
        nHint := '请联系管理员，做换票处理';
      Exit;
    end;

    Result := True;
  end;
end;

function TWorkerBusinessOrders.AddManualEventRecord(const nEID, nKey,
  nEvent, nFrom, nSolution, nDepartmen: string; const nReset: Boolean;
  const nMemo: string): Boolean;
var nStr: string;
    nUpdate: Boolean;
begin
  Result := False;
  if Trim(nSolution) = '' then
  begin
    WriteLog('请选择处理方案.');
    Exit;
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nEID]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := '事件记录:[ %s ]已存在';
    WriteLog(Format(nStr, [nEID]));

    if not nReset then Exit;
    nUpdate := True;
  end else nUpdate := False;

  nStr := SF('E_ID', nEID);
  nStr := MakeSQLByStr([
          SF('E_ID', nEID),
          SF('E_Key', nKey),
          SF('E_From', nFrom),
          SF('E_Memo', nMemo),
          SF('E_Result', 'Null', sfVal),

          SF('E_Event', nEvent),
          SF('E_Solution', nSolution),
          SF('E_Departmen', nDepartmen),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx

  gDBConnManager.WorkerExec(FDBConn, nStr);
  Result := True;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessOrders, sPlug_ModuleBus);
end.
