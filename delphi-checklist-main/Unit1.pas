unit Unit1;

interface

uses
  Unit3, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ComCtrls,
  Vcl.Menus, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.DataSet, Vcl.ExtCtrls, Vcl.Buttons, Vcl.WinXCtrls,
  Vcl.Themes, System.UITypes;

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
    procedure insertarLista(nombre: String);
    procedure AbrirListaClick(Sender: TObject);
    procedure mostrarListasCreadas(SubMenuItem: TMenuItem);
    procedure FormCreate(Sender: TObject);
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
  private
    NodoSeleccionado: TTreeNode;
    NodoArrastrado: TTreeNode;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Unit2;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  NodoPadre, NodoHijo: TTreeNode;
  MenuItem: TMenuItem;
  SubMenuItem: TMenuItem;
  SubListaItem: TMenuItem;
begin
  Self.Menu := MainMenu1;
  dm_data.FDConnection1.Connected := True;
  WindowState := wsMaximized;

  insertarLista('api');
  TreeView1.OnClick := TreeViewClick;

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

  mostrarListasCreadas(SubMenuItem);

  NodoSeleccionado      := nil;
  TreeView1.OnMouseDown := TreeViewMouseDown;
  TreeView1.PopupMenu   := PopupMenu1;
  pmAnadir.OnClick      := pmAnadirClick;
  pmEliminar.OnClick    := pmEliminarClick;
  pmRenombrar.OnClick   := pmRenombrarClick;

  NodoArrastrado           := nil;
  TreeView1.DragMode       := dmAutomatic;
  TreeView1.OnDragOver     := TreeView1DragOver;
  TreeView1.OnDragDrop     := TreeView1DragDrop;
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

  dm_data.FDQuery4.Close;
  dm_data.FDQuery4.SQL.Text := 'SELECT id FROM lista WHERE titulo = :titulo';
  dm_data.FDQuery4.ParamByName('titulo').AsString := Trim(nombre);
  dm_data.FDQuery4.Prepare;
  dm_data.FDQuery4.Open;
  id_lista := dm_data.FDQuery4.FieldByName('id').AsInteger;
  dm_data.FDQuery4.Close;

  dm_data.FDQuery1.Close;
  dm_data.FDQuery1.SQL.Text :=
    'SELECT * FROM item ' +
    'WHERE id_lista = :id_lista ' +
    'ORDER BY ISNULL(id_item_padre) DESC, id ASC';
  dm_data.FDQuery1.ParamByName('id_lista').AsInteger := id_lista;
  dm_data.FDQuery1.Open;

  while not dm_data.FDQuery1.EOF do
  begin
    if dm_data.FDQuery1.FieldByName('id_item_padre').IsNull then
    begin
      NodoPadre := TreeView1.Items.Add(nil, dm_data.FDQuery1.FieldByName('texto').AsString);
      NodoPadre.Checked := dm_data.FDQuery1.FieldByName('completado').AsBoolean;
      NodoPadre.Data    := Pointer(dm_data.FDQuery1.FieldByName('id').AsInteger);
    end
    else
    begin
      IdPadre   := dm_data.FDQuery1.FieldByName('id_item_padre').AsInteger;
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
        NodoHijo := TreeView1.Items.AddChild(NodoPadre, dm_data.FDQuery1.FieldByName('texto').AsString)
      else
        NodoHijo := TreeView1.Items.Add(nil, dm_data.FDQuery1.FieldByName('texto').AsString);

      NodoHijo.Checked := dm_data.FDQuery1.FieldByName('completado').AsBoolean;
      NodoHijo.Data    := Pointer(dm_data.FDQuery1.FieldByName('id').AsInteger);
    end;

    dm_data.FDQuery1.Next;
  end;

  dm_data.FDQuery1.Close;
  TreeView1.FullExpand;
end;

{
  Procedure recursiva que marca todos los hijos de un nodo
}
procedure MarcarHijosRecursivo(Nodo: TTreeNode; Marcado: Boolean; Query: TFDQuery);
var
  Hijo: TTreeNode;
