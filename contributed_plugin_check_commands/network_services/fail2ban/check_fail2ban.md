The check_fail2ban plugin uses the fail2ban-client binary to monitor fail2ban jails.

https://icinga.com/docs/icinga2/latest/doc/10-icinga-template-library/#lsyncd

https://github.com/fail2ban/fail2ban/blob/master/files/nagios/README

## Help
```
Usage: /<path-to>/check_fail2ban [-p] [-D "CHECK FAIL2BAN ACTIVITY"] [-v] [-c 2] [-w 1] [-s /<path-to>/socket] [-P /usr/bin/fail2ban-client]

Options:
 -h, --help
    Print detailed help screen
 -V, --version
    Print version information
 -D, --display=STRING
    To modify the output display
    default is "CHECK FAIL2BAN ACTIVITY"
 -P, --path-fail2ban_client=STRING
    Specify the path to the tw_cli binary
    default value is /usr/bin/fail2ban-client
 -c, --critical=INT
    Specify a critical threshold
    default is 2
 -w, --warning=INT
    Specify a warning threshold
    default is 1
 -s, --socket=STRING
    Specify a socket path
    default is unset
 -p, --perfdata
    If you want to activate the perfdata output
 -v, --verbose
    Show details for command-line debugging (Nagios may truncate the output)
```

## Example
```
# for a specific jail
$ ./check_fail2ban --verbose -p -j ssh -w 1 -c 5 -P /usr/bin/fail2ban-client
DEBUG : fail2ban_client_path: /usr/bin/fail2ban-client
DEBUG : /usr/bin/fail2ban-client exists and is executable
DEBUG : final fail2ban command: /usr/bin/fail2ban-client
DEBUG : warning threshold : 1, critical threshold : 5
DEBUG : it seems the connection with the fail2ban server is ok
CHECK FAIL2BAN ACTIVITY - OK - 0 current banned IP(s) for the specific jail ssh | currentBannedIP=0

# for all the current jails
$ ./check_fail2ban --verbose -p -w 1 -c 5 -P /usr/bin/fail2ban-client
DEBUG : fail2ban_client_path: /usr/bin/fail2ban-client
DEBUG : /usr/bin/fail2ban-client exists and is executable
DEBUG : final fail2ban command: /usr/bin/fail2ban-client
DEBUG : warning threshold : 1, critical threshold : 5
DEBUG : it seems the connection with the fail2ban server is ok
DEBUG : jails list: apache, ssh-ddos, ssh
DEBUG : the jail apache has currently 0 banned IPs
DEBUG : the jail ssh-ddos has currently 0 banned IPs
DEBUG : the jail ssh has currently 0 banned IPs
CHECK FAIL2BAN ACTIVITY - OK - 3 detected jails with 0 current banned IP(s) | currentBannedIP=0
```` 
