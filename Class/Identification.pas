unit Identification;

interface

uses
//  System.SysUtils, System.Classes, System.JSON, REST.JSON,
//  MyTools,
  System.SysUtils, BaseNeon;

type
  TIdentification = class(TBaseNeon)
  private
    FName: string;
    FEmail: string;
    FOrganization: string;
    procedure setName(const Value: string);
    procedure setEmail(const Value: string);
    procedure setOrganization(const Value: string);
  public
    property name: string read FName write setName;
    property email: string read FEmail write setEmail;
    property organization: string read FOrganization write setOrganization;
    function Valid: Boolean;
  end;

implementation

procedure TIdentification.setName(const Value: string);
begin
  FName := Value
end;

procedure TIdentification.setEmail(const Value: string);
begin
  FEmail := Value
end;

procedure TIdentification.setOrganization(const Value: string);
begin
  FOrganization := Value
end;

function TIdentification.Valid: Boolean;
begin

  result := (self.FName <> EmptyStr) and (self.FEmail <> EmptyStr) and
    (self.FOrganization <> EmptyStr);

end;

end.
