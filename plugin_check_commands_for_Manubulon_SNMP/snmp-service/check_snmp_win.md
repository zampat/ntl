Checks by snmp v1 or v3 windows specific health monitoring (service state for now).


http://nagios.manubulon.com/snmp_windows.html

##Examples

```
./check_snmp_win.pl -h

snmpv3 login	./check_snmp_win.pl -H 127.0.0.1 -l login -x passwd
Check if at least one process matching dns is running

./check_snmp_win.pl -H 127.0.0.1 -C public -n dns

Result example :

1 services active (matching "dns") : OK

Check if at least 3 process matching dns are running

./check_snmp_win.pl -H 127.0.0.1 -C public -n http -N 2

Result example : 
(<=2 will return warning, 0 critical)
1 services active (matching "dns") : CRITICAL
Check if dns and ssh services are running	./check_snmp_win.pl -H 127.0.0.1 -C public -n dns,ssh
Result example :

"dns" active, "ssh" active : OK
Check if dns and toto services are running	./check_snmp_win.pl -H 127.0.0.1 -C public -n dns,toto
Result example :
"toto" not active : CRITICAL
```
