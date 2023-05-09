unit Phone;

interface

type
  TPhone = class
  private
    FPhone: string;
    procedure setPhone(const Value: string);
  public
    property Phone: string read FPhone write setPhone;
    constructor Create(pPhone: string);
  end;

implementation

procedure TPhone.setPhone(const Value: string);
begin
  FPhone := Value;
end;

constructor TPhone.Create(pPhone: string);
begin
  FPhone := pPhone;
end;

end.
