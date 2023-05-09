unit LegalBase;

interface

type
  TLegalBase = class
  private
    FCategory: string;
    FType: string;
    FStatus: string;
    procedure setCategory(const Value: string);
    procedure setType(const Value: string);
    procedure setStatus(const Value: string);
  public
    property category: string read FCategory write setCategory;
    property _type: string read FType write setType;
    property status: string read FStatus write setStatus;
    constructor Create(pCategory: string; pType: string;
      pStatus: string); overload;
  end;

implementation

procedure TLegalBase.setCategory(const Value: string);
begin
  FCategory := Value;
end;

procedure TLegalBase.setType(const Value: string);
begin
  FType := Value;
end;

procedure TLegalBase.setStatus(const Value: string);
begin
  FStatus := Value;
end;

constructor TLegalBase.Create(pCategory: string; pType: string;
  pStatus: string);
begin
  FCategory := pCategory;
  FType := pType;
  FStatus := pStatus;
end;

end.
