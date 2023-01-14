+++
title = "Configuring SystemRescue"
draft = false
+++

## Overview
SystemRescue comes with options which allows users to change the way it runs.
For example, there are options for controlling which keyboard of layout to use,
whether the system must be run from memory or from the boot device, whether or
not to automatically start the graphical environment, and so on. You can follow
the link to see the list of [boot options](/manual/Booting_SystemRescue/)
which are supported on the command line.

These options are set on the boot command line. To change these options, you can
either manually edit the boot command line from the boot loader at run time, or
you can make the changes persistent by editing the configuration file of the
boot loaders, which are either isolinux if you start in BIOS mode or Grub if you
start in UEFI mode.

## Configuration features
Since SystemRescue version 9.00 there is another way to configure SystemRescue.
You can now edit YAML files on the boot device in order to configure it. This
way of configuration has been introduced to make it easy to make persistent
configuration changes, and these options are effective for both the BIOS mode
and UEFI mode.

The SystemRescue configuration YAML files are located in the `sysrescue.d`
folder located on the boot device.

SystemRescue comes with a default YAML configuration file, so it provides a good
example of such a file, which you can use as a starting point. You can edit it
to replace the options with your own preferences.

## Scopes

These yaml configuration files support multiple scopes. The main scope is called
`global` and is contains general configuration entries. Nearly all entries in the global
scope have boot commandline options of the same name and are documented in 
[Boot options](/manual/Booting_SystemRescue/).

The `autorun` scope is used to define configuration entries which are used by
[autorun](/manual/Run_your_own_scripts_with_autorun/) and are documented there.

The `autoterminal` scope is used to define configuration entries which are used by
[autoterminal](/manual/autoterminal_scripts_on_virtual_terminal/) and are documented there.

The `sysconfig` scope is used to define certain aspects of system configuration.
You can find more information about the entries at
[sysconfig](/manual/Configuring_SystemRescue_sysconfig/).

## Configuration entries
Below is an example of a valid yaml configuration file. In this example there
are entries in both the `global`, `autorun`, and `sysconfig` scopes. The
`copytoram` option is enabled so the system is fully copied to memory at boot
time, the `checksum` option is also enabled so the system checks its integrity
at boot time, as well as the `dostartx` option in order to automatically start
the graphical environment. Both the `nofirewall` and `loadsrm` options are left
disabled, so the firewall will not be turned off and SRM modules will not be loaded.
The `setkmap` option is used to configure a french keyboard layout. All these
general options belong to the `global` scope.

```
---
global:
    copytoram: true
    checksum: true
    nofirewall: false
    loadsrm: false
    late_load_srm: "https://example.com/myconfig.srm"
    setkmap: "fr-latin1"
    dostartx: true
    dovnc: false
    rootshell: "/bin/bash"
    rootcryptpass: "$6$Y.AolXkpG/Js2Zqx$z7J893qtB7jKn3z39ucbgvpkJ6wTrJ8N0CBVr5cJ.uXugGTMTSjMI7qsSTu4UTFGGKpGyEG/BnYNRE6oZFO4b0"
    rootpass: "MyRootPassword123"
    vncpass: "MyVncPassword456"

autorun:
    ar_disable: false
    ar_nowait: false
    ar_nodel: false
    ar_attempts: 1
    ar_ignorefail: false
    ar_suffixes: "0,1,2,3,4,5"

autoterminal:
    tty2: "/usr/bin/tmux"
    
sysconfig:
    ca-trust:
        example-ca: |
            -----BEGIN CERTIFICATE-----
            MIIDlTCCAn2gAwIBAgIUbB4K7H53E3spHfMtSb0To+Fyb3wwDQYJKoZIhvcNAQEL
            BQAwWjELMAkGA1UEBhMCWFgxFTATBgNVBAcMDERlZmF1bHQgQ2l0eTEcMBoGA1UE
            [...]
            VtbLuXNBNjfcAk1xqTb1j9dMeHDZKV4Imr0W3qfsHnWFqihxGyKJ79Qb2bL1Kquc
            vgI/6+yHyDlw
            -----END CERTIFICATE-----
```

## Status of this feature
At this stage only some options are supported in the configuration file. The plan is
to add support for more options or services in the future. Also you
can take advantage of this mechanism and use these yaml configuration files to
configure your own scripts that are executed from SystemRescue. You should
create new scopes in your configuration files if you plan to do so.

These features are relatively recent, so it is recommended you use the very
latest version of SystemRescue in order to benefit from the latest features
and bug fixes related to the way support for the configuration is implemented.

The way YAML configuration files are loaded changed with SystemRescue
Version 9.03. Versions 9.00 to 9.02 did only implement partial merging and when the
`sysrescuecfg` option was used, only the files given were loaded.

## Configuration file merging and order
To be able to configure SystemRescue using YAML configuration files, you
either edit the existing YAML file located in `sysrescue.d` on the boot device, or
create additional YAML files in the same location. Files must have a `.yaml` extension 
(not `.yml`), otherwise the file will be ignored. Also make sure you follow the yaml 
syntax correctly. Key and values are separated by colons, not equal signs, and the 
indentation is very important.

