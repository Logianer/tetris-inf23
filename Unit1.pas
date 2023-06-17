unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure IdleHandler(Sender: TObject; var Done: boolean);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

CONST
  FPS_CAP = trunc(1000 / 25);

var
  GAME_INIT: boolean;
  GAME_TICK: LongInt;
  DELTA_TIME: integer;
  Form1: TForm1;

implementation

{$R *.dfm}

procedure DrawGrid(c: TCanvas; form: TForm);
var
  I, size, size_x, size_y, curr_x, curr_y: integer;
begin
  size := 40;
  size_x := 9;
  size_y := 13;
  c.brush.style := bsSolid;
  c.brush.color := $ffff00;
  c.pen.Style := psClear;
  c.rectangle(0,0,form.width,form.height);

  c.brush.color := $00ff00;
  curr_x := (GAME_TICK mod (size_x*size_y)) mod size_x;
  curr_y := trunc((GAME_TICK mod (size_x*size_y))/size_x);
  c.Rectangle(15 + curr_x * size, 15 + curr_y * size,
      15 + size + curr_x * size, 15 + size + curr_y * size);
  c.brush.style := bsClear;
  c.pen.Style := psSolid;
  for I := 1 to size_x * size_y do
  begin
    c.Rectangle(15 + (I mod size_x) * size, 15 + (I mod size_y) * size,
      15 + size + (I mod size_x) * size, 15 + size + (I mod size_y) * size);
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
  if DELTA_TIME < FPS_CAP then Pause(FPS_CAP - DELTA_TIME);
  Application.ProcessMessages;
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
