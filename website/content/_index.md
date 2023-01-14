+++
weight = 100
title = "System Rescue Homepage"
nameInMenu = "Homepage"
draft = false
aliases = ["/SystemRescueCd_Homepage","/Main_Page"]
+++

## About SystemRescue
**Description:** SystemRescue (formerly known as SystemRescueCd) is a Linux
system rescue toolkit available as a bootable medium for administrating or
repairing your system and data after a crash. It aims to provide an easy way to
carry out admin tasks on your computer, such as creating and editing the hard
disk partitions. It comes with a lot of [Linux system utilities](/System-tools/)
such as GParted, fsarchiver, filesystem tools and basic tools (editors, midnight
commander, network tools). It can be used for both Linux
and [windows](/manual/Backup_data_from_an_unbootable_windows_computer/)
computers, and on desktops as well as servers. This rescue system requires no
installation as it can be booted from a CD/DVD drive or
[USB stick](/Installing-SystemRescue-on-a-USB-memory-stick/), but it can be
[installed on the hard disk](/manual/Installing_SystemRescue_on_the_disk/)
if you wish. The kernel supports all important file systems (ext4, xfs, btrfs,
vfat, ntfs), as well as network filesystems such as Samba and NFS.

## System and Networking Guides
In addition to the [Quick Start Guide](/Quick_start_guide/)
and [SystemRescue documentation](/manual/) here are other guides:

* **[Disk Partitioning](/disk-partitioning/)**:
  [Introduction](/disk-partitioning/Introduction-to-disk-partitioning/),
  [Attributes](/disk-partitioning/Partitions-attributes/),
  [Tools](/disk-partitioning/Standard-partitioning-tools/),
  [GPT Disks](/disk-partitioning/The-new-GPT-disk-layout/),
  [How Grub boots](/disk-partitioning/Grub-boot-stages/),
  [How to repair Grub](/disk-partitioning/Repairing-a-damaged-Grub/)
* **[LVM Volume-Manager](/lvm-guide-en/)**:
  [Overview](/lvm-guide-en/Overview-of-the-logical-volume-manager/),
  [How it works](/lvm-guide-en/How-the-logical-volume-manager-works/),
  [Booting](/lvm-guide-en/Booting-linux-from-LVM-volumes/),
  [Rootfs on LVM](/lvm-guide-en/Moving-the-linux-rootfs-to-an-LVM-volume/),
  [Snapshots and Backups](/lvm-guide-en/Making-consistent-backups-with-LVM/)

## Project documentation
This project comes with good [documentation](/manual/). Here are the most important pages:

### For the impatient:
* [Quick start guide](/Quick_start_guide/): please read this if this is the
first time you are using this system recovery cd.

### Chapters about basic usage:
* [Overview of the livecd](/manual/Overview/)
* [Downloading and burning](/manual/Downloading_and_burning/)
* [How to install SystemRescue on an USB-stick](/Installing-SystemRescue-on-a-USB-memory-stick/)
* [Booting SystemRescue (boot options)](/manual/Booting_SystemRescue/)
* [Starting to use the system](/manual/Starting_to_use_the_system/)
* [Network: configuration and programs](/manual/Network_configuration_and_programs/)
* [Mounting an NTFS partition with full Read-Write support](/manual/Mounting_ntfs_filesystems/)

### Chapters about advanced usage:
* [Installing SystemRescue on the disk](/manual/Installing_SystemRescue_on_the_disk/)
* [Installing additional software packages with pacman](/manual/Installing_packages_with_pacman/)
* [Configuring SystemRescue with YAML files](/manual/Configuring_SystemRescue/)
* [Creating a backing-store to keep your modifications](/manual/Creating_a_backing_store/)
* [PXE network booting with SystemRescue](/manual/PXE_network_booting/)
* [Run your own scripts at start-up with autorun](/manual/Run_your_own_scripts_with_autorun/)
* [Secure Deletion of Data](/manual/Secure_Deletion_of_Data/)
* [Backup data from an unbootable Windows computer](/manual/Backup_data_from_an_unbootable_windows_computer/)
* [Backup and transfer your data using rsync](/manual/Backup_and_transfer_your_data_using_rsync/)

## System tools included
* [**GNU Parted**](http://www.gnu.org/software/parted/): creates, resizes, moves, copies partitions, and filesystems (and more).
* [**GParted**](http://gparted.org/):  GUI implementation using the GNU Parted library.
* [**FSArchiver**](http://www.fsarchiver.org/): flexible archiver that can be used as both system and data recovery software
* [**ddrescue**](http://www.gnu.org/software/ddrescue/) : Attempts to make a copy of a block device that has hardware errors, optionally filling corresponding bad spots in input with user defined pattern in the copy.
* **File systems tools** (for Linux and Windows filesystems): format, resize, and debug an existing partition of a hard disk
* [**Ntfs3g**](/manual/Mounting_ntfs_filesystems/): enables read/write access to MS Windows NTFS partitions.
* [**Test-disk**](http://www.cgsecurity.org/wiki/TestDisk) : tool to check and undelete partition, supports reiserfs, ntfs, fat32, ext3/ext4 and many others
* [**Memtest**](https://www.memtest.org/): to test the memory of your computer (first thing to test when you have a crash or unexpected problems)
* [**Rsync**](/manual/Backup_and_transfer_your_data_using_rsync/): very-efficient and reliable program that can be used for remote backups.
* **Network tools** (Samba, NFS, ping, nslookup, ...): to backup your data across the network

Browse the [short system tools page](/System-tools/) for more details about the most important software included.

Browse the [detailed package list](/Detailed-packages-list/) for a full list of the packages.

**It is possible to make custom versions of the system.**
For example, you can add your own scripts, make an automatic restoration of the
system. It is also possible to create custom versions of SystemRescue.

**You can use SystemRescue to [backup data from an unbootable Windows computer](/manual/Backup_data_from_an_unbootable_windows_computer/)**, if you
want to backup the data stored on a Windows computer that cannot boot any more.

**It is very easy to [install SystemRescue on a USB stick](/Installing-SystemRescue-on-a-USB-memory-stick/)**. That is very useful in
case you cannot boot from the CD/DVD drive. You just have to copy several files to
the stick and run syslinux. The install process can be done from Linux or
Windows. Follow instructions from the [manual](/manual/) for more details.

## More information about this project
SystemRescue sources can be found on
[GitLab](https://gitlab.com/systemrescue/systemrescue-sources) and these are
licensed under the [GPLv3](https://opensource.org/licenses/GPL-3.0) license.
