inherited fFormSaleContract: TfFormSaleContract
  ClientHeight = 601
  ClientWidth = 544
  Caption = #21512#21516
  ExplicitWidth = 550
  ExplicitHeight = 630
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnOK: TUniButton
    Left = 380
    Top = 565
    TabOrder = 1
    OnClick = BtnOKClick
    ExplicitLeft = 380
    ExplicitTop = 565
  end
  inherited BtnExit: TUniButton
    Left = 461
    Top = 567
    TabOrder = 2
    ExplicitLeft = 461
    ExplicitTop = 567
  end
  inherited PanelWork: TUniSimplePanel
    Width = 528
    Height = 551
    TabOrder = 0
    ExplicitWidth = 528
    ExplicitHeight = 551
    object EditID: TUniEdit
      Left = 68
      Top = 15
      Width = 150
      Hint = ''
      MaxLength = 15
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 1
    end
    object UniLabel1: TUniLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Hint = ''
      Caption = #21512#21516#32534#21495':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 3
    end
    object UniLabel2: TUniLabel
      Left = 235
      Top = 20
      Width = 54
      Height = 12
      Hint = ''
      Caption = #39033#30446#21517#31216':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 4
    end
    object EditName: TUniEdit
      Left = 296
      Top = 15
      Width = 220
      Hint = ''
      MaxLength = 100
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 2
    end
    object UniLabel3: TUniLabel
      Left = 8
      Top = 125
      Width = 54
      Height = 12
      Hint = ''
      Caption = #25152#23646#21306#22495':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 15
    end
    object EditArea: TUniEdit
      Left = 68
      Top = 120
      Width = 150
      Hint = ''
      MaxLength = 50
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 13
    end
    object UniLabel4: TUniLabel
      Left = 235
      Top = 160
      Width = 54
      Height = 12
      Hint = ''
      Caption = #25209' '#20934' '#20154':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 20
    end
    object EditApproval: TUniEdit
      Left = 296
      Top = 155
      Width = 220
      Hint = ''
      MaxLength = 30
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 18
    end
    object EditSaleMan: TUniComboBox
      Left = 68
      Top = 50
      Width = 150
      Hint = ''
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 5
      OnChange = EditSaleManChange
    end
    object UniLabel8: TUniLabel
      Left = 8
      Top = 55
      Width = 54
      Height = 12
      Hint = ''
      Caption = #19994#21153#20154#21592':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 7
    end
    object UniLabel9: TUniLabel
      Left = 235
      Top = 55
      Width = 54
      Height = 12
      Hint = ''
      Caption = #23458#25143#21517#31216':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 8
    end
    object EditCus: TUniComboBox
      Left = 296
      Top = 50
      Width = 220
      Hint = ''
      Style = csDropDownList
      MaxLength = 35
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 6
    end
    object UniLabel10: TUniLabel
      Left = 235
      Top = 90
      Width = 54
      Height = 12
      Hint = ''
      Caption = #31614#35746#22320#28857':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 12
    end
    object EditQAddr: TUniEdit
      Left = 296
      Top = 85
      Width = 220
      Hint = ''
      MaxLength = 50
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 10
    end
    object UniLabel13: TUniLabel
      Left = 8
      Top = 90
      Width = 54
      Height = 12
      Hint = ''
      Caption = #31614#35746#26102#38388':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 11
    end
    object UniLabel14: TUniLabel
      Left = 8
      Top = 160
      Width = 54
      Height = 12
      Hint = ''
      Caption = #20184#27454#26041#24335':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 19
    end
    object UniLabel6: TUniLabel
      Left = 8
      Top = 195
      Width = 54
      Height = 12
      Hint = ''
      Caption = #25552#36135#26102#38271':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 22
    end
    object UniLabel5: TUniLabel
      Left = 235
      Top = 125
      Width = 54
      Height = 12
      Hint = ''
      Caption = #20132#36135#22320#28857':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 16
    end
    object EditDays: TUniEdit
      Left = 68
      Top = 190
      Width = 150
      Hint = ''
      MaxLength = 6
      Text = '1'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 21
    end
    object EditJAddr: TUniEdit
      Left = 296
      Top = 120
      Width = 220
      Hint = ''
      MaxLength = 50
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 14
    end
    object EditQDate: TUniDateTimePicker
      Left = 68
      Top = 85
      Width = 150
      Hint = ''
      DateTime = 43224.000000000000000000
      DateFormat = 'yyyy-MM-dd'
      TimeFormat = 'HH:mm:ss'
      TabOrder = 9
    end
    object Label1: TUniLabel
      Left = 235
      Top = 195
      Width = 228
      Height = 12
      Hint = ''
      Caption = #22825'  '#27880':'#29992#25143#38656#35201#22312#25351#23450#26102#38271#20869#23558#27700#27877#25552#23436'.'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 23
    end
    object EditMemo: TUniMemo
      Left = 8
      Top = 247
      Width = 508
      Height = 65
      Hint = ''
      TabOrder = 25
    end
    object Label2: TUniLabel
      Left = 8
      Top = 230
      Width = 54
      Height = 12
      Hint = ''
      Caption = #22791#27880#20449#24687':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 24
    end
    object EditPayment: TUniComboBox
      Left = 68
      Top = 155
      Width = 150
      Hint = ''
      MaxLength = 20
      Text = ''
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 17
    end
    object Grid1: TUniStringGrid
      Left = 8
      Top = 350
      Width = 508
      Height = 190
      Hint = ''
      FixedCols = 0
      FixedRows = 0
      ColCount = 6
      Options = [goVertLine, goHorzLine, goEditing, goAlwaysShowEditor]
      ShowColumnTitles = True
      Columns = <
        item
          Title.Caption = #27700#27877#32534#21495
          Width = 100
        end
        item
          Title.Caption = #27700#27877#21517#31216
          Width = 145
        end
        item
          Title.Caption = #25968#37327'('#21544'))'
          Width = 80
        end
        item
          Title.Caption = #21333#20215'('#20803'/'#21544')'
          Width = 80
        end
        item
          Title.Caption = #37329#39069'('#20803')'
          Width = 80
        end
        item
          Title.Caption = '111'
          Width = 1
        end>
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 29
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
    end
    object Label3: TUniLabel
      Left = 8
      Top = 330
      Width = 54
      Height = 12
      Hint = ''
      Caption = #21512#21516#26126#32454':'
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      TabOrder = 28
    end
    object BtnAdd: TUniBitBtn
      Left = 425
      Top = 328
      Width = 45
      Height = 20
      Hint = #28155#21152#21512#21516#26126#32454
      Visible = False
      ShowHint = True
      ParentShowHint = False
      Caption = '+'
      TabOrder = 26
    end
    object BtnDel: TUniBitBtn
      Left = 471
      Top = 328
      Width = 45
      Height = 20
      Hint = #21024#38500#36873#20013#30340#26126#32454
      Visible = False
      ShowHint = True
      ParentShowHint = False
      Caption = '-'
      TabOrder = 27
    end
  end
  object Check1: TUniCheckBox
    Left = 8
    Top = 569
    Width = 300
    Height = 17
    Hint = ''
    Caption = #34394#25311#21512#21516': '#21150#29702#32440#21345#26102#20801#35768#21464#26356#19994#21153#21592#21644#23458#25143#21517#31216'.'
    Anchors = [akLeft, akBottom]
    TabOrder = 3
  end
end
