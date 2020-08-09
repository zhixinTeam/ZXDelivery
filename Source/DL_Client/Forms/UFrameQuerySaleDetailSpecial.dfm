inherited fFrameSaleDetailQuerySpecial: TfFrameSaleDetailQuerySpecial
  Width = 1089
  Height = 429
  inherited ToolBar1: TToolBar
    Width = 1089
    ButtonWidth = 79
    inherited BtnAdd: TToolButton
      Caption = #20462#25913
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Left = 79
      Caption = #35843#25320
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Left = 158
      OnClick = BtnDelClick
    end
    inherited S1: TToolButton
      Left = 237
      Visible = False
    end
    inherited BtnRefresh: TToolButton
      Left = 245
      Caption = '    '#21047#26032'    '
    end
    inherited S2: TToolButton
      Left = 324
    end
    inherited BtnPrint: TToolButton
      Left = 332
    end
    inherited BtnPreview: TToolButton
      Left = 411
    end
    inherited BtnExport: TToolButton
      Left = 490
    end
    inherited S3: TToolButton
      Left = 569
    end
    inherited BtnExit: TToolButton
      Left = 577
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 205
    Width = 1089
    Height = 224
    inherited cxView1: TcxGridDBTableView
      PopupMenu = pmPMenu1
      DataController.Summary.Options = [soNullIgnore]
      OptionsSelection.MultiSelect = True
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1089
    Height = 138
    object cxtxtdt1: TcxTextEdit [0]
      Left = 627
      Top = 93
      Hint = 'T.L_CusName'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Width = 105
    end
    object EditDate: TcxButtonEdit [1]
      Left = 615
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 3
      Width = 261
    end
    object EditCustomer: TcxButtonEdit [2]
      Left = 437
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
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object cxtxtdt2: TcxTextEdit [3]
      Left = 449
      Top = 93
      Hint = 'T.L_Value'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 115
    end
    object cxtxtdt3: TcxTextEdit [4]
      Left = 81
      Top = 93
      Hint = 'T.L_ID'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 115
    end
    object cxtxtdt4: TcxTextEdit [5]
      Left = 259
      Top = 93
      Hint = 'T.L_StockName'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 115
    end
    object EditTruck: TcxButtonEdit [6]
      Left = 259
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
      Width = 115
    end
    object EditBill: TcxButtonEdit [7]
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
      Width = 115
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = EditBill
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = cxtxtdt3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21697#31181#21517#31216':'
          Control = cxtxtdt4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20132#36135#37327'('#21544'):'
          Control = cxtxtdt2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #23458#25143#21517#31216':'
          Control = cxtxtdt1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 197
    Width = 1089
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1089
    inherited TitleBar: TcxLabel
      Caption = #21457#36135#26126#32454#32479#35745#26597#35810
      Style.IsFontAssigned = True
      Width = 1089
      AnchorX = 545
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 10
    Top = 252
  end
  inherited DataSource1: TDataSource
    Left = 38
    Top = 252
  end
  object pmPMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 10
    Top = 280
    object mniN1: TMenuItem
      Caption = #26102#38388#27573#26597#35810
      OnClick = mniN1Click
    end
    object N1: TMenuItem
      Caption = #25209#37327#25171#21360
      Visible = False
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #20462#25913#21457#36135#22320#28857
      Visible = False
      OnClick = N2Click
    end
  end
end
