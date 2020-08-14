The check_haproxy_status plugin, uses the haproxy statistics socket to monitor haproxy frontends/backends.

https://github.com/jonathanio/monitoring-nagios-haproxy/blob/master/README.md

# check_haproxy Nagios Check Script

This is a Nagios plugin to check the status of HAProxy over a socket connection
(by default, /var/run/haproxy.sock) and parse the statistics to ensure that it
is operating within accepted limits, as per the defaults, or as set for each
frontend/backend.

## Usage

    check_haproxy [--defaults (defaults)] [--overrides (1 2 ... n)]
      [--[no]frontends] [--[no]backends] [--[no]servers]
      [--socket (path)] [--help]

### -f, --[no]frontends

Enable/disable checks for the frontends in HAProxy (that they're marked as OPEN
and the session limits haven't been reached).

### -b, --[no]backends

Enable/disable checks for the backends in HAProxy (that they have the required
quorum of servers, and that the session limits haven't been reached).

### -s, --[no]servers

Enable/disable checks for the servers in HAProxy (that they haven't reached the
limits for the sessions or for queues).

### -D, --defaults (defaults)

Set/Override the defaults which will be applied to all checks (unless
specifically set by --overrides). Takes the form:

    {u,d,x},{svr_warn},{svr_crit},{sess_warn},{sess_crit}

Each of these is optional, but the positioning is important. To fully override,
set (for example):

    u,10,5,.25,0.5

which means:

* `u`: Check for servers up (`u`) or servers down (`d`), or disable all checks
  on that particular frontend/backend (`x`).
* `10`: WARNING if less than 10 servers are up, or if at least that many servers
  are down.
* `5`: CRITICAL if less than 5 servers are available, or if at least that many
  have gone away.
* `.25`: WARNING if more any frontend, backend, or individual server has gone
  over 25% of it's maximum allowed sessions (or any queue for any server on the
  backend is at least 25% full).
* `0.5`: CRITICAL for the same reasons as previous, but we've reached 50% of
  these levels.

To override only some of these values from the pre-set defaults
(`u,5,2,.75,.9`), simply leave the others as empty, for example: `,10,7` will
leave checks as up, but increase the server WARN/CRIT to 10/7. or to switch to
use down, use `d,`, or off with `x`.

Each number has two meanings:

* `less than 1`: Where any number is less than (but not equal to) 1, then the
  value is understood as a percentage of the available servers or session
  limits. If you have 20 servers and set a threshold of .25 then that would
  mean 5 servers either up or down.
* `greater than, or equal to 1`: Where any number is greater than, or equal
  to, 1, then this is a fixed value. By setting 5 you are hard-coding the
  number of servers or sessions, regardless of the limit or number available
  to HAProxy.

The code **does not** alter this limit if it is greater than the available
servers or sessions so there are situations where the alert may not trigger.
For example, in the event of `down` being the trigger and the number of servers
is less than the Warning or Critical thresholds, the error may never trigger.
It is generally better to use `up` and percentage values where you are going
to have a flexible number of backends.

### -O, --overrides (override override ... override)

Override the defaults for a particular frontend or backend, in the form
`name:override`, where `override` is the same format as `--defaults` above. For
example, to override the frontend called "api" and allow that to increase to
limits of 15/10 for WARN/CRIT, use `api:,15,10`. Add as many as you like as
space-delimited options:

    --overrides api:,15,10 assets:d,2,5 webmail:u,3,2

### -S, --socket /path/to/socket

Path to the socket `check_haproxy` should connect to (requires read/write
permissions and must be at least user level; no operator or admin privileges
needed).

