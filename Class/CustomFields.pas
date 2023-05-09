unit CustomFields;

interface

type
  TCustomFields = class
  private
    FCustomFieldId: string;
    FValue: string;
    procedure setCustomFieldId(const Value: string);
    procedure setValue(const Value: string);
  public
    property custom_field_id: string read FCustomFieldId write setCustomFieldId;
    property value: string read FValue write setValue;
    constructor Create(pCustomFieldId: string; pValue: string); overload;
  end;

implementation

procedure TCustomFields.setCustomFieldId(const Value: string);
begin
  FCustomFieldId := Value;
end;

procedure TCustomFields.setValue(const Value: string);
begin
  FValue := Value;
end;

constructor TCustomFields.Create(pCustomFieldId: string;
  pValue: string);
begin
  FCustomFieldId := pCustomFieldId;
  FValue := pValue;
end;

end.
