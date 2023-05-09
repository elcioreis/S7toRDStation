unit MyTools;

interface

uses SysUtils, System.Classes, Vcl.Forms, Vcl.StdCtrls,
  System.Threading;

function GetFileWithPath(fileName: string): string;
function ReadSettings(fileName: string): string;
procedure InsertMemo(pMemo: TMemo; pMessage: string);
function FoneValido(pFone: string): boolean;

implementation

function GetFileWithPath(fileName: string): string;
begin

  result := ExtractFileDir(ParamStr(0)) + '\' + fileName;

end;

function ReadSettings(fileName: string): string;
var
  fullFileName: string;
  contents: TStringList;
begin

  contents := TStringList.Create;

  try

    fullFileName := GetFileWithPath(fileName);

    if not FileExists(fullFileName) then
      Exit;

    contents.LoadFromFile(fullFileName);

  finally
    result := contents.Text;
  end;

end;

procedure InsertMemo(pMemo: TMemo; pMessage: string);
var
  vFile: string;
begin

  // Uso o Hint para armazenar o nome do arquivo de log
  vFile := pMemo.Hint;

  pMemo.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' ' + pMessage);
  Application.ProcessMessages;

  if vFile <> EmptyStr then
  begin
    pMemo.Lines.SaveToFile(vFile);
    Application.ProcessMessages;
  end;

end;

function FoneValido(pFone: string): boolean;
var
  vTexto: string;
begin

  vTexto := StringReplace(pFone, '(', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, ')', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, '-', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, ' ', '', [rfReplaceAll]);

  vTexto := Trim(vTexto);

  result := vTexto <> EmptyStr;

end;

end.
