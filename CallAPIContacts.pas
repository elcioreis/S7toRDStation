unit CallAPIContacts;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, System.SysUtils, REST.Types, System.DateUtils,
  // Units internas do sistema
  SqlData, Paths, Token, MyTools, Contact, MyDate, Email, Phone,
  LegalBase, Response, GetContacts, BaseGetContact;

function ManipulateContact(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: TToken): Boolean;
function EmailExists(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: string; pEmail: string; pContatoId: integer): Boolean;
function NotifyCreation(pMemo: TMemo; pData: TDModule; pContatoId: integer;
  pResponse: TResponse): Boolean;
function NotifyRecovery(pMemo: TMemo; pData: TDModule; pContatoId: integer;
  pContact: TBaseGetContact): Boolean;
function NotifyUpdate(pMemo: TMemo; pData: TDModule; pContatoId: integer;
  pResponse: TResponse): Boolean;

implementation

function ManipulateContact(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: TToken): Boolean;
var
  vContact: TContact;
  vTitle: string;
  vFacebook: string;
  vLinkedin: string;
  vSkype: string;
  vBirthDay: TMyDate;
  vEmail: string;
  vEmails: TArray<TEmail>;
  vPhones: TArray<TPhone>;
  vDealIds: TArray<string>;
  vLegalBases: TArray<TLegalBase>;
  vSerialized: string;
  vInsOrUpd: string;
  vResponse: TResponse;
  vStatusCode, vInsert, vUpdate: integer;
  vMessage: string;

