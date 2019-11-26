# NetEye Template Library - NTL

Collection of monitoring plugins including metadata to support a standard deployment with NetEye 4.

This Repository comes with the aim of an integrative for "neteye4" repository.

NOTICE: This Project is Work In Progress.

[WP Project documentation link (Private)](https://siwuerthphoenix.atlassian.net/wiki/spaces/SCN/pages/1176633630/NetEye+Template+Library)

## Installation and setup

- Clone the present repository to a local drive on neteye
- Start the deployment of provided scripts and fetch resources from third-party repositories by running the ntl_download.sh.

```
mkdir /tmp/ns
cd /tmp/ns
git clone https://github.com/zampat/ntl
cd ntl
./ntl_download.sh

## Updates from community repo

Principally all improvements provided by this repository support an incremental update of your plugins. __Existing configurations are not altered.__
To update and install latest ntl plugins at any later moment:
```
cd neteye4
git fetch
git pull
./ntl_download.sh
```


