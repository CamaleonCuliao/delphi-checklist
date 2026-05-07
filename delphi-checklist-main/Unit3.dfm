object dm_data: Tdm_data
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=admindelphi'
      'Server=delphipauborja.fabricomiweb.com'
      'Database=delphiBDPauBorja'
      'Password=#fvS9aCQe9x_5gdk'
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
    DataSet = FDQuery6
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
  object FDQuery4: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      '')
    Left = 280
    Top = 96
  end
  object FDQuery5: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      '')
    Left = 352
    Top = 96
  end
  object FDQuery6: TFDQuery
    Connection = FDConnection1
    Left = 424
    Top = 96
  end
  object FDQuery7: TFDQuery
    Connection = FDConnection1
    Left = 496
    Top = 96
  end
  object DataSource2: TDataSource
    DataSet = FDQuery7
    Left = 136
    Top = 176
  end
  object FDQuery8: TFDQuery
    Connection = FDConnection1
    Left = 568
    Top = 96
  end
  object FDQueryAux: TFDQuery
    Connection = FDConnection1
    Left = 504
    Top = 216
  end
end
