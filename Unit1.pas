unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure DrawGrid(c: TCanvas; form: TForm);
var I, size, size_x, size_y: integer;
begin
  size := 40;
  size_x := 9;
  size_y := 13;
  for I := 0 to size_x*size_y do
  begin
    c.Rectangle(15+(I mod size_x)*size,15+(I mod size_y)*size,15+size+(I mod size_x)*size,15+size+(I mod size_y)*size);
  end;

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  DrawGrid(Form1.Canvas, Form1);
end;

end.
