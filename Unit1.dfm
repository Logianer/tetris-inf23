object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Tetris'
  ClientHeight = 480
  ClientWidth = 480
  Color = clWhite
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 18
  Font.Name = 'Consolas'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormActivate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 18
  object ScorePanel: TPanel
    Left = 279
    Top = 16
    Width = 185
    Height = 41
    Caption = 'Score: 0'
    Color = clSilver
    ParentBackground = False
    TabOrder = 0
  end
  object Beenden: TButton
    Left = 384
    Top = 447
    Width = 88
    Height = 25
    Caption = 'Game Over'
    TabOrder = 1
    TabStop = False
    OnClick = BeendenClick
  end
  object Button1: TButton
    Left = 384
    Top = 416
    Width = 88
    Height = 25
    Caption = 'Men'#252
    TabOrder = 2
    TabStop = False
    OnClick = Button1Click
  end
end
