+++
title = "Run your own scripts with autorun"
draft = false
aliases = ["/Sysresccd-manual-en_Run_your_own_scripts_with_autorun"]
+++

## Autorun overview
The **autorun feature** allows you to run scripts or binary programs automatically at
startup of the system. Each autorun script can manage a task. For
example, you can create a backup script that makes a backup of a
database, another for cleaning a system, ...

By default, the autorun script(s) can be copied in the `autorun` directory of the ISO image
or boot device, outside of the squashfs compressed image file, but other sources
are available too: local file system, network share, an HTTP/HTTPS server.

## Configuration methods

SystemRescue offers two methods to configure autorun programs:

- **Name based**. Programs with a file name beginning with `autorun` in a set of locations
are loaded and executed. This is the old style of configuring autorun.
- **YAML config based**. A configuration file contains the paths, URLs and parameters of
as many autorun programs as necessary. This is the new style of configuring autorun, available
since SystemRescue version 9.05.

Both methods are fully supported and are planned to stay available in future releases.

## Configuring autorun with YAML

Synopis:

```
---
autorun:
    exec:
        200:
            url: "http://web-server/adminscripts/some-script"
            parameters: 
                - "foo"
                - "bar"
            shell: false
            wait: always
            waitmode: 15
            on_error: break
        300:
            path: "rclone"
            parameters: 
                - "copy"
                - "myserver:/scripts/"
                - "/root"
            wait: on_error
            on_error: break
```

Configuration is done through entries in the [YAML configuration](/manual/Configuring_SystemRescue/)
using `exec` entries in the `autorun` scope. The keys in the `exec` Mapping / dictionary 
(`200` and `300` in the example above) are names for each autorun program. The programs are
executed in lexicographic order of these names.

Options for each `exec` entry:

- Each autorun program must have one `url` or `path` entry, but may not have both
- **url** a URL to download the program from. http, https, nfs and smb protocols are supported, device paths below /dev too.
    - When using https, the server certificate is checked for validity. So ensure that the system clock is correct. You can
      [add your own certificates to the trusted CA store](/manual/Configuring_SystemRescue_sysconfig/) if necessary.
    - nfs uses the style `nfs://hostname:/path/script`
    - smb uses the style `smb://hostname/share/path`. Be aware that only public guest shares without password are supported.
    - You can also supply a path into an unmounted block device, for example `/dev/sda1/usr/bin/script` or 
      `/dev/disk/by-label/mylabel/usr/bin/script`.
- **path** is used for programs on already mounted devices.
    - Absolute paths or lookup in $PATH are supported
    - Use `/run/archiso/bootmnt/autorun/` to access scripts in the `autorun` directory on the boot media.
    - This directory is also copied when using the `copytoram` option while other parts of the boot media are not available when using `copytoram`.
- **parameters** a list of parameters passed to the program.
- **shell** (default: `false`) controls if the program is executed directly or through the `/bin/sh` shell. 
    - When using the shell, all given parameters are concatenated and given to the shell as one string. Dividing them is then done 
       by the shell. 
    - Proper escaping of the parameters has to be done by the user
    - It is recommended to not use the shell option unless necessary, for example for piping the output to another program.
    - A shell script can (and usually should) be executed directly and without this shell option. This
      option is about how the script is invoked and parameter passing, not the language the script is written in. A shebang
      is recognized when executing directly and without the shell option.
- **wait** allowed values `always`, `on_error` or `never`, default is `on_error`. Controls if/when to wait directly after 
    execution of this one script.
- **waitmode** allows either `key` for requiring a keypress or a number, indicating the number of seconds to wait. You can press a key to
  continue before the given number of seconds is expired. Default is `30`.
- **on_error** allows either `break` or `continue`, with `ar_ignorefail` controlling the default. Defines what to do with the
  following scripts after this script failed (returned a non-zero status).
  
## Name based autorun

Scripts to execute are searched using a list of rules (see below).
If scripts are found, entries in the `exec` Mapping / dictionary are created for them.
This allows to use YAML based autorun and name based autorun programs to be used together.

### Options for name based autorun

-   **ar\_source=xxx**: place where the autoruns are located. It may be
    the root directory of a device (`/dev/sda1`), an nfs share
    (`nfs://192.168.1.1:/path/to/scripts`), a samba share (`smb://192.168.1.1/path/to/scripts`),
    or an http/https directory (`http://192.168.1.1/path/to/scripts`)..
    Please note this parameter contains the address of the folder which 
    contains some autorun script. This is not the full address of a particular 
    script, as the name of the script will be added at the end of the source.
