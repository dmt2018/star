unit Globals;

interface

uses
Contnrs,Ora,StdCtrls,Classes,IniFiles;

type
  TComboRecord = class(TObject)
  Ind : Integer;
  Cont : String;
  End;

type
  TRecogniseIt = record
    Name : String;
    column : integer;
    tag: integer;
  end;

type
  TBegEnd = record
    Name : String;
    row : integer;
  end;

VAR
  INPUT_DEPT_ID : Variant;
  CUR_DEPT_ID, CUR_DEPT_NAME : Variant;
  OLD_DICT_PATH : String;
  ProgPath, def_folder, OLD_LIST_DB : String;
  ora_db_path,creator : String;
  username, password : String;
  Recogniser : array of TRecogniseIt;
  Recogniser_new : array of TRecogniseIt;
  BegEndArr : array of TBegEnd;
  DEF_SUPPLIER_ID, DEF_COUNTRY_ID : Integer;
  HIDE_MARKS : Boolean;
  ed, del, pr, add : boolean;
  procedure FillRecogniser();
  procedure FillRecogniser_new();
  procedure FillBegEndArr();
  procedure ReadIni();

implementation

uses RegExpr, SysUtils, DataModule, DB;

procedure FillBegEndArr();
Begin
  SetLength(BegEndArr,2);
  BegEndArr[0].Name := '������';
  BegEndArr[0].row := -1;
  BegEndArr[1].Name := '�����';
  BegEndArr[1].row := -1;
End;

