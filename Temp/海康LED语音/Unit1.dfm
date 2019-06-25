object Form1: TForm1
  Left = 840
  Top = 377
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 341
  ClientWidth = 652
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 652
    Height = 41
    Align = alTop
    TabOrder = 0
    object Edit1: TEdit
      Left = 8
      Top = 16
      Width = 121
      Height = 20
      TabOrder = 0
      Text = #20320#22909
    end
    object Button1: TButton
      Left = 136
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 652
    Height = 300
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
end
