Checks by snmp v1, v2c or v3 environemental parameters such as fan, power supply, temperature


http://nagios.manubulon.com/snmp_env.html

Get help

./check_snmp_env.pl -h

Verbose output	./check_snmp_env.pl -H <IP> -C <com> -v
snmpv3 login	./check_snmp_env.pl -H 127.0.0.1 -l login -x passwd
Check Cisco for all sensors

./check_snmp_env.pl -H 127.0.0.1 -C public -T cisco

Check Nokia for all sensors	./check_snmp_env.pl -H 127.0.0.1 -C public -T nokia
checks ironport fans RPM > 1500 and temp < 70 deg celcius	./check_snmp_env.pl -H 127.0.0.1 -C public -T iron -F 1500 -c 7