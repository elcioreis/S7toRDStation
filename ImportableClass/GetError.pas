unit GetError;

interface

uses
  BaseNeon;

type
  TGetError = class(TBaseNeon)
  private
    FError: string;
    FMax: Integer;
    FUsage: Integer;
    FRemainingTime: Integer;
    procedure SetError(const Value: string);
    procedure SetMax(const Value: Integer);
    procedure SetUsage(const Value: Integer);
    procedure SetRemainingTime(const Value: Integer);
  public
    property error: string read FError write SetError;
    property max: Integer read FMax write SetMax;
    property usage: Integer read FUsage write SetUsage;
    property remaining_time: Integer read FRemainingTime write SetRemainingTime;
    {
      "error": "'lead_limiter' rate limit exceeded for 86400 second(s) period for key 'lead@example.org'",
      "max": 24,
      "usage": 25,
      "remaining_time": 43067
    }
  end;

implementation

procedure TGetError.SetError(const Value: string);
begin
  FError := Value;
end;

procedure TGetError.SetMax(const Value: Integer);
begin
  FMax := Value;
end;

procedure TGetError.SetUsage(const Value: Integer);
begin
  FUsage := Value;
end;

procedure TGetError.SetRemainingTime(const Value: Integer);
begin
  FRemainingTime := Value;
end;

end.