procedure FillRecogniser_new();
var i: integer;
Begin
  SetLength(Recogniser_new,41);
  Recogniser_new[0].Name := '� ������';
  Recogniser_new[0].column := -1;
  Recogniser_new[0].tag := 0;

  Recogniser_new[1].Name := '�������';
  Recogniser_new[1].column := -1;
  Recogniser_new[1].tag := 8;

  Recogniser_new[2].Name := '���';
  Recogniser_new[2].column := -1;
  Recogniser_new[2].tag := 30;

  Recogniser_new[3].Name := '��� (����)';
  Recogniser_new[3].column := -1;
  Recogniser_new[3].tag := 31;

  Recogniser_new[4].Name := '���������� ������';
  Recogniser_new[4].column := -1;
  Recogniser_new[4].tag := 12;

  Recogniser_new[5].Name := '�������';
  Recogniser_new[5].column := -1;
  Recogniser_new[5].tag := 36;

  Recogniser_new[6].Name := '�������� ���. �����';
  Recogniser_new[6].column := -1;
  Recogniser_new[6].tag := 15;

  Recogniser_new[7].Name := '������';
  Recogniser_new[7].column := -1;
  Recogniser_new[7].tag := 29;

  Recogniser_new[8].Name := '��� ��������';
  Recogniser_new[8].column := -1;
  Recogniser_new[8].tag := 14;

  Recogniser_new[9].Name := '���. � �������';
  Recogniser_new[9].column := -1;
  Recogniser_new[9].tag := 4;

  Recogniser_new[10].Name := '���. �������';
  Recogniser_new[10].column := -1;
  Recogniser_new[10].tag := 3;

  Recogniser_new[11].Name := '����� ������';
  Recogniser_new[11].column := -1;
  Recogniser_new[11].tag := 35;

  Recogniser_new[12].Name := '������';
  Recogniser_new[12].column := -1;
  Recogniser_new[12].tag := 28;

  Recogniser_new[13].Name := '�������� ��� ���������';
  Recogniser_new[13].column := -1;
  Recogniser_new[13].tag := 17;

  Recogniser_new[14].Name := '�������� ������';
  Recogniser_new[14].column := -1;
  Recogniser_new[14].tag := 1;

  Recogniser_new[15].Name := '�������� ������';
  Recogniser_new[15].column := -1;
  Recogniser_new[15].tag := 9;

  Recogniser_new[16].Name := '�������';
  Recogniser_new[16].column := -1;
  Recogniser_new[16].tag := 32;

  Recogniser_new[17].Name := '����� �������';
  Recogniser_new[17].column := -1;
  Recogniser_new[17].tag := 2;

  Recogniser_new[18].Name := '����� ���.';
  Recogniser_new[18].column := -1;
  Recogniser_new[18].tag := 5;

  Recogniser_new[19].Name := '�������� ���. �����';
  Recogniser_new[19].column := -1;
  Recogniser_new[19].tag := 16;

  Recogniser_new[20].Name := '�������';
  Recogniser_new[20].column := -1;
  Recogniser_new[20].tag := 19;

  Recogniser_new[21].Name := '���������';
  Recogniser_new[21].column := -1;
  Recogniser_new[21].tag := 7;

  Recogniser_new[22].Name := '�������';
  Recogniser_new[22].column := -1;
  Recogniser_new[22].tag := 20;

  Recogniser_new[23].Name := '����.�����������';
  Recogniser_new[23].column := -1;
  Recogniser_new[23].tag := 37;

  Recogniser_new[24].Name := '����� ������';
  Recogniser_new[24].column := -1;
  Recogniser_new[24].tag := 33;

  Recogniser_new[25].Name := '������� � �����';
  Recogniser_new[25].column := -1;
  Recogniser_new[25].tag := 38;

  Recogniser_new[26].Name := '������';
  Recogniser_new[26].column := -1;
  Recogniser_new[26].tag := 34;

  Recogniser_new[27].Name := '�����';
  Recogniser_new[27].column := -1;
  Recogniser_new[27].tag := 11;

  Recogniser_new[28].Name := '��� ��������';
  Recogniser_new[28].column := -1;
  Recogniser_new[28].tag := 6;

  Recogniser_new[29].Name := '�������';
  Recogniser_new[29].column := -1;
  Recogniser_new[29].tag := 27;

  Recogniser_new[30].Name := '����';
  Recogniser_new[30].column := -1;
  Recogniser_new[30].tag := 13;

  Recogniser_new[31].Name := '����';
  Recogniser_new[31].column := -1;
  Recogniser_new[31].tag := 10;

  Recogniser_new[32].Name := '�����-���';
  Recogniser_new[32].column := -1;
  Recogniser_new[32].tag := 18;

  Recogniser_new[33].Name := 'S20 �����';
  Recogniser_new[33].column := -1;
  Recogniser_new[33].tag := 21;

  Recogniser_new[34].Name := 'S22 ���. �����';
  Recogniser_new[34].column := -1;
  Recogniser_new[34].tag := 22;

  Recogniser_new[35].Name := 'S25 ���. ����� ����.';
  Recogniser_new[35].column := -1;
  Recogniser_new[35].tag := 23;

  Recogniser_new[36].Name := 'VD2 ���-�� � �������';
  Recogniser_new[36].column := -1;
  Recogniser_new[36].tag := 24;

  Recogniser_new[37].Name := 'S01 ������� ������';
  Recogniser_new[37].column := -1;
  Recogniser_new[37].tag := 25;

  Recogniser_new[38].Name := 'S02 ������ ������';
  Recogniser_new[38].column := -1;
  Recogniser_new[38].tag := 26;

  Recogniser_new[39].Name := '������� ����������';
  Recogniser_new[39].column := -1;
  Recogniser_new[39].tag := 39;

  Recogniser_new[40].Name := '������';
  Recogniser_new[40].column := -1;
  Recogniser_new[40].tag := 40;
End;


