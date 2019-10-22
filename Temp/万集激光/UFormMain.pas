unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrWJLaser, ExtCtrls, StdCtrls, TeEngine, Series, TeeProcs, Chart;

type
  TfFormMain = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    Chart1: TChart;
    Series1: TLineSeries;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoLog(const nEvent: string);
    procedure OnData(const nLaser: PWJLaserHost);
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  ULibFun, USysLoger;

var
  gPath: string;

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TWJLaserManager, '����װ�����', nEvent);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogEvent := DoLog;
  gSysLoger.LogSync := True;

  gWJLaserManager := TWJLaserManager.Create;
  with gWJLaserManager do
  begin
    LoadConfig('D:\Program Files\MyVCL\znlib\Hardware\WJLaser.xml');
    EventMode := emMain;
    OnCardEvent := OnData;
  end;
end;

procedure TfFormMain.DoLog(const nEvent: string);
begin
  if Memo1.Lines.Count > 150 then
  begin
    while Memo1.Lines.Count > 100 do
      Memo1.Lines.Delete(0);
    //xxxxx
  end;

  Memo1.Lines.Add(nEvent)
end;

procedure TfFormMain.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
       gWJLaserManager.StartService
  else gWJLaserManager.StopService;
end;

//Date: 2019-10-21
//Parm: ������������
//Desc: ������չʾ
procedure TfFormMain.OnData(const nLaser: PWJLaserHost);
var nIdx: Integer;
    nReal: Integer;
begin
  if nLaser.FDPrecision then
       nReal := nLaser.FDataParse[360].Fy
  else nReal := nLaser.FDataParse[180].Fy; //���·��߶�

  if not nLaser.FTruckExists then
  begin
    WriteLog(Format('������[ %s.%s ]�߶�[ %dmm ],δ��⵽����,', [nLaser.FID,
      nLaser.FName, nReal]));
    Exit;
  end;

  Series1.Clear;
  for nIdx:=0 to cLaserDataParse do
  with nLaser.FDataParse[nIdx] do
  begin
    if FAngle < 0 then Break;
    Series1.AddXY(Fx, Fy);
  end;

  WriteLog(Format('������:[ %s.%s ] ���·�:[ %d-%d=%d ] ��ͷ����:[ %d,%d ] ' +
    '��β����:[ %d,%d ] ����߶�:[ %d ] ���᳤��:[ %d ]', [nLaser.FID,
    nLaser.FName, nLaser.FHighLaser, nReal, nLaser.FHighUnderLaser, 
    nLaser.FOffsetFrontLaser, nLaser.FHighFrontLaser,
    nLaser.FOffsetBackLaser, nLaser.FHighBackLaser,
    nLaser.FTruckHigh, nLaser.FTruckLong]));
  //xxxxx

end;

procedure TfFormMain.Button1Click(Sender: TObject);
var nVal, nVal1, nVal2: Double;
begin
  nVal := 679;
  nVal1 := Cos(120 * Pi / 180);
  nVal2 := nVal * Sin(120 * Pi / 180);
  WriteLog(Format('X=%.2f  Y=%.2f', [nVal1, nVal2]));
end;

end.
