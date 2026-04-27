object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Autenticaci'#243'n Usuario'
  ClientHeight = 575
  ClientWidth = 849
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Contenido: TCardPanel
    Left = 0
    Top = 0
    Width = 849
    Height = 575
    Align = alClient
    ActiveCard = InicioSesion
    BevelOuter = bvNone
    Caption = 'Contenido'
    TabOrder = 0
    object InicioSesion: TCard
      Left = 0
      Top = 0
      Width = 849
      Height = 575
      Caption = 'InicioSesion'
      CardIndex = 0
      TabOrder = 0
      object SpeedButton1: TSpeedButton
        Left = 32
        Top = 8
        Width = 23
        Height = 22
      end
      object paginaRegistro: TPageControl
        Left = 0
        Top = 0
        Width = 849
        Height = 575
        ActivePage = paginaIniciarSesion
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Variable Small'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object paginaIniciarSesion: TTabSheet
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = 'Iniciar Sesi'#243'n'
          object Label1: TLabel
            Left = 286
            Top = 152
            Width = 268
            Height = 27
            Caption = 'NOMBRE DE USUARIO'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'PMingLiU-ExtB'
            Font.Style = []
            ParentFont = False
          end
          object Label2: TLabel
            Left = 335
            Top = 272
            Width = 171
            Height = 27
            Caption = 'CONTRASE'#209'A'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'PMingLiU-ExtB'
            Font.Style = []
            ParentFont = False
          end
          object btnPassword: TSpeedButton
            Left = 568
            Top = 312
            Width = 33
            Height = 29
            OnClick = btnPasswordClick
          end
          object btnIniciarSesion: TSpeedButton
            Left = 291
            Top = 448
            Width = 276
            Height = 57
            Caption = 'INICIAR SESI'#211'N'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI Variable Small'
            Font.Style = []
            ParentFont = False
            OnClick = btnIniciarSesionClick
          end
          object editNombreUsu: TEdit
            Left = 296
            Top = 192
            Width = 249
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TextHint = 'User123'
          end
          object editPassIni: TEdit
            Left = 296
            Top = 312
            Width = 249
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TextHint = 'Password'
          end
        end
        object paginaRegistrar: TTabSheet
          Caption = 'Registrar'
          ImageIndex = 1
          object Label3: TLabel
            Left = 294
            Top = 112
            Width = 268
            Height = 27
            Caption = 'NOMBRE DE USUARIO'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'PMingLiU-ExtB'
            Font.Style = []
            ParentFont = False
          end
          object Label4: TLabel
            Left = 343
            Top = 327
            Width = 171
            Height = 27
            Caption = 'CONTRASE'#209'A'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'PMingLiU-ExtB'
            Font.Style = []
            ParentFont = False
          end
          object Label5: TLabel
            Left = 294
            Top = 224
            Width = 270
            Height = 27
            Caption = 'COREO ELECTR'#211'NICO'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'PMingLiU-ExtB'
            Font.Style = []
            ParentFont = False
          end
          object btnPasswordReg: TSpeedButton
            Left = 568
            Top = 360
            Width = 33
            Height = 29
            OnClick = btnPasswordRegClick
          end
          object btnRegistrar: TSpeedButton
            Left = 283
            Top = 440
            Width = 276
            Height = 57
            Caption = 'REGISTRAR'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI Variable Small'
            Font.Style = []
            ParentFont = False
            OnClick = btnRegistrarClick
          end
          object editPasswordReg: TEdit
            Left = 304
            Top = 360
            Width = 249
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TextHint = 'Password'
          end
          object editUsuReg: TEdit
            Left = 304
            Top = 152
            Width = 249
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TextHint = 'User123'
          end
          object editEmailReg: TEdit
            Left = 304
            Top = 265
            Width = 249
            Height = 29
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            TextHint = 'usuario1@gmail.com'
          end
        end
      end
    end
    object Registro: TCard
      Left = 0
      Top = 0
      Width = 849
      Height = 575
      Caption = 'Registro'
      CardIndex = 1
      TabOrder = 1
    end
    object App: TCard
      Left = 0
      Top = 0
      Width = 849
      Height = 575
      Caption = 'App'
      CardIndex = 2
      TabOrder = 2
    end
  end
end
