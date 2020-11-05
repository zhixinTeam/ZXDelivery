inherited fFormBillWx: TfFormBillWx
  Left = 610
  Top = 295
  Caption = #38144#21806#21333#24494#20449#25195#30721
  ClientHeight = 391
  ClientWidth = 660
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 660
    Height = 391
    inherited BtnOK: TButton
      Left = 442
      Top = 347
      Width = 101
      Height = 33
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      ParentFont = False
      TabOrder = 14
    end
    inherited BtnExit: TButton
      Left = 548
      Top = 347
      Width = 101
      Height = 33
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      ParentFont = False
      TabOrder = 15
    end
    object editWebOrderNo: TcxTextEdit [2]
      Left = 99
      Top = 36
      Hint = #35831#25195#25551#25110#36755#20837#24494#20449#20108#32500#30721
      AutoSize = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = [fsBold]
      Style.TextColor = 3145983
      Style.IsFontAssigned = True
      TabOrder = 0
      OnKeyPress = editWebOrderNoKeyPress
      Height = 33
      Width = 396
    end
    object btnQuery: TcxButton [3]
      Left = 500
      Top = 36
      Width = 133
      Height = 35
      Caption = #26597#35810#35746#21333
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnQueryClick
    end
    object edt_CID: TcxTextEdit [4]
      Left = 99
      Top = 122
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Height = 33
      Width = 133
    end
    object edt_CName: TcxTextEdit [5]
      Left = 301
      Top = 122
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      Height = 33
      Width = 310
    end
    object edt_MID: TcxTextEdit [6]
      Left = 99
      Top = 160
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 5
      Height = 33
      Width = 133
    end
    object edt_MName: TcxTextEdit [7]
      Left = 301
      Top = 160
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 6
      Height = 33
      Width = 310
    end
    object edt_Truck: TcxTextEdit [8]
      Left = 99
      Top = 198
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = [fsBold]
      Style.TextColor = 1410047
      Style.IsFontAssigned = True
      TabOrder = 7
      Height = 33
      Width = 133
    end
    object edt_Value: TcxTextEdit [9]
      Left = 301
      Top = 198
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Horz = taLeftJustify
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -20
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = [fsBold]
      Style.TextColor = 1410047
      Style.IsFontAssigned = True
      TabOrder = 8
      Text = '0'
      Height = 33
      Width = 70
    end
    object edt_IDCard: TcxTextEdit [10]
      Left = 301
      Top = 238
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 11
      Height = 33
      Width = 310
    end
    object edt_Trucker: TcxTextEdit [11]
      Left = 99
      Top = 238
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 10
      Height = 33
      Width = 133
    end
    object edt_Memo: TcxTextEdit [12]
      Left = 99
      Top = 276
      AutoSize = False
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 12
      Height = 33
      Width = 530
    end
    object Panel1: TPanel [13]
      Left = 23
      Top = 76
      Width = 185
      Height = 41
      BevelOuter = bvNone
      Caption = #35746#21333#35814#24773
      Color = clWindow
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
    end
    object PrintHY: TcxCheckBox [14]
      Left = 11
      Top = 347
      Caption = #25171#21360#21270#39564#21333
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 13
      Transparent = True
      Width = 105
    end
    object cbb_BeltLine: TcxComboBox [15]
      Left = 422
      Top = 198
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -20
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      Style.IsFontAssigned = True
      TabOrder = 9
      Width = 188
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
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
              object dxLayout1Item3: TdxLayoutItem
                CaptionOptions.Text = #24494#20449#35746#21333#21495#65306
                Control = editWebOrderNo
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item4: TdxLayoutItem
                CaptionOptions.Visible = False
                Control = btnQuery
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item5: TdxLayoutItem
              CaptionOptions.Visible = False
              Control = Panel1
              ControlOptions.AutoColor = True
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group7: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxlytmLayout1Item5: TdxLayoutItem
              CaptionOptions.Text = #23458#25143#32534#21495#65306
              Control = edt_CID
              ControlOptions.ShowBorder = False
            end
            object dxlytmLayout1Item51: TdxLayoutItem
              CaptionOptions.Text = #23458#25143#21517#31216#65306
              Control = edt_CName
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Group6: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxlytmLayout1Item52: TdxLayoutItem
            CaptionOptions.Text = #21697#31181#32534#21495#65306
            Control = edt_MID
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item53: TdxLayoutItem
            CaptionOptions.Text = #21697#31181#21517#31216#65306
            Control = edt_MName
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxlytmLayout1Item54: TdxLayoutItem
            CaptionOptions.Text = #25552#36135#36710#21495#65306
            Control = edt_Truck
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item55: TdxLayoutItem
            CaptionOptions.Text = #25552#36135#21544#25968#65306
            Control = edt_Value
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #29983#20135#32447':'
            Control = cbb_BeltLine
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group5: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxlytmLayout1Item57: TdxLayoutItem
            CaptionOptions.Text = #21496#26426#22995#21517#65306
            Control = edt_Trucker
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item56: TdxLayoutItem
            CaptionOptions.Text = #36523#20221#35777#21495#65306
            Control = edt_IDCard
            ControlOptions.ShowBorder = False
          end
        end
        object dxlytmLayout1Item58: TdxLayoutItem
          CaptionOptions.Text = #35746#21333#22791#27880#65306
          Control = edt_Memo
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item6: TdxLayoutItem [0]
          CaptionOptions.Visible = False
          Control = PrintHY
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
