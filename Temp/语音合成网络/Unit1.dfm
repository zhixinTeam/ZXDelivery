object Form1: TForm1
  Left = 539
  Top = 492
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 225
  ClientWidth = 487
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
    Left = 10
    Top = 10
    Width = 465
    Height = 171
    Lines.Strings = (
      #24744#28857#20987#20102#35821#38899#21512#25104#27979#35797#25353#38062'.')
    TabOrder = 0
  end
  object Btn1: TButton
    Left = 12
    Top = 190
    Width = 75
    Height = 25
    Caption = #27979#35797
    TabOrder = 1
    OnClick = Btn1Click
  end
  object CheckBox1: TCheckBox
    Left = 114
    Top = 194
    Width = 97
    Height = 17
    Caption = #21551#21160#26381#21153
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object Button1: TButton
    Left = 328
    Top = 196
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
end
