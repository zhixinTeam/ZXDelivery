inherited fFormBill: TfFormBill
  Left = 772
  Top = 165
  ClientHeight = 526
  ClientWidth = 443
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 443
    Height = 526
    OptionsItem.AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 297
      Top = 493
      Caption = #24320#21333
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 367
      Top = 493
      TabOrder = 9
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 351
      Height = 116
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 273
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 8
    end
    object ListBill: TcxListView [3]
      Left = 23
      Top = 414
      Width = 372
      Height = 113
      Columns = <
        item
          Caption = #27700#27877#31867#22411
          Width = 80
        end
        item
          Caption = #25552#36135#36710#36742
          Width = 70
        end
        item
          Caption = #21150#29702#37327'('#21544')'
          Width = 100
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      ViewStyle = vsReport
    end
    object EditValue: TcxTextEdit [4]
      Left = 87
      Top = 389
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditTruck: TcxTextEdit [5]
      Left = 270
      Top = 182
      ParentFont = False
      Properties.MaxLength = 15
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 116
    end
    object EditStock: TcxComboBox [6]
      Left = 87
      Top = 364
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 15
      Properties.ItemHeight = 18
      Properties.OnChange = EditStockPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 0
      OnKeyPress = EditLadingKeyPress
      Width = 115
    end
    object BtnAdd: TButton [7]
      Left = 381
      Top = 364
      Width = 39
      Height = 17
      Caption = #28155#21152
      TabOrder = 4
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [8]
      Left = 381
      Top = 389
      Width = 39
      Height = 18
      Caption = #21024#38500
      TabOrder = 7
      OnClick = BtnDelClick
    end
    object EditLading: TcxComboBox [9]
      Left = 87
      Top = 182
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'T=T'#12289#33258#25552
        'S=S'#12289#36865#36135
        'X=X'#12289#36816#21368)
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditFQ: TcxTextEdit [10]
      Left = 270
      Top = 157
      ParentFont = False
      Properties.MaxLength = 100
      Properties.OnEditValueChanged = EditFQPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 13
      Width = 120
    end
    object EditType: TcxComboBox [11]
      Left = 87
      Top = 157
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'C=C'#12289#26222#36890
        'Z=Z'#12289#26632#21488
        'V=V'#12289'VIP'
        'S=S'#12289#33337#36816)
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 14
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object PrintGLF: TcxCheckBox [12]
      Left = 11
      Top = 493
      Caption = #25171#21360#36807#36335#36153
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 15
      Transparent = True
      Width = 95
    end
    object PrintHY: TcxCheckBox [13]
      Left = 111
      Top = 493
      Caption = #25171#21360#21270#39564#21333
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 16
      Transparent = True
      Width = 95
    end
    object EditSJName: TcxTextEdit [14]
      Left = 87
      Top = 232
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 17
      Width = 121
    end
    object cbbXHSpot: TcxComboBox [15]
      Left = 87
      Top = 257
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 18
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditIdent: TcxTextEdit [16]
      Left = 271
      Top = 232
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 19
      OnKeyPress = EditIdentKeyPress
      Width = 139
    end
    object EditSJPinYin: TcxTextEdit [17]
      Left = 87
      Top = 207
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 20
      OnKeyPress = EditSJPinYinKeyPress
      Width = 120
    end
    object editDate: TcxDateEdit [18]
      Left = 270
      Top = 257
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 21
      Width = 139
    end
    object cbb_BeltLine: TcxComboBox [19]
      Left = 270
      Top = 207
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 22
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object edt_PValue: TcxTextEdit [20]
      Left = 87
      Top = 282
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 23
      Width = 121
    end
    object cbb_Line: TcxComboBox [21]
      Left = 271
      Top = 282
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 24
      OnKeyPress = EditLadingKeyPress
      Width = 147
    end
    object editBZ: TcxTextEdit [22]
      Left = 87
      Top = 307
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 25
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #25552#36135#36890#36947':'
            Control = EditType
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #23553#31614#32534#21495':'
            Control = EditFQ
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item12: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #25552#36135#26041#24335':'
            Control = EditLading
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group9: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item18: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #22995#21517#25340#38899':'
            Control = EditSJPinYin
            ControlOptions.ShowBorder = False
          end
          object dxlytm_SCX: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #29983' '#20135' '#32447':'
            Control = cbb_BeltLine
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item15: TdxLayoutItem
            CaptionOptions.Text = #21496#26426#22995#21517':'
            Control = EditSJName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item17: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #36523#20221#35777#21495':'
            Control = EditIdent
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group6: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group10: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item16: TdxLayoutItem
              CaptionOptions.Text = #21368#36135#22320#28857':'
              Control = cbbXHSpot
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item19: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #34917#21333#26085#26399':'
              Control = editDate
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group11: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxlytmLayout1Item20: TdxLayoutItem
              AlignHorz = ahLeft
              CaptionOptions.Text = #36710#36742#30382#37325#65306
              Control = edt_PValue
              ControlOptions.ShowBorder = False
            end
            object dxlytmLayout1Item201: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #35013#36710#36890#36947':'
              Control = cbb_Line
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item20: TdxLayoutItem
          CaptionOptions.Text = #22791#27880#20449#24687':'
          Control = editBZ
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AlignVert = avClient
        CaptionOptions.Text = #25552#21333#26126#32454
        ButtonOptions.Buttons = <>
        object dxLayout1Group5: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group8: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #27700#27877#31867#22411':'
              Control = EditStock
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button1'
              CaptionOptions.Visible = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group7: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item8: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #21150#29702#21544#25968':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button2'
              CaptionOptions.Visible = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item4: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = 'New Item'
          CaptionOptions.Visible = False
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem [0]
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Visible = False
          Control = PrintGLF
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem [1]
          CaptionOptions.Visible = False
          Control = PrintHY
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
