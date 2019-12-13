check_mssql_health is a plugin, which is used to monitor different parameters of a MS SQL server.


https://labs.consol.de/nagios/check_mssql_health/index.html

##Examples

```
nagsrv$ check_mssql_health --mode mem-pool-data-buffer-hit-ratio
CRITICAL - buffer cache hit ratio is 71.21% | buffer_cache_hit_ratio=71.21%;90:;80:

nagsrv$ check_mssql_health --mode batch-requests
OK - 9.00 batch requests / sec | batch_requests_per_sec=9.00;100;200

nagsrv$ check_mssql_health --mode full-scans
OK - 6.14 full table scans / sec | full_scans_per_sec=6.14;100;500

nagsrv$ check_mssql_health --mode cpu-busy
OK - CPU busy 55.00% | cpu_busy=55.00;80;90

nagsrv$ check_mssql_health --mode database-free --name AdventureWorks
OK - database AdventureWorks has 21.59% free space left | 'db_adventureworks_free_pct'=21.59%;5:;2: 'db_adventureworks_free'=703MB;4768371582.03:;1907348632.81:;0;95367431640.62

nagsrv$ check_mssql_health --mode database-free --name AdventureWorks \
--warning 700: --critical 200: --units MB
WARNING - database AdventureWorks has 694.12MB free space left | 'db_adventureworks_free_pct'=21.31%;0.00:;0.00: 'db_adventureworks_free'=694.12MB;700.00:;200.00:;0;95367431640.62

nagsrv$ check_mssql_health --mode page-life-expectancy
OK - page life expectancy is 8950 seconds | page_life_expectancy=8950;300:;180:

nagsrv$ check_mssql_health --mode database-backup-age --name AHLE_WORSCHT \
--warning 72 --critical 120
WARNING - AHLE_WORSCHT backupped 102h ago | 'AHLE_WORSCHT_bck_age'=102;72;120 'AHLE_WORSCHT_bck_time'=12
```
