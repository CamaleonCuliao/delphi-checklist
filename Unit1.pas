unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ComCtrls,
  Vcl.Menus, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.DataSet, Vcl.ExtCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    f1: TMenuItem;
    dwaf1: TMenuItem;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    FDQuery2: TFDQuery;
    Panel1: TPanel;
    TreeView1: TTreeView;
    anadir: TSpeedButton;
    eliminar: TSpeedButton;
    crearlista: TBitBtn;
    borrarLista: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  NodoPadre, NodoHijo: TTreeNode;
  IdPadre: Integer;
begin
  FDConnection1.Connected := True;
  WindowState := wsMaximized;
  TreeView1.CheckBoxes := True;

  // --- BORRAR todo lo que haya en el árbol antes de cargar ---
  TreeView1.Items.Clear;

  // --- UNA SOLA QUERY ordenada: raíces primero, luego hijos por ID ---
  FDQuery1.Close;
  FDQuery1.SQL.Text :=
    'SELECT * FROM item ' +
    'WHERE id_lista = 1 ' +
    'ORDER BY ISNULL(id_item_padre) DESC, id ASC';
  FDQuery1.Open;

  while not FDQuery1.EOF do
  begin
    if FDQuery1.FieldByName('id_item_padre').IsNull then
    begin
      // --- Nodo RAÍZ ---
      NodoPadre := TreeView1.Items.Add(nil, FDQuery1.FieldByName('texto').AsString);
      NodoPadre.Checked := False;
      NodoPadre.Data    := Pointer(FDQuery1.FieldByName('id').AsInteger);
    end
    else
    begin
      // --- Nodo HIJO: buscar su padre por ID en .Data ---
      IdPadre   := FDQuery1.FieldByName('id_item_padre').AsInteger;
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
        NodoHijo := TreeView1.Items.AddChild(NodoPadre, FDQuery1.FieldByName('texto').AsString)
      else
        NodoHijo := TreeView1.Items.Add(nil, FDQuery1.FieldByName('texto').AsString);

      NodoHijo.Checked := False;
      NodoHijo.Data    := Pointer(FDQuery1.FieldByName('id').AsInteger);
    end;

    FDQuery1.Next;
  end;

  FDQuery1.Close;
  TreeView1.FullExpand;
end;

end.
