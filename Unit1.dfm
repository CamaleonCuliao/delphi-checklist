object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Delphi Checklist'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OnCreate = FormCreate
  TextHeight = 15
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    Indent = 19
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 296
    Top = 8
    Width = 320
    Height = 120
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object MainMenu1: TMainMenu
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 568
    Top = 384
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
      'DriverID=MySQL'
      'Server=localhost'
      'Database=delphi-checklist')
    Left = 40
    Top = 384
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM item')
    Left = 128
    Top = 384
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 208
    Top = 384
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM item WHERE id_lista_padre = :id')
    Left = 128
    Top = 328
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
end
