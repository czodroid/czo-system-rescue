+++
weight = 20010
title = "Overview"
draft = false
aliases = ["/Sysresccd-LVM-EN-Overview-of-the-logical-volume-manager"]
+++

## About
LVM is the **Logical Volume Manager** for Linux, currently in version 2. It's
the new method to manage the disk storage in a way which is more flexible than
the traditional disk partitioning. It allows you to create and modify volumes
easily. The standard partitioning method has many limitations: when you shrink
a partition which is at the end of your disk, you have to move the partitions
if you want to reallocate this space to grow another partition. With LVM you
don't have such problems. All you need to use LVM is a Linux kernel with
the device-mapper support enabled, and the lvm2 userspace tools. LVM2 has been
in production for many years so it's now very stable and you should not have any
problems with it.

LVM comes with all the recent mainstream Linux distributions, and it's even used
by default on Redhat Linux. The purpose of this document is to help you to
understand what it is, how it works, and to decide whether or not it's good for
you.

## Description
In the traditional partitioning layout, there are just two levels of storage:
the physical disks, and the partitions which are containers inside a physical
disk. LVM comes with three levels of storage to offer more flexibility. We end
up with containers called Logical-Volumes which correspond to an improved type
of disk partition. It's important to understand that partitions and
Logical-Volumes are just sets of disk blocks with a size. You still have to make
a filesystem on your volume to use it. It's different from Solaris ZFS where the
volume manager and the filesystem are integrated. In the world of Linux, the
volume manager and the filesystem are independent. You can choose which
filesystem you want to use on the top of a Logical-Volume. The ext4 filesystem
is the default choice because it is stable, but you can also use xfs for
instance. In the future, btrfs could be the standard filesystem in Linux.

Here are the three levels of storage:

* **Physical Volumes (PV)**: This is the physical storage used by LVM. it may b
  an entire disk or an existing partition
* **Volume Group (VG)**: This is an aggregate of one or more Physical Volumes,
  and it contains Logical-Volumes.
* **Logical Volume (LV)**: This is the space offered by LVM that you can use as
  a partition to make a filesystem and store your files.

In any case all of these three levels are required. You have to create a
Volume-Group even if you only have one Physical-Volume on your computer. With
these three levels of storage, you can organize your data in a very flexible
way, and you can sometimes make very interesting combinations.

LVM manages the disk space in chunks called extents. They all have the same size
(32MB in general). That way the blocks of a volume can be spread over the whole
size of your disks, which provides the possibility to resize the volumes
 multiple of times with no limitation other than the total disk space.

It's also possible to use both LVM and the traditional partitioning method on
the same disk: for instance you can install Windows on the first partition of
your disk, install linux on the second partition, and create a third partition
for LVM to store your data in a flexible way.

## Concrete example
Let's consider that you have two hard disks: /dev/sda (250GB) and
/dev/sdb (160GB). Let's create four primary partitions on the first
disk for Linux-boot, Windows, Linux-root, and LVM, and one partition for linux
on the second disk (entirely dedicated to LVM):
```
# parted /dev/sda
parted> mklabel msdos
parted> mkpart primary 0 100M
parted> mkpart primary 100M 4196M
parted> mkpart primary 4196M 8292M
parted> mkpart primary 8292M 100%
parted> quit

# parted /dev/sdb
parted> mklabel msdos
parted> mkpart primary 0 100%
parted> quit
```

The next thing to do is to create two Physical-Volumes on these disks. This will
just initialize these two disks so that LVM can use them. There is no name
associated with Physical-Volumes other than the name of the device where they
have been created.
```
# pvcreate /dev/sda4
# pvcreate /dev/sdb1
```

Now, we will create one Volume-Group as the concatenation of the two
Physical-Volumes. We have to choose a name for this Volume-Group, let's
use VolGroup00:
```
# vgcreate VolGroup00 /dev/sda4 /dev/sdb1
```
You can print details about this new Volume-Group using either vgdisplay
or vgs.