begin
  Nodo.Checked := Marcado;

  Query.Close;
  Query.SQL.Text :=
    'UPDATE item SET ' +
    '  completado = :completado, ' +
    '  fecha_completado = :fecha ' +
    'WHERE id = :id';
  Query.ParamByName('completado').AsBoolean := Marcado;
  if Marcado then
    Query.ParamByName('fecha').AsDateTime := Now
  else
    Query.ParamByName('fecha').Clear;
  Query.ParamByName('id').AsInteger := Integer(Nodo.Data);
  Query.ExecSQL;

  Hijo := Nodo.getFirstChild;
  while Hijo <> nil do
  begin
    MarcarHijosRecursivo(Hijo, Marcado, Query);
    Hijo := Hijo.getNextSibling;
  end;
end;

{
  Procedure para marcar los hijos de la checkbox seleccionada por el usuario
  Dependencias: MarcarHijosRecursivo()
}
procedure TForm1.TreeViewClick(Sender: TObject);
var
  Nodo: TTreeNode;
  HitTest: THitTests;
  PuntoLocal: TPoint;
begin
  PuntoLocal := TreeView1.ScreenToClient(Mouse.CursorPos);
  HitTest := TreeView1.GetHitTestInfoAt(PuntoLocal.X, PuntoLocal.Y);
  if not (htOnStateIcon in HitTest) then
    Exit;

  Nodo := TreeView1.GetNodeAt(PuntoLocal.X, PuntoLocal.Y);
  if Nodo = nil then
    Exit;

  MarcarHijosRecursivo(Nodo, Nodo.Checked, dm_data.FDQuery2);
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
  Procedure que toma todas las listas en la base de datos y la muestra en el menu
}
procedure TForm1.mostrarListasCreadas(SubMenuItem: TMenuItem);
var
  SubListaItem: TMenuItem;
begin
  dm_data.FDConnection1.Connected := True;
  dm_data.FDQuery3.Close;
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
  insertarLista(Item.Caption);
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
    TreeView1.Selected   := NodoSeleccionado;
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
  if NodoSeleccionado = nil then Exit;

  IdPadre := Integer(NodoSeleccionado.Data);

  Texto := InputBox('Nuevo ítem', 'Escribe el nombre:', '');
  if Trim(Texto) = '' then Exit;

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text :=
    'INSERT INTO item (id_lista, id_item_padre, texto, completado) ' +
    'VALUES (:id_lista, :id_padre, :texto, 0)';
  dm_data.FDQuery2.ParamByName('id_lista').AsInteger := 1;
  dm_data.FDQuery2.ParamByName('id_padre').AsInteger := IdPadre;
  dm_data.FDQuery2.ParamByName('texto').AsString     := Texto;
  dm_data.FDQuery2.ExecSQL;

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text := 'SELECT LAST_INSERT_ID() AS nuevo_id';
  dm_data.FDQuery2.Open;
  IdNuevo := dm_data.FDQuery2.FieldByName('nuevo_id').AsInteger;
  dm_data.FDQuery2.Close;

  NodoNuevo         := TreeView1.Items.AddChild(NodoSeleccionado, Texto);
  NodoNuevo.Checked := False;
  NodoNuevo.Data    := Pointer(IdNuevo);
  NodoSeleccionado.Expand(False);
end;

{
  Procedure que elimina el ítem seleccionado y todos sus hijos
}
procedure TForm1.pmEliminarClick(Sender: TObject);
var
  IdItem: Integer;
