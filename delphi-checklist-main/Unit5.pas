unit Unit5;

interface

uses
  Unit3,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Vcl.StdCtrls,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.ExtCtrls, Vcl.Buttons;

type
  TForm5 = class(TForm)
    PageControl1: TPageControl;
    tabUsuarios: TTabSheet;
    tabProyectos: TTabSheet;
    tabListas: TTabSheet;
    tabItems: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    DBNavigator2: TDBNavigator;
    DBGrid2: TDBGrid;
    Label3: TLabel;
    Label4: TLabel;
    DBNavigator3: TDBNavigator;
    DBGrid3: TDBGrid;
    DBNavigator4: TDBNavigator;
    DBGrid4: TDBGrid;
    Label5: TLabel;
    Label6: TLabel;
    DBNavigator5: TDBNavigator;
    DBGrid5: TDBGrid;
    DBNavigator6: TDBNavigator;
    DBGrid6: TDBGrid;
    Label7: TLabel;
    Label8: TLabel;
    DBNavigator7: TDBNavigator;
    DBGrid7: TDBGrid;
    DBNavigator8: TDBNavigator;
    DBGrid8: TDBGrid;
    procedure FormCreate(Sender: TObject);
  private
    // Tab 1: Usuarios → Proyectos
    QUsuarios:    TFDQuery;
    QProyectosU:  TFDQuery;
    DSUsuarios:   TDataSource;
    DSProyectosU: TDataSource;

    // Tab 2: Proyectos → Listas
    QProyectos:   TFDQuery;
    QListasP:     TFDQuery;
    DSProyectos:  TDataSource;
    DSListasP:    TDataSource;

    // Tab 3: Listas → Ítems
    QListas:      TFDQuery;
    QItemsL:      TFDQuery;
    DSListas:     TDataSource;
    DSItemsL:     TDataSource;

    // Tab 4: Ítems → Historial
    QItems:       TFDQuery;
    QHistorialI:  TFDQuery;
    DSItems:      TDataSource;
    DSHistorialI: TDataSource;

    procedure UsuariosCambia(Sender: TObject; Field: TField);
    procedure ProyectosCambia(Sender: TObject; Field: TField);
    procedure ListasCambia(Sender: TObject; Field: TField);
    procedure ItemsCambia(Sender: TObject; Field: TField);
  public
  end;

var
  Form5: TForm5;

implementation

uses Unit4;

{$R *.dfm}

{
  Procedure que recarga los proyectos cuando cambia el usuario seleccionado
}
procedure TForm5.UsuariosCambia(Sender: TObject; Field: TField);
begin
  QProyectosU.Close;
  if QUsuarios.IsEmpty then Exit;
  QProyectosU.ParamByName('id_usuario').AsInteger :=
    QUsuarios.FieldByName('id').AsInteger;
  QProyectosU.Open;
end;

{
  Procedure que recarga las listas cuando cambia el proyecto seleccionado
}
procedure TForm5.ProyectosCambia(Sender: TObject; Field: TField);
begin
  QListasP.Close;
  if QProyectos.IsEmpty then Exit;
  QListasP.ParamByName('id_proyecto').AsInteger :=
    QProyectos.FieldByName('id').AsInteger;
  QListasP.Open;
end;

{
  Procedure que recarga los items cuando cambia la lista seleccionada
}
procedure TForm5.ListasCambia(Sender: TObject; Field: TField);
begin
  QItemsL.Close;
  if QListas.IsEmpty then Exit;
  QItemsL.ParamByName('id_lista').AsInteger :=
    QListas.FieldByName('id').AsInteger;
  QItemsL.Open;
end;

{
  Procedure que recarga el historial cuando cambia el item seleccionado
}
procedure TForm5.ItemsCambia(Sender: TObject; Field: TField);
begin
  QHistorialI.Close;
  if QItems.IsEmpty then Exit;
  QHistorialI.ParamByName('id_item').AsInteger :=
    QItems.FieldByName('id').AsInteger;
  QHistorialI.Open;
end;

