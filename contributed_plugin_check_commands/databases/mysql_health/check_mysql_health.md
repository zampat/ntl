check_mysql_health is a plugin to check various parameters of a MySQL database.


https://labs.consol.de/nagios/check_mysql_health/index.html

##Examples
```
nagios$ check_mysql_healthhostname mydb3 --username nagios --password nagios -- mode connection-time
OK - 0.03 seconds to connect as nagios | connection_time=0.0337s;1;5

nagios$ check_oracle_healthmode=connection-time
OK - 0.17 seconds to connect  | connection_time=0.1740;1;5

nagios$ check_mysql_healthmode querycache-hitrate
CRITICAL - query cache hitrate 70.97% | qcache_hitrate=70.97%;90:;80: qcache_hitrate_now=72.25% selects_per_sec=270.00

nagios$ check_mysql_healthmode querycache-hitrate --warning 80: --critical 70:
WARNING - query cache hitrate 70.82% | qcache_hitrate=70.82%;80:;70: qcache_hitrate_now=62.82% selects_per_sec=420.17

nagios$ check_mysql_healthmode sql --name 'select 111 from dual'
CRITICAL - select 111 from dual: 111 | 'select 111 from dual'=111;1;5

nagios$ echo 'select 111 from dual' | check_mysql_healthmode encode
select%20111%20from%20dual

nagios$ check_mysql_healthmode sql --name select%20111%20from%20dual
CRITICAL - select 111 from dual: 111 | 'select 111 from dual'=111;1;5

nagios$ check_mysql_healthmode sql --name select%20111%20from%20dual --name2 myval
CRITICAL - myval: 111 | 'myval'=111;1;5

nagios$ check_mysql_healthmode sql --name select%20111%20from%20dual --name2 myval --units GB
CRITICAL - myval: 111GB | 'myval'=111GB;1;5

nagios$ check_mysql_healthmode sql --name select%20111%20from%20dual --name2 myval --units GB
   warning 100 --critical 110
CRITICAL - myval: 111GB | 'myval'=111GB;100;110
```
