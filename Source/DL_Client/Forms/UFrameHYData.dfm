inherited fFrameHYData: TfFrameHYData
  Width = 964
  Height = 436
  inherited ToolBar1: TToolBar
    Width = 964
    inherited BtnAdd: TToolButton
      Caption = #24320#21333
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 964
    Height = 234
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 964
    Height = 135
    object EditNO: TcxButtonEdit [0]
      Left = 289
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
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object EditName: TcxButtonEdit [1]
      Left = 467
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
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object cxTextEdit1: TcxTextEdit [2]
      Left = 81
      Top = 93
      Hint = 'T.H_SerialNo'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 115
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 259
      Top = 93
      Hint = 'T.P_Stock'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 115
    end
    object cxTextEdit4: TcxTextEdit [4]
      Left = 449
      Top = 93
      Hint = 'T.H_Value'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 115
    end
    object cxTextEdit3: TcxTextEdit [5]
      Left = 627
      Top = 93
      Hint = 'T.C_Name'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Width = 121
    end
    object EditDate: TcxButtonEdit [6]
      Left = 645
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
      TabOrder = 3
      Width = 182
    end
    object EditID: TcxButtonEdit [7]
      Left = 111
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
      Width = 115
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem
          CaptionOptions.Text = #35760#24405#21495'/'#36710#29260#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #27700#27877#32534#21495':'
          Control = EditNO
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #27700#27877#32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = #27700#27877#21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          CaptionOptions.Text = #25552#36135#37327'('#21544'):'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 964
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 964
    inherited TitleBar: TcxLabel
      Caption = #21270#39564#21333#35760#24405
      Style.IsFontAssigned = True
      Width = 964
      AnchorX = 482
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 236
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 236
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 264
    object X1: TMenuItem
      Caption = #20462#25913#24320#21333#23458#25143
      OnClick = X1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Tag = 10
      Caption = #25171#21360#21270#39564#21333
      OnClick = N1Click
    end
    object N281: TMenuItem
      Caption = #25171#21360#21270#39564#21333' 28'#22825
      OnClick = N281Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #25171#21360#21512#26684#35777
      OnClick = N2Click
    end
  end
end
