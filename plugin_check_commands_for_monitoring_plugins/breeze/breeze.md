This plugin reports the signal strength of a Breezecom wireless equipment

Usage: check_breeze -H <host> [-C community] -w <warn> -c <crit>

-H, --hostname=HOST
   Name or IP address of host to check
-C, --community=community
   SNMPv1 community (default public)
-w, --warning=INTEGER
   Percentage strength below which a WARNING status will result
-c, --critical=INTEGER
   Percentage strength below which a CRITICAL status will result