unit CallAPIProducts;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, System.SysUtils, REST.Types, System.DateUtils,
  // Units internas do sistema
  SqlData, Paths, Token, MyTools, Product, Response;

function ManipulateProduct(pMemo: TMemo; pData: TDModule; pPahts: TPaths;
  pToken: TToken): Boolean;
function NotifyCreation(pMemo: TMemo; pData: TDModule; pProdutoId: integer;
  pResponse: TResponse): Boolean;
function NotifyUpdate(pMemo: TMemo; pData: TDModule; pProdutoId: integer;
  pResponse: TResponse): Boolean;

implementation

function ManipulateProduct(pMemo: TMemo; pData: TDModule; pPahts: TPaths;
  pToken: TToken): Boolean;
var
  vProduct: TProduct;
  vSerialized: string;
  vInsOrUpd: string;
  vResponse: TResponse;
  vStatusCode, vInsert, vUpdate: integer;
  vMessage: string;
begin

  Result := True;

  vInsert := 0;
  vUpdate := 0;

  InsertMemo(pMemo, 'Exportando produtos...');

  vResponse := TResponse.Create;

  with pData do
    try
      try

        pData.RESTClient.BaseURL := pPahts.BaseURL;

        qryProdutos.Open;

        while not qryProdutos.Eof and (pData.Tag >= 0) do
        begin
          vInsOrUpd := qryProdutosINSORUPD.AsString;

          vProduct := TProduct.Create(pToken.Token,
            qryProdutosDESCRICAO.AsString, qryProdutosDESCRICAO.AsString,
            FormatFloat('0.00', qryProdutosPRECO.AsFloat));

          vSerialized := vProduct.Serialize;

          pData.RESTRequest.ClearBody;

          if vInsOrUpd = 'I' then
          begin
            pData.RESTRequest.Method := TRESTRequestMethod.rmPOST;
            pData.RESTRequest.Resource := pPahts.postProducts;
            pData.RESTRequest.Body.Add(vSerialized, ctAPPLICATION_JSON);
            pData.RESTRequest.Execute;
            vStatusCode := pData.RESTResponse.StatusCode;
            if vStatusCode = 200 then
              Inc(vInsert);
          end
          else
          begin
            pData.RESTRequest.Method := TRESTRequestMethod.rmPUT;
            pData.RESTRequest.Resource := StringReplace(pPahts.putProducts,
              '$id', pData.qryProdutosIDRDSTATION.AsString, [rfIgnoreCase]);
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
              NotifyCreation(pMemo, pData, qryProdutosPRODUTOID.AsInteger,
                vResponse);
            end
            else
            begin
              NotifyUpdate(pMemo, pData, qryProdutosPRODUTOID.AsInteger,
                vResponse);
            end;

          end
          else
          begin
            vMessage := 'Erro: ' + IntToStr(vStatusCode) + ' - ProdutoID: ' +
              qryProdutosPRODUTOID.AsString + #13#10 +
              pData.RESTResponse.Content;
            InsertMemo(pMemo, vMessage);
          end;

          qryProdutos.Next;
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
      vMessage := 'Produtos finalizados: ';

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

function NotifyCreation(pMemo: TMemo; pData: TDModule; pProdutoId: integer;
  pResponse: TResponse): Boolean;
var
  vCreatedAt: TDateTime;
  vUpdatedAt: TDateTime;
begin

  try
    pData.ADOConnection.BeginTrans;

    vCreatedAt := ISO8601ToDate(pResponse.created_at, False);
    vUpdatedAt := ISO8601ToDate(pResponse.updated_at, False);

    with pData.cmdInsertRDSProduto do
    begin
      with Parameters do
      begin
        ParamByName('PRODUTOID').Value := pProdutoId;
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
        'Problemas ao tentar executar CallAPIProducts.NotifyCreation!' + #13#10
        + 'PRODUTOID=' + IntToStr(pProdutoId));
      InsertMemo(pMemo, Ex.Message);
      Result := False;
    end;
  end;

end;

function NotifyUpdate(pMemo: TMemo; pData: TDModule; pProdutoId: integer;
  pResponse: TResponse): Boolean;
var
  vUpdatedAt: TDateTime;
begin

  try
    pData.ADOConnection.BeginTrans;

    vUpdatedAt := Now;

    with pData.cmdUpdateRDSProduto do
    begin
      with Parameters do
      begin
        ParamByName('PRODUTOID').Value := pProdutoId;
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
