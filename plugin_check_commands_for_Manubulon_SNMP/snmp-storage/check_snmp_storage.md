This scripts checks by snmp (V1 and v3) disks, memory, swap, everthing in hrStorage table. 
Storages selection can be done : 
- by perl regexp on description or index (-m)
- and (optional) by storage type (-q) : Other, Ram, VirtualMemory, FixedDisk, RemovableDisk, FloppyDisk, CompactDisk, RamDisk, FlashMemory, NetworkDisk

One or multiple storages can be selected.
It is also possible to sum all selected storages (-s)

Warning and critical levels can be checked based on : 
- Percent of disk used
- Percent of disk left
- MB left
- MB used

http://nagios.manubulon.com/snmp_storage.html


##Examples

```
./check_snmp_storage.pl -h

List all storage	./check_snmp_storage.pl -H 127.0.0.1 -C public -m zzzz -w 80 -c 81 -v
snmpv3 login	./check_snmp_storage.pl -H 127.0.0.1 -l login -x passwd
Unix/Linux

%used of /home is less than 80% and 90%

./check_snmp_storage.pl -H 127.0.0.1 -C public -m /home -w 80% -c 90%

%free of /home is above 10% and 5%

./check_snmp_storage.pl -H 127.0.0.1 -C public -m /home -w 10% -c 5% -T pl

Mb used of /home is less than 800 Mb and 900 Mb

./check_snmp_storage.pl -H 127.0.0.1 -C public -m /home -w 800 -c 900 -T bu

Mb free of /home is above 100Mb and 30Mb

./check_snmp_storage.pl -H 127.0.0.1 -C public -m /home -w 100 -c 30 -T bl

All mountpoints have %used less than 80% and 90%

./check_snmp_storage.pl -H 127.0.0.1 -C public -m / -w 80% -c 90%

%used of / mountpoint only is less than 80% and 90%	
./check_snmp_storage.pl -H 127.0.0.1 -C public -m / -r -w 80% -c 90%

%used of mountpoint index 1 only is less than 80% and 90%	
./check_snmp_storage.pl -H 127.0.0.1 -C public -m 1 -p -w 80% -c 90%

Swap %used is less than 80% and 90%	
./check_snmp_storage.pl -H 127.0.0.1 -C public -m Swap -w 80% -c 90%

Memory %used is less than 80% and 90%	
./check_snmp_storage.pl -H 127.0.0.1 -C public -m "Real Memory" -w 80% -c 90%

 	
Windows

%used of C is less than 80% and 90%	
./check_snmp_storage.pl -H 127.0.0.1 -C public -m ^C: -w 80% -c 90%

%used of C, D and E is less than 80% and 90%	
./check_snmp_storage.pl -H 127.0.0.1 -C public -m ^[CDE]: -w 80% -c 90%

%used of C+D+E is less than 80% and 90%	
./check_snmp_storage.pl -H 127.0.0.1 -C public -m ^[CDE]: -s -w 80% -c 90%

 	
AS/400 specific

Sum of all memory storages is less than 90% and 95%	
./check_snmp_storage.pl -H 127.0.0.1 -C public -m RAM -s -w 80% -c 90%%
```
