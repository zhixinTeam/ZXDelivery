inherited fFormHYData: TfFormHYData
  Left = 661
  Top = 254
  ClientHeight = 307
  ClientWidth = 444
  Constraints.MinHeight = 245
  Constraints.MinWidth = 460
  Font.Height = -13
  Font.Name = #24494#36719#38597#40657
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  inherited dxLayout1: TdxLayoutControl
    Width = 444
    Height = 307
    inherited BtnOK: TButton
      Left = 281
      Top = 266
      Width = 72
      Height = 27
      Caption = #30830#23450
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      ParentFont = False
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 358
      Top = 266
      Width = 72
      Height = 27
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      ParentFont = False
      TabOrder = 10
    end
    object EditTruck: TcxTextEdit [2]
      Left = 87
      Top = 198
      ParentFont = False
      Properties.MaxLength = 100
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 6
      OnKeyPress = EditTruckKeyPress
      Width = 147
    end
    object EditValue: TcxTextEdit [3]
      Left = 309
      Top = 198
      ParentFont = False
      Properties.MaxLength = 100
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 7
      OnKeyPress = EditNameKeyPress
      Width = 89
    end
    object EditSMan: TcxComboBox [4]
      Left = 87
      Top = 50
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 35
      Properties.OnEditValueChanged = EditSManPropertiesEditValueChanged
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      OnKeyPress = EditNameKeyPress
      Width = 328
    end
    object EditCustom: TcxComboBox [5]
      Left = 87
      Top = 82
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      OnKeyPress = EditCustomKeyPress
      Width = 328
    end
    object EditNo: TcxButtonEdit [6]
      Left = 309
      Top = 166
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNoPropertiesButtonClick
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 5
      OnKeyPress = EditNameKeyPress
      Width = 89
    end
    object EditDate: TcxDateEdit [7]
      Left = 87
      Top = 166
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      OnKeyPress = EditNameKeyPress
      Width = 147
    end
    object EditName: TcxTextEdit [8]
      Left = 87
      Top = 114
      ParentFont = False
      Properties.MaxLength = 80
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      OnKeyPress = EditNameKeyPress
      Width = 328
    end
    object cxLabel2: TcxLabel [9]
      Left = 29
      Top = 146
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Vert = taBottomJustify
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 15
      Width = 466
      AnchorY = 161
    end
    object chk_IsBD: TCheckBox [10]
      Left = 29
      Top = 230
      Width = 97
      Height = 17
      Caption = #26159#21542#34917#21333
      Color = clWindow
      ParentColor = False
      TabOrder = 8
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #19994' '#21153' '#21592':'
          Control = EditSMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustom
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #24320#21333#23458#25143':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #25552#36135#26085#26399':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27700#27877#32534#21495':'
            Control = EditNo
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#37327'('#21544'):'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = 'CheckBox1'
          ShowCaption = False
          Control = chk_IsBD
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
