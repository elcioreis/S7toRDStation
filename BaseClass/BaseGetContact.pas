unit BaseGetContact;

interface

uses
  BaseNeon, MyDate, LegalBase, Email, Phone;

type
  TBaseGetContact = class
  private
    FId: string;
    FOrganizationId: string;
    FCreatedAt: string;
    FUpdatedAt: string;
    procedure setId(const Value: string);
    procedure setOrganizationId(const Value: string);
    procedure setCreatedAt(const Value: string);
    procedure setUpdatedAt(const Value: string);
  public
    property id: string read FId write setId;
    property organization_id: string read FOrganizationId write setOrganizationId;
    property created_at: string read FCreatedAt write setCreatedAt;
    property updated_at: string read FUpdatedAt write setUpdatedAt;
  end;

implementation

procedure TBaseGetContact.setId(const Value: string);
begin
  FId := Value;
end;

procedure TBaseGetContact.setOrganizationId(const Value: string);
begin
  FOrganizationId := Value;
end;

procedure TBaseGetContact.setCreatedAt(const Value: string);
begin
  FCreatedAt := Value;
end;

procedure TBaseGetContact.setUpdatedAt(const Value: string);
begin
  FUpdatedAt := Value;
end;

end.
