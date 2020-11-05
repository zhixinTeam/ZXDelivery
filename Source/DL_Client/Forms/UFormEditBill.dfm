inherited fFormEditBill: TfFormEditBill
  Left = 1035
  Top = 261
  Caption = #38144#21806#21333#35843#25320'/'#20462#25913
  ClientHeight = 306
  ClientWidth = 490
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 490
    Height = 306
    inherited BtnOK: TButton
      Left = 344
      Top = 273
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 414
      Top = 273
      TabOrder = 13
    end
    object Edt_NCOrder: TcxButtonEdit [2]
      Left = 87
      Top = 36
      Hint = 'D.L_ZhiKa'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditCustomerPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      Width = 165
    end
    object edt_PValue: TcxTextEdit [3]
      Left = 87
      Top = 187
      Hint = 'D.L_PValue'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 9
      Width = 128
    end
    object edt_MValue: TcxTextEdit [4]
      Left = 284
      Top = 187
      Hint = 'D.L_MValue'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 10
      Width = 128
    end
    object EditMemo: TcxMemo [5]
      Left = 87
      Top = 213
      Hint = 'D.L_DelReson'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Edges = [bBottom]
      TabOrder = 11
      Height = 45
      Width = 394
    end
    object edt_StockName: TcxTextEdit [6]
      Left = 284
      Top = 111
      Hint = 'D.L_StockName'
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 180
    end
    object edt_StockNo: TcxTextEdit [7]
      Left = 87
      Top = 111
      Hint = 'D.L_StockNo'
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 128
    end
    object edt_CusName: TcxTextEdit [8]
      Left = 87
      Top = 86
      Hint = 'D.L_CusName'
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 280
    end
    object edt_CusId: TcxTextEdit [9]
      Left = 87
      Top = 61
      Hint = 'D.L_CusId'
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 128
    end
    object edt_Truck: TcxTextEdit [10]
      Left = 87
      Top = 162
      Hint = 'D.L_Truck'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 8
      Width = 128
    end
    object edt_YunFei: TcxTextEdit [11]
      Left = 284
      Top = 136
      Hint = 'D.L_YunFei'
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 7
      Text = '0'
      OnEditing = edt_YunFeiEditing
      Width = 100
    end
    object edt_Price: TcxTextEdit [12]
      Left = 87
      Top = 136
      Hint = 'D.L_Price'
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 6
      Width = 128
    end
    object edt_Bill: TcxTextEdit [13]
      Left = 284
      Top = 61
      Hint = 'D.L_ID'
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 180
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #32440#21345#32534#21495':'
          Control = Edt_NCOrder
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group2: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            ShowBorder = False
            object dxLayout1Group6: TdxLayoutGroup
              CaptionOptions.Visible = False
              ButtonOptions.Buttons = <>
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item10: TdxLayoutItem
                AlignHorz = ahLeft
                CaptionOptions.Text = #23458#25143#32534#21495#65306
                Control = edt_CusId
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item14: TdxLayoutItem
                CaptionOptions.Text = #25552#36135#21333#21495#65306
                Control = edt_Bill
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item8: TdxLayoutItem
              CaptionOptions.Text = #23458#25143#21517#31216#65306
              Control = edt_CusName
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
              CaptionOptions.Text = #21697#31181#32534#21495#65306
              Control = edt_StockNo
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              CaptionOptions.Text = #21697#31181#21517#31216#65306
              Control = edt_StockName
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group5: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            ShowBorder = False
            object dxLayout1Group8: TdxLayoutGroup
              CaptionOptions.Visible = False
              ButtonOptions.Buttons = <>
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item12: TdxLayoutItem
                CaptionOptions.Text = #27700#27877#21333#20215#65306
                Control = edt_Price
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item11: TdxLayoutItem
                CaptionOptions.Text = #36816#36153#21333#20215#65306
                Visible = False
                Control = edt_YunFei
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item4: TdxLayoutItem
              AlignHorz = ahLeft
              CaptionOptions.Text = #36710#29260#21495#30721#65306
              Control = edt_Truck
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Group7: TdxLayoutGroup
              CaptionOptions.Visible = False
              ButtonOptions.Buttons = <>
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item6: TdxLayoutItem
                CaptionOptions.Text = #36710#36742#30382#37325#65306
                Control = edt_PValue
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item9: TdxLayoutItem
                CaptionOptions.Text = #36710#36742#27611#37325#65306
                Control = edt_MValue
                ControlOptions.ShowBorder = False
              end
            end
          end
        end
        object dxLayout1Item13: TdxLayoutItem
          CaptionOptions.Text = #22791#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
