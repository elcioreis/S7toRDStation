unit Paths;

interface

type
  TPaths = class
  private
    FBaseURL: string;
    FgetTokenCheck: string;
    FpostProducts: string;
    FputProducts: string;
    FpostOrganizations: string;
    FputOrganizations: string;
    FgetContacts: string;
    FpostContacts: string;
    FputContacts: string;
    FpostDeals: string;
    FputDeals: string;
    FgetDealProducts: string;
    FpostDealProducts: string;
    FdeleteDealProducts: string;
    procedure setBaseURL(const Value: string);
    procedure setGetTokenCheck(const Value: string);
    procedure setPostProducts(const Value: string);
    procedure setPutProducts(const Value: string);
    procedure setPostOrganizations(const Value: string);
    procedure setPutOrganizations(const Value: string);
    procedure setGetContacts(const Value: string);
    procedure setPostContacts(const Value: string);
    procedure setPutContacts(const Value: string);
    procedure setPostDeals(const Value: string);
    procedure setPutDeals(const Value: string);
    procedure setGetDealProducts(const Value: string);
    procedure setPostDealProducts(const Value: string);
    procedure setDeleteDealProducts(const Value: string);
  public
    property BaseURL: string read FBaseURL write setBaseURL;
    property getTokenCheck: string read FgetTokenCheck write setGetTokenCheck;
    property postProducts: string read FpostProducts write setPostProducts;
    property putProducts: string read FputProducts write setPutProducts;
    property postOrganizations: string read FpostOrganizations
      write setPostOrganizations;
    property putOrganizations: string read FputOrganizations
      write setPutOrganizations;
    property getContacts: string read FgetContacts write setGetContacts;
    property postContacts: string read FpostContacts write setPostContacts;
    property putContacts: string read FputContacts write setPutContacts;
    property postDeals: string read FpostDeals write setPostDeals;
    property putDeals: string read FputDeals write setPutDeals;
    property getDealProducts: string read FgetDealProducts
      write setGetDealProducts;
    property postDealProducts: string read FpostDealProducts
      write setPostDealProducts;
    property deleteDealProducts: string read FdeleteDealProducts write setDeleteDealProducts;
  end;

implementation

procedure TPaths.setBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TPaths.setGetTokenCheck(const Value: string);
begin
  FgetTokenCheck := Value;
end;

procedure TPaths.setPostProducts(const Value: string);
begin
  FpostProducts := Value;
end;

procedure TPaths.setPutProducts(const Value: string);
begin
  FputProducts := Value;
end;

procedure TPaths.setPostOrganizations(const Value: string);
begin
  FpostOrganizations := Value;
end;

procedure TPaths.setPutOrganizations(const Value: string);
begin
  FputOrganizations := Value;
end;

procedure TPaths.setGetContacts(const Value: string);
begin
  FgetContacts := Value;
end;

procedure TPaths.setPostContacts(const Value: string);
begin
  FpostContacts := Value;
end;

procedure TPaths.setPutContacts(const Value: string);
begin
  FputContacts := Value;
end;

procedure TPaths.setPostDeals(const Value: string);
begin
  FpostDeals := Value;
end;

procedure TPaths.setPutDeals(const Value: string);
begin
  FputDeals := Value;
end;

procedure TPaths.setGetDealProducts(const Value: string);
begin
  FgetDealProducts := Value;
end;

procedure TPaths.setPostDealProducts(const Value: string);
begin
  FpostDealProducts := Value;
end;

procedure TPaths.setDeleteDealProducts(const Value: string);
begin
  FdeleteDealProducts := Value;
end;

end.
