https://www.claudiokuenzler.com/nagios-plugins/check_esxi_hardware.php

## Usage:
```
./check_esxi_hardware.py -H esxi-server-ip -U username -P mypass [-C -S -V -i -r -v -p -I]

./check_esxi_hardware.py --host esxi-server-ip --user username --password mypass [--cimport --sslproto --vendor --ignore --regex --verbose --perfdata --html]

./check_esxi_hardware.py -H esxi-server-ip -U -P file:/path/.passwdfile [--cimport --sslproto --vendor --ignore --regex --verbose --perfdata --html]

./check_esxi_hardware.py -H esxi-server-ip -U file:/path/.passwdfile -P file:/path/.passwdfile [-C -S -V -i -r -v -p --html]
```

## Examples:
``` 
./check_esxi_hardware.py -H 10.0.0.200 -U root -P mypass -V dell -p -I de
./check_esxi_hardware.py --host esxiserver1 --user root --password mypass --vendor hp --perfdata
./check_esxi_hardware.py --host esxiserver2 --user root --password mypass --vendor dell --html us
./check_esxi_hardware.py -H esxiserver1 -U root -P file:/root/.esxipass -V dell
./check_esxi_hardware.py -H esxiserver1 -U file:/root/.esxipass -P file:/root/.esxipass -V dell
./check_esxi_hardware.py -H esxiserver1 -U root -P mypass -V dell -i "IPMI SEL"
./check_esxi_hardware.py -H esxiserver1 -U root -P mypass -C 5989 -S TLSv1.0
```
