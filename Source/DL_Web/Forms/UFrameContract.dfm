inherited fFrameContract: TfFrameContract
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
      inherited BtnRefresh: TUniToolButton
        ExplicitLeft = 269
        ExplicitTop = 0
      end
    end
    inherited DBGridMain: TUniDBGrid
      Columns = <
        item
          Width = 64
          Font.Charset = GB2312_CHARSET
          Font.Height = -12
          Font.Name = #23435#20307
        end>
    end
  end
end
