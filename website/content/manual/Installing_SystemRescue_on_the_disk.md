+++
title = "Installing SystemRescue on the disk"
nameInMenu = "Disk install"
draft = false
aliases = ["/Sysresccd-manual-en_Easy_install_SystemRescueCd_on_harddisk",
           "/Sysresccd-manual-en_How_to_install_SystemRescueCd_on_harddisk",
           "/manual/Installing_SystemRescueCd_on_the_disk"]
+++

## Overview
This page explains how to install SystemRescue on the local disk so it can be
started without having to use a removable device. These instructions are valid
for SystemRescue since version 6.0.0.

## Introduction
There is an easy way to boot SystemRescue from the local disk. It can be
convenient if you often want to boot on SystemRescue as it will be faster and
there is no need to insert any media before you restart your computer. This
method allows to use SystemRescue as you do with the CDRom or USB version. It
also allows to boot SystemRescue if you do not have any CD/DVD drive or USB
socket in your computer. You can use another operating system to process the
installation of SystemRescue, and enable it. Thus, this method is recommended
if you often use SystemRescue and you want to avoid having to insert the
device each time.

The installation is done by copying files from the SystemRescue media to the
local filesystem where your operating system is installed. This approach does
not require any repartitioning of your disk. Using grub4dos you can even install
SystemRescue on a Windows NTFS partition. All you have to do is to install the
files that are on the SystemRescue disc to an existing partition on your local
disk, that can be either a Linux partition (ext4, xfs, ...) or a Windows one
(NTFS). That way you can boot SystemRescue from your Windows partition, and
using the `copytoram` option you can even use it to troubleshoot Windows itself
or `ntfs-3g` to work on the filesystem where it is installed.

There are two steps in this installation: first you will have to copy the main
SystemRescue files onto a partition of your disk. Then, you will have to
configure your boot loader. The installation process requires a partition with
enough space to copy SystemRescue files. You must have a working Grub2 boot
loader if you want to install the SystemRescue files on a Linux partition.

## First approach using Grub2 with isoloop

Grub2 provides a feature to boot from an ISO image which is stored on the local
disk. If you put a copy of `systemrescue-x.y.z.iso` on a filesystem that Grub2
can read then you can boot SystemRescue directly from the ISO image stored on
your disk. This is very convenient if you frequently update SystemRescue and
you want to boot it directly from Grub2.

The first step is to copy the latest SystemRescue ISO image to your disk, in a
place which is accessible from Grub. The recommended location is `/boot` as it
is normally not encrypted and hence it is accessible from Grub. It is
recommended to remove the version number form the name of ISO file so you do not
have to update the Grub configuration each time you download a new version of
the ISO image.
```
cp ~/Download/systemrescue-x.y.z.iso /boot/systemrescue.iso
```

Grub2 knows what an ISO image is and it will load the `vmlinuz` kernel image
file and the `sysresccd.img` initramfs from the ISO into memory. It will then do
its normal job and execute the kernel. Additional parameters must be passed to
SystemRescue on the boot command line so the startup script can find files.

The Grub configuration contains directives so Grub can find the ISO image and
the kernel image and initramfs within it. It also contains parameters passed to
the operating system so it can find the ISO image on the disk and important
files within the ISO image. It is important to understand that the path of the
ISO image may be different from the path on your Linux system if your `/boot`
directory is located on a separate file system (separate from the root file
system).

Here is an example of a Grub2 configuration section assuming the file system
which contains systemrescue.iso is labelled `boot`. If not please update the
values of the `--label` and `img_label` options so they match the label of the
file system which contains the ISO image file. The Grub configuration is
normally stored in a file such as `/etc/grub.d/25_sysresccd` and it needs to be
executable so the `grub-mkconfig` command can run it to produce the final grub
configuration file.

