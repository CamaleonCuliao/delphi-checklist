unit Unit4;

interface

uses
  Unit3, System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.Buttons, Vcl.ComCtrls;

type
  TForm4 = class(TForm)
    DBGrid1: TDBGrid;
    Label1: TLabel;
    btnAcceder: TSpeedButton;
    PageControl1: TPageControl;
    pageUnirProyec: TTabSheet;
    pageCrearProyect: TTabSheet;
    Panel1: TPanel;
    btnUnirAcceder: TSpeedButton;
    Label2: TLabel;
    editUnirNombreProyect: TEdit;
    Label3: TLabel;
    editUnirCodigoProyecto: TEdit;
    btnBorrarProyect: TSpeedButton;
    Label4: TLabel;
    editcrearNombreProyect: TEdit;
    Label5: TLabel;
    editCrearCodigoProyec: TEdit;
    Panel2: TPanel;
    btnCrearProyect: TSpeedButton;
    memoCrearDescripProyect: TMemo;

    procedure FormCreate(Sender: TObject);
    procedure btnCrearProyectoClick(Sender: TObject);
    procedure btnUnirAccederClick(Sender: TObject);
    procedure btnAccederClick(Sender: TObject);
    procedure btnBorrarProyectClick(Sender: TObject);
  private
    procedure CargarProyectos;
  public
  end;

var
  Form4: TForm4;
  IdProyectoActual: Integer = 0;

implementation

{$R *.dfm}

procedure TForm4.CargarProyectos;
begin
  dm_data.FDQuery6.Close;
  dm_data.FDQuery6.SQL.Text := 'SELECT p.id, p.nombre, p.descripcion ' +
    'FROM proyecto p ' +
    'INNER JOIN usuario_proyecto up ON p.id = up.id_proyecto ' +
    'WHERE up.id_usuario = :id_usuario';
  dm_data.FDQuery6.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery6.Open;

  DBGrid1.DataSource := dm_data.DataSource1;

  DBGrid1.Columns[0].FieldName := 'nombre';
  DBGrid1.Columns[1].FieldName := 'descripcion';

end;

procedure TForm4.FormCreate(Sender: TObject);
begin

  DBGrid1.Options := DBGrid1.Options - [dgEditing];

  CargarProyectos;

end;

procedure TForm4.btnBorrarProyectClick(Sender: TObject);
var
  idProyecto: Integer;
  totalUsuarios: Integer;
begin
  // 1. Verificar que hay un proyecto seleccionado
  if dm_data.FDQuery6.IsEmpty then
  begin
    ShowMessage('Selecciona un proyecto del listado primero');
    Exit;
  end;

  // 2. Obtener el ID del proyecto seleccionado en el grid
  idProyecto := dm_data.FDQuery6.FieldByName('id').AsInteger;

  // 3. Contar cuántos usuarios tiene el proyecto
  dm_data.FDQuery6.Close;
  dm_data.FDQuery6.SQL.Text := 'SELECT COUNT(*) AS total_usuarios ' +
    'FROM usuario_proyecto ' + 'WHERE id_proyecto = :idp';
  dm_data.FDQuery6.ParamByName('idp').AsInteger := idProyecto;
  dm_data.FDQuery6.Open;

  totalUsuarios := dm_data.FDQuery6.FieldByName('total_usuarios').AsInteger;
  dm_data.FDQuery6.Close;

  // 4. Si solo hay un usuario → borrar proyecto entero
  if totalUsuarios = 1 then
  begin
    dm_data.FDQuery6.SQL.Text := 'DELETE FROM proyecto WHERE id = :idp';
    dm_data.FDQuery6.ParamByName('idp').AsInteger := idProyecto;
    dm_data.FDQuery6.ExecSQL;

    ShowMessage('Proyecto eliminado completamente.');
  end
  else
  begin
    // 5. Si hay más usuarios → borrar solo la relación del usuario actual
    dm_data.FDQuery6.SQL.Text := 'DELETE FROM usuario_proyecto ' +
      'WHERE id_usuario = :idu AND id_proyecto = :idp';
    dm_data.FDQuery6.ParamByName('idu').AsInteger := IdUsuarioActual;
    dm_data.FDQuery6.ParamByName('idp').AsInteger := idProyecto;
    dm_data.FDQuery6.ExecSQL;

    ShowMessage('Has salido del proyecto, pero este sigue existiendo.');
  end;

  // 6. Recargar el grid
  CargarProyectos;
end;

