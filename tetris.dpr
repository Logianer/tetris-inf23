program tetris;

uses
  Vcl.Forms,
  Start in 'Start.pas' {Form3},
  GameOver in 'GameOver.pas' {Form2},
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Title := 'Tetris';
  Application.Initialize;
  Application.MainFormOnTaskbar := false;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
