unit UBluetoothThread;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants, System.SysUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  Androidapi.JNI.BluetoothAdapter,
  Androidapi.JNI.JavaTypes,  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Android.JNI.Toast,   uTasks,
  //System.math,
  FMX.ListBox, FMX.Layouts, FMX.Memo, FMX.Edit, FMX.Objects, FMX.ListView.Types,
  FMX.ListView, System.Rtti, FMX.Grid, Data.Bind.GenData,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation ;

type
  TBluetoothThread = class(TThread)
  private
    FIsCanPrint: Boolean;
    FOutStream : JOutputStream;
    FInStream  : JInputstream;
    FBlthUID:JUUID;                             // UUID for SPP traffic
    FBluthSocket:JBluetoothSocket;
    FAdapter : JBluetoothAdapter;             // Local BLUETOOTH adapter
    FemoteDevice:JBluetoothDevice;

    FPriorTaskManager : TTasks;
  protected
    procedure Execute; override;
    procedure SendPrintTXT(nStr: string);
  public
    constructor Create(CreateSuspended:Boolean);overload;
    destructor  Destroy;override;
    procedure   ConnBluthPrinter;
    property    PriorityTaskManager : TTasks read FPriorTaskManager;
  end;

implementation

{ TBluetoothThread }

uses UBusinessConst;


procedure TBluetoothThread.Execute;
var nTask : TTaskType;
    LastSplitGoodsTime : TDateTime;
begin
  while not Terminated do
  begin
    try
      try
        FillChar(nTask, SizeOf(TTaskType), #0);
        //********************************************************
        nTask:= FPriorTaskManager.GetFirstTask;

        if nTask.nCardMM<>'' then
          SendPrintTXT(nTask.nCardMM);
        //**********************************************************
        //**********************************************************
      except
        begin
          //AddLog('程序运行过程中发生错误、请联系相关人员处理');
        end;
      end;
    finally
    end;
  end;
end;

procedure TBluetoothThread.SendPrintTXT(nStr: string);
var
  i:integer;
  StrStream: TStringStream;
  nOneB: Byte;
begin
  if not FIsCanPrint then Exit;

//  nStr:= '　河南省太阳石集团水泥有限公司'+#13#10 +
//         '　　　　　 原料验收单'+#13#10 +
//         '————————————————'+#13#10 +
//         '供 应 商：O20061400001'+#13#10 +
//         '订单编号：O20061400001'+#13#10 +
//         '采购单号：D20061400001'+#13#10 +
//         '车牌号码：豫GE2966'+#13#10 +
//         '车辆毛重：49.06　吨'+#13#10 +
//         '车辆皮重：18.06　吨'+#13#10 +
//         '验收扣杂：3　　　吨'+#13#10 +
//         '净　　重：28.06　吨';

  nStr:= #13#10 + nStr +
          #13#10#13#10#13#10#13#10#13#10#13#10#13#10#13#10#13#10#13#10#13#10;

  StrStream := TStringStream.Create(nStr, TEncoding.ANSI);    //  TEncoding.UTF8  TEncoding.Default
  for nOneB in StrStream.Bytes do
    FOutStream.Write(( nOneB )); // einmal senden mit 255 am anfang     ostream.write(ord( nOneB ));
end;

procedure TBluetoothThread.ConnBluthPrinter;
begin
  FIsCanPrint:= False;
  if gSysParam.FBlthPrinterMAC='' then
  begin
    Toast('未设置蓝牙打印机，需设置后可打印票据!');
  end
  else
  begin
    FBlthUID:= TJUUID.JavaClass.fromString(stringtojstring('00001101-0000-1000-8000-00805F9B34FB'));
    //蓝牙设备ID
    FAdapter := TJBluetoothAdapter.JavaClass.getDefaultAdapter;
    FemoteDevice := FAdapter.getRemoteDevice(stringtojstring(gSysParam.FBlthPrinterMAC));
    Toast('已连接设备：' + gSysParam.FBlthPrinterName + ' (' + gSysParam.FBlthPrinterMAC + ')');
    FBluthSocket := FemoteDevice.createRfcommSocketToServiceRecord(FBlthUID);
    try
      FBluthSocket.connect;
    except
      Toast('蓝牙打印机连接失败，将无法打印票据!');
    end;

    if not FBluthSocket.isConnected then
    begin
      Toast('连接设备：' + gSysParam.FBlthPrinterMAC + ' 失败! 请重试...');
      exit;
    end;
    Toast('蓝牙打印机连接成功!');

    ////****************************************
    FOutStream := FBluthSocket.getOutputStream;    // record io streams
    FInStream  := FBluthSocket.getInputStream;

    FOutStream.write(ord(255)); //
    FOutStream.write(ord(255)); // get device id   (nur Chitanda)

    FIsCanPrint:= True;
  end;
end;

constructor TBluetoothThread.Create(CreateSuspended:Boolean);
begin
  inherited Create(CreateSuspended);
  ConnBluthPrinter;

  FreeOnTerminate:= False;
  FPriorTaskManager:= TTasks.Create;
  //*****************************
end;

destructor TBluetoothThread.Destroy;
begin
  FPriorTaskManager.Free;
  inherited;
end;



end.
