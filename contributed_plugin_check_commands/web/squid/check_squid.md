check_squid is a plugin to nagios for monitoring Squid

https://exchange.icinga.com/exchange/check_squid

Wrote in perl, It require NAGIOS::Plugin to work.

## Usage

```
check_squid [ -v| --verbose ] [ -H < host > ] [ -d < data > ] [ -p < port > ] [ -t < timeout >] [ -c < threshold > ] [ -w < threshold > ]
````

## Options

| Flag	| Description
|----|---|
| -H |  --host=< hostname >	Name of the proxy to check (default: localhost)
| -d | --data=< data >	Optional data to fetch (default: Connections) available data : Connections Cache Resources Memory FileDescriptors
| -p | --port=< port >	Optional port number (default: 3128)
| -U | --user=< user >	Optional WWW user (default: root)
| -W | --password=< password >	Optional WWW password
| -w | --warning=THRESHOLD	Warning threshold
| -c | --critical=THRESHOLD	Critical threshold
| -s | --squidclient=< squidclient_path >	Path of squidclient (default: /usr/sbin/squidclient)
