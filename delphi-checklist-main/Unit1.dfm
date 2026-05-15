object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Delphi Checklist'
  ClientHeight = 688
  ClientWidth = 1299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  Menu = MainMenu1
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object btnAbrirProyects: TSpeedButton
    Left = 1232
    Top = 8
    Width = 49
    Height = 44
    Caption = #55357#56513
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = btnAbrirProyectsClick
  end
  object btnRecargar: TSpeedButton
    Left = 817
    Top = 27
    Width = 100
    Height = 25
    Caption = #55357#56580' Recargar'
    OnClick = btnRecargarClick
  end
  object LblNotas: TLabel
    Left = 16
    Top = 506
    Width = 105
    Height = 15
    Caption = 'Notas del proyecto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnVisorDatos: TSpeedButton
    Left = 1168
    Top = 8
    Width = 58
    Height = 44
    Caption = 'Ver datos'
    OnClick = btnVisorDatosClick
  end
  object LblUsuarios: TLabel
    Left = 680
    Top = 406
    Width = 120
    Height = 15
    Caption = 'Usuarios del proyecto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 680
    Top = 58
    Width = 611
    Height = 319
    DataSource = dm_data.DataSource2
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        Width = 119
        Visible = True
      end
      item
        Expanded = False
        Width = 89
        Visible = True
      end
      item
        Expanded = False
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        Width = 107
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 625
    Height = 494
    Caption = 'Panel1'
    Color = clBackground
    ParentBackground = False
    TabOrder = 2
    object TreeView1: TTreeView
      Left = 8
      Top = 8
      Width = 609
      Height = 466
      Indent = 19
      PopupMenu = PopupMenu1
      TabOrder = 0
    end
  end
  object ToggleSwitch1: TToggleSwitch
    Left = 680
    Top = 32
    Width = 131
    Height = 20
    StateCaptions.CaptionOn = 'Claro Activo'
    StateCaptions.CaptionOff = 'Oscuro Activo'
    TabOrder = 3
    OnClick = ToggleSwitch1Click
  end
  object MemoNotas: TMemo
    Left = 16
    Top = 526
    Width = 609
    Height = 130
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object DBGrid2: TDBGrid
    Left = 680
    Top = 424
    Width = 611
    Height = 232
    DataSource = dm_data.DataSource3
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Nombre'
        Title.Caption = 'Usuario'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Email'
        Width = 290
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Rol'
        Width = 120
        Visible = True
      end>
  end
  object MainMenu1: TMainMenu
    Left = 944
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 976
    Top = 16
    object pmAnadir: TMenuItem
      Caption = 'A'#241'adir'
    end
    object pmEliminar: TMenuItem
      Caption = 'Eliminar'
    end
    object pmRenombrar: TMenuItem
      Caption = 'Renombrar'
    end
  end
end
