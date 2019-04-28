object Form1: TForm1
  Left = 359
  Top = 399
  Width = 713
  Height = 494
  Caption = 'PLC'#25511#21046#22120
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 697
    Height = 121
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 8
      Top = 12
      Width = 233
      Height = 105
      Caption = #26174#31034#20869#23481
      TabOrder = 0
      object EditTunnel: TLabeledEdit
        Left = 8
        Top = 35
        Width = 121
        Height = 20
        EditLabel.Width = 54
        EditLabel.Height = 12
        EditLabel.Caption = #36890#36947#26631#35782':'
        TabOrder = 0
        Text = 'T1'
      end
      object EditTxt: TLabeledEdit
        Left = 8
        Top = 77
        Width = 121
        Height = 20
        EditLabel.Width = 54
        EditLabel.Height = 12
        EditLabel.Caption = #26174#31034#20869#23481':'
        TabOrder = 1
        Text = #25105#26159'LED-123'
      end
      object BtnSend: TButton
        Left = 136
        Top = 72
        Width = 75
        Height = 25
        Caption = #21457#36865
        TabOrder = 2
        OnClick = BtnSendClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 248
      Top = 12
      Width = 313
      Height = 105
      Caption = #36890#36947#29366#24577
      TabOrder = 1
      object EditTunnel2: TLabeledEdit
        Left = 8
        Top = 35
        Width = 121
        Height = 20
        EditLabel.Width = 54
        EditLabel.Height = 12
        EditLabel.Caption = #36890#36947#26631#35782':'
        TabOrder = 0
        Text = 'T1'
      end
      object BtnDisplay: TButton
        Left = 8
        Top = 72
        Width = 75
        Height = 25
        Caption = #26174#31034
        TabOrder = 1
        OnClick = BtnDisplayClick
      end
      object BtnISOK: TButton
        Left = 96
        Top = 72
        Width = 75
        Height = 25
        Caption = #21028#23450
        TabOrder = 2
        OnClick = BtnISOKClick
      end
      object CheckBox1: TCheckBox
        Left = 184
        Top = 80
        Width = 97
        Height = 17
        Caption = #25171#24320'/'#20851#38381
        TabOrder = 3
        OnClick = CheckBox1Click
      end
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 121
    Width = 697
    Height = 334
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
end
