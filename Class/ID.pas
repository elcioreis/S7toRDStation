unit ID;

interface

type
  TId = class
  private
    FId: string;
    procedure setID(const Value: string);
  public
    property _id: string read FId write setID;
    constructor Create(pId: string); overload;
  end;

implementation

procedure TId.setID(const Value: string);
begin
  FId := Value;
end;

constructor TId.Create(pId: string);
begin
  FId := pId;
end;

end.
