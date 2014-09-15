inherited fFormShouJu: TfFormShouJu
  Left = 684
  Top = 370
  ClientHeight = 315
  ClientWidth = 610
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  inherited dxLayout1: TdxLayoutControl
    Width = 610
    Height = 315
    inherited BtnOK: TButton
      Left = 428
      Top = 273
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 515
      Top = 273
      TabOrder = 12
    end
    object EditDate: TcxDateEdit [2]
      Left = 87
      Top = 45
      Hint = 'T.S_Date'
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 0
      Width = 207
    end
    object EditMan: TcxTextEdit [3]
      Left = 357
      Top = 45
      Hint = 'T.S_Man'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 218
    end
    object cxLabel2: TcxLabel [4]
      Left = 29
      Top = 70
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Vert = taBottomJustify
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 19
      Width = 576
      AnchorY = 89
    end
    object EditID: TcxButtonEdit [5]
      Left = 87
      Top = 94
      Hint = 'T.S_Code'
      HelpType = htKeyword
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 3
      Width = 207
    end
    object EditName: TcxTextEdit [6]
      Left = 87
      Top = 119
      Hint = 'T.S_Sender'
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 5
      Width = 504
    end
    object EditReason: TcxTextEdit [7]
      Left = 87
      Top = 144
      Hint = 'T.S_Reason'
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 6
      Width = 504
    end
    object EditMoney: TcxTextEdit [8]
      Left = 87
      Top = 169
      Hint = 'T.S_Money'
      ParentFont = False
      TabOrder = 7
      OnExit = EditMoneyExit
      Width = 125
    end
    object cxLabel1: TcxLabel [9]
      Left = 217
      Top = 169
      AutoSize = False
      Caption = #20803
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 25
      Width = 32
      AnchorY = 182
    end
    object EditBig: TcxTextEdit [10]
      Left = 312
      Top = 169
      Hint = 'T.S_BigMoney'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 9
      Width = 261
    end
    object EditMemo: TcxMemo [11]
      Left = 87
      Top = 199
      Hint = 'T.S_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 10
      Height = 57
      Width = 504
    end
    object EditBank: TcxComboBox [12]
      Left = 357
      Top = 94
      Hint = 'T.S_Bank'
      ParentFont = False
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 35
      TabOrder = 4
      Width = 152
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #24320#25454#26102#38388':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20986#32435#21592':'
            Control = EditMan
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            Caption = #20973#21333#21495#30721':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item13: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #36716#36134#38134#34892':'
            Control = EditBank
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20857'    '#30001':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = #20132'    '#26469':'
            Control = EditReason
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Group5: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item9: TdxLayoutItem
                Caption = #20154' '#27665' '#24065':'
                Control = EditMoney
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item10: TdxLayoutItem
                ShowCaption = False
                Control = cxLabel1
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item11: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #22823#20889#37329#39069':'
                Control = EditBig
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item12: TdxLayoutItem
              Caption = #22791#27880#20449#24687':'
              Control = EditMemo
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
end