You should keep options `archisobasedir=sysresccd` as it is as this refers to
the path to files inside the ISO image. Also you should keep internal paths
`/sysresccd/boot/${arch}/` unchanged. The `copytoram` option is recommended by
not mandatory. You should then update the `setkmap` option so it matches your
keyboard layout. The following example corresponds to the 64 bit architecture
(amd64/x86_64) which is the recommended one. If you use the 32 bit version you
need to replace all instances of `x86_64` with `i686`:
```
#!/bin/sh
exec tail -n +3 $0

menuentry "SystemRescue (isoloop)" {
    load_video
    insmod gzio
    insmod part_gpt
    insmod part_msdos
    insmod ext2
    search --no-floppy --label boot --set=root
    loopback loop /systemrescue.iso
    echo   'Loading kernel ...'
    linux  (loop)/sysresccd/boot/x86_64/vmlinuz img_label=boot img_loop=/systemrescue.iso archisobasedir=sysresccd copytoram setkmap=us
    echo   'Loading initramfs ...'
    initrd (loop)/sysresccd/boot/x86_64/sysresccd.img
}
```

It is important to understand the main steps of the boot process in order to get the configuration right:
* Grub2 searches for a filesystem labelled `boot` that it considers as its root filesystem
* Grub2 searches for the ISO image `/systemrescue.iso` in the filesystem found previously
* Grub2 loads both `vmlinuz` and `sysresccd.img` from within the ISO image
* Grub2 executes the kernel image and passes the boot parameters from its configuration
* The boot process will use `img_label` to find the filesystem which contains the ISO image
* The boot processes will use option `img_loop` to find the ISO image within the filesystem
* This boot scripts mount the ISO image and boots from the squashfs filesystem image `airootfs.sfs`

If your `/boot` directory is part of the root file system (not mounted on a
separate device) you should set `img_label` so it matches the label of your root
file system, and `img_loop` should be updated so it matches the path of the ISO
file relative to the root, such as `img_loop=/boot/systemrescue.iso`

After having created the configuration file you normally have to run a command
such as `grub-mkconfig -o /boot/grub/grub.cfg` to produce the final grub
configuration. Make sure the final grub configuration contains the expected
section for SystemRescue before you reboot.

## Alternative approach involving extracting contents from the ISO image

This approach works on Linux with the Grub boot loader and it also works on
Windows with Grub4dos.

It involves copying SystemRescue main files to a filesystem on the disk and
configuring Grub or Grub4dos so it can be booted.

### First step: copy files from the ISO image to the disk
Now, mount the ISO image with `mount` under Linux
(eg: `mount -o loop systemrescue-x.y.z.iso /mnt/cdrom`) or you can use
a software such as Daemon-Tools under Windows if you did not burn the disc), in
order to have the main files.

You must copy the whole `/sysresccd/` directory from the ISO to the root folder
of the partition where this is installed. If you have a separate `/boot`
partition then this directory should be copied to `/boot/sysresccd`. You must
keep the directory structure as it is on the original ISO.

### Second step: update the boot loader configuration (if you install on Linux)
Now, you must update the boot loader. This section describe how to update
grub. If you are using an NTFS partition, please read the next section instead.

We will have to add several lines to the configuration file of the boot manager
(usually located in `/etc/grub.d/` for Grub2). You have to customize the
configuration given there.

Here is an example of Grub2 configuration. Create a new file such as
`/etc/grub.d/25_sysresccd` so its configuration is located after your
default operating system configuration. The search directive is very important
as it provides a way for grub to locate the filesystem which contains the
SystemRescue files.

In the following example the filesystem is identified using its label which is
`boot` but you can also identify the filesystem using its UUID if you prefer.
Once Grub finds the device with this label it will set it as its root
filesystem. It can be confusing as what grub considers as the root filesystem is
what Linux will consider as the boot filesystem if `/boot` is on a separate
filesystem. Paths to SystemRescue files are relative to the root of this
filesystem which may be different from the Linux path.

The `archisolabel=boot` option indicates that SystemRescue will try to find
its files on a filesystem which is labelled `boot` just as grub. The
`archisobasedir=sysresccd` options then indicates that SystemRescue needs to
search for its files in `/sysresccd` on this filesystem. The `copytoram` option
is recommended so the boot filesystem can be unmounted after the boot process is
complete, which allows you to perform changes on the disk where SystemRescue
is installed.

