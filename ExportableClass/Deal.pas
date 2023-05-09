unit Deal;

interface

uses
  BaseNeon, BaseDeal, BaseContact, Id;

type
  TDeal = class(TBaseNeon)
  private
    FToken: string;
    FDeal: TBaseDeal;
    FDealStageId: string;
    FContacts: TArray<TBaseContact>;
    FDealSource: TId;
    FCampaign: TId;
    FOrganization: TId;
    FDealLostReason: TId;
    procedure setToken(const Value: string);
    procedure setDeal(const Value: TBaseDeal);
    procedure setDealStageId(const Value: string);
    procedure setContacts(const Value: TArray<TBaseContact>);
    procedure setDealSource(const Value: TId);
    procedure setCampaign(const Value: TId);
    procedure setOrganization(const Value: TId);
    procedure setDealLostReason(const Value: TId);
  public
    property token: string read FToken write setToken;
    property Deal: TBaseDeal read FDeal write setDeal;
    property deal_stage_id: string read FDealStageId write setDealStageId;
    property contacts: TArray<TBaseContact> read FContacts write setContacts;
    property deal_source: TId read FDealSource write setDealSource;
    property campaign: TId read FCampaign write setCampaign;
    property organization: TId read FOrganization write setOrganization;
    property deal_lost_reason: TId read FDealLostReason write setDealLostReason;
    constructor Create(pToken: string; pBaseDeal: TBaseDeal;
      pDealStageId: string; pContacts: TArray<TBaseContact>; pDealSource: TId;
      pCampaign: TId; pOrganization: TId; pDealLostReason: TId);
  end;

implementation

procedure TDeal.setToken(const Value: string);
begin
  FToken := Value;
end;

procedure TDeal.setDeal(const Value: TBaseDeal);
begin
  FDeal := Value;
end;

procedure TDeal.setDealStageId(const Value: string);
begin
  FDealStageId := Value;
end;

procedure TDeal.setContacts(const Value: TArray<TBaseContact>);
var
  S, I: word;
begin
  S := Length(Value);
  SetLength(FContacts, S);
  if S > 0 then
    for I := 0 to S - 1 do
      FContacts[I] := Value[I];
end;

procedure TDeal.setDealSource(const Value: TId);
begin
  FDealSource := Value;
end;

procedure TDeal.setCampaign(const Value: TId);
begin
  FCampaign := Value;
end;

procedure TDeal.setOrganization(const Value: TId);
begin
  FOrganization := Value;
end;

procedure TDeal.setDealLostReason(const Value: TId);
begin
  FDealLostReason := Value;
end;

constructor TDeal.Create(pToken: string; pBaseDeal: TBaseDeal;
  pDealStageId: string; pContacts: TArray<TBaseContact>; pDealSource: TId;
  pCampaign: TId; pOrganization: TId; pDealLostReason: TId);
begin
  token := pToken;
  deal := pBaseDeal;
  deal_stage_id := pDealStageId;
  contacts := pContacts;
  deal_source := pDealSource;
  campaign := pCampaign;
  organization := pOrganization;
  deal_lost_reason := pDealLostReason;
end;

end.
