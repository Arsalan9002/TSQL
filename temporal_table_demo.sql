
IF OBJECT_ID('dbo.PostsTemporal','U') IS NOT NULL
BEGIN
    -- When deleting a temporal table, we first need to turn off the versioning
    ALTER TABLE [dbo].[PostsTemporal] SET (SYSTEM_VERSIONING = OFF)
    DROP TABLE [dbo].[PostsTemporal]
    DROP TABLE [dbo].[PostHistory]
END

--Temporal Tables

CREATE TABLE PostsTemporal (
	Id INT NOT NULL PRIMARY KEY CLUSTERED,
	CreationDate DATETIME NOT NULL DEFAULT GETDATE(),
	Score INT NOT NULL DEFAULT 0,
	ViewCount INT,
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

Select * from PostsTemporal
SELECT * from PostHistory

--Inserting data into temporal table
INSERT INTO PostsTemporal(
    Id, CreationDate, ViewCount, OwnerUserId,
    LastActivityDate,title,tags, AnswerCount,
    CommentCount,FavoriteCount)
Values (116,'2014-05-17T09:16:18.823',2766,173,'2016-04-28T06:18:44.780',
       'techniques for estimating users age'
       ,'<machine-learning><dimensionality-reduction><python>',6,3,10 )

Select * from PostsTemporal where Id=116
SELECT * from PostHistory where Id=116

--Updating data in temporal table
UPDATE PostsTemporal 
	SET Title = 'Forecasting weather'
	WHERE Id = 116;

Select * from PostsTemporal
SELECT * from PostHistory

-- Deleting record from temporal table
Delete from PostsTemporal where Id=116


--Querying Data from temporal
Select * from PostsTemporal 
SELECT * from PostHistory

--Construct state of temporal table at time = 2020–06–22 19:24:07.9109773
SELECT * FROM PostsTemporal FOR SYSTEM_TIME 
    AS OF '2020-06-22 19:24:07.9109773'
    Where Id=116

-- return those that overlap with a specified period
SELECT * FROM PostsTemporal FOR SYSTEM_TIME 
    BETWEEN '2020-06-22 19:14:13.6725928' AND 
            '2020-06-22 19:29:03.2112783'
    Where Id=116
    
-- returns only those that existed within specified period boundaries
SELECT * FROM PostsTemporal FOR SYSTEM_TIME 
    CONTAINED IN ('2020-06-22 19:14:13.6725928',
                  '2020-06-22 19:29:03.2112783')

-- Get all changes performed in order 
SELECT * FROM PostsTemporal FOR SYSTEM_TIME ALL 
    WHERE id=116 ORDER BY SysEndTime
