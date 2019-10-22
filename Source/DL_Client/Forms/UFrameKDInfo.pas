unit UFrameKDInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, dxLayoutControl, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, USysConst;

type
  TfFrameKDInfo = class(TfFrameNormal)
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFrameKDInfo: TfFrameKDInfo;

implementation
  uses UMgrControl, USysDB, UFormBase, UDataModule, ULibFun;
{$R *.dfm}

procedure TfFrameKDInfo.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormKDInfo, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

class function TfFrameKDInfo.FrameID: integer;
begin
  Result := cFI_FrameKDInfo;
end;

function TfFrameKDInfo.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_KDInfo;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
end;

procedure TfFrameKDInfo.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('R_ID').AsString;
    CreateBaseFormItem(cFI_FormKDInfo, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

procedure TfFrameKDInfo.BtnDelClick(Sender: TObject);
var nStr,nKDInfo,nEvent: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nKDInfo := SQLQuery.FieldByName('S_KDName').AsString;
    nStr    := Format('ȷ��Ҫɾ�����[ %s ]��?', [nKDInfo]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_KDInfo, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);

    nEvent := 'ɾ��[ %s ]�����Ϣ.';
    nEvent := Format(nEvent, [nKDInfo]);
    FDM.WriteSysLog(sFlag_CommonItem, nKDInfo, nEvent);

    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameKDInfo, TfFrameKDInfo.FrameID);

end.
