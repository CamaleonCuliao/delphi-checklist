unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.ComCtrls;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}



end.
