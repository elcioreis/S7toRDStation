unit MyDate;

interface

uses
  SysUtils;

type
  TMyDate = class
  private
    FDay: word;
    FMonth: word;
    FYear: word;
    procedure setDay(const Value: word);
    procedure setMonth(const Value: word);
    procedure setYear(const Value: word);
  public
    property day: word read FDay write setDay;
    property month: word read FMonth write setMonth;
    property year: word read FYear write setYear;
    constructor Create(pDay: integer; pMonth: integer; pYear: integer);
      overload;
    constructor Create(pDate: TDateTime); overload;
  end;

implementation

procedure TMyDate.setDay(const Value: word);
begin
  FDay := Value;
end;

procedure TMyDate.setMonth(const Value: word);
begin
  FMonth := Value;
end;

procedure TMyDate.setYear(const Value: word);
begin
  FYear := Value;
end;

constructor TMyDate.Create(pDay: integer; pMonth: integer; pYear: integer);
begin
  FDay := pDay;
  FMonth := pMonth;
  FYear := pYear;
end;

constructor TMyDate.Create(pDate: TDateTime);
begin
  DecodeDate(pDate, FYear, FMonth, FDay);
end;

end.
