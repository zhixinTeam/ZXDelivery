inherited fFormCrossCard: TfFormCrossCard
  Left = 402
  Top = 116
  Caption = #30913#21345#26597#35810
  ClientHeight = 256
  ClientWidth = 461
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 461
    Height = 256
    inherited BtnOK: TButton
      Left = 301
      Top = 223
      Width = 79
      Caption = #21150#29702#36890#34892#21345
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 385
      Top = 223
      TabOrder = 8
    end
    object EditTruck: TcxTextEdit [2]
      Left = 81
      Top = 176
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 6
      Width = 121
    end
    object EditCard: TcxTextEdit [3]
      Left = 81
      Top = 51
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 1
      Width = 121
    end
    object cxLabel2: TcxLabel [4]
      Left = 23
      Top = 36
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Transparent = True
      Height = 10
      Width = 331
    end
    object EditUse: TcxTextEdit [5]
      Left = 81
      Top = 76
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object EditFreeze: TcxTextEdit [6]
      Left = 81
      Top = 126
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditCType: TcxTextEdit [7]
      Left = 81
      Top = 151
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    object EditUTime: TcxTextEdit [8]
      Left = 81
      Top = 101
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item12: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20351#29992#29366#24577':'
          Control = EditUse
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #20351#29992#26102#38388':'
          Control = EditUTime
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20923#32467#29366#24577':'
          Control = EditFreeze
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #30913#21345#31867#22411':'
          Control = EditCType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#33337#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    Timeouts.ReadTotalMultiplier = 10
    Timeouts.ReadTotalConstant = 100
    OnRxChar = ComPort1RxChar
    Left = 14
    Top = 4
  end
end