begin

  // Os quatro objetos abaixo existem na estrutura de dados de Contatos,
  // porém não temos dados para preenchê-los, então os objetos são
  // criados mas nunca recebem valores
  vTitle := EmptyStr;
  vFacebook := EmptyStr;
  vLinkedin := EmptyStr;
  vSkype := EmptyStr;

  vBirthDay := TMyDate.Create;
  SetLength(vDealIds, 0);
  SetLength(vLegalBases, 0);

  Result := True;

  vInsert := 0;
  vUpdate := 0;

  InsertMemo(pMemo, 'Exportando contatos...');

  vResponse := TResponse.Create;

  pData.RESTClient.BaseURL := pPaths.BaseURL;

  with pData do
    try
      try
        pData.RESTClient.BaseURL := pPaths.BaseURL;

        qryContatos.Open;

        while not qryContatos.Eof and (pData.Tag >= 0) do
        begin
          vInsOrUpd := qryContatosINSORUPD.AsString;

          if Pos(';', qryContatosEMAIL.AsString) = 0 then
          begin
            vEmail := qryContatosEMAIL.AsString;
          end
          else
          begin
            vEmail := Copy(qryContatosEMAIL.AsString, 1,
              Pos(';', qryContatosEMAIL.AsString) - 1);
          end;

          if (vInsOrUpd = 'U') or not EmailExists(pMemo, pData, pPaths,
            pToken.Token, qryContatosEMAIL.AsString,
            qryContatosCONTATOID.AsInteger) then
          begin

            // Sempre haverá um e somente um email
            SetLength(vEmails, 1);
            vEmails[0] := TEmail.Create(vEmail);

            SetLength(vPhones, 0);

            if FoneValido(qryContatosTELFIXO.AsString) then
            begin
              SetLength(vPhones, Length(vPhones) + 1);
              vPhones[Length(vPhones) - 1] :=
                TPhone.Create(qryContatosTELFIXO.AsString);
            end;

            if FoneValido(qryContatosTELFIXO02.AsString) then
            begin
              SetLength(vPhones, Length(vPhones) + 1);
              vPhones[Length(vPhones) - 1] :=
                TPhone.Create(qryContatosTELFIXO02.AsString);
            end;

            if FoneValido(qryContatosTELMOVEL.AsString) then
            begin
              SetLength(vPhones, Length(vPhones) + 1);
              vPhones[Length(vPhones) - 1] :=
                TPhone.Create(qryContatosTELMOVEL.AsString);
            end;

            if FoneValido(qryContatosTELMOVEL02.AsString) then
            begin
              SetLength(vPhones, Length(vPhones) + 1);
              vPhones[Length(vPhones) - 1] :=
                TPhone.Create(qryContatosTELMOVEL02.AsString);
            end;

            vContact := TContact.Create(pToken.Token, qryContatosNOME.AsString,
              vTitle, vFacebook, vLinkedin, vSkype, vBirthDay, vEmails, vPhones,
              qryContatosORGANIZATIONID.AsString, vDealIds, vLegalBases);

            vSerialized := vContact.Serialize;

            pData.RESTRequest.ClearBody;

            if vInsOrUpd = 'I' then
            begin
              pData.RESTRequest.Method := TRESTRequestMethod.rmPOST;
              pData.RESTRequest.Resource := pPaths.postContacts;
              pData.RESTRequest.Body.Add(vSerialized, ctAPPLICATION_JSON);
              pData.RESTRequest.Execute;
              vStatusCode := pData.RESTResponse.StatusCode;

              if vStatusCode = 200 then
                Inc(vInsert);
            end
            else
            begin
              pData.RESTRequest.Method := TRESTRequestMethod.rmPUT;
              pData.RESTRequest.Resource := StringReplace(pPaths.putContacts,
                '$id', pData.qryContatosIDRDSTATION.AsString, [rfIgnoreCase]);
              pData.RESTRequest.Body.Add(vSerialized, ctAPPLICATION_JSON);
              pData.RESTRequest.Execute;
              vStatusCode := pData.RESTResponse.StatusCode;

              if vStatusCode = 200 then
                Inc(vUpdate);
            end;

            if vStatusCode = 200 then
            begin
              vSerialized := pData.RESTResponse.Content;
              vResponse.Deserialize(vSerialized);

              if vInsOrUpd = 'I' then
              begin
                NotifyCreation(pMemo, pData, qryContatosCONTATOID.AsInteger,
                  vResponse);
              end
              else
              begin
                NotifyUpdate(pMemo, pData, qryContatosCONTATOID.AsInteger,
                  vResponse);
              end;

            end
            else
            begin
              vMessage := 'Erro: ' + IntToStr(vStatusCode) + ' - ContatoID: ' +
                qryContatosCONTATOID.AsString + #13#10 +
                pData.RESTResponse.Content;
              InsertMemo(pMemo, vMessage);
            end;

            FreeAndNil(vContact);
          end;

          qryContatos.Next;

          Application.ProcessMessages;
          Sleep(300);
          Application.ProcessMessages;
          Sleep(300);
        end;

      except
        InsertMemo(pMemo, vMessage);
        Result := False;
      end;

    finally
      qryContatos.Close;

      vMessage := 'Contatos finalizados: ';

      case vInsert of
        0:
          vMessage := vMessage + '(0 inclusão, ';
        1:
          vMessage := vMessage + '(1 inclusão, ';
      else
        vMessage := vMessage + '(' + FormatFloat('#,##0', vInsert) +
          ' inclusões, ';
      end;

      case vUpdate of
        0:
          vMessage := vMessage + '0 alteração)';
        1:
          vMessage := vMessage + '1 alteração)';
      else
        vMessage := vMessage + FormatFloat('#,##0', vUpdate) + ' alterações)';
      end;
      InsertMemo(pMemo, vMessage);

    end;

end;

function EmailExists(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: string; pEmail: string; pContatoId: integer): Boolean;
var
  vPath: string;
  vStatusCode: integer;
  vSerialized: string;
  vGetContacts: TGetContacts;
begin
  vGetContacts := TGetContacts.Create;

  vPath := pPaths.GetContacts;
  vPath := StringReplace(vPath, '$token', pToken, [rfIgnoreCase]);
  vPath := StringReplace(vPath, '$email', pEmail, [rfIgnoreCase]);

  pData.RESTRequest.Method := TRESTRequestMethod.rmGET;
  pData.RESTRequest.Resource := vPath;
  pData.RESTRequest.ClearBody;
  pData.RESTRequest.Execute;
  vStatusCode := pData.RESTResponse.StatusCode;

  if vStatusCode = 200 then
  begin
    vSerialized := pData.RESTResponse.Content;
    vGetContacts.Deserialize(vSerialized);

    if Length(vGetContacts.contacts) > 0 then
    begin
      NotifyRecovery(pMemo, pData, pContatoId, vGetContacts.contacts[0]);
    end;

  end;

  Result := vGetContacts.total > 0;
