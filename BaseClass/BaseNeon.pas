unit BaseNeon;

interface

uses
  System.Classes, System.SysUtils, System.JSON,
  Neon.Core.Persistence,
  Neon.Core.Types,
  Neon.Core.Persistence.JSON;

type
  TSerializersType = (CustomNeon, CustomDemo);
  TSerializersSet = set of TSerializersType;

type
  TBaseNeon = class
  private
    procedure SerializeObject(AObject: TObject; out AWhere: String);
    function BuildConfig: INeonConfiguration;
    function BuildSerializerConfig(ASerializers: TSerializersSet)
      : INeonConfiguration;
  public
    function Serialize: string;
    procedure Deserialize(AWhere: String);
  end;

implementation

function TBaseNeon.Serialize: string;
var
  vTexto: string;
begin
  SerializeObject(self, vTexto);
  result := vTexto;
end;

procedure TBaseNeon.SerializeObject(AObject: TObject; out AWhere: String);
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

procedure TBaseNeon.Deserialize(AWhere: String);
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
      LReader.JSONToObject(Self, LJSON);
    finally
      LReader.Free;
    end;
  finally
    LJSON.Free;
  end;

end;

function TBaseNeon.BuildConfig: INeonConfiguration;
begin
  result := BuildSerializerConfig([TSerializersType.CustomNeon,
    TSerializersType.CustomDemo]);
end;

function TBaseNeon.BuildSerializerConfig(ASerializers: TSerializersSet)
  : INeonConfiguration;
begin
  result := TNeonConfiguration.Default;
  // Case settings
  result.SetMemberCustomCase(nil);
  result.SetMemberCase(TNeonCase.CamelCase);
  result.SetPrettyPrint(true);
end;

end.
