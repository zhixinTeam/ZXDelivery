unit UFramePurTestVerify;

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
  TfFramePurTestVerify = class(TfFrameNormal)
    dxLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    FStart,FEnd: TDate;
    //时间区间
  private
    procedure OnCreateFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    class function FrameID: integer; override;
  end;

var
  fFramePurTestVerify: TfFramePurTestVerify;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, USysLoger,
  UBusinessPacker;


class function TfFramePurTestVerify.FrameID: integer;
begin
  Result := cFI_FramePurTestVerify;
end;

procedure TfFramePurTestVerify.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
end;

function TfFramePurTestVerify.InitFormDataSQL(const nWhere: string): string;
VAR nYear, nMonth, nPreMonth:string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $SampleBatch '+
            'Where S_TestDate>=''$STime'' And S_TestDate<''$ETime'' ' ;

  Result := MacroValue(Result, [MI('$SampleBatch', sTable_PurSampleBatch),
                                MI('$UMan', gSysParam.FUserName),
                                MI('$STime', Date2Str(FStart)),
                                MI('$ETime', Date2Str(FEnd + 1)) ]);
  //xxxxx
end;

procedure TfFramePurTestVerify.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFramePurTestVerify.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
    nStr : string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    try
      nStr := '确定要对[ %s %s ]的记录做审核么?';
      nStr := Format(nStr, [SQLQuery.FieldByName('S_BatID').AsString,
                            SQLQuery.FieldByName('S_MName').AsString  ]);
      if not QueryDlg(nStr, sAsk) then Exit;

      nStr := 'UPDate %s Set S_Verify=''Y'', S_VerifyDate=GetDate(), S_VerifyMan=''%s'' Where R_ID=%s ';
      nStr := Format(nStr, [sTable_PurSampleBatch, gSysParam.FUserName,
                            SQLQuery.FieldByName('R_ID').AsString]);

      FDM.ExecuteSQL(nStr);
      InitFormData('');
      ShowMsg('审核成功', '提示');
    except
      ShowMsg('审核失败', '提示');
    end;
  end;
end;

procedure TfFramePurTestVerify.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
    nStr : string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    try
      nStr := '确定要取消[ %s %s ]的审核么?';
      nStr := Format(nStr, [SQLQuery.FieldByName('S_BatID').AsString,
                            SQLQuery.FieldByName('S_MName').AsString  ]);
      if not QueryDlg(nStr, sAsk) then Exit;

      nStr := 'UPDate %s Set S_Verify=''N'', S_VerifyDate=GetDate(), S_VerifyMan=''%s''  Where R_ID=%s';
      nStr := Format(nStr, [sTable_PurSampleBatch, gSysParam.FUserName, SQLQuery.FieldByName('R_ID').AsString]);

      FDM.ExecuteSQL(nStr);
      InitFormData('');
      ShowMsg('已撤销审核', '提示');
    except
      ShowMsg('撤销失败', '提示');
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurTestVerify, TfFramePurTestVerify.FrameID);



end.
