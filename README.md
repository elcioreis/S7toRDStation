# S7toRDStation

 Integração entre o sistema S7 da RE Sistemas e a API do CRM da RD Station

 As informações são enviadas somente do S7 para o RD Station.
 Os dados do S7 são lidos diretamente no banco de dado SQL Server.
 Para o envio das informações ao CRM é utilizada a API do RD Station.
 O desevolvimento foi executado em Delphi 10.4. 

 Documentação da API em https://developers.rdstation.com/reference/instru%C3%A7%C3%B5es-e-requisitos
 (o caminho da documentação tem caracteres da linha portuguesa)
 
 Utilizo a ferramenta Delphi-neon para fazer serialização/deserialização dos objetos de/para JSON
 Fontes do Delphi-neon em https://github.com/paolo-rossi/delphi-neon
