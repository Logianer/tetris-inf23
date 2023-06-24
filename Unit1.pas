unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure IdleHandler(Sender: TObject; var Done: boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

type TGrid = array[0..103] of integer;

CONST
  FPS_CAP = trunc(1000 / 30);
  COLORS: array [0 .. 6] of integer = (clMenu, $EF1111, $EFFE13, $00FF00, $00FFFF,
    $0000FF, $FF00FF);
  PIECES: array [1 .. 4] of array [1 .. 4] of array [1 .. 2] of integer =
    (((0, 0), (1, 0), (1, 1), (1, 2)), ((0, 0), (1, 0), (0, 1), (1, 1)),
    ((0, 0), (0, 1), (0, 2), (0, 3)),((0,0),(1,0),(1,1),(2,0)));

var
  GAME_INIT: boolean;
  GAME_TICK: LongInt;
  DELTA_TIME: integer;
  GAME_GRID: TGrid;
  PIECE_GRID: TGrid;
  CURRENT_PIECE: Integer;
  NEXT_PIECE: Integer;
  Form1: TForm1;

implementation

{$R *.dfm}

procedure DrawGrid(c: TCanvas; form: TForm);
var
  I, size, size_x, size_y: integer;
begin
  size := 35;
  size_x := 8;
  size_y := 13;
  c.brush.style := bsSolid;
  c.brush.color := clMenu;
  c.pen.style := psClear;
  c.rectangle(0, 0, form.width, form.height);
  c.brush.style := bsClear;
  c.pen.style := psSolid;

  // DRAW GRID
  for I := 0 to length(GAME_GRID)-1 do
  begin
    c.brush.color := COLORS[GAME_GRID[I]];
    c.rectangle(15 + (I mod 8) * size, 15 + trunc(I/8) * size, 15 + size + (I mod 8)* size, 15 + size + trunc(I/8) * size);
  end;
  // DRAW PIECE
  for I := 0 to length(PIECE_GRID)-1 do
  begin
    c.brush.color := COLORS[PIECE_GRID[I]];
    if PIECE_GRID[I] = 0 then c.Brush.Style := bsClear;
    c.rectangle(15 + (I mod 8) * size, 15 + trunc(I/8) * size, 15 + size + (I mod 8)* size, 15 + size + trunc(I/8) * size);
  end;
  Application.ProcessMessages;
end;

procedure clearRow(line_y: integer; var grid: TGrid);
var
  I: Integer;
begin
  for I := 7+(line_y*8) downto 0 do
  begin
      if trunc(I/8) = 0 then grid[I] := 0
      else
      begin
        grid[I] := grid[I - 8];
    end;
  end;

end;

procedure MovePiece(direction: boolean);
// direction: true-left | false-right
var
  I: Integer;
begin
  if direction then
  begin
  // PRECHECK
  for I := 0 to 103 do begin
  if (I mod 8 = 0) and (PIECE_GRID[I] <> 0) then Abort;
  if (I mod 8 > 0) and (GAME_GRID[I-1] <> 0) and (PIECE_GRID[I] <> 0) then Abort;
  end;
   // MODIFY
   for I := 0 to 103 do
    begin
      if (I mod 8) = 7 then PIECE_GRID[I] := 0
      else if (I mod 8 = 0) and (PIECE_GRID[I] <> 0) then Abort
      else
      begin
        PIECE_GRID[I] := PIECE_GRID[I + 1];
      end;
    end;
  end else
  begin
    // PRECHECK
    for I := 103 downto 0 do begin
    if (I mod 8 = 7) and (PIECE_GRID[I] <> 0) then Abort;
    if (I mod 8 < 7) and (GAME_GRID[I+1] <> 0) and (PIECE_GRID[I] <> 0) then Abort;
    end;
    // MODIFY
    for I := 103 downto 0 do
    begin
      if (I mod 8) = 0 then PIECE_GRID[I] := 0
      else
      begin
        PIECE_GRID[I] := PIECE_GRID[I - 1];
      end;
    end;
  end;
end;

procedure ClearGrid(var grid: TGrid);
var I: integer;
begin
 for I := 0 to length(grid)-1 do grid[I] := 0
end;

procedure SpawnNextPiece();
var
  I, color: Integer;
begin
  color := random(6)+1;
  for I := 1 to 4 do
  begin
    PIECE_GRID[3+PIECES[NEXT_PIECE][I][1]+(PIECES[NEXT_PIECE][I][2]*8)] := color
  end;
  CURRENT_PIECE := NEXT_PIECE;
  NEXT_PIECE := random(length(PIECES))+1;
end;

procedure CheckFullRows();
var
  I,J: Integer;
  full_row: boolean;
begin

  for I := 0 to 12 do
  begin

    full_row := true;
    for J := 0 to 7 do if GAME_GRID[(I*8)+J] = 0 then full_row := false;
    if full_row = true then clearRow(I, GAME_GRID);
  end;
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
  I: Integer;
begin
  for I := 0 to 103 do if PIECE_GRID[I] <> 0 then GAME_GRID[I] := PIECE_GRID[I];
  ClearGrid(PIECE_GRID);
  Pause(1000);
  CheckFullRows();
  Pause(500);
  SpawnNextPiece();
end;

function CheckCollision(): boolean;
var
  I: Integer;
  collide: boolean;
begin
  collide := false;
  for I := 0 to 103 do
  begin
      if (trunc(I/8) = 12) and (PIECE_GRID[I] <> 0) then collide := true
      else if (PIECE_GRID[I] <> 0) and (GAME_GRID[I+8] <> 0) then collide := true;
  end;
  CheckCollision := collide;
end;


procedure GameLoop;
var
  time_index: LongInt;
begin
  inc(GAME_TICK);
  time_index := LongInt(GetTickCount);

  if ((GAME_TICK mod 8) = 0) then
  begin
    if CheckCollision then AttachPiece()
    else clearRow(12, PIECE_GRID);
    if GAME_GRID[3] <> 0 then Form1.close();

  end;

  DrawGrid(Form1.Canvas, Form1);

  DELTA_TIME := LongInt(GetTickCount) - time_index;
  if DELTA_TIME < FPS_CAP then
    Pause(FPS_CAP - DELTA_TIME);
  Application.ProcessMessages;
end;
//-------------------------------------------------------------------------------------
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    32:
      begin
        ClearGrid(PIECE_GRID);
        SpawnNextPiece();
      end;
    37, 65:
      begin
        MovePiece(true);
      end;
    39, 68:
      begin
        MovePiece(false);
      end;
  end;
end;

procedure TForm1.IdleHandler(Sender: TObject; var Done: boolean);
begin
  GameLoop;
  Done := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
  GAME_TICK := 0;
  DELTA_TIME := 0;
  Application.OnIdle := IdleHandler;
  ClearGrid(GAME_GRID);
  GAME_GRID[12*8+3] := 4;
  GAME_GRID[12*8+2] := 4;
  GAME_GRID[11*8+2] := 4;
  GAME_GRID[11*8+3] := 4;
  ClearGrid(PIECE_GRID);
  NEXT_PIECE := random(length(PIECES))+1;
  SpawnNextPiece();
end;

end.
