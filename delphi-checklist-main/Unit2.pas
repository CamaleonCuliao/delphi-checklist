unit Unit2;

interface

uses
  Unit3, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXPanels, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.pngimage;

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
    editEmailReg: TEdit;
    Label2: TLabel;
    editPassIni: TEdit;
    editPasswordReg: TEdit;
    Label3: TLabel;
    editUsuReg: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    btnPassword: TSpeedButton;
    SpeedButton1: TSpeedButton;
    btnPasswordReg: TSpeedButton;
    btnRegistrar: TSpeedButton;
    btnIniciarSesion: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnPasswordClick(Sender: TObject);
    procedure btnPasswordRegClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure btnIniciarSesionClick(Sender: TObject);
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

    Ratio := Png.Width / Png.Height;

    IconW := Round(BtnW * 0.5);
    IconH := Round(IconW / Ratio);

    if IconH > BtnH * 0.5 then
    begin
      IconH := Round(BtnH * 0.5);
      IconW := Round(IconH * Ratio);
    end;

    X := (BtnW - IconW) div 2;
    Y := (BtnH - IconH) div 2;

    Bmp.SetSize(BtnW, BtnH);
    Bmp.PixelFormat := pf32bit;

    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.FillRect(Rect(0, 0, BtnW, BtnH));

    Bmp.Canvas.StretchDraw(Rect(X, Y, X + IconW, Y + IconH), Png);

    for j := 0 to Bmp.Height - 1 do
    begin
      Pixel := Bmp.ScanLine[j];
      for i := 0 to Bmp.Width - 1 do
      begin
        if (Pixel.rgbRed < 240) or (Pixel.rgbGreen < 240) or (Pixel.rgbBlue < 240) then
        begin
          Pixel.rgbRed   := 255;
          Pixel.rgbGreen := 255;
          Pixel.rgbBlue  := 255;
        end;
        Inc(Pixel);
      end;
    end;

    Button.Glyph.Assign(Bmp);
    Button.NumGlyphs    := 1;
    Button.Flat         := False;
    Button.Transparent  := False;

  finally
    Png.Free;
    Bmp.Free;
  end;
end;

procedure TForm2.LoadButtonImages;
var
  BasePath: string;
begin
  BasePath := ExtractFilePath(ParamStr(0));
  LoadPngToButton(btnPassword,    BasePath + 'passwordHide.png');
  LoadPngToButton(btnPasswordReg, BasePath + 'passwordHide.png');
end;

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

procedure TForm2.FormCreate(Sender: TObject);
begin
  editPassIni.PasswordChar     := '*';
  editPasswordReg.PasswordChar := '*';
  LoadButtonImages;
end;

procedure TForm2.btnPasswordClick(Sender: TObject);
begin
  TogglePassword(editPassIni, btnPassword);
end;

procedure TForm2.btnPasswordRegClick(Sender: TObject);
begin
  TogglePassword(editPasswordReg, btnPasswordReg);
end;

procedure TForm2.btnRegistrarClick(Sender: TObject);
var
  Nombre, Email, Password: string;
begin
  Nombre   := editUsuReg.Text;
  Email    := editEmailReg.Text;
  Password := editPasswordReg.Text;

  if (Trim(Nombre) = '') or (Trim(Email) = '') or (Trim(Password) = '') then
  begin
    ShowMessage('Rellena todos los campos');
    Exit;
  end;

  dm_data.FDConnection1.Connected := True;
  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text :=
    'INSERT INTO usuarios (nombre, email, contraseña) ' +
    'VALUES (:nombre, :email, :pass)';
  dm_data.FDQuery2.ParamByName('nombre').AsString := Nombre;
  dm_data.FDQuery2.ParamByName('email').AsString  := Email;
  dm_data.FDQuery2.ParamByName('pass').AsString   := Password;
  dm_data.FDQuery2.ExecSQL;
  dm_data.FDQuery2.Close;

  ShowMessage('Usuario registrado. Ya puedes iniciar sesión.');
  paginaRegistro.ActivePage := paginaIniciarSesion;
end;

procedure TForm2.btnIniciarSesionClick(Sender: TObject);
var
  Usuario, Password: String;
begin
  Usuario  := editNombreUsu.Text;
  Password := editPassIni.Text;

  if (Trim(Usuario) = '') or (Trim(Password) = '') then
  begin
    ShowMessage('Rellena todos los campos');
    Exit;
  end;

  dm_data.FDConnection1.Connected := True;
  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text :=
    'SELECT id FROM usuarios WHERE nombre = :nombre AND contraseña = :pass';
  dm_data.FDQuery2.ParamByName('nombre').AsString := Usuario;
  dm_data.FDQuery2.ParamByName('pass').AsString   := Password;
  dm_data.FDQuery2.Open;

  if dm_data.FDQuery2.IsEmpty then
  begin
    ShowMessage('Usuario o contraseña incorrectos');
    dm_data.FDQuery2.Close;
    Exit;
  end;

  dm_data.FDQuery2.Close;

  // Cerrar el modal con éxito
  ModalResult := mrOk;
end;

end.
