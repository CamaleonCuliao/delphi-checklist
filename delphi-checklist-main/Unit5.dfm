object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Visor de datos'
  ClientHeight = 650
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1000
    Height = 650
    ActivePage = tabUsuarios
    Align = alClient
    TabOrder = 0
    object tabUsuarios: TTabSheet
      Caption = 'Usuarios / Proyectos'
      object Label1: TLabel
        Left = 5
        Top = 5
        Width = 61
        Height = 15
        Caption = 'USUARIOS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 5
        Top = 280
        Width = 204
        Height = 15
        Caption = 'PROYECTOS del usuario seleccionado'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBNavigator1: TDBNavigator
        Left = 5
        Top = 26
        Width = 260
        Height = 25
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 5
        Top = 55
        Width = 980
        Height = 220
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
      object DBNavigator2: TDBNavigator
        Left = 5
        Top = 302
        Width = 260
        Height = 25
        TabOrder = 2
      end
      object DBGrid2: TDBGrid
        Left = 5
        Top = 330
        Width = 980
        Height = 270
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object tabProyectos: TTabSheet
      Caption = 'Proyectos / Listas'
      object Label3: TLabel
        Left = 5
        Top = 5
        Width = 67
        Height = 15
        Caption = 'PROYECTOS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 5
        Top = 280
        Width = 185
        Height = 15
        Caption = 'LISTAS del proyecto seleccionado'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBNavigator3: TDBNavigator
        Left = 5
        Top = 26
        Width = 260
        Height = 25
        TabOrder = 0
      end
      object DBGrid3: TDBGrid
        Left = 5
        Top = 55
        Width = 980
        Height = 220
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
      object DBNavigator4: TDBNavigator
        Left = 5
        Top = 302
        Width = 260
        Height = 25
        TabOrder = 2
      end
      object DBGrid4: TDBGrid
        Left = 5
        Top = 330
        Width = 980
        Height = 270
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object tabListas: TTabSheet
      Caption = 'Listas / '#205'tems'
      object Label5: TLabel
        Left = 5
        Top = 5
        Width = 38
        Height = 15
        Caption = 'LISTAS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 5
        Top = 280
        Width = 162
        Height = 15
        Caption = #205'TEMS de la lista seleccionada'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBNavigator5: TDBNavigator
        Left = 5
        Top = 26
        Width = 260
        Height = 25
        TabOrder = 0
      end
      object DBGrid5: TDBGrid
        Left = 5
        Top = 55
        Width = 980
        Height = 220
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
      object DBNavigator6: TDBNavigator
        Left = 5
        Top = 302
        Width = 260
        Height = 25
        TabOrder = 2
      end
      object DBGrid6: TDBGrid
        Left = 5
        Top = 330
        Width = 980
        Height = 270
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object tabItems: TTabSheet
      Caption = #205'tems / Historial'
      object Label7: TLabel
        Left = 5
        Top = 5
        Width = 35
        Height = 15
        Caption = #205'TEMS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 5
        Top = 280
        Width = 185
        Height = 15
        Caption = 'HISTORIAL del '#237'tem seleccionado'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBNavigator7: TDBNavigator
        Left = 5
        Top = 26
        Width = 260
        Height = 25
        TabOrder = 0
      end
      object DBGrid7: TDBGrid
        Left = 5
        Top = 55
        Width = 980
        Height = 220
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
      object DBNavigator8: TDBNavigator
        Left = 5
        Top = 302
        Width = 260
        Height = 25
        TabOrder = 2
      end
      object DBGrid8: TDBGrid
        Left = 5
        Top = 330
        Width = 980
        Height = 270
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
  end
end
