+++
weight = 30010
title = "Introduction to disk partitioning"
draft = false
aliases = ["/Sysresccd-Partitioning-EN-Introduction-to-disk-partitioning"]
+++

## About

Hard drives can contain multiple partitions. This may be used to isolate
the data from the Operating-System and programs. It can also be used to
**install multiple Operating-Systems on the same hard disk drive**, or
to organize your data in a specific way. Disk partitioning is quite
important especially if you want to install Linux. The standard PC/BIOS
partitioning system is very old so you may also be interested in the
[new GPT layout](/disk-partitioning/The-new-GPT-disk-layout/).
This chapter will tell you **all the basic things you need to know about
partitioning** and it will describe the standard PC/BIOS partition table
and its limitations.

## Master Boot Record

Disks based on the standard PC/BIOS partition tables all start with the
MBR (Master Boot Record) which is written on the first sector of the
disk. The MBR contains two important things:

* The boot code
* The partition table

**The `boot code`** is the place where the instructions executed during
the boot process are stored. These instructions will load and execute
instructions stored in other sectors of the disk so that the operating
system can boot.

**The `partition table` is where the definitions for the primary
partitions are stored**. Unfortunately this table can only contain up to
4 partitions. If you need more than four partitions, one of these
primary partitions has to be an `extended partition`. This type of
partition can contain secondary partitions called `logical drives`. You
can create an extended partition even if you have fewer than 4 primary
partitions. The problem of extended partitions is that it's more
complicated than primary partitions, and it's a bit fragile.

If your MBR is overwritten then you will lose your partitions, it won't
be possible to boot, and you will not be able to access your data.
That's why you must be very careful when you make modifications in your
MBR. Fortunately, tools such as **testdisk** can scan the disk and try
to recreate the original partitions if you lose your MBR.

**Each partition has an identifier which is written in the partition
table**. This identifier is used to identify what sort of filesystem the
partition contains. Sometimes it may not be consistent with the data
that the partition actually contains: a Linux partition may have the
Windows identifier. That's why it's important to check what the
filesystem of that partition is if you are not sure.

**Windows can only be installed on a primary partition**. Fortunately it
can use logical drives for data. Linux can be installed on any type of
partition, including logical drives.

The standard PC/BIOS partition tables only allow addresses up to 2
Tera-Bytes. It can be used on larger disks, but the extra space will be
inaccessible. To address more than 2 Tera-Bytes use
[GPT](/disk-partitioning/The-new-GPT-disk-layout/), but
you won't be able to boot Windows from that disk.

## Partitions and filesystems

It's very important to **differentiate two things: the partition and the
filesystem**. A partition is a group of contiguous sectors of your disk.
The filesystem is the system that organizes the storage of data within a
partition: it's responsible for managing files, folders, permissions,
and many other things.

A partition is defined by the first sector on the disk, last sector on
the disk, identifiers and attributes. Here is an example of a partition
table on a disk:

       Device Boot      Start         End      Blocks   Id  System
    /dev/sda1               2         730     5849610   83  Linux
    /dev/sda2             893        7001    49070542+  83  Linux
    /dev/sda3            7002        9730    21915211+  83  Linux

The most popular filesystems are FAT and NTFS for Windows and ext3,
ext4, reiserfs for Linux. **Each operating system has its own native
filesystems**. For instance Windows can only be installed using FAT or
NTFS. Linux has a bigger choice of native filesystems (ext3, ext4,
reiserfs, xfs, jfs, btrfs, ...), and it's also able to read and write
Windows filesystems. So you can read and write data on your Windows
partitions from Linux.

When you create a partition with low level tools such as fdisk, it may
just create an empty partition with no filesystem in it. This partition
won't be readable until a valid filesystem has been created on it. But
in general, advanced partitioning tools create both the partition and a
valid filesystem in the same time.

It's also very important to differentiate the partition and the
filesystem for resizing: in general a filesystem uses 100% of the space
available in a partition. It can never be bigger than the partition, but
it can be smaller. When you want to grow a partition, you first have to
grow the partition itself, and then you can grow the filesystem which is
inside. When you shrink a partition, you have to shrink the filesystem
first.

You should now understand the difference between **three levels of free
space**:

-   Within a hard-disk, there can be space which is not allocated to a
    partition
-   Within a partition, there may be space which is not allocated to the
    filesystem (it's very rare)
-   Within a filesystem, some space may not be allocated to any file,
    but it's allocated to the filesystem anyway.

## How to create partitions

If your disk is empty there are many ways to create new partitions. The
Windows and Linux installation programs allow you to create and destroy
partitions. In other words, if you want to install an Operating System
on a brand new disk, you don't need any additional partitioning tool
because the installation program can do that. However, you may have to
select advanced options.

You may also want to **modify your disk partitions when they already
contain data**. If you have no particular partitioning program you can
always destroy all your partitions and recreate new ones, but you will
lose all your data. You can do that with all the basic partitioning
tools (Disk-Manager in Windows, fdisk on Linux, etc.).

Fortunately there are **advanced partitioning programs** that allow you
to make modifications to your partitioning with no data loss by using
tools that understand the filesystem used on a partition. Thus it's
possible to move and resize existing partitions. You can also change
their labels or their settings (visible, hidden, etc.). The commercial
products Partition Magic and Acronis Disk Director have good support for
Windows partitions (FAT and NTFS). They also provide support for
advanced operations such as merging two partitions or splitting a
partition, but they don't provide good / up-to-date support for Linux
partitions in general.

**SystemRescue comes with GParted**. It's a graphical tool that
supports all the Windows and Linux filesystems. It also works on [GPT
disks](/disk-partitioning/The-new-GPT-disk-layout/). It allows you to
move and to resize partitions. Unfortunately it does not
support very advanced features such as merging and splitting.
