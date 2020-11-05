inherited fFrameQueryLadingTimeOutTruck: TfFrameQueryLadingTimeOutTruck
  Width = 792
  Height = 404
  inherited ToolBar1: TToolBar
    Width = 792
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 163
    Width = 792
    Height = 241
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 792
    Height = 96
    object EditTruck: TcxButtonEdit [0]
      Left = 75
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      Width = 115
    end
    object edt_Time: TcxTextEdit [1]
      Left = 540
      Top = 36
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.MaxLength = 100
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Text = '60'
      OnExit = edt_TimeExit
      Width = 55
    end
    object Chk1: TcxCheckBox [2]
      Left = 600
      Top = 36
      Caption = #27599#38548'5'#20998#38047#33258#21160#21047#26032
      ParentColor = False
      ParentFont = False
      Properties.OnChange = Chk1PropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Color = clWhite
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #24494#36719#38597#40657
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Width = 144
    end
    object EditDate: TcxButtonEdit [3]
      Left = 235
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      Width = 188
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#65306
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #26102#38388#65306
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          CaptionOptions.Text = #36229#26102#26102#38388#65288#20998#38047#65289#65306
          Control = edt_Time
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Control = Chk1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 155
    Width = 792
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 792
    inherited TitleBar: TcxLabel
      Caption = #35013#36710#36229#26102#36710#36742
      Style.IsFontAssigned = True
      Width = 792
      AnchorX = 396
      AnchorY = 11
    end
  end
  object tmr1: TTimer
    Enabled = False
    Interval = 300000
    Left = 89
    Top = 202
  end
end
