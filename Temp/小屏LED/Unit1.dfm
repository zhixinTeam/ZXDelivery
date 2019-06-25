object Form1: TForm1
  Left = 441
  Top = 309
  Width = 391
  Height = 482
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Button2: TButton
    Left = 288
    Top = 16
    Width = 75
    Height = 25
    Caption = 'send'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 265
    Height = 20
    TabOrder = 1
    Text = 'title'
  end
  object Memo1: TMemo
    Left = 0
    Top = 66
    Width = 375
    Height = 377
    Align = alBottom
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 8
    Top = 32
    Width = 265
    Height = 20
    TabOrder = 3
    Text = 'text'
  end
end
