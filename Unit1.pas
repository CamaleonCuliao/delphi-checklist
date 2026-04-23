unit Unit1;

interface

uses
  Unit3, Unit2, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ComCtrls,
  Vcl.Menus, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.DataSet, Vcl.ExtCtrls, Vcl.Buttons, Vcl.WinXCtrls, Vcl.Themes;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    TreeView1: TTreeView;
    anadir: TSpeedButton;
    eliminar: TSpeedButton;
    crearlista: TBitBtn;
    borrarLista: TBitBtn;
    ToggleSwitch1: TToggleSwitch;
    procedure FormCreate(Sender: TObject);
    procedure ToggleSwitch1Click(Sender: TObject);
  private
    procedure TreeViewClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


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
  Query.ParamByName('completado').AsInteger := Integer(Marcado);
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

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  NodoPadre, NodoHijo: TTreeNode;
  IdPadre: Integer;
begin
  dm_data.FDConnection1.Connected := True;
  WindowState := wsMaximized;
  TreeView1.CheckBoxes := True;
  TreeView1.OnClick := TreeViewClick;

  // --- BORRAR todo lo que haya en el árbol antes de cargar ---
  TreeView1.Items.Clear;

  // --- UNA SOLA QUERY ordenada: raíces primero, luego hijos por ID ---
  dm_data.FDQuery1.Close;
  dm_data.FDQuery1.SQL.Text :=
    'SELECT * FROM item ' +
    'WHERE id_lista = 1 ' +
    'ORDER BY ISNULL(id_item_padre) DESC, id ASC';
  dm_data.FDQuery1.Open;

  while not dm_data.FDQuery1.EOF do
  begin
    if dm_data.FDQuery1.FieldByName('id_item_padre').IsNull then
    begin
      // --- Nodo RAÍZ ---
      NodoPadre := TreeView1.Items.Add(nil, dm_data.FDQuery1.FieldByName('texto').AsString);
      NodoPadre.Checked := False;
      NodoPadre.Data    := Pointer(dm_data.FDQuery1.FieldByName('id').AsInteger);
    end
    else
    begin
      // --- Nodo HIJO: buscar su padre por ID en .Data ---
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

      NodoHijo.Checked := False;
      NodoHijo.Data    := Pointer(dm_data.FDQuery1.FieldByName('id').AsInteger);
    end;

    dm_data.FDQuery1.Next;
  end;

  dm_data.FDQuery1.Close;
  TreeView1.FullExpand;
end;

procedure TForm1.ToggleSwitch1Click(Sender: TObject);
begin
  if ToggleSwitch1.State = tssOn then
  TStyleManager.SetStyle('Aqua Light Slate') // Estilo claro
  else
  TStyleManager.SetStyle('Glossy');  // Estilo oscuro
end;

procedure TForm1.TreeViewClick(Sender: TObject);
var
  Nodo: TTreeNode;
  HitTest: THitTests;
  PuntoLocal: TPoint;
begin
  // Obtener la posición del click en coordenadas del TreeView
  PuntoLocal := TreeView1.ScreenToClient(Mouse.CursorPos);

  // Comprobar que el click fue exactamente sobre el checkbox
  HitTest := TreeView1.GetHitTestInfoAt(PuntoLocal.X, PuntoLocal.Y);
  if not (htOnStateIcon in HitTest) then
    Exit;

  // Obtener el nodo por posición, no por Selected
  Nodo := TreeView1.GetNodeAt(PuntoLocal.X, PuntoLocal.Y);
  if Nodo = nil then
    Exit;

  MarcarHijosRecursivo(Nodo, Nodo.Checked, dm_data.FDQuery2);
end;

end.
