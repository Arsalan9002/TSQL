--Temporal Tables

CREATE TABLE PostsTemporal (
	Id INT NOT NULL PRIMARY KEY CLUSTERED,
	CreationDate DATETIME NOT NULL DEFAULT GETDATE(),
	Score INT NOT NULL DEFAULT 0,
	ViewCount INT,
	Body VARCHAR(MAX) NOT NULL,
	OwnerUserId INT,
	LastActivityDate DATETIME NOT NULL DEFAULT GETDATE(),
	Title VARCHAR(500),
	Tags VARCHAR(255),
	AnswerCount INT,
	CommentCount INT,
	FavoriteCount INT,

    --PERIOD COLUMNS
    SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL,

    --specifying the period columns
    PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime)
)

-- Defined the table which is going to store the history
WITH (SYSTEM_VERSIONING  = ON (HISTORY_TABLE = dbo.PostHistory))