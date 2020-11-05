inherited fFramePurTestPlanSet: TfFramePurTestPlanSet
  Width = 1031
  Height = 457
  inherited ToolBar1: TToolBar
    Width = 1031
    inherited BtnAdd: TToolButton
      Caption = #26032#22686#26631#20934
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #20445#23384
      Visible = False
    end
    inherited BtnDel: TToolButton
      Caption = #21024#38500#26631#20934
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 135
    Width = 590
    Height = 322
    Align = alLeft
    inherited cxView1: TcxGridDBTableView
      OnDblClick = cxView1DblClick
      object Clmn_ID: TcxGridDBColumn
        Caption = #35760#24405#32534#21495
        Visible = False
        Options.Editing = False
        Options.Moving = False
        Width = 100
      end
      object Clmn_MID: TcxGridDBColumn
        Caption = #32534#21495
        DataBinding.FieldName = 'P_ID'
        Options.Editing = False
        Options.Moving = False
        Width = 123
      end
      object Clmn_MName: TcxGridDBColumn
        Caption = #26631#20934#21517#31216
        DataBinding.FieldName = 'P_Name'
        Options.Editing = False
        Options.Moving = False
        Width = 220
      end
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1031
    Height = 68
    object lbl1: TLabel [0]
      Left = 268
      Top = 36
      Width = 304
      Height = 57
      Caption = '      '#24038#20391#21015#34920#65306#36136#26816#26631#20934'     '#21491#20391#21015#34920#65306#21270#39564#36136#26816#39033#30446#13#10#13#10'         '
      Color = clWindow
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Edit_Name: TcxButtonEdit [1]
      Left = 87
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = Edit_NamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = Edit_NameKeyPress
      Width = 176
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #26041#26696#21517#31216#65306
          Control = Edit_Name
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
    Top = 127
    Width = 1031
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1031
    inherited TitleBar: TcxLabel
      Caption = #21407#26009#36136#26816#26631#20934#35774#32622
      Style.IsFontAssigned = True
      Width = 1031
      AnchorX = 516
      AnchorY = 11
    end
  end
  object cxspltr1: TcxSplitter [5]
    Left = 590
    Top = 135
    Width = 5
    Height = 322
    Control = cxGrid1
  end
  object Panel1: TPanel [6]
    Left = 595
    Top = 135
    Width = 436
    Height = 322
    Align = alClient
    Color = clWhite
    TabOrder = 6
    object cxGrid2: TcxGrid
      Left = 1
      Top = 48
      Width = 434
      Height = 273
      Align = alClient
      BorderStyle = cxcbsNone
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object cxView2: TcxGridDBTableView
        OnKeyPress = cxView2KeyPress
        NavigatorButtons.ConfirmDelete = False
        OnEditChanged = cxView2EditChanged
        DataController.DataSource = Ds_Items
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.OnGroupingChanged = cxView1DataControllerGroupingChanged
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.DataRowHeight = 24
        object Clmn_ItemID: TcxGridDBColumn
          DataBinding.FieldName = 'R_ID'
          Visible = False
        end
        object Clmn_ItemName: TcxGridDBColumn
          Caption = #26816#27979#39033#21517
          DataBinding.FieldName = 'I_ItemsName'
          Width = 123
        end
        object Clmn_ItemWhere: TcxGridDBColumn
          Caption = #26465#20214
          DataBinding.FieldName = 'I_Where'
          Width = 150
        end
        object Clmn_Formula: TcxGridDBColumn
          Caption = #20844#24335
          DataBinding.FieldName = 'I_Formula'
          Width = 223
        end
      end
      object cxLevel2: TcxGridLevel
        GridView = cxView2
      end
    end
    object Pnl_t: TPanel
      Left = 1
      Top = 1
      Width = 434
      Height = 47
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      object btn3: TButton
        Left = 18
        Top = 7
        Width = 91
        Height = 29
        Caption = #26032#22686#26816#27979#39033
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btn3Click
      end
      object btn4: TButton
        Left = 115
        Top = 7
        Width = 91
        Height = 29
        Caption = #21024#38500#26816#27979#39033
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btn4Click
      end
    end
  end
  inherited SQLQuery: TADOQuery
    Connection = nil
    Left = 7
    Top = 233
  end
  inherited DataSource1: TDataSource
    Left = 41
    Top = 233
  end
  object Qry_Items: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 7
    Top = 263
  end
  object Ds_Items: TDataSource
    DataSet = Qry_Items
    Left = 41
    Top = 262
  end
end
