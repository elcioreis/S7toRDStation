unit BaseProduct;

interface

uses
  BaseNeon;

type
  TBaseProduct = class
  private
    FName: string;
    FDescription: string;
    FBasePrice: string;
    procedure setName(const Value: string);
    procedure setDescription(const Value: string);
    procedure setBasePrice(const Value: string);
  public
    property name: string read FName write setName;
    property description: string read FDescription write setDescription;
    property base_price: string read FBasePrice write setBasePrice;
    constructor Create(pName: string; pDescription: string;
      pBasePrice: string); overload;
  end;

implementation

procedure TBaseProduct.setName(const Value: string);
begin
  FName := Value;
end;

procedure TBaseProduct.setDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TBaseProduct.setBasePrice(const Value: string);
begin
  FBasePrice := Value;
end;

constructor TBaseProduct.Create(pName: string; pDescription: string;
  pBasePrice: string);
begin
  FName := pName;
  FDescription := pDescription;
  FBasePrice := pBasePrice;
end;

end.
