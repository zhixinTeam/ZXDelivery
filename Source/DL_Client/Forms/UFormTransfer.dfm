inherited fFormTransfer: TfFormTransfer
  Left = 438
  Top = 340
  Caption = #20498#26009#31649#29702
  ClientHeight = 285
  ClientWidth = 368
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 368
    Height = 285
    inherited BtnOK: TButton
      Left = 222
      Top = 252
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 292
      Top = 252
      TabOrder = 12
    end
    object EditMate: TcxTextEdit [2]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 32
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 96
    end
    object EditSrcAddr: TcxTextEdit [3]
      Left = 81
      Top = 136
      ParentFont = False
      Properties.MaxLength = 32
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 96
    end
    object EditDstAddr: TcxTextEdit [4]
      Left = 81
      Top = 186
      ParentFont = False
      Properties.MaxLength = 32
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 96
    end
    object EditMID: TcxComboBox [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.OnChange = EditMIDPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 1
      Width = 121
    end
    object EditDC: TcxComboBox [6]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.OnChange = EditDCPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 3
      Width = 121
    end
    object EditDR: TcxComboBox [7]
      Left = 81
      Top = 161
      ParentFont = False
      Properties.OnChange = EditDCPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 5
      Width = 121
    end
    object EditTruck: TcxButtonEdit [8]
      Left = 81
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
      TabOrder = 0
      OnKeyPress = EditTruckKeyPress
      Width = 121
    end
    object chkNeiDao: TcxCheckBox [9]
      Left = 113
      Top = 252
      Caption = #22330#20869#20498#36816
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 10
      Width = 88
    end
    object CheckBox1: TcxCheckBox [10]
      Left = 11
      Top = 252
      Caption = #27492#21345#20026#22266#23450#21345
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 9
      Width = 97
    end
    object editMValue: TcxTextEdit [11]
      Left = 226
      Top = 211
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 8
      Text = '0.00'
      Width = 114
    end
    object editPValue: TcxTextEdit [12]
      Left = 81
      Top = 211
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 7
      Text = '0.00'
      Width = 106
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.AlignHorz = taRightJustify
          CaptionOptions.Text = #21407#26009#32534#21495':'
          Control = EditMID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #21407#26009#21517#31216':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          CaptionOptions.Text = #20498#20986#32534#21495':'
          Visible = False
          Control = EditDC
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          CaptionOptions.Text = #20498#20986#22320#28857':'
          Control = EditSrcAddr
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          CaptionOptions.Text = #20498#20837#32534#21495':'
          Visible = False
          Control = EditDR
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = #20498#20837#22320#28857':'
          Control = EditDstAddr
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item13: TdxLayoutItem
            CaptionOptions.Text = #30382#37325':'
            Control = editPValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item12: TdxLayoutItem
            CaptionOptions.Text = #27611#37325':'
            Control = editMValue
            ControlOptions.ShowBorder = False
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item10: TdxLayoutItem [0]
          Control = CheckBox1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem [1]
          Control = chkNeiDao
          ControlOptions.ShowBorder = False
        end
      end
    end
    object TdxLayoutGroup
      ButtonOptions.Buttons = <>
    end
  end
end
