unit Response;

interface

uses BaseNeon;

type
  TResponse = class(TBaseNeon)
  private
    FId: string;
    FCreatedAt: string;
    FUpdatedAt: string;
    procedure setId(const Value: string);
    procedure setCreatedAt(const Value: string);
    procedure setUpdatedAt(const Value: string);
  public
    property _id: string read FId write setId;
    property created_at: string read FCreatedAt write setCreatedAt;
    property updated_at: string read FUpdatedAt write setUpdatedAt;
  end;

implementation

procedure TResponse.setId(const Value: string);
begin
  FId := Value;
end;

procedure TResponse.setCreatedAt(const Value: string);
begin
  FCreatedAt := Value;
end;

procedure TResponse.setUpdatedAt(const Value: string);
begin
  FUpdatedAt := Value;
end;

end.
