unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXPanels, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.pngimage;  // 👈 NECESARIO PARA PNG

type
  TForm2 = class(TForm)
    Contenido: TCardPanel;
    InicioSesion: TCard;
    Registro: TCard;
    App: TCard;
    paginaRegistro: TPageControl;
    paginaIniciarSesion: TTabSheet;
    paginaRegistrar: TTabSheet;
    Label1: TLabel;
    editNombreUsu: TEdit;
    Label2: TLabel;
    editPassIni: TEdit;
    editPasswordReg: TEdit;
    Label3: TLabel;
    editUsuReg: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    btnPassword: TSpeedButton;
    SpeedButton1: TSpeedButton;
    btnPasswordReg: TSpeedButton;
    btnRegistrar: TSpeedButton;
    btnIniciarSesion: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure btnPasswordClick(Sender: TObject);
    procedure btnPasswordRegClick(Sender: TObject);
    procedure btnIniciarSesionClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);

  private
    procedure TogglePassword(Edit: TEdit; Button: TSpeedButton);
    procedure LoadButtonImages;
    procedure LoadPngToButton(Button: TSpeedButton; const FileName: string);
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

{ 🔵 Cargar PNG en un TSpeedButton }
procedure TForm2.LoadPngToButton(Button: TSpeedButton; const FileName: string);
var
  Png: TPngImage;
begin
  Png := TPngImage.Create;
  try
    Png.LoadFromFile(FileName);
    Button.Glyph.Assign(Png);  // Convierte PNG → Bitmap interno
  finally
    Png.Free;
  end;
end;

{ 🔵 Cargar iconos iniciales }
procedure TForm2.LoadButtonImages;
var
  BasePath: string;
begin
  BasePath := ExtractFilePath(ParamStr(0)) + 'imgs\';

  LoadPngToButton(btnPassword,    BasePath + 'passwordHide.png');
  LoadPngToButton(btnPasswordReg, BasePath + 'passwordHide.png');
end;

{ 🔵 Alternar mostrar/ocultar contraseña }
procedure TForm2.TogglePassword(Edit: TEdit; Button: TSpeedButton);
var
  BasePath: string;
begin
  BasePath := ExtractFilePath(ParamStr(0)) + 'imgs\';

  if Edit.PasswordChar = '*' then
  begin
    Edit.PasswordChar := #0;  // Mostrar
    LoadPngToButton(Button, BasePath + 'passwordView.png');
  end
  else
  begin
    Edit.PasswordChar := '*'; // Ocultar
    LoadPngToButton(Button, BasePath + 'passwordHide.png');
  end;
end;

{ 🔵 Inicialización }
procedure TForm2.FormCreate(Sender: TObject);
begin
  editPassIni.PasswordChar := '*';
  editPasswordReg.PasswordChar := '*';

  LoadButtonImages; // Cargar iconos iniciales
end;

{ 🔵 Botón mostrar/ocultar en iniciar sesión }
procedure TForm2.btnPasswordClick(Sender: TObject);
begin
  TogglePassword(editPassIni, btnPassword);
end;

{ 🔵 Botón mostrar/ocultar en registro }
procedure TForm2.btnPasswordRegClick(Sender: TObject);
begin
  TogglePassword(editPasswordReg, btnPasswordReg);
end;

procedure TForm2.btnRegistrarClick(Sender: TObject);
begin
     // Aquí tu lógica de Registrar
end;

procedure TForm2.btnIniciarSesionClick(Sender: TObject);
begin
  // Aquí tu lógica de iniciar sesión
end;

end.

