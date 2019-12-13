The Adaptec RAID Monitoring Plugin is a Nagios/Icinga to check the Adaptec RAID Controller for warnings or critical errors.
It is written in Perl and uses the arcconf command line tool to interact with the RAID Controller.

https://github.com/thomas-krenn/check_adaptec_raid/blob/master/README.md

##Examples
```
./check_adaptec_raid -Tw 40 -Tc 50 -LD 0,1 -PD 1 -z 0
``
