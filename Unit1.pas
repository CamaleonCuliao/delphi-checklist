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
  NodoPadre, NodoHijo: TTreeNode;   // Declaración correcta de variables locales
begin
  FDConnection1.Connected := True;
  FDQuery1.Open;

  WindowState := wsMaximized;

  // Activar checkboxes en el TreeView
  TreeView1.CheckBoxes := True;

  // Recorrer el dataset y construir el árbol
  FDQuery1.First;
  while not FDQuery1.EOF do
  begin
    // Verificar si es nodo raíz (id_lista_padre = 0)
    if FDQuery1.FieldByName('id_lista_padre').AsInteger = 0 then
    begin
      NodoPadre := TreeView1.Items.Add(nil, FDQuery1.FieldByName('texto').AsString);
      NodoPadre.Checked := False;   // Inicialmente desmarcado
    end
    else
    begin
      // Obtener el texto del nodo padre desde la base de datos
      FDQuery2.SQL.Text := 'SELECT texto FROM item WHERE id = :id';
      FDQuery2.Params.Clear;
      FDQuery2.Params.Add.Name := 'id';
      FDQuery2.ParamByName('id').AsInteger := FDQuery1.FieldByName('id_lista_padre').AsInteger;
      FDQuery2.Open;
      FDQuery2.First;

      // Buscar el nodo padre en el TreeView por su texto
      NodoPadre := nil;
      for i := 0 to TreeView1.Items.Count - 1 do
      begin
        if TreeView1.Items[i].Text = FDQuery2.FieldByName('texto').AsString then
        begin
          NodoPadre := TreeView1.Items[i];
          Break;
        end;
      end;

      // Si se encontró el padre, agregar como hijo; sino, agregar como raíz (por seguridad)
      if NodoPadre <> nil then
        NodoHijo := TreeView1.Items.AddChild(NodoPadre, FDQuery1.FieldByName('texto').AsString)
      else
        NodoHijo := TreeView1.Items.Add(nil, FDQuery1.FieldByName('texto').AsString);

      NodoHijo.Checked := False;
      FDQuery2.Close;
    end;

    FDQuery1.Next;
  end;

  // Expandir todos los nodos para visualización inmediata
  TreeView1.FullExpand;
end;

end.
