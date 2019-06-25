object Form1: TForm1
  Left = 553
  Top = 376
  Width = 682
  Height = 398
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 666
    Height = 318
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 666
    Height = 41
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'busy'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = 'start'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 176
      Top = 8
      Width = 75
      Height = 25
      Caption = 'stop'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 352
      Top = 8
      Width = 75
      Height = 25
      Caption = 'addparam'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Timer1: TTimer
    Left = 288
    Top = 8
  end
end
