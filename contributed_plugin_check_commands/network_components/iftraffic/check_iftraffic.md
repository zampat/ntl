Checks the utilization of a given interface name with SNMP.

https://github.com/NETWAYS/check_iftraffic/blob/master/README.md

##Examples

```
$ ./check_iftraffic.pl -H localhost -C public -i en0 -b 100 -u m
Total RX Bytes: 859.84 MB, Total TX Bytes: 1566.80 MB<br>Average Traffic: 0.00 kB/s (0.0%) in, 0.00 kB/s (0.0%) out| inUsage=0.0,85,98 outUsage=0.0,85,98 inAbsolut=880477 outAbsolut=1604405
```
