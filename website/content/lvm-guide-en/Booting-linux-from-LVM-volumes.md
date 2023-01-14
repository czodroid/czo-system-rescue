+++
weight = 20030
title = "Booting Linux from LVM Volumes"
draft = false
aliases = ["/Sysresccd-LVM-EN-Booting-linux-from-LVM-volumes"]
+++

## About
In this tutorial, we will explain the Linux boot process in general, and how it
works when Linux is installed on an LVM volume. It's recommended to read the
previous chapter about LVM if you are not already familiar with LVM. This
section will also give you a good understanding of the Linux boot process in
general even if you don't use LVM, so it's worth reading. It is recommended that
you read the [previous pages about LVM](/lvm-guide-en/) before reading this one.

## Booting from an LVM Root filesystem
Many linux distributions such as Redhat/Fedora allow you to install the root
filesystem on an LVM Logical Volume. This way you get the flexibility of LVM for
this filesystem and not just for the data. The down side is that the boot
procedure is a bit more complex, and you need to understand how its boots so
that you are able to fix it in case of problems.

Booting using a root filesystem located on an LVM Logical Volume is more
complicated because the kernel does not know anything about LVM. So it needs the
LVM binary to mount the root filesystem. But the LVM binary is installed on the
root filesystem that we want to mount... The solution to this egg and chicken
problem is to boot with an initramfs. This is a compressed archive that contains
all the kernel modules and programs that are required to mount the root
filesystem at boot time. In general, it's located in `/boot`, and it is
called `initramfs-x.y.z.gz`. The other important file is the linux kernel
image which is called `vmlinuz-x.y.z`.

## Here are the important steps involved in booting from LVM:
* The BIOS executes the boot loader which is very often Grub
* The boot loader has its own code for reading partitions and filesystems. So it
  knows how to read files from the /boot partition which contains the linux
  kernel image (vmlinuz-x.y.z) and the initramfs (initrd-x.y.z.gz). It first
  loads these two files into memory. Then it executes the kernel image and it
  tells the kernel where the initramfs is located in memory. The boot command
  line is also passed to the kernel. This command line contains the important
  parameters for the kernel such as `root=/dev/volgroup/lvroot`.
* The linux kernel starts and executes its initialization code. Then it reads
  the initramfs from the memory. The contents is uncompressed into a new
  location in the memory.
* The contents of the initramfs is now available. The program/script called init
  is now executed. This script which is specific to each linux distribution is
  responsible for finding the root filesystem.
* If the LVM Physical Volumes are stored on the top of a RAID disk, the init
  program will first execute dmraid/mdadm to make this raid disk available.
* Then the init script will run programs such as pvscan/vgscan/lvscan to detect
  the LVM volumes located on the disks
* The LVM volumes are not usable yet. They have to be activated first. This is
  done by `vgchange --available y` or `vgchange -ay`.
* The init script reads the virtual file called `/proc/cmdline` to see what
  is the name of the root filesystem specified on the boot command line.
* The root filesystem is mounted in a temporary directory such as `/rootfs`
  and other things such as `/rootfs/proc` and `/rootfs/dev` may also be
  mounted.
* The initscript executes a chroot to `/rootfs`. This means that this
  directory becomes the new root for the processes which will be executed. When
  a process reads `/bin/something` it will read `/rootfs/bin/something`
  in reality.
* The secondary init program, the one which is stored on the root filesystem is
  now executed and it finishes the initialization with an access to the real
  root filesystem.

## Distributions and rootfs on LVM
* All mainstream Linux distributions now support LVM2. But the installation
  program may not allow you to install the Linux rootfs onto an LVM Logical Volume.
  * **Redhat + Fedora + CentOS**, anaconda (the installation program) install
    the root filesystem on LVM by default, but you can change it.
  * **Gentoo:** since the default installation method is to install it by hand,
    you can directly install Gentoo on LVM if you know what you are doing
  * **Ubuntu:** as of version 09.04, the installation program does not support
    LVM, but you can probably migrate the root filesystem after installation.

There are good reasons for using LVM for the root filesystem:

* The root filesystem will be more flexible: it will be easier to resize it if
  it is on an LVM Logical Volume
* You can make snapshots of the root filesystem which is very useful if you want
  to make consistent backups of it

You may not want your root filesystem to be on an LVM Logical Volume if you
don't want to boot with a ramdisk. If you compile your own kernel with all the
important disk and filesystem drivers built in the linux image, it will be
possible to boot with no initramfs as long as linux is installed on a standard
disk partition that the kernel will be able to mount.

## Extracting an initramfs
An initramfs contains the files necessary to obtain access to the root
filesystem at boot time. It is possible to read its contents if you want to
have a look at its contents. There are two sorts of such files: the old ones are
called initramdisk and the new ones are called initramfs.

### about initramfs
Most linux distributions provide initramfs along with kernel images. They are
compressed cpio archives. Here is how to extract it

#### Create a temporary directory
```
mkdir /var/tmp/ramdiskfiles
```
#### Extract the compressed initramfs
```
cd /var/tmp/ramdiskfiles && zcat /boot/initrd-x.y.z.gz | cpio -id
```
#### Here is how to recreate an initramfs
The following command will create a new initramfs using files located in `/var/tmp/ramdiskfiles-new`:
```
find /var/tmp/ramdiskfiles-new | cpio -H newc -o | gzip -9 > boot/initrd-x.y.z-new.gz
```
