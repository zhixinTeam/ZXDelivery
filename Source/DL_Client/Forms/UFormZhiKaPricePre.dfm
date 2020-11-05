inherited fFormZKPricePre: TfFormZKPricePre
  Left = 799
  Top = 328
  ClientHeight = 216
  ClientWidth = 379
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 379
    Height = 216
    inherited BtnOK: TButton
      Left = 233
      Top = 183
      Caption = #30830#23450
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 303
      Top = 183
      TabOrder = 8
    end
    object EditStock: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      Width = 200
    end
    object EditPrice: TcxTextEdit [3]
      Left = 81
      Top = 78
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 121
    end
    object EditNew: TcxTextEdit [4]
      Left = 265
      Top = 78
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 90
    end
    object cxLabel1: TcxLabel [5]
      Left = 23
      Top = 128
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Transparent = True
    end
    object EditStart: TcxDateEdit [6]
      Left = 81
      Top = 103
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 4
      Width = 166
    end
    object pnl1: TPanel [7]
      Left = 23
      Top = 61
      Width = 300
      Height = 12
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = '---------------------------------------------------'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clScrollBar
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object Chk_1: TcxCheckBox [8]
      Left = 23
      Top = 149
      Caption = #22312#21407#21333#20215#22522#30784#19978#24212#29992#26032#21333#20215'.'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Transparent = True
      Width = 203
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        AlignHorz = ahLeft
        CaptionOptions.Text = #36873#39033
        object dxLayout1Item3: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #27700#27877#21697#31181':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item82: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = 'Panel1'
          CaptionOptions.Visible = False
          Control = pnl1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            CaptionOptions.Text = #38144#21806#20215#26684':'
            Control = EditPrice
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            CaptionOptions.Text = #26032' '#21333' '#20215':'
            Control = EditNew
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item10: TdxLayoutItem
          AlignHorz = ahLeft
          AlignVert = avTop
          CaptionOptions.Text = #29983#25928#26102#38388':'
          Control = EditStart
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel1'
          CaptionOptions.Visible = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AlignHorz = ahLeft
          CaptionOptions.Visible = False
          Control = Chk_1
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        AlignHorz = ahRight
      end
    end
  end
end