end;

function NotifyCreation(pMemo: TMemo; pData: TDModule; pContatoId: integer;
  pResponse: TResponse): Boolean;
var
  vCreatedAt: TDateTime;
  vUpdatedAt: TDateTime;
begin
  // Rotina de gravação utilizada pela inclusão de contato.
  try
    pData.ADOConnection.BeginTrans;

    vCreatedAt := ISO8601ToDate(pResponse.created_at, False);
    vUpdatedAt := ISO8601ToDate(pResponse.updated_at, False);

    with pData.cmdInsertRDSContato do
    begin
      with Parameters do
      begin
        ParamByName('CONTATOID').Value := pContatoId;
        ParamByName('IDRDSTATION').Value := pResponse._id;
        ParamByName('CREATEDAT').Value := vCreatedAt;
        ParamByName('UPDATEDAT').Value := vUpdatedAt;
        ParamByName('UPDATEDTIMES').Value := 0;
        ParamByName('RECOVERED').Value := 0;
      end;
      Execute;
    end;

    pData.ADOConnection.CommitTrans;

    Result := True;
  except
    on Ex: Exception do
    begin
      pData.ADOConnection.RollbackTrans;
      InsertMemo(pMemo,
        'Problemas ao tentar executar CallAPIProducts.NotifyCreation!' + #13#10
        + 'PRODUTOID=' + IntToStr(pContatoId));
      InsertMemo(pMemo, Ex.Message);
      Result := False;
    end;
  end;
end;

function NotifyRecovery(pMemo: TMemo; pData: TDModule; pContatoId: integer;
  pContact: TBaseGetContact): Boolean;
var
  vCreatedAt: TDateTime;
  vUpdatedAt: TDateTime;
begin
  // Rotina de gravação utilizada pela inclusão de contato.
  try
    pData.ADOConnection.BeginTrans;

    vCreatedAt := ISO8601ToDate(pContact.created_at, False);
    vUpdatedAt := ISO8601ToDate(pContact.updated_at, False);

    with pData.cmdInsertRDSContato do
    begin
      with Parameters do
      begin
        ParamByName('CONTATOID').Value := pContatoId;
        ParamByName('IDRDSTATION').Value := pContact.Id;
        ParamByName('CREATEDAT').Value := vCreatedAt;
        ParamByName('UPDATEDAT').Value := vUpdatedAt;
        ParamByName('UPDATEDTIMES').Value := 0;
        ParamByName('RECOVERED').Value := 1;
      end;
      Execute;
    end;

    pData.ADOConnection.CommitTrans;

    Result := True;
  except
    on Ex: Exception do
    begin
      pData.ADOConnection.RollbackTrans;
      InsertMemo(pMemo,
        'Problemas ao tentar executar CallAPIProducts.NotifyRecovery!' + #13#10
        + 'PRODUTOID=' + IntToStr(pContatoId));
      InsertMemo(pMemo, Ex.Message);
      Result := False;
    end;
  end;

end;

function NotifyUpdate(pMemo: TMemo; pData: TDModule; pContatoId: integer;
  pResponse: TResponse): Boolean;
var
  vUpdatedAt: TDateTime;
begin

  try
    pData.ADOConnection.BeginTrans;

    vUpdatedAt := Now;

    with pData.cmdUpdateRDSContato do
    begin
      with Parameters do
      begin
        ParamByName('CONTATOID').Value := pContatoId;
        ParamByName('UPDATEDAT').Value := vUpdatedAt;
      end;

      Execute;
    end;

    pData.ADOConnection.CommitTrans;

    Result := True;
  except
    on Ex: Exception do
    begin
      pData.ADOConnection.RollbackTrans;
      InsertMemo(pMemo,
        'Problemas ao tentar executar CallAPIProducts.NotifyUpdate!');
      InsertMemo(pMemo, Ex.Message);
      Result := False;
    end;
  end;
end;

end.
