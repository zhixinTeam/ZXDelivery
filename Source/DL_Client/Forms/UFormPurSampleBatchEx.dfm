inherited fFormPurSampleBatchEx: TfFormPurSampleBatchEx
  Left = 697
  Top = 309
  Caption = #20013#38388#21697#21462#26679#32452#25209
  ClientHeight = 252
  ClientWidth = 451
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 451
    Height = 252
    inherited BtnOK: TButton
      Left = 275
      Top = 213
      Width = 80
      Height = 28
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 360
      Top = 213
      Width = 80
      Height = 28
      TabOrder = 8
    end
    object cxlbl_BZ: TcxLabel [2]
      Left = 23
      Top = 172
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
      Top = 160
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
    object cxgrpbx2: TcxGroupBox [4]
      Left = 23
      Top = 106
      Caption = '                                    '#26816#39564#26631#20934#20449#24687
      Ctl3D = False
      DragCursor = crDefault
      DragKind = dkDock
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      Style.BorderStyle = ebsNone
      Style.Color = clWindow
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 3
      Height = 19
      Width = 405
    end
    object Edt_SID: TcxButtonEdit [5]
      Left = 87
      Top = 130
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = Edt_InspectionStandardPropertiesButtonClick
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      Width = 317
    end
    object EditMName: TcxButtonEdit [6]
      Left = 87
      Top = 64
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      OnKeyPress = EditMNameKeyPress
      Width = 121
    end
    object cxgrpbx3: TcxGroupBox [7]
      Left = 23
      Top = 89
      Caption = '                                    '
      Ctl3D = False
      DragCursor = crDefault
      DragKind = dkDock
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      Style.BorderStyle = ebsNone
      Style.Color = clWindow
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 2
      Height = 12
      Width = 405
    end
    object cxLabel1: TcxLabel [8]
      Left = 23
      Top = 36
      Caption = #29289#26009#32534#21495#65306
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
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item4: TdxLayoutItem
          Caption = #32452#25209#29289#26009#65306
          Control = EditMName
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item42: TdxLayoutItem
          ShowCaption = False
          Control = cxgrpbx3
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item34: TdxLayoutItem
          ShowCaption = False
          Control = cxgrpbx2
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #26816#39564#26631#20934#65306
          Control = Edt_SID
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item33: TdxLayoutItem
          ShowCaption = False
          Control = cxlbl3
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item31: TdxLayoutItem
          Caption = #29289#26009#20449#24687#65306
          ShowCaption = False
          Control = cxlbl_BZ
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
