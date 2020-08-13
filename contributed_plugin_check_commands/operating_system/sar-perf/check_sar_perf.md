https://github.com/dnsmichi/check-sar-perf

## Usage
```
# ./check_sar_perf.py <profile1> [<profile2> <profile3> ...]
```

##Example
```
check_sar_perf.py cpu
sar OK| CPU=all user=59.90 nice=0.00 system=4.46 iowait=0.00 steal=0.00 idle=35.64

check_sar_perf.py disk sda
sar OK| DEV=sda tps=0.00 rd_sec/s=0.00 wr_sec/s=0.00 avgrq-sz=0.00 avgqu-sz=0.00 await=0.00 svctm=0.00 util=0.00

check_sar_perf.py foo
ERROR: option not defined
```
