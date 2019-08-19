inherited fFormDriverWh: TfFormDriverWh
  Left = 586
  Top = 381
  ClientHeight = 208
  ClientWidth = 375
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 375
    Height = 208
    inherited BtnOK: TButton
      Left = 229
      Top = 175
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 299
      Top = 175
      TabOrder = 4
    end
    object EditName: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 0
      OnKeyPress = EditNameKeyPress
      Width = 125
    end
    object EditPinYin: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      TabOrder = 1
      OnKeyPress = EditNameKeyPress
      Width = 121
    end
    object EditIDCard: TcxTextEdit [4]
      Left = 81
      Top = 86
      ParentFont = False
      TabOrder = 2
      OnKeyPress = EditNameKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #21496#26426#22995#21517':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #22995#21517#20840#25340':'
          Control = EditPinYin
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36523#20221#35777#21495':'
          Control = EditIDCard
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
