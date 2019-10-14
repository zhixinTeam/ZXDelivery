object fFormMain: TfFormMain
  Left = 705
  Top = 418
  Width = 742
  Height = 443
  Caption = #19975#38598#28608#20809
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 734
    Height = 199
    Align = alClient
    Lines.Strings = (
      
        'FF AA 00 1E 00 00 00 0A 34 06 01 01 00 04 00 00 00 00 00 00 00 0' +
        '0 02 01 00 00 00 00 00 00 00 21 EE EE')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 734
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Memo2: TMemo
    Left = 0
    Top = 240
    Width = 734
    Height = 176
    Align = alBottom
    Lines.Strings = (
      'Memo2')
    TabOrder = 2
  end
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 24
    Top = 56
  end
end
