check_db2_health is a plugin, which is used to monitor various parameters of a DB2 database.


https://labs.consol.de/nagios/check_db2_health/index.html

##Examples

```
nagsrv$ check_db2_health --mode connection-time
WARNING - 1.61 seconds to connect as DB2INST1 |  connection_time=1.6084;1;5

nagsrv$ check_db2_health --mode connected-users
OK - 3 connected users |  connected_users=3;50;100

nagsrv$ check_db2_health --mode list-databases
TOOLSDB
OK - have fun

nagsrv$ check_db2_health --mode database-usage
OK - database usage is 31.29% |  'db_toolsdb_usage'=31.29%;80;90

nagsrv$ check_db2_health --mode tablespace-usage
CRITICAL - tbs TEMPSPACE1 usage is 100.00%, tbs TBSP32KTMP0000 usage is 100.00%, tbs TBSP32K0000 usage is 100.00%, tbs USERSPACE1 usage is 5.08%, tbs SYSTOOLSPACE usage is 1.86%, tbs SYSCATSPACE usage is 80.37% |  'tbs_userspace1_usage_pct'=5.08%;90;98 'tbs_userspace1_usage'=16MB;288;313;0;320 'tbs_tempspace1_usage_pct'=100.00%;90;98 'tbs_tempspace1_usage'=0MB;0;0;0;0 'tbs_tbsp32ktmp0000_usage_pct'=100.00%;90;98 'tbs_tbsp32ktmp0000_usage'=0MB;0;0;0;0 'tbs_tbsp32k0000_usage_pct'=100.00%;90;98 'tbs_tbsp32k0000_usage'=61MB;55;60;0;61 'tbs_systoolspace_usage_pct'=1.86%;90;98 'tbs_systoolspace_usage'=0MB;28;31;0;32 'tbs_syscatspace_usage_pct'=80.37%;90;98 'tbs_syscatspace_usage'=51MB;57;62;0;64

nagsrv$ check_db2_health --mode list-tablespaces
SYSCATSPACE
SYSTOOLSPACE
TBSP32K0000
TBSP32KTMP0000
TEMPSPACE1
USERSPACE1
OK - have fun

nagsrv$ check_db2_health --mode tablespace-usage --name SYSCATSPACE
OK - tbs SYSCATSPACE usage is 80.37% |  'tbs_syscatspace_usage_pct'=80.37%;90;98 'tbs_syscatspace_usage'=51MB;57;62;0;64

nagsrv$ check_db2_health --mode tablespace-free --name SYSCATSPACE
OK - tbs SYSCATSPACE has 19.63% free space left |  'tbs_syscatspace_free_pct'=19.63%;5:;2: 'tbs_syscatspace_free'=12MB;3.20:;1.28:;0;64.00

nagsrv$ check_db2_health --mode tablespace-free --name SYSCATSPACE --units MB
OK - tbs SYSCATSPACE has 12.55MB free space left |  'tbs_syscatspace_free_pct'=19.63%;7.81:;3.12: 'tbs_syscatspace_free'=12.55MB;5.00:;2.00:;0;64.00

nagsrv$ check_db2_health --mode tablespace-free --name SYSCATSPACE --units MB --warning 15: --critical 10:
WARNING - tbs SYSCATSPACE has 12.55MB free space left |  'tbs_syscatspace_free_pct'=19.63%;23.44:;15.62: 'tbs_syscatspace_free'=12.55MB;15.00:;10.00:;0;64.00

nagsrv$ check_db2_health --mode bufferpool-hitratio
CRITICAL - bufferpool IBMDEFAULTBP hitratio is 53.60%, bufferpool BP32K0000 hitratio is 100.00% |  'bp_ibmdefaultbp_hitratio'=53.60%;98:;90: 'bp_ibmdefaultbp_hitratio_now'=100.00% 'bp_bp32k0000_hitratio'=100.00%;98:;90: 'bp_bp32k0000_hitratio_now'=100.00%

nagsrv$ check_db2_health --mode list-bufferpools
BP32K0000
IBMDEFAULTBP
OK - have fun

nagsrv$ check_db2_health --mode bufferpool-hitratio --name IBMDEFAULTBP
CRITICAL - bufferpool IBMDEFAULTBP hitratio is 53.60% |  'bp_ibmdefaultbp_hitratio'=53.60%;98:;90: 'bp_ibmdefaultbp_hitratio_now'=100.00%

nagsrv$ check_db2_health --mode bufferpool-data-hitratio --name IBMDEFAULTBP
CRITICAL - bufferpool IBMDEFAULTBP data page hitratio is 64.35% |  'bp_ibmdefaultbp_hitratio'=64.35%;98:;90: 'bp_ibmdefaultbp_hitratio_now'=100.00%

nagsrv$ check_db2_health --mode bufferpool-index-hitratio --name IBMDEFAULTBP
CRITICAL - bufferpool IBMDEFAULTBP index hitratio is 38.89% |  'bp_ibmdefaultbp_hitratio'=38.89%;98:;90: 'bp_ibmdefaultbp_hitratio_now'=100.00%

nagsrv$ check_db2_health --mode index-usage
CRITICAL - index usage is 0.71% |  index_usage=0.71%;98:;90:

nagsrv$ check_db2_health --mode synchronous-read-percentage
OK - synchronous read percentage is 100.00% |  srp=100.00%;90:;80:

nagsrv$ check_db2_health --mode asynchronous-write-percentage
CRITICAL - asynchronous write percentage is 0.00% |  awp=0.00%;90:;80:
nagsrv$ check_db2_health --mode deadlocks
OK - 0.000000 deadlocs / sec |  deadlocks_per_sec=0.000000;0;1

nagsrv$ check_db2_health --mode lock-waits
OK - 0.000000 lock waits / sec |  lock_waits_per_sec=0.000000;10;100

nagsrv$ check_db2_health --mode lock-waiting
OK - 0.000000% of the time was spent waiting for locks |  lock_percent_waiting=0.000000%;2;5
```

