+++
title = "mountall: Mount all disks and volumes"
+++

## Overview

`mountall` checks all available block devices, partitions, LVM volumes, MD RAID and LUKS-encrypted 
devices and tries to automatically mount them. Filesystems are autodetected and default options used. 
Already mounted devices and devices where filesystem autodetection doesn't work are ignored.

The devices are all mounted below `/mnt` with their device names, so for example `/mnt/sda1`. If
a directory is already in use, `_<n>` is appended to the directory name with increasing numbers 
until a free name is found. So for example when `/mnt/sda1` is busy, `/mnt/sda1_1` is tried.

## bind mounts for `/dev`, `/proc` and `/sys`

When mountall detects that a filesystem contains the directories `/dev`, `/proc` or `/sys`, it
guesses that the partition is a root partition for a Linux system. It then bind-mounts these
directories from System Rescue into it. This helps when chrooting into the path: many common
commands, like `grub-install` or `rpm`, require these directories to be available and populated.

You can disable this behavior with the `--no-bind` option.

## All options

```
mountall - mount all suitable block devices

Usage:
mountall [-n|--no-bind] [-o|--ro|--readonly] [-v|--verbose]

--no-bind                   Don't try to bind-mount /dev /proc and /sys when
                            the partition has these dirs
--readonly                  Mount read-only
--verbose                   Verbose output.
```
