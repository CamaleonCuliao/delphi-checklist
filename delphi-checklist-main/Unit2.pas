unit Unit2;

interface

uses
  Unit3, System.SysUtils, System.Classes, Vcl.Menus, Vcl.Dialogs;

type
  Tdm_logic = class(TDataModule)
    MainMenu1: TMainMenu;
    procedure DataModuleCreate(Sender: TObject);
    procedure mostrarListasCreadas(SubMenuItem: TMenuItem);
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

procedure Tdm_logic.DataModuleCreate(Sender: TObject);
var
MenuItem: TMenuItem;
SubMenuItem: TMenuItem;
SubListaItem: TMenuItem;
begin

   MenuItem := TMenuItem.Create(MainMenu1);
   MenuItem.Caption := 'Listas';
   MainMenu1.Items.Add(MenuItem);

   SubMenuItem := TMenuItem.Create(MainMenu1);
   SubMenuItem.Caption := 'Crear lista';
   MenuItem.Add(SubMenuItem);

   //Crea item padre abrir
   SubMenuItem := TMenuItem.Create(MainMenu1);
   SubMenuItem.Caption := 'Abrir...';
   MenuItem.Add(SubMenuItem);

   mostrarListasCreadas(SubMenuItem);

end;

end.
