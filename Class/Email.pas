unit Email;

interface

type
  TEmail = class
  private
    FEmail: string;
    procedure setEmail(const Value: string);
  public
    property Email: string read FEmail write setEmail;
    constructor Create(pEmail: string);
  end;

implementation

procedure TEmail.setEmail(const Value: string);
begin
  FEmail := Value;
end;

constructor TEmail.Create(pEmail: string);
begin
  FEmail := pEmail;
end;

end.
