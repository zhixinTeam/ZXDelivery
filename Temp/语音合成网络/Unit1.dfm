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
      'Memo1')
    TabOrder = 0
  end
  object Btn1: TButton
    Left = 12
    Top = 190
    Width = 75
    Height = 25
    Caption = #21457#36865
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
end
