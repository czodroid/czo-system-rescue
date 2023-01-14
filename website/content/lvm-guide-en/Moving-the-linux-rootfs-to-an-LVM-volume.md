+++
weight = 20040
title = "Moving a Linux root filesystem to LVM"
draft = false
aliases = ["/Sysresccd-LVM-EN-Moving-the-linux-rootfs-to-an-LVM-volume"]
+++

## About
Many linux users install the root filesystem on a standard partition. If this is
the case with you, it may be possible to copy the root filesystem onto an LVM
Logical-Volume by hand, and to modify the boot loader configuration file (eg:
`/boot/grub.conf` for Grub) so that it now boots from the LVM volume. This
procedure has been tested with Debian Lenny, and it's likely to work for other
distributions.

You will need enough space on your disk to have both the old root partition and
the new LVM volume at the same time. If you don't have enough space, it's also
possible to backup and restore your root filesystem instead of doing a copy. It
should work if you know what you are doing. This is a dangerous operation, so
please check that you have a recent backup first and don't do this if you don't
fully understand this procedure. It is recommended that you read the
[previous pages about LVM](/lvm-guide-en/) before reading this one.

## Checking the initramfs
Before you migrate your root filesystem to an LVM volume, you should check that
the initramfs provided by your distribution supports LVM. On some distributions,
the initramfs is configuration specific. For instance, on Fedora/Redhat, the
initramfs is created automatically by a program called `mkinitrd` each time
you install or update the kernel image. The problem is that this program only
includes the disk drivers for the hardware on which it runs, and it only includes
the LVM programs if you are using it. In that case you will have problems if you
try to reuse this linux kernel image and this initramfs on hardware which needs
different disk drivers and if you use LVM. The solution is to recreate the
initramfs with LVM support before you reboot the new root filesystem.

With Other distributions such as Debian-Lenny, the initramfs includes all the
disk drivers and it always includes the LVM programs so it should work. In that
case you can just reuse the linux -kernel-image and the initramfs as they have
already been installed in /boot.

As of version 09.10 the default installer in Ubuntu does not support LVM. You
have to install Ubuntu on a normal partition first, run commands on this system
either by booting on it or through chroot, install the lvm2 tools, update the
initramfs and then copy the filesystem to an LVM volume:

* Install Ubuntu on a normal partition (eg: `/dev/sda1`)
* Boot on the new installed system or chroot to it from SystemRescue
* Install the lvm2 tools: `apt-get install lvm2`
* Regenerate the initramfs: `update-initramfs -u -k all`
*
Then the initramfs will have LVM support and it will work when you try to use it
to boot Ubuntu from an LVM Logical-Volume.

## Copying the root filesystem to a logical volume
* Boot from a recent SystemRescue
  You can boot from the cdrom edition or a usb or from the network
* Create an LVM Physical Volume if necessary
  If you have no LVM Physical-Volume, you have to find a disk or a partition for
  it. It will need to be big enough to store the new root filesystem
* Create an LVM Volume-Group if necessary
  Create an LVM Volume-Group if you don't have one already. In this example it
  will be called `/dev/vgmain`
* Create an LVM Logical-Volume
  Create an LVM Logical-Volume which is big enough for the root filesystem.
  Let's say it's `/dev/mapper/vgmain-debian`
* Make a new filesystem on the new Logical-Volume
  You can change the type of the filesystem if you are sure that the kernel will
  support it. If you are not sure which filesystems are supported by your
  distribution, you should keep the same one, it's ext3 in general:
  ```
  mke2fs -j -L debian /dev/mapper/vgmain-debian
  ```
* Mount both the old and the new filesystems
  ```
  mkdir -p /oldrootfs /newrootfs
  mount -r /dev/sda2 /oldrootfs
  mount /dev/mapper/vgmain-debian /newrootfs
  ```
* Copy the contents of the root filesystem to the new volume
  rsync will be used to copy all the data because it know how to preserve all
  file attributes, including the extended-attributes which are required for
  selinux to work when it's enabled. You can also use another tool such as tar
  if you know what you are doing. You can also make a copy at the block level if
  the new volume is at least as big as the old one but you may have to run
  resizefs if it's bigger. Here is how to do the copy using rsync:
  ```
  rsync -axHAX /oldrootfs/ /newrootfs/
  ```
* Update the entry for the root filesystem in the new fstab
  You have to edit ```/newrootfs/etc/fstab``` and change the entry related to
  the root filesystem so that the name of the device and the filesystem are
  correct.
* Unmount the filesystems
  ```
  cd / ; umount /oldrootfs /newrootfs
  ```

## Updating the boot loader
Now you have to mount your boot partition and edit the boot loader configuration
so that it will know from where to boot. It's recommended to preserve the
existing boot entry, just in case there is a problem with the new root
filesystem. Here is an example of a grub configuration file for Debian with
these two entries. The important thing is the the `root=xxx` boot parameter.
```
default 0
timeout 10

title Debian-Linux-2.6.26-2-amd64 [new-lvm-rootfs]
        root (hd0,0)
        kernel /vmlinuz-2.6.26-2-amd64 root=/dev/mapper/vgmain-debian ro
        initrd /initrd.img-2.6.26-2-amd64

title Debian-Linux-2.6.26-2-amd64 [old-std-rootfs]
        root (hd0,0)
        kernel /vmlinuz-2.6.26-2-amd64 root=/dev/sda2 ro
        initrd /initrd.img-2.6.26-2-amd64
```
Now you should be able to reboot on the new root filesystem.
