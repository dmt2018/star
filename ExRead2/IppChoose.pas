unit IppChoose;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, PI_library, Menus,
  cxLookAndFeelPainters, cxButtons, ExtCtrls, cxGraphics, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxImageComboBox, DB;

type
  TIppChooseF = class(TForm)
    sb_ins: TSpeedButton;
    sb_del: TSpeedButton;
    Panel1: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    cb_packs: TcxImageComboBox;
    procedure sb_insClick(Sender: TObject);
    procedure sb_delClick(Sender: TObject);
  private
    { Private declarations }
    procedure FillCombos;
  public
    { Public declarations }
  end;

function GetIPP_ID() : integer;

var
  IppChooseF: TIppChooseF;

implementation

uses DataModule, NewSomethingU;

{$R *.dfm}


//
//  ��������� ���������� ������
//
procedure TIppChooseF.FillCombos;
Begin
  try
    DM.SelQ.Close;
    DM.SelQ.SQL.Clear;
    DM.SelQ.SQL.Add('begin INVOICE_PKG.get_ipp_list(:v_office, :cursor_); end;');
    DM.SelQ.ParamByName('v_office').AsInteger := dm.id_office;
    DM.SelQ.ParamByName('cursor_').DataType   := ftCursor;
    DM.SelQ.Open;
    FillImgComboCx(DM.SelQ, cb_packs, '');
    DM.SelQ.Close;
  except
    on E: Exception do MessageBox(Handle,PChar('�������� ������'+#10+E.Message),'������',MB_ICONERROR);
  End;
End;


//
//  �������� �� �����
//
function GetIPP_ID() : integer;
Begin
  try
    Application.CreateForm(TIppChooseF, IppChooseF);
    with IppChooseF do
    Begin
      FillCombos;
      if ShowModal <> mrOk then result := -1
                           else result := cb_packs.EditValue; // ReadComboEx(ComboBoxEx1);
    End;
  finally
    IppChooseF.Free;
  end;
End;



//
//  ��������� ����� �����
//
procedure TIppChooseF.sb_insClick(Sender: TObject);
VAR
  IPPName : string;
  IPP_ID : Integer;
begin
  if not NewSomethingF.GetSomething('�������� ����� ��������',256,IPPName) then exit;

  try
    with DM.SelQ do
    Begin
       Close;
       SQL.Clear;
       SQL.Add('begin INVOICE_PKG.ADD_PRICE_PACK(:IPP_COMMENT_, :IN_ID_); end;');
       ParamByName('IPP_COMMENT_').AsString := IPPName;
       ParamByName('IN_ID_').AsInteger      := 0;
       Execute;
       IPP_ID := ParamByName('IN_ID_').Value;
       FillCombos;
       cb_packs.EditValue := IPP_ID;
    End;
  except
    on E: Exception do MessageBox(Handle,PChar('�������� ������'+#10+E.Message),'������',MB_ICONERROR);
  End;
end;


//
//  ������� �����
//
procedure TIppChooseF.sb_delClick(Sender: TObject);
VAR
  IPP_ID : Integer;
begin
  IPP_ID := cb_packs.EditValue;

  if (MessageDlg('������� ������?',  mtConfirmation, [mbOk, mbNo], 1) = mrOk) then
  begin
    if (IPP_ID > 0) then
    begin
      try
        with DM.SelQ do
        Begin
          Close;
          SQL.Clear;
          SQL.Add('begin INVOICE_PKG.DEL_PRICE_PACK(:IPP_ID_); end;');
          ParamByName('IPP_ID_').AsInteger := IPP_ID;
          Execute;
          FillCombos;
        End;
      except
        on E: Exception do MessageBox(Handle,PChar('�������� ������'+#10+E.Message),'������',MB_ICONERROR);
      End;
    end;
  end;

end;


end.
