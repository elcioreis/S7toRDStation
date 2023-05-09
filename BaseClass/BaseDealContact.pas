unit BaseDealContact;

interface

uses
  BaseNeon, MyDate, LegalBase, Email, Phone;

type
  TBaseDealContact = class
  private
    FName: string;
    FTitle: string;
    FFacebook: string;
    FLinkedin: string;
    FSkype: string;
    // FBirthday: TMyDate;
    FEmails: TArray<TEmail>;
    FPhones: TArray<TPhone>;
    FLegalBases: TArray<TLegalBase>;
    procedure setName(const Value: string);
    procedure setTitle(const Value: string);
    procedure setFacebook(const Value: string);
    procedure setLinkedin(const Value: string);
    procedure setSkype(const Value: string);
    // procedure setBirthday(const Value: TMyDate);
    procedure setEmails(const Value: TArray<TEmail>);
    procedure setPhones(const Value: TArray<TPhone>);
    procedure setLegalBases(const Value: TArray<TLegalBase>);
  public
    property name: string read FName write setName;
    property title: string read FTitle write setTitle;
    property facebook: string read FFacebook write setFacebook;
    property linkedin: string read FLinkedin write setLinkedin;
    property skype: string read FSkype write setSkype;
    // property birdthday: TMyDate read FBirthday write setBirthday;
    property emails: TArray<TEmail> read FEmails write setEmails;
    property phones: TArray<TPhone> read FPhones write setPhones;
    property legal_bases: TArray<TLegalBase> read FLegalBases
      write setLegalBases;
    constructor Create(pName: string; pTitle: string; pFacebook: string;
      pLinkedin: string; pSkype: string; pEmails: TArray<TEmail>;
      pPhones: TArray<TPhone>; pLegalBases: TArray<TLegalBase>); overload;
  end;

implementation

procedure TBaseDealContact.setName(const Value: string);
begin
  FName := Value;
end;

procedure TBaseDealContact.setTitle(const Value: string);
begin
  FTitle := Value;
end;

// procedure TBaseDealContact.setBirthday(const Value: TMyDate);
// begin
// FBirthday := Value;
// end;

procedure TBaseDealContact.setEmails(const Value: TArray<TEmail>);
begin
  FEmails := Value;
end;

procedure TBaseDealContact.setPhones(const Value: TArray<TPhone>);
begin
  FPhones := Value;
end;

procedure TBaseDealContact.setLegalBases(const Value: TArray<TLegalBase>);
begin
  FLegalBases := Value;
end;

procedure TBaseDealContact.setFacebook(const Value: string);
begin
  FFacebook := Value;
end;

procedure TBaseDealContact.setLinkedin(const Value: string);
begin
  FLinkedin := Value;
end;

procedure TBaseDealContact.setSkype(const Value: string);
begin
  FSkype := Value;
end;

constructor TBaseDealContact.Create(pName: string; pTitle: string;
  pFacebook: string; pLinkedin: string; pSkype: string; pEmails: TArray<TEmail>;
  pPhones: TArray<TPhone>; pLegalBases: TArray<TLegalBase>);
var
  I, S: word;
begin
  FName := pName;
  FTitle := pTitle;
  FFacebook := pFacebook;
  FLinkedin := pLinkedin;
  FSkype := pSkype;
//  FBirthday := pBirthday;

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

  S := Length(pLegalBases);
  SetLength(FLegalBases, S);
  if S > 0 then
    for I := 0 to S - 1 do
      FLegalBases[I] := pLegalBases[I];

end;

end.
