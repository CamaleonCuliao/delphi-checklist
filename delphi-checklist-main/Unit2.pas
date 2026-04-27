unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXPanels, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.pngimage;  // Necesario para PNG

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

{ Cargar PNG en un TSpeedButton }
procedure TForm2.LoadPngToButton(Button: TSpeedButton; const FileName: string);
var
  Png: TPngImage;
  Bmp: TBitmap;
  BtnW, BtnH: Integer;
  IconW, IconH: Integer;
  Ratio: Double;
  X, Y: Integer;
  i, j: Integer;
  Pixel: PRGBQuad;
begin
  Png := TPngImage.Create;
  Bmp := TBitmap.Create;
  try
    Png.LoadFromFile(FileName);

    BtnW := Button.Width;
    BtnH := Button.Height;

    // Proporción del PNG
    Ratio := Png.Width / Png.Height;

    // Icono al 50% del tamaño del botón
    IconW := Round(BtnW * 0.5);
    IconH := Round(IconW / Ratio);

    if IconH > BtnH * 0.5 then
    begin
      IconH := Round(BtnH * 0.5);
      IconW := Round(IconH * Ratio);
    end;

    X := (BtnW - IconW) div 2;
    Y := (BtnH - IconH) div 2;

    // Bitmap del tamaño del botón
    Bmp.SetSize(BtnW, BtnH);
    Bmp.PixelFormat := pf32bit;

    // Fondo blanco visible SIEMPRE
    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.FillRect(Rect(0, 0, BtnW, BtnH));

    // Dibujar icono escalado
    Bmp.Canvas.StretchDraw(Rect(X, Y, X + IconW, Y + IconH), Png);

    // Convertir icono a blanco
    for j := 0 to Bmp.Height - 1 do
    begin
      Pixel := Bmp.ScanLine[j];
      for i := 0 to Bmp.Width - 1 do
      begin
        if (Pixel.rgbRed < 240) or (Pixel.rgbGreen < 240) or (Pixel.rgbBlue < 240) then
        begin
          Pixel.rgbRed := 255;
          Pixel.rgbGreen := 255;
          Pixel.rgbBlue := 255;
        end;
        Inc(Pixel);
      end;
    end;

    Button.Glyph.Assign(Bmp);
    Button.NumGlyphs := 1;

    // Botón visible SIEMPRE
    Button.Flat := False;
    Button.Transparent := False;

  finally
    Png.Free;
    Bmp.Free;
  end;
end;


{ Cargar iconos iniciales }
procedure TForm2.LoadButtonImages;
var
  BasePath: string;
begin
  BasePath := ExtractFilePath(ParamStr(0));  // Ruta del EXE

  LoadPngToButton(btnPassword,    BasePath + 'passwordHide.png');
  LoadPngToButton(btnPasswordReg, BasePath + 'passwordHide.png');
end;

{ Alternar mostrar/ocultar contraseña }
procedure TForm2.TogglePassword(Edit: TEdit; Button: TSpeedButton);
var
  BasePath: string;
begin
  BasePath := ExtractFilePath(ParamStr(0));

  if Edit.PasswordChar = '*' then
  begin
    Edit.PasswordChar := #0;
    LoadPngToButton(Button, BasePath + 'passwordView.png');
  end
  else
  begin
    Edit.PasswordChar := '*';
    LoadPngToButton(Button, BasePath + 'passwordHide.png');
  end;
end;


{ Inicialización }
procedure TForm2.FormCreate(Sender: TObject);
begin
  editPassIni.PasswordChar := '*';
  editPasswordReg.PasswordChar := '*';

  LoadButtonImages;
end;

{ Botón mostrar/ocultar en iniciar sesión }
procedure TForm2.btnPasswordClick(Sender: TObject);
begin
  TogglePassword(editPassIni, btnPassword);
end;

{ Botón mostrar/ocultar en registro }
procedure TForm2.btnPasswordRegClick(Sender: TObject);
begin
  TogglePassword(editPasswordReg, btnPasswordReg);
end;

procedure TForm2.btnRegistrarClick(Sender: TObject);
begin
  // Lógica de registrar
end;

procedure TForm2.btnIniciarSesionClick(Sender: TObject);
begin
  // Lógica de iniciar sesión
end;

end.
