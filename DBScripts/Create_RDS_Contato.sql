CREATE TABLE RDS_CONTATO (
	CONTATOID INT NOT NULL CONSTRAINT PK_RDS_CONTATO PRIMARY KEY,
	IDRDSTATION VARCHAR(50) NOT NULL,
	CREATEDAT DATETIME NOT NULL,
	UPDATEDAT DATETIME NOT NULL,
	UPDATEDTIMES INT NOT NULL,
	RECOVERED BIT NOT NULL);