inherited fFrameAccReport: TfFrameAccReport
  inherited PanelWork: TUniContainerPanel
    inherited PanelQuick: TUniSimplePanel
      object BtnDateFilter: TUniBitBtn
        Left = 512
        Top = 12
        Width = 25
        Height = 22
        Hint = ''
        Caption = '...'
        TabOrder = 1
        OnClick = BtnDateFilterClick
      end
      object EditDate: TUniEdit
        Left = 325
        Top = 12
        Width = 185
        Hint = ''
        Text = ''
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 2
        EmptyText = #26597#25214
        ReadOnly = True
      end
      object Label3: TUniLabel
        Left = 264
        Top = 17
        Width = 54
        Height = 12
        Hint = ''
        Caption = #26085#26399#31579#36873':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 3
      end
      object editType: TUniComboBox
        Left = 101
        Top = 12
        Width = 145
        Hint = ''
        Style = csDropDownList
        Text = #20840#37096#23458#25143
        Items.Strings = (
          #20840#37096#23458#25143
          'A'#31867#23458#25143
          'b'#31867#23458#25143)
        ItemIndex = 0
        TabOrder = 4
      end
      object UniLabel1: TUniLabel
        Left = 40
        Top = 17
        Width = 54
        Height = 12
        Hint = ''
        Caption = #23458#25143#31867#22411':'
        ParentFont = False
        Font.Charset = GB2312_CHARSET
        Font.Height = -12
        Font.Name = #23435#20307
        TabOrder = 5
      end
      object UniButton1: TUniButton
        Left = 558
        Top = 9
        Width = 75
        Height = 25
        Hint = ''
        Caption = #32479#35745
        TabOrder = 6
        OnClick = UniButton1Click
      end
    end
  end
end
