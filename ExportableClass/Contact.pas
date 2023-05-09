unit Contact;

interface

uses
  BaseNeon, BaseContact, MyDate, Email, Phone, LegalBase;

type
  TContact = class(TBaseNeon)
  private
    FToken: string;
    FContact: TBaseContact;
    procedure setToken(const Value: string);
    procedure setContact(const Value: TBaseContact);
  public
    property Token: string read FToken write setToken;
    property Contact: TBaseContact read FContact write setContact;
    constructor Create(pToken: string; pName: string; pTitle: string;
      pFacebook: string; pLinkedin: string; pSkype: string; pBirthDay: TMyDate;
      pEmails: TArray<TEmail>; pPhones: TArray<TPhone>; pOrganizationId: string;
      pDealIds: TArray<string>; pLegalBases: TArray<TLegalBase>); overload;
  end;

implementation

procedure TContact.setToken(const Value: string);
begin
  FToken := Value;
end;

procedure TContact.setContact(const Value: TBaseContact);
begin
  FContact := Value;
end;

constructor TContact.Create(pToken: string; pName: string; pTitle: string;
  pFacebook: string; pLinkedin: string; pSkype: string; pBirthDay: TMyDate;
  pEmails: TArray<TEmail>; pPhones: TArray<TPhone>; pOrganizationId: string;
  pDealIds: TArray<string>; pLegalBases: TArray<TLegalBase>);
begin
  FToken := pToken;
  FContact := TBaseContact.Create(pName, pTitle, pFacebook, pLinkedin, pSkype,
    pBirthDay, pEmails, pPhones, pOrganizationId, pDealIds, pLegalBases);
end;

end.
