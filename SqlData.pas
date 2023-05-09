unit SqlData;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client, Data.DB,
  Data.Win.ADODB,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TDModule = class(TDataModule)
    ADOConnection: TADOConnection;
    qryProdutos: TADOQuery;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    qryProdutosPRODUTOID: TIntegerField;
    qryProdutosCODESTOQUE: TStringField;
    qryProdutosDESCRICAO: TStringField;
    qryProdutosPRECO: TBCDField;
    qryProdutosINSORUPD: TStringField;
    cmdInsertRDSProduto: TADOCommand;
    cmdUpdateRDSProduto: TADOCommand;
    qryProdutosIDRDSTATION: TStringField;
    qryParceiros: TADOQuery;
    cmdInsertRDSParceiro: TADOCommand;
    cmdUpdateCADProduto: TADOCommand;
    cmdUpdateRDSParceiro: TADOCommand;
    qryContatos: TADOQuery;
    qryContatosCONTATOID: TIntegerField;
    qryContatosIDRDSTATION: TStringField;
    qryContatosPARCEIROID: TIntegerField;
    qryContatosNOME: TStringField;
    qryContatosCARGO: TStringField;
    qryContatosTELFIXO: TStringField;
    qryContatosTELFIXO02: TStringField;
    qryContatosTELMOVEL: TStringField;
    qryContatosTELMOVEL02: TStringField;
    qryContatosEMAIL: TStringField;
    qryContatosORGANIZATIONID: TStringField;
    qryContatosINSORUPD: TStringField;
    cmdInsertRDSContato: TADOCommand;
    cmdUpdateRDSContato: TADOCommand;
    qryOrcamentos: TADOQuery;
    qryOrcamentosItensOrcamento: TADOQuery;
    qryOrcamentosItensPedido: TADOQuery;
    qryOrcamentosContato: TADOQuery;
    qryOrcamentosContatoCONTATOID: TIntegerField;
    qryOrcamentosContatoIDRDSTATION: TStringField;
    qryOrcamentosContatoPARCEIROID: TIntegerField;
    qryOrcamentosContatoNOME: TStringField;
    qryOrcamentosContatoCARGO: TStringField;
    qryOrcamentosContatoTELFIXO: TStringField;
    qryOrcamentosContatoTELFIXO02: TStringField;
    qryOrcamentosContatoTELMOVEL: TStringField;
    qryOrcamentosContatoTELMOVEL02: TStringField;
    qryOrcamentosContatoEMAIL: TStringField;
    cmdInsertRDSOrcamento: TADOCommand;
    cmdUpdateRDSOrcamento: TADOCommand;
    qryParceirosPARCEIROID: TIntegerField;
    qryParceirosIDRDSTATION: TStringField;
    qryParceirosAPELIDO: TStringField;
    qryParceirosRAZAONOME: TStringField;
    qryParceirosSEGMENTO: TStringField;
    qryParceirosUSUARIOID: TStringField;
    qryParceirosENDERECO: TStringField;
    qryParceirosURL: TStringField;
    qryParceirosINSORUPD: TStringField;
    qryOrcamentosItensOrcamentoPRODUTOID: TIntegerField;
    qryOrcamentosItensOrcamentoRDSPRODUTOID: TStringField;
    qryOrcamentosItensOrcamentoNOME: TStringField;
    qryOrcamentosItensOrcamentoDESCRICAO: TStringField;
    qryOrcamentosItensOrcamentoQTDSALDO: TIntegerField;
    qryOrcamentosItensOrcamentoVRUNITARIO: TFloatField;
    qryOrcamentosItensOrcamentoQTDPRODUTO: TIntegerField;
    qryOrcamentosItensOrcamentoTOTAL: TFloatField;
    qryOrcamentosItensOrcamentoDISCOUNT_TYPE: TStringField;
    qryOrcamentosItensOrcamentoRECURRENCE: TStringField;
    qryOrcamentosItensPedidoPRODUTOID: TIntegerField;
    qryOrcamentosItensPedidoRDSPRODUTOID: TStringField;
    qryOrcamentosItensPedidoNOME: TStringField;
    qryOrcamentosItensPedidoDESCRICAO: TStringField;
    qryOrcamentosItensPedidoQTDSALDO: TIntegerField;
    qryOrcamentosItensPedidoVRUNITARIO: TFloatField;
    qryOrcamentosItensPedidoQTDPRODUTO: TIntegerField;
    qryOrcamentosItensPedidoTOTAL: TFloatField;
    qryOrcamentosItensPedidoDISCOUNT_TYPE: TStringField;
    qryOrcamentosItensPedidoRECURRENCE: TStringField;
    qryOrcamentosESTAGIO: TIntegerField;
    qryOrcamentosORCAMENTOID: TIntegerField;
    qryOrcamentosIDRDSTATION: TStringField;
    qryOrcamentosNOMEORCAMENTO: TStringField;
    qryOrcamentosRATING: TIntegerField;
    qryOrcamentosPEDIDOID: TIntegerField;
    qryOrcamentosDTEMISSAO: TDateTimeField;
    qryOrcamentosPARCEIROID: TIntegerField;
    qryOrcamentosRDSPARCEIROID: TStringField;
    qryOrcamentosPARCEIROCONTATOID: TIntegerField;
    qryOrcamentosRDSCONTATOID: TStringField;
    qryOrcamentosUSERID: TStringField;
    qryOrcamentosDEALSOURCE: TStringField;
    qryOrcamentosCAMPAIGN: TStringField;
    qryOrcamentosDEALSTAGEID: TStringField;
    qryOrcamentosSTATUSORCAMENTO: TStringField;
    qryOrcamentosPROPOSTAGANHA: TStringField;
    qryOrcamentosORCAMENTODTALTERACAO: TDateTimeField;
    qryOrcamentosPEDIDODTALTERACAO: TDateTimeField;
    qryOrcamentosDEALLOSTREASON: TStringField;
    qryOrcamentosINSORUPD: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    LogPath: string;
    SaveJsonOnError: Boolean;
    DealSource: string;
    StatusIdOrcamento: Integer;
    StatusIdVendaRealizada: Integer;
  end;

var
  DModule: TDModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

end.
