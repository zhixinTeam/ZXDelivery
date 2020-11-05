inherited fFormPurSampleBatch: TfFormPurSampleBatch
  Left = 750
  Top = 236
  Caption = #35746#21333#21462#26679#32452#25209
  ClientHeight = 344
  ClientWidth = 451
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 451
    Height = 344
    inherited BtnOK: TButton
      Left = 275
      Top = 305
      Width = 80
      Height = 28
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 360
      Top = 305
      Width = 80
      Height = 28
      TabOrder = 6
    end
    object cxlbl_BZ: TcxLabel [2]
      Left = 23
      Top = 260
      Caption = #26631#20934#21517#31216#65306
      ParentColor = False
      ParentFont = False
      Style.Color = clWhite
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
    object cxlbl3: TcxLabel [3]
      Left = 23
      Top = 248
      Caption = '    '
      ParentColor = False
      ParentFont = False
      Style.Color = clWhite
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -1
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
    object cxgrpbx1: TcxGroupBox [4]
      Left = 23
      Top = 36
      Caption = #21462#26679#29289#26009#20449#24687
      ParentColor = False
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Color = clWindow
      TabOrder = 0
      Height = 153
      Width = 405
      object cxlbl_ProInfo: TcxLabel
        Left = 12
        Top = 18
        Caption = #20379#24212#21830#21517#65306
        ParentColor = False
        ParentFont = False
        Style.Color = clWhite
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
      end
      object cxlbl_MaInfo: TcxLabel
        Left = 12
        Top = 44
        Caption = #21462#26679#29289#26009#65306
        ParentColor = False
        ParentFont = False
        Style.Color = clWhite
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
      end
      object cxlbl_Value: TcxLabel
        Left = 11
        Top = 70
        Caption = #32452#25209#24635#37327#65306
        ParentColor = False
        ParentFont = False
        Style.Color = clWhite
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
      end
      object cxlbl_Trucks: TcxLabel
        Left = 11
        Top = 95
        Caption = #36865#36135#36710#36742#65306
        ParentColor = False
        ParentFont = False
        Style.Color = clWhite
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = #24494#36719#38597#40657
        Style.Font.Style = []
        Style.IsFontAssigned = True
      end
    end
    object cxgrpbx2: TcxGroupBox [5]
      Left = 23
      Top = 194
      Caption = '                                    '#26816#39564#26631#20934#20449#24687
      Ctl3D = False
      DragCursor = crDefault
      DragKind = dkDock
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Color = clWindow
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 1
      Height = 19
      Width = 405
    end
    object Edt_SID: TcxButtonEdit [6]
      Left = 111
      Top = 218
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = Edt_InspectionStandardPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.IsFontAssigned = True
      TabOrder = 2
      Width = 317
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytmLayout1Item35: TdxLayoutItem
          CaptionOptions.Text = 'cxGroupBox1'
          CaptionOptions.Visible = False
          Control = cxgrpbx1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item34: TdxLayoutItem
          CaptionOptions.Visible = False
          Control = cxgrpbx2
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #36873#25321#26816#39564#26631#20934#65306
          Control = Edt_SID
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item33: TdxLayoutItem
          CaptionOptions.Visible = False
          Control = cxlbl3
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item31: TdxLayoutItem
          CaptionOptions.Text = #29289#26009#20449#24687#65306
          CaptionOptions.Visible = False
          Control = cxlbl_BZ
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object cxlbl_Num: TcxLabel
    Left = 34
    Top = 155
    Caption = #21512#35745#36710#25968#65306
    ParentColor = False
    ParentFont = False
    Style.Color = clWhite
    Style.Font.Charset = GB2312_CHARSET
    Style.Font.Color = clBlack
    Style.Font.Height = -13
    Style.Font.Name = #24494#36719#38597#40657
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
end
