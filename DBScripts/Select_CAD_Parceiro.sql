SELECT TOP 10
       PAR.PARCEIROID,
       RDS.IDRDSTATION,
       PAR.APELIDO,
       PAR.RAZAONOME,
       CAT.APELIDO AS SEGMENTO,
       COM.CODEXTERNO AS USUARIOID,
       PEN.DESCRICAO + ',  ' + PEN.NRO + ' ' + COALESCE(PEN.COMPLEMENTO, '') + ' - ' + COALESCE(PEN.BAIRRO, ' ' )
       + ' - ' + CID.DESCRICAO + ' - ' + EST.SIGLAUF + ' - ' + PEN.CEP AS ENDERECO,
      '' AS URL,
       CASE WHEN RDS.PARCEIROID IS NULL THEN 'I' ELSE 'U' END INSORUPD
FROM CAD_PARCEIRO PAR
     LEFT JOIN RDS_PARCEIRO RDS ON RDS.PARCEIROID = PAR.PARCEIROID
     LEFT JOIN CAD_PARCEIROENDERECO PEN ON PEN.PARCEIROID = PAR.PARCEIROID AND TIPO = 'P'
     LEFT JOIN CAD_CATEGORIA CAT ON CAT.CATEGORIAID = PAR.CATEGORIAID
     LEFT JOIN VDA_COMISSIONADO COM ON COM.COMISSIONADOID = PAR.VENDEDORID
     LEFT JOIN CAD_CIDADE CID ON CID.CIDADEID = PEN.CIDADEID
     LEFT JOIN CAD_UF EST ON EST.UFID = CID.UFID
WHERE (RDS.PARCEIROID IS NULL OR RDS.UPDATEDAT < PAR.DTALTERACAO)
  AND (TIPOCLIENTE = 'S') -- APENAS CLIENTE
  AND (PAR.ATIVO = 'S') -- APENAS ATIVOS
  AND ((SELECT COUNT(*) FROM CAD_PARCEIROCONTATO CO WHERE CO.PARCEIROID = PAR.PARCEIROID) >= 1)
  AND (PAR.PARCEIROID IN (SELECT PARCEIROID FROM VDA_ORCAMENTO WHERE DTEMISSAO >= :DATAEMISSAO))
ORDER BY PAR.PARCEIROID
