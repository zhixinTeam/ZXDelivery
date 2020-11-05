inherited fFramePurSampleHYDataEx: TfFramePurSampleHYDataEx
  Width = 1211
  Height = 398
  inherited ToolBar1: TToolBar
    Width = 1211
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
    Top = 137
    Width = 815
    Height = 261
    Align = alLeft
    inherited cxView1: TcxGridDBTableView
      OnCellDblClick = cxView1CellDblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1211
    Height = 70
    object lbl1: TLabel [0]
      Left = 268
      Top = 36
      Width = 304
      Height = 38
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
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      Width = 176
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #26085#26399#36873#25321#65306
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          CaptionOptions.Visible = False
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
    Top = 129
    Width = 1211
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1211
    inherited TitleBar: TcxLabel
      Caption = #21407#26009#26679#21697#21270#39564#32467#26524#24405#20837
      Style.IsFontAssigned = True
      Width = 1211
      AnchorX = 606
      AnchorY = 11
    end
  end
  object cxspltr1: TcxSplitter [5]
    Left = 815
    Top = 137
    Width = 5
    Height = 261
    Control = cxGrid1
  end
  object lv1: TListView [6]
    Left = 820
    Top = 137
    Width = 391
    Height = 261
    Align = alClient
    BevelKind = bkFlat
    BorderStyle = bsNone
    Columns = <
      item
        Caption = #26816#27979#39033
        Width = 100
      end
      item
        Caption = #26816#27979#20540
        Width = 100
      end
      item
        Caption = #26465#20214
        Width = 100
      end
      item
        Caption = #20844#24335
        Width = 223
      end
      item
        Caption = #21028#23450#32467#26524
      end>
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 6
    ViewStyle = vsReport
    OnClick = lv1Click
    OnCustomDrawItem = lv1CustomDrawItem
  end
  object edt_lst: TEdit [7]
    Left = 833
    Top = 210
    Width = 121
    Height = 19
    BorderStyle = bsNone
    Color = clGray
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 7
    Visible = False
    OnChange = edt_lstChange
    OnExit = edt_lstExit
    OnKeyPress = edt_lstKeyPress
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
