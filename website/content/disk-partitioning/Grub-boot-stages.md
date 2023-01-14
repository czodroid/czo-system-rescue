+++
weight = 30050
title = "Grub boot stages"
draft = false
aliases = ["/Sysresccd-Partitioning-EN-Grub-boot-stages"]
+++

## About Grub

Grub is the default boot manager on Linux. This program runs early in
the boot process, before the linux kernel starts. Grub is installed
automatically by Linux installers. It's a very particular program, and
you may break it if you make modifications to your system. The problem
is it's quite difficult to repair a broken Grub installation without
understanding how it works. For that reason, it's quite important to
have a look at Grub in detail. After having read this chapter, you
should be able to repair and reinstall Grub on your box, and you should
also be able to make better decisions at installation.

There are currently two Grub versions: **Grub1** which is also known as
**Grub Legacy** (versions 0.9x) is still the default on most of the
Linux distributions. It works well, but it's not maintained any more, so
each Linux distribution has a particular Grub1 version with their own
modifications. Grub2 is only available as pre-versions (1.96, 1.97, ...)
but it's already usable. It has a better design and provides more
flexibility. It's under heavy development, and it's already used by
Ubuntu-09.10 for new installations.

Fortunately most of the concepts are common to these two versions, so it
won't be difficult to understand how Grub2 works if you are familiar
with Grub1. This documentation will focus on giving you enough knowledge
so that you can install and repair Grub configurations.

## The boot managers

Grub is the default boot manager for Linux, but it's also used to boot
other operating systems such as Open-Solaris. What Grub has to do is to
**load the linux kernel and (the associated initramdisk if necessary)
into memory** so that the kernel can start. These two files are usually
called `vmlinuz` and `initrd`, and they are stored on a linux filesystem
(either on the root or on the boot filesystem in general). The problem
is that the normal programs use the services of the operating system to
read a file from a filesystem. At this stage Grub cannot use it because
Linux has not yet started.

Other boot managers such as Lilo read these files using a static list of
sectors that correspond to the sectors where these files are stored.
This map is created at installation time by the lilo command when the
operating system is available. The problem with this static map is that
the boot loader is not flexible and it stops working if the physical
locations of the files on the disk are modified.

Grub is a lot more flexible. It is able to read files from filesystems
such as fat, ntfs, ext3, reiserfs. Then it can read the linux kernel
image and its initrd even when files are modified on the disk. This
flexibility has a cost: grub is bigger and multiple steps are necessary
for grub to be executed. These three steps are called `stage-1`,
`stage-1.5` and `stage-2`. Also the `stage-1.5` may not be used with
Grub1. In that case `stage1` will directly load `stage2`. For simplicity
`stage-1.5` it has been completely removed from Grub2.

You can see these stages if you look at the the files you have in /boot/grub:
```
root@debian % ls -l /boot/grub
-rw-r--r-- 1 root root     63 2009-08-16 10:45 device.map
-rw-r--r-- 1 root root  13844 2009-08-16 10:45 e2fs_stage1_5
-rw-r--r-- 1 root root  13608 2009-08-16 10:45 fat_stage1_5
-rw-r--r-- 1 root root  12920 2009-08-16 10:45 ffs_stage1_5
-rw------- 1 root root    637 2009-08-16 10:45 grub.conf
-rw-r--r-- 1 root root  12920 2009-08-16 10:45 iso9660_stage1_5
-rw-r--r-- 1 root root  14488 2009-08-16 10:45 jfs_stage1_5
lrwxrwxrwx 1 root root     11 2009-08-16 10:45 menu.lst -> ./grub.conf
-rw-r--r-- 1 root root  13056 2009-08-16 10:45 minix_stage1_5
-rw-r--r-- 1 root root  15656 2009-08-16 10:45 reiserfs_stage1_5
-rw-r--r-- 1 root root  98743 2009-04-17 19:19 splash.xpm.gz
-rw-r--r-- 1 root root    512 2009-08-16 10:45 stage1
-rw-r--r-- 1 root root 122108 2009-08-16 10:45 stage2
-rw-r--r-- 1 root root  13196 2009-08-16 10:45 ufs2_stage1_5
-rw-r--r-- 1 root root  12500 2009-08-16 10:45 vstafs_stage1_5
-rw-r--r-- 1 root root  15172 2009-08-16 10:45 xfs_stage1_5
```

