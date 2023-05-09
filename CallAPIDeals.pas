unit CallAPIDeals;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, System.SysUtils, REST.Types, System.DateUtils,
  Data.Win.ADODB, System.Classes,
  // Units internas do sistema
  Deal, DealProduct, GetDealProducts, BaseContact, BaseDeal, Id, MyDate,
  SqlData, Paths, Token, MyTools, Response, Email, Phone, LegalBase;

function ManipulateDeal(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: TToken; pDtEmissao: TDateTime): Boolean;
function AssembleContact(pQryContato: TADOQuery; pContatoID: Integer;
  out pContacts: TArray<TBaseContact>): Boolean;
function NotifyCreation(pMemo: TMemo; pData: TDModule; pOrcamentoID: Integer;
  pResponse: TResponse): Boolean;
function NotifyUpdate(pMemo: TMemo; pData: TDModule; pOrcamentoID: Integer;
  pResponse: TResponse): Boolean;
procedure SaveJson(pSubject: string; pPath: string; pJson: string);
procedure IncludeProducts(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: TToken; pRDSOrcamentoID: string; pID: Integer;
  pQryProdutos: TADOQuery);
procedure RemoveProducts(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: TToken; pRDStationID: string);

implementation

function ManipulateDeal(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: TToken; pDtEmissao: TDateTime): Boolean;
const
  sTrue: string = '==true==';
  sFalse: string = '==false==';
  sNull: string = '==null==';
var
  vDeal: TDeal;
  vBaseDeal: TBaseDeal;
  vDealProducts: TArray<TDealProduct>;
  vContacts: TArray<TBaseContact>;
  vDealSource: TId;
  vCampaign: TId;
  vDealLostReason: TId;
  vOrganization: TId;
  vSerialized: widestring;
  vInsOrUpd: string;
  vResponse: TResponse;
  vStatusCode, vInsert, vUpdate: Integer;
  vWin: string;
  vMessage: string;
  vErro: Boolean;
