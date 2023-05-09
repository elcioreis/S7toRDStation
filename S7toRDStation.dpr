program S7toRDStation;

uses
  Vcl.Forms,
  Main in 'Main.pas' {FMain},
  SqlData in 'SqlData.pas' {DModule: TDataModule},
  BaseNeon in 'BaseClass\BaseNeon.pas',
  BaseProduct in 'BaseClass\BaseProduct.pas',
  Token in 'ExportableClass\Token.pas',
  MyTools in 'Tools\MyTools.pas',
  Settings in 'Tools\Settings.pas',
  Paths in 'Class\Paths.pas',
  CallAPIContacts in 'CallAPIContacts.pas',
  CallAPIDeals in 'CallAPIDeals.pas',
  CallAPIOrganizations in 'CallAPIOrganizations.pas',
  CallAPIProducts in 'CallAPIProducts.pas',
  Identification in 'Class\Identification.pas',
  Neon.Core.Attributes in 'Neon-master\Neon.Core.Attributes.pas',
  Neon.Core.DynamicTypes in 'Neon-master\Neon.Core.DynamicTypes.pas',
  Neon.Core.Nullables in 'Neon-master\Neon.Core.Nullables.pas',
  Neon.Core.Persistence.JSON in 'Neon-master\Neon.Core.Persistence.JSON.pas',
  Neon.Core.Persistence.JSON.Schema in 'Neon-master\Neon.Core.Persistence.JSON.Schema.pas',
  Neon.Core.Persistence in 'Neon-master\Neon.Core.Persistence.pas',
  Neon.Core.Serializers.DB in 'Neon-master\Neon.Core.Serializers.DB.pas',
  Neon.Core.Serializers.Nullables in 'Neon-master\Neon.Core.Serializers.Nullables.pas',
  Neon.Core.Serializers.RTL in 'Neon-master\Neon.Core.Serializers.RTL.pas',
  Neon.Core.Serializers.VCL in 'Neon-master\Neon.Core.Serializers.VCL.pas',
  Neon.Core.TypeInfo in 'Neon-master\Neon.Core.TypeInfo.pas',
  Neon.Core.Types in 'Neon-master\Neon.Core.Types.pas',
  Neon.Core.Utils in 'Neon-master\Neon.Core.Utils.pas',
  NeonTools in 'Tools\NeonTools.pas',
  Product in 'ExportableClass\Product.pas',
  ResponseProduct in 'ResponseClass\ResponseProduct.pas',
  BaseOrganization in 'BaseClass\BaseOrganization.pas',
  Organization in 'ExportableClass\Organization.pas',
  Response in 'ResponseClass\Response.pas',
  BaseContact in 'BaseClass\BaseContact.pas',
  MyDate in 'Class\MyDate.pas',
  LegalBase in 'Class\LegalBase.pas',
  Phone in 'Class\Phone.pas',
  Email in 'Class\Email.pas',
  Contact in 'ExportableClass\Contact.pas',
  BaseDeal in 'BaseClass\BaseDeal.pas',
  CustomFields in 'Class\CustomFields.pas',
  ID in 'Class\ID.pas',
  Deal in 'ExportableClass\Deal.pas',
  GetContacts in 'ImportableClass\GetContacts.pas',
  BaseGetContact in 'BaseClass\BaseGetContact.pas',
  DealProduct in 'ExportableClass\DealProduct.pas',
  BaseGetDealProduct in 'BaseClass\BaseGetDealProduct.pas',
  GetDealProducts in 'ImportableClass\GetDealProducts.pas',
  GetError in 'ImportableClass\GetError.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDModule, DModule);
  Application.Run;

end.
