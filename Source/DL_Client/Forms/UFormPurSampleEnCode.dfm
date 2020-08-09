inherited fFormPurSampleEnCode: TfFormPurSampleEnCode
  Left = 704
  Top = 275
  Caption = #35774#32622#21152#23494#32534#30721
  ClientHeight = 125
  ClientWidth = 307
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 307
    Height = 125
    inherited BtnOK: TButton
      Left = 129
      Top = 88
      Width = 81
      Height = 26
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 215
      Top = 88
      Width = 81
      Height = 26
      TabOrder = 2
    end
    object Edt_Code: TcxButtonEdit [2]
      Left = 87
      Top = 36
      ParentFont = False
      Properties.Buttons = <>
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -16
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 287
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxlytm_Code: TdxLayoutItem
          Caption = #21152#23494#32534#30721#65306
          Control = Edt_Code
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