begin
  if NodoSeleccionado = nil then Exit;

  IdItem := Integer(NodoSeleccionado.Data);

  if MessageDlg('¿Eliminar "' + NodoSeleccionado.Text + '" y todos sus hijos?',
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text := 'DELETE FROM item WHERE id = :id';
  dm_data.FDQuery2.ParamByName('id').AsInteger := IdItem;
  dm_data.FDQuery2.ExecSQL;

  TreeView1.Items.Delete(NodoSeleccionado);
  NodoSeleccionado := nil;
end;

{
  Procedure para renombrar el item seleccionado
}
procedure TForm1.pmRenombrarClick(Sender: TObject);
var
  TextoNuevo: string;
  IdItem: Integer;
begin
  if NodoSeleccionado = nil then Exit;

  IdItem := Integer(NodoSeleccionado.Data);

  TextoNuevo := InputBox('Renombrar', 'Nuevo nombre: ', NodoSeleccionado.Text);

  if Trim(TextoNuevo) = '' then Exit;
  if TextoNuevo = NodoSeleccionado.Text then Exit;

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text := 'UPDATE item SET texto = :texto WHERE id = :id';
  dm_data.FDQuery2.ParamByName('texto').AsString  := TextoNuevo;
  dm_data.FDQuery2.ParamByName('id').AsInteger    := IdItem;
  dm_data.FDQuery2.ExecSQL;
  dm_data.FDQuery2.Close;

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
  Texto       := InputBox('Nueva lista', 'Escribe el nombre:', '');
  Descripcion := InputBox('Descripcion de la lista:', 'Escribe', '');

  dm_data.FDQuery5.Close;
  dm_data.FDQuery5.SQL.Text :=
    'INSERT INTO lista (id_usuario, titulo, descripcion, ES_NOTA) ' +
    'VALUES (1, :nombre, :descripcion, 0)';
  dm_data.FDQuery5.ParamByName('nombre').AsString      := Texto;
  dm_data.FDQuery5.ParamByName('descripcion').AsString := Descripcion;
  dm_data.FDQuery5.ExecSQL;

  dm_data.FDQuery5.SQL.Text :=
    'INSERT INTO item (id_lista, id_item_padre, texto, completado) ' +
    'VALUES (LAST_INSERT_ID(), NULL, ''raiz'', 0)';
  dm_data.FDQuery5.ExecSQL;
  dm_data.FDQuery5.Close;

  SubItem := TMenuItem(MainMenu1.FindComponent('mnuAbrir'));
  while SubItem.Count > 0 do
    SubItem.Delete(0);
  mostrarListasCreadas(SubItem);
end;

procedure TForm1.borrarListaFunction(Sender: TObject);
var
  Texto: String;
  SubItem: TMenuItem;
begin
  Texto := InputBox('Nombre de la lista a borrar:', '', '');

  dm_data.FDQuery5.Close;
  dm_data.FDQuery5.SQL.Text := 'DELETE FROM lista WHERE titulo = :nombre';
  dm_data.FDQuery5.ParamByName('nombre').AsString := Texto;
  dm_data.FDQuery5.ExecSQL;

  SubItem := TMenuItem(MainMenu1.FindComponent('mnuAbrir'));
  while SubItem.Count > 0 do
    SubItem.Delete(0);
  mostrarListasCreadas(SubItem);
end;

{
  Procedure que acepta o rechaza el drag mientras se arrastra
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
  Procedure que ejecuta el drop cuando se suelta el nodo
}
procedure TForm1.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  NodoDestino: TTreeNode;
  NodoHijo: TTreeNode;
  i: Integer;
begin
  NodoDestino := TreeView1.GetNodeAt(X, Y);

  if NodoDestino = nil then Exit;
  if NodoArrastrado = nil then Exit;
  if NodoDestino = NodoArrastrado then Exit;

  NodoHijo := NodoDestino.Parent;
  while NodoHijo <> nil do
  begin
    if NodoHijo = NodoArrastrado then Exit;
    NodoHijo := NodoHijo.Parent;
  end;

  NodoArrastrado.MoveTo(NodoDestino, naAddChild);
  NodoDestino.Expand(False);

  dm_data.FDQuery2.Close;
  dm_data.FDQuery2.SQL.Text :=
    'UPDATE item SET id_item_padre = :nuevo_padre WHERE id = :id';
  dm_data.FDQuery2.ParamByName('nuevo_padre').AsInteger := Integer(NodoDestino.Data);
  dm_data.FDQuery2.ParamByName('id').AsInteger          := Integer(NodoArrastrado.Data);
  dm_data.FDQuery2.ExecSQL;

  NodoHijo := NodoDestino.getFirstChild;
  i := 1;
  while NodoHijo <> nil do
  begin
    dm_data.FDQuery2.Close;
    dm_data.FDQuery2.SQL.Text :=
      'UPDATE item SET orden = :orden WHERE id = :id';
    dm_data.FDQuery2.ParamByName('orden').AsInteger := i;
    dm_data.FDQuery2.ParamByName('id').AsInteger    := Integer(NodoHijo.Data);
    dm_data.FDQuery2.ExecSQL;
    Inc(i);
    NodoHijo := NodoHijo.getNextSibling;
  end;

  NodoArrastrado := nil;
end;

end.
