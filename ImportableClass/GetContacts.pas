unit GetContacts;

interface

uses
  BaseNeon, BaseGetContact;

type
  TGetContacts = class(TBaseNeon)
  private
    FTotal: Integer;
    FHasMore: Boolean;
    FContacts: TArray<TBaseGetContact>;
    procedure setTotal(const Value: Integer);
    procedure setHasMore(const Value: Boolean);
    procedure setContacts(const Value: TArray<TBaseGetContact>);
  public
    property total: Integer read FTotal write setTotal;
    property hasMore: Boolean read FHasMore write setHasMore;
    property contacts: TArray<TBaseGetContact> read FContacts write setContacts;
  end;

implementation

procedure TGetContacts.setTotal(const Value: Integer);
begin
  FTotal := Value;
end;

procedure TGetContacts.setHasMore(const Value: Boolean);
begin
  FHasMore := Value;
end;

procedure TGetContacts.setContacts(const Value: TArray<TBaseGetContact>);
begin
  FContacts := Value;
end;

end.
