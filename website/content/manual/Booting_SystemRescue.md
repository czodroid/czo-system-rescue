+++
title = "Booting SystemRescue"
nameInMenu = "Boot options"
draft = false
aliases = ["/Sysresccd-manual-en_Booting_the_CD-ROM","/manual/Booting_SystemRescue/"]
+++

## Boot from a removable device
To boot from a CD-ROM or USB device make sure that the computer firmware (BIOS
or UEFI settings) is configured to boot the right device and that the priority
is correct.

To start SystemRescue, insert the CD or USB in the drive, and power on or
reset your computer, or press a key to select an alternative boot device when it
starts.

## Boot commandline options

In the bootloader you can press TAB (syslinux, used for classic BIOS boot) or
"e" (grub, used for UEFI boot) to edit the boot commandline of the currently
selected boot entry. You can then add the options listed below.

### Available on commandline and YAML config

Most options are available on the boot commandline as well as in the 
[YAML configuration](/manual/Configuring_SystemRescue/) in the `global` scope. 
Options on the boot commandline have higher priority than the ones in the YAML config.

The following options are supported on boot commandline and in YAML config:

* **setkmap=xx** defines the system to configure the keyboard layout where `xx`
corresponds to a keyboard map code. For example `setkmap=de` will
configure the German keyboards layout during the boot process. You can also
set the keyboard layout by running a command such as `setkmap de`
from the shell after boot time, and you can run `setkmap` with no parameter in
the terminal on a running SystemRescue to get a list of all supported keymaps.
* **copytoram** causes SystemRescue to be fully loaded into memory. This
corresponds to the `docache` option in previous versions. A slower start but
once complete, the system will be more responsive and also it will not require
the original device to run. It means you can actually work on the device where
SystemRescue is installed. This requires 2GB of memory to cache the system.
* **checksum** will trigger a verification of the squashfs checksum during the
boot so you know if the file has been corrupted. You should use this boot option
if you get unexpected errors when booting SystemRescue.
* **rootpass=password123**: Sets the root password of the system running on the
livecd to `password123`. That way you can connect from the network and ssh on
the livecd and authenticate using this password. For security reasons it is
recommended to use the alternative `rootcryptpass` option instead of `rootpass`
so the password is not visible as clear text.
* **rootcryptpass=xxxx**: Sets the root password of the system running on
the livecd so you can connect to the system remotely via ssh and use the
password to authenticate on the livecd. The password must be encrypted using
a command line such as the following one:
`python3 -c 'import crypt; print(crypt.crypt("MyPassWord123", crypt.mksalt(crypt.METHOD_SHA512)))'`
You need to provide the whole encrypted password as printed by the python
command including the `$5$` or `$6$` prefix and the salt. The encrypted password
contains dollars so you should check if your boot loader needs escaping
characters to preserve these special characters. You should check that
`/proc/cmdline` contains the value that you passed if you have doubts.
* **nofirewall** stop the iptables and ip6table services which are enabled by
default in order to block incoming connection requests. You need to use this
option if you need to establish connections to the system running SystemRescue
from outside (for example connections to sshd). This option was introduced in
SystemRescue-6.0.4.
* **rootshell=/bin/myshell** use an alternative shell such as /bin/zsh instead
of /bin/bash. This option was introduced in SystemRescue-6.1.1.
* **cow_label=xxxx** Set the filesystem label where upperdir/workdir files for
overlayfs must be stored. By default this option is not set and changes made on
SystemRescue files are lost after a reboot. In other words you can use a Linux
filesystem to persist all modifications made on SystemRescue when it runs such
as new bookmarks in Firefox, application configuration files, etc. You have to
provide the label of the filesystem that needs to be used to store these
changes. All these changes will be isolated in a directory prefixed by
`persistent` unless you override this using `cow_directory`
* **cow_directory=xxxx** Name of the directory where to store changes made on
the system. You must have specified a cow device for this change to take effect.
* **loadsrm=y** Load all SRM modules located on the boot device
* **noautologin** Do not automatically login on the console. Use this option if
you intend to use SystemRescue to run automatic jobs to connect remotely and
want to prevent local users from using the system from the console. This option
was introduced in SystemRescue-8.06.
* **dostartx** Automatically start the graphical environment. This option
was introduced in SystemRescue-8.06.
* **dovnc** Automatically start the VNC server to be able to remotely connect
using a graphical session. This option was introduced in SystemRescue-8.06.
* **vncpass=password123** Set the VNC password for connecting remotely. Without
this option connections to the VNC server will not be restricted. This option
was introduced in SystemRescue-8.06.

### Available only on commandline

The following options are supported only on the boot commandline:

