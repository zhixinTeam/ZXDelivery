inherited fFormDateFilter: TfFormDateFilter
  ClientHeight = 150
  ClientWidth = 314
  Caption = #26085#26399#31579#36873
  ExplicitWidth = 320
  ExplicitHeight = 179
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnOK: TUniButton
    Left = 148
    Top = 116
    OnClick = BtnOKClick
    ExplicitLeft = 132
    ExplicitTop = 102
  end
  inherited BtnExit: TUniButton
    Left = 231
    Top = 116
    ExplicitLeft = 215
    ExplicitTop = 102
  end
  inherited PanelWork: TUniSimplePanel
    Width = 298
    Height = 100
    ExplicitWidth = 298
    ExplicitHeight = 112
    object EditStart: TUniDateTimePicker
      Left = 74
      Top = 20
      Width = 207
      Hint = ''
      DateTime = 43224.000000000000000000
      DateFormat = 'yyyy-MM-dd'
      TimeFormat = 'HH:mm:ss'
      TabOrder = 1
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
    end
    object Label1: TUniLabel
      Left = 7
      Top = 24
      Width = 52
      Height = 13
      Hint = ''
      Caption = #24320#22987#26085#26399':'
      TabOrder = 2
    end
    object Label2: TUniLabel
      Left = 7
      Top = 64
      Width = 52
      Height = 13
      Hint = ''
      Caption = #32467#26463#26085#26399':'
      TabOrder = 3
    end
    object EditEnd: TUniDateTimePicker
      Left = 74
      Top = 60
      Width = 207
      Hint = ''
      DateTime = 43224.000000000000000000
      DateFormat = 'yyyy-MM-dd'
      TimeFormat = 'HH:mm:ss'
      TabOrder = 4
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
    end
  end
end
