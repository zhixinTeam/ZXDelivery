inherited fFramePurSampleBatch: TfFramePurSampleBatch
  Width = 1134
  Height = 495
  inherited ToolBar1: TToolBar
    Width = 1139
    inherited BtnAdd: TToolButton
      Caption = #28155#21152#32452#25209
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #20013#38388#21697#32452#25209
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Caption = #25764#38144#32452#25209
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Left = 697
    Top = 161
    Width = 442
    Height = 317
    inherited cxView1: TcxGridDBTableView
      DataController.DetailKeyFieldNames = 'S_BatID'
      DataController.MasterKeyFieldNames = 'S_BatID'
    end
    object cxView_Dtl: TcxGridDBTableView [1]
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = Ds_Dtl
      DataController.DetailKeyFieldNames = 'D_BatID'
      DataController.KeyFieldNames = 'D_ID'
      DataController.MasterKeyFieldNames = 'S_BatID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      object Clmn_DID: TcxGridDBColumn
        Caption = #35746#21333#21495
        DataBinding.FieldName = 'D_ID'
        Options.Focusing = False
        Options.Moving = False
        Width = 123
      end
      object Clmn_ProName: TcxGridDBColumn
        Caption = #20379#24212#21830#21517
        DataBinding.FieldName = 'D_ProName'
        Options.Editing = False
        Options.Moving = False
        Width = 270
      end
      object Clmn_MetName: TcxGridDBColumn
        Caption = #29289#26009
        DataBinding.FieldName = 'D_StockName'
        Options.Editing = False
        Options.Moving = False
        Width = 123
      end
      object Clmn_xValue: TcxGridDBColumn
        Caption = #20928#37325
        DataBinding.FieldName = 'D_Value'
        Options.Editing = False
        Options.Moving = False
        Width = 90
      end
      object Clmn_xTruck: TcxGridDBColumn
        Caption = #36710#29260#21495
        DataBinding.FieldName = 'D_Truck'
        Options.Editing = False
        Options.Moving = False
        Width = 100
      end
      object Clmn_OutTime: TcxGridDBColumn
        Caption = #20986#21378#26102#38388
        DataBinding.FieldName = 'D_OutFact'
        Options.Editing = False
        Options.Moving = False
        Width = 155
      end
    end
    inherited cxLevel1: TcxGridLevel
      object cxLevel_Dtl: TcxGridLevel
        GridView = cxView_Dtl
      end
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1139
    Height = 68
    object lbl1: TLabel [0]
      Left = 268
      Top = 36
      Width = 379
      Height = 19
      AutoSize = False
      Caption = '      '#24038#20391#21015#34920#65306#36827#21378#21407#26009#26126#32454'     '#21491#20391#21015#34920#65306#24050#21462#26679#32452#25209#35760#24405'         '
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
    Width = 1139
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1139
    inherited TitleBar: TcxLabel
      Caption = #21407#26009#21462#26679#32452#25209
      Style.IsFontAssigned = True
      Width = 1139
      AnchorX = 570
      AnchorY = 11
    end
  end
  object cxGrid2: TcxGrid [5]
    Left = 0
    Top = 161
    Width = 692
    Height = 317
    Align = alLeft
    BorderStyle = cxcbsNone
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    LookAndFeel.Kind = lfOffice11
    object cxViewOrderDtl: TcxGridDBTableView
      OnMouseDown = cxViewOrderDtlMouseDown
      NavigatorButtons.ConfirmDelete = False
      OnCellClick = cxViewOrderDtlCellClick
      OnCustomDrawCell = cxViewOrderDtlCustomDrawCell
      DataController.DataSource = Ds_Sample
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      DataController.OnGroupingChanged = cxView1DataControllerGroupingChanged
      OptionsCustomize.ColumnMoving = False
      OptionsView.DataRowHeight = 24
      object Clmn_Chk1: TcxGridDBColumn
        Caption = #36873#25321
        DataBinding.FieldName = 'Chk'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        Properties.NullStyle = nssUnchecked
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
        Width = 50
      end
      object Clmn_ID: TcxGridDBColumn
        Caption = #21333#21495
        DataBinding.FieldName = 'D_ID'
        Visible = False
        Width = 20
      end
      object Clmn_TruckNo: TcxGridDBColumn
        Caption = #36710#29260#21495
        DataBinding.FieldName = 'D_Truck'
        Options.Editing = False
        Options.Moving = False
        Width = 79
      end
      object Clmn_Value: TcxGridDBColumn
        Caption = #20928#37325
        DataBinding.FieldName = 'D_Value'
        Width = 65
      end
      object Clmn_Provider: TcxGridDBColumn
        Caption = #20379#24212#21830
        DataBinding.FieldName = 'D_ProName'
        Options.Editing = False
        Options.Moving = False
        Width = 223
      end
      object Clmn_MName: TcxGridDBColumn
        Caption = #29289#26009#21517#31216
        DataBinding.FieldName = 'D_StockName'
        Options.Editing = False
        Options.Moving = False
        Width = 110
      end
      object Clmn_OutDate: TcxGridDBColumn
        Caption = #20986#21378#26102#38388
        DataBinding.FieldName = 'D_OutFact'
        Options.Editing = False
        Options.Moving = False
        Width = 150
      end
      object Clmn_ProID: TcxGridDBColumn
        DataBinding.FieldName = 'D_ProID'
        Visible = False
        Options.Editing = False
      end
      object Clmn_MID: TcxGridDBColumn
        DataBinding.FieldName = 'D_StockNo'
        Visible = False
        Options.Editing = False
      end
      object Clmn_BatID: TcxGridDBColumn
        DataBinding.FieldName = 'D_BatID'
        Visible = False
      end
    end
    object cxLevel2: TcxGridLevel
      GridView = cxViewOrderDtl
    end
  end
  object pnl1: TPanel [6]
    Left = 0
    Top = 135
    Width = 1139
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 6
    object chk1: TCheckBox
      Left = 18
      Top = 5
      Width = 97
      Height = 17
      Caption = #20840#36873
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = chk1Click
    end
  end
  object cxspltr1: TcxSplitter [7]
    Left = 692
    Top = 161
    Width = 5
    Height = 317
    Control = cxGrid1
  end
  inherited SQLQuery: TADOQuery
    Left = 8
    Top = 221
  end
  inherited DataSource1: TDataSource
    Left = 39
    Top = 220
  end
  object Qry_Sample: TADOQuery
    Parameters = <>
    Left = 7
    Top = 250
  end
  object Ds_Sample: TDataSource
    AutoEdit = False
    DataSet = ClientDs1
    Left = 102
    Top = 250
  end
  object ClientDs1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 70
    Top = 250
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = Qry_Sample
    Left = 38
    Top = 250
  end
  object Qry_Dtl: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 7
    Top = 288
  end
  object Ds_Dtl: TDataSource
    DataSet = Qry_Dtl
    Left = 38
    Top = 288
  end
end
