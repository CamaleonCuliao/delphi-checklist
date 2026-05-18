unit Unit1;

interface

uses
  Unit3, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ComCtrls,
  Vcl.Menus, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.DataSet, Vcl.ExtCtrls, Vcl.Buttons, Vcl.WinXCtrls,
  Vcl.Themes, System.UITypes, System.ImageList, Vcl.ImgList,
  System.Generics.Collections, System.Hash;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    TreeView1: TTreeView;
    ToggleSwitch1: TToggleSwitch;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    pmAnadir: TMenuItem;
    pmEliminar: TMenuItem;
    pmRenombrar: TMenuItem;
    btnAbrirProyects: TSpeedButton;
    btnRecargar: TSpeedButton;
    MemoNotas: TMemo;
    LblNotas: TLabel;
    btnVisorDatos: TSpeedButton;
    DBGrid2: TDBGrid;
    LblUsuarios: TLabel;
    btnCambiarCodigo: TSpeedButton;
    PopupMenu2: TPopupMenu;
    pmExpulsar: TMenuItem;

    procedure AbrirListaClick(Sender: TObject);
    procedure mostrarListasCreadas(SubMenuItem: TMenuItem);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToggleSwitch1Click(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure pmAnadirClick(Sender: TObject);
    procedure pmEliminarClick(Sender: TObject);
    procedure pmRenombrarClick(Sender: TObject);
    procedure insertarNuevaLista(Sender: TObject);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure borrarListaFunction(Sender: TObject);
    procedure RegistrarHistorial(IdItem: Integer; TipoCambio: String;
      DatoAnterior: String);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure btnAbrirProyectsClick(Sender: TObject);
    procedure btnRecargarClick(Sender: TObject);
    procedure CargarNotasProyecto;
    procedure insertarNuevaNota(Sender: TObject);
    procedure borrarNota(Sender: TObject);
    procedure btnVisorDatosClick(Sender: TObject);
    procedure CargarUsuariosProyecto;
    procedure btnCambiarCodigoClick(Sender: TObject);
    procedure pmExpulsarClick(Sender: TObject);

  private
    NodoSeleccionado: TTreeNode;
    NodoArrastrado: TTreeNode;
    TituloListaActual: String;
    EsNotaActual: Boolean;
    FItemVersions: TDictionary<Integer, Integer>;
    procedure MarcarHijosRecursivo(Nodo: TTreeNode; Marcado: Boolean;
      Query: TFDQuery; Forzar: Boolean = False);
    procedure RecargarListaActual;
    procedure ActualizarVersionItem(IdItem: Integer; NuevaVersion: Integer);
    function ObtenerUltimoCambio(IdItem: Integer; out Usuario, Accion: string;
      out Fecha: TDateTime): Boolean;
    function HashMD5(const s: String): String;
  public
    procedure RecargarMenuListas;
    procedure insertarLista(nombre: String);
    procedure CargarHistorial;
  end;

var
  Form1: TForm1;
  UltimoNombreLista: string;

implementation

uses
  Unit2, Unit4, Unit5;

{$R *.dfm}

{
  Procedure de inicializacion del formulario principal
  - Establece la conexion con la base de datos
  - Inicializa el diccionario de versiones para el control de concurrencia
  - Configura el TreeView con sus eventos y modo drag & drop
  - Construye el menu de Listas dinamicamente
  - Configura el DBGrid del historial con sus columnas
}

function TForm1.HashMD5(const s: String): String;
begin
  Result := THashMD5.GetHashString(s);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  MenuItem: TMenuItem;
  SubMenuItem: TMenuItem;
begin
  Self.Menu := MainMenu1;
  dm_data.FDConnection1.Connected := True;
  WindowState := wsMaximized;

  FItemVersions := TDictionary<Integer, Integer>.Create;

  TreeView1.OnClick := TreeViewClick;
  TreeView1.OnMouseDown := TreeViewMouseDown;
  TreeView1.PopupMenu := PopupMenu1;
  pmAnadir.OnClick := pmAnadirClick;
  pmEliminar.OnClick := pmEliminarClick;
  pmRenombrar.OnClick := pmRenombrarClick;
  NodoSeleccionado := nil;
  NodoArrastrado := nil;
  TreeView1.DragMode := dmAutomatic;
  TreeView1.OnDragOver := TreeView1DragOver;
  TreeView1.OnDragDrop := TreeView1DragDrop;

  DBGrid1.Options := DBGrid1.Options - [dgEditing];

  MenuItem := TMenuItem.Create(MainMenu1);
  MenuItem.Caption := 'Listas';
  MainMenu1.Items.Add(MenuItem);

  SubMenuItem := TMenuItem.Create(MainMenu1);
  SubMenuItem.Caption := 'Crear lista';
  SubMenuItem.OnClick := insertarNuevaLista;
  MenuItem.Add(SubMenuItem);

  SubMenuItem := TMenuItem.Create(MainMenu1);
  SubMenuItem.Caption := 'Borrar lista';
  SubMenuItem.OnClick := borrarListaFunction;
  MenuItem.Add(SubMenuItem);

  SubMenuItem := TMenuItem.Create(MainMenu1);
  SubMenuItem.Caption := 'Abrir...';
  SubMenuItem.Name := 'mnuAbrir';
  MenuItem.Add(SubMenuItem);

  SubMenuItem := TMenuItem.Create(MainMenu1);
  SubMenuItem.Caption := 'Crear nota';
  SubMenuItem.OnClick := insertarNuevaNota;
  MenuItem.Add(SubMenuItem);

  SubMenuItem := TMenuItem.Create(MainMenu1);
  SubMenuItem.Caption := 'Borrar nota';
  SubMenuItem.OnClick := borrarNota;
  MenuItem.Add(SubMenuItem);

  TreeView1.OnChange := TreeView1Change;

  DBGrid1.DataSource := dm_data.DataSource2;
  dm_data.DataSource2.DataSet := dm_data.FDQuery7;

  DBGrid1.Columns.Clear;
  with DBGrid1.Columns.Add do
  begin
    FieldName := 'item';
    Title.Caption := 'Ítem';
    Width := 150;
  end;
  with DBGrid1.Columns.Add do
  begin
    FieldName := 'tipo_cambio';
    Title.Caption := 'Tipo Cambio';
    Width := 100;
  end;
  with DBGrid1.Columns.Add do
  begin
    FieldName := 'dato_anterior';
    Title.Caption := 'Dato Anterior';
    Width := 90;
  end;
  with DBGrid1.Columns.Add do
  begin
    FieldName := 'usuario';
    Title.Caption := 'Usuario';
    Width := 100;
  end;
  with DBGrid1.Columns.Add do
  begin
    FieldName := 'fecha_cambio';
    Title.Caption := 'Fecha';
    Width := 125;
  end;
end;

{
  Procedure que libera los recursos al cerrar el formulario
  - Destruye el diccionario de versiones para evitar fugas de memoria
}
procedure TForm1.FormDestroy(Sender: TObject);
begin
  FItemVersions.Free;
end;

{
  Procedure que carga una lista del proyecto activo en el TreeView
  - Si el nombre esta vacio carga la primera lista disponible del proyecto
  - Consulta todos los items de la lista ordenados por jerarquia
  - Reconstruye el arbol de nodos con sus checkboxes y versiones
  - Al terminar recarga las notas y el historial
}
procedure TForm1.insertarLista(nombre: String);
var
  NodoPadre, NodoHijo: TTreeNode;
  IdPadre: Integer;
  i: Integer;
  id_lista: Integer;
begin
  dm_data.FDConnection1.Connected := True;
  TreeView1.CheckBoxes := True;

  TreeView1.Items.Clear;
  FItemVersions.Clear;

  dm_data.FDQuery4.Close;
  if Trim(nombre) = '' then
  begin
    dm_data.FDQuery4.SQL.Text := 'SELECT id FROM lista WHERE id_proyecto = :id_proyecto AND ES_NOTA = 0 LIMIT 1';
    dm_data.FDQuery4.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  end
  else
  begin
    dm_data.FDQuery4.SQL.Text := 'SELECT id FROM lista WHERE id_proyecto = :id_proyecto AND titulo = :titulo AND ES_NOTA = 0';
    dm_data.FDQuery4.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
    dm_data.FDQuery4.ParamByName('titulo').AsString := Trim(nombre);
  end;
  dm_data.FDQuery4.Open;

  if dm_data.FDQuery4.IsEmpty then
  begin
    dm_data.FDQuery4.Close;
    Exit;
  end;

  id_lista := dm_data.FDQuery4.FieldByName('id').AsInteger;
  IdListaActual := id_lista;
  TituloListaActual := Trim(nombre);
  dm_data.FDQuery4.Close;

  dm_data.FDQuery1.Close;
  dm_data.FDQuery1.SQL.Text := 'SELECT * FROM item ' +
    'WHERE id_lista = :id_lista ' +
    'ORDER BY ISNULL(id_item_padre) DESC, id ASC';
  dm_data.FDQuery1.ParamByName('id_lista').AsInteger := id_lista;
  dm_data.FDQuery1.Open;

  while not dm_data.FDQuery1.EOF do
  begin
    if dm_data.FDQuery1.FieldByName('id_item_padre').IsNull then
    begin
      NodoPadre := TreeView1.Items.Add(nil,
        dm_data.FDQuery1.FieldByName('texto').AsString);
      NodoPadre.Checked := dm_data.FDQuery1.FieldByName('completado').AsBoolean;
      NodoPadre.Data := Pointer(dm_data.FDQuery1.FieldByName('id').AsInteger);
      FItemVersions.Add(dm_data.FDQuery1.FieldByName('id').AsInteger,
        dm_data.FDQuery1.FieldByName('version').AsInteger);
    end
    else
    begin
      IdPadre := dm_data.FDQuery1.FieldByName('id_item_padre').AsInteger;
      NodoPadre := nil;

      for i := 0 to TreeView1.Items.Count - 1 do
      begin
        if Integer(TreeView1.Items[i].Data) = IdPadre then
        begin
          NodoPadre := TreeView1.Items[i];
          Break;
        end;
      end;

      if NodoPadre <> nil then
        NodoHijo := TreeView1.Items.AddChild(NodoPadre,
          dm_data.FDQuery1.FieldByName('texto').AsString)
      else
        NodoHijo := TreeView1.Items.Add(nil,
          dm_data.FDQuery1.FieldByName('texto').AsString);

      NodoHijo.Checked := dm_data.FDQuery1.FieldByName('completado').AsBoolean;
      NodoHijo.Data := Pointer(dm_data.FDQuery1.FieldByName('id').AsInteger);
      FItemVersions.Add(dm_data.FDQuery1.FieldByName('id').AsInteger,
        dm_data.FDQuery1.FieldByName('version').AsInteger);
    end;

    dm_data.FDQuery1.Next;
  end;

  dm_data.FDQuery1.Close;
  TreeView1.FullExpand;
  CargarNotasProyecto;
  CargarUsuariosProyecto;
  CargarHistorial;
end;

{
  Funcion que obtiene el ultimo cambio registrado en el historial para un item
  - Consulta el historial ordenado por fecha descendente
  - Devuelve el nombre del usuario, la accion realizada y la fecha
  - Retorna True si encontro datos, False si el item no tiene historial
}
function TForm1.ObtenerUltimoCambio(IdItem: Integer;
  out Usuario, Accion: string; out Fecha: TDateTime): Boolean;
begin
  Result := False;
  Usuario := '';
  Accion := '';
  Fecha := 0;
  dm_data.FDQueryAux.Close;
  dm_data.FDQueryAux.SQL.Text :=
    'SELECT u.nombre, h.tipo_cambio, h.fecha_cambio ' + 'FROM historial h ' +
    'JOIN usuarios u ON h.id_usuario = u.id ' + 'WHERE h.id_item = :id_item ' +
    'ORDER BY h.fecha_cambio DESC LIMIT 1';
  dm_data.FDQueryAux.ParamByName('id_item').AsInteger := IdItem;
  dm_data.FDQueryAux.Open;
  if not dm_data.FDQueryAux.IsEmpty then
  begin
    Usuario := dm_data.FDQueryAux.FieldByName('nombre').AsString;
    Accion := dm_data.FDQueryAux.FieldByName('tipo_cambio').AsString;
    Fecha := dm_data.FDQueryAux.FieldByName('fecha_cambio').AsDateTime;
    Result := True;
  end;
  dm_data.FDQueryAux.Close;
end;

{
  Procedure recursiva que marca o desmarca un nodo y todos sus hijos
  - Comprueba la version del item antes de actualizar (control de concurrencia)
  - Si Forzar es False: usa WHERE version = old_version para detectar conflictos
  - Si Forzar es True: actualiza sin comprobar version (el usuario ha confirmado)
  - Si RowsAffected = 0 sin forzar lanza una excepcion de conflicto de version
  - Actualiza la version local en FItemVersions tras cada escritura exitosa
  - Se llama recursivamente sobre todos los hijos del nodo
}
procedure TForm1.MarcarHijosRecursivo(Nodo: TTreeNode; Marcado: Boolean;
  Query: TFDQuery; Forzar: Boolean = False);
var
  Hijo: TTreeNode;
  OldVersion: Integer;
begin
  if not Forzar then
    OldVersion := FItemVersions[Integer(Nodo.Data)];

  Nodo.Checked := Marcado;

  if Forzar then
  begin
    Query.Close;
    Query.SQL.Text := 'UPDATE item SET ' + 'completado = :completado, ' +
      'fecha_completado = :fecha, ' + 'version = version + 1 ' +
      'WHERE id = :id';
  end
  else
  begin
    Query.Close;
    Query.SQL.Text := 'UPDATE item SET ' + 'completado = :completado, ' +
      'fecha_completado = :fecha, ' + 'version = version + 1 ' +
      'WHERE id = :id AND version = :old_version';
    Query.ParamByName('old_version').AsInteger := OldVersion;
  end;

  Query.ParamByName('completado').AsBoolean := Marcado;
  if Marcado then
    Query.ParamByName('fecha').AsDateTime := Now
  else
    Query.ParamByName('fecha').Clear;
  Query.ParamByName('id').AsInteger := Integer(Nodo.Data);
  Query.ExecSQL;

  if (Query.RowsAffected = 0) and (not Forzar) then
    raise Exception.Create('Conflicto de versión en item ' +
      IntToStr(Integer(Nodo.Data)));

  if Forzar and (Query.RowsAffected = 0) then
    raise Exception.Create('El item ' + IntToStr(Integer(Nodo.Data)) +
      ' ha sido eliminado por otro usuario.');

  if Forzar then
  begin
    Query.Close;
    Query.SQL.Text := 'SELECT version FROM item WHERE id = :id';
    Query.ParamByName('id').AsInteger := Integer(Nodo.Data);
    Query.Open;
    FItemVersions[Integer(Nodo.Data)] := Query.FieldByName('version').AsInteger;
    Query.Close;
  end
  else
    FItemVersions[Integer(Nodo.Data)] := OldVersion + 1;

  Hijo := Nodo.getFirstChild;
  while Hijo <> nil do
  begin
    MarcarHijosRecursivo(Hijo, Marcado, Query, Forzar);
    Hijo := Hijo.getNextSibling;
  end;
end;

{
  Procedure que gestiona el clic sobre el checkbox de un nodo del arbol
  - Detecta si el clic fue exactamente sobre el checkbox por posicion
  - Inicia una transaccion para garantizar atomicidad
  - Llama a MarcarHijosRecursivo para marcar el nodo y sus hijos
  - Si hay conflicto de version muestra quien hizo el ultimo cambio
  - Permite al usuario forzar el cambio o cancelar y recargar la lista
  - Hace rollback si ocurre cualquier error
}
procedure TForm1.TreeViewClick(Sender: TObject);
var
  Nodo: TTreeNode;
  HitTest: THitTests;
  PuntoLocal: TPoint;
  IdItem: Integer;
  Usuario, Accion: string;
  Fecha: TDateTime;
begin
  PuntoLocal := TreeView1.ScreenToClient(Mouse.CursorPos);
  HitTest := TreeView1.GetHitTestInfoAt(PuntoLocal.X, PuntoLocal.Y);
  if not(htOnStateIcon in HitTest) then
    Exit;

  Nodo := TreeView1.GetNodeAt(PuntoLocal.X, PuntoLocal.Y);
  if Nodo = nil then
    Exit;

  IdItem := Integer(Nodo.Data);
  dm_data.FDConnection1.StartTransaction;
  try
    MarcarHijosRecursivo(Nodo, Nodo.Checked, dm_data.FDQuery2);
    RegistrarHistorial(IdItem, 'COMPLETADO', BoolToStr(not Nodo.Checked, True));
    dm_data.FDConnection1.Commit;
  except
    on E: Exception do
    begin
      dm_data.FDConnection1.Rollback;
      if Pos('Conflicto de versión', E.Message) > 0 then
      begin
        if ObtenerUltimoCambio(IdItem, Usuario, Accion, Fecha) then
        begin
          if MessageDlg
            (Format('El usuario "%s" ha realizado la acción "%s" el %s.' +
            sLineBreak + '¿Desea aplicar su cambio de todas formas?',
            [Usuario, Accion, DateTimeToStr(Fecha)]), mtConfirmation,
            [mbYes, mbNo], 0) = mrYes then
          begin
            dm_data.FDConnection1.StartTransaction;
            try
              MarcarHijosRecursivo(Nodo, Nodo.Checked, dm_data.FDQuery2, True);
              RegistrarHistorial(IdItem, 'COMPLETADO',
                BoolToStr(not Nodo.Checked, True));
              dm_data.FDConnection1.Commit;
            except
              dm_data.FDConnection1.Rollback;
              ShowMessage('No se pudo forzar el cambio. Se recargará la lista.');
              RecargarListaActual;
            end;
          end
          else
            RecargarListaActual;
        end
        else
        begin
          ShowMessage('No se pudo obtener información del conflicto. Recargando lista...');
          RecargarListaActual;
        end;
      end
      else
      begin
        ShowMessage('Error inesperado: ' + E.Message);
        RecargarListaActual;
      end;
    end;
  end;
end;

{
  Procedure que cambia el tema visual de la aplicacion
  - Si el toggle esta activado aplica el tema claro (Aqua Light Slate)
  - Si el toggle esta desactivado aplica el tema oscuro (Glossy)
}
procedure TForm1.ToggleSwitch1Click(Sender: TObject);
begin
  if ToggleSwitch1.State = tssOn then
  begin
    if not TStyleManager.TrySetStyle('Aqua Light Slate') then
      ShowMessage('Estilo no disponible');
  end
  else
  begin
    if not TStyleManager.TrySetStyle('Glossy') then
      ShowMessage('Estilo no disponible');
  end;
end;

{
  Procedure que rellena el submenu Abrir con las listas del proyecto activo
  - Filtra por id_proyecto y ES_NOTA = 0 para mostrar solo listas de tareas
  - Crea un TMenuItem por cada lista y le asigna el evento AbrirListaClick
}
procedure TForm1.mostrarListasCreadas(SubMenuItem: TMenuItem);
var
  SubListaItem: TMenuItem;
begin
  dm_data.FDConnection1.Connected := True;
  dm_data.FDQuery3.Close;
  dm_data.FDQuery3.SQL.Text :=
    'SELECT titulo FROM lista WHERE id_proyecto = :id_proyecto AND ES_NOTA = 0';
  dm_data.FDQuery3.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery3.Open;

  while not dm_data.FDQuery3.EOF do
  begin
    SubListaItem := TMenuItem.Create(SubMenuItem);
    SubListaItem.Caption := dm_data.FDQuery3.FieldByName('titulo').AsString;
    SubListaItem.OnClick := AbrirListaClick;
    SubMenuItem.Add(SubListaItem);
    dm_data.FDQuery3.Next;
  end;
  dm_data.FDQuery3.Close;
end;

{
  Procedure que abre la lista seleccionada desde el submenu
  - Elimina el caracter & que Delphi añade automaticamente a los captions del menu
  - Guarda el nombre de la lista activa en UltimoNombreLista para poder recargarla
  - Llama a insertarLista para cargar el arbol con los items de la lista
}
procedure TForm1.AbrirListaClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  Item := TMenuItem(Sender);
  Item.Caption := StringReplace(Item.Caption, '&', '', [rfReplaceAll]);
  UltimoNombreLista := Item.Caption;
  insertarLista(UltimoNombreLista);
end;

{
  Procedure que detecta el boton del raton pulsado sobre el TreeView
  - Si es clic izquierdo guarda el nodo como candidato a ser arrastrado
  - Si es clic derecho guarda el nodo seleccionado para el menu contextual
  - Si no hay nodo bajo el cursor desactiva el popup para no mostrarlo en el vacio
}
procedure TForm1.TreeViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    NodoArrastrado := TreeView1.GetNodeAt(X, Y);

  if Button <> mbRight then
    Exit;
  NodoSeleccionado := TreeView1.GetNodeAt(X, Y);
  if NodoSeleccionado = nil then
    PopupMenu1.AutoPopup := False
  else
  begin
    PopupMenu1.AutoPopup := True;
    TreeView1.Selected := NodoSeleccionado;
  end;
end;

{
  Procedure que añade un nuevo item como hijo del nodo seleccionado
  - Pide el nombre del nuevo item mediante InputBox
  - Inserta el item en la BD con version = 0 y como hijo del nodo seleccionado
  - Obtiene el id del nuevo item con LAST_INSERT_ID
  - Registra la accion en el historial
  - Añade el nodo al TreeView y lo registra en FItemVersions
}
procedure TForm1.pmAnadirClick(Sender: TObject);
var
  NodoNuevo: TTreeNode;
  Texto: string;
  IdPadre, IdNuevo: Integer;
begin
  if NodoSeleccionado = nil then
    Exit;
  IdPadre := Integer(NodoSeleccionado.Data);
  Texto := InputBox('Nuevo ítem', 'Escribe el nombre:', '');
  if Trim(Texto) = '' then
    Exit;

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text :=
    'INSERT INTO item (id_lista, id_item_padre, texto, completado, version) ' +
    'VALUES (:id_lista, :id_padre, :texto, 0, 0)';
  dm_data.FDQuery2.ParamByName('id_lista').AsInteger := IdListaActual;
  dm_data.FDQuery2.ParamByName('id_padre').AsInteger := IdPadre;
  dm_data.FDQuery2.ParamByName('texto').AsString := Texto;
  dm_data.FDQuery2.ExecSQL;

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text := 'SELECT LAST_INSERT_ID() AS nuevo_id';
  dm_data.FDQuery2.Open;
  IdNuevo := dm_data.FDQuery2.FieldByName('nuevo_id').AsInteger;
  dm_data.FDQuery2.Close;

  RegistrarHistorial(IdNuevo, 'CREADO', Texto);

  NodoNuevo := TreeView1.Items.AddChild(NodoSeleccionado, Texto);
  NodoNuevo.Checked := False;
  NodoNuevo.Data := Pointer(IdNuevo);
  FItemVersions.Add(IdNuevo, 0);
  NodoSeleccionado.Expand(False);
  CargarHistorial;
end;

{
  Procedure que elimina el item seleccionado de la BD y del arbol
  - Pide confirmacion al usuario antes de borrar
  - Comprueba la version del item antes de eliminar (control de concurrencia)
  - Si hay conflicto de version muestra quien hizo el ultimo cambio
  - Permite al usuario forzar el borrado o cancelar y recargar
  - Registra la accion en el historial si el borrado tiene exito
  - Elimina el nodo del TreeView y su entrada en FItemVersions
}
procedure TForm1.pmEliminarClick(Sender: TObject);
var
  IdItem, OldVersion: Integer;
  Usuario, Accion: string;
  Fecha: TDateTime;
begin
  if NodoSeleccionado = nil then
    Exit;
  IdItem := Integer(NodoSeleccionado.Data);
  OldVersion := FItemVersions[IdItem];

  if MessageDlg('¿Eliminar "' + NodoSeleccionado.Text + '" y todos sus hijos?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  RegistrarHistorial(IdItem, 'BORRADO', NodoSeleccionado.Text);

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text :=
    'DELETE FROM item WHERE id = :id AND version = :old_version';
  dm_data.FDQuery2.ParamByName('id').AsInteger := IdItem;
  dm_data.FDQuery2.ParamByName('old_version').AsInteger := OldVersion;
  dm_data.FDQuery2.ExecSQL;

  if dm_data.FDQuery2.RowsAffected = 0 then
  begin
    if ObtenerUltimoCambio(IdItem, Usuario, Accion, Fecha) then
    begin
      if MessageDlg(Format('El usuario "%s" ha realizado la acción "%s" el %s.'
        + sLineBreak + '¿Desea eliminar el ítem de todas formas?',
        [Usuario, Accion, DateTimeToStr(Fecha)]), mtConfirmation, [mbYes, mbNo],
        0) = mrYes then
      begin
        dm_data.FDQuery2.Close;
        dm_data.FDQuery2.SQL.Text := 'DELETE FROM item WHERE id = :id';
        dm_data.FDQuery2.ParamByName('id').AsInteger := IdItem;
        dm_data.FDQuery2.ExecSQL;
        if dm_data.FDQuery2.RowsAffected = 0 then
        begin
          ShowMessage('El ítem ya había sido eliminado. Recargando lista...');
          RecargarListaActual;
          Exit;
        end;
        FItemVersions.Remove(IdItem);
        TreeView1.Items.Delete(NodoSeleccionado);
        NodoSeleccionado := nil;
      end
      else
        RecargarListaActual;
    end
    else
    begin
      ShowMessage('El elemento fue modificado por otro usuario. Recargando lista...');
      RecargarListaActual;
    end;
  end
  else
  begin
    FItemVersions.Remove(IdItem);
    TreeView1.Items.Delete(NodoSeleccionado);
    NodoSeleccionado := nil;
  end;
  CargarHistorial;
end;

{
  Procedure que renombra el item seleccionado
  - Pide el nuevo nombre mediante InputBox
  - Comprueba la version del item antes de actualizar (control de concurrencia)
  - Si hay conflicto de version muestra quien hizo el ultimo cambio
  - Permite al usuario forzar el renombrado o cancelar y recargar
  - Actualiza la version local en FItemVersions tras el exito
  - Registra la accion en el historial y actualiza el texto del nodo
}
procedure TForm1.pmRenombrarClick(Sender: TObject);
var
  TextoNuevo: string;
  IdItem, OldVersion: Integer;
  Usuario, Accion: string;
  Fecha: TDateTime;
begin
  if NodoSeleccionado = nil then
    Exit;
  IdItem := Integer(NodoSeleccionado.Data);
  OldVersion := FItemVersions[IdItem];

  TextoNuevo := InputBox('Renombrar', 'Nuevo nombre: ', NodoSeleccionado.Text);
  if Trim(TextoNuevo) = '' then
    Exit;
  if TextoNuevo = NodoSeleccionado.Text then
    Exit;

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text :=
    'UPDATE item SET texto = :texto, version = version + 1 ' +
    'WHERE id = :id AND version = :old_version';
  dm_data.FDQuery2.ParamByName('texto').AsString := TextoNuevo;
  dm_data.FDQuery2.ParamByName('id').AsInteger := IdItem;
  dm_data.FDQuery2.ParamByName('old_version').AsInteger := OldVersion;
  dm_data.FDQuery2.ExecSQL;

  if dm_data.FDQuery2.RowsAffected = 0 then
  begin
    if ObtenerUltimoCambio(IdItem, Usuario, Accion, Fecha) then
    begin
      if MessageDlg(Format('El usuario "%s" ha realizado la acción "%s" el %s.'
        + sLineBreak + '¿Desea renombrar de todas formas?',
        [Usuario, Accion, DateTimeToStr(Fecha)]), mtConfirmation, [mbYes, mbNo],
        0) = mrYes then
      begin
        dm_data.FDQuery2.Close;
        dm_data.FDQuery2.SQL.Text :=
          'UPDATE item SET texto = :texto, version = version + 1 ' +
          'WHERE id = :id';
        dm_data.FDQuery2.ParamByName('texto').AsString := TextoNuevo;
        dm_data.FDQuery2.ParamByName('id').AsInteger := IdItem;
        dm_data.FDQuery2.ExecSQL;
        if dm_data.FDQuery2.RowsAffected = 0 then
        begin
          ShowMessage('El ítem ha sido eliminado por otro usuario. Recargando...');
          RecargarListaActual;
          Exit;
        end;
        dm_data.FDQuery2.Close;
        dm_data.FDQuery2.SQL.Text := 'SELECT version FROM item WHERE id = :id';
        dm_data.FDQuery2.ParamByName('id').AsInteger := IdItem;
        dm_data.FDQuery2.Open;
        FItemVersions[IdItem] := dm_data.FDQuery2.FieldByName('version').AsInteger;
        dm_data.FDQuery2.Close;

        RegistrarHistorial(IdItem, 'TEXTO', NodoSeleccionado.Text);
        NodoSeleccionado.Text := TextoNuevo;
      end
      else
        RecargarListaActual;
    end
    else
    begin
      ShowMessage('El elemento fue modificado por otro usuario. Recargando lista...');
      RecargarListaActual;
    end;
  end
  else
  begin
    FItemVersions[IdItem] := OldVersion + 1;
    RegistrarHistorial(IdItem, 'RENOMBRADO', NodoSeleccionado.Text);
    NodoSeleccionado.Text := TextoNuevo;
  end;
  CargarHistorial;
end;

{
  Procedure que crea una nueva lista de tareas en el proyecto activo
  - Pide el nombre y la descripcion de la lista mediante InputBox
  - Inserta la lista en la BD con ES_NOTA = 0
  - Crea automaticamente un item raiz para que el arbol tenga punto de partida
  - Refresca el submenu Abrir y carga la nueva lista en el arbol
}
procedure TForm1.insertarNuevaLista(Sender: TObject);
var
  Texto, Descripcion: String;
  SubItem: TMenuItem;
begin
  Texto := InputBox('Nueva lista', 'Escribe el nombre:', '');
  if Trim(Texto) = '' then
    Exit;
  Descripcion := InputBox('Descripcion de la lista:', 'Escribe', '');

  dm_data.FDQuery5.Close;
  dm_data.FDQuery5.SQL.Text :=
    'INSERT INTO lista (id_usuario, id_proyecto, titulo, descripcion, ES_NOTA) '
    + 'VALUES (:id_usuario, :id_proyecto, :nombre, :descripcion, 0)';
  dm_data.FDQuery5.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery5.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery5.ParamByName('nombre').AsString := Texto;
  dm_data.FDQuery5.ParamByName('descripcion').AsString := Descripcion;
  dm_data.FDQuery5.ExecSQL;

  dm_data.FDQuery5.SQL.Text :=
    'INSERT INTO item (id_lista, id_item_padre, texto, completado, version) ' +
    'VALUES (LAST_INSERT_ID(), NULL, ''raiz'', 0, 0)';
  dm_data.FDQuery5.ExecSQL;
  dm_data.FDQuery5.Close;

  SubItem := TMenuItem(MainMenu1.FindComponent('mnuAbrir'));
  while SubItem.Count > 0 do
    SubItem.Delete(0);
  mostrarListasCreadas(SubItem);
  insertarLista(Texto);
end;

{
  Procedure que elimina una lista de tareas del proyecto activo
  - Pide el nombre de la lista a borrar mediante InputBox
  - Filtra por ES_NOTA = 0 para no borrar notas accidentalmente
  - Refresca el submenu Abrir y limpia el arbol y el diccionario de versiones
}
procedure TForm1.borrarListaFunction(Sender: TObject);
var
  Texto: String;
  SubItem: TMenuItem;
begin
  Texto := InputBox('Nombre de la lista a borrar:', '', '');
  if Trim(Texto) = '' then
    Exit;

  dm_data.FDQuery5.Close;
  dm_data.FDQuery5.SQL.Text :=
    'DELETE FROM lista WHERE titulo = :nombre AND id_proyecto = :id_proyecto AND ES_NOTA = 0';
  dm_data.FDQuery5.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery5.ParamByName('nombre').AsString := Texto;
  dm_data.FDQuery5.ExecSQL;
  dm_data.FDQuery5.Close;

  SubItem := TMenuItem(MainMenu1.FindComponent('mnuAbrir'));
  while SubItem.Count > 0 do
    SubItem.Delete(0);
  mostrarListasCreadas(SubItem);
  TreeView1.Items.Clear;
  FItemVersions.Clear;
end;

{
  Procedure que abre el selector de proyectos y recarga el formulario principal
  - Abre Form4 en modo modal y espera a que el usuario seleccione un proyecto
  - Refresca el submenu de listas con las del nuevo proyecto seleccionado
  - Recarga la ultima lista activa o la primera disponible si no habia ninguna
}
procedure TForm1.btnAbrirProyectsClick(Sender: TObject);
begin
  Form4.ShowModal;
  RecargarMenuListas;
  if UltimoNombreLista <> '' then
    insertarLista(UltimoNombreLista)
  else
    insertarLista('');
end;

{
  Procedure que acepta o rechaza el drop mientras el usuario arrastra un nodo
  - Solo acepta el drop si el origen es el propio TreeView
  - Resalta el nodo destino mientras se arrastra encima de el
}
procedure TForm1.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  NodoDestino: TTreeNode;
begin
  Accept := Source = TreeView1;
  NodoDestino := TreeView1.GetNodeAt(X, Y);
  if NodoDestino <> nil then
    TreeView1.Selected := NodoDestino;
end;

{
  Procedure que ejecuta el movimiento cuando se suelta un nodo sobre otro
  - Comprueba que el destino no es el propio nodo ni un descendiente suyo (evita ciclos)
  - Inicia una transaccion para garantizar atomicidad del movimiento
  - Comprueba la version antes de mover (control de concurrencia)
  - Actualiza id_item_padre y el orden de los hermanos en la BD
  - Si hay conflicto de version permite al usuario forzar el movimiento
  - Hace rollback si ocurre cualquier error y recarga la lista
}
procedure TForm1.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  NodoDestino, NodoHijo: TTreeNode;
  i, OldVersion, IdArrastrado: Integer;
  Usuario, Accion: string;
  Fecha: TDateTime;
begin
  NodoDestino := TreeView1.GetNodeAt(X, Y);
  if NodoDestino = nil then
    Exit;
  if NodoArrastrado = nil then
    Exit;
  if NodoDestino = NodoArrastrado then
    Exit;

  NodoHijo := NodoDestino.Parent;
  while NodoHijo <> nil do
  begin
    if NodoHijo = NodoArrastrado then
      Exit;
    NodoHijo := NodoHijo.Parent;
  end;

  IdArrastrado := Integer(NodoArrastrado.Data);
  dm_data.FDConnection1.StartTransaction;
  try
    OldVersion := FItemVersions[IdArrastrado];
    dm_data.FDQuery2.Close;
    dm_data.FDQuery2.SQL.Text :=
      'UPDATE item SET id_item_padre = :nuevo_padre, version = version + 1 ' +
      'WHERE id = :id AND version = :old_version';
    dm_data.FDQuery2.ParamByName('nuevo_padre').AsInteger :=
      Integer(NodoDestino.Data);
    dm_data.FDQuery2.ParamByName('id').AsInteger := IdArrastrado;
    dm_data.FDQuery2.ParamByName('old_version').AsInteger := OldVersion;
    dm_data.FDQuery2.ExecSQL;

    if dm_data.FDQuery2.RowsAffected = 0 then
      raise Exception.Create('Conflicto de versión al mover ítem');

    FItemVersions[IdArrastrado] := OldVersion + 1;

    NodoHijo := NodoDestino.getFirstChild;
    i := 1;
    while NodoHijo <> nil do
    begin
      OldVersion := FItemVersions[Integer(NodoHijo.Data)];
      dm_data.FDQuery2.Close;
      dm_data.FDQuery2.SQL.Text :=
        'UPDATE item SET orden = :orden, version = version + 1 ' +
        'WHERE id = :id AND version = :old_version';
      dm_data.FDQuery2.ParamByName('orden').AsInteger := i;
      dm_data.FDQuery2.ParamByName('id').AsInteger := Integer(NodoHijo.Data);
      dm_data.FDQuery2.ParamByName('old_version').AsInteger := OldVersion;
      dm_data.FDQuery2.ExecSQL;

      if dm_data.FDQuery2.RowsAffected = 0 then
        raise Exception.Create('Conflicto de versión al reordenar');

      FItemVersions[Integer(NodoHijo.Data)] := OldVersion + 1;
      Inc(i);
      NodoHijo := NodoHijo.getNextSibling;
    end;

    dm_data.FDConnection1.Commit;

    NodoArrastrado.MoveTo(NodoDestino, naAddChild);
    NodoDestino.Expand(False);
  except
    on E: Exception do
    begin
      dm_data.FDConnection1.Rollback;
      if Pos('Conflicto de versión', E.Message) > 0 then
      begin
        if ObtenerUltimoCambio(IdArrastrado, Usuario, Accion, Fecha) then
        begin
          if MessageDlg
            (Format('El usuario "%s" ha realizado la acción "%s" el %s.' +
            sLineBreak + '¿Desea forzar el movimiento?', [Usuario, Accion,
            DateTimeToStr(Fecha)]), mtConfirmation, [mbYes, mbNo], 0) = mrYes
          then
          begin
            dm_data.FDConnection1.StartTransaction;
            try
              dm_data.FDQuery2.Close;
              dm_data.FDQuery2.SQL.Text :=
                'UPDATE item SET id_item_padre = :nuevo_padre, version = version + 1 '
                + 'WHERE id = :id';
              dm_data.FDQuery2.ParamByName('nuevo_padre').AsInteger :=
                Integer(NodoDestino.Data);
              dm_data.FDQuery2.ParamByName('id').AsInteger := IdArrastrado;
              dm_data.FDQuery2.ExecSQL;

              if dm_data.FDQuery2.RowsAffected = 0 then
                raise Exception.Create('El ítem ha sido eliminado');

              dm_data.FDQuery2.Close;
              dm_data.FDQuery2.SQL.Text :=
                'SELECT version FROM item WHERE id = :id';
              dm_data.FDQuery2.ParamByName('id').AsInteger := IdArrastrado;
              dm_data.FDQuery2.Open;
              FItemVersions[IdArrastrado] := dm_data.FDQuery2.FieldByName
                ('version').AsInteger;
              dm_data.FDQuery2.Close;

              NodoHijo := NodoDestino.getFirstChild;
              i := 1;
              while NodoHijo <> nil do
              begin
                dm_data.FDQuery2.Close;
                dm_data.FDQuery2.SQL.Text :=
                  'UPDATE item SET orden = :orden, version = version + 1 ' +
                  'WHERE id = :id';
                dm_data.FDQuery2.ParamByName('orden').AsInteger := i;
                dm_data.FDQuery2.ParamByName('id').AsInteger :=
                  Integer(NodoHijo.Data);
                dm_data.FDQuery2.ExecSQL;

                dm_data.FDQuery2.Close;
                dm_data.FDQuery2.SQL.Text :=
                  'SELECT version FROM item WHERE id = :id';
                dm_data.FDQuery2.ParamByName('id').AsInteger :=
                  Integer(NodoHijo.Data);
                dm_data.FDQuery2.Open;
                FItemVersions[Integer(NodoHijo.Data)] :=
                  dm_data.FDQuery2.FieldByName('version').AsInteger;
                dm_data.FDQuery2.Close;

                Inc(i);
                NodoHijo := NodoHijo.getNextSibling;
              end;

              dm_data.FDConnection1.Commit;
              NodoArrastrado.MoveTo(NodoDestino, naAddChild);
              NodoDestino.Expand(False);
            except
              dm_data.FDConnection1.Rollback;
              ShowMessage('No se pudo forzar el cambio. Recargando lista...');
              RecargarListaActual;
            end;
          end
          else
            RecargarListaActual;
        end
        else
        begin
          ShowMessage('Conflicto desconocido. Recargando lista...');
          RecargarListaActual;
        end;
      end
      else
      begin
        ShowMessage('Error durante el movimiento: ' + E.Message + sLineBreak +
          'Recargando...');
        RecargarListaActual;
      end;
    end;
  end;
  NodoArrastrado := nil;
  CargarHistorial;
end;

{
  Procedure que recarga el submenu Abrir con las listas del proyecto activo
  - Elimina todos los items actuales del submenu
  - Vuelve a rellenarlo consultando la BD mediante mostrarListasCreadas
}
procedure TForm1.RecargarMenuListas;
var
  SubItem: TMenuItem;
begin
  SubItem := TMenuItem(MainMenu1.FindComponent('mnuAbrir'));
  if SubItem = nil then
    Exit;
  while SubItem.Count > 0 do
    SubItem.Delete(0);
  mostrarListasCreadas(SubItem);
end;

{
  Procedure que registra una accion del usuario en la tabla historial
  - Guarda el id del item, la lista, el usuario, el tipo de cambio y el dato anterior
  - Se llama despues de cada operacion exitosa sobre un item
}
procedure TForm1.RegistrarHistorial(IdItem: Integer; TipoCambio: String;
  DatoAnterior: String);
begin
  dm_data.FDQuery7.Close;
  dm_data.FDQuery7.SQL.Text :=
    'INSERT INTO historial (id_item, id_lista, id_usuario, tipo_cambio, dato_anterior) '
    + 'VALUES (:id_item, :id_lista, :id_usuario, :tipo_cambio, :dato_anterior)';
  dm_data.FDQuery7.ParamByName('id_item').AsInteger := IdItem;
  dm_data.FDQuery7.ParamByName('id_lista').AsInteger := IdListaActual;
  dm_data.FDQuery7.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery7.ParamByName('tipo_cambio').AsString := TipoCambio;
  dm_data.FDQuery7.ParamByName('dato_anterior').AsString := DatoAnterior;
  dm_data.FDQuery7.ExecSQL;
  dm_data.FDQuery7.Close;
end;

{
  Procedure que recarga el historial al cambiar el nodo seleccionado en el arbol
  - Solo actua si hay una lista activa cargada
}
procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if Node = nil then
    Exit;
  if IdListaActual = 0 then
    Exit;

  CargarHistorial;
end;

{
  Procedure que recarga todos los datos del formulario principal desde la BD
  - Refresca el submenu de listas
  - Recarga el arbol con la lista activa
  - Recarga el historial y las notas del proyecto
}
procedure TForm1.btnRecargarClick(Sender: TObject);
begin
  RecargarMenuListas;
  if TituloListaActual = '' then
    insertarLista('')
  else
    insertarLista(TituloListaActual);

  if IdListaActual > 0 then
  begin
    dm_data.FDQuery7.Close;
    dm_data.FDQuery7.SQL.Text :=
      'SELECT COALESCE(i.texto, h.dato_anterior) AS item, ' + 'h.tipo_cambio, '
      + 'h.dato_anterior, ' + 'u.nombre AS usuario, ' + 'h.fecha_cambio ' +
      'FROM historial h ' + 'INNER JOIN usuarios u ON h.id_usuario = u.id ' +
      'LEFT JOIN item i ON h.id_item = i.id ' + 'WHERE h.id_lista = :id_lista '
      + 'ORDER BY h.fecha_cambio DESC';
    dm_data.FDQuery7.ParamByName('id_lista').AsInteger := IdListaActual;
    dm_data.FDQuery7.Open;
  end;
  CargarNotasProyecto;
  CargarUsuariosProyecto;
end;

{
  Procedure que abre el formulario visor de datos en modo modal
  - Crea Form5 bajo demanda para garantizar que la conexion ya esta activa
  - Libera el formulario al cerrarlo para no dejar memoria ocupada
  - Recarga el historial al volver por si hubo cambios en el visor
}
procedure TForm1.btnVisorDatosClick(Sender: TObject);
var
  Visor: TForm5;
begin
  if RolApp <> 'admin_aplicacion' then
  begin
    ShowMessage('No es posible acceder a esta opcion si no eres administrador de la app');
    Exit;
  end;

  Visor := TForm5.Create(Application);
  try
    Visor.ShowModal;
  finally
    Visor.Free;
  end;

  CargarHistorial;
end;

{
  Procedure que carga las notas del proyecto activo en el MemoNotas
  - Si no hay proyecto activo limpia el memo y sale
  - Consulta todas las listas con ES_NOTA = 1 del proyecto actual
  - Muestra cada nota con su titulo y descripcion agrupados
}
procedure TForm1.CargarNotasProyecto;
begin
  if IdProyectoActual = 0 then
  begin
    MemoNotas.Clear;
    Exit;
  end;
  dm_data.FDQuery8.Close;
  dm_data.FDQuery8.SQL.Text := 'SELECT titulo, descripcion FROM lista ' +
    'WHERE id_proyecto = :id_proyecto AND ES_NOTA = 1 ' +
    'ORDER BY fecha_creacion ASC';
  dm_data.FDQuery8.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery8.Open;
  MemoNotas.Clear;
  if dm_data.FDQuery8.IsEmpty then
    MemoNotas.Lines.Add('(Sin notas)')
  else
    while not dm_data.FDQuery8.EOF do
    begin
      MemoNotas.Lines.Add('=== ' + dm_data.FDQuery8.FieldByName('titulo')
        .AsString + ' ===');
      MemoNotas.Lines.Add(dm_data.FDQuery8.FieldByName('descripcion').AsString);
      MemoNotas.Lines.Add('');
      dm_data.FDQuery8.Next;
    end;
  dm_data.FDQuery8.Close;
end;

{
  Procedure que inserta una nueva nota en la BD con ES_NOTA = 1
  - Pide el titulo y el contenido de la nota mediante InputBox
  - Inserta la nota en la tabla lista asociada al proyecto y usuario actuales
  - Recarga el MemoNotas para mostrar la nueva nota
}
procedure TForm1.insertarNuevaNota(Sender: TObject);
var
  Titulo, Contenido: String;
begin
  Titulo := InputBox('Nueva nota', 'Título de la nota:', '');
  if Trim(Titulo) = '' then
    Exit;
  Contenido := InputBox('Contenido:', 'Escribe el contenido:', '');
  dm_data.FDQuery5.Close;
  dm_data.FDQuery5.SQL.Text :=
    'INSERT INTO lista (id_usuario, id_proyecto, titulo, descripcion, ES_NOTA) '
    + 'VALUES (:id_usuario, :id_proyecto, :titulo, :descripcion, 1)';
  dm_data.FDQuery5.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery5.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery5.ParamByName('titulo').AsString := Titulo;
  dm_data.FDQuery5.ParamByName('descripcion').AsString := Contenido;
  dm_data.FDQuery5.ExecSQL;
  dm_data.FDQuery5.Close;
  CargarNotasProyecto;
end;

{
  Procedure que elimina una nota del proyecto activo por su titulo
  - Pide el titulo de la nota a borrar mediante InputBox
  - Filtra por ES_NOTA = 1 para no borrar listas de tareas accidentalmente
  - Recarga el MemoNotas tras el borrado
}
procedure TForm1.borrarNota(Sender: TObject);
var
  Titulo: String;
begin
  Titulo := InputBox('Borrar nota', 'Título de la nota a borrar:', '');
  if Trim(Titulo) = '' then
    Exit;
  dm_data.FDQuery5.Close;
  dm_data.FDQuery5.SQL.Text := 'DELETE FROM lista WHERE titulo = :titulo ' +
    'AND id_proyecto = :id_proyecto AND ES_NOTA = 1';
  dm_data.FDQuery5.ParamByName('titulo').AsString := Titulo;
  dm_data.FDQuery5.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery5.ExecSQL;
  dm_data.FDQuery5.Close;
  CargarNotasProyecto;
end;

{
  Procedure que recarga la lista actualmente abierta en el arbol
  - Si hay lista activa la recarga por titulo, si no carga la primera disponible
}
procedure TForm1.RecargarListaActual;
begin
  if TituloListaActual <> '' then
    insertarLista(TituloListaActual)
  else
    insertarLista('');
end;

{
  Procedure que actualiza la version local de un item en el diccionario
  - Se usa para mantener sincronizada la version local con la de la BD
}
procedure TForm1.ActualizarVersionItem(IdItem: Integer; NuevaVersion: Integer);
begin
  FItemVersions[IdItem] := NuevaVersion;
end;

{
  Procedure que carga el historial de la lista activa en el DBGrid
  - Si no hay lista activa cierra la query y sale
  - Consulta el historial ordenado por fecha descendente
  - Hace JOIN con usuarios para mostrar el nombre y con item para mostrar el texto
  - Usa COALESCE para mostrar el dato_anterior si el item ya fue borrado
}
procedure TForm1.CargarHistorial;
begin
  if IdListaActual = 0 then
  begin
    dm_data.FDQuery7.Close;
    Exit;
  end;
  dm_data.FDQuery7.Close;
  dm_data.FDQuery7.SQL.Text :=
    'SELECT COALESCE(i.texto, h.dato_anterior) AS item, ' +
    'h.tipo_cambio, h.dato_anterior, u.nombre AS usuario, h.fecha_cambio ' +
    'FROM historial h ' + 'INNER JOIN usuarios u ON h.id_usuario = u.id ' +
    'LEFT JOIN item i ON h.id_item = i.id ' + 'WHERE h.id_lista = :id_lista ' +
    'ORDER BY h.fecha_cambio DESC';
  dm_data.FDQuery7.ParamByName('id_lista').AsInteger := IdListaActual;
  dm_data.FDQuery7.Open;
end;

{
  Procedure que carga los usuarios del proyecto activo en el DBGrid2
  - Si no hay proyecto activo cierra la query y sale
  - Consulta nombre, email y rol de todos los usuarios del proyecto
  - Se recarga al cambiar de proyecto o al pulsar Recargar
}
procedure TForm1.CargarUsuariosProyecto;
begin
  if IdProyectoActual = 0 then
  begin
    dm_data.FDQuery9.Close;
    Exit;
  end;

  dm_data.FDQuery9.Close;
  dm_data.FDQuery9.SQL.Text :=
    'SELECT u.nombre as Nombre, u.email as Email, up.rol as Rol ' +
    'FROM usuarios u ' +
    'INNER JOIN usuario_proyecto up ON u.id = up.id_usuario ' +
    'WHERE up.id_proyecto = :id_proyecto ' +
    'ORDER BY up.rol ASC, u.nombre ASC';
  dm_data.FDQuery9.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery9.Open;
end;

{
  Procedure que permite cambiar el codigo de acceso del proyecto
  - Solo funciona para admin del proyecto y admin_aplicacion
  - Si el usuario es miembro muestra un mensaje de error
  - Comprueba que el nuevo codigo no este en uso por otro proyecto
  - Actualiza el codigo en la BD
}
procedure TForm1.btnCambiarCodigoClick(Sender: TObject);
var
  NuevoCodigo: string;
begin
  if(RolProyecto <> 'admin') and (RolApp <> 'admin_aplicacion') then
  begin
    ShowMessage('No tienes permisos para cambiar el código del proyecto.');
    Exit;
  end;

  NuevoCodigo := InputBox('Cambiar código', 'Nuevo código del proyecto:', '');
  if Trim(NuevoCodigo) = '' then Exit;

  dm_data.FDQuery10.Close;
  dm_data.FDQuery10.SQL.Text := 'SELECT id FROM proyecto WHERE codigo = :codigo AND id <> :id_proyecto';
  dm_data.FDQuery10.ParamByName('codigo').AsString := HashMD5(Trim(NuevoCodigo));
  dm_data.FDQuery10.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery10.Open;

  if not dm_data.FDQuery10.IsEmpty then
  begin
    ShowMessage('Ese código ya está en uso por otro proyecto.');
    dm_data.FDQuery10.Close;
    Exit;
  end;
  dm_data.FDQuery10.Close;

  dm_data.FDQuery10.SQL.Text := 'UPDATE proyecto SET codigo = :codigo WHERE id = :id_proyecto';
  dm_data.FDQuery10.ParamByName('codigo').AsString := HashMD5(Trim(NuevoCodigo));
  dm_data.FDQuery10.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery10.ExecSQL;
  dm_data.FDQuery10.Close;

  ShowMessage('Código actualizado a "' + Trim(NuevoCodigo) + '".');
end;

{
  Procedure que expulsa al usuario seleccionado en el DBGrid2
  - Solo accesible para admin del proyecto y admin_aplicacion
  - Obtiene el nombre del usuario seleccionado en el grid
  - Pide confirmacion antes de expulsar
  - Elimina la relacion del usuario con el proyecto en usuario_proyecto
  - Recarga el grid de usuarios al terminar
}
procedure TForm1.pmExpulsarClick(Sender: TObject);
var
  NombreUsuario: string;
  RolUsuario: string;
begin
  if (RolProyecto <> 'admin') and (RolApp <> 'admin_aplicacion') then
  begin
    ShowMessage('No tienes permisos para expulsar usuarios.');
    Exit;
  end;

  if dm_data.FDQuery9.IsEmpty then
    Exit;

  NombreUsuario := dm_data.FDQuery9.FieldByName('Nombre').AsString;
  RolUsuario := dm_data.FDQuery9.FieldByName('Rol').AsString;

  // No permitir expulsar a otros admins
  if RolUsuario = 'admin' then
  begin
    ShowMessage('No puedes expulsar a otro administrador.');
    Exit;
  end;

  if MessageDlg('¿Expulsar a "' + NombreUsuario + '" del proyecto?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  dm_data.FDQuery10.Close;
  dm_data.FDQuery10.SQL.Text :=
    'DELETE FROM usuario_proyecto ' +
    'WHERE id_usuario = (SELECT id FROM usuarios WHERE nombre = :nombre) ' +
    'AND id_proyecto = :id_proyecto';
  dm_data.FDQuery10.ParamByName('nombre').AsString := NombreUsuario;
  dm_data.FDQuery10.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery10.ExecSQL;
  dm_data.FDQuery10.Close;

  ShowMessage('"' + NombreUsuario + '" ha sido expulsado del proyecto.');
  CargarUsuariosProyecto;
end;
end.
