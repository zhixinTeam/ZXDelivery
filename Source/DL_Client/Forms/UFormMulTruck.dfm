inherited fFormMulTruck: TfFormMulTruck
  Left = 522
  Top = 278
  ClientHeight = 167
  ClientWidth = 375
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 375
    Height = 167
    inherited BtnOK: TButton
      Left = 229
      Top = 134
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 299
      Top = 134
      TabOrder = 3
    end
    object CheckValid: TcxCheckBox [2]
      Left = 23
      Top = 101
      Caption = #36710#36742#20801#35768#24320#21333'.'
      ParentFont = False
      TabOrder = 1
      Transparent = True
      Width = 80
    end
    object EditXTNum: TcxTextEdit [3]
      Left = 93
      Top = 36
      ParentFont = False
      TabOrder = 0
      Text = '0'
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item11: TdxLayoutItem
          Caption = #26368#22823#24320#21333#37327':'
          Control = EditXTNum
          ControlOptions.ShowBorder = False
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
      end
    end
  end
end
