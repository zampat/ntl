A monitoring plugin for Icinga (2), Nagios, Shinken, Naemon, etc. to check the Logstash API (Logstash v.5+)

While the plugin works with the first release of Logstash 5.0, there is still some work to be done and some tests to be made.
A word of warning Be sure to read the configuration check part of this readme since there is a problem with this feature.


https://github.com/widhalmt/check_logstash/blob/master/README.md

##Usage
```
-H HOST                          Logstash host
-p, --hostname PORT              Logstash API port
    --file-descriptor-threshold-warn WARN
                                 The percentage relative to the process file descriptor limit on which to be a warning result.
    --file-descriptor-threshold-crit CRIT
                                 The percentage relative to the process file descriptor limit on which to be a critical result.
    --heap-usage-threshold-warn WARN
                                 The percentage relative to the heap size limit on which to be a warning result.
    --heap-usage-threshold-crit CRIT
                                 The percentage relative to the heap size limit on which to be a critical result.
    --cpu-usage-threshold-warn WARN
                                 The percentage of CPU usage on which to be a warning result.
    --cpu-usage-threshold-crit CRIT
                                 The percentage of CPU usage on which to be a critical result.
    --inflight-events-warn WARN  Threshold for inflight events to be a warning result. Use min:max for a range.
    --inflight-events-crit CRIT  Threshold for inflight events to be a critical result. Use min:max for a range.
-h, --help                       Show this message
```
##Examples 

```
./check_logstash.rb -H 127.0.0.1 --file-descriptor-threshold-warn 40 --file-descriptor-threshold-crit 50 --heap-usage-threshold-warn 10 --heap-usage-threshold-crit 20
```
