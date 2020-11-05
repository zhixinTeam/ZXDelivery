inherited fFormGetInspStandard: TfFormGetInspStandard
  Left = 661
  Top = 256
  Caption = #33719#21462#26816#27979#26631#20934
  ClientHeight = 346
  ClientWidth = 533
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 533
    Height = 346
    inherited BtnOK: TButton
      Left = 375
      Top = 308
      Width = 71
      Height = 27
      Caption = #36873#25321
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 451
      Top = 308
      Width = 71
      Height = 27
      TabOrder = 4
    end
    object Edit_Txt: TcxButtonEdit [2]
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
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 200
    end
    object GridOrders: TcxGrid [3]
      Left = 23
      Top = 69
      Width = 441
      Height = 224
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object cxView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        OnCellDblClick = cxView1CellDblClick
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.DataRowHeight = 25
        object cxView1Column1: TcxGridDBColumn
          Caption = #26631#20934#32534#21495
          DataBinding.FieldName = 'R_ID'
          Options.Editing = False
          Width = 113
        end
        object cxView1Column2: TcxGridDBColumn
          Caption = #26631#20934#21517#31216
          DataBinding.FieldName = 'P_Name'
          Options.Editing = False
          Width = 207
        end
      end
      object cxLevel1: TcxGridLevel
        GridView = cxView1
      end
    end
    object btn_Search: TButton [4]
      Left = 292
      Top = 36
      Width = 75
      Height = 25
      Caption = #26597#25214
      TabOrder = 1
      OnClick = btn_SearchClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group2: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #26631#20934#21517#31216#65306
            Control = Edit_Txt
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item5: TdxLayoutItem
            CaptionOptions.Text = 'Button1'
            CaptionOptions.Visible = False
            Control = btn_Search
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item4: TdxLayoutItem
          Control = GridOrders
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 34
    Top = 153
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 65
    Top = 153
  end
end
