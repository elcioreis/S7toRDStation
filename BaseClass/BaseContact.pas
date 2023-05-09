unit BaseContact;

interface

uses
  BaseNeon, MyDate, LegalBase, Email, Phone;

type
  TBaseContact = class
  private
    FName: string;
    FTitle: string;
    FFacebook: string;
    FLinkedin: string;
    FSkype: string;
    FBirthday: TMyDate;
    FEmails: TArray<TEmail>;
    FPhones: TArray<TPhone>;
    FOrganizationId: string;
    FDealIds: TArray<string>;
    FLegalBases: TArray<TLegalBase>;
    procedure setName(const Value: string);
    procedure setTitle(const Value: string);
    procedure setFacebook(const Value: string);
    procedure setLinkedin(const Value: string);
    procedure setSkype(const Value: string);
    procedure setBirthday(const Value: TMyDate);
    procedure setEmails(const Value: TArray<TEmail>);
    procedure setPhones(const Value: TArray<TPhone>);
    procedure setOrganizationId(const Value: string);
    procedure setDealId(const Value: TArray<string>);
    procedure setLegalBases(const Value: TArray<TLegalBase>);
  public
    property name: string read FName write setName;
    property title: string read FTitle write setTitle;
    property facebook: string read FFacebook write setFacebook;
    property linkedin: string read FLinkedin write setLinkedin;
    property skype: string read FSkype write setSkype;
    property birdthday: TMyDate read FBirthday write setBirthday;
    property emails: TArray<TEmail> read FEmails write setEmails;
    property phones: TArray<TPhone> read FPhones write setPhones;
    property organization_id: string read FOrganizationId
      write setOrganizationId;
    property deal_ids: TArray<string> read FDealIds write setDealId;
    property legal_bases: TArray<TLegalBase> read FLegalBases
      write setLegalBases;
    constructor Create(pName: string; pTitle: string; pFacebook: string;
      pLinkedin: string; pSkype: string; pBirthday: TMyDate;
      pEmails: TArray<TEmail>; pPhones: TArray<TPhone>; pOrganizationId: string;
      pDealIds: TArray<string>; pLegalBases: TArray<TLegalBase>); overload;
  end;

implementation

procedure TBaseContact.setName(const Value: string);
begin
  FName := Value;
end;

procedure TBaseContact.setTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TBaseContact.setBirthday(const Value: TMyDate);
begin
  FBirthday := Value;
end;

procedure TBaseContact.setEmails(const Value: TArray<TEmail>);
begin
  FEmails := Value;
end;

procedure TBaseContact.setPhones(const Value: TArray<TPhone>);
begin
  FPhones := Value;
end;

procedure TBaseContact.setOrganizationId(const Value: string);
begin
  FOrganizationId := Value;
end;

procedure TBaseContact.setDealId(const Value: TArray<string>);
begin
  FDealIds := Value;
end;

procedure TBaseContact.setLegalBases(const Value: TArray<TLegalBase>);
begin
  FLegalBases := Value;
end;

procedure TBaseContact.setFacebook(const Value: string);
begin
  FFacebook := Value;
end;

procedure TBaseContact.setLinkedin(const Value: string);
begin
  FLinkedin := Value;
end;

procedure TBaseContact.setSkype(const Value: string);
begin
  FSkype := Value;
end;

constructor TBaseContact.Create(pName: string; pTitle: string;
  pFacebook: string; pLinkedin: string; pSkype: string; pBirthday: TMyDate;
  pEmails: TArray<TEmail>; pPhones: TArray<TPhone>; pOrganizationId: string;
  pDealIds: TArray<string>; pLegalBases: TArray<TLegalBase>);
var
  I, S: word;
begin
  FName := pName;
  FTitle := pTitle;
  FFacebook := pFacebook;
  FLinkedin := pLinkedin;
  FSkype := pSkype;
  FBirthday := pBirthday;

  S := Length(pEmails);
  SetLength(FEmails, S);
  if S > 0 then
    for I := 0 to S - 1 do
      FEmails[I] := pEmails[I];

  S := Length(pPhones);
  SetLength(FPhones, S);
  if S > 0 then
    for I := 0 to S - 1 do
      FPhones[I] := pPhones[I];

  FOrganizationId := pOrganizationId;
  FDealIds := pDealIds;

  S := Length(pLegalBases);
  SetLength(FLegalBases, S);
  if S > 0 then
    for I := 0 to S - 1 do
      FLegalBases[I] := pLegalBases[I];

end;

end.