procedure FillRecogniser();
var i: integer;
Begin
  SetLength(Recogniser,39);
  Recogniser[0].Name := '� ������';
  Recogniser[0].column := -1;
  Recogniser[1].Name := '�������� ������';
  Recogniser[1].column := -1;
  Recogniser[2].Name := '����� �������';
  Recogniser[2].column := -1;
  Recogniser[3].Name := '���. �������';
  Recogniser[3].column := -1;
  Recogniser[4].Name := '���. � �������';
  Recogniser[4].column := -1;
  Recogniser[5].Name := '����� ���.';
  Recogniser[5].column := -1;
  Recogniser[6].Name := '��� ��������';
  Recogniser[6].column := -1;
  Recogniser[7].Name := '���������';
  Recogniser[7].column := -1;
  Recogniser[8].Name := '�������';
  Recogniser[8].column := -1;
  Recogniser[9].Name := '�������� ������';
  Recogniser[9].column := -1;
  Recogniser[10].Name := '����';
  Recogniser[10].column := -1;
  Recogniser[11].Name := '�����';
  Recogniser[11].column := -1;
  Recogniser[12].Name := '���������� ������';
  Recogniser[12].column := -1;
  Recogniser[13].Name := '����';
  Recogniser[13].column := -1;
  Recogniser[14].Name := '��� ��������';
  Recogniser[14].column := -1;
  Recogniser[15].Name := '�������� ���. �����';
  Recogniser[15].column := -1;
  Recogniser[16].Name := '�������� ���. �����';
  Recogniser[16].column := -1;
  Recogniser[17].Name := '�������� ��� ���������';
  Recogniser[17].column := -1;
  Recogniser[18].Name := '�����-���';
  Recogniser[18].column := -1;
  Recogniser[19].Name := '�������';
  Recogniser[19].column := -1;
  Recogniser[20].Name := '�������';
  Recogniser[20].column := -1;
  Recogniser[21].Name := '����� (S20)';
  Recogniser[21].column := -1;
  Recogniser[22].Name := '���. ����� (S22)';
  Recogniser[22].column := -1;
  Recogniser[23].Name := '���. ����� ����. (S25)';
  Recogniser[23].column := -1;
  Recogniser[24].Name := '���-�� � ������� (VD2)';
  Recogniser[24].column := -1;
  Recogniser[25].Name := '������� ������ (S01)';
  Recogniser[25].column := -1;
  Recogniser[26].Name := '������ ������ (S02)';
  Recogniser[26].column := -1;
  Recogniser[27].Name := '�������';
  Recogniser[27].column := -1;
  Recogniser[28].Name := '������';
  Recogniser[28].column := -1;
  Recogniser[29].Name := '������';
  Recogniser[29].column := -1;
  Recogniser[30].Name := '���';
  Recogniser[30].column := -1;
  Recogniser[31].Name := '��� (����)';
  Recogniser[31].column := -1;
  Recogniser[32].Name := '�������';
  Recogniser[32].column := -1;
  Recogniser[33].Name := '����� ������';
  Recogniser[33].column := -1;
  Recogniser[34].Name := '������';
  Recogniser[34].column := -1;
  Recogniser[35].Name := '����� ������';
  Recogniser[35].column := -1;
  Recogniser[36].Name := '�������';
  Recogniser[36].column := -1;
  Recogniser[37].Name := '����.�����������';
  Recogniser[37].column := -1;
  Recogniser[38].Name := '������� � �����';
  Recogniser[38].column := -1;

End;

procedure ReadIni();
VAR
  Ini : TIniFile;
Begin
  ProgPath := GetCurrentDir;
  Ini := TIniFile.Create(ProgPath + '\connections\Paths.ini' );
  try
    OLD_DICT_PATH := Ini.ReadString('paths','OldDict','???');
    def_folder    := Ini.ReadString('folder', 'Value', '..');
    OLD_LIST_DB   := Ini.ReadString('list','value','???');
  finally
    Ini.Free;
  end;
{
  with DM.SelQ do
    Begin
      SQL.Clear;
      SQL.Add('SELECT * FROM PERSONAL_SETTINGS WHERE DB_USER=USER AND HIDE_MARKS=1');
      Open;
      if IsEmpty then
        Begin
          HIDE_MARKS:=false;
          DM.InvoiceData.SQL.LoadFromFile(ProgPath + '\SQL\SelInvDatMarks.sql');
        End
      else
        Begin
          HIDE_MARKS:=true;
          DM.InvoiceData.SQL.LoadFromFile(ProgPath + '\SQL\SelInvDatNoMarks.sql');
        End;
    End;
}    
End;

end.