```
#!/bin/sh
exec tail -n +3 $0

menuentry 'SystemRescue' {
  load_video
  insmod gzio
  insmod part_gpt
  insmod part_msdos
  insmod ext2
  search --no-floppy --label boot --set=root
  echo   'Loading Linux kernel ...'
  linux  /sysresccd/boot/x86_64/vmlinuz archisobasedir=sysresccd archisolabel=boot copytoram setkmap=us
  echo   'Loading initramfs ...'
  initrd /sysresccd/boot/x86_64/sysresccd.img
}
```

After having created the configuration file you normally have to run a command
such as `grub-mkconfig -o /boot/grub/grub.cfg` to produce the final grub
configuration. Make sure the final grub configuration contains the expected
section for SystemRescue before you reboot.

### Second step: update the grub4dos bootmanager (if you install on Windows)
Now, you must update your bootmanager using grub4dos that is the grub port to
windows. This section describes how to install the grub4dos boot manager if you
installed the SystemRescue files on an NTFS partition running Windows. If you
are using a Linux partition, please read the previous section instead.

One of the most interesting things you can do with the sysresccd ntfs
installation is to troubleshoot windows when it has problems. This way you can
mount the windows partition with ntfs-3g and repair your windows (replace a
backup of the registry, ...). The only problem is you cannot mount the windows
disk read-write with ntfs-3g because it was already mounted read-only during the
boot process. The solution to this problem is to use the `copytoram` option at
boot time. When this option is enabled, sysresccd will cache its own files
(found on the ntfs disk) into memory during the boot process, and the ntfs disk
will be unmounted. So it allows you to mount it again with ntfs-3g. So you have
to add `copytoram` to the `menu.lst` boot options if you want to be able
to mount your windows disk with ntfs-3g after booting from the ntfs disk itself.

Installation is really straight forward. In this mini tutorial, I assume Windows
is installed on an NTFS disk (Disk-C) and that you copied the SystemRescue main
files into `C:\sysresccd`

You must download grub4dos, extract the zip file into a temporary directory, and
copy `grldr` to `C:\`. This installation has been tested using the `grldr` file
provided with `grub4dos-0.4.3-2007-08-27.zip` but it should work with any recent
version.

Together with `grldr` you need to copy `grldr.mbr` (part of the archive)
to the root of the Windows boot partition. Then you need to type several
commands at a command prompt (run `cmd.exe` with an administrator user account).

In the command prompt window (`C:>` is a dummy substitute for the cmd prompt)
do the following:
```
C:> bcdedit /create /d "SystemRescue [GRUB4DOS]" /application bootsector
```

You get in return the boot entry `{id}` - use it (copy/paste or type) in the following steps
```
C:> bcdedit /set {id} device boot
C:> bcdedit /set {id} path \grldr.mbr
C:> bcdedit /displayorder {id} /addlast
```

You have to create a `C:\menu.lst` that is the `grub4dos` configuration
file. Here is an example. It corresponds to the 64 bit architecture
(amd64/x86_64). If you use the 32 bit version you need to replace all instances
of `x86_64` with `i686`:
```
# This is a sample menu.lst file for SystemRescue
title    SystemRescue from the NTFS disk
root     (hd0,0)
kernel   /sysresccd/boot/x86_64/vmlinuz archisobasedir=sysresccd archisolabel=windows copytoram setkmap=us
initrd   /sysresccd/boot/x86_64/sysresccd.img
```

In `menu.lst` you will have to update `archisolabel` so it matches the label of
the NTFS filesystem which contains the `sysresccd` and also you should update
the `setkmap` parameter so the code matches your keyboard configuration. In this
example, files are located on the NTFS partition that is the first partition of
the first hard disk. Then the grub device name is `(hd0,0)`. It would be
`(hd1,0)` for the first partition of the 2nd hard-disk, `(hd0,1)` for the second
partition of the first hard-disk, ... You have to replace `root (hd0,0)` with
the grub name of your NTFS partition.
