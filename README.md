# Transact-SQL

This Repo is contains Transact-SQL and sample SQL snippets related to all its core concepts.

- tsql_data_manipulation_playbook.ipynb 
	- contains practice queries for DML/DDL 

- tsql_combining&filteringdata.ipynb
	- contains practice queries for how do we combine and filter data in TSQL
	- CTE
	- Full outer join behavior

- querying_xml_json.sql
	- contains practice queries for data selection and filtering from JSON & XML
	- Temporal tables explained

- tsql_stored_proc.ipynb
	- contains queries on how Stored procedures work in TSql
	- how SPs reuse the execution plan as compared to adhoc TSQL statements to improve performance
	- parameter sniffing in SPs
	
- tsql_error_handling.sql
	- contains error handling methods in tsql (try/catch, raiserror)
	- how to deal with transactions & setup isolation levels
	- how we can leverage an error log table for the errors
	- calling proc in catch block

Tools Used:
- Azure Data Studio
- Docker Container 


Setup SQL server image on docker container:
https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash

Azure Data Studio Data Connection Setup:
https://docs.microsoft.com/en-us/sql/azure-data-studio/quickstart-sql-server?view=sql-server-ver15

Database backfiles used:
https://drive.google.com/drive/folders/1U6k2TOpyjfLpRV3rknq2t8TX6ifHio8u?usp=sharing

- Run docker container (docker start [server-name])
- Open Azure Data Studio and connect

Note: Please read the comments carefully


Assessment of skills on pluralsight:
https://monosnap.com/file/72svSvlttGXKWbVlteFuO6Ap0to9gr

