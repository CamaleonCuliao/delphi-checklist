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
  Application.CreateForm(Tdm_data, dm_data);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);

  if Form2.ShowModal = mrOk then
  begin
    Application.CreateForm(TForm4, Form4);
    if Form4.ShowModal = mrOk then
    begin
      // ← AÑADIR: recargar el menú con las listas del proyecto seleccionado
      Form1.RecargarMenuListas;
      Form1.insertarLista('');
      Form1.Show;
      Application.Run;
    end
    else
      Application.Terminate;
  end
  else
    Application.Terminate;
end.

