inherited fFormPurTestPlanSet: TfFormPurTestPlanSet
  Left = 875
  Top = 337
  Caption = #36136#26816#26041#26696
  ClientHeight = 138
  ClientWidth = 371
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 371
    Height = 138
    inherited BtnOK: TButton
      Left = 205
      Top = 100
      Width = 75
      Height = 27
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 285
      Top = 100
      Width = 75
      Height = 27
      TabOrder = 2
    end
    object Edt_1: TcxButtonEdit [2]
      Left = 87
      Top = 36
      ParentFont = False
      Properties.Buttons = <>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 272
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytmLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #26041#26696#21517#31216#65306
          Control = Edt_1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
