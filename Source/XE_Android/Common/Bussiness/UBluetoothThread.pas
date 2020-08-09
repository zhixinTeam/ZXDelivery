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
          //AddLog('�������й����з�����������ϵ�����Ա����');
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

//  nStr:= '������ʡ̫��ʯ����ˮ�����޹�˾'+#13#10 +
//         '���������� ԭ�����յ�'+#13#10 +
//         '��������������������������������'+#13#10 +
//         '�� Ӧ �̣�O20061400001'+#13#10 +
//         '������ţ�O20061400001'+#13#10 +
//         '�ɹ����ţ�D20061400001'+#13#10 +
//         '���ƺ��룺ԥGE2966'+#13#10 +
//         '����ë�أ�49.06����'+#13#10 +
//         '����Ƥ�أ�18.06����'+#13#10 +
//         '���տ��ӣ�3��������'+#13#10 +
//         '�������أ�28.06����';

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
    Toast('δ����������ӡ���������ú�ɴ�ӡƱ��!');
  end
  else
  begin
    FBlthUID:= TJUUID.JavaClass.fromString(stringtojstring('00001101-0000-1000-8000-00805F9B34FB'));
    //�����豸ID
    FAdapter := TJBluetoothAdapter.JavaClass.getDefaultAdapter;
    FemoteDevice := FAdapter.getRemoteDevice(stringtojstring(gSysParam.FBlthPrinterMAC));
    Toast('�������豸��' + gSysParam.FBlthPrinterName + ' (' + gSysParam.FBlthPrinterMAC + ')');
    FBluthSocket := FemoteDevice.createRfcommSocketToServiceRecord(FBlthUID);
    try
      FBluthSocket.connect;
    except
      Toast('������ӡ������ʧ�ܣ����޷���ӡƱ��!');
    end;

    if not FBluthSocket.isConnected then
    begin
      Toast('�����豸��' + gSysParam.FBlthPrinterMAC + ' ʧ��! ������...');
      exit;
    end;
    Toast('������ӡ�����ӳɹ�!');

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