-   **ar\_suffixes=\[0-F\]**: comma separated list of the suffixes corresponding
    to the autorun scripts which must be executed. For instance if you use
    `ar_suffixes=0,2,7` then the following autorun scripts will be executed:
    `autorun0`, `autorun2`, `autorun7`, and scripts with other suffixes will be
    ignored. Use `autoruns=no` to disable all the autorun scripts with a suffix.
    This option was introduced in SystemRescue 9.00 in order to replace the
    deprecated `autoruns=` option which was used similarly with older versions.

### Script search rules for name based autorun

At startup, a list of locations is checked against the presence of
autorun files. They are, successively:

-   if the **ar\_source=** parameter was passed at startup, the root
    directory of the given location.
-   the **autorun** folder located at the root of the boot device (since
    SystemRescue 9.00)
-   the **root directory** of the boot device. This is deprecated and will be ignored in a future release.
-   the superuser home directory (**/root**)
-   the **/usr/share/sys.autorun** directory

If autorun files are found in some location, they are added to the `exec` Mapping / dictionary
and the following locations are ignored.

In each source location, there are two possible modes of operation :

-   simple one : if a shell script named `autorun` is found, it is run
-   more flexible : if `autorun#` scripts are found (\# is a digit from
    0 to 9 or letter A to F) and either
    -   `ar_suffixes=` boot parameter was NOT specified, or
    -   `ar_suffixes=` boot parameter value contains \#

Example: With `ar_suffixes=0,1,4` only `autorun0`, `autorun1` and `autorun4`
scripts will be executed if present. Other scripts, such as `autorun2` and
`autorun3` will be ignored.

A script with the filename `autorun` will get the name `1000-autorun` within the `exec` Mapping / dictionary.
`autorun0` will get `1010-autorun0`, `autorun1` will be `1011-autorun1` and so on until `1025-autorunF`.
This naming scheme allows to control the execution order when using YAML config based autorun together
with name based autorun.

## General Options for autorun

These options are used to control the general behaviour of autorun. They can be
specified either on the boot command line or through
[YAML configuration files](/manual/Configuring_SystemRescue/)

-   **ar\_nowait**: do not wait for a keypress after all the autorun scripts
    have been executed (default: true)
-   **ar\_ignorefail**: continue to execute the scripts chain even if a
    script has failed (returned a non-zero status) (default: false)
-   **ar\_nodel**: do not delete the temporary copy of the autorun
    scripts located in `/var/autorun/tmp` after execution (default: false)
-   **ar\_disable**: completely disable all autorun execution (default: false)
-   **ar_attempts** number of tries to download a script from a remote URL (default: 1)

## Installing autorun programs

The easiest method to get autorun programs onto a SystemRescue media is usually to 
create a writable USB boot media for SystemRescue. This can be done with
Rufus or SystemRescue USB writer [as described here](/Installing-SystemRescue-on-a-USB-memory-stick/).
You can mount the USB media afterwards and copy the autorun scripts into
the `autorun` directory using a regular file manager.

If you install SystemRescue on a USB stick using either `dd` or any other tool 
which performs a physical copy of the ISO image, it will not produce a writable 
file system, and you will not be able to copy autorun scripts to the device.

If creating a writeable USB media is not possible, you can modify the ISO image
with [sysrescue-customize](/scripts/sysrescue-customize/).

To write programs to the `/root` or `/usr/share/sys.autorun` directory, you have
to modify not the boot media, but the the filesystem that SystemRescue boots to (airootfs).
This can be best be achieved by using [SystemRescue Modules (SRM)](/Modules/) or
with a [permanent backing store](/manual/Creating_a_backing_store/).

## Program execution

The script can be any script using an installed interpreter like shell, Python, Perl, ...
It should have a shebang (#!) at the beginning to indicate the interpreter to use. 
ELF binaries are also supported.

Scripts without shebang are executed by the POSIX shell (`/bin/sh`). This is deprecated
and a future version of SystemRescue will require all scripts to have a valid shebang.

Windows end-of-line terminators (`\r\n`) are translated to allow running shell scripts 
written with a MS editor. This is deprecated and future revisions of SystemRescue will
not modify line endings anymore.

Autorun programs are executed on the main system console. All their output is written to
the console and input from the console is passed to the program. Escape sequences are not
passed through, so using a curses based text UI (for example like `setkmap`) is not supported.
For programs with user interaction, using [autoterminal](/manual/autoterminal_scripts_on_virtual_terminal/)
is the preferred solution over autorun.

## Troubleshooting

Since SystemRescue 9.00, you can find a general autorun log file in
`/var/log/sysrescue-autorun.log` to determine what has gone wrong. Use this log
file if you have a general autorun issue, for example if your script has not
been executed. The autorun output is also logged to the systemd journal.

Each autorun script additionally creates its own log file and a file with the returncode in `/var/autorun/log`.
Use these logs to investigate issues affecting a particular autorun script.

For debugging it can be helpful to rerun autostart later when the system is already running. You can do this by calling `/etc/systemd/scripts/sysrescue-autorun`.
