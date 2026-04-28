program delphi_checklist;

uses
  Vcl.Forms,
  System.UITypes,
  Unit1 in 'Unit1.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  Unit3 in 'Unit3.pas' {dm_data: TDataModule},
  Unit2 in 'Unit2.pas' {Form2},
  Unit4 in 'Unit4.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');

  // 1) DataModule (no se muestra)
  Application.CreateForm(Tdm_data, dm_data);

  // 2) Form1 se crea PRIMERO → será MainForm (aunque no se muestre aún)
  Application.CreateForm(TForm1, Form1);

  // 3) Crear el resto
  Application.CreateForm(TForm2, Form2);

  // 4) Mostrar primero Form2 (login)
  if Form2.ShowModal = mrOk then
  begin
    // 5) Luego Form4
    Application.CreateForm(TForm4, Form4);
    Form4.ShowModal;

    // 6) Por último Form1 (ya es MainForm)
    Form1.Show;

    // 7) Arrancar el bucle de mensajes
    Application.Run;
  end
  else
    Application.Terminate;
end.

