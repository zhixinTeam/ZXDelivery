inherited fFormCusSalePlanByMoney: TfFormCusSalePlanByMoney
  Left = 1118
  Top = 240
  Caption = #38144#21806#38480#37327
  ClientHeight = 233
  ClientWidth = 365
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 365
    Height = 233
    inherited BtnOK: TButton
      Left = 219
      Top = 200
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 289
      Top = 200
      TabOrder = 6
    end
    object Edt_CName: TcxButtonEdit [2]
      Left = 87
      Top = 66
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = Edt_CNamePropertiesButtonClick
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      OnKeyPress = Edt_CNameKeyPress
      Width = 255
    end
    object edt_Money: TcxTextEdit [3]
      Left = 87
      Top = 96
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      Width = 153
    end
    object Edt_CID: TcxButtonEdit [4]
      Left = 87
      Top = 36
      ParentFont = False
      Properties.Buttons = <>
      Style.Edges = []
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 255
    end
    object DateETime: TcxDateEdit [5]
      Left = 87
      Top = 156
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      Width = 172
    end
    object DateSTime: TcxDateEdit [6]
      Left = 87
      Top = 126
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Width = 172
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytmLayout1Item32: TdxLayoutItem
          Caption = #23458#25143#21517#31216#65306
          Control = Edt_CID
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item3: TdxLayoutItem
          Caption = #23458#25143#21517#31216#65306
          Control = Edt_CName
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item31: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #27599#26085#38480#39069#65306
          Control = edt_Money
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item34: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #24320#22987#26102#38388#65306
          Control = DateSTime
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item33: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #32467#26463#26102#38388#65306
          Control = DateETime
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
