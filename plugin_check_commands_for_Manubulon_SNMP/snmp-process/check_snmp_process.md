Checks by snmp v1 or v3 if a process is running and how many instances are running (minimum & maximum). 
It is also possible to check memory and cpu used by one or a group of process

http://nagios.manubulon.com/snmp_process.html

##Examples

```
./check_snmp_process.pl -h

snmpv3 login	./check_snmp_process.pl -H 127.0.0.1 -l login -x passwd
Check if at least one process matching http is running

./check_snmp_process.pl -H 127.0.0.1 -C public -n http

Result example :

3 process matching http : > 0 : OK

Check if at least 3 process matching http are running

./check_snmp_process.pl -H 127.0.0.1 -C public -n http -w 2 -c 0

Result example : 
(<=2 will return warning, 0 critical)
3 process matching httpd : > 2 : OK
Check if at least one process named "httpd" exists (no regexp)	./check_snmp_process.pl -H 127.0.0.1 -C public -n http -r
Result example :

3 process named httpd : > 0 : OK
Check process by their full path : check process of /opt/soft/bin/ (at least one)	./check_snmp_process.pl -H 127.0.0.1 -C public -n /opt/soft/bin/ -f
Check that at least 3 process but not more than 8 are running	./check_snmp_process.pl -H 127.0.0.1 -C public -n http -w 3,8 -c 0,15
Same checks + checks maximum memory used by process (in Mb) : warning and critical levels	./check_snmp_process.pl -H 127.0.0.1 -C public -n http -w 3,8 -c 0,15 -m 9,25
Same check but sum all CPU used by all selected process	./check_snmp_process.pl -H 127.0.0.1 -C public -n http -w 3,8 -c 0,15 -m 9,25 -u 70,99
```
