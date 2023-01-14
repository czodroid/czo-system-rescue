+++
weight = 30060
title = "Repairing a damaged Grub"
draft = false
aliases = ["/Sysresccd-Partitioning-EN-Repairing-a-damaged-Grub"]
+++

## Introduction

If you have read [the previous chapter](/disk-partitioning/Grub-boot-stages/),
you know that Grub requires multiple stages to be installed correctly. They are
all installed in different locations of your hard-disk. If one of these
sectors is overwritten then Grub will stop working. Fortunately **there
are solutions to recover your linux installation** by reinstalling Grub,
and you don't have to reinstall Linux entirely.

All the administration programs required to re-enable Grub are part of
the standard Linux installations, so the main problem is to access Linux
the first time. The first solution is to start the Linux system which is
on your hard-disk by booting from SystemRescue. The second solution is
to boot from a rescue disk such as SystemRescue normally and to run
the Grub installation command from a chroot environment. These two
solutions are described below and they **should work for both Grub1
(Grub Legacy) and Grub2**.

## Why Grub may break

Grub may stop working for many reasons. Here are examples of what can
break it:

-   **installation of another operating system** on your computer: the
    installation program is likely to overwrite the boot code in the MBR
    where Grub can store its first stage.
-   **modifications of the disk partitioning**: Grub sometimes uses a
    static list of sectors to remember where the
    [next stage](/disk-partitioning/Grub-boot-stages/) is located.
    It can be installed at the beginning of a partition when
    the filesystem of that partition leaves some free space at the
    beginning (eg: ReiserFS does not use the first 64KB). If you move
    that partition, then the sectors where Grub is installed will move
    with it, and the bad sectors will be referenced.
-   **disk cloning**: you may want to clone your partitions to another
    disk or another computer for some reason. If you just clone the
    partitions of the disks, the sectors where Grub is installed may not
    be copied (eg: sectors before the first partition, or MBR).
-   **modification of the boot priority of the hard-disks**: If you have
    multiple hard-disks you can specify which one you want to boot from
    in the BIOS settings. In general Grub is installed on only one disk,
    so it will stop working if the BIOS tries to boot from another disk.

## Identification of the boot and root filesystems

To repair Grub, you may need to know the name of the boot and root
partitions where Linux is installed. If you have many partitions on your
disk you may not remember which one it is. You can run
`fsarchiver probe simple` or `fsarchiver probe detailed` from
SystemRescue to show the list of filesystems of your computer. Here is
an example:

    root@sysresccd /root % fsarchiver probe simple
    [=====DEVICE=====] [==FILESYS==] [=====LABEL=====] [====SIZE====] [MAJ] [MIN]
    [/dev/sda1       ] [ext3       ] [boot           ] [   256.00 MB] [  8] [  1]
    [/dev/sda2       ] [reiserfs   ] [debian         ] [    16.00 GB] [  8] [  2]
    [/dev/sda3       ] [ntfs       ] [winxp32        ] [    16.00 GB] [  8] [  3]
    [/dev/sda4       ] [ext3       ] [data           ] [   898.56 GB] [  8] [  4]

There we can see that `/dev/sda1` is the boot partition, and `/dev/sda2`
is the root filesystem for Linux-Debian. This is obvious because the
labels are appropriate, but it's not always that simple. All linux root
filesystems are supposed to have their init program in `/sbin/init`. You
can check that Linux is installed on a partition by checking if that
file exists:

    root@sysresccd /root % mkdir -p /mnt/linux
    root@sysresccd /root % mount -r /dev/sda2 /mnt/linux
    root@sysresccd /root % ls -l /mnt/linux/sbin/init
    -rwxr-xr-x 1 root root 37384 2008-08-12 15:20 /mnt/linux/sbin/init
    root@sysresccd /root % umount /mnt/linux

