object fFormHYRecord: TfFormHYRecord
  Left = 313
  Top = 6
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 683
  ClientWidth = 812
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 812
    Height = 683
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    OptionsItem.AutoControlTabOrders = False
    object BtnOK: TButton
      Left = 656
      Top = 649
      Width = 70
      Height = 23
      Caption = #20445#23384
      TabOrder = 4
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 731
      Top = 649
      Width = 70
      Height = 23
      Caption = #21462#28040
      TabOrder = 5
      OnClick = BtnExitClick
    end
    object EditID: TcxButtonEdit
      Left = 81
      Top = 36
      Hint = 'E.R_SerialNo'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.IsFontAssigned = True
      TabOrder = 0
      OnExit = EditIDExit
      OnKeyPress = EditIDKeyPress
      Width = 220
    end
    object EditStock: TcxComboBox
      Left = 81
      Top = 62
      Hint = 'E.R_PID'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      Properties.OnEditValueChanged = EditStockPropertiesEditValueChanged
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
      Width = 493
    end
    object wPanel: TPanel
      Left = 23
      Top = 144
      Width = 415
      Height = 262
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 6
      object Label17: TLabel
        Left = 6
        Top = 258
        Width = 72
        Height = 12
        Caption = '3'#22825#25239#21387#24378#24230':'
        Transparent = True
      end
      object Label18: TLabel
        Left = 6
        Top = 227
        Width = 72
        Height = 12
        Caption = '3'#22825#25239#25240#24378#24230':'
        Transparent = True
      end
      object Label25: TLabel
        Left = 205
        Top = 258
        Width = 78
        Height = 12
        Caption = '28'#22825#25239#21387#24378#24230':'
        Transparent = True
      end
      object Label26: TLabel
        Left = 205
        Top = 227
        Width = 78
        Height = 12
        Caption = '28'#22825#25239#25240#24378#24230':'
        Transparent = True
      end
      object Bevel2: TBevel
        Left = 3
        Top = 209
        Width = 452
        Height = 7
        Shape = bsBottomLine
      end
      object Label19: TLabel
        Left = 314
        Top = 61
        Width = 54
        Height = 12
        Caption = #30897' '#21547' '#37327':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label20: TLabel
        Left = 157
        Top = 139
        Width = 54
        Height = 12
        Caption = #19981' '#28342' '#29289':'
        Transparent = True
      end
      object Label21: TLabel
        Left = 2
        Top = 139
        Width = 54
        Height = 12
        Caption = #31264'    '#24230':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label22: TLabel
        Left = 2
        Top = 88
        Width = 54
        Height = 12
        Caption = #32454'    '#24230':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label23: TLabel
        Left = 157
        Top = 88
        Width = 54
        Height = 12
        Caption = #27695' '#31163' '#23376':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label24: TLabel
        Left = 157
        Top = 5
        Width = 54
        Height = 12
        Caption = #27687' '#21270' '#38209':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label27: TLabel
        Left = 1
        Top = 164
        Width = 54
        Height = 12
        Caption = #21021#20957#26102#38388':'
        Transparent = True
      end
      object Label28: TLabel
        Left = 1
        Top = 191
        Width = 54
        Height = 12
        Caption = #32456#20957#26102#38388':'
        Transparent = True
      end
      object Label29: TLabel
        Left = 0
        Top = 115
        Width = 54
        Height = 12
        Caption = #27604#34920#38754#31215':'
        Transparent = True
      end
      object Label30: TLabel
        Left = 2
        Top = 61
        Width = 54
        Height = 12
        Caption = #23433' '#23450' '#24615':'
        Transparent = True
      end
      object Label31: TLabel
        Left = 157
        Top = 33
        Width = 54
        Height = 12
        Caption = #19977#27687#21270#30827':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label32: TLabel
        Left = 157
        Top = 61
        Width = 54
        Height = 12
        Caption = #28903' '#22833' '#37327':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label34: TLabel
        Left = 314
        Top = 88
        Width = 54
        Height = 12
        Caption = #28216' '#31163' '#38041':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label38: TLabel
        Left = 157
        Top = 191
        Width = 54
        Height = 12
        Caption = #30789' '#37240' '#30416':'
        Transparent = True
      end
      object Label39: TLabel
        Left = 157
        Top = 164
        Width = 54
        Height = 12
        Caption = #38041' '#30789' '#27604':'
        Transparent = True
      end
      object Label40: TLabel
        Left = 157
        Top = 115
        Width = 54
        Height = 12
        Caption = #20445' '#27700' '#29575':'
        Transparent = True
      end
      object Label41: TLabel
        Left = 314
        Top = 5
        Width = 54
        Height = 12
        Caption = #30707#33167#31181#31867':'
        Transparent = True
      end
      object Label42: TLabel
        Left = 314
        Top = 33
        Width = 54
        Height = 12
        Caption = #30707' '#33167' '#37327':'
      end
      object Label43: TLabel
        Left = 2
        Top = 5
        Width = 54
        Height = 12
        Caption = #28151#21512#26448#31867':'
      end
      object Label44: TLabel
        Left = 2
        Top = 33
        Width = 54
        Height = 12
        Caption = #28151#21512#26448#37327':'
        Transparent = True
      end
      object Label1: TLabel
        Left = 314
        Top = 115
        Width = 54
        Height = 12
        Caption = #31881' '#29028' '#28784':'
        Transparent = True
      end
      object Label2: TLabel
        Left = 314
        Top = 139
        Width = 54
        Height = 12
        Caption = #29123#29028#28809#28195':'
        Transparent = True
      end
      object Label3: TLabel
        Left = 314
        Top = 164
        Width = 54
        Height = 12
        Caption = #30719'    '#31881':'
        Transparent = True
      end
      object Label4: TLabel
        Left = 314
        Top = 191
        Width = 54
        Height = 12
        Caption = #21161' '#30952' '#21058':'
        Transparent = True
      end
      object lbl_3YaAVG: TLabel
        Left = 207
        Top = 258
        Width = 26
        Height = 13
        Caption = #22343#20540
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 36095
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lbl_28YaAVG: TLabel
        Left = 475
        Top = 258
        Width = 26
        Height = 13
        Caption = #22343#20540
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 36095
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label48: TLabel
        Left = 474
        Top = 61
        Width = 54
        Height = 12
        Caption = #30707' '#28784' '#30707':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label49: TLabel
        Left = 474
        Top = 88
        Width = 54
        Height = 12
        Caption = #39029'    '#23721':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Label50: TLabel
        Left = 474
        Top = 5
        Width = 54
        Height = 12
        Caption = #30719'    '#28195':'
        Transparent = True
      end
      object Label51: TLabel
        Left = 474
        Top = 33
        Width = 54
        Height = 12
        Caption = #33073#30827#30707#33167':'
      end
      object Label52: TLabel
        Left = 474
        Top = 115
        Width = 54
        Height = 12
        Caption = '45um'#31579#20313':'
        Transparent = True
      end
      object Label53: TLabel
        Left = 474
        Top = 139
        Width = 54
        Height = 12
        Caption = #27700' '#28784' '#27604':'
        Transparent = True
      end
      object Label54: TLabel
        Left = 474
        Top = 164
        Width = 54
        Height = 12
        Caption = #35797' '#39292' '#27861':'
        Transparent = True
      end
      object Label55: TLabel
        Left = 474
        Top = 191
        Width = 54
        Height = 12
        Caption = #38647' '#27663' '#27861':'
        Transparent = True
      end
      object Label56: TLabel
        Left = 626
        Top = 5
        Width = 42
        Height = 12
        Caption = #27969#21160#24230':'
        Transparent = True
      end
      object cxTextEdit29: TcxTextEdit
        Left = 76
        Top = 222
        Hint = 'E.R_3DZhe1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 24
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit30: TcxTextEdit
        Left = 76
        Top = 247
        Hint = 'E.R_3DYa1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 27
        OnExit = cxTextEdit30Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit31: TcxTextEdit
        Left = 345
        Top = 222
        Hint = 'E.R_28Zhe1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 33
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit32: TcxTextEdit
        Left = 345
        Top = 247
        Hint = 'E.R_28Ya1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 36
        OnExit = cxTextEdit32Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit33: TcxTextEdit
        Left = 385
        Top = 222
        Hint = 'E.R_28Zhe2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 34
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit34: TcxTextEdit
        Left = 424
        Top = 222
        Hint = 'E.R_28Zhe3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 35
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit35: TcxTextEdit
        Left = 385
        Top = 247
        Hint = 'E.R_28Ya2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 37
        OnExit = cxTextEdit32Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit36: TcxTextEdit
        Left = 424
        Top = 247
        Hint = 'E.R_28Ya3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 38
        OnExit = cxTextEdit32Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit37: TcxTextEdit
        Left = 116
        Top = 222
        Hint = 'E.R_3DZhe2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 25
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit38: TcxTextEdit
        Left = 116
        Top = 247
        Hint = 'E.R_3DYa2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 28
        OnExit = cxTextEdit30Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit39: TcxTextEdit
        Left = 156
        Top = 222
        Hint = 'E.R_3DZhe3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 26
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit40: TcxTextEdit
        Left = 156
        Top = 247
        Hint = 'E.R_3DYa3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 29
        OnExit = cxTextEdit30Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit41: TcxTextEdit
        Left = 76
        Top = 264
        Hint = 'E.R_3DYa4'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 30
        OnExit = cxTextEdit30Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit42: TcxTextEdit
        Left = 116
        Top = 264
        Hint = 'E.R_3DYa5'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 31
        OnExit = cxTextEdit30Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit43: TcxTextEdit
        Left = 156
        Top = 264
        Hint = 'E.R_3DYa6'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 32
        OnExit = cxTextEdit30Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit47: TcxTextEdit
        Left = 345
        Top = 264
        Hint = 'E.R_28Ya4'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 39
        OnExit = cxTextEdit32Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit48: TcxTextEdit
        Left = 385
        Top = 264
        Hint = 'E.R_28Ya5'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 40
        OnExit = cxTextEdit32Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit49: TcxTextEdit
        Left = 424
        Top = 264
        Hint = 'E.R_28Ya6'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 41
        OnExit = cxTextEdit32Exit
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit17: TcxTextEdit
        Left = 214
        Top = -2
        Hint = 'E.R_MgO'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 8
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit18: TcxTextEdit
        Left = 214
        Top = 78
        Hint = 'E.R_CL'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 11
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit19: TcxTextEdit
        Left = 59
        Top = 78
        Hint = 'E.R_XiDu'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 3
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit20: TcxTextEdit
        Left = 58
        Top = 130
        Hint = 'E.R_ChouDu'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 5
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit21: TcxTextEdit
        Left = 214
        Top = 130
        Hint = 'E.R_BuRong'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 13
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit22: TcxTextEdit
        Left = 369
        Top = 51
        Hint = 'E.R_Jian'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 18
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit23: TcxTextEdit
        Left = 214
        Top = 24
        Hint = 'E.R_SO3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 9
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit24: TcxTextEdit
        Left = 214
        Top = 52
        Hint = 'E.R_ShaoShi'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 10
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit25: TcxTextEdit
        Left = 59
        Top = 52
        Hint = 'E.R_AnDing'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 2
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit26: TcxTextEdit
        Left = 59
        Top = 102
        Hint = 'E.R_BiBiao'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 4
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit27: TcxTextEdit
        Left = 59
        Top = 183
        Hint = 'E.R_ZhongNing'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 7
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit28: TcxTextEdit
        Left = 59
        Top = 155
        Hint = 'E.R_ChuNing'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 6
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit45: TcxTextEdit
        Left = 368
        Top = 78
        Hint = 'E.R_YLiGai'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 19
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit52: TcxTextEdit
        Left = 214
        Top = 182
        Hint = 'E.R_KuangWu'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 15
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit53: TcxTextEdit
        Left = 214
        Top = 155
        Hint = 'E.R_GaiGui'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 14
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit54: TcxTextEdit
        Left = 214
        Top = 104
        Hint = 'E.R_Water'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 12
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit55: TcxTextEdit
        Left = 370
        Top = 0
        Hint = 'E.R_SGType'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 16
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit56: TcxTextEdit
        Left = 370
        Top = 26
        Hint = 'E.R_SGValue'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 17
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit57: TcxTextEdit
        Left = 59
        Top = -2
        Hint = 'E.R_HHCType'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 0
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit58: TcxTextEdit
        Left = 59
        Top = 24
        Hint = 'E.R_HHCValue'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 1
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit1: TcxTextEdit
        Left = 372
        Top = 102
        Hint = 'E.R_FMH'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 20
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit2: TcxTextEdit
        Left = 371
        Top = 130
        Hint = 'E.R_RMLZ'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 21
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit3: TcxTextEdit
        Left = 371
        Top = 155
        Hint = 'E.R_KF'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 22
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit4: TcxTextEdit
        Left = 371
        Top = 180
        Hint = 'E.R_ZMJ'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 23
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxGroupBox1: TcxGroupBox
        Left = -1
        Top = 288
        Caption = #31881#29028#28784#29305#23450#26816#39564#25968#25454
        ParentFont = False
        TabOrder = 42
        Height = 44
        Width = 550
        object Label5: TLabel
          Left = 4
          Top = 21
          Width = 54
          Height = 12
          Caption = #38656#27700#37327#27604':'
          Transparent = True
        end
        object Label6: TLabel
          Left = 138
          Top = 21
          Width = 54
          Height = 12
          Caption = #23494'    '#24230':'
          Transparent = True
        end
        object Label7: TLabel
          Left = 276
          Top = 21
          Width = 54
          Height = 12
          Caption = #36136#37327#20998#25968':'
          Transparent = True
        end
        object Label8: TLabel
          Left = 412
          Top = 20
          Width = 54
          Height = 12
          Caption = #27963#24615#25351#25968':'
          Transparent = True
        end
        object lbl1: TLabel
          Left = 6
          Top = 53
          Width = 48
          Height = 12
          Caption = '7'#22825#27963#24615':'
          Transparent = True
        end
        object lbl2: TLabel
          Left = 139
          Top = 53
          Width = 54
          Height = 12
          Caption = '28'#22825#27963#24615':'
          Transparent = True
        end
        object lbl3: TLabel
          Left = 273
          Top = 54
          Width = 54
          Height = 12
          Caption = #27969' '#21160' '#27604':'
          Transparent = True
        end
        object cxTextEdit5: TcxTextEdit
          Left = 62
          Top = 16
          Hint = 'E.R_FMHXSLB'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 0
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit6: TcxTextEdit
          Left = 195
          Top = 16
          Hint = 'E.R_FMHMD'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 1
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit7: TcxTextEdit
          Left = 335
          Top = 16
          Hint = 'E.R_FMHZLFS'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 2
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit8: TcxTextEdit
          Left = 471
          Top = 16
          Hint = 'E.R_FMHHXZS'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 3
          OnKeyPress = cxTextEdit17KeyPress
          Width = 75
        end
        object edt_1: TcxTextEdit
          Left = 62
          Top = 49
          Hint = 'E.R_7HuoXing'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 4
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object edt_11: TcxTextEdit
          Left = 195
          Top = 49
          Hint = 'E.R_28HuoXing'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 5
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object edt_12: TcxTextEdit
          Left = 332
          Top = 49
          Hint = 'E.R_LiuDong'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 6
          OnKeyPress = cxTextEdit17KeyPress
          Width = 75
        end
      end
      object cxGroupBox2: TcxGroupBox
        Left = 0
        Top = 371
        Caption = #26426#21046#30722#29305#23450#26816#39564#25968#25454
        ParentFont = False
        TabOrder = 43
        Height = 150
        Width = 550
        object Label9: TLabel
          Left = 4
          Top = 22
          Width = 54
          Height = 12
          Caption = 'MB    '#20540':'
          Transparent = True
        end
        object Label10: TLabel
          Left = 138
          Top = 21
          Width = 54
          Height = 12
          Caption = #30707#31881#21547#37327':'
          Transparent = True
        end
        object Label11: TLabel
          Left = 276
          Top = 21
          Width = 54
          Height = 12
          Caption = #27877#22359#21547#37327':'
          Transparent = True
        end
        object Label12: TLabel
          Left = 412
          Top = 20
          Width = 66
          Height = 12
          Caption = #22362#22266#24615#25351#26631':'
          Transparent = True
        end
        object Label13: TLabel
          Left = 4
          Top = 45
          Width = 54
          Height = 12
          Caption = #21387#30862#25351#26631':'
          Transparent = True
        end
        object Label14: TLabel
          Left = 138
          Top = 45
          Width = 54
          Height = 12
          Caption = #34920#35266#23494#24230':'
          Transparent = True
        end
        object Label15: TLabel
          Left = 276
          Top = 45
          Width = 78
          Height = 12
          Caption = #26494#25955#22534#31215#23494#24230':'
          Transparent = True
        end
        object Label16: TLabel
          Left = 428
          Top = 44
          Width = 42
          Height = 12
          Caption = #23380#38553#29575':'
          Transparent = True
        end
        object Label33: TLabel
          Left = 4
          Top = 76
          Width = 66
          Height = 12
          Caption = #26041#23380#31579'4.75:'
          Transparent = True
        end
        object Label35: TLabel
          Left = 148
          Top = 76
          Width = 66
          Height = 12
          Caption = #26041#23380#31579'2.36:'
          Transparent = True
        end
        object Label36: TLabel
          Left = 292
          Top = 76
          Width = 66
          Height = 12
          Caption = #26041#23380#31579'1.18:'
          Transparent = True
        end
        object Label37: TLabel
          Left = 4
          Top = 100
          Width = 66
          Height = 12
          Caption = #26041#23380#31579'0.6 :'
          Transparent = True
        end
        object Label45: TLabel
          Left = 148
          Top = 100
          Width = 66
          Height = 12
          Caption = #26041#23380#31579'0.3 :'
          Transparent = True
        end
        object Label46: TLabel
          Left = 292
          Top = 100
          Width = 66
          Height = 12
          Caption = #26041#23380#31579'0.15:'
          Transparent = True
        end
        object Label47: TLabel
          Left = 4
          Top = 124
          Width = 66
          Height = 12
          Caption = #32454#24230#27169#25968'  :'
          Transparent = True
        end
        object cxTextEdit9: TcxTextEdit
          Left = 62
          Top = 16
          Hint = 'E.R_JZSMBZ'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 11
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit10: TcxTextEdit
          Left = 195
          Top = 16
          Hint = 'E.R_JZSSFHL'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 12
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit11: TcxTextEdit
          Left = 335
          Top = 16
          Hint = 'E.R_JZSNKHL'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 13
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit12: TcxTextEdit
          Left = 478
          Top = 16
          Hint = 'E.R_JZSJGXZB'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 14
          OnKeyPress = cxTextEdit17KeyPress
          Width = 65
        end
        object cxTextEdit13: TcxTextEdit
          Left = 62
          Top = 40
          Hint = 'E.R_JZSYSZB'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 0
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit14: TcxTextEdit
          Left = 195
          Top = 40
          Hint = 'E.R_JZSBGMD'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 1
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit15: TcxTextEdit
          Left = 353
          Top = 40
          Hint = 'E.R_JZSSSDJMD'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 2
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit16: TcxTextEdit
          Left = 477
          Top = 40
          Hint = 'E.R_JZSKXL'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 3
          OnKeyPress = cxTextEdit17KeyPress
          Width = 65
        end
        object cxTextEdit44: TcxTextEdit
          Left = 70
          Top = 72
          Hint = 'E.R_JZSFKS475'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 4
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit46: TcxTextEdit
          Left = 214
          Top = 72
          Hint = 'E.R_JZSFKS236'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 5
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit50: TcxTextEdit
          Left = 358
          Top = 72
          Hint = 'E.R_JZSFKS118'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 6
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit51: TcxTextEdit
          Left = 70
          Top = 96
          Hint = 'E.R_JZSFKS060'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 7
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit59: TcxTextEdit
          Left = 214
          Top = 96
          Hint = 'E.R_JZSFKS030'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 8
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit60: TcxTextEdit
          Left = 358
          Top = 96
          Hint = 'E.R_JZSFKS015'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 9
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
        object cxTextEdit61: TcxTextEdit
          Left = 70
          Top = 120
          Hint = 'E.R_JZSXDMS'
          ParentFont = False
          Properties.MaxLength = 20
          TabOrder = 10
          OnKeyPress = cxTextEdit17KeyPress
          Width = 74
        end
      end
      object cxTextEdit62: TcxTextEdit
        Left = 529
        Top = 51
        Hint = 'E.R_shs'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 44
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit63: TcxTextEdit
        Left = 528
        Top = 78
        Hint = 'E.R_Yy'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 45
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit64: TcxTextEdit
        Left = 530
        Top = 0
        Hint = 'E.R_KZ'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 46
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit65: TcxTextEdit
        Left = 530
        Top = 26
        Hint = 'E.R_tlsg'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 47
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit66: TcxTextEdit
        Left = 532
        Top = 102
        Hint = 'E.R_45sy'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 48
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit67: TcxTextEdit
        Left = 531
        Top = 130
        Hint = 'E.R_shb'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 49
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit68: TcxTextEdit
        Left = 531
        Top = 155
        Hint = 'E.R_sbf'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 50
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit69: TcxTextEdit
        Left = 531
        Top = 180
        Hint = 'E.R_lsf'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 51
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
      object cxTextEdit70: TcxTextEdit
        Left = 666
        Top = 0
        Hint = 'E.R_ldd'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 52
        OnKeyPress = cxTextEdit17KeyPress
        Width = 90
      end
    end
    object EditDate: TcxDateEdit
      Left = 81
      Top = 87
      Hint = 'E.R_Date'
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
      TabOrder = 2
      Width = 220
    end
    object EditMan: TcxTextEdit
      Left = 364
      Top = 36
      Hint = 'E.R_Man'
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
      TabOrder = 7
      Width = 210
    end
    object EditCXDate: TcxDateEdit
      Left = 364
      Top = 87
      Hint = 'E.R_CXDate'
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
      TabOrder = 3
      Width = 210
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        CaptionOptions.Text = #22522#26412#20449#24687
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item1: TdxLayoutItem
            CaptionOptions.Text = #25209#27425#32534#21495':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item3: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #24405#20837#20154':'
            Control = EditMan
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item12: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #25152#23646#21697#31181':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item2: TdxLayoutItem
            CaptionOptions.Text = #21462#26679#26085#26399':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayoutControl1Item5: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #25104#22411#26085#26399':'
            Control = EditCXDate
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AlignVert = avClient
        CaptionOptions.Text = #26816#39564#25968#25454
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Item4: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = 'Panel1'
          CaptionOptions.Visible = False
          Control = wPanel
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        AlignVert = avBottom
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item10: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button3'
          CaptionOptions.Visible = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item11: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button4'
          CaptionOptions.Visible = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
