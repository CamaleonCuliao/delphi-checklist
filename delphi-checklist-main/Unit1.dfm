object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Delphi Checklist'
  ClientHeight = 688
  ClientWidth = 1299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OnCreate = FormCreate
  TextHeight = 15
  object DBGrid1: TDBGrid
    Left = 680
    Top = 58
    Width = 611
    Height = 383
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        Width = 119
        Visible = True
      end
      item
        Expanded = False
        Width = 89
        Visible = True
      end
      item
        Expanded = False
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        Width = 107
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 625
    Height = 657
    Caption = 'Panel1'
    Color = clBackground
    ParentBackground = False
    TabOrder = 1
    object TreeView1: TTreeView
      Left = 8
      Top = 24
      Width = 609
      Height = 625
      Indent = 19
      PopupMenu = PopupMenu1
      TabOrder = 0
    end
  end
  object ToggleSwitch1: TToggleSwitch
    Left = 680
    Top = 32
    Width = 131
    Height = 20
    StateCaptions.CaptionOn = 'Claro Activo'
    StateCaptions.CaptionOff = 'Oscuro Activo'
    TabOrder = 2
    OnClick = ToggleSwitch1Click
  end
  object ListBox1: TListBox
    Left = 680
    Top = 568
    Width = 611
    Height = 97
    ItemHeight = 15
    TabOrder = 3
  end
  object MainMenu1: TMainMenu
    Left = 776
    Top = 512
  end
  object PopupMenu1: TPopupMenu
    Left = 864
    Top = 512
    object pmAnadir: TMenuItem
      Caption = 'A'#241'adir'
    end
    object pmEliminar: TMenuItem
      Caption = 'Eliminar'
    end
    object pmRenombrar: TMenuItem
      Caption = 'Renombrar'
    end
  end
end
