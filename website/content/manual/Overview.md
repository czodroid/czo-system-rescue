+++
title = "SystemRescue Overview"
draft = false
aliases = ["/Sysresccd-manual-en_Overview"]
+++

## Description
SystemRescue is a Linux system available on a bootable CD-ROM that allows you
to repair your system and your data after a crash. It also aims to provide an
easy way to do administrative tasks on your computer, such as creating and
editing the partitions of the hard disk. It contains a lot of system utilities
(parted, fsarchiver, file system tools, ...) and basic ones (editors, midnight
commander, network tools). It aims to be very easy to use: just boot from the
boot media, and you can do everything. The kernel of the system supports most
important file systems (ext3, ext4, xfs, btrfs, reiserfs, vfat, ntfs, iso9660),
and network ones (samba and nfs).

You can use SystemRescue for many tasks:

* The first time you use the computer, when no operating system is installed.
  The first task is creating partitions on the hard disk, and installing the
  operating system. With this CD-ROM, you can make partitions easily with the
  graphical partition tool GParted, and you can install Gentoo Linux.
* After a crash, or a mistake, you may have problems booting. For example, after
  installing Windows, your boot loader (LILO, Grub) may have been erased from the
  MBR. With this CD-ROM, you have all you need for reinstalling Grub or Lilo.
* For windows users that do not have Linux installed, it provides a tiny Linux
  System with most important system tools. For example, Windows users can backup
  their windows system partition using Linux tools.

## Contents

Here is a short list that describes what you will find on this rescue system:

* A recent Linux kernel, that supports most important file systems, and the most
  important hardware. Supported file systems include: ext3, ext4, xfs, reiserfs,
  fat16, fat32, jfs, ntfs. The kernel supports NFS and Samba.
* Graphical partition tools, that aim to be free partition-magic clones for
  Linux. You can use GParted.
* Most important console system tools for Linux. Of course, you have GNU Parted
  (partition editor), Partimage or FSArchiver (drive image clone) for backing up
  partitions to an image file, File system tools (e2fsprogs for ext4, xfsprogs,
  reiserfsprogs for reiserFS, jfsutils, dosfstools for FAT,
  ntfsprogs for NTFS. You can use dump/restore for backing up an ext4 partition.
* ntfs-3g (third generation of the NTFS driver) provides a full read-write
  support for NTFS partitions from Linux.
* Usual tools for Linux users: tar/gzip/bzip2 for archiving files. The same
  tools for Windows users: zip/unzip, p7zip are provided. This means
  that you are able to backup/restore your windows data. We have added DAR
  (Disk Archiver). This is a program like tar, but more powerful
* Midnight-Commander (type ```mc``` on the console command line) is a free
  Norton-Commander clone for Linux. With mc, it is easy to browse, copy, move,
  edit all files on your computer. If you don't know all the Linux shell
  commands well, you can start with mc.
* You can use basic web browsers to get some documentation while you are working
  from the rescue environment.
* Of course, editors are important when you have problems. Nano (easy editor),
  vim (vi improved) and qemacs (emacs clone) are provided for the text mode.
* The XFCE graphical desktop environment allow you to use graphical programs
  such as GParted and graphical text editors such as Geany.
