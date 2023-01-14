+++
title = "sysrescue-customize: customize SystemRescue ISO-images"
+++

## Why?

There are several cases where modifying SystemRescue makes sense, for example when
you want to [configure YAML files](/manual/Configuring_SystemRescue/) or add
[SystemRescueModules (SRM)](/Modules/).

The recommended method for this is usually to create USB-media using 
Rufus or SystemRescue USB writer [as described here](/Installing-SystemRescue-on-a-USB-memory-stick/),
because it creates a USB memory stick partitioned like a disk drive and that
allows you to directly modify it with the regular methods provided by your operating
system.

But sometimes it is better to modify the ISO-image instead, for example when the
Rufus-method is inconvenient or you need an ISO-image to boot a virtual machine.
Since ISO-images were developed for read-only media, they are inherently read-only.
To modify them you have to unpack, modify and then rebuild them.
This is what this script does.

## Preparation

Download the most recent version of sysrescue-customize from here:\
https://gitlab.com/systemrescue/systemrescue-sources/-/raw/main/airootfs/usr/share/sysrescue/bin/sysrescue-customize?inline=false

#### Linux

The best way to use sysrescue-customize is usually on another Linux system.
It is a bash script written in a way that it is compatible with most common Linux
systems. It checks for all necessary programs at the start. These are usually part
of the base installation, except xorriso and mksquashfs. These can usually be installed
with the package manager of your distribution.

#### SystemRescue

The script is also included on SystemRescue itself. But running it there has the downside
that you need about 3 times the size of SystemRescue as Copy-on-Write space for
a full rebuild. So you may need to change the `cow_spacesize=xx` [boot option](/manual/Booting_SystemRescue/)
or use a [permanent backing store](/manual/Creating_a_backing_store/) to make it work.

#### Windows

You can run sysrescue-customize with the Windows Subsystem for Linux (WSL). When using
the default Ubuntu variant, you have to install the dependencies like this:
```
sudo apt install xorriso squashfs-tools
```

## Manual mode

In manual mode you first unpack the provided ISO-image of SystemRescue like this:
```
sysrescue-customize --unpack --source=<ISO-FILE> --dest=<DIR>
```
You can then modify the contents of the image in the given destination directory.
Afterwards you can rebuild the image again:
```
sysrescue-customize --rebuild --source=<DIR> --dest=<ISO-FILE>
```

When the destination directory or ISO-file already exists, the script will abort.
If you want to let it overwrite instead, use the `--overwrite` option.

## SystemRescueModules (SRM)

While rebuilding or in automatic mode, sysrescue-customize can build a [SystemRescueModule (SRM)](/Modules/)
and insert it into the image. When rebuilding manually, you add the `--srm-dir=<DIR>` option for this.
In automatic mode you use the `build_into_srm` directory.

All files existing in the given directory are packed into the SRM and are then later overlayed over
the regular filesystem of the running SystemRescue.

When adding a SRM in `--rebuild` mode, the given `--source=<DIR>` is modified. Meaning that the SRM-file
and a YAML-file to activate it are written into this directory. So be careful when reusing the same source
directory with different options.

SRMs are squashfs-files and created with mksquashfs. When you want fine control over how mksquashfs
is executed, you can create a file `.squashfs-options` in the top level of the SRM directory. The content
of this file is then given as additional command line options to mksquashfs. Lines starting with `#` are
excluded as comments and newlines are converted to space, so you can span the options over several lines.
The options are evaluated by the shell as given, so for example forking a subshell and executing random
commands is possible. So be sure you fully trust the content of the file before using it on your system.

