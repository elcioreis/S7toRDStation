unit DealProducts;

interface

uses
  BaseNeon;

type
  TDealProducts = class(TBaseNeon)
  private
    FToken: string;
    FProductId: string;
    FPrice: double;
    FAmount: double;
    procedure setToken(const Value: string);
    procedure setProductId(const Value: string);
    procedure setPrice(const Value: double);
    procedure setAmount(const Value: double);
  public
    property token: string read FToken write setToken;
    property product_id: string read FProductId write setProductId;
    property price: double read FPrice write setPrice;
    property amount: double read FAmount write setAmount;
    constructor Create(pToken: string; pProductId: string; pPrice: double;
      pAmount: double);
  end;

implementation

procedure TDealProducts.setToken(const Value: string);
begin
  FToken := Value;
end;

procedure TDealProducts.setProductId(const Value: string);
begin
  FProductId := Value;
end;

procedure TDealProducts.setPrice(const Value: double);
begin
  FPrice := Value;
end;

procedure TDealProducts.setAmount(const Value: double);
begin
  FAmount := Value;
end;

constructor TDealProducts.Create(pToken: string; pProductId: string;
  pPrice: double; pAmount: double);
begin
  token := pToken;
  product_id := pProductId;
  price := pPrice;
  amount := pAmount;
end;

end.
