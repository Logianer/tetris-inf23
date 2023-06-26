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
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 18
  object Panel1: TPanel
    Left = 279
    Top = 16
    Width = 185
    Height = 41
    Caption = 'Score: 0'
    Color = clSilver
    ParentBackground = False
    TabOrder = 0
  end
end
