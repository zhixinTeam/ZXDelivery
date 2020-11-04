inherited fFormTruck: TfFormTruck
  Left = 804
  Top = 258
  ClientHeight = 437
  ClientWidth = 430
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 430
    Height = 437
    inherited BtnOK: TButton
      Left = 284
      Top = 404
      TabOrder = 19
    end
    inherited BtnExit: TButton
      Left = 354
      Top = 404
      TabOrder = 20
    end
    object EditTruck: TcxTextEdit [2]
      Left = 105
      Top = 36
      ParentFont = False
      Properties.MaxLength = 15
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 119
    end
    object EditOwner: TcxTextEdit [3]
      Left = 287
      Top = 36
      ParentFont = False
      Properties.MaxLength = 100
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 120
    end
    object EditPhone: TcxTextEdit [4]
      Left = 105
      Top = 61
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      Width = 302
    end
    object CheckValid: TcxCheckBox [5]
      Left = 23
      Top = 319
      Caption = #36710#36742#20801#35768#24320#21333'.'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 14
      Transparent = True
      Width = 384
    end
    object CheckVerify: TcxCheckBox [6]
      Left = 23
      Top = 371
      Caption = #39564#35777#36710#36742#24050#21040#20572#36710#22330'.'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 17
      Transparent = True
      Width = 165
    end
    object CheckUserP: TcxCheckBox [7]
      Left = 23
      Top = 345
      Caption = #36710#36742#20351#29992#39044#32622#30382#37325'.'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 15
      Transparent = True
      Width = 165
    end
    object CheckVip: TcxCheckBox [8]
      Left = 193
      Top = 345
      Caption = 'VIP'#36710#36742
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 16
      Transparent = True
      Width = 100
    end
    object CheckGPS: TcxCheckBox [9]
      Left = 193
      Top = 371
      Caption = #24050#23433#35013'GPS'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 18
      Transparent = True
      Width = 100
    end
    object EditXTNum: TcxTextEdit [10]
      Left = 105
      Top = 236
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 11
      Text = '0'
      Width = 302
    end
    object edt_LimitedValue: TcxTextEdit [11]
      Left = 105
      Top = 261
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 12
      Text = '0'
      Width = 88
    end
    object edt_LimitedValueMin: TcxTextEdit [12]
      Left = 280
      Top = 261
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 13
      Text = '0'
      Width = 127
    end
    object EditColor: TcxTextEdit [13]
      Left = 268
      Top = 161
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 7
      Width = 139
    end
    object EditType: TcxTextEdit [14]
      Left = 105
      Top = 161
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 6
      Width = 100
    end
    object EditStock: TcxTextEdit [15]
      Left = 105
      Top = 186
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 8
      Width = 100
    end
    object EditPF: TcxTextEdit [16]
      Left = 268
      Top = 186
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 9
      Width = 139
    end
    object EditPrePValue: TcxTextEdit [17]
      Left = 105
      Top = 211
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 10
      Width = 302
    end
    object edt_XSZ: TcxTextEdit [18]
      Left = 105
      Top = 86
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Width = 100
    end
    object edt_XCZ: TcxTextEdit [19]
      Left = 105
      Top = 136
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 5
      Width = 100
    end
    object edt_DLYSZ: TcxTextEdit [20]
      Left = 105
      Top = 111
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      Width = 100
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #36710#29260#21495#30721':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #36710#20027#22995#21517':'
            Control = EditOwner
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #32852#31995#26041#24335':'
          Control = EditPhone
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item17: TdxLayoutItem
          Caption = #39550#39542#35777#21495':'
          Control = edt_XSZ
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item172: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #36947#36335#36816#36755#35777':'
          Control = edt_DLYSZ
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item171: TdxLayoutItem
          Caption = #34892#36710#35777#21495':'
          Control = edt_XCZ
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item13: TdxLayoutItem
              Caption = #36710#36742#31867#22411':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item12: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #36710#29260#39068#33394':'
              Control = EditColor
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item14: TdxLayoutItem
              Caption = #21697'    '#31181':'
              Control = EditStock
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item15: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #25490#25918#26631#20934':'
              Control = EditPF
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item16: TdxLayoutItem
            Caption = #39044#32622#30382#37325':'
            Control = EditPrePValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item11: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #26368#22823#24320#21333#37327':'
            Control = EditXTNum
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxlytm_MValueMax: TdxLayoutItem
              Caption = #27611#37325#38480#36733#19978#38480':'
              Control = edt_LimitedValue
              ControlOptions.ShowBorder = False
            end
            object dxlytm_MValeMin: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #27611#37325#38480#36733#19979#38480':'
              Control = edt_LimitedValueMin
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #36710#36742#21442#25968
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = CheckValid
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            ShowCaption = False
            Control = CheckUserP
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = CheckVip
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = 'cxCheckBox2'
            ShowCaption = False
            Control = CheckVerify
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = CheckGPS
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
    object TdxLayoutItem
    end
    object TdxLayoutItem
    end
  end
end
