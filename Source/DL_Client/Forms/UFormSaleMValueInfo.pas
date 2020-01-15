{*******************************************************************************
  作者: dmzn@163.com 2014-11-25
  描述: 矿点信息管理
*******************************************************************************}
unit UFormSaleMValueInfo;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox;

type
  TfFormSaleMValueInfo = class(TfFormNormal)
    EditMValueMax: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FRID: string;
    procedure LoadFormData;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst;

class function TfFormSaleMValueInfo.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  
  with TfFormSaleMValueInfo.Create(Application) do
  try
    LoadFormData;
    ShowModal;
  finally
    Free;
  end;
end;

class function TfFormSaleMValueInfo.FormID: integer;
begin
  Result := cFI_FormSaleMValueInfo;
end;

procedure TfFormSaleMValueInfo.LoadFormData;
var nStr: string;
begin
  nStr := 'Select * From %s ';
  nStr := Format(nStr, [sTable_SaleMValueInfo]);
  FDM.QueryTemp(nStr);

  with FDM.SqlTemp do
  begin
    if (RecordCount < 1) then
    begin
      Exit;
    end;
    FRID               := FieldByName('R_ID').AsString;
    EditMValueMax.Text := FieldByName('S_MValueMax').AsString;
  end;
end;

//Desc: 保存
procedure TfFormSaleMValueInfo.BtnOKClick(Sender: TObject);
var nStr,nNum1,nU,nV,nP,nVip,nGps,nEvent: string;
begin
  nNum1 := UpperCase(Trim(EditMValueMax.Text));
  if nNum1 = '' then
  begin
    ActiveControl := EditMValueMax;
    ShowMsg('请输入毛重上限值', sHint);
    Exit;
  end;

  if FRID <> '' then
  begin
    nStr := ' Update %s set S_MValueMax=%g  where R_ID = ''%s'' ';
    nStr := Format(nStr,[sTable_SaleMValueInfo,StrToFloat(EditMValueMax.Text),FRID]);
    FDM.ExecuteSQL(nStr);
  end
  else
  begin
    nStr := MakeSQLByStr([SF('S_MValueMax', EditMValueMax.Text)
            ], sTable_SaleMValueInfo, '', True);
    FDM.ExecuteSQL(nStr);
  end;

  ModalResult := mrOk;
  ShowMsg('毛重上限设置成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormSaleMValueInfo, TfFormSaleMValueInfo.FormID);
end.