This Volume-Group now provides about 400GB of storage that we can use to make
Logical-Volumes. Each time we create a Logical-Volume we have to give it a name
and a size. We could make one big Logical-Volume of 400GB is we wanted to, but
let's create only two Logical-Volumes and ext3 filesystems on the top:
```
# lvcreate -n data -L 50G VolGroup00
# mke2fs -j /dev/VolGroup00/data -L data
# mount /dev/VolGroup00/data /mnt/data

# lvcreate -n backup -L 35G VolGroup00
# mke2fs -j /dev/VolGroup00/backup -L backup
# mount /dev/VolGroup00/backup /mnt/backup
```

When you use lvcreate, your system will create a special file to manage this
device. It can be either /dev/vgname/lvname or /dev/mapper/vgname-pvname or both.

After some time, you may decide to use the disk space which is not yet allocated
in your Volume-Group to grow a Logicial-Volume which needs more space. Most
linux filesystems can be grown online, which means that you don't have to
unmount it. They can be grown even if they are in use. This is very useful on
servers for which we want to avoid any down time. Let's add 10GB of space for
the backups:
```
# lvresize -L +10G /dev/VolGroup00/backup
# resize2fs /dev/VolGroup00/backup
```

The command to resize a Logical-Volume is lvresize. You can either give it a
relative size (+10 GB to grow it by 10GB) or an absolute size (45GB). When no
size is given to resize2fs (the tool that resizes ext2/ext3/ext4 filesystems),
then it automatically grows to the size of the underlying volume which is what
we want. Be careful if you shrink a volume. You have to unmount the filesystem
first since linux filesystems do not support online shrinking with the exception
of btrfs. Also you have to shrink the filesystem first (using resize2fs,
resize_reiserfs, ...) and then you can resize the volume. A filesystem cannot be
bigger than the volume where it lives. For this reason, it's good practice not
to allocate all the space of your Volume-Groups immediately. It's recommended to
create small Logical-Volumes first so as to leave some free space on your
Volume-Group. You can always grow the volumes later when you need more space.
This way you avoid having to unmount a filesystem to shrink it in order to free
some space for other Logical-Volumes. This would require some down time which
is not always possible on production machines.

## How to use LVM
There was a version 1 of LVM but it's very old now so all the recent Linux
distributions have LVM2. By default lvm can be managed using the command line
tools which come with the package called lvm2. The names of these commands are
very easy to remember: in general there is a prefix which is one of the
following: pv, vg, lv depending on what sort of object we want to work on
(Physical-Volumes, Volume-Groups, Logical-Volumes). Then comes the name of the
action we want to perform: create, display, rename, reduce, ... We end up with a
command such as ```pvcreate```, ```vgcreate```, ```lvcreate```, ```pvdisplay```.
If these commands are not available and you are sure lvm2 is installed, you may
have to use one of these commands as an argument of the main lvm binary. So you
may have to type something such as ```lvm lvcreate <arguments>```
instead of ```lvcreate <arguments>```.

There is no real need for graphical tools with LVM because the physical way the
blocks are stored does not really matter. With LVM we don't have to know whether
the volume is stored at the beginning or at the end of the disk: you can grow or
shrink your volumes as long as there is some space somewhere in the
Volume-Group. The lvm2 commands are really easy to use directly once you
understand how they work. These commands accept the sizes in common units such
as MB, GB, TB. You don't have to worry about sectors or cylinders. Thereafter
you just use the filesystem commands such as mkfs, fsck, resizefs on your
volumes.  There is no real need for graphical tools to do that either.

## Reasons to use LVM
There are many good reasons to use LVM:

* **Flexible disk space management:**
  The first reason to use LVM is to have a flexible way to use the free space of
  your disk and to be able to allocate the space from anywhere on the disk to
  grow a volume. Because most linux filesystems support online growing, there is
  no down time when you just want to grow a a volume.
