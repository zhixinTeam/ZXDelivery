inherited fFramePurSampleHYData: TfFramePurSampleHYData
  Width = 1213
  Height = 425
  inherited ToolBar1: TToolBar
    Width = 1213
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 135
    Width = 815
    Height = 290
    Align = alLeft
    inherited cxView1: TcxGridDBTableView
      OnCellDblClick = cxView1CellDblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1213
    Height = 68
    object lbl1: TLabel [0]
      Left = 268
      Top = 36
      Width = 326
      Height = 17
      AutoSize = False
      Caption = '      '#24038#20391#21015#34920#65306#21462#26679#35760#24405'     '#21491#20391#21015#34920#65306#21270#39564#32467#26524#24405#20837#13#10'         '
      Color = clWindow
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object EditDate: TcxButtonEdit [1]
      Left = 87
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 0
      Width = 176
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #26085#26399#36873#25321#65306
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          ShowCaption = False
          Control = lbl1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 127
    Width = 1213
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1213
    inherited TitleBar: TcxLabel
      Caption = #21407#26009#26679#21697#21270#39564#32467#26524#24405#20837
      Style.IsFontAssigned = True
      Width = 1213
      AnchorX = 607
      AnchorY = 11
    end
  end
  object cxspltr1: TcxSplitter [5]
    Left = 815
    Top = 135
    Width = 5
    Height = 290
    Control = cxGrid1
  end
  object Pnl_1: TPanel [6]
    Left = 820
    Top = 135
    Width = 393
    Height = 290
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pnl_1'
    TabOrder = 6
    object strngrd_Items: TStringGrid
      Left = 0
      Top = 35
      Width = 393
      Height = 255
      Align = alClient
      ColCount = 6
      Ctl3D = False
      DefaultColWidth = 70
      RowCount = 30
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnDrawCell = strngrd_ItemsDrawCell
      OnKeyDown = strngrd_ItemsKeyDown
      OnSelectCell = strngrd_ItemsSelectCell
      RowHeights = (
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24
        24)
    end
    object Pnl_2: TPanel
      Left = 0
      Top = 0
      Width = 393
      Height = 35
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object btn1: TButton
        Left = 5
        Top = 1
        Width = 87
        Height = 30
        Caption = #20445'  '#23384
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btn1Click
      end
    end
  end
  inherited SQLQuery: TADOQuery
    Connection = nil
    Left = 8
    Top = 221
  end
  inherited DataSource1: TDataSource
    Left = 39
    Top = 222
  end
  object Qry_TestItems: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 7
    Top = 251
  end
  object Ds_TestItems: TDataSource
    DataSet = Qry_TestItems
    Left = 98
    Top = 254
  end
  object ClientDs1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 68
    Top = 252
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = SQLQuery
    Left = 36
    Top = 252
  end
end
