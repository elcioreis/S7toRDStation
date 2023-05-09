unit Settings;

interface

uses
  System.SysUtils, System.Variants, System.JSON,
  MyTools, Paths, Token;

function LoadAppSettings(pFileName: string; out pConnectionString: string;
  out pToken: TToken; out pPaths: TPaths; out pLogPath: string;
  out pSaveJsonOnError: Boolean; out pDealSource: string;
  out pStatusIdOrcamento: Integer; out pStatusIdVendaRealizada: Integer;
  out pDtEmissao: TDateTime; out pTempoEsperaMinutos: Integer): Boolean;
function LoadString(pJSONObject: TJSONObject; pTagName: string): string;
function LoadInteger(pJSONObject: TJSONObject; pTagName: string): Integer;
function LoadBoolean(pJSONObject: TJSONObject; pTagName: string): Boolean;
function LoadToken(pJSONObject: TJSONObject): TToken;
function LoadPaths(pJSONObject: TJSONObject): TPaths;
function LoadLogFolder(pJSONObject: TJSONObject): string;
function LoadDateTime(pJSONObject: TJSONObject; pTagName: string): TDateTime;

implementation

function LoadAppSettings(pFileName: string; out pConnectionString: string;
  out pToken: TToken; out pPaths: TPaths; out pLogPath: string;
  out pSaveJsonOnError: Boolean; out pDealSource: string;
  out pStatusIdOrcamento: Integer; out pStatusIdVendaRealizada: Integer;
  out pDtEmissao: TDateTime; out pTempoEsperaMinutos: Integer): Boolean;
var
  contents: string;
  vJSON: TJSONObject;
  vParseResult: Integer;
begin

  vJSON := TJSONObject.Create;

  pStatusIdOrcamento := 0;
  pStatusIdVendaRealizada := 0;

  try

    try
      contents := ReadSettings(pFileName);

      if contents <> EmptyStr then
      begin
        vParseResult := vJSON.Parse(BytesOf(contents), 0);

        if vParseResult >= 0 then
        begin
          pConnectionString := LoadString(vJSON, 'connectionString');
          pToken := LoadToken(vJSON);
          pPaths := LoadPaths(vJSON);
          pLogPath := LoadLogFolder(vJSON);
          pSaveJsonOnError := LoadBoolean(vJSON, 'saveJsonOnError');
          pDealSource := LoadString(vJSON, 'dealSource');
          pStatusIdOrcamento := LoadInteger(vJSON, 'statusIdOrcamento');
          pStatusIdVendaRealizada := LoadInteger(vJSON, 'statusIdVendaRealizada');
          pDtEmissao := LoadDateTime(vJSON, 'dataEmissao');
          pTempoEsperaMinutos := LoadInteger(vJSON, 'tempoEsperaMinutos');
          result := true;
        end
        else
        begin
          result := false;
        end;

      end
      else
      begin
        raise Exception.Create('Arquivo de configuração vazio');
      end;

    except
      result := false;
    end;
  finally
    FreeAndNil(vJSON);
  end;

end;

function LoadString(pJSONObject: TJSONObject; pTagName: string): string;
var
  vJSONPair: TJSONPair;
  vJSONEntry: TJSONValue;
begin
  try
    vJSONPair := pJSONObject.Get(pTagName);
    if (vJSONPair <> nil) then
    begin
      vJSONEntry := vJSONPair.JsonValue;
      result := vJSONEntry.Value;
    end
    else
    begin
      result := EmptyStr;
    end;
  except
    result := EmptyStr;
  end;
end;

function LoadInteger(pJSONObject: TJSONObject; pTagName: string): Integer;
var
  vJSONPair: TJSONPair;
  vJSONEntry: TJSONValue;
begin
  try
    vJSONPair := pJSONObject.Get(pTagName);
    if (vJSONPair <> nil) then
    begin
      vJSONEntry := vJSONPair.JsonValue;
      if not Int32.TryParse(vJSONEntry.Value, result) then
        result := 30;
    end
    else
    begin
      result := 30;
    end;
  except
    result := 30;
  end;
end;

function LoadBoolean(pJSONObject: TJSONObject; pTagName: string): Boolean;
var
  vJSONPair: TJSONPair;
  vJSONEntry: TJSONValue;
