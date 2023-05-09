unit ResponseProduct;

interface

uses
  BaseNeon;

type
  TResponseProduct = class(TBaseNeon)
  private
    FId: string;
    FName: string;
    FDescription: string;
    FVisible: string;
    FBasePrice: string;
    FCreatedAt: string;
    FUpdatedAt: string;
    procedure setId(const Value: string);
    procedure setName(const Value: string);
    procedure setDescription(const Value: string);
    procedure setVisible(const Value: string);
    procedure setBasePrice(const Value: string);
    procedure setCreatedAt(const Value: string);
    procedure setUpdatedAt(const Value: string);
  public
    property _id : string read FId write setId;
    property name: string read FName write setName;
    property description: string read FDescription write setDescription;
    property visible: string read FVisible write setVisible;
    property base_price: string read FBasePrice write setBasePrice;
    property created_at: string read FCreatedAt write setCreatedAt;
    property updated_at: string read FUpdatedAt write setUpdatedAt;
  end;

implementation

procedure TResponseProduct.setId(const Value: string);
begin
  FId := Value;
end;

procedure TResponseProduct.setName(const Value: string);
begin
  FName := Value;
end;

procedure TResponseProduct.setDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TResponseProduct.setVisible(const Value: string);
begin
  FVisible := Value;
end;

procedure TResponseProduct.setBasePrice(const Value: string);
begin
  FBasePrice := Value;
end;

procedure TResponseProduct.setCreatedAt(const Value: string);
begin
  FCreatedAt := Value;
end;

procedure TResponseProduct.setUpdatedAt(const Value: string);
begin
  FUpdatedAt := Value;
end;


end.
