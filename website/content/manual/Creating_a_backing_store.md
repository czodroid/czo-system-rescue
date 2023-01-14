+++
title = "Creating a backing store"
draft = false
+++

## Overview
SystemRescue is based on a read-only compressed file system. All the files of
the system are stored in a large squashfs file system image file. As a
consequence, **changes you make on the system are not saved**, and they are lost
when you reboot (except what you do on the other file systems that you may have
mounted).

The root file system in SystemRescue is an overlayfs since version 6.0. Hence
**all changes made on system files are allowed and stored in memory**. It allows
you to change a system file, for instance you can replace a program with your
own version, or you can make configuration changes in applications such as
Firefox.

Users who want to keep their changes in the system files can create a custom
SystemRescue media. It is very convenient when you want to add new programs to
the system, but it is not comfortable if you often have to change files in the
system. You do not want to make a new customized version everyday.

That is why SystemRescue provides the backing-store feature. A backing-store
is a file system stored on an USB-stick or on an hard drive, which
contains all the files of the system that have been changed. The modifications
are saved to the backing-store every time you edit a file, when you create a new
directory, or when the system writes or deletes a file for any other reason. As
a consequence, it allows you to keep your configuration changes: you can add
your bookmarks and extensions to Firefox, and they will still be there when you
reboot SystemRescue, as long as the same backing-store is loaded.

Backing stores are not compatible between SystemRescueCd-5.x and SystemRescue
since version 6.0 as they use different union file systems (aufs vs overlayfs).

## Using a backing store with SystemRescue-6.x and newer

You need to have a Linux file system where SystemRescue is allowed to store its
changes. It can be any Linux file system such as ext4, xfs or btrfs. You can
either create a dedicated file system to store these changes or you can reuse an
existing file system as changes will be isolated in a directory. You need provide
SystemRescue an option on the boot command line or in the 
[YAML configuration](/manual/Configuring_SystemRescue/) configuration file so it 
can identify the file system where to store these changes. The recommended method
is to specify the file system label but this is not the only way.

You then need to boot SystemRescue with option `cow_label=xxxx` where `xxxx`
is the label of a Linux file system where you want changes to be stored. For
example you use `cow_label=boot` if your `/boot` file system is labelled `boot`.
This is similar to `cow_device=/dev/disk/by-label/boot`.

How to set a file system label depends on the filesystem used. For ext4 use
`tune2fs -L <newlabel> <device>`, for xfs `xfs_admin -L <newlabel> <device>` and
`btrfs filesystem label <device> <newlabel>` for btrfs.

Changes will by default be stored in a directory named `persistent_${archisolabel}/${arch}`.
So for example `persistent_RESCUE904/x86_64`. You can override this default using the
`cow_directory=xxxx` option.

See [Booting SystemRescue](/manual/Booting_SystemRescue/) for more details about the
boot options supported in SystemRescue.