See the [squashfs documentation](https://github.com/plougher/squashfs-tools/blob/master/USAGE) for details
about the available options.

Sometimes it is important to control file mode or owner for the files in the SRM, for example when supplying
SSH-keys. By default mksquashfs will just keep the owner, group and mode of the files from the given directory.
This can prevent you from running sysrescue-customize without root rights. To solve this, mksquashfs offers
a feature called "pseudo-files" which allows you to override owner, group and mode of individual files. This
is triggered by creating a file with the name `.squashfs-pseudo` in the SRM directory.

Basic syntax for overriding file modes and owner is:
```
filename m <octalmode> <uid|username> <gid|groupname>
```

Use it for example like this:
```
/root/.ssh m 700 root root
/root/.ssh/authorized_keys m 600 root root
```

Details of the syntax can be found in the pseudo-files section of the [squashfs documentation](https://github.com/plougher/squashfs-tools/blob/master/USAGE).

## Automatic mode

In automatic mode a ISO-image is unpacked, modified and than rebuilt with one command. All modifications
are codified in a "recipe".
```
sysrescue-customize --auto --source=<ISO-FILE> --dest=<ISO-FILE> --recipe-dir=<RECIPE-DIR>
```
The auto mode and recipes are a convenient method to make the same modifications on different versions
of SystemRescue. It allows you to prepare the customizations once, and apply these very easily
each time you download a new version of SystemRescue. The recipe could for example be stored in a git
repository to allow tracking changes over time.

The recipe is a directory with several subdirectories, one for each step.

You can download and extract an [example of a recipe folder](/examples/sysrescue-customize-recipe-example.tar.gz)
to give you a concrete example of what a recipe folder may contain.

#### Step 1: \<RECIPE-DIR\>/iso_delete/

Each file that exists in this directory means that files or directories with the same name are deleted
from the ISO-image. This deletion is recursive. So if a file `<RECIPE-DIR>/iso_delete/EFI` exists, the whole
`EFI` directory from the ISO-image would be deleted. If there is a file `<RECIPE-DIR>/iso_delete/EFI/shell.efi`, just
the EFI-shell would be deleted.

#### Step 2: \<RECIPE-DIR\>/iso_add/

All files that exist below that directory are copied into the ISO-image. Already existing files are overwritten.

So you could for example create a file `<RECIPE-DIR>/iso_add/sysrescue.d/500-settings.yaml` to add a new
[YAML configuration file](/manual/Configuring_SystemRescue/) which will override the default settings. This
way you can do things such as having the correct keyboard type automatically configured, force the system to
be copied to RAM during the boot time, or automatically start the graphical environment.

You can also copy [autorun scripts](/manual/Run_your_own_scripts_with_autorun/) here so the custom ISO can be
used to automatically execute administration scripts when SystemRescue starts.

#### Step 3: \<RECIPE-DIR\>/iso_patch_and_script/

This step allows you to patch existing files or run arbitrary scripts. All files in this directory are executed
in alphabetical order. To make sure they are always executed in a consistent and predictable order, the
allowed filenames are limited: `^[0-9_a-z-]+$` for scripts and `^[0-9_a-z-]+\.patch$` for patches. Scripts
need to have the executable mode bit set.

Patches are executed with `-p1`, meaning they must have one additional directory level above the root directory
of the ISO-image.

Scripts are executed from within the root directory of the ISO-image, so they don't need any knowledge about
the directory structure of the machine they are running on. Scripts allow the most flexible modifications, so
you could for example even unpack and rebuild the `airootfs.sfs` with them. Make sure that you fully trust the
script content before executing a recipe.

#### Step 4: \<RECIPE-DIR\>/build_into_srm/

See the section about SRMs above.

#### Work directory

By default a temporary directory is created and that is used to unpack the ISO content to and modify it. The
temporary directory is deleted after the script finishes. Alternatively you can control the location of
the work dir with the `--work-dir=<DIR>` parameter. The work dir must be empty or the `--overwrite` option be
used.

## All options

```
sysrescue-customize - customize an existing SystemRescue iso image

Usage in unpack mode:
sysrescue-customize --unpack -s|--source=<ISO-FILE> -d|--dest=<DIR>
    [-o|--overwrite] [-v|--verbose]

Usage in rebuild mode:
sysrescue-customize --rebuild -s|--source=<DIR> -d|--dest=<ISO-FILE>
    [-m|--srm-dir=<DIR>] [-o|--overwrite] [-v|--verbose]

Usage in auto-mode:
sysrescue-customize --auto -s|--source=<ISO-FILE> -d|--dest=<ISO-FILE>
    -r|--recipe-dir=<DIR> [-w|--work-dir=<DIR>] [-o|--overwrite] [-v|--verbose]

--source=<ISO or DIR>       unpack and auto: iso file (or raw block device)
                                     to extract. Must be in iso9660 format.
                                     On SystemRescue: can be omitted, then
                                     the boot device is used if possible.
                            rebuild: source dir to rebuild the iso image from.
                                     Must be in the same format as created by
                                     --unpack.
--dest=<ISO or DIR>         unpack: destination directory to unpack into.
                            rebuild and auto: destination for the iso file.
--srm-dir=<DIR>             Content of the directory will be packed into a
                            SystemRescueModule (SRM). The --source dir will
                            be modified when this option is used.
--recipe-dir=<DIR>          Directory that contains a recipe for fully
                            automatic customization. Uses these subdirectories:
                            iso_delete (Step 1: files there trigger deletes)
                            iso_add  (Step 2: add or overwrite)
                            iso_patch_and_script (Step 3: patch -p1 or scripts)
                            build_into_srm (Step 4: like --srm-dir option)
                            See SystemRescue manual for more details.
--work-dir=<DIR>            Use this as a temporary work directory for
                            unpacking and rebuilding.
--overwrite                 Without this option the target directories or
                            files must be empty or non-existing. This option
                            will overwrite existing files without questions.
--verbose                   Verbose output when running xorriso.
```
