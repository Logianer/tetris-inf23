unit Start;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Unit1;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Start: TButton;
    Ende: TButton;
    procedure EndeClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.EndeClick(Sender: TObject);
begin
  close();
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EndeClick(Sender);
end;

procedure TForm3.StartClick(Sender: TObject);
begin
  Application.CreateForm(TForm1, Form1);
  self.hide();
end;

end.
