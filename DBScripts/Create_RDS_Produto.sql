CREATE TABLE RDS_PRODUTO (
	PRODUTOID INT NOT NULL CONSTRAINT PK_RDS_PRODUTO PRIMARY KEY,
	IDRDSTATION VARCHAR(50) NOT NULL,
	CREATEDAT DATETIME NOT NULL,
	UPDATEDAT DATETIME NOT NULL,
	UPDATEDTIMES INT NOT NULL);