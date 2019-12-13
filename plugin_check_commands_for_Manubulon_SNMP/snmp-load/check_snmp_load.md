Checks by snmp v1, v2c or v3 cpu or average load. 
Works on Windows, Linux/Unix, AS400, Cisco, Cisco catalyst, HP Procurve, LinkProof, Blucoat, Nokia, Fortinet, Netscreen.

http://nagios.manubulon.com/snmp_load.html

##Examples

```
./check_snmp_load.pl -h


Check loads on linux with Net-SNMP : checks the 1, 5 and 15 minutes load average.

./check_snmp_load.pl -H 127.0.0.1 -C public -w 3,3,2 -c 4,4,3 -T netsl

Check cpu load (generic) : checks the %used CPU for the last minute

./check_snmp_load.pl -H 127.0.0.1 -C public -w 98% -c 99%

Check cpu load on AS/400

./check_snmp_load.pl -H 127.0.0.1 -C public -w 98% -c 99% -T as400
```
