Check command object for the check_ping.exe plugin. ping-windows should automatically detect whether ping_win_address is an IPv4 or IPv6 address. If not, use ping4-windows and ping6-windows. Also note that check_ping.exe waits at least ping_win_timeout milliseconds between the pings.

https://icinga.com/docs/icinga2/latest/doc/10-icinga-template-library/#ping-windows