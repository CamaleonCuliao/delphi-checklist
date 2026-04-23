object dm_data: Tdm_data
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Server=localhost'
      'Database=checklistdelphi'
      'DriverID=MySQL')
    Left = 56
    Top = 24
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM item')
    Left = 56
    Top = 96
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM item WHERE id_lista_padre = :id')
    Left = 136
    Top = 96
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 56
    Top = 176
  end
  object FDQuery3: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM lista')
    Left = 208
    Top = 96
  end
end
