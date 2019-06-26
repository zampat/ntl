# disk-windows
Check command object for the `check_disk.exe` plugin. Aggregates the disk space of all volumes and mount points it can find, or the ones defined in `disk_win_path`. Ignores removable storage like flash drives and discs (CD, DVD etc.). The data collection is instant and free disk space (default, see `disk_win_show_used`) is used for threshold computation.

> **Note**
> Percentage based thresholds can be used by adding a ‘%’ to the threshold value.

**Custom attributes:**

| Name | Description |
| ------ | ------ |
|disk_win_warn|	**Optional**. The warning threshold. Defaults to “20%”.
|disk_win_crit|	**Optional**. The critical threshold. Defaults to “10%”.
|disk_win_path|	**Optional**. Check only these paths, default checks all.
|disk_win_unit|	**Optional**. Use this unit to display disk space, thresholds are interpreted in this unit. Defaults to “mb”, possible values are: b, kb, mb, gb and tb.
|disk_win_exclude|	**Optional**. Exclude these drives from check.
|disk_win_show_used|	**Optional**. Use used instead of free space.