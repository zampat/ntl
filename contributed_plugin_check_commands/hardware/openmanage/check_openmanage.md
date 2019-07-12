The check_openmanage plugin checks the hardware health of Dell PowerEdge (and some PowerVault) servers. It uses the Dell OpenManage Server Administrator (OMSA) software, which must be running on the monitored system. check_openmanage can be used remotely with SNMP or locally with icinga2 agent, check_by_ssh or similar, whichever suits your needs and particular taste.

The plugin checks the health of the storage subsystem, power supplies, memory modules, temperature probes etc., and gives an alert if any of the components are faulty or operate outside normal parameters.


http://folk.uio.no/trondham/software/check_openmanage.html

