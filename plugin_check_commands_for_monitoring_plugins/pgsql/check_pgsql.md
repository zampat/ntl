The check_pgsql plugin tests a PostgreSQL DBMS to determine whether it is active and accepting queries. If a query is specified using the pgsql_query attribute, it will be executed after connecting to the server. The result from the query has to be numeric in order to compare it against the query thresholds if set.

   
https://www.monitoring-plugins.org/doc/man/check_pgsql.html