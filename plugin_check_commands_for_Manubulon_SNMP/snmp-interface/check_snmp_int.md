Checks by snmp (v1, v2c or v3) host interface state and usage. 

Interfaces can be selected by regexp ( 'eth' will check eth0, eth1, eth2, ...).
If multiple interfaces are selected, all must be up to get an OK result

http://nagios.manubulon.com/snmp_int.html


##Examples

```
./check_snmp_int.pl -h

List all interfaces	./check_snmp_int.pl -H 127.0.0.1 -C public -n zzzz -v
snmpv3 login	./check_snmp_int.pl -H 127.0.0.1 -l login -w passwd
Check eth0 interface is up

./check_snmp_int.pl -H 127.0.0.1 -C public -n eth0 -r

Check that all eth interface are up

./check_snmp_int.pl -H 127.0.0.1 -C public -n eth

Check that all ppp interface are down

./check_snmp_int.pl -H 127.0.0.1 -C public -n ppp -i

Check that all eth interface are administratively up

./check_snmp_int.pl -H 127.0.0.1 -C public -n eth -a

Check that FastEternet0/11 to 0/14 are up (Cisco)

./check_snmp_int.pl -H 127.0.0.1 -C public -n "Fast.*0.1[1234]"

Check the eth0 usage 
Note : no critical inbound (0)	./check_snmp_int.pl -H 127.0.0.1 -C public -n eth0 -k -w 200,400 -c 0,600
```
