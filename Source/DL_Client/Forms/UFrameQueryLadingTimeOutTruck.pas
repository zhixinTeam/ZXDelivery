unit UFrameQueryLadingTimeOutTruck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, dxSkinsdxLCPainter, cxContainer, cxTextEdit,
  dxLayoutControl, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxCheckBox, ExtCtrls;

type
  TfFrameQueryLadingTimeOutTruck = class(TfFrameNormal)
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    edt_Time: TcxTextEdit;
    Chk1: TcxCheckBox;
    dxlytmLayout1Item3: TdxLayoutItem;
    tmr1: TTimer;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure Chk1PropertiesChange(Sender: TObject);
    procedure edt_TimeExit(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FStart,FEnd: TDate;
    //时间区间
  private
    procedure OnCreateFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //查询SQL
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFrameQueryLadingTimeOutTruck: TfFrameQueryLadingTimeOutTruck;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormDateFilter, USysPopedom, USysBusiness,
  UBusinessConst, USysConst, USysDB, UDataModule, UFormInputbox;



procedure TfFrameQueryLadingTimeOutTruck.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

class function TfFrameQueryLadingTimeOutTruck.FrameID: integer;
begin
  Result := cFI_FrameLadingTimeOutTruck;
end;

function TfFrameQueryLadingTimeOutTruck.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [DateTime2Str(FStart), DateTime2Str(FEnd + 1)]);

  Result := 'Select DateDiff(MINUTE,isNull(L_LadeTime,GetDate()),GETDATE()) TimeOut,* From $Bill '+
            'Where L_ID in (Select L_ID From S_LadingOutTime Where L_Date>=''$ST'' And L_Date<=''$End'') ';

  if nWhere <> '' then
      Result := Result + ' And (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$Bill', sTable_Bill), MI('$TimeOut', Trim(edt_Time.text)),
                                MI('$ST', DateTime2Str(FStart)), MI('$End', DateTime2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFrameQueryLadingTimeOutTruck.EditTruckPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  EditTruck.Text := Trim(EditTruck.Text);
  if EditTruck.Text = '' then Exit;

  FWhere := 'L_Truck like ''%%%s%%'' ';
  FWhere := Format(FWhere, [EditTruck.Text]);
  InitFormData(FWhere);
end;

procedure TfFrameQueryLadingTimeOutTruck.Chk1PropertiesChange(
  Sender: TObject);
begin
  tmr1.Enabled:= Chk1.Enabled;
  if Chk1.Checked then BtnRefresh.Click;
end;

procedure TfFrameQueryLadingTimeOutTruck.edt_TimeExit(Sender: TObject);
var nStr:string;
begin
  nStr := ' UPDate sys_Dict Set D_Value='+trim(edt_Time.Text)+
          ' Where  D_Name=''SanLadingOutTime'' ';
  FDM.ExecuteSQL(nStr);
end;

procedure TfFrameQueryLadingTimeOutTruck.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd, True) then InitFormData('');
end;

initialization
  gControlManager.RegCtrl(TfFrameQueryLadingTimeOutTruck, TfFrameQueryLadingTimeOutTruck.FrameID);

end.
