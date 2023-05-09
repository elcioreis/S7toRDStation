unit Organization;

interface

uses
  BaseNeon, BaseOrganization, CustomFields;

type
  TOrganization = class(TBaseNeon)
  private
    FToken: string;
    FOrganization: TBaseOrganization;
    procedure setToken(const Value: string);
    procedure setOrganization(const Value: TBaseOrganization);
  public
    property token: string read FToken write setToken;
    property Organization: TBaseOrganization read FOrganization
      write setOrganization;
    constructor Create(pToken: string; pName: string; pResume: string;
      pUrl: string; pUserId: string; pOrganizationSegments: TArray<string>;
      pOrganizationCustomFields: TArray<TCustomFields>); overload;
  end;

implementation

procedure TOrganization.setToken(const Value: string);
begin
  FToken := Value;
end;

procedure TOrganization.setOrganization(const Value: TBaseOrganization);
begin
  FOrganization := Value;
end;

constructor TOrganization.Create(pToken: string; pName: string; pResume: string;
  pUrl: string; pUserId: string; pOrganizationSegments: TArray<string>;
  pOrganizationCustomFields: TArray<TCustomFields>);
begin
  FToken := pToken;
  FOrganization := TBaseOrganization.Create(pName, pResume, pUrl, pUserId,
    pOrganizationSegments, pOrganizationCustomFields);
end;

end.
