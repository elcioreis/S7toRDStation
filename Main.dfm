object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'S7 to RD Station'
  ClientHeight = 277
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    675
    277)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 8
    Top = 8
    Width = 659
    Height = 261
    HelpType = htKeyword
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo')
    ParentFont = False
    TabOrder = 0
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = ExecuteTimer
    Left = 104
    Top = 88
  end
end
