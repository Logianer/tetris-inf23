unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Vcl.StdCtrls, GameOver, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ScorePanel: TPanel;
    Beenden: TButton;
    procedure FormCreate(Sender: TObject);
    procedure IdleHandler(Sender: TObject; var Done: boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BeendenClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

type
  TGrid = array [0 .. 103] of integer;
  TPieceCoord = array [1 .. 4, 1 .. 2] of integer;
  TPieces = array [1 .. 7] of TPieceCoord;

CONST
  FPS_CAP = trunc(1000 / 30);
  COLORS: array [0 .. 5] of integer = (clMenu, $AE4103, $3BCB72, $00D5FF,
    $1C97FF, $1332FF);
  // Order: L, J, O, I, T, S, Z
  Pieces: TPieces = (((0, -1), (1, -1), (1, 0), (1, 1)),
    ((0, -1), (-1, -1), (-1, 0), (-1, 1)), ((0, 0), (1, 0), (0, 1), (1, 1)),
    ((0, -1), (0, 0), (0, 1), (0, 2)), ((0, 0), (-1, -1), (0, -1), (1, -1)),
    ((0, 0), (1, 0), (-1, 1), (0, 1)), ((0, 0), (-1, 0), (0, 1), (1, 1)));

var
  GAME_STATE: (gsStart, gsPaused, gsGameOver);
  GAME_TICK: LongInt;
  DELTA_TIME: integer;
  GAME_GRID: TGrid;
  SCORE: Integer;
  PIECE_GRID: TGrid;
  CURRENT_PIECE: integer;
  CURRENT_COLOR: integer;
  CURRENT_PIECE_POS: array [1 .. 2] of integer;
  CURRENT_PIECE_ROTATION: integer;
  NEXT_PIECE: integer;
  Form1: TForm1;

implementation

{$R *.dfm}

function RotatePoints(const Points: TPieceCoord; rotation: integer)
  : TPieceCoord;
var
  I: integer;
begin

  for I := 1 to 4 do
  begin
    case rotation of
      1:
        begin
          Result[I][1] := Points[I][2];
          Result[I][2] := -Points[I][1];
        end;
      2:
        begin
          Result[I][1] := -Points[I][1];
          Result[I][2] := -Points[I][2];
        end;
      3:
        begin
          Result[I][1] := -Points[I][2];
          Result[I][2] := Points[I][1];
        end;
    else
      Result := Points;
    end;
  end;
end;

procedure Draw(form: TForm);
var
  I, size, size_x, size_y: integer;
  Buffer: TBitmap;
  c: TCanvas;
begin
  size := 35;
  size_x := 8;
  size_y := 13;

  Buffer := TBitmap.Create;
  Buffer.Width := Form1.Width;
  Buffer.Height := Form1.Height;
  c := Buffer.Canvas;

  c.brush.style := bsSolid;
  c.pen.style := psClear;
  c.brush.style := bsClear;
  c.pen.style := psSolid;
  c.pen.color := clGray;

  // DRAW GRID
  for I := 0 to length(GAME_GRID) - 1 do
  begin
    c.brush.color := COLORS[GAME_GRID[I]];
    c.rectangle(15 + (I mod 8) * size, 15 + trunc(I / 8) * size,
      15 + size + (I mod 8) * size, 15 + size + trunc(I / 8) * size);
  end;
  // DRAW PIECE
  for I := 0 to length(PIECE_GRID) - 1 do
  begin
    c.brush.color := COLORS[PIECE_GRID[I]];
    if PIECE_GRID[I] = 0 then
      c.brush.style := bsClear;
    c.rectangle(15 + (I mod 8) * size, 15 + trunc(I / 8) * size,
      15 + size + (I mod 8) * size, 15 + size + trunc(I / 8) * size);
  end;
  form.Canvas.Draw(0, 0, Buffer);
  Application.ProcessMessages;
end;

procedure UpdateScore();
begin
  Form1.ScorePanel.Caption := 'Score: '+InttoStr(SCORE);
end;

procedure clearRow(line_y: integer; var grid: TGrid);
var
  I: integer;
begin
  for I := 7 + (line_y * 8) downto 0 do
  begin
    if trunc(I / 8) = 0 then
      grid[I] := 0
    else
    begin
      grid[I] := grid[I - 8];
    end;
  end;

end;

procedure MovePiece(direction: boolean);
// direction: true-left | false-right
var
  I: integer;
begin
  if direction then
  begin
    // PRECHECK
    for I := 0 to 103 do
    begin
      if (I mod 8 = 0) and (PIECE_GRID[I] <> 0) then
        Abort;
      if (I mod 8 > 0) and (GAME_GRID[I - 1] <> 0) and (PIECE_GRID[I] <> 0) then
        Abort;
    end;
    // MODIFY
    for I := 0 to 103 do
    begin
      if (I mod 8) = 7 then
        PIECE_GRID[I] := 0
      else if (I mod 8 = 0) and (PIECE_GRID[I] <> 0) then
        Abort
      else
      begin
        PIECE_GRID[I] := PIECE_GRID[I + 1];
      end;
    end;
    dec(CURRENT_PIECE_POS[1]);
  end
  else
  begin
    // PRECHECK
    for I := 103 downto 0 do
    begin
      if (I mod 8 = 7) and (PIECE_GRID[I] <> 0) then
        Abort;
      if (I mod 8 < 7) and (GAME_GRID[I + 1] <> 0) and (PIECE_GRID[I] <> 0) then
        Abort;
    end;
    // MODIFY
    for I := 103 downto 0 do
    begin
      if (I mod 8) = 0 then
        PIECE_GRID[I] := 0
      else
      begin
        PIECE_GRID[I] := PIECE_GRID[I - 1];
      end;
    end;
    inc(CURRENT_PIECE_POS[1])
  end;
end;

procedure ClearGrid(var grid: TGrid);
var
  I: integer;
begin
  for I := 0 to length(grid) - 1 do
    grid[I] := 0
end;

procedure RotatePiece();
var
  new_points: TPieceCoord;
  I: integer;
begin
  new_points := RotatePoints(Pieces[CURRENT_PIECE], CURRENT_PIECE_ROTATION);
  ClearGrid(PIECE_GRID);
  for I := 1 to 4 do
    PIECE_GRID[CURRENT_PIECE_POS[1] + new_points[I][1] +
      (new_points[I][2] + CURRENT_PIECE_POS[2]) * 8] := CURRENT_COLOR;
end;

procedure SpawnNextPiece();
var
  I: integer;
begin
  CURRENT_COLOR := random(5) + 1;
  for I := 1 to 4 do
  begin
    PIECE_GRID[3 + Pieces[NEXT_PIECE][I][1] + (Pieces[NEXT_PIECE][I][2] + 1) *
      8] := CURRENT_COLOR
  end;
  CURRENT_PIECE_POS[1] := 3;
  CURRENT_PIECE_POS[2] := 1;
  CURRENT_PIECE_ROTATION := 0;
  CURRENT_PIECE := NEXT_PIECE;
  NEXT_PIECE := random(length(Pieces)) + 1;
end;

procedure CheckFullRows();
var
  I, J: integer;
  full_row: boolean;
  full_row_counter: Integer;
begin

  for I := 0 to 12 do
  begin

    full_row := true;
    full_row_counter := 0;
    for J := 0 to 7 do
      if GAME_GRID[(I * 8) + J] = 0 then
        full_row := false;
    if full_row = true then begin
    clearRow(I, GAME_GRID);
    inc(full_row_counter);
    end;
  end;
  // SCORE SYSTEM: https://tetris.wiki/Scoring
  case full_row_counter of
  1: inc(SCORE, 40);
  2: inc(SCORE, 100);
  3: inc(SCORE, 300);
  4..13: inc(SCORE,(1200*(full_row_counter-3))); // ab 4: 1200 & für jede weitere 1200 p.
  end;
  UpdateScore();
end;

procedure Pause(ms: integer);
var
  current_time: LongInt;
  pause_time: LongInt;
begin
  current_time := GetTickCount;
  pause_time := current_time + ms;
  while current_time < (pause_time) do
  begin
    Application.ProcessMessages;
    current_time := GetTickCount;
  end;
end;

procedure AttachPiece();
var
  I: integer;
begin
  for I := 0 to 103 do
    if PIECE_GRID[I] <> 0 then
      GAME_GRID[I] := PIECE_GRID[I];
  ClearGrid(PIECE_GRID);
  CheckFullRows();
  GAME_STATE := gsPaused;
  Pause(500);
  GAME_STATE := gsStart;
  SpawnNextPiece();
end;

function CheckCollision(): boolean;
var
  I: integer;
  collide: boolean;
begin
  collide := false;
  for I := 0 to 103 do
  begin
    if (trunc(I / 8) = 12) and (PIECE_GRID[I] <> 0) then
      collide := true
    else if (PIECE_GRID[I] <> 0) and (GAME_GRID[I + 8] <> 0) then
      collide := true;
  end;
  CheckCollision := collide;
end;

procedure PieceTick();
begin
  if CheckCollision then
    AttachPiece()
  else
  begin
    clearRow(12, PIECE_GRID);
    inc(CURRENT_PIECE_POS[2])
  end;

  if GAME_GRID[3] <> 0 then GAME_STATE := gsGameOver;
end;

procedure GameLoop;
var
  time_index: LongInt;
begin
  inc(GAME_TICK);
  time_index := LongInt(GetTickCount);
  case GAME_STATE of
    gsStart:
      begin
        if ((GAME_TICK mod 10) = 0) then
          PieceTick();
        Draw(Form1);
      end;
  end;

  DELTA_TIME := LongInt(GetTickCount) - time_index;
  if DELTA_TIME < FPS_CAP then
    Pause(FPS_CAP - DELTA_TIME);
  Application.ProcessMessages;
end;

// -------------------------------------------------------------------------------------
procedure TForm1.FormKeyDown(Sender: TObject;

  var Key: Word; Shift: TShiftState);
begin
  if GAME_STATE = gsPaused then Abort;
  case Key of
    // https://keycode.info
    32, 38, 87: // SPACE, W, UP ARROW
      begin
        inc(CURRENT_PIECE_ROTATION);
        if CURRENT_PIECE_ROTATION = 4 then
          CURRENT_PIECE_ROTATION := 0;
        RotatePiece();
      end;
    190: // PERIOD
      begin
        ClearGrid(GAME_GRID);
      end;
    188: // COMMA
      begin
        ClearGrid(PIECE_GRID);
        SpawnNextPiece();
      end;
    37, 65: // LEFT ARROW, A
      begin
        MovePiece(true);
      end;
    39, 68: // RIGHT ARROW, D
      begin
        MovePiece(false);
      end;
    40, 83: // DOWN ARROW, S
      begin
        PieceTick();
      end;
  end;
end;

procedure TForm1.IdleHandler(Sender: TObject;

  var Done: boolean);
begin
  GameLoop;
  Done := false;
end;

procedure TForm1.BeendenClick(Sender: TObject);
begin
  GAME_STATE := gsGameOver;
  Form2.Show();
  Form1.hide();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
  GAME_STATE := gsStart;
  SCORE := 0;
  UpdateScore();
  GAME_TICK := 0;
  DELTA_TIME := 0;
  Application.OnIdle := IdleHandler;
  ClearGrid(GAME_GRID);
  ClearGrid(PIECE_GRID);
  CURRENT_PIECE_ROTATION := 0;
  NEXT_PIECE := random(length(Pieces)) + 1;
  SpawnNextPiece();
end;

end.
