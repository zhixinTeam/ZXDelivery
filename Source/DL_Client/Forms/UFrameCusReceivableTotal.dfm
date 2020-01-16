inherited fFrameCusReceivableTotal: TfFrameCusReceivableTotal
  Width = 886
  Height = 396
  inherited ToolBar1: TToolBar
    Width = 886
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
    Width = 886
    Height = 229
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 886
    object EditCustomer: TcxButtonEdit [0]
      Left = 636
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
      TabOrder = 3
      Width = 177
    end
    object EditEnd: TcxDateEdit [1]
      Left = 280
      Top = 36
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 130
    end
    object cxButtonEdit1: TcxButtonEdit [2]
      Left = 479
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
      TabOrder = 2
      Width = 88
    end
    object EditStart: TcxDateEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 130
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxlytmLayout1Item4: TdxLayoutItem
          Caption = #24320#22987#26102#38388':'
          Control = EditStart
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #25130#27490#26102#38388#65306
          Control = EditEnd
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #23458#25143#32534#21495#65306
          Control = cxButtonEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #23458#25143#21517#31216#65306
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Width = 886
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 886
    inherited TitleBar: TcxLabel
      Caption = #38144#21806#23458#25143#24212#25910#36134#27454
      Style.IsFontAssigned = True
      Width = 886
      AnchorX = 443
      AnchorY = 11
    end
  end
end
