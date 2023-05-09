object DModule: TDModule
  OldCreateOrder = False
  Height = 453
  Width = 653
  object ADOConnection: TADOConnection
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'SQLOLEDB.1'
    Left = 70
    Top = 8
  end
  object qryProdutos: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT PRD.PRODUTOID,'
      '       RDS.IDRDSTATION,'
      '       PRD.CODESTOQUE,'
      '       PRD.DESCRICAO,'
      '       CAST(0.0 AS NUMERIC(10,2)) AS PRECO,'
      
        '       CASE WHEN RDS.PRODUTOID IS NULL THEN '#39'I'#39' ELSE '#39'U'#39' END INS' +
        'ORUPD'
      'FROM EST_PRODUTO PRD'
      '     LEFT JOIN RDS_Produto RDS ON RDS.PRODUTOID = PRD.PRODUTOID'
      'WHERE RDS.PRODUTOID IS NULL OR RDS.UPDATEDAT < PRD.DTALTERACAO'
      'ORDER BY PRD.PRODUTOID;')
    Left = 72
    Top = 64
    object qryProdutosPRODUTOID: TIntegerField
      FieldName = 'PRODUTOID'
    end
    object qryProdutosIDRDSTATION: TStringField
      FieldName = 'IDRDSTATION'
      Size = 50
    end
    object qryProdutosCODESTOQUE: TStringField
      FieldName = 'CODESTOQUE'
      Size = 30
    end
    object qryProdutosDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
    object qryProdutosPRECO: TBCDField
      FieldName = 'PRECO'
      ReadOnly = True
      Precision = 10
      Size = 2
    end
    object qryProdutosINSORUPD: TStringField
      FieldName = 'INSORUPD'
      ReadOnly = True
      Size = 1
    end
  end
  object RESTClient: TRESTClient
    Params = <>
    Left = 424
    Top = 8
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    Left = 496
    Top = 8
  end
  object RESTResponse: TRESTResponse
    Left = 576
    Top = 8
  end
  object cmdInsertRDSProduto: TADOCommand
    CommandText = 
      'INSERT INTO RDS_PRODUTO'#13#10'(PRODUTOID, IDRDSTATION, CREATEDAT, UPD' +
      'ATEDAT, UPDATEDTIMES)'#13#10'VALUES'#13#10'(:PRODUTOID, :IDRDSTATION, :CREAT' +
      'EDAT, :UPDATEDAT, :UPDATEDTIMES);'#13#10
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'PRODUTOID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'IDRDSTATION'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 50
        Value = Null
      end
      item
        Name = 'CREATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'UPDATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'UPDATEDTIMES'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 179
    Top = 64
  end
  object cmdUpdateRDSProduto: TADOCommand
    CommandText = 
      'UPDATE RDS_PRODUTO'#13#10'SET UPDATEDAT = :UPDATEDAT,'#13#10'    UPDATEDTIME' +
      'S = UPDATEDTIMES + 1'#13#10'WHERE PRODUTOID = :PRODUTOID;'#13#10
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'UPDATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'PRODUTOID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 312
    Top = 64
  end
  object qryParceiros: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'DATAEMISSAO'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end>
    SQL.Strings = (
      'SELECT PAR.PARCEIROID,'
      '       RDS.IDRDSTATION,'
      '       PAR.APELIDO,'
      '       PAR.RAZAONOME + '#39' - '#39' + PAR.APELIDO AS RAZAONOME,'
      '       CAT.APELIDO AS SEGMENTO,'
      '       COM.CODEXTERNO AS USUARIOID,'
      
        '       PEN.DESCRICAO + '#39',  '#39' + PEN.NRO + '#39' '#39' + COALESCE(PEN.COMP' +
        'LEMENTO, '#39#39') + '#39' - '#39' + COALESCE(PEN.BAIRRO, '#39' '#39' )'
      
        '       + '#39' - '#39' + CID.DESCRICAO + '#39' - '#39' + EST.SIGLAUF + '#39' - '#39' + P' +
        'EN.CEP AS ENDERECO,'
      '       '#39#39' AS URL,'
      
        '       CASE WHEN RDS.PARCEIROID IS NULL THEN '#39'I'#39' ELSE '#39'U'#39' END IN' +
        'SORUPD'
      'FROM CAD_PARCEIRO PAR'
      
        '     LEFT JOIN RDS_PARCEIRO RDS ON RDS.PARCEIROID = PAR.PARCEIRO' +
        'ID'
      
        '     LEFT JOIN CAD_PARCEIROENDERECO PEN ON PEN.PARCEIROID = PAR.' +
        'PARCEIROID AND TIPO = '#39'P'#39
      
        '     LEFT JOIN CAD_CATEGORIA CAT ON CAT.CATEGORIAID = PAR.CATEGO' +
        'RIAID'
      
        '     LEFT JOIN VDA_COMISSIONADO COM ON COM.COMISSIONADOID = PAR.' +
        'VENDEDORID'
      '     LEFT JOIN CAD_CIDADE CID ON CID.CIDADEID = PEN.CIDADEID'
      '     LEFT JOIN CAD_UF EST ON EST.UFID = CID.UFID'
      
        'WHERE (RDS.PARCEIROID IS NULL OR RDS.UPDATEDAT < PAR.DTALTERACAO' +
        ')'
      '  AND (PAR.TIPOCLIENTE = '#39'S'#39') -- APENAS CLIENTE'
      '  AND (PAR.ATIVO = '#39'S'#39') -- APENAS ATIVOS'
      
        '  AND (PAR.PARCEIROID IN (SELECT PARCEIROID FROM VDA_ORCAMENTO W' +
        'HERE DTEMISSAO >= :DATAEMISSAO))'
      'ORDER BY PAR.PARCEIROID'
      '')
    Left = 72
    Top = 120
    object qryParceirosPARCEIROID: TIntegerField
      FieldName = 'PARCEIROID'
    end
    object qryParceirosIDRDSTATION: TStringField
      FieldName = 'IDRDSTATION'
      Size = 50
    end
    object qryParceirosAPELIDO: TStringField
      FieldName = 'APELIDO'
    end
    object qryParceirosRAZAONOME: TStringField
      FieldName = 'RAZAONOME'
      ReadOnly = True
      Size = 103
    end
    object qryParceirosSEGMENTO: TStringField
      FieldName = 'SEGMENTO'
    end
    object qryParceirosUSUARIOID: TStringField
      FieldName = 'USUARIOID'
      Size = 30
    end
    object qryParceirosENDERECO: TStringField
      FieldName = 'ENDERECO'
      ReadOnly = True
      Size = 260
    end
    object qryParceirosURL: TStringField
      FieldName = 'URL'
      ReadOnly = True
      Size = 1
    end
    object qryParceirosINSORUPD: TStringField
      FieldName = 'INSORUPD'
      ReadOnly = True
      Size = 1
    end
  end
  object cmdInsertRDSParceiro: TADOCommand
    CommandText = 
      'INSERT INTO RDS_PARCEIRO'#13#10'(PARCEIROID, IDRDSTATION, CREATEDAT, U' +
      'PDATEDAT, UPDATEDTIMES)'#13#10'VALUES'#13#10'(:PARCEIROID, :IDRDSTATION, :CR' +
      'EATEDAT, :UPDATEDAT, :UPDATEDTIMES);'#13#10
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'PARCEIROID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'IDRDSTATION'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 50
        Value = Null
      end
      item
        Name = 'CREATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'UPDATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'UPDATEDTIMES'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 179
    Top = 120
  end
  object cmdUpdateCADProduto: TADOCommand
    CommandText = 
      'UPDATE CAD_PARCEIRO'#13#10'SET CODEXTERNO = :IDRDSTATION'#13#10'WHERE PARCEI' +
      'ROiD = :PARCEIROID'
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'IDRDSTATION'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'PARCEIROID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 312
    Top = 120
  end
  object cmdUpdateRDSParceiro: TADOCommand
    CommandText = 
      'UPDATE RDS_PARCEIRO'#13#10'SET UPDATEDAT = :UPDATEDAT,'#13#10'    UPDATEDTIM' +
      'ES = UPDATEDTIMES + 1'#13#10'WHERE PARCEIROID = :PARCEIROID;'#13#10
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'UPDATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'PARCEIROID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 436
    Top = 120
  end
  object qryContatos: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '    CON.CONTATOID,'
      '    RDC.IDRDSTATION,'
      '    CON.PARCEIROID,'
      '    CON.NOME,'
      '    CON.CARGO,'
      '    CON.TELFIXO,'
      '    CON.TELFIXO02,'
      '    CON.TELMOVEL,'
      '    CON.TELMOVEL02,'
      '    CON.EMAIL,'
      '    RDP.IDRDSTATION AS ORGANIZATIONID,'
      
        '    CASE WHEN RDC.CONTATOID IS NULL THEN '#39'I'#39' ELSE '#39'U'#39' END INSORU' +
        'PD'
      'FROM CAD_PARCEIROCONTATO CON'
      '     JOIN CAD_PARCEIRO PAR ON PAR.PARCEIROID = CON.PARCEIROID'
      '     JOIN RDS_PARCEIRO RDP ON RDP.PARCEIROID = CON.PARCEIROID'
      'LEFT JOIN RDS_CONTATO RDC ON RDC.CONTATOID = CON.CONTATOID'
      'WHERE (RDC.CONTATOID IS NULL OR RDC.UPDATEDAT < PAR.DTALTERACAO)'
      '  AND CON.EMAIL IS NOT NULL'
      'ORDER BY CON.PARCEIROID, CON.CONTATOID;')
    Left = 72
    Top = 176
    object qryContatosCONTATOID: TIntegerField
      FieldName = 'CONTATOID'
    end
    object qryContatosIDRDSTATION: TStringField
      FieldName = 'IDRDSTATION'
      Size = 50
    end
    object qryContatosPARCEIROID: TIntegerField
      FieldName = 'PARCEIROID'
    end
    object qryContatosNOME: TStringField
      FieldName = 'NOME'
      Size = 80
    end
    object qryContatosCARGO: TStringField
      FieldName = 'CARGO'
      Size = 30
    end
    object qryContatosTELFIXO: TStringField
      FieldName = 'TELFIXO'
      Size = 30
    end
    object qryContatosTELFIXO02: TStringField
      FieldName = 'TELFIXO02'
      Size = 30
    end
    object qryContatosTELMOVEL: TStringField
      FieldName = 'TELMOVEL'
      Size = 30
    end
    object qryContatosTELMOVEL02: TStringField
      FieldName = 'TELMOVEL02'
      Size = 30
    end
    object qryContatosEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 160
    end
    object qryContatosORGANIZATIONID: TStringField
      FieldName = 'ORGANIZATIONID'
      Size = 50
    end
    object qryContatosINSORUPD: TStringField
      FieldName = 'INSORUPD'
      ReadOnly = True
      Size = 1
    end
  end
  object cmdInsertRDSContato: TADOCommand
    CommandText = 
      'INSERT INTO RDS_CONTATO'#13#10'(CONTATOID, IDRDSTATION, CREATEDAT, UPD' +
      'ATEDAT, UPDATEDTIMES, RECOVERED)'#13#10'VALUES'#13#10'(:CONTATOID, :IDRDSTAT' +
      'ION, :CREATEDAT, :UPDATEDAT, :UPDATEDTIMES, :RECOVERED);'#13#10
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'CONTATOID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'IDRDSTATION'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 50
        Value = Null
      end
      item
        Name = 'CREATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'UPDATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'UPDATEDTIMES'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'RECOVERED'
        Attributes = [paNullable]
        DataType = ftBoolean
        NumericScale = 255
        Precision = 255
        Size = 2
        Value = Null
      end>
    Left = 179
    Top = 176
  end
  object cmdUpdateRDSContato: TADOCommand
    CommandText = 
      'UPDATE RDS_CONTATO'#13#10'SET UPDATEDAT = :UPDATEDAT,'#13#10'    UPDATEDTIME' +
      'S = UPDATEDTIMES + 1'#13#10'WHERE CONTATOID = :CONTATOID;'#13#10
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'UPDATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'CONTATOID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 312
    Top = 176
  end
  object qryOrcamentos: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'IdStatusOrcamento'
        DataType = ftInteger
        Size = -1
        Value = Null
      end
      item
        Name = 'DataEmissaoA'
        DataType = ftDateTime
        Size = -1
        Value = Null
      end
      item
        Name = 'DataEmissaoB'
        DataType = ftDateTime
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '    1 ESTAGIO,'
      '    ORC.ORCAMENTOID,-- numero do orcamento / oportunidade'
      '    RDO.IDRDSTATION,'
      
        '    '#39'OR'#199'AMENTO #'#39' + CAST(ORC.ORCAMENTOID AS VARCHAR) AS NOMEORCA' +
        'MENTO,'
      '    1 AS RATING,'
      '    PED.PEDIDOID,'
      '    ORC.DTEMISSAO,   -- dt emissao da oportunidade'
      '    ORC.PARCEIROID, --parceiroid /empresa da oportunidade'
      '    RDP.IDRDSTATION AS RDSPARCEIROID,'
      '    ORC.PARCEIROCONTATOID, -- Contato da opotunidade'
      '    RDC.IDRDSTATION AS RDSCONTATOID,'
      
        '    COALESCE(COM.CODEXTERNO, '#39#39') AS USERID, --id do usu'#225'rio resp' +
        'ons'#225'vel / vendedor'
      '    '#39#39' AS DEALSOURCE, --source da oportunidade'
      '    '#39#39' AS CAMPAIGN,'
      
        '    COALESCE(ST2.CODEXTERNO, (SELECT TOP 1 CODEXTERNO FROM VDA_S' +
        'TATUS STX WHERE STX.CODINTERNO = '#39'I'#39' ORDER BY STX.STATUSID)) AS ' +
        'DEALSTAGEID, --status do funil'
      '    STT.CODINTERNO AS STATUSORCAMENTO,'
      '    '#39'A'#39' AS PROPOSTAGANHA,'
      '    ORC.DTALTERACAO ORCAMENTODTALTERACAO,'
      '    PED.DTALTERACAO PEDIDODTALTERACAO,'
      
        '    COALESCE(TCN.CODEXTERNO, '#39#39') AS DEALLOSTREASON, --MOTIVO DE ' +
        'CANCELAMENTO'
      
        '    CASE WHEN RDO.ORCAMENTOID IS NULL THEN '#39'I'#39' ELSE '#39'U'#39' END INSO' +
        'RUPD'
      'FROM VDA_ORCAMENTO ORC'
      'LEFT JOIN VDA_PEDIDO PED ON PED.pedidoid = ORC.pedidoid'
      
        'LEFT JOIN VDA_COMISSIONADO COM ON COM.COMISSIONADOID = ORC.VENDE' +
        'DORID'
      'LEFT JOIN VDA_STATUS STT ON STT.STATUSID = ORC.STATUSFOLLOWUPID'
      'LEFT JOIN RDS_PARCEIRO RDP ON RDP.PARCEIROID = ORC.PARCEIROID'
      
        'LEFT JOIN RDS_CONTATO RDC ON RDC.CONTATOID = ORC.PARCEIROCONTATO' +
        'ID'
      'LEFT JOIN RDS_ORCAMENTO RDO ON RDO.ORCAMENTOID = ORC.ORCAMENTOID'
      
        'LEFT JOIN VDA_TIPOCANCELAMENTO TCN ON TCN.TIPOCANCELAMENTOID = O' +
        'RC.TIPOCANCELAMENTOID'
      'LEFT JOIN VDA_STATUS ST2 ON ST2.STATUSID = :IdStatusOrcamento'
      
        'WHERE RDO.ORCAMENTOID IS NULL AND RDP.IDRDSTATION IS NOT NULL AN' +
        'D ORC.DTEMISSAO >= :DataEmissaoA'
      '--AND ORC.ORCAMENTOID = 6457'
      ''
      'UNION ALL'
      ''
      'SELECT'
      '    2 ESTAGIO,'
      '    ORC.ORCAMENTOID, -- numero do orcamento / oportunidade'
      '    RDO.IDRDSTATION,'
      
        '    '#39'OR'#199'AMENTO #'#39' + CAST(ORC.ORCAMENTOID AS VARCHAR) AS NOMEORCA' +
        'MENTO,'
      '    1 AS RATING,'
      '    PED.PEDIDOID,'
      '    ORC.DTEMISSAO,   -- dt emissao da oportunidade'
      '    ORC.PARCEIROID, --parceiroid /empresa da oportunidade'
      '    RDP.IDRDSTATION AS RDSPARCEIROID,'
      '    ORC.PARCEIROCONTATOID, -- Contato da opotunidade'
      '    RDC.IDRDSTATION AS RDSCONTATOID,'
      
        '    COALESCE(COM.CODEXTERNO, '#39#39') AS USERID, --id do usu'#225'rio resp' +
        'ons'#225'vel / vendedor'
      '    '#39#39' AS DEALSOURCE, --source da oportunidade'
      '    '#39#39' AS CAMPAIGN,'
      #9'CASE'
      #9'  WHEN ((PED.PEDIDOID IS NOT NULL) AND (ORC.STATUS = '#39'E'#39')) THEN'
      
        #9'    COALESCE(STP.CODEXTERNO, (SELECT CODEXTERNO FROM VDA_STATUS' +
        ' STX WHERE STX.CODINTERNO = '#39'A'#39'  ))'
      
        #9'  ELSE  COALESCE(STT.CODEXTERNO, (SELECT CODEXTERNO FROM VDA_ST' +
        'ATUS STX WHERE STX.CODINTERNO = '#39'A'#39'  ))'
      '    END AS DEALSTAGEID,'
      '    STT.CODINTERNO AS STATUSORCAMENTO,'
      '    CASE'
      
        #9'      WHEN ((PED.PEDIDOID IS NULL) AND (ORC.STATUS = '#39'C'#39')) THEN' +
        ' '#39'C'#39
      
        #9'      WHEN ((PED.PEDIDOID IS NOT NULL) AND (ORC.STATUS = '#39'E'#39')) ' +
        'THEN '#39'E'#39
      #9'      ELSE '#39'A'#39
      #9'  END AS PROPOSTAGANHA,'
      '    ORC.DTALTERACAO ORCAMENTODTALTERACAO,'
      '    PED.DTALTERACAO PEDIDODTALTERACAO,'
      
        '    COALESCE(TCN.CODEXTERNO, '#39#39') AS DEALLOSTREASON, --MOTIVO DE ' +
        'CANCELAMENTO'
      
        '    CASE WHEN RDO.ORCAMENTOID IS NULL AND STT.CODINTERNO <> '#39'3'#39' ' +
        'THEN '#39'I'#39' ELSE '#39'U'#39' END INSORUPD'
      'FROM VDA_ORCAMENTO ORC'
      'LEFT JOIN VDA_PEDIDO PED ON PED.pedidoid = ORC.pedidoid'
      
        'LEFT JOIN VDA_COMISSIONADO COM ON COM.COMISSIONADOID = ORC.VENDE' +
        'DORID'
      'LEFT JOIN VDA_STATUS STT ON STT.STATUSID = ORC.STATUSFOLLOWUPID'
      'LEFT JOIN VDA_STATUS STP ON STP.STATUSID = PED.STATUSFOLLOWUPID'
      'LEFT JOIN RDS_PARCEIRO RDP ON RDP.PARCEIROID = ORC.PARCEIROID'
      
        'LEFT JOIN RDS_CONTATO RDC ON RDC.CONTATOID = ORC.PARCEIROCONTATO' +
        'ID'
      'LEFT JOIN RDS_ORCAMENTO RDO ON RDO.ORCAMENTOID = ORC.ORCAMENTOID'
      
        'LEFT JOIN VDA_TIPOCANCELAMENTO TCN ON TCN.TIPOCANCELAMENTOID = O' +
        'RC.TIPOCANCELAMENTOID'
      
        'WHERE RDP.IDRDSTATION IS NOT NULL AND RDP.IDRDSTATION IS NOT NUL' +
        'L AND (RDO.UPDATEDAT < ORC.DTALTERACAO OR RDO.UPDATEDAT < PED.DT' +
        'ALTERACAO) AND ORC.DTEMISSAO >= :DataEmissaoB'
      '--AND ORC.ORCAMENTOID = 6457'
      ''
      'ORDER BY ESTAGIO, ORC.ORCAMENTOID;')
    Left = 72
    Top = 232
    object qryOrcamentosESTAGIO: TIntegerField
      FieldName = 'ESTAGIO'
      ReadOnly = True
    end
    object qryOrcamentosORCAMENTOID: TIntegerField
      FieldName = 'ORCAMENTOID'
      ReadOnly = True
    end
    object qryOrcamentosIDRDSTATION: TStringField
      FieldName = 'IDRDSTATION'
      ReadOnly = True
      Size = 50
    end
    object qryOrcamentosNOMEORCAMENTO: TStringField
      FieldName = 'NOMEORCAMENTO'
      ReadOnly = True
      Size = 41
    end
    object qryOrcamentosRATING: TIntegerField
      FieldName = 'RATING'
      ReadOnly = True
    end
    object qryOrcamentosPEDIDOID: TIntegerField
      FieldName = 'PEDIDOID'
      ReadOnly = True
    end
    object qryOrcamentosDTEMISSAO: TDateTimeField
      FieldName = 'DTEMISSAO'
      ReadOnly = True
    end
    object qryOrcamentosPARCEIROID: TIntegerField
      FieldName = 'PARCEIROID'
      ReadOnly = True
    end
    object qryOrcamentosRDSPARCEIROID: TStringField
      FieldName = 'RDSPARCEIROID'
      ReadOnly = True
      Size = 50
    end
    object qryOrcamentosPARCEIROCONTATOID: TIntegerField
      FieldName = 'PARCEIROCONTATOID'
      ReadOnly = True
    end
    object qryOrcamentosRDSCONTATOID: TStringField
      FieldName = 'RDSCONTATOID'
      ReadOnly = True
      Size = 50
    end
    object qryOrcamentosUSERID: TStringField
      FieldName = 'USERID'
      ReadOnly = True
      Size = 30
    end
    object qryOrcamentosDEALSOURCE: TStringField
      FieldName = 'DEALSOURCE'
      ReadOnly = True
      Size = 1
    end
    object qryOrcamentosCAMPAIGN: TStringField
      FieldName = 'CAMPAIGN'
      ReadOnly = True
      Size = 1
    end
    object qryOrcamentosDEALSTAGEID: TStringField
      FieldName = 'DEALSTAGEID'
      ReadOnly = True
      Size = 30
    end
    object qryOrcamentosSTATUSORCAMENTO: TStringField
      FieldName = 'STATUSORCAMENTO'
      ReadOnly = True
      Size = 15
    end
    object qryOrcamentosPROPOSTAGANHA: TStringField
      FieldName = 'PROPOSTAGANHA'
      ReadOnly = True
      Size = 1
    end
    object qryOrcamentosORCAMENTODTALTERACAO: TDateTimeField
      FieldName = 'ORCAMENTODTALTERACAO'
      ReadOnly = True
    end
    object qryOrcamentosPEDIDODTALTERACAO: TDateTimeField
      FieldName = 'PEDIDODTALTERACAO'
      ReadOnly = True
    end
    object qryOrcamentosDEALLOSTREASON: TStringField
      FieldName = 'DEALLOSTREASON'
      ReadOnly = True
      Size = 30
    end
    object qryOrcamentosINSORUPD: TStringField
      FieldName = 'INSORUPD'
      ReadOnly = True
      Size = 1
    end
  end
  object qryOrcamentosItensOrcamento: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'ID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '    ITM.PRODUTOID, '
      '    RDS.IDRDSTATION AS RDSPRODUTOID,'
      '    PRO.CODESTOQUE AS NOME,'
      '    PRO.DESCRICAO,'
      '    CAST(ITM.QTDSALDO AS INT) QTDSALDO,'
      '    ITM.VRUNITARIO,'
      '    CAST(ITM.QTDPRODUTO AS INT) QTDPRODUTO,'
      '    ITM.VRUNITARIO * ITM.QTDPRODUTO AS TOTAL,'
      '    '#39#39' AS DISCOUNT_TYPE,'
      '    '#39#39' AS RECURRENCE'
      'FROM VDA_ORCAMENTOITEM ITM'
      '     JOIN EST_PRODUTO PRO ON PRO.PRODUTOID = ITM.PRODUTOID'
      'LEFT JOIN RDS_PRODUTO RDS ON RDS.PRODUTOID = ITM.PRODUTOID'
      'WHERE ITM.ORCAMENTOID = :ID'
      'ORDER BY PRO.DESCRICAO;'
      '')
    Left = 72
    Top = 280
    object qryOrcamentosItensOrcamentoPRODUTOID: TIntegerField
      FieldName = 'PRODUTOID'
    end
    object qryOrcamentosItensOrcamentoRDSPRODUTOID: TStringField
      FieldName = 'RDSPRODUTOID'
      Size = 50
    end
    object qryOrcamentosItensOrcamentoNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object qryOrcamentosItensOrcamentoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
    object qryOrcamentosItensOrcamentoQTDSALDO: TIntegerField
      FieldName = 'QTDSALDO'
      ReadOnly = True
    end
    object qryOrcamentosItensOrcamentoVRUNITARIO: TFloatField
      FieldName = 'VRUNITARIO'
    end
    object qryOrcamentosItensOrcamentoQTDPRODUTO: TIntegerField
      FieldName = 'QTDPRODUTO'
      ReadOnly = True
    end
    object qryOrcamentosItensOrcamentoTOTAL: TFloatField
      FieldName = 'TOTAL'
      ReadOnly = True
    end
    object qryOrcamentosItensOrcamentoDISCOUNT_TYPE: TStringField
      FieldName = 'DISCOUNT_TYPE'
      ReadOnly = True
      Size = 1
    end
    object qryOrcamentosItensOrcamentoRECURRENCE: TStringField
      FieldName = 'RECURRENCE'
      ReadOnly = True
      Size = 1
    end
  end
  object qryOrcamentosItensPedido: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'ID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '    ITM.PRODUTOID,'
      '    RDS.IDRDSTATION AS RDSPRODUTOID,'
      '    PRO.CODESTOQUE AS NOME, '
      '    PRO.DESCRICAO,'
      '    CAST(ITM.QTDSALDO AS INT) QTDSALDO,'
      '    ITM.VRUNITARIO,'
      '    CAST(ITM.QTDPRODUTO AS INT) QTDPRODUTO,'
      '    ITM.VRUNITARIO * ITM.QTDPRODUTO AS TOTAL,'
      '    '#39#39' AS DISCOUNT_TYPE,'
      '    '#39#39' AS RECURRENCE'
      'FROM VDA_PEDIDOITEM ITM'
      '     JOIN EST_PRODUTO PRO ON PRO.PRODUTOID = ITM.PRODUTOID'
      'LEFT JOIN RDS_PRODUTO RDS ON RDS.PRODUTOID = ITM.PRODUTOID'
      'WHERE ITM.PEDIDOID = :ID'
      'ORDER BY PRO.DESCRICAO;')
    Left = 72
    Top = 328
    object qryOrcamentosItensPedidoPRODUTOID: TIntegerField
      FieldName = 'PRODUTOID'
    end
    object qryOrcamentosItensPedidoRDSPRODUTOID: TStringField
      FieldName = 'RDSPRODUTOID'
      Size = 50
    end
    object qryOrcamentosItensPedidoNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object qryOrcamentosItensPedidoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
    object qryOrcamentosItensPedidoQTDSALDO: TIntegerField
      FieldName = 'QTDSALDO'
      ReadOnly = True
    end
    object qryOrcamentosItensPedidoVRUNITARIO: TFloatField
      FieldName = 'VRUNITARIO'
    end
    object qryOrcamentosItensPedidoQTDPRODUTO: TIntegerField
      FieldName = 'QTDPRODUTO'
      ReadOnly = True
    end
    object qryOrcamentosItensPedidoTOTAL: TFloatField
      FieldName = 'TOTAL'
      ReadOnly = True
    end
    object qryOrcamentosItensPedidoDISCOUNT_TYPE: TStringField
      FieldName = 'DISCOUNT_TYPE'
      ReadOnly = True
      Size = 1
    end
    object qryOrcamentosItensPedidoRECURRENCE: TStringField
      FieldName = 'RECURRENCE'
      ReadOnly = True
      Size = 1
    end
  end
  object qryOrcamentosContato: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'CONTATOID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '    CON.CONTATOID,'
      '    RDC.IDRDSTATION,'
      '    CON.PARCEIROID,'
      '    CON.NOME,'
      '    CON.CARGO,'
      '    CON.TELFIXO,'
      '    CON.TELFIXO02,'
      '    CON.TELMOVEL,'
      '    CON.TELMOVEL02,'
      '    CON.EMAIL'
      'FROM CAD_PARCEIROCONTATO CON'
      #9' JOIN CAD_PARCEIRO PAR ON PAR.PARCEIROID = CON.PARCEIROID'
      '     JOIN RDS_PARCEIRO RDP ON RDP.PARCEIROID = CON.CONTATOID'
      'LEFT JOIN RDS_CONTATO RDC ON RDC.CONTATOID = CON.CONTATOID'
      'WHERE CON.CONTATOID = :CONTATOID'
      'ORDER BY CON.PARCEIROID, CON.CONTATOID;')
    Left = 72
    Top = 376
    object qryOrcamentosContatoCONTATOID: TIntegerField
      FieldName = 'CONTATOID'
    end
    object qryOrcamentosContatoIDRDSTATION: TStringField
      FieldName = 'IDRDSTATION'
      Size = 50
    end
    object qryOrcamentosContatoPARCEIROID: TIntegerField
      FieldName = 'PARCEIROID'
    end
    object qryOrcamentosContatoNOME: TStringField
      FieldName = 'NOME'
      Size = 80
    end
    object qryOrcamentosContatoCARGO: TStringField
      FieldName = 'CARGO'
      Size = 30
    end
    object qryOrcamentosContatoTELFIXO: TStringField
      FieldName = 'TELFIXO'
      Size = 30
    end
    object qryOrcamentosContatoTELFIXO02: TStringField
      FieldName = 'TELFIXO02'
      Size = 30
    end
    object qryOrcamentosContatoTELMOVEL: TStringField
      FieldName = 'TELMOVEL'
      Size = 30
    end
    object qryOrcamentosContatoTELMOVEL02: TStringField
      FieldName = 'TELMOVEL02'
      Size = 30
    end
    object qryOrcamentosContatoEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 160
    end
  end
  object cmdInsertRDSOrcamento: TADOCommand
    CommandText = 
      'INSERT INTO RDS_ORCAMENTO'#13#10'(ORCAMENTOID, IDRDSTATION, CREATEDAT,' +
      ' UPDATEDAT, UPDATEDTIMES)'#13#10'VALUES'#13#10'(:ORCAMENTOID, :IDRDSTATION, ' +
      ':CREATEDAT, :UPDATEDAT, :UPDATEDTIMES);'
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'ORCAMENTOID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'IDRDSTATION'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 50
        Value = Null
      end
      item
        Name = 'CREATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'UPDATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'UPDATEDTIMES'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 179
    Top = 232
  end
  object cmdUpdateRDSOrcamento: TADOCommand
    CommandText = 
      'UPDATE RDS_ORCAMENTO'#13#10'SET UPDATEDAT = :UPDATEDAT,'#13#10'    UPDATEDTI' +
      'MES = UPDATEDTIMES + 1'#13#10'WHERE ORCAMENTOID = :ORCAMENTOID;'#13#10
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'UPDATEDAT'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'ORCAMENTOID'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 312
    Top = 232
  end
end
