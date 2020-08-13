https://exchange.icinga.com/exchange/check_memcached

check_memcached will give a critical message if a partiular memcached host is inaccessible.

It will generate a warning (only) if the hit/miss ratio falls below a given threshold (default 2) It will generate a warning (only) if the number of evictions exceeds a given limit (default 10)
