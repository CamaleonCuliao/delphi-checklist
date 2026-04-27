program delphi_checklist;

uses
  Vcl.Forms,
  System.UITypes,
  Unit1 in 'Unit1.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  Unit3 in 'Unit3.pas' {dm_data: TDataModule},
  Unit2 in 'Unit2.pas' {Form2};

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
    Form1.Show;
    Application.Run;
  end
  else
    Application.Terminate;
end.
