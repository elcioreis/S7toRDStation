unit BaseGetDealProduct;

interface

uses
  BaseNeon;

type
  TBaseGetDealProduct = class
  private
    FId: string;
    FProductId: string;
    FName: string;
    FDescription: string;
    FPrice: Double;
    FAmount: Double;
    procedure setFId(const Value: string);
    procedure setProductId(const Value: string);
    procedure setName(const Value: string);
    procedure setDescription(const Value: string);
    procedure setPrice(const Value: Double);
    procedure setAmount(const Value: Double);
  public
    property id: string read FId write setFId;
    property product_id: string read FProductId write setProductId;
    property name: string read FName write setName;
    property description: string read FDescription write setDescription;
    property price: Double read FPrice write setPrice;
    property amount: Double read FAmount write setAmount;
  end;

implementation

procedure TBaseGetDealProduct.setFId(const Value: string);
begin
  FId := Value;
end;

procedure TBaseGetDealProduct.setProductId(const Value: string);
begin
  FProductId := Value;
end;

procedure TBaseGetDealProduct.setName(const Value: string);
begin
  FName := Value;
end;

procedure TBaseGetDealProduct.setDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TBaseGetDealProduct.setPrice(const Value: Double);
begin
  FPrice := Value;
end;

procedure TBaseGetDealProduct.setAmount(const Value: Double);
begin
  FAmount := Value;
end;

end.
