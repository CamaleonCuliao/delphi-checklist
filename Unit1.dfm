object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Delphi Checklist'
  ClientHeight = 688
  ClientWidth = 1132
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OnCreate = FormCreate
  TextHeight = 15
  object anadir: TSpeedButton
    Left = 712
    Top = 264
    Width = 320
    Height = 33
    Caption = 'A'#241'adir'
  end
  object eliminar: TSpeedButton
    Left = 712
    Top = 360
    Width = 320
    Height = 33
    Caption = 'Eliminar'
  end
  object DBGrid1: TDBGrid
    Left = 712
    Top = 64
    Width = 320
    Height = 120
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 625
    Height = 657
    Caption = 'Panel1'
    Color = clBackground
    ParentBackground = False
    TabOrder = 1
    object TreeView1: TTreeView
      Left = 8
      Top = 16
      Width = 609
      Height = 625
      Indent = 19
      TabOrder = 0
    end
  end
  object crearlista: TBitBtn
    Left = 712
    Top = 24
    Width = 121
    Height = 25
    Caption = 'Crear Lista'
    TabOrder = 2
  end
  object borrarLista: TBitBtn
    Left = 839
    Top = 24
    Width = 121
    Height = 25
    Caption = 'Borrar Lista'
    TabOrder = 3
  end
  object MainMenu1: TMainMenu
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 880
    Top = 472
    object f1: TMenuItem
      Caption = 'API'
    end
    object dwaf1: TMenuItem
      Caption = 'Frontend'
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Server=localhost'
      'Database=checklistdelphi'
      'DriverID=MySQL')
    Left = 728
    Top = 544
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM item')
    Left = 816
    Top = 544
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 896
    Top = 544
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM item WHERE id_lista_padre = :id')
    Left = 816
    Top = 488
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
end