The `/boot` directory is where the linux kernel image (vmlinuz) and the
associated initramfs (initrd) and grub files are installed. This
directory is either part of the root filesystem or on a separate
partition. You can identify the boot partition because it's quite small
in general (between 50MB and 300MB), and it's often the first partition
of the hard drive. You can mount the boot partition and check that it
contains the files we expect (vmlinuz and initrd):

    root@sysresccd /root % mkdir -p /mnt/boot
    root@sysresccd /root % mount -r /dev/sda1 /mnt/boot
    root@sysresccd /root % ls -l /mnt/boot
    lrwxrwxrwx 1 root root        1 2008-08-05 22:46 boot -> .
    -rw-r--r-- 1 root root    98203 2009-10-27 10:05 config-2.6.30-bpo.2-amd64
    drwxr-xr-x 2 root root     2800 2009-11-12 19:38 grub
    -rw-r--r-- 1 root root  8198587 2009-11-08 14:59 initrd.img-2.6.30-bpo.2-amd64
    drwx------ 2 root root       48 2006-11-25 15:55 lost+found
    -rw-r--r-- 1 root root  1508757 2009-10-27 10:05 System.map-2.6.30-bpo.2-amd64
    -rw-r--r-- 1 root root  2224064 2009-10-27 10:04 vmlinuz-2.6.30-bpo.2-amd64
    root@sysresccd /root % umount /mnt/boot

## Solution 1: Booting your Linux installation from SystemRescue

SystemRescue allows you to boot a Linux system installed on the disk
even if grub is broken. You have to boot SystemRescue either from the
cdrom, [usb stick](/Installing-SystemRescue-on-a-USB-memory-stick/)
or [the network](/manual/PXE_network_booting/).
The purpose is to just have access to your system so that you can
reinstall Grub from your original Linux installation.

When the first screen shows up (with the ACSII-art logo), you will have
to boot with specific [boot options](/manual/Booting_SystemRescue/) so that it
starts the system which is installed on the disk. The
[`root=/dev/xxx`](/manual/Booting_a_broken_linux_system_on_the_hard_disk/)
option can be used either with the name of the root partition of your
Linux installation, or with `auto`. In the first case (eg:
`rescuecd root=/dev/sda2`) the SystemRescue initialization script will
mount the specified partition. If you type `rescuecd root=auto` then
SystemRescue will use the first valid root partition where a Linux
installation has been detected.

If your Linux system uses 64bit binaries, you have to use a
64bit kernel, so the complete command can be something like `rescue64 root=auto`
if you want SystemRescue to find and boot the first valid 64bit installation of
Linux. You can use a 64bit kernel even if you have a 32bit installation
of Linux, as long as your hardware supports 64bit programs (which is the
case for all the recent Intel & AMD processors).

Your Linux system should then boot using the kernel from SystemRescue.
the consequence is that it may complain about missing kernel modules
(`No such file or directory` errors). This is because each specific
kernel version has its own kernel modules, and the linux distribution
you have installed does not provide the modules of that particular
kernel. It should not be a problem since all the filesystems and disk
drivers should be loaded at that stage. This is all you need to
reinstall Grub.

Once you have access to your system, you have to get a shell to run
commands. You have to identify the name of the disk where Grub has to be
installed. In general, it will be `/dev/sda`. If you have more than one
disk, it may also be `/dev/sdb`, `/dev/sdc`, ... You can use
`fsarchiver probe simple` to get the list of the partitions, and then
you can guess the name of the disk. Here is an example of a computer
with two disks (`/dev/sda` and `/dev/sdb`):

    root@debian /root % fsarchiver probe simple
    [=====DEVICE=====] [==FILESYS==] [=====LABEL=====] [====SIZE====] [MAJ] [MIN]
    [/dev/sda1       ] [ext3       ] [boot           ] [   256.00 MB] [  8] [  1]
    [/dev/sda2       ] [reiserfs   ] [debian         ] [    16.00 GB] [  8] [  2]
    [/dev/sda3       ] [ntfs       ] [winxp32        ] [    16.00 GB] [  8] [  3]
    [/dev/sda4       ] [ext3       ] [data           ] [   898.56 GB] [  8] [  4]
    [/dev/sdb1       ] [ext3       ] [boot           ] [   976.55 MB] [  8] [ 17]
    [/dev/sdb2       ] [reiserfs   ] [gentoo         ] [    16.00 GB] [  8] [ 18]
    [/dev/sdb3       ] [LVM2_member] [<unknown>      ] [   866.56 GB] [  8] [ 19]

Then you can use `grub-install` with the name of the disk where it has
to be installed. Here is what you can expect:

    root@debian /root % grub-install /dev/sda
    Installation finished. No error reported.
    This is the contents of the device map /boot/grub/device.map.
    Check if this is correct or not. If any of the lines is incorrect,
    fix it and re-run the script grub-install.
    (hd0)   /dev/sda

