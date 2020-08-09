unit uTasks;

interface
uses
  SysUtils, Variants, Classes, uGlobal;

type

  PTTaskType = ^TTaskType;
  TTaskType = record
    nTskIdx  : Integer;
    ItemId   : string;     //
    nCardMM  : string;     //
    nLast    : string;
  end;

  TTasks = class
  private
    FTaskList : TThreadList;
    FTaskIndex : Integer;
    FConfigFilePath : string;
  private
    function  GetTaskCount:Integer;
    function  GetTask(nIndex:Integer):TTaskType;
  public
    constructor Create;
    destructor  Destroy;override;
    function    GetNextTask:TTaskType;
    procedure   ClearTask;

    function    GetFirstTask: TTaskType;
    function    IsExistedTask(szItemId:string):Boolean;
    function    FindTask(szItemId:string):TTaskType;
    function    AddTask(Task: TTaskType): Boolean;

    procedure   SetStartPos(TskIdx: Integer);
  public
    property    TaskCount : Integer read GetTaskCount;
    property    TaskList[nIndex : Integer] : TTaskType read GetTask;
    property    ConfigFilePath : string read FConfigFilePath write FConfigFilePath;
  end;

implementation


{ TTasks }

procedure TTasks.ClearTask;
var
  List : TList;
  pTask : PTTaskType;
begin
  try
    List := FTaskList.LockList;
    while List.Count > 0 do
    begin
      pTask := List.Items[0];
      List.Remove(pTask);
      FreeMem(pTask);
    end;
  finally
    FTaskList.UnlockList;
  end;
end;

constructor TTasks.Create;
begin
  FTaskList := TThreadList.Create;
  FTaskIndex := 0;
end;

destructor TTasks.Destroy;
begin
  ClearTask;
  FTaskList.Free;
  inherited;
end;

function TTasks.AddTask(Task: TTaskType): Boolean;
var
  List : TList;
  pTask : PTTaskType;
begin
  Result:= False;
  try
    List := FTaskList.LockList;
    GetMem(pTask,SizeOf(TTaskType));
    FillChar(pTask^,SizeOf(TTaskType),#0);
    pTask^ := Task;
    List.Add(pTask);
    Result := True;
  finally
    FTaskList.UnlockList;
  end;
end;

function TTasks.IsExistedTask(szItemId:string):Boolean;
var
  List : TList;
  I: Integer;
  pTask : PTTaskType;
begin
  Result:= False;
  try
    List := FTaskList.LockList;
    for I := 0 to List.Count - 1 do
    begin
      pTask := List.Items[I];
      if (pTask^.ItemId = szItemId) then
      begin
        Result:= True;
        Break;
      end;
    end;
  finally
    FTaskList.UnlockList;
  end;
end;

function TTasks.FindTask(szItemId:string):TTaskType;
var
  List : TList;
  I: Integer;
  pTask : PTTaskType;
begin
  try
    List := FTaskList.LockList;
    for I := 0 to List.Count - 1 do
    begin
      pTask := List.Items[I];
      if (pTask^.ItemId = szItemId) then
      begin
        Result := pTask^;
        Break;
      end;
    end;
  finally
    FTaskList.UnlockList;
  end;
end;

function TTasks.GetFirstTask: TTaskType;
var
  List : TList;
  pTaskType : PTTaskType;
begin
  FillChar(Result,SizeOf(TTaskType),#0);
  try
    List:= FTaskList.LockList;
    if List.Count > 0 then
    begin
      pTaskType := List.Items[0];
      Result := pTaskType^;
      List.Remove(pTaskType);
      FreeMem(pTaskType);
    end;
  finally
    FTaskList.UnlockList;
  end;
end;

function TTasks.GetNextTask: TTaskType;
var
  List : TList;
  pTaskType : PTTaskType;
begin
  try
    List := FTaskList.LockList;
    if FTaskIndex >= List.Count then
    begin
      FTaskIndex := 0;
    end;
    pTaskType := List.Items[FTaskIndex];
    Result := pTaskType^;
    Inc(FTaskIndex);
  finally
    FTaskList.UnlockList;
  end;
end;

function TTasks.GetTask(nIndex: Integer): TTaskType;
var
  List : TList;
  pTask : PTTaskType;
begin
  FillChar(Result,SizeOf(TTaskType),#0);
  try
    List := FTaskList.LockList;
    if nIndex < List.Count then
    begin
      pTask := List.Items[nIndex];
      Result := pTask^;
    end;
  finally
    FTaskList.UnlockList;
  end;
end;

procedure TTasks.SetStartPos(TskIdx: Integer);
var
  List : TList;
  I: Integer;
  pTask : PTTaskType;
begin
  try
    List := FTaskList.LockList;
    for I := 0 to List.Count - 1 do
    begin
      pTask := List.Items[I];
      if pTask^.nTskIdx = TskIdx then
      begin
        FTaskIndex := I;
        Break;
      end;
    end;
    if I >= List.Count then
    begin
      FTaskIndex := 0;
    end;
  finally
    FTaskList.UnlockList;
  end;
end;

function TTasks.GetTaskCount: Integer;
var
  List : TList;
begin
  try
    List := FTaskList.LockList;
    Result := List.Count;
  finally
    FTaskList.UnlockList;
  end;
end;


end.