The system reads all files with a `.yaml` extension located in the `sysrescue.d`
folder on the boot device in lexicographic order. **Files loaded later are
merged with the previous ones, overwriting already configured individual options.**
When a later loaded file contains an empty option, it is removed from the final
config and not just overwritten with an empty value.

Files provided by SystemRescue have a name starting with a number to make ordering
more explicit. It is recommended to follow that practise for additional files too.

For example if you have the file `100-defaults.yaml`:
```
---
global:
    nofirewall: false
    dovnc: false
    setkmap: "fr-latin1"
```
and the file `200-my-options.yaml`:
```
---
global:
    nofirewall: true
    setkmap:
```
the `nofirewall` option will be `true`, `dovnc` will be `false` and no config
entry will exist for `setkmap`.

After all files in the `sysrescue.d` dir are read and merged, the system looks
for the `sysrescuecfg` option on the boot command line. You can add more
YAML files to be loaded and merged with that option. 

The `sysrescuecfg` option allows using HTTP and HTTPS URLs for loading remote files. 
When using HTTPS, **no certificate check is done**, as the CA trust database 
is not set up yet during the initramfs boot phase when the YAML files are evaluated.

Alternatively you can specify absolute and relative paths. Relative paths are relative to the
`sysrescue.d` dir on the boot device. If a given path points to a directory, all
`.yaml` files in this directory are loaded and merged in lexicographic order. This
could be used for example to load YAML files from different subdirectories of
`sysrescue.d`. You can specify the `sysrescuecfg` option multiple times on the boot
command line.

After the YAML files are loaded and merged, options on the boot command line are
evaluated. See [boot options](/manual/Booting_SystemRescue/). The options
on the boot command line take precedence over what is configured in the YAML files.

## Storing YAML configuration files

The easiest method to get your configuration files onto a SystemRescue media is usually to 
create a writable USB boot media for SystemRescue. This can be done with
Rufus or SystemRescue USB writer [as described here](/Installing-SystemRescue-on-a-USB-memory-stick/).
You can mount the USB media afterwards and copy the configuration files into
the `sysrescue.d` directory using a regular file manager.

If you install SystemRescue on a USB stick using either `dd` or any other tool 
which performs a physical copy of the ISO image, it will not produce a writable 
file system, and you will not be able to edit the configuration file on the device.

If creating a writeable USB media is not possible, you can modify the ISO image
with [sysrescue-customize](/scripts/sysrescue-customize/).

## Implementation details
Support for options located in the YAML configuration file are implemented in
multiple places:

The bulk of the processing of the configuration is implemented in the following script:
[sysrescue-configuration.lua](https://gitlab.com/systemrescue/systemrescue-sources/-/blob/main/airootfs/usr/bin/sysrescue-configuration.lua).
This script is run during the initramfs boot phase and processes the yaml configuration 
files available on the local boot device, as well as the options specified on the boot 
command line, and it determines the "effective" configuration. This is a single JSON file, stored in
`/run/archiso/config/sysrescue-effective-config.json`, which contains a single definition
of each supported option and allows various programs to determine which value is
applicable for a particular option, without having to process all possible sources
of configuration. Multiple scripts such as `sysrescue-initialize` and `sysrescue-autorun`
use the effective configuration file to determine what to do. Python scripts have
built-in support for reading JSON files. Shell script can use the standard `jq`
command to read values from this JSON file.

The lua library used to read the YAML files and process them into a JSON file
puts some restrictions on the supported YAML syntax and types. For example all 
numeric values are converted to floating point by lua and written out that way
into the JSON.

When adding new values it is recommended to use list structures very carefully, 
because there is no obvious semantics to merge them. New list values currently 
overwrite values at the same position when merging multiple files. Using dictionary 
structures that are then evaluated with their keys in lexicographic order is the 
preferred way instead. This allows full merging and targeted removal of previous entries.

Some [archiso hooks](https://gitlab.com/systemrescue/systemrescue-sources/-/blob/main/patches/archiso-v43-07-yaml-config.patch)
read the effective configuration to determine the values for options such as
`copytoram`, `checksum` and `loadsrm` which must be used at an early stage
during the boot process, as part of the initramfs.

The sysrescue-initialize script script also uses the effective configuration to determine 
how the system should be initialized, in the later stage of the boot process. It is divided
into two parts: 
[sysrescue-initialize-prenet](https://gitlab.com/systemrescue/systemrescue-sources/-/blob/main/airootfs/etc/systemd/scripts/sysrescue-initialize-prenet) and
[sysrescue-initialize-whilenet](https://gitlab.com/systemrescue/systemrescue-sources/-/blob/main/airootfs/etc/systemd/scripts/sysrescue-initialize-whilenet). 
The first is executed before setting up networking is begun and configures things like 
firewalling, the latter is executed in parallel to networking being set up.

