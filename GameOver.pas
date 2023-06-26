unit GameOver;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    OK: TButton;
    Panel1: TPanel;
    Menü: TButton;
    procedure OKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenüClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

Uses Unit1;
{$R *.dfm}

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OKClick(Sender);
end;

procedure TForm2.FormShow(Sender: TObject);
begin  Panel1.Caption := 'Score: '+Inttostr(Unit1.SCORE);
end;

procedure TForm2.MenüClick(Sender: TObject);
begin
  self.close;
  Form1.Button1Click(Sender); // spart schreibarbeit
end;

procedure TForm2.OKClick(Sender: TObject);
begin
  self.Close;
end;

end.
