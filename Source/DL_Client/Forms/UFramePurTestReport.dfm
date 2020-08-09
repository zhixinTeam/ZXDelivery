inherited fFramePurTestReport: TfFramePurTestReport
  Width = 899
  inherited ToolBar1: TToolBar
    Width = 899
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 135
    Width = 899
    Height = 232
    inherited cxView1: TcxGridDBTableView
      DataController.DetailKeyFieldNames = 'S_BatID'
      DataController.MasterKeyFieldNames = 'S_BatID'
    end
    object cxView_2: TcxGridDBTableView [1]
      NavigatorButtons.ConfirmDelete = False
      OnCustomDrawCell = cxView_2CustomDrawCell
      DataController.DataSource = Ds_ItemData
      DataController.DetailKeyFieldNames = 'H_BatID'
      DataController.MasterKeyFieldNames = 'S_BatID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      object Clmn_1: TcxGridDBColumn
        Caption = #26816#27979#39033
        DataBinding.FieldName = 'I_ItemsName'
        Width = 123
      end
      object Clmn_2: TcxGridDBColumn
        Caption = #26816#27979#20540
        DataBinding.FieldName = 'H_Value'
        Width = 123
      end
      object Clmn_3: TcxGridDBColumn
        Caption = #26816#27979#32467#26524
        DataBinding.FieldName = 'H_Result'
        Width = 123
      end
    end
    inherited cxLevel1: TcxGridLevel
      object cxLevel_2: TcxGridLevel
        GridView = cxView_2
      end
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 899
    Height = 68
    object lbl1: TLabel [0]
      Left = 501
      Top = 36
      Width = 337
      Height = 17
      AutoSize = False
      Caption = '      '#25628#32034#20869#23481#21487#20026#65306' '#20379#24212#21830#12289#29289#26009#12289#21152#23494#32534#30721#31561#20449#24687#13#10#13#10'         '
      Color = clWindow
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Edit_Name: TcxButtonEdit [1]
      Left = 320
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = Edit_NamePropertiesButtonClick
      TabOrder = 1
      Width = 176
    end
    object EditDate: TcxButtonEdit [2]
      Left = 87
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 0
      Width = 176
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21462#26679#26085#26399#65306
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20851#38190#23383#65306
          Control = Edit_Name
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          ShowCaption = False
          Control = lbl1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 127
    Width = 899
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 899
    inherited TitleBar: TcxLabel
      Caption = #21407#26009#36136#26816#20998#26512#25253#21578#21333
      Style.IsFontAssigned = True
      Width = 899
      AnchorX = 450
      AnchorY = 11
    end
  end
  object Qry_ItemData: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 5
    Top = 236
  end
  object Ds_ItemData: TDataSource
    DataSet = Qry_ItemData
    Left = 36
    Top = 236
  end
end
