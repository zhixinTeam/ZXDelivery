object TfFormBillSalePlan: TTfFormBillSalePlan
  Left = 1012
  Top = 275
  BorderStyle = bsDialog
  Caption = #38144#21806#20379#24212#35745#21010#35774#32622
  ClientHeight = 253
  ClientWidth = 381
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    381
    253)
  PixelsPerInch = 96
  TextHeight = 12
  object lbl2: TLabel
    Left = 33
    Top = 49
    Width = 60
    Height = 12
    Caption = #20379#24212#21544#25968#65306
  end
  object lbl3: TLabel
    Left = 11
    Top = 178
    Width = 84
    Height = 12
    Caption = #20379#24212#19978#38480#21544#25968#65306
    Visible = False
  end
  object lbl1: TLabel
    Left = 43
    Top = 117
    Width = 48
    Height = 12
    Caption = #19994#21153#21592#65306
    Visible = False
  end
  object lbl4: TLabel
    Left = 43
    Top = 148
    Width = 48
    Height = 12
    Caption = #23458'  '#25143#65306
    Visible = False
  end
  object lbl5: TLabel
    Left = 43
    Top = 16
    Width = 48
    Height = 12
    Caption = #21697'  '#31181#65306
  end
  object Edt_StockNum: TcxTextEdit
    Left = 101
    Top = 46
    Hint = 'T.L_CusName'
    Enabled = False
    ParentFont = False
    TabOrder = 0
    Width = 256
  end
  object Edt_CusNum: TcxTextEdit
    Left = 102
    Top = 173
    Hint = 'T.L_CusName'
    ParentFont = False
    TabOrder = 2
    Visible = False
    Width = 113
  end
  object cbbEditSalesMan: TcxComboBox
    Left = 99
    Top = 111
    ParentFont = False
    Properties.DropDownListStyle = lsEditFixedList
    Properties.DropDownRows = 20
    Properties.ImmediateDropDown = False
    Properties.ItemHeight = 18
    Properties.OnChange = cbbEditSalesManPropertiesChange
    TabOrder = 3
    Visible = False
    Width = 260
  end
  object cbbEditName: TcxComboBox
    Left = 99
    Top = 141
    ParentFont = False
    Properties.DropDownRows = 20
    Properties.ImmediateDropDown = False
    Properties.IncrementalSearch = False
    Properties.ItemHeight = 18
    TabOrder = 4
    Visible = False
    Width = 260
  end
  object EditStock: TcxComboBox
    Left = 99
    Top = 10
    Enabled = False
    ParentFont = False
    Properties.DropDownListStyle = lsEditFixedList
    Properties.DropDownRows = 15
    Properties.ItemHeight = 18
    Properties.OnChange = EditStockPropertiesChange
    TabOrder = 5
    Width = 260
  end
  object chk1: TCheckBox
    Left = 104
    Top = 77
    Width = 241
    Height = 17
    Caption = #35813#21697#31181#26410#35774#32622#20379#24212#35745#21010#23458#25143#31105#27490#24320#21333
    TabOrder = 7
    Visible = False
  end
  object btn_Save: TButton
    Left = 80
    Top = 213
    Width = 89
    Height = 27
    Anchors = [akLeft, akBottom]
    Caption = #20445#23384
    TabOrder = 1
    OnClick = btn_SaveClick
  end
  object btn1: TButton
    Left = 232
    Top = 213
    Width = 89
    Height = 27
    Anchors = [akLeft, akBottom]
    Caption = #21462#28040
    TabOrder = 6
    OnClick = btn1Click
  end
end