{
  Procedure que crea un nuevo proyecto y añade al usuario como administrador
  - Valida que nombre y código no estén vacíos
  - Añade al usuario actual como admin en usuario_proyecto
  - Recarga el grid con los proyectos actualizados
}

procedure TForm4.btnCrearProyectoClick(Sender: TObject);
var
  Nombre, Codigo, Descripcion: String;
begin
  Nombre := editcrearNombreProyect.Text;
  Codigo := editCrearCodigoProyec.Text;
  Descripcion := memoCrearDescripProyect.Text;

  if (Trim(Nombre) = '') or (Trim(Codigo) = '') then
  begin
    ShowMessage('Nombre y código son obligatorios');
    Exit;
  end;

  // Insertar el proyecto
  dm_data.FDQuery6.Close;
  dm_data.FDQuery6.SQL.Text :=
    'INSERT INTO proyecto (id_usuario, nombre, codigo, descripcion) ' +
    'VALUES (:id_usuario, :nombre, :codigo, :descripcion)';
  dm_data.FDQuery6.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery6.ParamByName('nombre').AsString := Nombre;
  dm_data.FDQuery6.ParamByName('codigo').AsString := Codigo;
  dm_data.FDQuery6.ParamByName('descripcion').AsString := Descripcion;
  dm_data.FDQuery6.ExecSQL;

  // Añadir al creador como admin en usuario_proyecto
  dm_data.FDQuery6.SQL.Text :=
    'INSERT INTO usuario_proyecto (id_usuario, id_proyecto, rol) ' +
    'VALUES (:id_usuario, LAST_INSERT_ID(), ''admin'')';
  dm_data.FDQuery6.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery6.ExecSQL;
  dm_data.FDQuery6.Close;

  ShowMessage('Proyecto "' + Nombre + '" creado correctamente');

  // Limpiar campos
  editcrearNombreProyect.Text := '';
  editCrearCodigoProyec.Text := '';
  memoCrearDescripProyect.Text := '';

  CargarProyectos;
end;

{
  Procedure que une al usuario actual a un proyecto mediante su códig
  - Valida que el código no esté vacío
  - Busca el proyecto por código en la BD
  - Comprueba que el proyecto existe
  - Inserta la relación en usuario_proyecto como miembro
  - Recarga el grid con los proyectos actualizados
}
procedure TForm4.btnUnirAccederClick(Sender: TObject);
var
  Codigo: String;
  idProyecto: Integer;
begin
  Codigo := editUnirCodigoProyecto.Text;

  if Trim(Codigo) = '' then
  begin
    ShowMessage('Introduce el código del proyecto');
    Exit;
  end;

  // Buscar proyecto por código
  dm_data.FDQuery6.Close;
  dm_data.FDQuery6.SQL.Text := 'SELECT id FROM proyecto WHERE codigo = :codigo';
  dm_data.FDQuery6.ParamByName('codigo').AsString := Codigo;
  dm_data.FDQuery6.Open;

  if dm_data.FDQuery6.IsEmpty then
  begin
    ShowMessage('Código de proyecto no encontrado');
    dm_data.FDQuery6.Close;
    CargarProyectos;
    Exit;
  end;

  idProyecto := dm_data.FDQuery6.FieldByName('id').AsInteger;
  dm_data.FDQuery6.Close;

  // Unirse como miembro (INSERT IGNORE evita duplicados)
  dm_data.FDQuery6.SQL.Text :=
    'INSERT IGNORE INTO usuario_proyecto (id_usuario, id_proyecto, rol) ' +
    'VALUES (:id_usuario, :id_proyecto, ''miembro'')';
  dm_data.FDQuery6.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery6.ParamByName('id_proyecto').AsInteger := idProyecto;
  dm_data.FDQuery6.ExecSQL;
  dm_data.FDQuery6.Close;

  ShowMessage('Te has unido al proyecto correctamente');

  // Limpiar campo
  editUnirCodigoProyecto.Text := '';

  CargarProyectos;
end;

{
  Procedure para abrir el proyecto seleccionado en el grid
}
procedure TForm4.btnAccederClick(Sender: TObject);
begin
  if dm_data.FDQuery6.IsEmpty then
  begin
    ShowMessage('Selecciona un proyecto del listado primero');
    Exit;
  end;

  // Necesitamos el id del proyecto, añadirlo a la query de CargarProyectos
  IdProyectoActual := dm_data.FDQuery6.FieldByName('id').AsInteger;
  ModalResult := mrOk;
end;

end.