* **Making read-only snapshots of a volume:**
  With LVM you can create read-only snapshots of an existing Logical-Volume as
  long as you have some space in your Volume-Group to store a copy of the
  original blocks which are modified during that time. It's the best way to
  make consistent [linux backup](/lvm-guide-en/Making-consistent-backups-with-LVM/)
  because the blocks from the read-only snapshot are frozen in the original
  state while the normal filesystem is still being modified.
* **Preserving the name of your volumes:**
  The name of physical disks and partitions may change if you reconnect the same
  disk onto another computer or if you plug it into another disk controller in
  the same machine. The partition which was named ```/dev/sda1``` may
  be ```/dev/sdb1``` on another computer. This can break many things like the
  ability to boot. With LVM the Logical-Groups and the Logical-Volumes will keep
  the names they have been given even if the name of the physical disk is
  modified. You can rename them at anytime using commands such as ```vgrename```
  or ```lvrename```.
* **Avoiding limitations of the number of volumes:**
  If your hard disk uses the msdos disklabel (the standard partition table
  system used on most computers) then you are limited to 4 primary partitions.
  You can have more partitions if you have an extended partition, but the
  implementation is based on a linked list so it's very fragile. If you loose a
  link to a logical partition, you will loose the next ones. Anyway linux only
  supports up to 16 partitions per disk because the 17th minor number is used
  for the first partition of the next disk. With LVM you don't have this
  limitation so you can have more than 16 Logical-Volumes per disk.
* **Live-migration of your data:**
  It's possible to move Logical-Volumes from one physical disk to another disk
  while the filesystems are still in use (mounted with a read-write access and
  modified). To do that, you must first create a new Physical-Volume on the
  new disk, add it to the current Volume-Group using ```vgextend```. Then
  use ```pvmove``` to move the extents of your Logical-Volumes from the old disk
  to the new one (they will stay inside the same Volume-Group). Then remove the
  old Physical-Volume from the Volume-Group using ```vgreduce```, and then
  destroy the old Physical-Volume. It's a very useful technique to upgrade to a
  bigger hotplug hard-drive on a production server that must stay in production
  during the migration of the contents.
* **Concatenate multiple small disks:**
  Logical-Volumes can be bigger than a physical disk because a Volume-Group can
  be made of multiple Physical-Volumes.

## Limitations with LVM
Despite these good things, LVM may not always be appropriate:

* **Non-linux operating systems won't see the volumes:**
  There is currently no stable solution for reading Linux LVM volumes from
  another operating system such as Windows. Even if you use an NTFS filesystem
  on your Logical-Volume, Windows won't be able to read it because of the way
  that LVM organises its disk extents. This is also true for proprietary
  software: in general the commercial products such as Partition-Magic or
  Norton-Ghost don't support LVM. You have to use the standard linux
  administration tools instead.
* **An initramfs is required to boot a Linux system installed on a Logical-Volume:**
  You won't have any problem booting if only your data are on Logical-Volumes.
  If you install the root filesystem of your linux system on a Logical-Volume,
  an initramfs with the LVM tools is required to boot. Fortunately all of the
  mainstream Linux distributions install such an initramfs anyway. But there
  are linux users who want to compile support for all the critical things in the
  kernel image (disk drivers, filesystem drivers) so that no initramfs is
  necessary to boot. In that case the linux kernel won't find the root
  filesystem because the support for LVM is implemented in userspace and not in
  the kernel. That's why the initramfs is required to mount LVM based root
  filesystems.
* **Grub1 can't boot the kernel if it is stored on an LVM volume:**
  Your kernel image and initramfs may either be on a specific /boot
  partition or they may just be in the /boot directory in your root filesystem
  where linux is installed. Anyway, at the beginning of the boot process, the
  boot manager (Grub in general) has to read the kernel image (often called
  vmlinuz) and the initramfs if there is one. The old version of Grub does not
  know how to read these files from LVM volumes. So the partition where these
  files are stored must be on a standard partition of your disk (ideally a
  /boot partition). This is not a problem any more as all major distributions
  are now using Grub2.
