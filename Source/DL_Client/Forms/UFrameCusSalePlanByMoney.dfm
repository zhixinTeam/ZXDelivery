inherited fFrameCusSalePlanByMoney: TfFrameCusSalePlanByMoney
  Width = 788
  Height = 407
  inherited ToolBar1: TToolBar
    Width = 788
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
    inherited S1: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 788
    Height = 205
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 788
    Height = 135
    object cxTextEdit3: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.A_CID'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 115
    end
    object cxTextEdit4: TcxTextEdit [1]
      Left = 259
      Top = 93
      Hint = 'T.C_Name'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 150
    end
    object EditCustomer: TcxButtonEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 150
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#32534#21495':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 788
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 788
    inherited TitleBar: TcxLabel
      Caption = #38144#21806#23458#25143#38480#37327#25511#21046#65288#37329#39069#65289
      Style.IsFontAssigned = True
      Width = 788
      AnchorX = 394
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 8
    Top = 248
  end
  inherited DataSource1: TDataSource
    Left = 36
    Top = 248
  end
end