begin

  Result := True;

  vErro := False;

  vInsert := 0;
  vUpdate := 0;

  InsertMemo(pMemo, 'Exportando oportunidades...');

  vResponse := TResponse.Create;

  with pData do
    try
      try

        pData.RESTClient.BaseURL := pPaths.BaseURL;

        // A rotina de inclusão de produtos foi apartada
        SetLength(vDealProducts, 0);

        with qryOrcamentos.Parameters do
        begin
          ParamByName('DATAEMISSAOA').Value := pDtEmissao;
          ParamByName('DATAEMISSAOB').Value := pDtEmissao;
          ParamByName('IDSTATUSORCAMENTO').Value := StatusIdOrcamento;
        end;

        qryOrcamentos.Open;

        repeat

          while not qryOrcamentos.Eof and (pData.Tag >= 0) do
          begin
            vInsOrUpd := qryOrcamentosINSORUPD.AsString;

            if qryOrcamentosUSERID.AsString = EmptyStr then
            begin
              vMessage := 'Erro - OrcamentoID: ' +
                qryOrcamentosORCAMENTOID.AsString + #13#10 +
                'O código externo do vendedor (USERID) está nulo no S7';
              InsertMemo(pMemo, vMessage);
              qryOrcamentos.Next;
              vErro := True;
              Continue;
            end;

            if qryOrcamentosPROPOSTAGANHA.AsString = 'E' then
              vWin := sTrue
            else if qryOrcamentosPROPOSTAGANHA.AsString = 'C' then
              vWin := sFalse
            else
              vWin := sNull;

            vBaseDeal := TBaseDeal.Create(qryOrcamentosNOMEORCAMENTO.AsString,
              qryOrcamentosUSERID.AsString, qryOrcamentosRATING.AsInteger,
              qryOrcamentosDEALSTAGEID.AsString, vWin);

            SetLength(vContacts, 0);
            if not qryOrcamentosPARCEIROCONTATOID.IsNull then
            begin
              AssembleContact(qryOrcamentosContato,
                qryOrcamentosPARCEIROCONTATOID.AsInteger, vContacts);
            end;

            if qryOrcamentosDEALSOURCE.AsString <> EmptyStr then
              vDealSource := TId.Create(qryOrcamentosDEALSOURCE.AsString)
            else if pData.DealSource <> EmptyStr then
              vDealSource := TId.Create(pData.DealSource)
            else
              vDealSource := nil;

            if qryOrcamentosCAMPAIGN.AsString <> EmptyStr then
              vCampaign := TId.Create(qryOrcamentosCAMPAIGN.AsString)
            else
              vCampaign := nil;

            if qryOrcamentosDEALLOSTREASON.AsString <> EmptyStr then
              vDealLostReason :=
                TId.Create(qryOrcamentosDEALLOSTREASON.AsString)
            else
              vDealLostReason := nil;

            vOrganization := TId.Create(qryOrcamentosRDSPARCEIROID.AsString);

            vDeal := TDeal.Create(pToken.Token, vBaseDeal,
              qryOrcamentosDEALSTAGEID.AsString, vContacts, vDealSource,
              vCampaign, vOrganization, vDealLostReason);

            vSerialized := vDeal.Serialize;

            vSerialized := StringReplace(vSerialized, '"' + sTrue + '"', 'true',
              [rfReplaceAll]);
            vSerialized := StringReplace(vSerialized, '"' + sFalse + '"',
              'false', [rfReplaceAll]);
            vSerialized := StringReplace(vSerialized, '"' + sNull + '"', 'null',
              [rfReplaceAll]);

            pData.RESTRequest.ClearBody;

            if vInsOrUpd = 'I' then
            begin
              pData.RESTRequest.Method := TRESTRequestMethod.rmPOST;
              pData.RESTRequest.Resource := pPaths.postDeals;
              pData.RESTRequest.Body.Add(vSerialized, ctAPPLICATION_JSON);
              pData.RESTRequest.Execute;
              vStatusCode := pData.RESTResponse.StatusCode;

              if vStatusCode = 200 then
                Inc(vInsert);
            end
            else
            begin
              pData.RESTRequest.Method := TRESTRequestMethod.rmPUT;
              pData.RESTRequest.Resource := StringReplace(pPaths.putDeals,
                '$id', pData.qryOrcamentosIDRDSTATION.AsString, [rfIgnoreCase]);
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
                NotifyCreation(pMemo, pData, qryOrcamentosORCAMENTOID.AsInteger,
                  vResponse);
              end
              else
              begin
                NotifyUpdate(pMemo, pData, qryOrcamentosORCAMENTOID.AsInteger,
                  vResponse);

                // No caso de alteração do orçamento, remove todos
                // os itens previamente cadastrados no RD Station.
                RemoveProducts(pMemo, pData, pPaths, pToken,
                  qryOrcamentosIDRDSTATION.AsString);
              end;

              // Proposta Ganha pode ser C, A ou E
              // C - Cancelada
              // A - Aberta
              // E - Encerrada (ganha)
              if qryOrcamentosPROPOSTAGANHA.AsString <> 'E' then
              begin
                // Inclui os produtos do orçamento
                IncludeProducts(pMemo, pData, pPaths, pToken, vResponse._id,
                  qryOrcamentosORCAMENTOID.AsInteger,
                  qryOrcamentosItensOrcamento);
              end
              else
              begin
                // Inclui os produtos do pedido
                IncludeProducts(pMemo, pData, pPaths, pToken, vResponse._id,
                  qryOrcamentosPEDIDOID.AsInteger, qryOrcamentosItensPedido);
              end;

            end
            else
            begin
              vErro := True;
              vMessage := 'Erro: ' + IntToStr(vStatusCode) + ' - OrcamentoID: '
                + qryOrcamentosORCAMENTOID.AsString + #13#10 +
                pData.RESTResponse.Content;
              InsertMemo(pMemo, vMessage);

              if pData.SaveJsonOnError then
              begin
                if vInsOrUpd = 'I' then
                  SaveJson('CreateDeal_', pData.LogPath, vSerialized)
                else
                  SaveJson('UpdateDeal_', pData.LogPath, vSerialized);
              end;

            end;

            qryOrcamentos.Next;
            Application.ProcessMessages;
            Sleep(500);
            Application.ProcessMessages;
            Sleep(500);
          end;

          if vErro or (pData.Tag < 0) then
            Exit;

          qryOrcamentos.Close;
          qryOrcamentos.Open;

        until qryOrcamentos.Eof;

      except
        InsertMemo(pMemo, vMessage);
        Result := False;
      end;
    finally
      qryOrcamentos.Close;

      vMessage := 'Oportunidades finalizadas: ';

      case vInsert of
        0:
          vMessage := vMessage + '(0 inclusão, ';
        1:
          vMessage := vMessage + '(1 inclusão, ';
      else
        vMessage := vMessage + '(' + FormatFloat('#,##0', vInsert) +
          ' inclusões, ';
      end;

      vUpdate := vUpdate - vInsert;

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

function AssembleContact(pQryContato: TADOQuery; pContatoID: Integer;
  out pContacts: TArray<TBaseContact>): Boolean;
var
  vContact: TBaseContact;
  vTitle: string;
  vFacebook: string;
  vLinkedin: string;
  vSkype: string;
  vBirthDay: TMyDate;
  vEmails: TArray<TEmail>;
  vPhones: TArray<TPhone>;
  vDealIds: TArray<string>;
  vLegalBases: TArray<TLegalBase>;
  vEmail: string;
