unit CallAPIOrganizations;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, System.SysUtils, REST.Types, System.DateUtils,
  // Units internas do sistema
  SqlData, Paths, Token, MyTools, Organization, CustomFields, Response;

function ManipulateOrganization(pMemo: TMemo; pData: TDModule; pPahts: TPaths;
  pToken: TToken; pDtEmissao: TDateTime): Boolean;
function NotifyCreation(pMemo: TMemo; pData: TDModule; pParceiroId: integer;
  pResponse: TResponse): Boolean;
function NotifyUpdate(pMemo: TMemo; pData: TDModule; pParceiroId: integer;
  pResponse: TResponse): Boolean;

implementation

function ManipulateOrganization(pMemo: TMemo; pData: TDModule; pPahts: TPaths;
  pToken: TToken; pDtEmissao: TDateTime): Boolean;
var
  vOrganization: TOrganization;
  vOrganizationSegments: TArray<string>;
  vOrganizationCustomFields: TArray<TCustomFields>;
  vSerialized: string;
  vInsOrUpd: string;
  vResponse: TResponse;
  vStatusCode, vInsert, vUpdate: integer;
  vMessage: string;
  vAnterior: integer;
begin

  Result := True;

  vInsert := 0;
  vUpdate := 0;

  InsertMemo(pMemo, 'Exportando empresas...');

  vResponse := TResponse.Create;

  with pData do
    try
      try
        pData.RESTClient.BaseURL := pPahts.BaseURL;

        qryParceiros.Parameters.ParamByName('DATAEMISSAO').Value := pDtEmissao;

        qryParceiros.Open;

        while not qryParceiros.Eof and (pData.Tag >= 0) do
        begin

          vInsOrUpd := qryParceirosINSORUPD.AsString;

          SetLength(vOrganizationSegments, 0);

          if not qryParceirosSEGMENTO.IsNull then
          begin
            SetLength(vOrganizationSegments, 1);
            vOrganizationSegments[0] := qryParceirosSEGMENTO.AsString;
          end;

          vOrganization := TOrganization.Create(pToken.Token,
            qryParceirosRAZAONOME.AsString, // pNome
            qryParceirosAPELIDO.AsString, // pResume
            qryParceirosURL.AsString, // pUrl
            qryParceirosUSUARIOID.AsString, // pUserID
            vOrganizationSegments, // pOrganizationSegments
            vOrganizationCustomFields); // (não inicializado)

          vSerialized := vOrganization.Serialize;

          pData.RESTRequest.ClearBody;

          if vInsOrUpd = 'I' then
          begin
            pData.RESTRequest.Method := TRESTRequestMethod.rmPOST;
            pData.RESTRequest.Resource := pPahts.postOrganizations;
            pData.RESTRequest.Body.Add(vSerialized, ctAPPLICATION_JSON);
            pData.RESTRequest.Execute;
            vStatusCode := pData.RESTResponse.StatusCode;
            if vStatusCode = 200 then
              Inc(vInsert);
          end
          else
          begin
            pData.RESTRequest.Method := TRESTRequestMethod.rmPUT;
            pData.RESTRequest.Resource := StringReplace(pPahts.putOrganizations,
              '$id', pData.qryParceirosIDRDSTATION.AsString, [rfIgnoreCase]);
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
              NotifyCreation(pMemo, pData, qryParceirosPARCEIROID.AsInteger,
                vResponse);
            end
            else
            begin
              NotifyUpdate(pMemo, pData, qryParceirosPARCEIROID.AsInteger,
                vResponse);
            end;

          end
          else if vStatusCode = 404 then
          begin
            // Ao executar a chamada de alteração, o ID do RdStation vai na
            // rota, porém, há casos de empresas que foram cadastradas
            // diretamente no RDStation ao invés de serem exportadas
            // por essa rotina, nesse caso, haverá o erro 404
            // (caminho não encontrado), esse tratamento foi colocado
            // aqui para evitar que problemas explodam na tela e também
            // para fazer a baixa de uma eventual atualização na
            // tabela RDS_Parceiro. Teoricamente essa rotina nunca será executada
            vResponse._id := qryParceirosIDRDSTATION.AsString;
            vResponse.updated_at := DateToISO8601(Now);
            NotifyUpdate(pMemo, pData, qryParceirosPARCEIROID.AsInteger,
              vResponse);
          end
          else if vStatusCode = 422 then
          begin
            vSerialized := pData.RESTResponse.Content;
            vResponse.Deserialize(vSerialized);
            NotifyCreation(pMemo, pData, qryParceirosPARCEIROID.AsInteger,
              vResponse);
          end
          else
          begin
            vMessage := 'Erro: ' + IntToStr(vStatusCode) + ' - ParceiroID: ' +
              qryParceirosPARCEIROID.AsString + #13#10 +

              pData.RESTResponse.Content;
            InsertMemo(pMemo, vMessage);
          end;

          vAnterior := qryParceirosPARCEIROID.AsInteger;
          qryParceiros.Next;

          // Por causa do endereço a pesquisa pode retornar
          // mais de uma vez o mesmo ID de parceiro
          if qryParceirosPARCEIROID.AsInteger = vAnterior then
          begin
            qryParceiros.Next;
          end;

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
      qryProdutos.Close;

      vMessage := 'Empresas finalizadas: ';

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

function NotifyCreation(pMemo: TMemo; pData: TDModule; pParceiroId: integer;
  pResponse: TResponse): Boolean;
var
  vCreatedAt: TDateTime;
  vUpdatedAt: TDateTime;
  vBadId: Boolean;
begin

  vBadId := False;

  try
    pData.ADOConnection.BeginTrans;

    if pResponse.created_at <> EmptyStr then
    begin
      vCreatedAt := ISO8601ToDate(pResponse.created_at, False);
      vUpdatedAt := ISO8601ToDate(pResponse.updated_at, False);
    end
    else
    begin
      vBadId := True;
      vCreatedAt := Now;
      vUpdatedAt := vCreatedAt;
    end;

    with pData.cmdInsertRDSParceiro do
    begin
      with Parameters do
      begin
        ParamByName('PARCEIROID').Value := pParceiroId;
        ParamByName('IDRDSTATION').Value := pResponse._id;
        ParamByName('CREATEDAT').Value := vCreatedAt;
        ParamByName('UPDATEDAT').Value := vUpdatedAt;
        ParamByName('UPDATEDTIMES').Value := 0;
      end;
      Execute;
    end;

    if not vBadId then
      with pData.cmdUpdateCADProduto do
      begin
        with Parameters do
        begin
          ParamByName('PARCEIROID').Value := pParceiroId;
          ParamByName('IDRDSTATION').Value := pResponse._id;
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
        'Problemas ao tentar executar CallAPIOrganizations.NotifyCreation!' +
        #13#10 + 'PARCEIROID=' + IntToStr(pParceiroId));
      InsertMemo(pMemo, Ex.Message);
      Result := False;
    end;
  end;

end;

function NotifyUpdate(pMemo: TMemo; pData: TDModule; pParceiroId: integer;
  pResponse: TResponse): Boolean;
var
  vUpdatedAt: TDateTime;
begin
  try
    pData.ADOConnection.BeginTrans;

    vUpdatedAt := Now;

    with pData.cmdUpdateRDSParceiro do
    begin
      with Parameters do
      begin
        ParamByName('PARCEIROID').Value := pParceiroId;
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
        'Problemas ao tentar executar CallAPIOrganizations.NotifyUpdate!' +
        #13#10 + Ex.Message);
      InsertMemo(pMemo, Ex.Message);
      Result := False;
    end;
  end;
end;

end.
