unit Unit2;

interface

uses
  Unit3, System.SysUtils, System.Classes, System.Types, Vcl.Menus, Vcl.Dialogs, ComCtrls, Controls,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DApt;

type
  Tdm_logic = class(TDataModule)
    MainMenu1: TMainMenu;
    procedure DataModuleCreate(Sender: TObject);
    procedure mostrarListasCreadas(SubMenuItem: TMenuItem);
    procedure insertarLista(nombre: String; TreeView1: TTreeView);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm_logic: Tdm_logic;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{
  Procedure que inserta en el programa la lista seleccionada
}
procedure Tdm_logic.insertarLista(nombre: String; TreeView1: TTreeView);
var
  NodoPadre, NodoHijo: TTreeNode;
  IdPadre: Integer;
  i: Integer;
begin
  dm_data.FDConnection1.Connected := True;
  TreeView1.CheckBoxes := True;

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

{
  Procedure que toma todas las listas en la base de datos y la muestra en el menu del programa
}
procedure Tdm_logic.mostrarListasCreadas(SubMenuItem: TMenuItem);
var
SubListaItem: TMenuItem;
begin
dm_data.FDConnection1.Connected := True;
dm_data.FDQuery3.Open();

while not dm_data.FDQuery3.EOF do
    begin
       //Asigna las listas existentes
       SubListaItem := TMenuItem.Create(SubMenuItem);
       SubListaItem.Caption := dm_data.FDQuery3.FieldByName('titulo').AsString;
       SubMenuItem.add(SubListaItem);

       dm_data.FDQuery3.next()
    end;

dm_data.FDQuery3.Close();
end;

{
  Procedure que ocurre cuando se inicializa el archivo Unit2.pas (dm_logic)

  Lista de cosas que hace:
    - Crea el menu del programa
}
procedure Tdm_logic.DataModuleCreate(Sender: TObject);
var
MenuItem: TMenuItem;
SubMenuItem: TMenuItem;
SubListaItem: TMenuItem;
begin

   //Creacion del item del menu 'listas'
   MenuItem := TMenuItem.Create(MainMenu1);
   MenuItem.Caption := 'Listas';
   MainMenu1.Items.Add(MenuItem);

   SubMenuItem := TMenuItem.Create(MainMenu1);
   SubMenuItem.Caption := 'Crear lista';
   MenuItem.Add(SubMenuItem);

   SubMenuItem := TMenuItem.Create(MainMenu1);
   SubMenuItem.Caption := 'Abrir...';
   MenuItem.Add(SubMenuItem);

   mostrarListasCreadas(SubMenuItem);

end;

end.