{
  Procedure que inicializa los queries, datasources y los conecta a los grids
  al crear el formulario. Se crea bajo demanda desde Unit1 para garantizar
  que la conexion a la base de datos ya esta activa.
  Relaciones maestro/detalle:
    Tab 1: USUARIOS    -> PROYECTO   (un usuario tiene varios proyectos)
    Tab 2: PROYECTO    -> LISTA      (un proyecto tiene varias listas)
    Tab 3: LISTA       -> ITEM       (una lista tiene varios items)
    Tab 4: ITEM        -> HISTORIAL  (un item tiene varios registros de historial)
}
procedure TForm5.FormCreate(Sender: TObject);
begin
  dm_data.FDConnection1.Connected := True;

  // -----------------------------------------------
  // TAB 1: Usuarios (maestro) → Proyectos (detalle)
  // -----------------------------------------------
  QUsuarios := TFDQuery.Create(Self);
  QUsuarios.Connection := dm_data.FDConnection1;
  QUsuarios.SQL.Text := 'SELECT id, nombre, email FROM usuarios ORDER BY id';

  DSUsuarios := TDataSource.Create(Self);
  DSUsuarios.DataSet := QUsuarios;
  DSUsuarios.OnDataChange := UsuariosCambia;

  QProyectosU := TFDQuery.Create(Self);
  QProyectosU.Connection := dm_data.FDConnection1;
  QProyectosU.SQL.Text :=
    'SELECT id, nombre, codigo, descripcion, fecha_creacion ' +
    'FROM proyecto WHERE id_usuario = :id_usuario ORDER BY id';

  DSProyectosU := TDataSource.Create(Self);
  DSProyectosU.DataSet := QProyectosU;

  DBGrid1.DataSource      := DSUsuarios;
  DBNavigator1.DataSource := DSUsuarios;
  DBGrid2.DataSource      := DSProyectosU;
  DBNavigator2.DataSource := DSProyectosU;

  QUsuarios.Open;

  // -----------------------------------------------
  // TAB 2: Proyectos (maestro) → Listas (detalle)
  // -----------------------------------------------
  QProyectos := TFDQuery.Create(Self);
  QProyectos.Connection := dm_data.FDConnection1;
  QProyectos.SQL.Text :=
    'SELECT id, nombre, codigo, descripcion FROM proyecto ORDER BY id';

  DSProyectos := TDataSource.Create(Self);
  DSProyectos.DataSet := QProyectos;
  DSProyectos.OnDataChange := ProyectosCambia;

  QListasP := TFDQuery.Create(Self);
  QListasP.Connection := dm_data.FDConnection1;
  QListasP.SQL.Text :=
    'SELECT id, titulo, descripcion, ES_NOTA, fecha_creacion ' +
    'FROM lista WHERE id_proyecto = :id_proyecto ORDER BY id';

  DSListasP := TDataSource.Create(Self);
  DSListasP.DataSet := QListasP;

  DBGrid3.DataSource      := DSProyectos;
  DBNavigator3.DataSource := DSProyectos;
  DBGrid4.DataSource      := DSListasP;
  DBNavigator4.DataSource := DSListasP;

  QProyectos.Open;

  // -----------------------------------------------
  // TAB 3: Listas (maestro) → Ítems (detalle)
  // -----------------------------------------------
  QListas := TFDQuery.Create(Self);
  QListas.Connection := dm_data.FDConnection1;
  QListas.SQL.Text :=
    'SELECT id, titulo, descripcion, ES_NOTA FROM lista ORDER BY id';

  DSListas := TDataSource.Create(Self);
  DSListas.DataSet := QListas;
  DSListas.OnDataChange := ListasCambia;

  QItemsL := TFDQuery.Create(Self);
  QItemsL.Connection := dm_data.FDConnection1;
  QItemsL.SQL.Text :=
    'SELECT id, texto, completado, orden, fecha_creacion, fecha_completado ' +
    'FROM item WHERE id_lista = :id_lista ORDER BY orden, id';

  DSItemsL := TDataSource.Create(Self);
  DSItemsL.DataSet := QItemsL;

  DBGrid5.DataSource      := DSListas;
  DBNavigator5.DataSource := DSListas;
  DBGrid6.DataSource      := DSItemsL;
  DBNavigator6.DataSource := DSItemsL;

  QListas.Open;

  // -----------------------------------------------
  // TAB 4: Ítems (maestro) → Historial (detalle)
  // -----------------------------------------------
  QItems := TFDQuery.Create(Self);
  QItems.Connection := dm_data.FDConnection1;
  QItems.SQL.Text :=
    'SELECT id, texto, completado FROM item ORDER BY id';

  DSItems := TDataSource.Create(Self);
  DSItems.DataSet := QItems;
  DSItems.OnDataChange := ItemsCambia;

  QHistorialI := TFDQuery.Create(Self);
  QHistorialI.Connection := dm_data.FDConnection1;
  QHistorialI.SQL.Text :=
    'SELECT id, tipo_cambio, dato_anterior, fecha_cambio ' +
    'FROM historial WHERE id_item = :id_item ORDER BY fecha_cambio DESC';

  DSHistorialI := TDataSource.Create(Self);
  DSHistorialI.DataSet := QHistorialI;

  DBGrid7.DataSource      := DSItems;
  DBNavigator7.DataSource := DSItems;
  DBGrid8.DataSource      := DSHistorialI;
  DBNavigator8.DataSource := DSHistorialI;

  QItems.Open;
end;

end.
