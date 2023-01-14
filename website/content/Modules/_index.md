+++
weight = 900
title = "Custom SystemRescue Modules"
nameInMenu = "Modules"
draft = false
+++

## About SystemRescue Modules
SystemRescue supports loading SRM Modules (System-Rescue-Modules). These are
squashfs file systems which allow to add custom files to the live system.
This feature was originally introduced in version 3.x on legacy versions, but it
had not been implemented immediately after the project was rebased on Arch Linux
in version 6.0. This feature is available again in SystemRescue version 7.

This feature is useful for adding new programs to SystemRescue as a module can
contain a program, its data files and all its dependencies, but this features
can also be used to add custom data files (your favourite scripts, configuration
files,...) even though a [backstore](/manual/Creating_a_backing_store/) may be
more appropriate in this case.

## Loading SRM modules into SystemRescue
All SRM modules must be placed in the directory designated by the
`archisobasedir` boot parameter ("sysresccd" by default) on the boot disk. This
is one directory above where the `airootfs.sfs` file is stored. The SRM files
names must have a `.srm` extension. If multiple srm files are found, they are
all loaded in alphabetical order. SRM modules are only loaded when the `loadsrm`
boot parameter is present, either as `loadsrm` or `loadsrm=y`. You can only
enable or disable the loading of all SRM modules on the command line. It is not
possible to specify which module to load.

To be able to copy SRMs into the correct directory as outlined above, SystemRescue
must be on media that is partitioned like a regular disk drive, not like a CD-ROM. 
The former is the case when using Rufus or SystemRescue USB writer 
[as described here](/Installing-SystemRescue-on-a-USB-memory-stick/).

When you want to create a full ISO-image with SystemRescue that contains SRMs, you
can do that with the [sysrescue-customize](/scripts/sysrescue-customize/) script.

## Modules implementation
SRM modules are standard squashfs file system images just like `airootfs.sfs`.
These file systems are mounted on top of the regular SystemRescue file system
using overlay file systems. If a file is present in an SRM module and also in
the stock SystemRescue, the file in the SRM will take precedence.

## Creating your own SRM modules
You can create your own module using `mksquashfs`. You just have to prepare a
directory with all the files you want to put in the module. If you want to add
extra programs to SystemRescue creating a module with standalone programs (such
as static binaries) should be quite simple. If you want to add programs which
have many dependencies this will be more complicated, as they may conflict with
what the stock SystemRescue needs.

## Creating SRM modules out of pacman packages
SystemRescue supports the pacman package manager and repositories of the Arch Linux
base distribution to install additional software, see 
[Installing additional software packages with pacman](/manual/Installing_packages_with_pacman/)
for details.

You can create a SRM module to make these additional packages usable without internet
access or combine them with your own scripts and configuration.

The `cowpacman2srm` script is provided with SystemRescue version 7.01 and newer. 
It packs all packages you have installed during a running SystemRescue
session using the Copy-On-Write space to an SRM file. It just writes installed
pacman packages and systemd unit symlinks for them, but not other changes in the
COW space.

How to use cowpacman2srm:

* Boot SystemRescue, and make sure the version you use is as recent as possible.
You will need to have enough space in the Copy-On-Write area to download and
install all additional packages (and their dependencies). Ideally you should use
a computer with a large amount of RAM. You can also boot SystemRescue using the
`cow_spacesize` boot parameter to increase the size of the Copy-On-Write area
which is set to 25% of the physical RAM by default. For example you can boot
using `cow_spacesize=4G` if you use a computer with 8GB of RAM so it allocates
half or the memory to the COW area instead of just a quarter.
* Install packages using `pacman -Sy packagename`
* You can enable systemd units provided by the packages just installed if
necessary
* Run `cowpacman2srm` as described below.
* Copy the resulting .srm file to your boot media into the sysresccd directory
(usually mounted on `/run/archiso/bootmnt`). Modify the bootloader configuration
to add `loadsrm` to the parameters in the boot command line.

Syntax: `cowpacman2srm [-s subcmd] [-c compalg] [-l complevel] [targetfile.srm]`

* `subcmd` is a sub-command to execute, it can be any of: prepare, create, all. (default: all)
* `compalg` is any of the compression algorithms supported by mksquashfs (default: zstd)
* `complevel` is the compression level for the given algorithm (if supported with -Xcompression-level)

This script runs in two stages:

* During the `prepare` stage all files belonging to pacman packages manually
  installed are being copied to a temporary directory
* During the `create` stage the SRM file (which is a squashfs file system) is
  being created with the contents stored in the temporary directory.

You can either run both stages in a single run (this is the default) or one
stage at a time. If you do not specify any sub-command the script is going to
run the two stages in one run. If you want to customize the contents of the SRM
module you can run the "prepare" stage first, then make customizations in the
temporary directory (for example to add extra files) and then you run the
"create" stage to produce the SRM file.

## SRM modules and dependencies
Be aware that SystemRescue does not have a mechanism to verify if the contents
of an SRM module are compatible with the running version of SystemRescue. The
SRM is just overlaid over the base file system. If the SRM contains changes to
system libraries or core programs, this could render SystemRescue unbootable or
unstable. Also the pacman package databases of SystemRescue and an SRM created
with cowpacman2srm are merged. This can disturb the operation of pacman if you
use an SRM module created with a different version of SystemRescue than you are
running it with. This is why it is not recommended to use `cowpacman2srm` on
anything but the SystemRescue you want to use the resulting SRM with.

## Early load vs. late load
Usually SRMs are loaded early during boot in the initramfs phase. This is because
they change the mountpoint of the root filesystem. This is called **early load** and is
the faster and memory efficient way to use SRMs. But during initramfs the system 
has just a rudimentary network stack, so things like Wifi or VLAN tagging are not 
supported. Also certificate verification for HTTPS does not work. So when you want
these features, you can late load your SRM instead.

**Late loading** is implemented by copying the content of the SRM over the Copy-On-Write (CoW)
space, it is not permanently mounted as overlay like when early loading. This
means that more memory is required for the CoW-space. So it is recommended
to keep the size of late loaded SRMs small. When using a 
[persistent backing store](/manual/Creating_a_backing_store/), the 
content of a late loaded SRM is written to it.

The image format of a SRM is always the same (=squashfs), regardless of when it is loaded.

## Late loading from YAML config
You can late load a SRM by using the `late_load_srm` option in the 
[YAML config](/manual/Configuring_SystemRescue/).

The `late_load_srm` option either takes a local path as parameter, for example using
`/run/archiso/bootmnt` to access the original boot media. Or you can use `http://` and
`https://` URLs to access network servers.

This option is executed during system initialization. It is guaranteed to be done after
setting up Certification Authority (CA) trust, including the custom `ca-trust` entries.

A `systemctl daemon-reload` is executed afterwards, but systemd doesn't re-evaluate
dependencies during a running transaction. So an extra start of `multi-user.target`
is queued after late-loading with the `late_load_srm` option. That means you can add
`Wants` to `multi-user.target` in a late-loaded SRM and have them acted upon, but not
to other targets or units.

Autorun is done after late loading is finished.

## Late loading with `load-srm`
You can late load SRMs at any time by calling the `load-srm` script included in 
SystemRescue since Version 9.02.

Usage:
```
load-srm [-v|--verbose] [-i|--insecure] <URL-or-Path>

<URL-or-Path>    Either a path to the SRM or a URL to download it from.
                 Supports http:// and https:// URLs.

--insecure       Ignore TLS errors like wrong certificate when using HTTPS.
                 Not recommended to use unless you know what you are doing.
--verbose        Output progress and details about each step.
```


