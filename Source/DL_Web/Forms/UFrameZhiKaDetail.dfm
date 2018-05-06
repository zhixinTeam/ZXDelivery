inherited fFrameZhiKaDetail: TfFrameZhiKaDetail
  Font.Charset = GB2312_CHARSET
  Font.Height = -12
  Font.Name = #23435#20307
  ParentFont = False
  inherited PanelWork: TUniContainerPanel
    inherited UniToolBar1: TUniToolBar
      ParentFont = False
      Font.Charset = GB2312_CHARSET
      Font.Height = -12
      Font.Name = #23435#20307
      inherited BtnAdd: TUniToolButton
        Visible = False
      end
      inherited BtnEdit: TUniToolButton
        Visible = False
      end
      inherited BtnDel: TUniToolButton
        Visible = False
      end
      inherited UniToolButton4: TUniToolButton
        Visible = False
      end
    end
    inherited PanelQuick: TUniSimplePanel
      object Label1: TUniLabel
        Left = 12
        Top = 16
        Width = 54
        Height = 12
        Hint = ''
        Caption = #32440#21345#32534#21495':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 1
      end
      object EditID: TUniEdit
        Left = 72
        Top = 12
        Width = 125
        Hint = ''
        Text = ''
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 2
        EmptyText = #26597#25214
        OnKeyPress = EditIDKeyPress
      end
      object Label2: TUniLabel
        Left = 224
        Top = 16
        Width = 54
        Height = 12
        Hint = ''
        Caption = #23458#25143#21517#31216':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 3
      end
      object EditCus: TUniEdit
        Left = 284
        Top = 12
        Width = 125
        Hint = ''
        Text = ''
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 4
        EmptyText = #26597#25214
        OnKeyPress = EditIDKeyPress
      end
      object Label3: TUniLabel
        Left = 435
        Top = 16
        Width = 54
        Height = 12
        Hint = ''
        Caption = #26085#26399#31579#36873':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 5
      end
      object EditDate: TUniEdit
        Left = 495
        Top = 12
        Width = 185
        Hint = ''
        Text = ''
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 6
        EmptyText = #26597#25214
        ReadOnly = True
        OnKeyPress = EditIDKeyPress
      end
      object BtnDateFilter: TUniBitBtn
        Left = 682
        Top = 12
        Width = 25
        Height = 22
        Hint = ''
        Caption = '...'
        TabOrder = 7
        OnClick = BtnDateFilterClick
      end
    end
    inherited DBGridMain: TUniDBGrid
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgRowSelect, dgCheckSelect, dgConfirmDelete, dgMultiSelect, dgAutoRefreshRow]
      OnMouseDown = DBGridMainMouseDown
      Columns = <
        item
          Width = 64
          Font.Charset = GB2312_CHARSET
          Font.Height = -12
          Font.Name = #23435#20307
        end>
    end
  end
  object PMenu1: TUniPopupMenu
    Left = 42
    Top = 182
    object MenuItem1: TUniMenuItem
      Caption = #8251#32440#21345#20923#32467#8251
      Enabled = False
    end
    object MenuItem2: TUniMenuItem
      Tag = 10
      Caption = #20923#32467#32440#21345
      OnClick = MenuItem2Click
    end
    object MenuItem3: TUniMenuItem
      Tag = 20
      Caption = #35299#38500#20923#32467
      OnClick = MenuItem2Click
    end
    object MenuItem4: TUniMenuItem
      Tag = 10
      Caption = #25353#21697#31181#20923#32467
      OnClick = MenuItem4Click
    end
    object MenuItemN2: TUniMenuItem
      Caption = '-'
    end
    object MenuItem5: TUniMenuItem
      Tag = 20
      Caption = #8251#32440#21345#35843#20215#8251
      Enabled = False
    end
    object MenuItem6: TUniMenuItem
      Caption = #20215#26684#35843#25972
      OnClick = MenuItem6Click
    end
    object MenuItem7: TUniMenuItem
      Caption = #35843#20215#35760#24405
    end
    object MenuItem8: TUniMenuItem
      Tag = 10
      Caption = #35843#20215#35774#32622
      object MenuItem9: TUniMenuItem
        Tag = 10
        Caption = #21442#19982#35843#20215
        OnClick = MenuItem9Click
      end
      object MenuItem10: TUniMenuItem
        Tag = 20
        Caption = #19981#21442#19982#35843#20215
        OnClick = MenuItem9Click
      end
    end
    object MenuItemN3: TUniMenuItem
      Tag = 10
      Caption = '-'
    end
    object MenuItem11: TUniMenuItem
      Tag = 20
      Caption = #8251#20449#24687#26597#35810#8251
      Enabled = False
    end
    object MenuItem12: TUniMenuItem
      Tag = 30
      Caption = #26080#25928#32440#21345
      OnClick = MenuItem2Click
    end
    object MenuItem13: TUniMenuItem
      Tag = 40
      Caption = #26597#35810#20840#37096
      OnClick = MenuItem2Click
    end
    object MenuItem14: TUniMenuItem
      Tag = 50
      Caption = #24050#20923#32467#32440#21345
      OnClick = MenuItem2Click
    end
  end
end
