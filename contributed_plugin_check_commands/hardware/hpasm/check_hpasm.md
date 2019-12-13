check_hpasm is a plugin for Nagios which checks the hardware health of Hewlett-Packard Proliant Servers. To accomplish this, you must have installed the hpasm package. 
The plugin checks the health of

Processors
Power supplies
Memory modules
Fans
CPU- and board-temperatures
Raids (ide and sas only when using SNMP)
and alerts you if one of these components is faulty or operates outside its normal parameters.


https://labs.consol.de/nagios/check_hpasm/index.html

##Examples
```
nagios$ check_hpasm
CRITICAL - dimm module 2 @ cartridge 2 needs attention (dimm is degraded)

nagios$ check_hpasm -v
checking hpasmd process
System        :proliant dl580 g3
Serial No.    :GB8632FB7V
ROM version   :P38 04/28/2006
checking cpus
 cpu 0 is ok
 cpu 1 is ok
 cpu 2 is ok
 cpu 3 is ok
checking power supplies
 powersupply 1 is ok
 powersupply 2 is ok
checking fans
checking temperatures
 1 cpu#1 temparature is 36 (80 max)
 2 cpu#2 temparature is 34 (80 max)
 3 cpu#3 temparature is 33 (80 max)
 4 cpu#4 temparature is 37 (80 max)
 5 i/o_zone temparature is 32 (60 max)
 6 ambient temparature is 23 (40 max)
 7 system_bd temparature is 34 (60 max)
checking memory modules
 dimm 1@1 is ok
 dimm 2@1 is ok
 dimm 3@1 is ok
 dimm 4@1 is ok
 dimm 1@2 is ok
 dimm 2@2 is dimm is degraded
 dimm 3@2 is ok
 dimm 4@2 is ok
CRITICAL - dimm module 2 @ cartridge 2 needs attention (dimm is degraded)
```
