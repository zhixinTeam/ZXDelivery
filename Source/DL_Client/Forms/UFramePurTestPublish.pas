unit UFramePurTestPublish;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, dxSkinsdxLCPainter, cxContainer, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, dxLayoutControl, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, cxTextEdit, cxMaskEdit,
  cxButtonEdit, Menus, cxGridCustomPopupMenu, cxGridPopupMenu;

type
  TfFramePurTestPublish = class(TfFrameNormal)
    dxLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    FStart,FEnd: TDate;
    //ʱ������
  private
    procedure OnCreateFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurTestPublish: TfFramePurTestPublish;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, USysLoger,
  UBusinessPacker;


class function TfFramePurTestPublish.FrameID: integer;
begin
  Result := cFI_FramePurTestPublish;
end;

procedure TfFramePurTestPublish.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

function TfFramePurTestPublish.InitFormDataSQL(const nWhere: string): string;
VAR nYear, nMonth, nPreMonth:string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $SampleBatch Where S_Date>=''$STime'' And S_Date<''$ETime'' ' ;

  Result := MacroValue(Result, [MI('$SampleBatch', sTable_PurSampleBatch),
                            MI('$UMan', gSysParam.FUserName),
                            MI('$STime', Date2Str(FStart)), MI('$ETime', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFramePurTestPublish.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFramePurTestPublish.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
    nStr : string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    try
      nStr := 'UPDate %s Set S_Publish=''Y'', S_PublishDate=GetDate(), S_PublishMan=''%s''  Where R_ID=%s';
      nStr := Format(nStr, [sTable_PurSampleBatch, gSysParam.FUserName, SQLQuery.FieldByName('R_ID').AsString]);

      FDM.ExecuteSQL(nStr);
      InitFormData('');
      ShowMsg('�����ɹ�', '��ʾ');
    except
      ShowMsg('����ʧ��', '��ʾ');
    end;
  end;
end;

procedure TfFramePurTestPublish.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
    nStr : string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    try
      nStr := 'UPDate %s Set S_Publish=''N'', S_PublishDate=GetDate(), S_PublishMan=''%s''  Where R_ID=%s';
      nStr := Format(nStr, [sTable_PurSampleBatch, gSysParam.FUserName, SQLQuery.FieldByName('R_ID').AsString]);

      FDM.ExecuteSQL(nStr);
      InitFormData('');
      ShowMsg('�����ɹ�', '��ʾ');
    except
      ShowMsg('����ʧ��', '��ʾ');
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurTestPublish, TfFramePurTestPublish.FrameID);



end.