Grub should now be fixed on your disk, and you can reboot your computer.

## Solution 2: Reinstallation of Grub using chroot

The second option is to repair Grub by running `grub-install` another
way. The command we are using is still part of your Linux installation.
The difference is that we will start SystemRescue normally, and we
will access your Linux installation from chroot. The first thing to do
is to start SystemRescue normally. You just have to boot with a
64bit kernel (eg: `rescue64` or `raltker64`) if your Linux
installation is based on 64bit binaries.

Next, you can run `fsarchiver probe simple` to identify your boot and
root filesystems (see the section about detection of the boot and root
filesystems).

    root@sysresccd /root % fsarchiver probe simple
    [=====DEVICE=====] [==FILESYS==] [=====LABEL=====] [====SIZE====] [MAJ] [MIN]
    [/dev/sda1       ] [ext3       ] [/boot          ] [   196.08 MB] [  8] [  1]
    [/dev/sda2       ] [ext3       ] [fedora11       ] [     6.05 GB] [  8] [  2]
    [/dev/sda3       ] [ext3       ] [data           ] [     2.07 GB] [  8] [  3]

Now you have to mount the partition that contains the root filesystem.
In that example `/dev/sda2` is the partition where Fedora-Linux is
installed. You also have to mount the `proc`, `dev` and `sys` virtual
filesystems this way:

    root@sysresccd /root % mkdir /mnt/linux
    root@sysresccd /root % mount /dev/sda2 /mnt/linux
    root@sysresccd /root % mount -o bind /proc /mnt/linux/proc
    root@sysresccd /root % mount -o bind /dev /mnt/linux/dev
    root@sysresccd /root % mount -o bind /sys /mnt/linux/sys

The `mount -o bind` command makes something that looks like a symbolic
link. For instance the directory `/mnt/linux/proc` is an access to the
real primary directory which is `/proc`

Now we have to `chroot` to `/mnt/linux`. **Chroot is a very powerful
command: it gives the programs the illusion that the root of the system
is `/mnt/linux`**. This means that each time a program reads a file such
as `/bin/ls` it will use `/mnt/linux/bin/ls` instead. Chroot is required
because we want to execute commands from the Linux installation from the
disk, as if it was the current root. **Chroot only has an effect on the
current shell** and on all the commands that you will run from that
shell. In has no effect on the other programs which are already running
from SystemRescue.

    root@sysresccd /root % chroot /mnt/linux /bin/bash

If the contents of `/boot` is on a separate partition (if `/boot` is
currently empty) you have to mount it:

    [root@sysresccd /]# ls -l /boot/
    total 0
    [root@sysresccd /]# mount /dev/sda1 /boot/
    [root@sysresccd /]# ls -l /boot/
    -rw-r--r--. 1 root root   97567 2009-05-27 22:25 config-2.6.29.4-167.fc11.i586
    drwxr-xr-x. 2 root root    1024 2009-11-14 18:57 grub
    -rw-------. 1 root root 2944107 2009-06-14 11:08 initrd-2.6.29.4-167.fc11.i586.img
    -rw-r--r--. 1 root root 1257178 2009-05-27 22:25 System.map-2.6.29.4-167.fc11.i586
    -rwxr-xr-x. 1 root root 3035056 2009-05-27 22:25 vmlinuz-2.6.29.4-167.fc11.i586

Now you can run `grub-install` to repair Grub. The first argument it
takes is the name of the disk where to reinstall Grub. See the previous
section for more details.

    [root@sysresccd /]# grub-install /dev/sda
    Installation finished. No error reported.
    This is the contents of the device map /boot/grub/device.map.
    Check if this is correct or not. If any of the lines is incorrect,
    fix it and re-run the script `grub-install'.
    # this device map was generated by anaconda
    (hd0)     /dev/sda

Once Grub has been reinstalled, you can type `exit` to leave the chroot
environment.

    [root@sysresccd /]# exit
    exit

Then unmount all the filesystems properly:

    root@sysresccd /root % umount /mnt/linux/{dev,proc,sys}
    root@sysresccd /root % umount /mnt/linux/boot
    root@sysresccd /root % umount /mnt/linux/

You can now reboot your computer, Grub should work.
