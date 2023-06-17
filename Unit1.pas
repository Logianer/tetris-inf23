unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormResize(Sender: TObject);
    procedure IdleHandler(Sender: TObject; var Done: boolean);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

CONST
  FPS_CAP = trunc(1000 / 30);

var
  GAME_INIT: boolean;
  GAME_TICK: LongInt;
  Form1: TForm1;

implementation

{$R *.dfm}

procedure DrawGrid(c: TCanvas; form: TForm);
var
  I, size, size_x, size_y: integer;
begin
  size := 40;
  size_x := 9;
  size_y := 13;
  for I := 0 to size_x * size_y do
  begin
    if GAME_TICK mod 2 = 0 then c.Brush.Color := clBlue
    else c.Brush.Color := $00000000;
    c.Rectangle(15 + (I mod size_x) * size, 15 + (I mod size_y) * size,
      15 + size + (I mod size_x) * size, 15 + size + (I mod size_y) * size);
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

procedure GameLoop;
var
  time_index: LongInt;
begin
  inc(GAME_TICK);
  time_index := LongInt(GetTickCount);
  DrawGrid(Form1.Canvas, Form1);
  time_index := LongInt(GetTickCount) - time_index;
  // Pause if it was too quick
  if (time_index < FPS_CAP) then
  begin
    Pause(FPS_CAP - time_index);
  end;
  Application.ProcessMessages;
end;

procedure TForm1.IdleHandler(Sender: TObject; var Done: boolean);
begin
  GameLoop;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  GAME_TICK := 0;
  Application.OnIdle := IdleHandler;
end;

end.
