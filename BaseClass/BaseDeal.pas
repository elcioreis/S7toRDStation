unit BaseDeal;

interface

uses
  CustomFields;

type
  TBaseDeal = class
  private
    FName: string;
    FUserId: string;
    FRating: integer;
    FDealStageId: string;
    FWin: string;
    FDealCustomFields: TArray<TCustomFields>;
    procedure setName(const Value: string);
    procedure setUserId(const Value: string);
    procedure setRating(const Value: integer);
    procedure setDealStageId(const Value: string);
    procedure setWin(const Value: string);
    procedure setDealCustomFields(const Value: TArray<TCustomFields>);
  public
    property name: string read FName write setName;
    property user_id: string read FUserId write setUserId;
    property rating: integer read FRating write setRating;
    property deal_stage_id: string read FDealStageId write setDealStageId;
    property win: string read FWin write setWin;
    property deal_custom_fields: TArray<TCustomFields> read FDealCustomFields
      write setDealCustomFields;
    constructor Create(pName: string; pUserId: string; pRating: integer;
      pDealStageId: string; pWin: string); overload;
//    constructor Create(pName: string; pUserId: string; pRating: integer;
//      {pDealStageId: string;} pWin: string;
//      pDealCustomFields: TArray<TCustomFields>); overload;
  end;

implementation

procedure TBaseDeal.setName(const Value: string);
begin
  FName := Value;
end;

procedure TBaseDeal.setUserId(const Value: string);
begin
  FUserId := Value;
end;

procedure TBaseDeal.setRating(const Value: integer);
begin
  FRating := Value;
end;

procedure TBaseDeal.setDealStageId(const Value: string);
begin
  FDealStageId := Value;
end;

procedure TBaseDeal.setWin(const Value: string);
begin
  FWin := Value;
end;

procedure TBaseDeal.setDealCustomFields(const Value: TArray<TCustomFields>);
var
  S, I: word;
begin
  S := Length(Value);
  SetLength(FDealCustomFields, S);
  if S > 0 then
    for I := 0 to S - 1 do
      FDealCustomFields[I] := Value[I];
end;

constructor TBaseDeal.Create(pName: string; pUserId: string; pRating: integer;
  pDealStageId: string; pWin: string);
var
  vDealCustomFields: TArray<TCustomFields>;
begin
  name := pName;
  user_id := pUserId;
  rating := pRating;
  deal_stage_id := pDealStageId;
  win := pWin;
  SetLength(vDealCustomFields, 0);
  deal_custom_fields := vDealCustomFields;
end;

//constructor TBaseDeal.Create(pName: string; pUserId: string; pRating: integer;
//  {pDealStageId: string;} pWin: string; pDealCustomFields: TArray<TCustomFields>);
//begin
//  name := pName;
//  user_id := pUserId;
//  rating := pRating;
////  deal_stage_id := pDealStageId;
//  win := pWin;
//  deal_custom_fields := pDealCustomFields;
//end;

end.
