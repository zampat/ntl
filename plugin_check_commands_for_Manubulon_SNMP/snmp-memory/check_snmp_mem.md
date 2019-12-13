Checks by snmp v1, v2c or v3 :

- Memory and swap usage on Linux given by Net-snmp. 
It checks memory and swap usage independantly : one warning and critical level for each of them.
- Memory usage on cisco routers or Pix : the plugin will add all of the memory pool and then checks the warning and critical levels.
On cisco routeurs, it will add 'IO' and 'Processor' memory
On Pix, it will check the memory used (one memory pool only on Pix).
- Memory usage on HP Procurve switch.
Memory segments will be added then the free memory will be checked.

http://nagios.manubulon.com/snmp_mem.html

##Examples

```
./check_snmp_mem.pl -h

Verbose output	./check_snmp_mem.pl -H <IP> -C <com> -w 80 -c 81 -v
snmpv3 login	./check_snmp_mem.pl -H 127.0.0.1 -l login -x passwd
 

Unix/Linux

%used of 
- RAM < 99% and 100%
- Swap : < 20% and 30%

./check_snmp_mem.pl -H <IP> -C <com> -w 99,20 -c 100,30

Same with no warning levels for memory

./check_snmp_mem.pl -H <IP> -C <com> -w 0,20 -c 100,30

Check memory on Cisco

./check_snmp_mem.pl -H <IP> -C <com> -I -w 90% -c 98%
```
