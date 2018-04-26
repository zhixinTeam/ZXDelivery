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
  uniPanel, uniGUIBaseClasses, uniGUIFrame, Vcl.Menus, uniMainMenu, uniSplitter,
  uniCheckBox, uniButton, uniMemo, uniPageControl, Vcl.Controls, uniStatusBar;

type
  TfFormMain = class(TUniForm)
    StatusBar1: TUniStatusBar;
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
    PMenu1: TUniPopupMenu;
    N1: TUniMenuItem;
    N2: TUniMenuItem;
    N3: TUniMenuItem;
    BtnUpdateMemory: TUniButton;
    procedure UniFormCreate(Sender: TObject);
    procedure BtnFreshClick(Sender: TObject);
    procedure TreeMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure BtnUpdateMemoryClick(Sender: TObject);
    procedure TreeMenuClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadFormConfig;
    //窗体配置
    procedure CallBack_UpdateMemory(Sender: TComponent; Res: Integer);
    //对话框回调
    procedure TabSheetClose(Sender: TObject; var AllowClose: Boolean);
    //分页关闭
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, ULibFun, UManagerGroup,
  USysDB, USysFun, USysBusiness, USysConst;

function fFormMain: TfFormMain;
begin
  Result := TfFormMain(UniMainModule.GetFormInstance(TfFormMain));
end;

//Date: 2018-04-19
//Desc: 初始化窗体配置
procedure TfFormMain.LoadFormConfig;
var nStr: string;
begin
  ImageLeft.Url := sImageDir + 'top_left.bmp';
  ImageRight.Url := sImageDir + 'top_right.bmp';

  with UniMainModule.FUserConfig do
  begin
    Caption := FMainTitle;
    LabelHint.Caption := FHintText;

    nStr := '用户:【%s】 来自:【%s】 系统:【%s】 浏览器:【%s】';
    nStr := Format(nStr, [FUserID, FLocalIP, FOSUser, FUserAgent]);
    StatusBar1.SimpleText := nStr;
  end;

  PageWork.ActivePage := SheetWelcome;
  SheetMemory.Visible := UniMainModule.FUserConfig.FIsAdmin;
end;

procedure TfFormMain.UniFormCreate(Sender: TObject);
begin
  LoadFormConfig;
  BuidMenuTree(TreeMenu);
  GetFactoryList(ComboFactory.Items);
end;

//Desc: 刷新内存
procedure TfFormMain.BtnFreshClick(Sender: TObject);
begin
  LoadSystemMemoryStatus(MemoMemory.Lines, CheckFriendly.Checked);
end;

//Desc: 更新内存
procedure TfFormMain.BtnUpdateMemoryClick(Sender: TObject);
var nStr: string;
begin
  nStr := '服务器将重新加载配置数据,并断开所有连接.' + #13#10 +
          '继续操作请点"是"按钮.';
  MessageDlg(nStr, mtConfirmation, mbYesNo, CallBack_UpdateMemory);
end;

procedure TfFormMain.CallBack_UpdateMemory(Sender: TComponent; Res: Integer);
begin
  if Res = mrYes then ReloadSystemMemory;
end;

//------------------------------------------------------------------------------
procedure TfFormMain.TreeMenuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then PMenu1.Popup(X, Y, TreeMenu);
end;

procedure TfFormMain.N1Click(Sender: TObject);
begin
  TreeMenu.FullExpand;
end;

procedure TfFormMain.N3Click(Sender: TObject);
begin
  TreeMenu.FullCollapse;
end;

procedure TfFormMain.TreeMenuClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nForm: TUniForm;
    nMenu: PMenuModuleItem;
    nFrame: TUniFrame;
    nFrameClass: TUniFrameClass;
begin
  if (not Assigned(TreeMenu.Selected)) or
     (TreeMenu.Selected.HasChildren) then Exit;
  nIdx := Integer(TreeMenu.Selected.Data);

  nStr := GetMenuItemID(nIdx);
  if nStr = '' then Exit;
  //invalid menu

  for nIdx := gMenuModule.Count-1 downto 0 do
  begin
    nMenu := gMenuModule[nIdx];
    if CompareText(nMenu.FMenuID, nStr) <> 0 then Continue;
    //not match

    if nMenu.FItemType = mtForm then
    begin
      nForm := SystemGetForm(nMenu.FModule);
      if not Assigned(nForm) then
      begin
        nStr := '窗体类[ %s ]无效.';
        ShowMessage(Format(nStr, [nMenu.FModule]));
        Exit;
      end;

      nForm.ShowModalN;
      //show form
    end else

    if nMenu.FItemType = mtFrame then
    begin
      if not Assigned(nMenu.FTabSheet) then
      begin
        nFrameClass := TUniFrameClass(GetClass(nMenu.FModule));
        if not Assigned(nFrameClass) then
        begin
          nStr := 'Frame类[ %s ]无效.';
          ShowMessage(Format(nStr, [nMenu.FModule]));
          Exit;
        end;

        nMenu.FTabSheet := TUniTabSheet.Create(Self);
        with nMenu.FTabSheet do
        begin
          Pagecontrol := PageWork;
          Caption := TreeMenu.Selected.Text;

          Closable := True;
          OnClose := TabSheetClose;
          Tag := NativeInt(TreeMenu.Selected);
        end;

        nFrame := nFrameClass.Create(Self);
        nFrame.Parent := nMenu.FTabSheet;
        nFrame.Align := alClient;
      end;

      PageWork.ActivePage := nMenu.FTabSheet;
      //active
    end;
  end;
end;

procedure TfFormMain.TabSheetClose(Sender: TObject; var AllowClose: Boolean);
var nNode: TUniTreeNode;
begin
  nNode := Pointer((Sender as TUniTabSheet).Tag);
  if TreeMenu.Selected = nNode then
  begin
    TreeMenu.Selected := nil;
  end;
end;

initialization
  RegisterAppFormClass(TfFormMain);
end.
