inherited fFramePurSampleEnCode: TfFramePurSampleEnCode
  inherited ToolBar1: TToolBar
    inherited BtnAdd: TToolButton
      Caption = #35774#32622#32534#30721
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #25764#38144#32534#30721
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 137
    Height = 230
  end
  inherited dxLayout1: TdxLayoutControl
    Height = 70
    object EditDate: TcxButtonEdit [0]
      Left = 87
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
      TabOrder = 0
      Width = 176
    end
    object Edt_Code: TcxButtonEdit [1]
      Left = 332
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      Width = 123
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #21462#26679#26085#26399#65306
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item2: TdxLayoutItem
          CaptionOptions.Text = #21152#23494#32534#30721#65306
          Control = Edt_Code
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 129
  end
  inherited TitlePanel1: TZnBitmapPanel
    inherited TitleBar: TcxLabel
      Caption = #21462#26679#21152#23494#32534#30721
      Style.IsFontAssigned = True
      AnchorX = 294
      AnchorY = 11
    end
  end
end
