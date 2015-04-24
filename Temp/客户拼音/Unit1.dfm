object Form1: TForm1
  Left = 323
  Top = 142
  Width = 841
  Height = 548
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 833
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 14
      Top = 10
      Width = 75
      Height = 25
      Caption = 'do'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 833
    Height = 475
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=P@ssw0rd;Persist Security Info=True' +
      ';User ID=sa;Initial Catalog=ZXDelivery;Data Source=192.168.0.200'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 6
    Top = 78
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 34
    Top = 78
  end
  object ADOQuery2: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 62
    Top = 78
  end
end
