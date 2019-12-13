Bug and feature update to check_iftraffic3. This is a 64 (and 32) bit Nagvis compatible SNMP iftraffic check. Renamed to highlight the change from 32 to 64 bit as the default counters used. Tested with Windows 2003/08/12, Linux (RedHat), and Cisco devices.

https://exchange.nagios.org/directory/Plugins/Network-Connections%2C-Stats-and-Bandwidth/check_iftraffic64/details

##Examples

```
# Simple 64 bit check of interface used as the primary host interface (based on IP address of host1)
check_iftraffic64.pl -H host1 -C sneaky

# 32 bit mode check of interface index 5 in bits/s with 100m bandwidth limit
check_iftraffic64.pl -H host1 -C sneaky -i 5 -B -b 100 -u m --32bit

# Check of interface using address 192.168.1.1 in bits/s running 50m down (in) and 10m up (out)
check_iftraffic64.pl -H host1 -C sneaky -A 192.168.1.1 -B -I 50 -O 10 -u m
```
