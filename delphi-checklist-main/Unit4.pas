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
    SpeedButton1: TSpeedButton;
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
  private
    procedure CargarProyectos;
  public
  end;

var
  Form4: TForm4;
  IdProyectoActual: Integer = 0;

implementation

{$R *.dfm}

{
  Procedure que carga los proyectos del usuario actual en el DBGrid
  - Consulta los proyectos asociados al usuario mediante usuario_proyecto
}
procedure TForm4.CargarProyectos;
begin

  dm_data.FDQuery6.Close;
  dm_data.FDQuery6.SQL.Text :=
    'SELECT p.nombre, p.descripcion ' +
    'FROM proyecto p ' +
    'INNER JOIN usuario_proyecto up ON p.id = up.id_proyecto ' +
    'WHERE up.id_usuario = :id_usuario';
  dm_data.FDQuery6.ParamByName('id_usuario').AsInteger := IdUsuarioActual;
  dm_data.FDQuery6.Open;

  DBGrid1.DataSource := dm_data.DataSource1;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  CargarProyectos;
end;

end.
