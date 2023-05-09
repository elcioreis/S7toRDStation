SELECT TOP 10
    CON.CONTATOID,
    RDC.IDRDSTATION,
    CON.PARCEIROID,
    CON.NOME,
    CON.CARGO,
    CON.TELFIXO,
    CON.TELFIXO02,
    CON.TELMOVEL,
    CON.TELMOVEL02,
    CON.EMAIL
FROM CAD_PARCEIROCONTATO CON
	 JOIN CAD_PARCEIRO PAR ON PAR.PARCEIROID = CON.PARCEIROID
     JOIN RDS_PARCEIRO RDP ON RDP.PARCEIROID = CON.CONTATOID
LEFT JOIN RDS_CONTATO RDC ON RDC.CONTATOID = CON.CONTATOID
WHERE (RDC.CONTATOID IS NULL OR RDC.UPDATEDAT < PAR.DTALTERACAO)
  AND CON.EMAIL IS NOT NULL
ORDER BY CON.PARCEIROID, CON.CONTATOID;
