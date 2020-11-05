inherited fFramePurMatelTestItemSet: TfFramePurMatelTestItemSet
  Width = 1031
  Height = 457
  inherited ToolBar1: TToolBar
    Width = 1031
    inherited BtnAdd: TToolButton
      Visible = False
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #20445#23384
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 137
    Width = 470
    Height = 320
    Align = alLeft
    inherited cxView1: TcxGridDBTableView
      object Clmn_ID: TcxGridDBColumn
        Caption = #35760#24405#32534#21495
        Options.Editing = False
        Options.Moving = False
        Width = 100
      end
      object Clmn_MID: TcxGridDBColumn
        Caption = #29289#26009#32534#21495
        DataBinding.FieldName = 'M_ID'
        Options.Editing = False
        Options.Moving = False
        Width = 123
      end
      object Clmn_MName: TcxGridDBColumn
        Caption = #29289#26009#21517#31216
        DataBinding.FieldName = 'M_Name'
        Options.Editing = False
        Options.Moving = False
        Width = 185
      end
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1031
    Height = 70
    object lbl1: TLabel [0]
      Left = 268
      Top = 36
      Width = 291
      Height = 57
      Caption = '      '#24038#20391#21015#34920#65306#21407#26448#26009'     '#21491#20391#21015#34920#65306#21270#39564#36136#26816#39033#30446#13#10#13#10'         '
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
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      Width = 176
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #29289#26009#21517#31216#65306
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
    Width = 1031
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1031
    inherited TitleBar: TcxLabel
      Caption = #21407#26009#36136#26816#35774#32622
      Style.IsFontAssigned = True
      Width = 1031
      AnchorX = 516
      AnchorY = 11
    end
  end
  object cxspltr1: TcxSplitter [5]
    Left = 470
    Top = 137
    Width = 5
    Height = 320
    Control = cxGrid1
  end
  object cxGrid2: TcxGrid [6]
    Left = 475
    Top = 137
    Width = 556
    Height = 320
    Align = alClient
    BorderStyle = cxcbsNone
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    object cxView2: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      OnCustomDrawCell = cxView1CustomDrawCell
      DataController.DataSource = Ds_Sample
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      DataController.OnGroupingChanged = cxView1DataControllerGroupingChanged
      OptionsView.DataRowHeight = 24
    end
    object cxLevel2: TcxGridLevel
      GridView = cxView2
    end
  end
  inherited SQLQuery: TADOQuery
    Connection = nil
    Left = 8
    Top = 221
  end
  inherited DataSource1: TDataSource
    Left = 103
    Top = 222
  end
  object Qry_Sample: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 7
    Top = 250
  end
  object Ds_Sample: TDataSource
    DataSet = Qry_Sample
    Left = 38
    Top = 251
  end
  object ClientDs1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 71
    Top = 221
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = SQLQuery
    Left = 39
    Top = 221
  end
end