begin
  try
    vJSONPair := pJSONObject.Get(pTagName);
    if (vJSONPair <> nil) then
    begin
      vJSONEntry := vJSONPair.JsonValue;
      result := LowerCase(vJSONEntry.Value) = 'true';
    end
    else
    begin
      result := false;
    end;
  except
    result := false;
  end;
end;

function LoadToken(pJSONObject: TJSONObject): TToken;
const
  tagName: string = 'token';
var
  vToken: TToken;
  vJSONPair: TJSONPair;
  vJSONEntry: TJSONValue;
begin
  vToken := TToken.Create;

  try
    vJSONPair := pJSONObject.Get(tagName);
    if (vJSONPair <> nil) then
    begin
      vJSONEntry := vJSONPair.JsonValue;
      vToken.Token := vJSONEntry.Value;
      result := vToken
    end
    else
    begin
      result := vToken;
    end;
  except
    result := vToken;
  end;
end;

function LoadPaths(pJSONObject: TJSONObject): TPaths;
const
  tagName: string = 'paths';
var
  vJSONValue: TJSONValue;
  vPaths: TPaths;
begin
  vPaths := TPaths.Create;
  try
    vPaths.BaseURL := LoadString(pJSONObject, 'baseUrl');
    vJSONValue := pJSONObject.Get(tagName).JsonValue;
    vPaths.getTokenCheck := vJSONValue.GetValue<string>('v1getTokenCheck');
    vPaths.postProducts := vJSONValue.GetValue<string>('v1postProducts');
    vPaths.putProducts := vJSONValue.GetValue<string>('v1putProducts');
    vPaths.postOrganizations := vJSONValue.GetValue<string>
      ('v1postOrganizations');
    vPaths.putOrganizations := vJSONValue.GetValue<string>
      ('v1putOrganizations');
    vPaths.getContacts := vJSONValue.GetValue<string>('v1getContacts');
    vPaths.postContacts := vJSONValue.GetValue<string>('v1postContacts');
    vPaths.putContacts := vJSONValue.GetValue<string>('v1putContacts');
    vPaths.postDeals := vJSONValue.GetValue<string>('v1postDeals');
    vPaths.putDeals := vJSONValue.GetValue<string>('v1putDeals');
    vPaths.getDealProducts := vJSONValue.GetValue<string>('v1getDealProducts');
    vPaths.postDealProducts := vJSONValue.GetValue<string>
      ('v1postDealProducts');
    vPaths.deleteDealProducts := vJSONValue.GetValue<string>
      ('v1deleteDealProducts');
  finally
    result := vPaths;
  end;

end;

function LoadLogFolder(pJSONObject: TJSONObject): string;
var
  vFolder: string;
  vPath: string;
  // vFile: string;
begin
  vFolder := LoadString(pJSONObject, 'logFolder');

  if vFolder = '.' then
  begin
    vPath := ExtractFileDir(ParamStr(0));
  end
  else if Copy(vFolder, 1, 1) = '.' then
  begin
    // a partir da pasta do Executável
    vPath := ExtractFileDir(ParamStr(0)) + Copy(vFolder, 2);
  end
  else
  begin
    // local absoluto
    vPath := vFolder;
  end;

  if not DirectoryExists(vPath) then
  begin
    ForceDirectories(vPath);
  end;

  result := vPath;

  // result := vPath + '\' + vFile;

end;

function LoadDateTime(pJSONObject: TJSONObject; pTagName: String): TDateTime;
var
  vJSONPair: TJSONPair;
  vJSONEntry: TJSONValue;
  vContent: String;
  vDate: TDateTime;
  vFormatSettings: TFormatSettings;
begin
  vFormatSettings := TFormatSettings.Create('pt-BR');
  vFormatSettings.ShortDateFormat := 'dd/MM/yyyy';

  try
    vJSONPair := pJSONObject.Get(pTagName);
    if (vJSONPair <> nil) then
    begin
      vJSONEntry := vJSONPair.JsonValue;
      vContent := vJSONEntry.Value;
      vDate := StrToDateTime(vContent, vFormatSettings);
      result := vDate;
    end
    else
    begin
      result := StrToDateTime('01/08/2022', vFormatSettings);
    end;
  except
    result := StrToDateTime('01/08/2022', vFormatSettings);
  end;
end;

end.
