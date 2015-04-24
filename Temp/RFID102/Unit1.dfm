object Form1: TForm1
  Left = 861
  Top = 498
  Width = 770
  Height = 418
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Memo1: TMemo
    Left = 0
    Top = 50
    Width = 762
    Height = 336
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 762
    Height = 50
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 7
      Top = 10
      Width = 93
      Height = 31
      Caption = 'start'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 111
      Top = 10
      Width = 92
      Height = 31
      Caption = 'stop'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
