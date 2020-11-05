inherited fFormSaleMValueInfo: TfFormSaleMValueInfo
  Left = 586
  Top = 381
  ClientHeight = 139
  ClientWidth = 375
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 375
    Height = 139
    inherited BtnOK: TButton
      Left = 229
      Top = 106
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 299
      Top = 106
      TabOrder = 2
    end
    object EditMValueMax: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 100
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      Width = 125
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #27611#37325#19978#38480':'
          Control = EditMValueMax
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
