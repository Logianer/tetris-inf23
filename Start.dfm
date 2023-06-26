object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Tetris - Start'
  ClientHeight = 307
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 16
  Font.Name = 'Consolas'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 0
    Top = 8
    Width = 417
    Height = 36
    Alignment = taCenter
    AutoSize = False
    Caption = 'Tetris'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 3918706
    Font.Height = 36
    Font.Name = 'Consolas'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 66
    Width = 361
    Height = 103
    TabStop = False
    BorderStyle = bsNone
    Color = clMenu
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 11419907
    Font.Height = 16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Steuerung:'
      #8592' '#8594' A D: Teil links-rechts bewegen'
      ''
      #8593' [Leertaste]: Teil drehen'
      ''
      #8595' S: Teil schneller nach unten bewegen')
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    WantReturns = False
  end
  object Start: TButton
    Left = 144
    Top = 200
    Width = 121
    Height = 33
    Caption = 'Start'
    TabOrder = 1
    OnClick = StartClick
  end
  object Ende: TButton
    Left = 144
    Top = 248
    Width = 121
    Height = 33
    Caption = 'Beenden'
    TabOrder = 2
    OnClick = EndeClick
  end
end
