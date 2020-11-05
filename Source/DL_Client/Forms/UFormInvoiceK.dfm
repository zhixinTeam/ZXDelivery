object fFormInvoiceK: TfFormInvoiceK
  Left = 914
  Top = 262
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 447
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 448
    Height = 447
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 291
      Top = 413
      Width = 70
      Height = 22
      Caption = #20445#23384
      TabOrder = 11
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 366
      Top = 413
      Width = 70
      Height = 22
      Caption = #21462#28040
      TabOrder = 12
      OnClick = BtnExitClick
    end
    object EditMemo: TcxMemo
      Left = 83
      Top = 114
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Height = 45
      Width = 240
    end
    object EditInvoice: TcxComboBox
      Left = 83
      Top = 39
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 125
    end
    object EditMoney: TcxTextEdit
      Left = 271
      Top = 39
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Text = '0'
      Width = 152
    end
    object EditZheKou: TcxTextEdit
      Left = 271
      Top = 64
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Text = '0'
      Width = 152
    end
    object EditStock: TcxTextEdit
      Left = 83
      Top = 199
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 6
      Width = 125
    end
    object EditPrice: TcxTextEdit
      Left = 271
      Top = 199
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 7
      Width = 152
    end
    object EditValue: TcxTextEdit
      Left = 271
      Top = 224
      OnFocusChanged = EditValueFocusChanged
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 9
      Width = 152
    end
    object ListDetail: TcxMCListBox
      Left = 25
      Top = 249
      Width = 374
      Height = 100
      HeaderSections = <
        item
          Text = #27700#27877#21697#31181
          Width = 75
        end
        item
          Alignment = taCenter
          Text = #25552#36135#21333#20215
          Width = 75
        end
        item
          Alignment = taCenter
          Text = #24320#31080#21333#20215
          Width = 75
        end
        item
          Alignment = taCenter
          Text = #24453#24320#21544#25968
          Width = 75
        end
        item
          Alignment = taCenter
          Text = #24050#24320#21544#25968
          Width = 75
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 10
      OnClick = ListDetailClick
    end
    object EditZK: TcxTextEdit
      Left = 83
      Top = 224
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 8
      Width = 125
    end
    object EditCus: TcxTextEdit
      Left = 83
      Top = 89
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      Width = 340
    end
    object EditSale: TcxTextEdit
      Left = 83
      Top = 64
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 2
      Width = 125
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        CaptionOptions.Text = #21457#31080#20449#24687
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Group9: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item3: TdxLayoutItem
            CaptionOptions.Text = #21457#31080#32534#21495':'
            Control = EditInvoice
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item2: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #21457#31080#24635#39069':'
            Control = EditMoney
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item13: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #19994' '#21153' '#21592':'
            Control = EditSale
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item4: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #25240#25187#24635#39069':'
            Control = EditZheKou
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item12: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item8: TdxLayoutItem
          CaptionOptions.Text = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AlignVert = avClient
        CaptionOptions.Text = #21457#31080#26126#32454
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Group7: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item1: TdxLayoutItem
              CaptionOptions.Text = #27700#27877#21697#31181':'
              Control = EditStock
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item5: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #24320#31080#21333#20215':'
              Control = EditPrice
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group6: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item9: TdxLayoutItem
              AlignHorz = ahLeft
              CaptionOptions.Text = #25240#25187#37329#39069':'
              Control = EditZK
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item6: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #24320#31080#21544#25968':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Item7: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = 'cxMCListBox1'
          CaptionOptions.Visible = False
          Control = ListDetail
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item10: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button3'
          CaptionOptions.Visible = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item11: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button4'
          CaptionOptions.Visible = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
