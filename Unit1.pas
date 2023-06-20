unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Vcl.StdCtrls;

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

type TGrid = array[0..7, 0..12] of integer;

CONST
  FPS_CAP = trunc(1000 / 25);
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
  NEXT_PIECE: Integer;
  Form1: TForm1;

implementation

{$R *.dfm}

procedure DrawGrid(c: TCanvas; form: TForm);
var
  I, J, size, size_x, size_y: integer;
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
    for J := 0 to length(GAME_GRID[0])-1 do
    begin
         c.brush.color := COLORS[GAME_GRID[I][J]];
    c.rectangle(15 + I * size, 15 + J * size, 15 + size + I * size,
      15 + size + J * size);
    end;
  end;
  // DRAW PIECE
  for I := 0 to length(PIECE_GRID)-1 do
  begin
    for J := 0 to length(PIECE_GRID[0])-1 do
    begin
    c.brush.color := COLORS[PIECE_GRID[I][J]];
    if PIECE_GRID[I][J] = 0 then c.Brush.Style := bsClear;
    
    c.rectangle(15 + I * size, 15 + J * size, 15 + size + I * size,
      15 + size + J * size);
    end;
  end;
  Application.ProcessMessages;
end;

procedure clearLine(line_y: integer; var grid: TGrid);
var
  I, J, tmp: Integer;
begin
  for I := line_y downto 0 do
  begin
    for J := 0 to 7 do
    begin
      if I=0 then grid[J][I] := 0
      else
      begin
        grid[J][I] := grid[J][I-1];
      end;
    end;
  end;

end;

procedure SpawnNextPiece();
var
  I, color: Integer;
begin
  color := random(6)+1;
  for I := 1 to 4 do
  begin
    PIECE_GRID[3+PIECES[NEXT_PIECE][I][1]][0+PIECES[NEXT_PIECE][I][2]] := color
  end;
  NEXT_PIECE := random(length(PIECES))+1;
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

procedure GameLoop;
var
  time_index: LongInt;
begin
  inc(GAME_TICK);
  time_index := LongInt(GetTickCount);

  DrawGrid(Form1.Canvas, Form1);
  if (GAME_TICK mod 8) = 0 then clearLine(12, PIECE_GRID);

  DELTA_TIME := LongInt(GetTickCount) - time_index;
  if DELTA_TIME < FPS_CAP then
    Pause(FPS_CAP - DELTA_TIME);
  Application.ProcessMessages;
end;

procedure ClearGrid(var grid: TGrid);
var I, J: integer;
begin
 for I := 0 to 7 do
  begin
    for J := 0 to 12 do grid[I][J] := 0
  end;
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
  end;
end;

procedure TForm1.IdleHandler(Sender: TObject; var Done: boolean);
begin
  GameLoop;
  Done := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I, J: Integer;
begin
  Randomize;
  GAME_TICK := 0;
  DELTA_TIME := 0;
  Application.OnIdle := IdleHandler;
  for I := 0 to 7 do
  begin
    for J := 0 to 12 do GAME_GRID[I][J] := 0
  end;
  PIECE_GRID := GAME_GRID;
  NEXT_PIECE := random(length(PIECES))+1;
  SpawnNextPiece();
  clearLine(12, PIECE_GRID);
end;

end.
