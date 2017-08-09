object Form1: TForm1
  Left = 861
  Top = 498
  Width = 770
  Height = 418
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 762
    Height = 350
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
    Height = 41
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 6
      Top = 8
      Width = 75
      Height = 25
      Caption = 'start'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 90
      Top = 8
      Width = 75
      Height = 25
      Caption = 'stop'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Edit1: TEdit
      Left = 268
      Top = 10
      Width = 101
      Height = 21
      TabOrder = 2
      Text = '01001'
    end
    object Button3: TButton
      Left = 374
      Top = 8
      Width = 75
      Height = 25
      Caption = 'open'
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 372
    Top = 196
  end
end
