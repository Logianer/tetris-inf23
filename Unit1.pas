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

CONST
  FPS_CAP = trunc(1000 / 25);
  COLORS: array [0 .. 6] of integer = (clMenu, $EF1111, $EFFE13, $00FF00, $00FFFF,
    $0000FF, $FF00FF);
  PIECES: array [1 .. 3] of array [1 .. 4] of array [1 .. 2] of integer =
    (((0, 0), (1, 0), (1, 1), (1, 2)), ((0, 0), (1, 0), (0, 1), (1, 1)),
    ((0, 0), (0, 1), (0, 2), (0, 3)));

var
  GAME_INIT: boolean;
  GAME_TICK: LongInt;
  DELTA_TIME: integer;
  COLOR_I: integer;
  GAME_GRID: array[0..8, 0..13] of integer;
  Form1: TForm1;

implementation

{$R *.dfm}

procedure DrawGrid(c: TCanvas; form: TForm);
var
  I, size, size_x, size_y, curr_x, curr_y, piece_y: integer;
begin
  size := 40;
  size_x := 8;
  size_y := 13;
  c.brush.style := bsSolid;
  c.brush.color := clMenu;
  c.pen.style := psClear;
  c.rectangle(0, 0, form.width, form.height);

  c.brush.color := COLORS[COLOR_I];
  curr_x := (GAME_TICK mod (size_x * size_y)) mod size_x;
  curr_y := trunc((GAME_TICK mod (size_x * size_y)) / size_x);
  c.rectangle(15 + curr_x * size, 15 + curr_y * size, 15 + size + curr_x * size,
    15 + size + curr_y * size);
  c.brush.style := bsClear;
  c.pen.style := psSolid;
  piece_y := (trunc(GAME_TICK/10) mod size_y);
  for I := 1 to length(PIECES[2]) do
  begin
    c.rectangle(15 + (PIECES[2][I][1] + 3) * size, 15 + (PIECES[2][I][2] + piece_y) *
      size, 15 + size + (PIECES[2][I][1] + 3) * size,
      15 + size + (PIECES[2][I][2] + piece_y) * size);
  end;
  Application.ProcessMessages;
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

  DELTA_TIME := LongInt(GetTickCount) - time_index;
  if DELTA_TIME < FPS_CAP then
    Pause(FPS_CAP - DELTA_TIME);
  Application.ProcessMessages;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    32:
      begin
        inc(COLOR_I);
        COLOR_I := COLOR_I mod length(COLORS)
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
  GAME_TICK := 0;
  DELTA_TIME := 0;
  Application.OnIdle := IdleHandler;
end;

end.
