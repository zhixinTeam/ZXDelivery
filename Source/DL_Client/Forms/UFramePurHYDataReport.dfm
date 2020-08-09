inherited fFramePurHYDataReport: TfFramePurHYDataReport
  inherited ToolBar1: TToolBar
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
    Top = 134
    Height = 233
  end
  inherited dxLayout1: TdxLayoutControl
    Height = 67
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
      TabOrder = 0
      Width = 176
    end
    object Edit_Name: TcxButtonEdit [1]
      Left = 320
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Width = 176
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #21462#26679#26085#26399#65306
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #20851#38190#23383#65306
          Control = Edit_Name
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 126
  end
  inherited TitlePanel1: TZnBitmapPanel
    inherited TitleBar: TcxLabel
      Caption = #21407#26009#36136#26816#32467#26524
      Style.IsFontAssigned = True
      AnchorX = 294
      AnchorY = 11
    end
  end
end
