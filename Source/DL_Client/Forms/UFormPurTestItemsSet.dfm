inherited fFormPurTestItemsSet: TfFormPurTestItemsSet
  Left = 690
  Top = 318
  Caption = #36136#26816#39033
  ClientHeight = 251
  ClientWidth = 427
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 427
    Height = 251
    inherited BtnOK: TButton
      Left = 265
      Top = 212
      Width = 73
      Height = 28
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 343
      Top = 212
      Width = 73
      Height = 28
      TabOrder = 5
    end
    object Edt_1: TcxButtonEdit [2]
      Left = 87
      Top = 57
      ParentFont = False
      Properties.Buttons = <>
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 261
    end
    object cxlbl1: TcxLabel [3]
      Left = 23
      Top = 36
      Caption = #26631#20934#20449#24687#65306
      ParentColor = False
      ParentFont = False
      Style.Color = clWhite
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
    object Mmo_1: TcxMemo [4]
      Left = 87
      Top = 89
      ParentFont = False
      TabOrder = 2
      Height = 51
      Width = 317
    end
    object Mmo_GS: TcxMemo [5]
      Left = 87
      Top = 145
      ParentFont = False
      TabOrder = 3
      Height = 51
      Width = 317
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytmLayout1Item4: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxlbl1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #26816#27979#39033#21517#65306
          Control = Edt_1
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item42: TdxLayoutItem
          Caption = #21028#23450#26465#20214#65306
          Control = Mmo_1
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item41: TdxLayoutItem
          Caption = #20844'    '#24335#65306
          Control = Mmo_GS
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
