check_oracle_health is a plugin to check various parameters of an Oracle database.

https://labs.consol.de/nagios/check_oracle_health/index.html

##Examples

```
nagios$ check_oracle_health --connect bba --mode tnsping
OK - connection established to bba.

nagios$ check_oracle_health --mode connection-time
OK - 0.17 seconds to connect  |
  connection_time=0.1740;1;5

nagios$ check_oracle_health --mode sga-data-buffer-hit-ratio
CRITICAL - SGA data buffer hit ratio 0.99%  |
  sga_data_buffer_hit_ratio=0.99%;98:;95:

nagios$ check_oracle_health --mode sga-library-cache-hit-ratio
OK - SGA library cache hit ratio 98.75%  |
  sga_library_cache_hit_ratio=98.75%;98:;95:

nagios$ check_oracle_health --mode sga-latches-hit-ratio
OK - SGA latches hit ratio 100.00%  |
  sga_latches_hit_ratio=100.00%;98:;95:

nagios$ check_oracle_health --mode sga-shared-pool-reloads
OK - SGA shared pool reloads 0.28%  |
  sga_shared_pool_reloads=0.28%;1;10

nagios$ check_oracle_health --mode sga-shared-pool-free
WARNING - SGA shared pool free 8.91%  |
  sga_shared_pool_free=8.91%;10:;5:

nagios$ check_oracle_health --mode pga-in-memory-sort-ratio
OK - PGA in-memory sort ratio 100.00%  |
  pga_in_memory_sort_ratio=100.00;99:;90:

nagios$ check_oracle_health --mode invalid-objects
OK - no invalid objects found  |
  invalid_ind_partitions=0 invalid_indexes=0
  invalid_objects=0 unrecoverable_datafiles=0

nagios$ check_oracle_health --mode switch-interval
OK - Last redo log file switch interval was 18 minutes |
    redo_log_file_switch_interval=1090s;600:;60:

nagios$ check_oracle_health --mode switch-interval --connect rac1
OK - Last redo log file switch interval was 32 minutes (thread 1)|
    redo_log_file_switch_interval=1938s;600:;60:

nagios$ check_oracle_health --mode tablespace-usage
CRITICAL - tbs SYSTEM usage is 99.33%
tbs SYSAUX usage is 93.73%
tbs USERS usage is 8.75%
tbs UNDOTBS1 usage is 6.65% | 'tbs_users_usage_pct'=8%;90;98
'tbs_users_usage'=0MB;4;4;0;5
'tbs_undotbs1_usage_pct'=6%;90;98
'tbs_undotbs1_usage'=11MB;153;166;0;170
'tbs_system_usage_pct'=99%;90;98
'tbs_system_usage'=695MB;630;686;0;700
'tbs_sysaux_usage_pct'=93%;90;98
'tbs_sysaux_usage'=802MB;770;839;0;856

nagios$ check_oracle_health --mode tablespace-usage
    --tablespace USERS
OK - tbs USERS usage is 8.75% |
  'tbs_users_usage_pct'=8%;90;98
  'tbs_users_usage'=0MB;4;4;0;5

nagios$ check_oracle_health --mode tablespace-usage
    --name USERS
OK - tbs USERS usage is 8.75% |
  'tbs_users_usage_pct'=8%;90;98
  'tbs_users_usage'=0MB;4;4;0;5

nagios$ check_oracle_health --mode tablespace-free
    --name TEST
OK - tbs TEST has 97.91% free space left |
    'tbs_test_free_pct'=97.91%;5:;2:
    'tbs_test_free'=32083MB;1638.40:;655.36:;0.00;32767.98

nagios$ check_oracle_health --mode tablespace-free
    --name TEST --units MB --warning 100: --critical 50:
OK - tbs TEST has 32083.61MB free space left |
    'tbs_test_free_pct'=97.91%;0.31:;0.15:
    'tbs_test_free'=32083.61MB;100.00:;50.00:;0;32767.98

nagios$ check_oracle_health --mode tablespace-free
    --name TEST --warning 10: --critical 5:
OK - tbs TEST has 97.91% free space left |
    'tbs_test_free_pct'=97.91%;10:;5:
    'tbs_test_free'=32083MB;3276.80:;1638.40:;0.00;32767.98

nagios$ check_oracle_health --mode tablespace-remaining-time
    --tablespace ARUSERS --lookback 7
WARNING - tablespace ARUSERS will be full in 78 days |
  'tbs_arusers_days_until_full'=78;90:;30:

nagios$ check_oracle_health --mode flash-recovery-area-free
OK - flra /u00/app/oracle/flash_recovery_area has 100.00% free space left |
    'flra_free_pct'=100.00%;5:;2:
    'flra_free'=2048MB;102.40:;40.96:;0;2048.00

nagios$ check_oracle_health --mode flash-recovery-area-free
    --units KB --warning 1000: --critical 500:
OK - flra /u00/app/oracle/flash_recovery_area has 2097152.00KB free space left |     'flra_free_pct'=100.00%;0.05:;0.02:
    'flra_free'=2097152.00KB;1000.00:;500.00:;0;2097152.00

nagios$ check_oracle_health --mode datafile-io-traffic
  --datafile users01.dbf
WARNING - users01.dbf: 1049.83 IO Operations per Second |
  'dbf_users01.dbf_io_total_per_sec'=1049.83;1000;5000

nagios$ check_oracle_health --mode latch-contention
  --name 214
OK - SGA latch library cache (214) contention 0.08% |
 'latch_214_contention'=0.08%;1;2
 'latch_214_sleep_share'=0.00% 'latch_214_gets'=49995

nagios$ check_oracle_health --mode latch-contention
  --name 'library cache'
OK - SGA latch library cache (214) contention 0.08% |
 'latch_214_contention'=0.08%;1;2
 'latch_214_sleep_share'=0.00% 'latch_214_gets'=49937

nagios$ check_oracle_health --mode enqueue-contention --name TC
CRITICAL - enqueue TC: 19.90% of the requests must wait |
 'TC_contention'=19.90%;1;10
 'TC_requests'=2015 'TC_waits'=401

nagios$ check_oracle_health --mode latch-contention
  --name 'messages'
OK - SGA latch messages (17) contention 0.02% |
 'latch_17_contention'=0.02%;1;2 'latch_17_gets'=4867

nagios$ check_oracle_health --mode latch-waiting
  --name 'user lock'
OK - SGA latch user lock (205) sleeping 0.000841% of the time |
 'latch_205_sleep_share'=0.000841%

nagios$ check_oracle_health --mode event-waits
  --name 'log file sync'
OK - log file sync : 1.839511 waits/sec |
 'log file sync_waits_per_sec'=1.839511;10;100

nagios$ check_oracle_health --mode event-waiting
  --name 'Log file parallel write'
OK - log file parallel write waits 0.045843% of the time |
rarr 'log file parallel write_percent_waited'=0.045843%;0.1;0.5

nagios$ check_oracle_health --mode sysstat
  --name 'transaction rollbacks'
OK - 0.000003 transaction rollbacks/sec |
 'transaction rollbacks_per_sec'=0.000003;10;100
 'transaction rollbacks'=4

nagios$ check_oracle_health --mode sql
  --name 'select count(*) from v$session' --name2 sessions
CRITICAL - sessions: 21 | 'sessions'=21;1;5

nagios$ check_oracle_health --mode sql
  --name 'select 12 from dual' --name2 twelve --units MB
CRITICAL - twelfe: 12MB | 'twelfe'=12MB;1;5

nagios$ check_oracle_health --mode sql
  --name 'select 200,300,1000 from dual'
  --name2 'kaspar melchior balthasar'
  --warning 180 --critical 500
WARNING - kaspar melchior balthasar: 200 300 1000 |
'kaspar'=200;180;500 'melchior'=300;; 'balthasar'=1000;;

nagios$ check_oracle_health --mode sql
  --name "select 'abc123' from dual" --name2 \\d
  --regexp
OK - output abc123 matches pattern \d
```