* **cow_spacesize=xx** sets the size of the Copy-on-Write area which is stored
in a tmpfs file system in memory. It accepts values such as 512M, 4G and is set
to 25% of the system memory by default.
* **nomodeset** causes the system to run with a basic display driver in lower
resolution instead of using the most optimal display settings. Use this option
if information is not being displayed properly on the screen.
* **findroot**: boot a Linux OS installed on disk using the SystemRescue
kernel. This is very useful if you are unable to boot a Linux OS directly using
the normal process. This could be caused by the boot loader being broken for
example. This option allows you to boot your system via SystemRescue so you
can fix the boot loader. This option works by scanning block devices during the
boot process to find filesystems where a Linux operating system is installed
(ie: filesystems which contain a file called `/sbin/init`). This includes block
devices which are luks encrypted hence the user will have to provide the
passphrase in order to access these devices. It will then show a list of all
block devices which seems to be Linux root filesystems. The user will then need
to choose the block device from which to boot. This option has been introduced
in SystemRescue version 6.1.4.
* **break**: stop the boot process before the root filesystem gets mounted. A
shell will be executed from the initramfs. This option allows to run commands
manually in order to troubleshoot issues if SystemRescue cannot boot normally.
* **break=postmount**: stop the boot process after the root filesystem gets
mounted. A shell will be executed from the initramfs. This option allows to run
commands manually in order to troubleshoot issues if SystemRescue cannot boot
normally.
* **sysrescuecfg=filename.yaml** adds additional yaml configuration files 
to be loaded after the default ones in the `sysrescue.d` directory. This option
can be specified one or multiple times on the boot command line. See
[YAML configuration](/manual/Configuring_SystemRescue/) for details.
This option was introduced in SystemRescue-9.01.
* **archisolabel=xxxx** Set the filesystem label where SystemRescue files
reside. In other words the system will try to find SystemRescue files on a
filesystem having the label specified so it is important for it to locate on
which device SystemRescue files are located. This is set to `RESCUEXYZ` by
default since version 7.00 (it used to be `SYSRCDXYZ` with versions 6.x)
where XYZ corresponds to the SystemRescue version (eg: the label is `RESCUE803`
for version `8.03`)
* **archisobasedir=xxxx** Set the base directory where all SystemRescue files
reside and it is set to `sysresccd` by default. In other words the
system will try to find SystemRescue files in a directory named
`sysresccd` which is located at the root of the filesystem.
* **img_label=xxxx** Set the filesystem label where SystemRescue ISO image is
located. This is only used when booting SystemRescue using the loopback option
from Grub2.
* **img_loop=xxxx** Set the path to the SystemRescue ISO image within the
filesystem so the boot process can mount it and find the squashfs filesystem.
This is only used when booting SystemRescue using the loopback option from
Grub2.
* **nomdlvm** SystemRescue by default automatically activates all md RAID, 
device mapper and LVM devices that are found in the system. Activating them 
can lead to writes to the disk and this is sometimes not wanted, for example 
when doing forensics or working with defective disks. This option disables
this behavior and all devices have to be activated manually.
* **archiso_http_srv=** Set a HTTP URL (must end with /) where to download
the *.sfs file from when using HTTP. ${archisobasedir} and the architecture (`x86_64`)
are added to the supplied URL.
http and https are supported. When using https, no certificate check is done as the
initramfs environment doesn't contain a trusted CA database.
* **archiso_nfs_srv=** Set the NFS-IP:/path of the server where to download
the *.sfs file from when using NFS. ${archisobasedir} and the architecture (`x86_64`)
are added to the supplied path. Note that due to tooling limitations only IPv4 addresses
are supported, no DNS hostnames or IPv6.

Please read [the archiso documentation](https://gitlab.archlinux.org/archlinux/archiso/-/raw/v43/docs/README.bootparams)
for more advanced boot options and PXE boot in particular.

### Options provided for autorun

These options are available on the boot commandline as well as in the 
[YAML configuration](/manual/Configuring_SystemRescue/) in the `autorun` scope. 

* **ar_source=xxx**: place where the autorun are stored. It may be the root
  directory of a partition (`/dev/sda1`),
  an nfs share (`nfs://192.168.1.1:/path/to/scripts`),
  a samba share (`smb://192.168.1.1/path/to/scripts`), or
  an http(s) directory (`http://192.168.1.1/path/to/scripts`).
* **ar_ignorefail**: continue to execute the scripts chain even if a script
  failed (returned a non-zero status)
* **ar_nodel**: do not delete the temporary copy of the autorun scripts located
  in `/var/autorun/tmp` after execution
* **ar_disable**: completely disable autorun, the simple `autorun` script will
  not be executed
* **ar_nowait**: do not wait for a key press after the autorun script have been
  executed.
* **ar_attempts**: use this option if you want to retry to download the file
  multiple times
* **ar_suffixes=[0-9]**: comma separated list of suffixes corresponding to the
  autorun scripts to be run. For example with `ar_suffixes=0,2,7` the autorun
  scripts `autorun0`, `autorun2`, `autorun7` are going to be run, and scripts
  with other suffixes will be ignored. Use `ar_suffixes=no` to disable all the
  autorun scripts with a suffix. This option has been introduced in SystemRescue
  9.00 in order to replace `autoruns=` and make the name more consistent with
  other autorun options.
* **autoruns=[0-9]**: comma separated list of the autorun scripts to be run. For
  example `autoruns=0,2,7` the autorun scripts `autorun0`, `autorun2`,
  `autorun7` are run. Use `autoruns=no` to disable all the autorun scripts with
  a suffix. This option is deprecated in SystemRescue 9.00 as it was replaced
  with `ar_suffixes`.

For more details, please read the
[page about autorun](/manual/Run_your_own_scripts_with_autorun/)

## Booting on a serial console
See [Booting on a serial console](/manual/Booting_on_a_serial_console/).

## Booting from the network via PXE
It is also possible to boot SystemRescue from the network. Since the
installation is not simple, there is a dedicated page to
[PXE network booting](/manual/PXE_network_booting/)
