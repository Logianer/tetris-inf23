program Project1;

uses
  Vcl.Forms,
  Start in 'Start.pas' {Form3},
  GameOver in 'GameOver.pas' {Form2},
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
