object Form1: TForm1
  Left = 610
  Top = 319
  Width = 702
  Height = 476
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 694
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 12
      Top = 8
      Width = 75
      Height = 25
      Caption = #23458#25143#20837#37329
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = #20986#20837#37329#26126#32454
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 182
      Top = 8
      Width = 75
      Height = 25
      Caption = #21697#31181
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 268
      Top = 8
      Width = 75
      Height = 25
      Caption = #30913#21345#23548#20837
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 694
    Height = 216
    Align = alTop
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 0
    Top = 257
    Width = 694
    Height = 192
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 2
  end
end
