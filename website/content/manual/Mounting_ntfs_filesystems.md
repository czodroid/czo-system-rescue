+++
title = "Mounting NTFS file systems"
draft = false
aliases = ["/Sysresccd-manual-en_Mounting_an_NTFS_partition_with_full_Read-Write_support"]
+++

## Introduction
NTFS (New Technology File System) is the default file system used on recent
Windows versions and the Windows system disk is based on the NTFS format.

Linux has offered full read support for NTFS file systems for a long time.
However, until recently, the NTFS write support that cames with the kernel was
missing. To have access to a full read-write support for NTFS disks, you had to
use [ntfs-3g](https://wiki.archlinux.org/title/NTFS-3G), which is a userspace
program, and hence it is very slow.

SystemRescue version 9.00 comes with Linux-3.15 which brings the
[kernel based ntfs3 file system driver](https://www.kernel.org/doc/html/latest/filesystems/ntfs3.html).
This modern kernel module provides a full read-write support for NTFS on Linux.
It is the recommended way to access NTFS disks from SystemRescue. At this stage
ntfs-3g is still the default NTFS driver, so you have to explicitly specify that
you want to use ntfs3 in order to benefit from this new driver.

If you do not know the name of the device which contains the NTFS file system,
you should use `lsblk` and `blkid` or GParted to identify the disk. In the
following examples we will assume the device name is `/dev/xxx`, please replace
this with the name of the actual device.

## Full Read-Write support
If you need a complete NTFS Write support, should use a mount command such as:
```
mkdir -p /mnt/windows
mount -t ntfs3 /dev/xxx /mnt/windows
```

## Read only support
If you just want a read support on NTFS disks, you can specify the `-o ro`
option to restrict the access to the file system). This read-only support is
safer (you cannot alter or damage your data) and may be used for example if you
just want to backup several files, or read a document.

```
mkdir -p /mnt/windows
mount -t ntfs3 -o ro /dev/xxx /mnt/windows
```
