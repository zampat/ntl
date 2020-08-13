https://github.com/miso231/icinga2-cloudera-plugin/blob/master/readme.md

```
check_cloudera_hdfs_space.py [-h] -H HOST [-P PORT] -d DISK -w WARN -c CRIT

Check status of cloudera

arguments:
  -h, --help show this help message and exit
  -H HOST, --host HOST
  -P PORT, --port PORT
  -d DISK, --disk DISK
  -w WARN, --warn WARN
  -c CRIT, --crit CRIT
```

## Examples

```
./check_cloudera_hdfs_space.py -H hadoop-namenode.example.com -w 40 -c 50 -d DISK
DISK: Used 3.77 PB of 6.95 PB (54.23%)|USED=3861TB;2848;3559;0;7119
```
