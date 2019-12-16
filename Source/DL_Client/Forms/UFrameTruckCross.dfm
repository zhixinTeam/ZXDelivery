inherited fFrameTruckCross: TfFrameTruckCross
  Width = 937
  Height = 428
  inherited ToolBar1: TToolBar
    Width = 937
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Visible = False
      OnClick = BtnDelClick
    end
    inherited S1: TToolButton
      Visible = False
    end
    inherited BtnRefresh: TToolButton
      Caption = #21047#26032' '
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 217
    Width = 937
    Height = 211
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 937
    Height = 150
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.L_Truck'
      ParentFont = False
      TabOrder = 3
      Width = 125
    end
    object EditTruck: TcxButtonEdit [1]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [2]
      Left = 257
      Top = 93
      Hint = 'T.C_Reader'
      ParentFont = False
      TabOrder = 4
      Width = 125
    end
    object EditDate: TcxButtonEdit [3]
      Left = 445
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 2
      Width = 185
    end
    object EditReader: TcxButtonEdit [4]
      Left = 257
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #35835#21345#22120':'
          Control = EditReader
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #35835#21345#22120':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 209
    Width = 937
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 937
    inherited TitleBar: TcxLabel
      Caption = #36710#36742#36890#34892#35760#24405#26597#35810
      Style.IsFontAssigned = True
      Width = 937
      AnchorX = 469
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 10
    Top = 252
  end
  inherited DataSource1: TDataSource
    Left = 38
    Top = 252
  end
end