begin
  vTitle := '';
  vFacebook := '';
  vLinkedin := '';
  vSkype := '';
  vBirthDay := nil;
  SetLength(vEmails, 0);
  SetLength(vPhones, 0);
  SetLength(vDealIds, 0);
  SetLength(vLegalBases, 0);

  pQryContato.Parameters.ParamByName('CONTATOID').Value := pContatoID;

  with pQryContato do
    try

      Open;

      if not FieldByName('EMAIL').IsNull then
      begin
        SetLength(vEmails, 1);

        if Pos(';', FieldByName('EMAIL').AsString) = 0 then
        begin
          vEmail := FieldByName('EMAIL').AsString;
        end
        else
        begin
          vEmail := Copy(FieldByName('EMAIL').AsString, 1,
            Pos(';', FieldByName('EMAIL').AsString) - 1);
        end;

        vEmails[0] := TEmail.Create(vEmail);
      end;

      if FoneValido(FieldByName('TELFIXO').AsString) then
      begin
        SetLength(vPhones, Length(vPhones) + 1);
        vPhones[Length(vPhones) - 1] :=
          TPhone.Create(FieldByName('TELFIXO').AsString);
      end;

      if FoneValido(FieldByName('TELFIXO02').AsString) then
      begin
        SetLength(vPhones, Length(vPhones) + 1);
        vPhones[Length(vPhones) - 1] :=
          TPhone.Create(FieldByName('TELFIXO02').AsString);
      end;

      if FoneValido(FieldByName('TELMOVEL').AsString) then
      begin
        SetLength(vPhones, Length(vPhones) + 1);
        vPhones[Length(vPhones) - 1] :=
          TPhone.Create(FieldByName('TELMOVEL').AsString);
      end;

      if FoneValido(FieldByName('TELMOVEL02').AsString) then
      begin
        SetLength(vPhones, Length(vPhones) + 1);
        vPhones[Length(vPhones) - 1] :=
          TPhone.Create(FieldByName('TELMOVEL02').AsString);
      end;

      vContact := TBaseContact.Create(FieldByName('NOME').AsString, vTitle,
        vFacebook, vLinkedin, vSkype, vBirthDay, vEmails, vPhones,
        FieldByName('IDRDSTATION').AsString, vDealIds, vLegalBases);

      if (vContact.name <> EmptyStr) and (Length(vContact.emails) > 0) then
      begin
        SetLength(pContacts, 1);
        pContacts[0] := vContact;
      end;

      Result := True;
    finally
      Close;
    end;

end;

function NotifyCreation(pMemo: TMemo; pData: TDModule; pOrcamentoID: Integer;
  pResponse: TResponse): Boolean;
var
  vCreatedAt: TDateTime;
  vUpdatedAt: TDateTime;
begin

  try
    pData.ADOConnection.BeginTrans;

    vCreatedAt := ISO8601ToDate(pResponse.created_at, False);
    if pResponse.updated_at <> EmptyStr then
      vUpdatedAt := ISO8601ToDate(pResponse.updated_at, False)
    else
      vUpdatedAt := vCreatedAt;

    // Quando for inclusão de orçamentos, faz a inclusão e já elenca
    // o orçamento para uma nova atualização para que o campo WIN
    // seja preenchido corretamente caso este tenha valor logo na
    // primeira inclusão a ser executada
    vUpdatedAt := vUpdatedAt - 365;

    with pData.cmdInsertRDSOrcamento do
    begin
      with Parameters do
      begin
        ParamByName('ORCAMENTOID').Value := pOrcamentoID;
        ParamByName('IDRDSTATION').Value := pResponse._id;
        ParamByName('CREATEDAT').Value := vCreatedAt;
        ParamByName('UPDATEDAT').Value := vUpdatedAt;
        ParamByName('UPDATEDTIMES').Value := 0;
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
        'Problemas ao tentar executar CallAPIDeals.NotifyCreation!' + #13#10 +
        'ORCAMENTOID=' + IntToStr(pOrcamentoID));
      InsertMemo(pMemo, Ex.Message);
      Result := False;
    end;
  end;

end;

function NotifyUpdate(pMemo: TMemo; pData: TDModule; pOrcamentoID: Integer;
  pResponse: TResponse): Boolean;
var
  vUpdatedAt: TDateTime;
begin

  try
    pData.ADOConnection.BeginTrans;

    vUpdatedAt := Now;

    with pData.cmdUpdateRDSOrcamento do
    begin
      with Parameters do
      begin
        ParamByName('ORCAMENTOID').Value := pOrcamentoID;
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
        'Problemas ao tentar executar CallAPIDeals.NotifyUpdate!');
      InsertMemo(pMemo, Ex.Message);
      Result := False;
    end;
  end;

