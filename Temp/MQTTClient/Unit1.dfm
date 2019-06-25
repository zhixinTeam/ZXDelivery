object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 495
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 24
    Top = 32
    Width = 225
    Height = 21
    TabOrder = 0
    Text = 'topic'
  end
  object Button1: TButton
    Left = 257
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 24
    Top = 72
    Width = 227
    Height = 21
    TabOrder = 2
    Text = 'pub'
  end
  object Button2: TButton
    Left = 338
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 112
    Width = 852
    Height = 383
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 464
    Top = 74
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 5
    OnClick = CheckBox1Click
  end
  object TMSMQTTClient1: TTMSMQTTClient
    Version = '1.0.9.0'
    Left = 280
    Top = 24
  end
end
