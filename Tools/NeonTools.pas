unit NeonTools;

interface

uses
  System.Classes, System.SysUtils, System.JSON,
  Neon.Core.Persistence,
  Neon.Core.Types,
  Neon.Core.Persistence.JSON;

type
  TSerializersType = (CustomNeon, CustomDemo);
  TSerializersSet = set of TSerializersType;

procedure DeserializeObject(AObject: TObject; AWhere: string);
procedure SerializeObject(AObject: TObject; out AWhere: String);

function BuildConfig: INeonConfiguration;
function BuildSerializerConfig(ASerializers: TSerializersSet)
  : INeonConfiguration;

implementation

procedure DeserializeObject(AObject: TObject; AWhere: string);
var
  LJSON: TJSONValue;
  LReader: TNeonDeserializerJSON;
  AConfig: INeonConfiguration;
begin

  AConfig := BuildConfig;

  LJSON := TJSONObject.ParseJSONValue(AWhere);
  if not Assigned(LJSON) then
    raise Exception.Create('Error parsing JSON string');

  try
    LReader := TNeonDeserializerJSON.Create(AConfig);
    try
      LReader.JSONToObject(AObject, LJSON);
    finally
      LReader.Free;
    end;
  finally
    LJSON.Free;
  end;

end;

procedure SerializeObject(AObject: TObject; out AWhere: String);
var
  LJSON: TJSONValue;
  LWriter: TNeonSerializerJSON;
  AConfig: INeonConfiguration;
begin
  AConfig := BuildConfig;

  LWriter := TNeonSerializerJSON.Create(AConfig);
  try
    LJSON := LWriter.ObjectToJSON(AObject);
    try
      AWhere := TNeon.Print(LJSON, AConfig.GetPrettyPrint);
    finally
      LJSON.Free;
    end;
  finally
    LWriter.Free;
  end;
end;

function BuildConfig: INeonConfiguration;
begin
  Result := BuildSerializerConfig([TSerializersType.CustomNeon,
    TSerializersType.CustomDemo]);
end;

function BuildSerializerConfig(ASerializers: TSerializersSet)
  : INeonConfiguration;
begin
  Result := TNeonConfiguration.Default;
  // Case settings
  Result.SetMemberCustomCase(nil);
  Result.SetMemberCase(TNeonCase.CamelCase);
  Result.SetPrettyPrint(true);
end;

end.
