The check_elasticsearch plugin uses the HTTP API to monitor an Elasticsearch node.


https://github.com/anchor/nagios-plugin-elasticsearch

##Examples

```
check_elasticsearch [options]

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -v, --verbose
  -f FAILURE_DOMAIN, --failure-domain=FAILURE_DOMAIN
                        A comma-separated list of ElasticSearch attributes
                        that make up your cluster's failure domain[0].  This
                        should be the same list of attributes that
                        ElasticSearch's location-aware shard allocator has
                        been configured with.  If this option is supplied,
                        additional checks are carried out to ensure that
                        primary and replica shards are not stored in the same
                        failure domain.
			[0]: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-cluster.html
  -H HOST, --host=HOST  Hostname or network address to probe.  The
                        ElasticSearch API should be listening here.  Defaults
                        to 'localhost'.
  -m MASTER_NODES, --master-nodes=MASTER_NODES
                        Issue a warning if the number of master-eligible nodes
                        in the cluster drops below this number.  By default,
                        do not monitor the number of nodes in the cluster.
  -p PORT, --port=PORT  TCP port to probe.  The ElasticSearch API should be
                        listening here.  Defaults to 9200.
  -y YELLOW_CRITICAL, --yellow-critical=TRUE
                        Instead of issuing a 'warning' for a yellow cluster
                        state, issue a 'critical' alert. Allows for greater
                        control of alerting for clusters that may be of 
                        greater sensitivity (or fragility). Defaults to False.
```