end;

procedure SaveJson(pSubject: string; pPath: string; pJson: string);
var
  vFile: string;
  vStrList: TStringList;
begin

  vFile := pPath + '\' + pSubject + FormatDateTime('yyyymmddhhnnsszzz', Now)
    + '.json';

  vStrList := TStringList.Create;
  try
    vStrList.Add(pJson);
    vStrList.SaveToFile(vFile);
  finally
    vStrList.Free;
  end;

end;

procedure IncludeProducts(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: TToken; pRDSOrcamentoID: string; pID: Integer;
  pQryProdutos: TADOQuery);
var
  vDealProduct: TDealProduct;
  vSerialized: widestring;
  vStatusCode: word;
  vMessage: string;
begin

  pData.RESTRequest.Method := TRESTRequestMethod.rmPOST;
  pData.RESTRequest.Resource := StringReplace(pPaths.postDealProducts, '$id',
    pRDSOrcamentoID, [rfIgnoreCase]);

  with pQryProdutos do
    try
      Parameters.ParamByName('ID').Value := pID;
      Open;

      while not Eof do
      begin
        vDealProduct := TDealProduct.Create(pToken.Token,
          FieldByName('RDSPRODUTOID').AsString, FieldByName('VRUNITARIO')
          .AsFloat, FieldByName('QTDPRODUTO').AsFloat);

        vSerialized := vDealProduct.Serialize;

        pData.RESTRequest.ClearBody;

        pData.RESTRequest.Body.Add(vSerialized, ctAPPLICATION_JSON);
        pData.RESTRequest.Execute;
        vStatusCode := pData.RESTResponse.StatusCode;

        if vStatusCode <> 201 then
        begin

          vMessage := 'Erro: ' + IntToStr(vStatusCode) + ' - OrcamentoID: ' +
            pData.qryOrcamentosORCAMENTOID.AsString + #13#10 +
            pData.RESTResponse.Content;
          InsertMemo(pMemo, vMessage);

          if pData.SaveJsonOnError then
          begin
            if pData.qryOrcamentosINSORUPD.AsString = 'I' then
              SaveJson('CreateDealProduct_', pData.LogPath, vSerialized)
            else
              SaveJson('UpdateDealProduct_', pData.LogPath, vSerialized);
          end;

        end;

        vDealProduct.Free;

        Next;
      end;

    finally
      Close;
    end;

end;

procedure RemoveProducts(pMemo: TMemo; pData: TDModule; pPaths: TPaths;
  pToken: TToken; pRDStationID: string);
var
  vStatusCode: Integer;
  vPath: string;
  vSerialized: widestring;
  vGetDealProducts: TGetDealProducts;
  I: word;
begin

  vGetDealProducts := TGetDealProducts.Create;
  try

    pData.RESTRequest.Method := TRESTRequestMethod.rmGET;
    pData.RESTRequest.Resource :=
      StringReplace(StringReplace(pPaths.GetDealProducts, '$id', pRDStationID,
      [rfIgnoreCase]), '$token', pToken.Token, [rfIgnoreCase]);
    pData.RESTRequest.ClearBody;
    pData.RESTRequest.Execute;
    vStatusCode := pData.RESTResponse.StatusCode;

    if vStatusCode = 200 then
    begin
      vSerialized := pData.RESTResponse.Content;
      vGetDealProducts.Deserialize(vSerialized);

      pData.RESTRequest.Method := TRESTRequestMethod.rmDELETE;
      pData.RESTRequest.ClearBody;

      if Length(vGetDealProducts.deal_products) > 0 then
      begin
        // Passa todos os itens do vetor para executar a exclusão de um por um
        for I := 0 to Length(vGetDealProducts.deal_products) - 1 do
        begin
          vPath := pPaths.deleteDealProducts;
          vPath := StringReplace(vPath, '$id', pRDStationID, [rfIgnoreCase]);
          vPath := StringReplace(vPath, '$idproducts',
            vGetDealProducts.deal_products[I].Id, [rfIgnoreCase]);
          vPath := StringReplace(vPath, '$token', pToken.Token, [rfIgnoreCase]);

          pData.RESTRequest.Resource := vPath;
          pData.RESTRequest.ClearBody;
          pData.RESTRequest.Execute;
          vStatusCode := pData.RESTResponse.StatusCode;

          if vStatusCode <> 204 then
          begin
            SaveJson('DeleteDealProduct_', pData.LogPath,
              pPaths.BaseURL + '/' + vPath);
          end;

        end;

      end;

    end;

  finally
    vGetDealProducts.Free;
  end;

end;

end.
