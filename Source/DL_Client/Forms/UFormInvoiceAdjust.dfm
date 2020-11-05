inherited fFormInvoiceAdjust: TfFormInvoiceAdjust
  Left = 473
  Top = 334
  ClientHeight = 175
  ClientWidth = 329
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 329
    Height = 175
    OptionsItem.AutoControlAreaAlignment = False
    inherited BtnOK: TButton
      Left = 183
      Top = 142
      Caption = #30830#23450
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 253
      Top = 142
      TabOrder = 5
    end
    object EditPrice: TcxTextEdit [2]
      Left = 93
      Top = 85
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 121
    end
    object cxLabel2: TcxLabel [3]
      Left = 23
      Top = 64
      Caption = 'xxxx'
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaTop
      Transparent = True
    end
    object EditValue: TcxTextEdit [4]
      Left = 81
      Top = 39
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 121
    end
    object cxLabel1: TcxLabel [5]
      Left = 23
      Top = 18
      Caption = 'xxxx'
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        CaptionOptions.Text = ''
        object dxLayout1Item6: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel2'
          CaptionOptions.Visible = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = '  '#30003#35831#37327':'
          Control = EditValue
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel1'
          CaptionOptions.Visible = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = '  '#24320#31080#21333#20215':'
          Control = EditPrice
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        inherited dxLayout1Item1: TdxLayoutItem
          AlignVert = avBottom
        end
      end
    end
  end
end
