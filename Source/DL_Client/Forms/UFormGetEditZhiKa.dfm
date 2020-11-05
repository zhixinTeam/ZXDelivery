inherited fFormGetEditZhiKa: TfFormGetEditZhiKa
  Left = 753
  Top = 238
  BorderStyle = bsDialog
  ClientHeight = 369
  ClientWidth = 687
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 687
    Height = 369
    inherited BtnOK: TButton
      Left = 531
      Top = 332
      Width = 70
      Height = 26
      Caption = #30830#23450
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 606
      Top = 332
      Width = 70
      Height = 26
      TabOrder = 3
    end
    object GridOrders: TcxGrid [2]
      Left = 23
      Top = 61
      Width = 250
      Height = 200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object cxView1: TcxGridDBTableView
        OnDblClick = cxView1DblClick
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.DataRowHeight = 25
        object cxView1Column1: TcxGridDBColumn
          Caption = #35746#21333#32534#21495
          DataBinding.FieldName = 'Z_ID'
          Width = 103
        end
        object cxView1Column7: TcxGridDBColumn
          Caption = #32440#21345#21517#31216
          DataBinding.FieldName = 'Z_Name'
          Width = 104
        end
        object cxView1Column2: TcxGridDBColumn
          Caption = #29289#26009#32534#21495
          DataBinding.FieldName = 'D_StockNo'
          Width = 76
        end
        object cxView1Column3: TcxGridDBColumn
          Caption = #29289#26009#21517#31216
          DataBinding.FieldName = 'D_StockName'
          Width = 113
        end
        object cxView1Column4: TcxGridDBColumn
          Caption = #23458#25143#32534#21495
          DataBinding.FieldName = 'C_ID'
          Width = 73
        end
        object cxView1Column5: TcxGridDBColumn
          Caption = #23458#25143#21517#31216
          DataBinding.FieldName = 'C_Name'
          Width = 136
        end
        object cxView1Column6: TcxGridDBColumn
          Caption = #20215#26684
          DataBinding.FieldName = 'D_Price'
        end
      end
      object cxLevel1: TcxGridLevel
        GridView = cxView1
      end
    end
    object EditCus: TcxButtonEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      ParentShowHint = False
      Properties.Buttons = <
        item
          Default = True
          Hint = #26597#25214
          Kind = bkEllipsis
        end
        item
          Caption = #8730
          Hint = #21047#26032
          Kind = bkText
        end>
      Properties.OnButtonClick = EditCusPropertiesButtonClick
      ShowHint = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = EditCusKeyPress
      Width = 228
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        CaptionOptions.Text = #35746#21333#21015#34920
        object dxLayout1Item4: TdxLayoutItem
          AlignHorz = ahLeft
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = 'cxGrid1'
          CaptionOptions.Visible = False
          Control = GridOrders
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 44
    Top = 122
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 72
    Top = 122
  end
  object Qry_1: TADOQuery
    Parameters = <>
    Left = 44
    Top = 154
  end
end
