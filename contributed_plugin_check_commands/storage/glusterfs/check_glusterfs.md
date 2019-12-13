The glusterfs plugin is used to check the GlusterFS storage health on the server. The plugin requires sudo permissions.

https://icinga.com/docs/icinga2/latest/doc/10-icinga-template-library/#glusterfs

## Variables
| Name | Description
|-|-
| glusterfs_perfdata | 	Optional. Print perfdata of all or the specified volume.
| glusterfs_warnonfailedheal | 	Optional. Warn if the heal-failed log contains entries. The log can be cleared by restarting glusterd.
| glusterfs_volume | 	Optional. Only check the specified VOLUME. If –volume is not set, all volumes are checked.
| glusterfs_disk_warning | 	Optional. Warn if disk usage is above DISKWARN. Defaults to 90 (percent).
| glusterfs_disk_critical | 	Optional. Return a critical error if disk usage is above DISKCRIT. Defaults to 95 (percent).
| glusterfs_inode_warning | 	Optional. Warn if inode usage is above DISKWARN. Defaults to 90 (percent).
| glusterfs_inode_critical | 	Optional. Return a critical error if inode usage is above DISKCRIT. Defaults to 95 (percent).

## USAGE

```
check_glusterfs [-H HOST] [-p] [-f] [-l VOLUME]
         [-w DISKWARN] [-c DISKCRIT]
         [-W INODEWARN] [-C INODECRIT]
```

## OPTIONS


- H

Optional. Dummy for compatibility with Nagios.

- p 

Optional. Print perfdata of all or the specified volume. I<Warning>: depending on how many volumes and bricks you have, this may result in a lot of data.

- f <warnonfailedheal>

Optional. Warn if the I<heal-failed> log contains entries. The log can be cleared by restarting C<glusterd>.

- B <volume>

Optional. Only check the specified I<VOLUME>. If B<--volume> is not set, all volumes are checked.

- w <diskwarn>

Optional. Warn if disk usage is above I<DISKWARN>. Defaults to 90 (percent).

- c <diskcrit>

Optional. Return a critical error if disk usage is above I<DISKCRIT>. Defaults to 95 (percent).

- W <inodewarn>

Optional. Warn if inode usage is above I<DISKWARN>. Defaults to 90 (percent).

- C <inodcrit>

Optional. Return a critical error if inode usage is above I<DISKCRIT>. Defaults to 95 (percent).


## DESCRIPTION

This nagios/icinga check script checks the glusterfs volumes, their bricks and the heal logs. If enabled, it returns the per-brick perfdata split-brain, heal-failed, healed, disk used and inodes used.

## CAVEATS

Do NOT run multiple copies of check_glusterfs simultanously in a cluster. All bricks will appear offline.

## DEPENDENCIES


Getopt::Long

pod::Usage

gluster

## AUTHOR

Philippe Kueck <projects at unixadm dot org>
