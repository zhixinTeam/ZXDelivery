inherited fFrameBillSalePlan: TfFrameBillSalePlan
  Width = 898
  Height = 544
  inherited ToolBar1: TToolBar
    Width = 898
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Tag = 1
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Tag = 1
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 134
    Width = 898
    Height = 410
    LevelTabs.Slants.Kind = skCutCorner
    LevelTabs.Style = 9
    RootLevelOptions.DetailTabsPosition = dtpTop
    OnActiveTabChanged = cxGrid1ActiveTabChanged
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView1DblClick
    end
    object cxView2: TcxGridDBTableView [1]
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    inherited cxLevel1: TcxGridLevel
      Caption = '  '#21697#31181#24635#38480#37327#26126#32454'  '
    end
    object cxLevel2: TcxGridLevel
      Caption = '  '#21697#31181#12289#23458#25143#38480#37327#26126#32454'  '
      GridView = cxView2
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 898
    Height = 67
    object Edt_StockName: TcxButtonEdit [0]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object EditCus: TcxButtonEdit [1]
      Left = 269
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 155
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #21697#31181#21517#31216':'
          Control = Edt_StockName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 126
    Width = 898
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 898
    inherited TitleBar: TcxLabel
      Caption = #26597#35810#27700#38144#21806#21697#31181#38480#37327'  '#23458#25143#38480#37327
      Style.IsFontAssigned = True
      Width = 898
      AnchorX = 449
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 2
    Top = 262
  end
  inherited DataSource1: TDataSource
    Left = 30
    Top = 262
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 2
    Top = 318
    object N1: TMenuItem
      Caption = #26597#30475#21457#36135#22238#21333#26126#32454
      OnClick = N1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
  end
  object DataSource2: TDataSource
    DataSet = SQLNo1
    Left = 30
    Top = 290
  end
  object SQLNo1: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 2
    Top = 290
  end
end
