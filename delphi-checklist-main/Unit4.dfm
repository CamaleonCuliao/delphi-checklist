object Form4: TForm4
  Left = 511
  Top = 187
  BorderStyle = bsSingle
  Caption = 'Form4'
  ClientHeight = 647
  ClientWidth = 1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 204
    Top = 52
    Width = 290
    Height = 53
    Caption = 'PROYECTOS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -53
    Font.Name = 'PMingLiU-ExtB'
    Font.Style = []
    ParentFont = False
  end
  object btnAcceder: TSpeedButton
    Left = 40
    Top = 548
    Width = 393
    Height = 57
    Caption = 'ACCEDER'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI Variable Small'
    Font.Style = []
    ParentFont = False
  end
  object btnBorrarProyect: TSpeedButton
    Left = 472
    Top = 548
    Width = 193
    Height = 57
    Caption = 'BORRAR'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI Variable Small'
    Font.Style = []
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 736
    Top = 149
    Width = 310
    Height = 336
    ActivePage = pageCrearProyect
    TabOrder = 1
    object pageUnirProyec: TTabSheet
      Caption = 'Unete a un Nuevo Proyecto'
      object Label2: TLabel
        Left = 64
        Top = 24
        Width = 178
        Height = 21
        Caption = 'NOMBRE DEL PROYECTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI Emoji'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 64
        Top = 112
        Width = 173
        Height = 21
        Caption = 'CODIGO DEL PROYECTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI Emoji'
        Font.Style = []
        ParentFont = False
      end
      object Panel1: TPanel
        Left = 40
        Top = 198
        Width = 229
        Height = 73
        TabOrder = 0
        object SpeedButton1: TSpeedButton
          Left = -23
          Top = 0
          Width = 276
          Height = 73
          Caption = 'ACCEDER'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI Variable Small'
          Font.Style = []
          ParentFont = False
        end
      end
      object editUnirNombreProyect: TEdit
        Left = 63
        Top = 59
        Width = 177
        Height = 23
        TabOrder = 1
      end
      object editUnirCodigoProyecto: TEdit
        Left = 64
        Top = 147
        Width = 177
        Height = 23
        TabOrder = 2
      end
    end
    object pageCrearProyect: TTabSheet
      Caption = 'Crea tu propio Proyecto'
      ImageIndex = 1
      object Label4: TLabel
        Left = 64
        Top = 12
        Width = 178
        Height = 21
        Caption = 'NOMBRE DEL PROYECTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI Emoji'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 64
        Top = 80
        Width = 173
        Height = 21
        Caption = 'CODIGO DEL PROYECTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI Emoji'
        Font.Style = []
        ParentFont = False
      end
      object TLabel
        Left = 48
        Top = 150
        Width = 212
        Height = 21
        Caption = 'DESCRIPCI'#211'N DEL PROYECTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI Emoji'
        Font.Style = []
        ParentFont = False
      end
      object editcrearNombreProyect: TEdit
        Left = 64
        Top = 39
        Width = 177
        Height = 23
        TabOrder = 0
      end
      object editCrearCodigoProyec: TEdit
        Left = 64
        Top = 107
        Width = 177
        Height = 23
        TabOrder = 1
      end
      object Panel2: TPanel
        Left = 56
        Top = 262
        Width = 193
        Height = 41
        TabOrder = 2
        object btnCrearProyect: TSpeedButton
          Left = -16
          Top = 0
          Width = 217
          Height = 41
          Caption = 'CREAR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -27
          Font.Name = 'Segoe UI Variable Small'
          Font.Style = []
          ParentFont = False
        end
      end
      object memoCrearDescripProyect: TMemo
        Left = 48
        Top = 177
        Width = 209
        Height = 79
        TabOrder = 3
      end
    end
  end
  object DBGrid1: TDBGrid
    Left = 32
    Top = 120
    Width = 641
    Height = 408
    DataSource = dm_data.DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
end
