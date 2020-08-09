unit UFrmBluetoothSet;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UAndroidFormBase, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView,

  Androidapi.JNI.BluetoothAdapter,
  Androidapi.JNI.JavaTypes,  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Android.JNI.Toast,
  //System.math,
  FMX.ListBox, FMX.Memo, FMX.Objects,
  System.Rtti, FMX.Grid, Data.Bind.GenData,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.ObjectScope,
  System.Bluetooth, System.Bluetooth.Components;


type
  TFrmBluetoothSet = class(TfrmFormBase)
    BtnCancel: TSpeedButton;
    BtnSave: TSpeedButton;
    lbl1: TLabel;
    btn1: TSpeedButton;
    lv1: TListView;
    blth1: TBluetooth;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv1ItemClick(const Sender: TObject; const AItem: TListViewItem);
  private
    FEQuipmentMAC:string;                  // remote MAC address of the selected
    ostream:JOutputStream;
    istream:JInputstream;
    uid:JUUID;                             // UUID for SPP traffic
    FSock:JBluetoothSocket;
    Adapter:JBluetoothAdapter;             // Local BLUETOOTH adapter
    remoteDevice:JBluetoothDevice;
  public
    { Public declarations }
  end;

var
  FrmBluetoothSet: TFrmBluetoothSet;

implementation
uses UBusinessConst, System.IniFiles, System.IOUtils, UBase64;

{$R *.fmx}

procedure TFrmBluetoothSet.BtnCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmBluetoothSet.BtnSaveClick(Sender: TObject);
begin
  with gSysParam do
  begin
    FOperator := '';
  end;

  Close;
end;

procedure TFrmBluetoothSet.FormShow(Sender: TObject);
var
  nStr:string;
  i:integer;
  list:TStringList;
begin
  list:= TStringList.Create;
  nStr:= checkBluetooth;                       // Make sure bluetooth is enabled
  Toast(nStr);
  if pos('disabled',nStr)<>0 then exit;

  // This is the well known SPP UUID for connection to a Bluetooth serial device
  uid:= TJUUID.JavaClass.fromString(stringtojstring('00001101-0000-1000-8000-00805F9B34FB'));

  list.Clear;
  list.AddStrings(getbonded);    // produce a list of bonded/paired devices
  for i := 0 to list.Count-1 do
  begin
    lv1.Items.Add;
    lv1.Items[i].Text  := list[i].Split(['='])[0];
    lv1.Items[i].Detail:= list[i].Split(['='])[1];
  end;
end;

procedure TFrmBluetoothSet.lv1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  Toast('选择设备：' + AItem.Text);
  if Trim(AItem.Detail) = '' then
    Exit;

  gSysParam.FBlthPrinterName:= AItem.Text;
  gSysParam.FBlthPrinterMAC := AItem.Detail;

  if Assigned(gBlthThread) then
    gBlthThread.ConnBluthPrinter;

  Exit;
  Adapter := TJBluetoothAdapter.JavaClass.getDefaultAdapter;
  remoteDevice := Adapter.getRemoteDevice(stringtojstring(AItem.Detail));
  Toast('已连接设备：' + AItem.Text + ' (' + AItem.Detail + ')');
  FSock := remoteDevice.createRfcommSocketToServiceRecord(UID);
  try
    FSock.connect;
  except
    Toast('创建连接服务失败!');
  end;
  if not FSock.isConnected then
  begin
    Toast('连接设备：' + AItem.Detail + ' 失败! 请重试...');
    exit;
  end;
  gSysParam.FBlthPrinterName:= AItem.Text;
  gSysParam.FBlthPrinterMAC := AItem.Detail;
  Toast('连接成功!');

  ostream := FSock.getOutputStream;           // record io streams
  istream := FSock.getInputStream;

  Application.ProcessMessages;

  ostream.write(ord(255)); //
  ostream.write(ord(255)); // get device id   (nur Chitanda)
  sleep(200);

end;

end.
