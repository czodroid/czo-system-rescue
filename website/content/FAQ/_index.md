+++
weight = 2100
title = "Frequently Asked Questions"
nameInMenu = "FAQ"
draft = false
+++

## When is SystemRescue going to support ZFS
ZFS will not be included because of its licence. If it was just a technical matter
it would already be included. The legal stuff is a gray area. Some people say it could
be distributed, some other people say it cannot. Hence we are not going to take any
legal risk. With the [customization script](/scripts/sysrescue-customize/) and 
[SystemRescueModule (SRM)](/Modules/) it should be easier for users who really need
zfs to create a custom ISO which includes the zfs dkms kernel module and tools.

## Why is SystemRescue not able to automatically mount file systems
Most regular desktop distributions are able to automatically mount file systems,
including from removable devices, in order to make the access to your data easy.
but SystemRescue does not auto mount file systems in such a way, and there is a
good reason for it. SystemRescue can be used to perform physical copies of disks
or partitions at a block level using tools such as `dd`. It is essential that
file systems on these devices are not mounted when this happens. If file systems
were mounted automatically, these could cause these file systems to be accessed
unintentionally while such operations are being performed, which is harmful.
If data on a device are accessed by both the file system and by a tool such as `dd`,
it is very likely to cause corruptions on the device, or on the copy of the device.

See the [mountall script](/scripts/mountall/) for a convenient alternative to auto
mounting.
