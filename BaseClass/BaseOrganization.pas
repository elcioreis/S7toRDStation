unit BaseOrganization;

interface

uses
  BaseNeon, CustomFields;

type
  TBaseOrganization = class
  private
    FName: string;
    FResume: string;
    FUrl: string;
    FUserId: string;
    FOrganizationSegments: TArray<string>;
    FOrganizationCustomFields: TArray<TCustomFields>;
    procedure setName(const Value: string);
    procedure setResume(const Value: string);
    procedure setUrl(const Value: string);
    procedure setUserId(const Value: string);
    procedure setOrganizationSegments(const Value: TArray<string>);
    procedure setOrganizationCustomFields(const Value: TArray<TCustomFields>);
  public
    property name: string read FName write setName;
    property resume: string read FResume write setResume;
    property url: string read FUrl write setUrl;
    property user_id: string read FUserId write setUserId;
    property organization_segments: TArray<string> read FOrganizationSegments
      write setOrganizationSegments;
    property organization_custom_fields: TArray<TCustomFields>
      read FOrganizationCustomFields write setOrganizationCustomFields;
    constructor Create(pName: string; pResume: string; pUrl: string;
      pUserId: string; pOrganizationSegments: TArray<string>;
      pOrganizationCustomFields: TArray<TCustomFields>); overload;
  end;

implementation

procedure TBaseOrganization.setName(const Value: string);
begin
  FName := Value;
end;

procedure TBaseOrganization.setResume(const Value: string);
begin
  FResume := Value;
end;

procedure TBaseOrganization.setUrl(const Value: string);
begin
  FUrl := Value;
end;

procedure TBaseOrganization.setUserId(const Value: string);
begin
  FUserId := Value;
end;

procedure TBaseOrganization.setOrganizationSegments
  (const Value: TArray<string>);
begin
  FOrganizationSegments := Value;
end;

procedure TBaseOrganization.setOrganizationCustomFields
  (const Value: TArray<TCustomFields>);
begin
  FOrganizationCustomFields := Value;
end;

constructor TBaseOrganization.Create(pName: string; pResume: string;
  pUrl: string; pUserId: string; pOrganizationSegments: TArray<string>;
  pOrganizationCustomFields: TArray<TCustomFields>);
var
  S, I: word;
begin
  FName := pName;
  FResume := pResume;
  FUrl := pUrl;
  FUserId := pUserId;
  FOrganizationSegments := pOrganizationSegments;

  S := Length(pOrganizationCustomFields);
  SetLength(FOrganizationCustomFields, S);
  if S > 0 then
    for I := 0 to S - 1 do
      FOrganizationCustomFields[I] := pOrganizationCustomFields[I];
end;

end.
