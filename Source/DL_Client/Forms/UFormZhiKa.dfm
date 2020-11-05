inherited fFormZhiKa: TfFormZhiKa
  Left = 548
  Top = 143
  Width = 536
  Height = 540
  BorderStyle = bsSizeable
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 520
    Height = 502
    inherited BtnOK: TButton
      Left = 374
      Top = 469
      TabOrder = 21
    end
    inherited BtnExit: TButton
      Left = 444
      Top = 469
      TabOrder = 22
    end
    object ListDetail: TcxListView [2]
      Left = 23
      Top = 275
      Width = 438
      Height = 188
      Checkboxes = True
      Columns = <
        item
          Caption = #27700#27877#31867#22411
          Width = 188
        end
        item
          Caption = #21333#20215'('#20803'/'#21544')'
          Width = 100
        end
        item
          Caption = #21150#29702#37327'('#21544')'
          Width = 100
        end>
      HideSelection = False
      ParentFont = False
      PopupMenu = PMenu1
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 16
      ViewStyle = vsReport
      OnClick = ListDetailClick
    end
    object EditPrice: TcxTextEdit [3]
      Left = 284
      Top = 437
      ParentFont = False
      Properties.OnEditValueChanged = EditPricePropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 18
      Width = 79
    end
    object EditValue: TcxTextEdit [4]
      Left = 420
      Top = 437
      ParentFont = False
      Properties.OnEditValueChanged = EditPricePropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 19
      Width = 77
    end
    object EditCID: TcxButtonEdit [5]
      Left = 293
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      OnExit = EditCIDExit
      OnKeyPress = EditCIDKeyPress
      Width = 121
    end
    object EditPName: TcxTextEdit [6]
      Left = 99
      Top = 61
      ParentFont = False
      Properties.MaxLength = 100
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 121
    end
    object EditSMan: TcxComboBox [7]
      Left = 99
      Top = 111
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ItemHeight = 18
      Properties.OnEditValueChanged = EditSManPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 4
      Width = 125
    end
    object EditCustom: TcxComboBox [8]
      Left = 99
      Top = 86
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 3
      OnKeyPress = EditCustomKeyPress
      Width = 121
    end
    object EditLading: TcxComboBox [9]
      Left = 99
      Top = 136
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'T=T'#12289#33258#25552
        'S=S'#12289#36865#36135)
      Properties.MaxLength = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 6
      Width = 125
    end
    object EditPayment: TcxComboBox [10]
      Left = 99
      Top = 186
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 10
      Width = 125
    end
    object EditMoney: TcxTextEdit [11]
      Left = 293
      Top = 186
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 11
      Text = '0'
      Width = 121
    end
    object cxLabel2: TcxLabel [12]
      Left = 477
      Top = 186
      AutoSize = False
      Caption = #20803
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 20
      AnchorY = 196
    end
    object Check1: TcxCheckBox [13]
      Left = 11
      Top = 469
      Caption = #23436#25104#21518#25171#24320#38480#25552#31383#21475
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 20
      Transparent = True
      Width = 142
    end
    object EditDays: TcxDateEdit [14]
      Left = 293
      Top = 136
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 7
      Width = 121
    end
    object EditName: TcxTextEdit [15]
      Left = 99
      Top = 36
      ParentFont = False
      Properties.MaxLength = 100
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      Width = 125
    end
    object editArea: TcxButtonEdit [16]
      Left = 293
      Top = 111
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = editAreaPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      TabOrder = 5
      Width = 153
    end
    object editXHSpot: TcxTextEdit [17]
      Left = 99
      Top = 161
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 8
      Width = 125
    end
    object editFreight: TcxCurrencyEdit [18]
      Left = 293
      Top = 161
      ParentFont = False
      Properties.DisplayFormat = ',0.00;-,0.00'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 9
      Width = 202
    end
    object EditStock: TcxTextEdit [19]
      Left = 99
      Top = 437
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 17
      Width = 116
    end
    object editYF: TcxCurrencyEdit [20]
      Left = 99
      Top = 211
      ParentFont = False
      Properties.DisplayFormat = ',0.00;-,0.00'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 13
      Width = 124
    end
    object editJF: TcxCurrencyEdit [21]
      Left = 304
      Top = 211
      ParentFont = False
      Properties.DisplayFormat = ',0.00;-,0.00'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 14
      Width = 193
    end
    object editNF: TcxCurrencyEdit [22]
      Left = 99
      Top = 236
      ParentFont = False
      Properties.DisplayFormat = ',0.00;-,0.00'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 15
      Width = 106
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group5: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item13: TdxLayoutItem
            CaptionOptions.Text = #32440#21345#21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #21512#21516#32534#21495':'
            Control = EditCID
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item8: TdxLayoutItem
          CaptionOptions.Text = #39033#30446#21517#31216':'
          Control = EditPName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditCustom
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group6: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            CaptionOptions.Text = #19994#21153#20154#21592':'
            Control = EditSMan
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item14: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #25152#23646#21306#22495#65306
            Control = editArea
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item11: TdxLayoutItem
            CaptionOptions.Text = #25552#36135#26041#24335#65306
            Control = EditLading
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item18: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #25552#36135#26102#38271#65306
            Control = EditDays
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group7: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item19: TdxLayoutItem
            CaptionOptions.Text = #21368#36135#22320#28857#65306
            Control = editXHSpot
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item20: TdxLayoutItem
            CaptionOptions.Text = #36816#36153#21333#20215#65306
            Control = editFreight
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item12: TdxLayoutItem
            CaptionOptions.Text = #20184#27454#26041#24335#65306
            Control = EditPayment
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item15: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #39044#20184#37329#39069#65306
            Control = EditMoney
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item16: TdxLayoutItem
            Control = cxLabel2
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group8: TdxLayoutGroup
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item21: TdxLayoutItem
            CaptionOptions.Text = #26376#36820'('#20803'/'#21544'):'
            Control = editYF
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item22: TdxLayoutItem
            CaptionOptions.Text = #23395#36820'('#20803'/'#21544'):'
            Control = editJF
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item23: TdxLayoutItem
          CaptionOptions.Text = #24180#36820'('#20803'/'#21544'):'
          Control = editNF
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AlignVert = avClient
        ButtonOptions.Buttons = <>
        object dxLayout1Item3: TdxLayoutItem
          AlignVert = avClient
          Control = ListDetail
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            CaptionOptions.Text = #21697#31181#65306
            Control = EditStock
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AlignHorz = ahRight
            CaptionOptions.Text = #21333#20215#65306
            Control = EditPrice
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            AlignHorz = ahRight
            CaptionOptions.Text = #21150#29702#37327#65306
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item17: TdxLayoutItem [0]
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 36
    Top = 268
    object N1: TMenuItem
      Tag = 10
      Caption = #20840#37096#36873#20013
      OnClick = N3Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #20840#37096#21462#28040
      OnClick = N3Click
    end
    object N3: TMenuItem
      Tag = 30
      Caption = #21453#30456#36873#25321
      OnClick = N3Click
    end
  end
end
