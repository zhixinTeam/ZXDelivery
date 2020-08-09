{*******************************************************************************
  作者: dmzn@163.com 2012-5-3
  描述: 数据模块
*******************************************************************************}
unit UDataModule;

interface

uses
  SysUtils, Classes, DB, ADODB, USysLoger;

type
  TFDM = class(TDataModule)
    ADOConn: TADOConnection;
    SQLQuery1: TADOQuery;
    SQLTemp: TADOQuery;
    Qry_OPer: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function SQLQuery(const nSQL: string; const nQuery: TADOQuery): TDataSet;
    //查询数据库
    function ExecuteSQL(const nSQL: string): integer;
    {*执行写操作*}
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TFDM, '数据模块', nEvent);
end;

//Date: 2012-5-3
//Parm: SQL;是否保持连接
//Desc: 执行SQL数据库查询
function TFDM.SQLQuery(const nSQL: string; const nQuery: TADOQuery): TDataSet;
var nInt: Integer;
begin
  Result := nil;
  nInt := 0;

  while nInt < 2 do
  try
    if not ADOConn.Connected then
      ADOConn.Connected := True;
    //xxxxx

    with nQuery do
    begin
      Close;
      SQL.Text := nSQL;
      Open;
    end;

    Result := nQuery;
    Exit;
  except
    on E:Exception do
    begin
      ADOConn.Connected := False;
      Inc(nInt);
      WriteLog(nSQL);
      WriteLog(E.Message);
    end;
  end;
end;

//Desc: 执行nSQL写操作
function TFDM.ExecuteSQL(const nSQL: string): integer;
var nStep : integer;
begin
  Result:= -1;
  nStep := 0;
  
  while nStep < 2 do
  try
    if not ADOConn.Connected then
      ADOConn.Connected := True;
    //xxxxx

    Qry_OPer.Close;
    Qry_OPer.SQL.Text := nSQL;
    Result := Qry_OPer.ExecSQL;

    Break;
  except
    on E:Exception do
    begin
      Inc(nStep);
      WriteLog(E.Message+' SQl:'+ nSQL);
      raise Exception.Create(E.Message);
    end;
  end;
end;



end.