## Description of the three stages

The boot process on traditional PC computers has to cope with the
limitations of the BIOS. The BIOS knows how to work with hard disks
having a valid Master-Boot-Record (MBR). This is the first sector of a
disk (512 bytes), and it's used to store both the partition table (which
can contains up to 4 entries) and the initialization code. If no
initialization code is present in the MBR, the BIOS will execute the
code stored on the first sector of the partition which is marked as
`active`. That's why Windows has to be installed on the active primary
partition if you want it to start.

In general, Grub uses 440 bytes reserved for the initialization code of
the MBR to start. The problem is this code area is very small, and Grub
does complex things that cannot fit into 440 bytes. That's why Grub is
made of multiple stages: the first stage is very small. All it does is
that it loads the first sector of the next stage (either stage-1.5 or
stage2, and it executes the instructions it contains, which loads the
stage entirely into memory.

**If stage-1.5 is present, it implements support for reading files from
the filesystem** where stage2 is stored. Then stage2 can be stored as a
normal file, and it is read dynamically. Then stage2 can be moved or
modified because grub understands how the data of those files are
organized in a filesystem. Grub comes with multiple possible versions of
the stage-1.5, one version for each supported filesystem. In the end
only one version will be installed: the version that corresponds to the
filesystem of the partition where the stage2 is stored.

**If there is no stage-1.5, then stage1 directly loads stage2** using a
static list of sectors where stage2 is stored. This block list is
created at installation time. The problem is that it will stop working
if stage2 is moved to another location.

**The stage2 is the biggest** and the most important part of grub.
Stage2 contains the entire code that provides support for all the
filesystems, it can display the boot menu and offer many features used
to boot an operating system. It's intelligent enough to read any file
from the supported filesystems. That's very important, because the
stage2 will have to load the linux kernel image (vmlinuz) and the
initramdisk (initrd) to boot linux.

It's important to differentiate the **two ways that Grub can read a file
from the disk**. In the first method Grub uses a static list of sectors,
which depends on your particular configuration. This list is created at
installation, just after the files have been copied to your disk. A file
may be fragmented on the disk so we can't just store the number of the
first sector of the file. The second method is to read the file
dynamically by understanding the structure of the filesystem where it's
stored. This is only possible after the stage-1.5 or the stage2 has been
loaded.

## Where the stages are located

The various Grub stages can be stored in multiples places on the disk:
they can be copied into the MBR, or into the boot sector of a partition,
or into a space which has not been allocated to partitions, or into an
unused area of a partition, as a normal file, or onto a dedicated
partition. When stage-1.5 is present, stage2 will be stored as a normal
file which is read dynamically. In the other cases the stage will be
stored at a static location. The best place will be on sectors which are
not supposed to move in the future, or to be overwritten by something
else.

Stage1 can only be stored either on the MBR or in the boot sector of a
partition, because that's the only places that can be directly executed
by the BIOS.

Stage-1.5 can be stored at multiple locations: if stage1 is in the MBR,
stage-1.5 is likely to be written in the sectors which are between the
MBR (first sector) and the first partitions. For geometry reasons, the
first partition does not start on the second sector just after the MBR.
Then it leaves few Kilo-Bytes where stage-1.5 can fit entirely.
Unfortunately stage2 is too big to fit there except if the administrator
decided not to create the first partition at the very beginning.
Stage-1.5 can also be installed on the first sectors of a partition, if
the filesystem leaves some free space at the beginning. For instance,
reiserfs starts at offset 65536 of a partition, which leaves 64
Kilo-Bytes for that sort of thing.

Stage2 is the biggest of the three stages. If there is a stage-1.5, then
stage2 is just a normal file on the boot or root filesystem. If stage2
is directly loaded by stage1 then it's read using a static list of
sectors created during the installation. Stage2 can be installed before
the first partition of the disk if there is enough space for it. It can
also be installed on a dedicated partition if your disk is based on the
[GPT partition table](/disk-partitioning/The-new-GPT-disk-layout/). This
partition should ideally be the first one, and it reserves some space
for the boot manager. That way nothing else can overwrite its data, and
Grub should not stop working as long as you don't modify this partition.
