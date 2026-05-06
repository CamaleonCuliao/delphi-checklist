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
  System.Generics.Collections;  // <-- añadido

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

  private
    NodoSeleccionado: TTreeNode;
    NodoArrastrado: TTreeNode;
    TituloListaActual: String;
    EsNotaActual: Boolean;
    FItemVersions: TDictionary<Integer, Integer>;
    procedure MarcarHijosRecursivo(Nodo: TTreeNode; Marcado: Boolean;
      Query: TFDQuery);
    procedure RecargarListaActual;
    procedure ActualizarVersionItem(IdItem: Integer; NuevaVersion: Integer);
  public
    procedure RecargarMenuListas;
    procedure insertarLista(nombre: String);
  end;

var
  Form1: TForm1;
  UltimoNombreLista: string;

implementation

uses
  Unit2, Unit4, Unit5;

{$R *.dfm}

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

  // Creacion del item del menu 'listas'
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

  // --- Configuración del DBGrid para el historial ---
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

  DBGrid1.Options := DBGrid1.Options - [dgEditing];

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FItemVersions.Free;
end;

{
  Procedure insertar
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
    dm_data.FDQuery4.SQL.Text :=
      'SELECT id FROM lista WHERE id_proyecto = :id_proyecto LIMIT 1';
    dm_data.FDQuery4.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  end
  else
  begin
    dm_data.FDQuery4.SQL.Text :=
      'SELECT id FROM lista WHERE id_proyecto = :id_proyecto AND titulo = :titulo';
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
end;

{
  Procedure recursiva que marca todos los hijos de un nodo
  Ahora con manejo de versión optimista dentro de una transacción.
}
procedure TForm1.MarcarHijosRecursivo(Nodo: TTreeNode; Marcado: Boolean;
  Query: TFDQuery);
var
  Hijo: TTreeNode;
  OldVersion: Integer;
begin
  OldVersion := FItemVersions[Integer(Nodo.Data)];

  Nodo.Checked := Marcado;

  Query.Close;
  Query.SQL.Text := 'UPDATE item SET ' +
    '  completado = :completado, ' +
    '  fecha_completado = :fecha, ' +
    '  version = version + 1 ' +
    'WHERE id = :id AND version = :old_version';
  Query.ParamByName('completado').AsBoolean := Marcado;
  if Marcado then
    Query.ParamByName('fecha').AsDateTime := Now
  else
    Query.ParamByName('fecha').Clear;
  Query.ParamByName('id').AsInteger := Integer(Nodo.Data);
  Query.ParamByName('old_version').AsInteger := OldVersion;
  Query.ExecSQL;

  if Query.RowsAffected = 0 then
    raise Exception.Create('Conflicto de versión en item ' + IntToStr(Integer(Nodo.Data)));

  FItemVersions[Integer(Nodo.Data)] := OldVersion + 1;

  Hijo := Nodo.getFirstChild;
  while Hijo <> nil do
  begin
    MarcarHijosRecursivo(Hijo, Marcado, Query);
    Hijo := Hijo.getNextSibling;
  end;
end;

{
  Procedure para marcar los hijos de la checkbox seleccionada por el usuario
}
procedure TForm1.TreeViewClick(Sender: TObject);
var
  Nodo: TTreeNode;
  HitTest: THitTests;
  PuntoLocal: TPoint;
begin
  PuntoLocal := TreeView1.ScreenToClient(Mouse.CursorPos);

  HitTest := TreeView1.GetHitTestInfoAt(PuntoLocal.X, PuntoLocal.Y);
  if not(htOnStateIcon in HitTest) then
    Exit;

  Nodo := TreeView1.GetNodeAt(PuntoLocal.X, PuntoLocal.Y);
  if Nodo = nil then
    Exit;

  dm_data.FDConnection1.StartTransaction;
  try
    MarcarHijosRecursivo(Nodo, Nodo.Checked, dm_data.FDQuery2);
    RegistrarHistorial(Integer(Nodo.Data), 'COMPLETADO',
      BoolToStr(not Nodo.Checked, True));
    dm_data.FDConnection1.Commit;
  except
    on E: Exception do
    begin
      dm_data.FDConnection1.Rollback;
      ShowMessage('No se pudo aplicar el cambio. Otro usuario modificó algún elemento.' + sLineBreak +
        E.Message);
      RecargarListaActual;
    end;
  end;
end;

{
  Estilo de la aplicacion
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
  Procedure que toma todas las listas en la base de datos y la muestra en el menu del programa
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
  Procedure que detecta el clic derecho y guarda el nodo seleccionado
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
  Procedure que añade un nuevo ítem como hijo del nodo seleccionado
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
end;

{
  Procedure que elimina el ítem seleccionado y todos sus hijos
}
procedure TForm1.pmEliminarClick(Sender: TObject);
var
  IdItem, OldVersion: Integer;
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
  dm_data.FDQuery2.SQL.Text := 'DELETE FROM item WHERE id = :id AND version = :old_version';
  dm_data.FDQuery2.ParamByName('id').AsInteger := IdItem;
  dm_data.FDQuery2.ParamByName('old_version').AsInteger := OldVersion;
  dm_data.FDQuery2.ExecSQL;

  if dm_data.FDQuery2.RowsAffected = 0 then
  begin
    ShowMessage('El elemento fue modificado por otro usuario. Recargando lista...');
    RecargarListaActual;
    Exit;
  end;

  FItemVersions.Remove(IdItem);
  TreeView1.Items.Delete(NodoSeleccionado);
  NodoSeleccionado := nil;
end;

{
  Procedure para renombrar el item seleccionado
}
procedure TForm1.pmRenombrarClick(Sender: TObject);
var
  TextoNuevo: string;
  IdItem, OldVersion: Integer;
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

  RegistrarHistorial(IdItem, 'TEXTO', NodoSeleccionado.Text);

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
    ShowMessage('El elemento fue modificado por otro usuario. Recargando lista...');
    RecargarListaActual;
    Exit;
  end;

  FItemVersions[IdItem] := OldVersion + 1;
  NodoSeleccionado.Text := TextoNuevo;
end;

{
  Procedure que añade una nueva lista a la base de datos
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
    'DELETE FROM lista WHERE titulo = :nombre AND id_proyecto = :id_proyecto';
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

procedure TForm1.btnAbrirProyectsClick(Sender: TObject);
begin
  Form4.ShowModal;
  RecargarMenuListas;
  if UltimoNombreLista <> '' then
    insertarLista(UltimoNombreLista)
  else
    insertarLista('');
end;

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

procedure TForm1.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  NodoDestino: TTreeNode;
  NodoHijo: TTreeNode;
  i, OldVersion: Integer;
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

  dm_data.FDConnection1.StartTransaction;
  try
    OldVersion := FItemVersions[Integer(NodoArrastrado.Data)];
    dm_data.FDQuery2.Close;
    dm_data.FDQuery2.SQL.Text :=
      'UPDATE item SET id_item_padre = :nuevo_padre, version = version + 1 ' +
      'WHERE id = :id AND version = :old_version';
    dm_data.FDQuery2.ParamByName('nuevo_padre').AsInteger := Integer(NodoDestino.Data);
    dm_data.FDQuery2.ParamByName('id').AsInteger := Integer(NodoArrastrado.Data);
    dm_data.FDQuery2.ParamByName('old_version').AsInteger := OldVersion;
    dm_data.FDQuery2.ExecSQL;

    if dm_data.FDQuery2.RowsAffected = 0 then
      raise Exception.Create('Conflicto de versión al mover ítem');

    FItemVersions[Integer(NodoArrastrado.Data)] := OldVersion + 1;

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
      ShowMessage('Conflicto al reorganizar: ' + E.Message + sLineBreak +
        'Se recargará la lista.');
      RecargarListaActual;
    end;
  end;

  NodoArrastrado := nil;
end;

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

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if Node = nil then
    Exit;
  if IdListaActual = 0 then
    Exit;

  dm_data.FDQuery7.Close;
  dm_data.FDQuery7.SQL.Text :=
    'SELECT COALESCE(i.texto, h.dato_anterior) AS item, ' + 'h.tipo_cambio, ' +
    'h.dato_anterior, ' + 'u.nombre AS usuario, ' + 'h.fecha_cambio ' +
    'FROM historial h ' + 'INNER JOIN usuarios u ON h.id_usuario = u.id ' +
    'LEFT JOIN item i ON h.id_item = i.id ' + 'WHERE h.id_lista = :id_lista ' +
    'ORDER BY h.fecha_cambio DESC';
  dm_data.FDQuery7.ParamByName('id_lista').AsInteger := IdListaActual;
  dm_data.FDQuery7.Open;

  DBGrid1.DataSource := dm_data.DataSource2;
end;

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
      'SELECT COALESCE(i.texto, h.dato_anterior) AS item, ' +
      'h.tipo_cambio, ' +
      'h.dato_anterior, ' +
      'u.nombre AS usuario, ' +
      'h.fecha_cambio ' +
      'FROM historial h ' +
      'INNER JOIN usuarios u ON h.id_usuario = u.id ' +
      'LEFT JOIN item i ON h.id_item = i.id ' +
      'WHERE h.id_lista = :id_lista ' +
      'ORDER BY h.fecha_cambio DESC';
    dm_data.FDQuery7.ParamByName('id_lista').AsInteger := IdListaActual;
    dm_data.FDQuery7.Open;
  end;
  CargarNotasProyecto;
end;

{
  Procedure que abre el formulario visor de datos en modo modal.
  Se crea bajo demanda para garantizar que la conexion ya esta activa.
}
procedure TForm1.btnVisorDatosClick(Sender: TObject);
var
  Visor: TForm5;
begin
  Visor := TForm5.Create(Application);
  try
    Visor.ShowModal;
  finally
    Visor.Free;
  end;
end;

procedure TForm1.CargarNotasProyecto;
begin
  if IdProyectoActual = 0 then
  begin
    MemoNotas.Clear;
    Exit;
  end;

  dm_data.FDQuery8.Close;
  dm_data.FDQuery8.SQL.Text :=
    'SELECT titulo, descripcion FROM lista ' +
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
      MemoNotas.Lines.Add('=== ' + dm_data.FDQuery8.FieldByName('titulo').AsString + ' ===');
      MemoNotas.Lines.Add(dm_data.FDQuery8.FieldByName('descripcion').AsString);
      MemoNotas.Lines.Add('');
      dm_data.FDQuery8.Next;
    end;

  dm_data.FDQuery8.Close;
end;

procedure TForm1.insertarNuevaNota(Sender: TObject);
var
  Titulo, Contenido: String;
begin
  Titulo := InputBox('Nueva nota', 'Título de la nota:', '');
  if Trim(Titulo) = '' then Exit;

  Contenido := InputBox('Contenido:', 'Escribe el contenido:', '');

  dm_data.FDQuery5.Close;
  dm_data.FDQuery5.SQL.Text :=
    'INSERT INTO lista (id_usuario, id_proyecto, titulo, descripcion, ES_NOTA) ' +
    'VALUES (:id_usuario, :id_proyecto, :titulo, :descripcion, 1)';
  dm_data.FDQuery5.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery5.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery5.ParamByName('titulo').AsString := Titulo;
  dm_data.FDQuery5.ParamByName('descripcion').AsString := Contenido;
  dm_data.FDQuery5.ExecSQL;
  dm_data.FDQuery5.Close;

  CargarNotasProyecto;
end;

procedure TForm1.borrarNota(Sender: TObject);
var
  Titulo: String;
begin
  Titulo := InputBox('Borrar nota', 'Título de la nota a borrar:', '');
  if Trim(Titulo) = '' then
    Exit;

  dm_data.FDQuery5.Close;
  dm_data.FDQuery5.SQL.Text :=
    'DELETE FROM lista WHERE titulo = :titulo ' +
    'AND id_proyecto = :id_proyecto AND ES_NOTA = 1';
  dm_data.FDQuery5.ParamByName('titulo').AsString := Titulo;
  dm_data.FDQuery5.ParamByName('id_proyecto').AsInteger := IdProyectoActual;
  dm_data.FDQuery5.ExecSQL;
  dm_data.FDQuery5.Close;

  CargarNotasProyecto;
end;

// Métodos privados auxiliares de concurrencia optimista

procedure TForm1.RecargarListaActual;
begin
  if TituloListaActual <> '' then
    insertarLista(TituloListaActual)
  else
    insertarLista('');
end;

procedure TForm1.ActualizarVersionItem(IdItem: Integer; NuevaVersion: Integer);
begin
  FItemVersions[IdItem] := NuevaVersion;
end;

end.
