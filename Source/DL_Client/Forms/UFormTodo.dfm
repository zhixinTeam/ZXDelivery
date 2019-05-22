inherited fFormTodo: TfFormTodo
  Left = 704
  Top = 144
  Width = 453
  Height = 517
  BorderStyle = bsSizeable
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 445
    Height = 486
    inherited BtnOK: TButton
      Left = 299
      Top = 453
      Caption = #30830#23450
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 369
      Top = 453
      Caption = #20851#38381
      TabOrder = 8
    end
    object cxLabel1: TcxLabel [2]
      Left = 23
      Top = 36
      AutoSize = False
      ParentFont = False
      Transparent = True
      Height = 6
      Width = 10
    end
    object ListTodo: TcxListView [3]
      Left = 23
      Top = 47
      Width = 328
      Height = 152
      Columns = <
        item
          Caption = #26102#38388
        end
        item
          Caption = #26469#28304
        end
        item
          Caption = #20869#23481
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = ImageBar
      Style.Edges = []
      TabOrder = 1
      ViewStyle = vsReport
      OnSelectItem = ListTodoSelectItem
    end
    object EditDate: TcxTextEdit [4]
      Left = 57
      Top = 127
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditFrom: TcxTextEdit [5]
      Left = 57
      Top = 152
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 121
    end
    object EditEvent: TcxMemo [6]
      Left = 57
      Top = 177
      ParentFont = False
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      Style.Edges = []
      TabOrder = 4
      Height = 100
      Width = 365
    end
    object cxRadio1: TcxRadioGroup [7]
      Left = 23
      Top = 376
      Caption = #22788#29702#26041#26696':'
      ParentFont = False
      Properties.Items = <>
      Properties.OnEditValueChanged = cxRadio1PropertiesEditValueChanged
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      Transparent = True
      Height = 65
      Width = 399
    end
    object EditMemo: TcxMemo [8]
      Left = 57
      Top = 282
      ParentFont = False
      Properties.ScrollBars = ssVertical
      TabOrder = 5
      OnEnter = EditMemoEnter
      Height = 89
      Width = 185
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #20107#39033#21015#34920
        object dxLayout1Item7: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxListView1'
          ShowCaption = False
          Control = ListTodo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #22788#29702#26041#24335':'
        object dxLayout1Item4: TdxLayoutItem
          Caption = #26102#38388':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #26469#28304':'
          Control = EditFrom
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #20869#23481':'
          Control = EditEvent
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #22791#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = 'cxRadioGroup1'
          ShowCaption = False
          Control = cxRadio1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 26
    Top = 70
  end
  object ADOQuery1: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 54
    Top = 70
  end
  object ImageBar: TcxImageList
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 6422554
    ImageInfo = <
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000001A313D521E6A9AF7062F4C8901070B14000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000305070981BEFF6BAFCDFF0B5A8FFF0B578BF704416396025E
          90C502659AD30130496400000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000011724311D90C8FF59B6DEFF438EB6FF106498FF0676B3FF67CB
          EBFF6ACEEDFF057DBCFF00010102000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000012335482B97CDFF2BB2EAFF89CFE7FF2278A9FF0778B5FFA4D8
          EEFFAFDEF1FF057FBEFF00010203000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000011A28361B8FC8FF2DB1E9FF4EBEE9FF85CAE4FF127AB1FF0879
          B5FF0679B5FF085B8BD600020305000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000246698F1896D2FF36B6EAFF2EA2D9FF7BD3F0FF6BBADBFF1D7F
          B1FF1974A7FF13689DFF093E61A9000102030000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000002314A640E87C4FF30B4EAFF38B9EAFF38ADDFFF2C9BD1FF9AE2F5FF54AB
          D2FF1B7BAFFF156EA2FF106397FF063554950000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000000000B
          10160580BDFF26A9E0FF35B5E9FF3EBCECFF41B6E4FF218FC9FF38A2D6FFA0E3
          F5FF64B5D6FF1670A4FF106599FF0C5D90FF041F305400000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000248
          6B911999D3FF32B5E9FF39BAEBFF47C3ECFF2C9BD1FF2796CDFF3EA9DAFF49B4
          DEFF96E1F5FF78C1DFFF11669AFF0C5B90FF0C588AF201060911000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000126384C1089
          C4FF2FB2EAFF35B8EBFF41BFEBFF3EB2E1FF3AA8D9FF6DD5F3FF89E2F8FFB9ED
          FBFFD9F6FCFFBBEEFAFF87CDE5FF126194FF0B5B8FFF06314E8B000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000025C8ABB29A6
          DDFF36B8ECFF3EBCECFF4AC0ECFF4BBCE6FF67D5F3FF92E3F8FFDBF6FCFFE9F9
          FDFFBFEFFAFF9EE8F9FF87E1F8FF83D2EAFF428DB6FF08517FDB000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000475B0EF5CC4
          EEFF40BCEDFF49C3EDFF54C9F1FF64D1F2FF9CE4F7FFD7F3FBFF91E3F7FF5BD6
          F4FF63CAEDFF54BDE3FF4CB8E1FF43B0DCFF2B9BCEFF010D151F000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000035B88BD66BC
          E2FF63CBF0FF5ECBF0FF6DD3F3FF9CE3F6FFAEEAFAFF67D9F5FF64D5F3FF38A2
          D3FF025985B5023F5F8101314A6401273C51000A0F1400000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000025C89CF0981
          BFFF7DCFEEFF8ADDF5FFA7E5F9FF96E3F7FF5CD6F4FF5DC5E8FF0B80BFFF013C
          5A7B000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000015179BE52AF
          D7FF0A83BFFF5FC3E8FF71D7F4FF62CDEEFF2698CCFF02486D9401121C260000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000012334510251
          79BE025C8AD3035987BC036FA5E002537EAB011D2C3C00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end>
  end
end
