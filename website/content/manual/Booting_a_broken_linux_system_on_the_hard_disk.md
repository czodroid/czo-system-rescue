+++
title = "Booting a broken Linux system"
draft = false
+++

Sometimes, we may have problem to boot the Linux system that is installed on the
disk. For instance, after some administration tasks, or after installing an
operating system on your hard disk, you may loose the ability to boot Linux because
**another system may have overwritten the MBR or replaced the boot loader**.
In these cases it is useful to use SystemRescue to boot the existing Linux system
that is already installed on the disk. And once this system is running you will
be able to [repair the boot loader](/disk-partitioning/Repairing-a-damaged-Grub/).

Since SystemRescue version 6.1.4, it supports the `findroot` parameter on the
boot command line. You can use it by either typing this parameter on the boot
command line, or by selecting **Boot from a Linux operating system installed on the disk**
in the pre-defined SystemRescue boot menu. When you boot SystemRescue with this
option enabled, it will try to find and start any Linux operating system which
is installed on the disk. This supports Linux operating systems installed on
ordinary file systems, including LVM disk, and dm-crypt encrypted disk. If
multiple systems are found, it will show a menu to let you choose which one you
want to start.

Once you have managed to start your Linux operating system, you will be able to
use various command to repair the system. It includes commands to reinstall the
boot loader on the disk, to upgrade or replace packages, or to update configuration
files.
