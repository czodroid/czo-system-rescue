+++
weight = 20000
title = "Logical Volume Manager Guide"
draft = false
aliases = ["/Sysresccd-Guide-EN-LVM2"]
+++

LVM is a **Logical Volume Manager** for Linux. It offers a management of the
disk space which is more **flexible** and less limited than the standard disk
partitioning based on primary and logical partitions. LVM is supported by all
major Linux distributions, and it's even used by default on Fedora and RHEL.

This documentation has been written for multiple reasons: it will quickly tell
you the basics if you have never heard of it before in the first chapter. It
also gives you an idea of **whether or not LVM is good for you**. The second
chapter explains more about **how LVM actually works** so that you know what it
can do and **how to fix problems** related to LVM. The next chapters explain how
the **Linux boot process** works when LVM is used for the root filesystem. The
fifth chapter explains how to make **reliable backups using LVM snapshots**.

* [LVM: Overview of the logical volume manager](/lvm-guide-en/Overview-of-the-logical-volume-manager/)
* [LVM: How the logical volume manager works](/lvm-guide-en/How-the-logical-volume-manager-works/)
* [LVM: Booting linux from LVM volumes](/lvm-guide-en/Booting-linux-from-LVM-volumes/)
* [LVM: Moving the linux rootfs to an LVM volume](/lvm-guide-en/Moving-the-linux-rootfs-to-an-LVM-volume/)
* [LVM: Making consistent backups with LVM](/lvm-guide-en/Making-consistent-backups-with-LVM/)
