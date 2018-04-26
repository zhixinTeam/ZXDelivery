{*******************************************************************************
  作者: dmzn@163.com 2018-04-25
  描述: Frame基类
*******************************************************************************}
unit UFrameBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, MainModule, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniToolBar, uniGUIBaseClasses, uniPanel, Data.DB,
  Datasnap.DBClient, uniBasicGrid, uniDBGrid, uniSplitter;

type
  TfFrameBase = class(TUniFrame)
    PanelWork: TUniContainerPanel;
    UniToolBar1: TUniToolBar;
    BtnAdd: TUniToolButton;
    BtnEdit: TUniToolButton;
    BtnDel: TUniToolButton;
    UniToolButton4: TUniToolButton;
    BtnRefresh: TUniToolButton;
    BtnPrint: TUniToolButton;
    BtnPreview: TUniToolButton;
    BtnExport: TUniToolButton;
    UniToolButton10: TUniToolButton;
    UniToolButton11: TUniToolButton;
    BtnExit: TUniToolButton;
    PanelQuick: TUniSimplePanel;
    DBGridMain: TUniDBGrid;
    ClientDS: TClientDataSet;
    DataSource1: TDataSource;
    SplitterTop: TUniSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
