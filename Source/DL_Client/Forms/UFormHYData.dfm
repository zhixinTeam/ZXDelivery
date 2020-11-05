inherited fFormHYData: TfFormHYData
  Left = 661
  Top = 254
  ClientHeight = 248
  ClientWidth = 444
  Constraints.MinHeight = 245
  Constraints.MinWidth = 460
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 444
    Height = 248
    inherited BtnOK: TButton
      Left = 283
      Top = 231
      Width = 64
      Height = 25
      Caption = #30830#23450
      ParentFont = False
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 352
      Top = 231
      Width = 64
      Height = 25
      ParentFont = False
      TabOrder = 11
    end
    object EditTruck: TcxTextEdit [2]
      Left = 81
      Top = 177
      ParentFont = False
      Properties.MaxLength = 100
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 7
      OnKeyPress = EditTruckKeyPress
      Width = 147
    end
    object EditValue: TcxTextEdit [3]
      Left = 303
      Top = 177
      ParentFont = False
      Properties.MaxLength = 100
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 8
      OnKeyPress = EditNameKeyPress
      Width = 118
    end
    object EditSMan: TcxComboBox [4]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 35
      Properties.OnEditValueChanged = EditSManPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      Style.IsFontAssigned = True
      TabOrder = 0
      OnKeyPress = EditNameKeyPress
      Width = 340
    end
    object EditCustom: TcxComboBox [5]
      Left = 81
      Top = 61
      Hint = #28857#20987#31354#26684#38190#12289#22312#24377#20986#31383#21475#36873#25321#23458#25143
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      Style.IsFontAssigned = True
      TabOrder = 1
      OnKeyPress = EditCustomKeyPress
      Width = 340
    end
    object EditNo: TcxButtonEdit [6]
      Left = 303
      Top = 152
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNoPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.IsFontAssigned = True
      TabOrder = 6
      OnKeyPress = EditNameKeyPress
      Width = 118
    end
    object EditDate: TcxDateEdit [7]
      Left = 81
      Top = 152
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      Style.IsFontAssigned = True
      TabOrder = 5
      OnKeyPress = EditNameKeyPress
      Width = 147
    end
    object EditName: TcxTextEdit [8]
      Left = 81
      Top = 107
      ParentFont = False
      Properties.MaxLength = 80
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      OnKeyPress = EditNameKeyPress
      Width = 340
    end
    object cxLabel2: TcxLabel [9]
      Left = 23
      Top = 132
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Vert = taBottomJustify
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 15
      Width = 466
      AnchorY = 147
    end
    object chk_IsBD: TCheckBox [10]
      Left = 23
      Top = 202
      Width = 97
      Height = 17
      Caption = #26159#21542#34917#21333
      Color = clWindow
      ParentColor = False
      TabOrder = 9
    end
    object cxlbl1: TcxLabel [11]
      Left = 23
      Top = 86
      Caption = '         '#28857#20987#31354#26684#38190#12289#22312#24377#20986#31383#21475#36873#25321#23458#25143
      ParentColor = False
      ParentFont = False
      Style.Color = clWhite
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #19994' '#21153' '#21592':'
          Control = EditSMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditCustom
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item11: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel1'
          CaptionOptions.Visible = False
          Control = cxlbl1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          CaptionOptions.Text = #24320#21333#23458#25143':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          CaptionOptions.Visible = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            CaptionOptions.Text = #25552#36135#26085#26399':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #27700#27877#32534#21495':'
            Control = EditNo
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            CaptionOptions.Text = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #25552#36135#37327'('#21544'):'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item10: TdxLayoutItem
          CaptionOptions.Text = 'CheckBox1'
          CaptionOptions.Visible = False
          Control = chk_IsBD
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
