https://github.com/miso231/icinga2-cloudera-plugin/blob/master/readme.md

```
check_cloudera_service_status.py [-h] -H HOST [-P API_PORT] -u API_USER -p API_PASS -v API_V -c CLUSTER -s SERVICE [-k VERIFY_SSL]

arguments:
  -h, --help show this help message and exit
  -H HOST, --host HOST
  -P API_PORT, --port API_PORT
  -u API_USER, --user API_USER
  -p API_PASS, --pass API_PASS
  -v API_V, --api_version API_V
  -c CLUSTER, --cluster CLUSTER
  -s SERVICE, --service SERVICE
  -k VERIFY_SSL, --verify_ssl VERIFY_SSL
```

## Examples

```
# Check YARN
./check_cloudera_service_status -H cloudera.test.example -u super_user -p super_password -v v18 -s yarn -c My_cluster
OK - yarn is in healthy state

# Check HDFS
./check_cloudera_service_status -H cloudera.test.example -u super_user -p super_password -v v18 -s hdfs -c My_cluster
Critical - there are several problems with service hdfs
hdfs_ha_namenode_health: bad
```
