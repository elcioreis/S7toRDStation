unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Data.Bind.Components, Data.Bind.ObjectScope, REST.Types,
  Vcl.ExtCtrls,
  // Units internas do sistema
  SqlData, Settings, Paths, Token, Identification, MyTools,
  CallAPIProducts, CallAPIOrganizations, CallAPIContacts, CallAPIDeals;

type
  TFMain = class(TForm)
    Memo: TMemo;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    function TestDBConnection(pConnectionString: string): Boolean;
    procedure ExecuteTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    function LoadSettings: Boolean;
    procedure ExportToRDStation;
    function TestToken(pBaseUrl: string; pPath: string; pToken: TToken)
      : Boolean;
  public
    { Public declarations }
    ConnectionString: string;
    Token: TToken;
    Paths: TPaths;
    Id: TIdentification;
    DataEmissao: TDateTime;
    TempoEsperaMinutos: Integer;
  end;

var
  FMain: TFMain;
  DModule: TDModule;

implementation

{$R *.dfm}

procedure TFMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  InsertMemo(Memo, 'Sistema encerrado pelo usuário.');
  DModule.Tag := -1;
end;

procedure TFMain.FormCreate(Sender: TObject);
var
  vSuccess: Boolean;
begin
  FormatSettings.DecimalSeparator := '.';

  DModule := TDModule.Create(Self);

  Memo.Lines.Clear;
  Memo.Lines.Add('Envio de dados do S7 para RD Station');
  Memo.Lines.Add('------------------------------------');

  vSuccess := LoadSettings();

  if vSuccess then
    Timer.Enabled := True;

end;

function TFMain.LoadSettings: Boolean;
begin

  if DModule.ADOConnection.Connected then
    DModule.ADOConnection.Close;

  DModule.ADOConnection.ConnectionString := EmptyStr;
  Result := True;

  if LoadAppSettings('appSettings.json', ConnectionString, Self.Token,
    Self.Paths, DModule.LogPath, DModule.SaveJsonOnError, DModule.DealSource,
    DModule.StatusIdOrcamento, DModule.StatusIdVendaRealizada, DataEmissao,
    TempoEsperaMinutos) then
  begin

    if ConnectionString = EmptyStr then
    begin
      InsertMemo(Memo, 'Falha ao carregar a string de conexão.');
      Result := False;
    end
    else if not TestDBConnection(ConnectionString) then
    begin
      InsertMemo(Memo, 'Conexão ao banco de dados S7 falhou.');
      Result := False;
    end
    else
    begin
      InsertMemo(Memo, 'Conexão ao banco de dados S7 testada.');
    end;

    if Self.Token = nil then
    begin
      InsertMemo(Memo, 'Falha ao carregar o Token para acesso ao RD Station.');
      Result := False;
    end;

    if Self.Paths = nil then
    begin
      InsertMemo(Memo,
        'Relação de caminhos para o RD Station não foi configurada.');
      Result := False;
    end;

    if Result then
      if TestToken(Self.Paths.BaseURL, Self.Paths.getTokenCheck, Self.Token)
      then
      begin
        InsertMemo(Memo, 'Token testado na API RD Station.');
      end
      else
      begin
        InsertMemo(Memo, 'Falha ao testar o token na API RD Station.');
        Result := False;
      end;

    if Result then
    begin
      if DModule.StatusIdOrcamento = 0 then
      begin
        InsertMemo(Memo, 'O StatusID do orçamento não foi configurado.');
        Result := False;
      end;

      if DModule.StatusIdVendaRealizada = 0 then
      begin
        InsertMemo(Memo, 'O StatusID da venda realizada não foi configurado.');
        Result := False;
      end;

    end;

    if Result then
    begin
      InsertMemo(Memo, 'Sistema em execução.');
    end
    else
    begin
      InsertMemo(Memo, 'Sistema parado!!!');
    end;

  end
  else
  begin
    InsertMemo(Memo, 'Problemas ao tentar carregar arquivo de configurações.');
    InsertMemo(Memo, 'Sistema parado!!!');
  end;

  if not Result then
    Memo.Font.Color := clRed;

end;

procedure TFMain.ExportToRDStation;
begin

  try

    if Memo.Hint <> EmptyStr then
    begin
      Memo.Lines.Clear;
      Memo.Lines.Add('Envio de dados do S7 para RD Station');
      Memo.Lines.Add('------------------------------------');
    end;

    // Uso o Hint para armazenar o nome do arquivo de log
    Memo.Hint := DModule.LogPath + '\' + 'S7toRDStation' +
      FormatDateTime('yymmddhhnnss', Now) + '.log';

    DModule.ADOConnection.ConnectionString := ConnectionString;
    DModule.ADOConnection.Open;
    Application.ProcessMessages;
    ManipulateProduct(Memo, DModule, Paths, Token);
    Application.ProcessMessages;
    ManipulateOrganization(Memo, DModule, Paths, Token, DataEmissao);
    Application.ProcessMessages;
    ManipulateContact(Memo, DModule, Paths, Token);
    Application.ProcessMessages;
    ManipulateDeal(Memo, DModule, Paths, Token, DataEmissao);
    Application.ProcessMessages;

  finally
    DModule.ADOConnection.Close;
  end;

end;

function TFMain.TestDBConnection(pConnectionString: string): Boolean;
begin

  DModule.ADOConnection.ConnectionString := pConnectionString;

  try
    DModule.ADOConnection.Open;
    DModule.ADOConnection.Close;
    Result := True;
  except
    Result := False;
  end;

end;

function TFMain.TestToken(pBaseUrl: string; pPath: string;
  pToken: TToken): Boolean;
var
  vToken: string;
begin

  Self.Id := TIdentification.Create;

  try
    vToken := pToken.Serialize;

    DModule.RESTClient.BaseURL := pBaseUrl;
    DModule.RESTRequest.Resource := pPath;
    DModule.RESTRequest.Body.Add(vToken, ctAPPLICATION_JSON);
    DModule.RESTRequest.Execute;

    if DModule.RESTResponse.StatusCode = 200 then
    begin
      Self.Id.Deserialize(DModule.RESTResponse.Content);
    end
    else
    begin
      InsertMemo(Memo, 'Acesso a API obteve erro: ' +
        IntToStr(DModule.RESTResponse.StatusCode));
    end;

    Result := Self.Id.Valid;
  except
    Result := False;
  end;

end;

procedure TFMain.ExecuteTimer(Sender: TObject);
begin

  Timer.Enabled := False;

  // Tempo X 60 X 1000 para transformar em minutos
  Timer.Interval := TempoEsperaMinutos * 60 * 1000;

  try
    ExportToRDStation();
    InsertMemo(Self.Memo, 'Aguardando a próxima execução...');
  finally
    Timer.Enabled := True;
  end;

end;

end.
