inherited fFormCard: TfFormCard
  Left = 844
  Top = 413
  Caption = #20851#32852#30913#21345
  ClientHeight = 183
  ClientWidth = 314
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 314
    Height = 183
    inherited BtnOK: TButton
      Left = 167
      Top = 150
      Caption = #30830#23450
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 238
      Top = 150
      TabOrder = 5
    end
    object EditBill: TcxTextEdit [2]
      Left = 84
      Top = 29
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsOffice11
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditTruck: TcxTextEdit [3]
      Left = 84
      Top = 56
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsOffice11
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object cxLabel1: TcxLabel [4]
      Left = 24
      Top = 83
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 20
      Width = 287
    end
    object EditCard: TcxTextEdit [5]
      Left = 84
      Top = 109
      ParentFont = False
      Properties.MaxLength = 15
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsOffice11
      TabOrder = 3
      OnKeyPress = EditCardKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = ''
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = EditBill
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#33337#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
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
    Left = 12
    Top = 148
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 40
    Top = 148
  end
end
