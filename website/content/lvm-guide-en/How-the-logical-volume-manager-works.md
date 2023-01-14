+++
weight = 20020
title = "How the Logical Volume Manager works"
draft = false
aliases = ["/Sysresccd-LVM-EN-How-the-logical-volume-manager-works"]
+++

## About
In this tutorial, we will explain more about how LVM works. It's quite important
to understand how it works to know how to use it the right way. We will also
focus on the root filesystem, which is where the main linux programs are
installed, so that you know whether or not it's appropriate for you. It is
recommended that you read the [previous pages about LVM](/lvm-guide-en/) before
reading this one.

## LVM Implementation
It's quite important to understand that **LVM is implemented in userspace** and
not in kernel space. This means that **the kernel does not know anything about
LVM**, and the implementation is just in the LVM binaries which come with the
LVM2 package. As a consequence you won't find any LVM option if you try to
recompile your Linux kernel. The other very important consequence is that **the
kernel won't be able to mount the root filesystem directly** at boot time if
it's an LVM logical volume. It requires the lvm binary, and then an initramfs is
used to boot from LVM.

## Device-Mapper
LVM is based on the **Device-Mapper** which is implemented in kernel space. The
device mapper is a block driver that establishes a mapping between logical
blocks and physical blocks. A logical block device such as an LVM Logical-Volume
is a volume as the end user can see it. The physical block device is something
like a partition of your hard-disk or your entire hard-disk. The Device-Mapper
provides a lot of flexibility with block devices. For instance, when you read
the first block of a logical volume the physical block may be located in the
middle of your disk. If you create two logical volumes, and then grow the first
volume after the second has been created, it will use disk blocks which don't
follow the blocks of the initial volume, because the Device-Mapper tells the
logical volume where to find the new disk blocks of the volume. The Device-Mapper
is not only used by LVM. It's also used by programs such as dmraid which allow
the use of RAID adapters bundled with motherboards. It's also used for encryption
at the block level for an entire filesystem, with tools such as TrueCrypt.

## LVM utilities
When LVM is started at boot time, it first reads its meta-data in the
Physical-Volumes to know how its own data are organized. Then it maps the disk
blocks using the Device-Mapper. This way the Device-Mapper knows where to find
the physical block when the user wants to read a block in a Logical-Volume.
After the mapping has been established, the LVM program is not active any more,
and only the Device-Mapper driver does all of the translations each time a block
is accessed. That's why there is no process running lvm when you work on LVM
disks. As a consequence, LVM cannot be used if the Device-Mapper is not compiled
in your kernel.

## About LVM metadata
LVM has its own way of organizing the data on your disk. Obviously it needs some
space to store information about the mapping so that it knows where the blocks
can be found on the disk when it boots the next time. All of these internal data
used by LVM are its metadata. They are stored on disk sectors that you cannot
see directly. For instance, each LVM Physical Volume has metadata blocks that
are used to store information related to how the Volume-Groups are stored on
these Physical-Volumes. Also each Volume-Group contains metadata blocks about
the Logical-Volumes which are part of a volume-Group. In other words, LVM does
not use any file to store its own internal structures, so the disk will still be
readable by LVM if you decide to erase the root filesystem where the default
Linux system is installed.
