{*******************************************************************************
  作者: dmzn@163.com 2018-03-15
  描述: 主窗口,调度其它模块
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, Dialogs,
  uniGUITypes, uniGUIAbstractClasses, uniGUIClasses, uniGUIRegClasses,
  uniGUIForm, uniLabel, uniMultiItem, uniComboBox, uniTreeView, uniImage,
  uniPanel, uniGUIBaseClasses, uniTimer, Vcl.Controls, uniStatusBar,
  uniPageControl, Vcl.Menus, uniMainMenu, uniSplitter, uniButton, uniMemo,
  uniCheckBox;

type
  TfFormMain = class(TUniForm)
    UniStatusBar1: TUniStatusBar;
    PanelTop: TUniSimplePanel;
    ImageRight: TUniImage;
    ImageLeft: TUniImage;
    PageWork: TUniPageControl;
    SheetWelcome: TUniTabSheet;
    PanelLeft: TUniPanel;
    UniSimplePanel3: TUniSimplePanel;
    ComboFactory: TUniComboBox;
    LabelFactory: TUniLabel;
    TreeMenu: TUniTreeView;
    UniSplitter1: TUniSplitter;
    UniPanel1: TUniPanel;
    LabelHint: TUniLabel;
    SheetMemory: TUniTabSheet;
    MemoMemory: TUniMemo;
    UniSimplePanel1: TUniSimplePanel;
    BtnFresh: TUniButton;
    CheckFriendly: TUniCheckBox;
    procedure UniFormCreate(Sender: TObject);
    procedure BtnFreshClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadFormConfig;
    //窗体配置
    procedure BuildMenuTree;
    //构建菜单树
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, Data.Win.ADODB, ULibFun,
  UManagerGroup, USysDB, USysFun, USysConst;

function fFormMain: TfFormMain;
begin
  Result := TfFormMain(UniMainModule.GetFormInstance(TfFormMain));
end;

//Date: 2018-04-19
//Desc: 初始化窗体配置
procedure TfFormMain.LoadFormConfig;
begin
  with UniMainModule.FUserConfig do
  begin
    Caption := FMainTitle;
    LabelHint.Caption := FHintText;
  end;

  PageWork.ActivePage := SheetWelcome;
  SheetMemory.Visible := UniMainModule.FUserConfig.FIsAdmin;

  ImageLeft.Url := sImageDir + 'top_left.bmp';
  ImageRight.Url := sImageDir + 'top_right.bmp';
end;

procedure TfFormMain.BtnFreshClick(Sender: TObject);
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    gMG.FObjectPool.GetStatus(nList, CheckFriendly.Checked);
    gMG.FObjectManager.GetStatus(nList, CheckFriendly.Checked);
    MemoMemory.Text := nList.Text;
  finally
    nList.Free;
  end;
end;

procedure TfFormMain.UniFormCreate(Sender: TObject);
begin
  LoadFormConfig;
  BuildMenuTree;
end;

//------------------------------------------------------------------------------
//Desc: 构建菜单树
procedure TfFormMain.BuildMenuTree;
var nStr: string;
    nQuery: TADOQuery;
begin
  TreeMenu.Items.Clear;
  nQuery := nil;
  try
    nQuery := LockDBQuery(ctMain);

  finally
    RelaseDBQuery(nQuery);
  end;
end;

initialization
  RegisterAppFormClass(TfFormMain);

end.
