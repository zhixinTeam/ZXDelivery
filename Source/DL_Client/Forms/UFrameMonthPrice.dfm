inherited fFrameMonthPrice: TfFrameMonthPrice
  inherited dxLayout1: TdxLayoutControl
    object Button1: TButton [0]
      Left = 23
      Top = 36
      Width = 75
      Height = 25
      Caption = #25353#21306#22495#32479#35745
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton [1]
      Left = 103
      Top = 36
      Width = 75
      Height = 25
      Caption = #25353#35268#26684#32479#35745
      TabOrder = 1
      OnClick = Button2Click
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = 'Button1'
          CaptionOptions.Visible = False
          Control = Button1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          CaptionOptions.Text = 'Button2'
          CaptionOptions.Visible = False
          Control = Button2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited TitlePanel1: TZnBitmapPanel
    inherited TitleBar: TcxLabel
      Caption = #26376#22343#35064#20215
      Style.IsFontAssigned = True
      AnchorX = 301
      AnchorY = 11
    end
  end
end
