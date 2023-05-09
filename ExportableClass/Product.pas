unit Product;

interface

uses
  BaseNeon, BaseProduct;

type
  TProduct = class(TBaseNeon)
  private
    FToken: string;
    FProduct: TBaseProduct;
    procedure setToken(const Value: string);
    procedure setProduct(const Value: TBaseProduct);
  public
    property Token: string read FToken write setToken;
    property Product: TBaseProduct read FProduct write setProduct;
    constructor Create(pToken: string; pProduct: TBaseProduct); overload;
    constructor Create(pToken: string; pName: string; pDescription: string;
      pBasePrice: string); overload;
  end;

implementation

procedure TProduct.setToken(const Value: string);
begin
  FToken := Value;
end;

procedure TProduct.setProduct(const Value: TBaseProduct);
begin
  FProduct := Value;
end;

constructor TProduct.Create(pToken: string; pProduct: TBaseProduct);
begin
  FToken := pToken;
  FProduct := pProduct;
end;

constructor TProduct.Create(pToken: string; pName: string;
  pDescription: string; pBasePrice: string);
begin
  FToken := pToken;
  FProduct := TBaseProduct.Create(pName, pDescription, pBasePrice);
end;

end.
