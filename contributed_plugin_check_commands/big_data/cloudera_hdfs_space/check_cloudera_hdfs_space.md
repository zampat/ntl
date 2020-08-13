https://github.com/miso231/icinga2-cloudera-plugin/blob/master/readme.md

```
check_cloudera_hdfs_files.py [-h] -H HOST [-P PORT] -w WARN -c CRIT [-m MAX_FILES]

arguments:
  -h, --help show this help message and exit
  -H HOST, --host HOST
  -P PORT, --port PORT
  -w WARN, --warn WARN
  -c CRIT, --crit CRIT
  -m MAX_FILES, --max MAX_FILES
```

## Examples

```
./check_cloudera_hdfs_files.py -H hadoop-namenode.example.com -w 80000000 -c 100000000 -m 200000000
Total count of files on HDFS is 64,773,022|FilesTotal=64773022;80000000;100000000;0;200000000
```
