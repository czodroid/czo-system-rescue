+++
weight = 30030
title = "Standard partitioning tools"
draft = false
aliases = ["/Sysresccd-Partitioning-EN-Standard-partitioning-tools"]
+++

## About

SystemRescue comes with many disk and partitioning tools. This section
will give you a good idea of which ones you should use, and what they
can do. Of course, all of these tools are free software for Linux and
you don't have to pay to use them. It is recommended to read the
[Introduction to partitioning](/disk-partitioning/Introduction-to-disk-partitioning/)
as well as the section about
[Partitions attributes](/disk-partitioning/Partitions-attributes/) first.

## Fdisk and Gdisk

**fdisk is a primitive disk partitioning tool**. Each operating system
comes with its own version of fdisk, but they all provide the same sort
of services. fdisk allows you to create, edit and delete partitions. In
other words it's a tool to edit
[partition tables](/disk-partitioning/Introduction-to-disk-partitioning/)
on your disk. It can work on both the primary partitions table which is
stored in the MBR and the logical partitions which are implemented in
the extended partitions. fdisk used to only work on MBR/MSDOS partition tables
but in recent versions it also supports GPT partition tables.

fdisk allows you to create and manipulate partition tables, but unlike parted
it won't do anything with the contents of the partition. In other words you will
have to use another tool if you want to create or modify a filesystem in a
partition created using fdisk. fdisk can be used to create partitions before you
install an operating system on it.

Changes are not committed immediately with fdisk. All the changes are
made and held in memory until you decide to write your modifications to
the disk. This allows you to try modifications and see how they look
before you decide whether or not to keep them.

fdisk is not the best tool if you want to create new partitions on your
disk. It is the appropriate tool when you want to make changes which are
not available from other partitioning tools. It is very useful if you
want to change the identifier of a partition without changing its
filesystem, because the other tools don't give you access to that sort
of advanced option in general.

fdisk can also be used to resize partitions when Parted/GParted are
not able to do that. They refuse to resize partitions when the
partitions don't support their filesystem. In that case you will have to
delete the partition and recreate it with a different size in fdisk. You
won't lose the contents because fdisk only modifies the partition table,
not the partition contents. This is still quite risky, so you must be
very careful. You must also use the appropriate tool to resize the
filesystem manually.

So fdisk is a quite primitive partitioning tool which should only be
used for specific things that cannot be done from parted/gparted. And
it must be used with care.

gdisk was designed as an equivalent of fdisk for manipulating
[GPT disks](/disk-partitioning/The-new-GPT-disk-layout/).
You should use Parted or GParted for normal tasks on GPT disks since
they support it. gdisk is a good alternative for things that cannot be
done from Parted and GParted.

## Parted

Parted (GNU Partition Editor) is the most popular command line
partitioning tool for linux. It supports a wide range of partition
tables: naturally it works on
[msdos/bios partition tables](/disk-partitioning/Introduction-to-disk-partitioning/)
and on [GPT partition tables](/disk-partitioning/The-new-GPT-disk-layout/),
but it also supports the partition tables for sun, bsd, aix, amiga, ...

**Parted has to be used from the command line**. It's not difficult once
you are a bit familiar with it. It provides many options which makes it
easy to use. For instance you can manipulate partition sizes in
Mega-Bytes and Giga-Bytes as well as sectors. All the changes take
effect immediately in Parted, so you have to be careful.

**Parted works on both the partition table and on filesystem levels** at
the same time. In other words it will both create an entry in the
partition table and a filesystem on the space allocated to it when you
decide to make a new partition. It has built-in support for FAT and EXT2
filesystems. It will then be able to create and resize these
filesystems. Parted has no such support for the other filesystems (ntfs,
ext3, ext4, xfs, btrfs, ...), but they will be detected
anyway. As a consequence, you will have to use the external filesystems
tools once you have created an empty partition in Parted, or you can use
GParted which does that for you.

So **Parted is the best partitioning tool in text mode** on Linux. It
should be the default choice if you don't want to use a graphical tool.
It can also be scripted if you want to automate operations using scripts.

## GParted

**GParted is the best graphical partitioning tool for Linux**. It's
based on Parted's library (libparted) for partition table manipulations
but **it's not just a front-end to Parted** because it also interacts
with filesystem tools to provide support for all the popular
filesystems. For instance, it will use programs from ntfsprogs to
create and resize ntfs partitions. As a consequence it requires these
filesystem tools for these features to be available. Fortunately
SystemRescue comes with all the filesystem tools that GParted
requires. The modifications done in GParted are not immediately applied
on the disk, so you have to apply your modifications for the changes to
take effect.

GParted is very user friendly. The graphical representation of the disks
gives a good idea of how the disk space is used by partitions. It may be
used by users who are not expert in disk partitioning. It provides all
the traditional tasks for most filesystems:

-   Creation of a new partition table on a disk device
-   Creation of partitions and filesystems
-   Deletion of partitions from the disk
-   Move and resize partitions with no data losses
-   Check the integrity of a filesystem
-   Modifications of partition attributes (label, flags, ...)

![sysresccd-gparted-02.png](/images/sysresccd-gparted-02.png)

## Filesystem tools

**Linux supports a wide range of filesystems**: it provides a full
read-write support for Windows filesystems (fat and ntfs) as well as its
own native filesystems (ext3, ext4, reiserfs, xfs, jfs, btrfs).
They can all be used from the command line, and **they provide advanced
options** that cannot be accessed from generic partitioning programs.
**Each filesystem comes with its own set of programs**:

-   **mkfs**: is the traditional program that creates a new filesystem
    on a partition of your disk
-   **fsck**: checks the integrity of a filesystem and it repairs
    inconsistencies (due to a bug or a crash)
-   **resizefs**: allows you to grow a filesystem (you must grow the
    partition first) or to shrink it (shrink the partition afterwards).
-   **tunefs**: is used to change various settings of a filesystem (its
    volume name, advanced options, ...)

Each filesystem has its own limitation(s) and may provide extra tools.
Here are examples:

-   **e2fsprogs**: linux ext2/ext3/ext4 filesystems (mke2fs, e2fsck,
    resize2fs, tune2fs)
-   **reiserfsprogs**: linux reiserfs versions 3.5/3.6 (mkreiserfs,
    reiserfsck, resize\_reiserfs, reiserfstune)
-   **xfsprogs**: linux xfs filesystems (mkfs.xfs, fsck.xfs,
    xfs\_growfs, xfs\_admin) (shrinking xfs is not possible)
-   **ntfsprogs**: windows ntfs filesystems (mkntfs, ntfsfix,
    ntfsresize)

Most **native linux filesystems can be grown online** (ie: when the
filesystem is mounted). It's very useful for production servers since it
allows you to allocate more space to a filesystem with no down time. To
do that you just have to run the normal `resizefs` command that
corresponds to a particular filesystem. The command will exit quickly
since the real resize is done by the filesystem driver in the kernel.
