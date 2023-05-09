unit DealProduct;

interface

uses
  BaseNeon;

type
  TDealProduct = class(TBaseNeon)
  private
    FToken: string;
    FProductId: string;
    FPrice: Double;
    FAmount: Double;
    procedure setToken(const Value: string);
    procedure setProductId(const Value: string);
    procedure setPrice(const Value: Double);
    procedure setAmount(const Value: Double);
  public
    property token: string read FToken write setToken;
    property product_id: string read FProductId write setProductId;
    property price: Double read FPrice write setPrice;
    property amount: Double read FAmount write setAmount;
    constructor Create(pToken: string; pProductId: string; pPrice: Double;
      pAmount: Double);
  end;

implementation

procedure TDealProduct.setToken(const Value: string);
begin
  FToken := Value;
end;

procedure TDealProduct.setProductId(const Value: string);
begin
  FProductId := Value;
end;

procedure TDealProduct.setPrice(const Value: Double);
begin
  FPrice := Value;
end;

procedure TDealProduct.setAmount(const Value: Double);
begin
  FAmount := Value;
end;

constructor TDealProduct.Create(pToken: string; pProductId: string;
  pPrice: Double; pAmount: Double);
begin
  token := pToken;
  product_id := pProductId;
  price := pPrice;
  amount := pAmount;
end;

end.
