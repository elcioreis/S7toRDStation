unit GetDealProducts;

interface

uses
  BaseNeon, BaseGetDealProduct;

type
  TGetDealProducts = class(TBaseNeon)
  private
    FDealProducts: TArray<TBaseGetDealProduct>;

  public
    property deal_products: TArray<TBaseGetDealProduct> read FDealProducts write FDealProducts;
  end;

implementation

end.
