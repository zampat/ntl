The check_interfaces plugin uses SNMP to monitor network interfaces and their utilization.

https://github.com/NETWAYS/check_interfaces/blob/master/README.md

##Usage

```
check_interface -c public -h 192.168.0.1 -r 'FastEth' -p '$SERVICEPERFDATA$' -t $LASTSERVICECHECK$ -a

Options;
 -h                 address of device

 -c|--community     community (default public)
 -r|--regex         interface list regexp
                        Regex to match interfaces (important, this is a Regular Expression
                        not a simple wildcard string, see below)
 -e|--errors        number of in errors (CRC errors for cisco) to consider a warning (default 50)
                        Only warn if errors increase by more than this amount between checks
 -f|--out-errors    number of out errors (collisions for cisco) to consider a warning
                        Defaults to the same value as for errors
 -p|--perfdata      last check perfdata
                        Performance data from previous check (used to calculate traffic)
 -P|--prefix        prefix interface names with this label
 -t|--lastcheck     last checktime (unixtime)
                        Last service check time in unixtime (also used to calculate traffic)
 -b|--bandwidth     bandwidth warn level in %
 -s|--speed         override speed detection with this value (bits per sec)
 -x|--trim          cut this number of characters from the start of interface descriptions
                        Useful for nortel switches
 -j|--auth-proto    SNMPv3 Auth Protocol (SHA|MD5)
 -J|--auth-phrase   SNMPv3 Auth Phrase
 -k|--priv-proto    SNMPv3 Privacy Protocol (AES|DES) (optional)
 -K|--priv-phrase   SNMPv3 Privacy Phrase
 -u|--user          SNMPv3 User
 -d|--down-is-ok    disables critical alerts for down interfaces
                        i.e do not consider a down interface to be critical
 -a|--aliases       retrieves the interface description
                        This alias does not always deliver useful information
 -A|--match-aliases also test the Alias against the Regexes
 -D|--debug-print   list administrative down interfaces in perfdata
 -N|--if-names      use ifName instead of ifDescr
    --timeout       sets the SNMP timeout (in ms)
 -m|--mode          special operating mode (default,cisco,nonbulk,bintec)
                        Workarounds for various hardware
```

##Examples

```
check_interface -c public -h 192.168.0.1 -r 'Eth(0|2)$'
```
