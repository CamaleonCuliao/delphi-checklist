program delphi_checklist;

uses
  Vcl.Forms,
  Unit1 in '..\Unit1.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  Unit3 in 'Unit3.pas' {dm_data: TDataModule},
  Unit2 in 'Unit2.pas' {dm_logic: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(Tdm_data, dm_data);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tdm_logic, dm_logic);
  Application.Run;
end.
