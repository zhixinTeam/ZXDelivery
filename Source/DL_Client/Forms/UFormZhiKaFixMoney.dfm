inherited fFormZhiKaFixMoney: TfFormZhiKaFixMoney
  Left = 982
  Top = 233
  ClientHeight = 384
  ClientWidth = 380
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 380
    Height = 384
    OptionsItem.AutoControlAreaAlignment = False
    inherited BtnOK: TButton
      Left = 234
      Top = 351
      Caption = #30830#23450
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 304
      Top = 351
      TabOrder = 9
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 374
      Height = 110
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 296
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditZK: TcxTextEdit [3]
      Left = 81
      Top = 154
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 105
    end
    object EditOut: TcxTextEdit [4]
      Left = 249
      Top = 211
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Text = '0'
      Width = 121
    end
    object EditIn: TcxTextEdit [5]
      Left = 81
      Top = 211
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Text = '0'
      Width = 105
    end
    object EditFreeze: TcxTextEdit [6]
      Left = 81
      Top = 236
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Text = '0'
      Width = 105
    end
    object EditValid: TcxTextEdit [7]
      Left = 249
      Top = 236
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Text = '0'
      Width = 121
    end
    object EditMoney: TcxTextEdit [8]
      Left = 81
      Top = 293
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 121
    end
    object Check1: TcxCheckBox [9]
      Left = 23
      Top = 318
      Caption = #38480#21046#35813#32440#21345#30340#21487#25552#36135#37327'.'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Transparent = True
      OnClick = Check1Click
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        CaptionOptions.Text = #32440#21345#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          AlignVert = avClient
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #32440#21345#32534#21495':'
          Control = EditZK
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        CaptionOptions.Text = #36134#25143#20449#24687
        ButtonOptions.Buttons = <>
        object dxLayout1Group5: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            CaptionOptions.Text = #20837#37329#24635#39069':'
            Control = EditIn
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #20986#37329#24635#39069':'
            Control = EditOut
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            CaptionOptions.Text = #20923#32467#37329#39069':'
            Control = EditFreeze
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #21487#29992#37329#39069':'
            Control = EditValid
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup3: TdxLayoutGroup [2]
        CaptionOptions.Text = #21487#25552#36135#37329#39069
        ButtonOptions.Buttons = <>
        object dxLayout1Item4: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #37329#39069'('#20803'):'
          Control = EditMoney
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
