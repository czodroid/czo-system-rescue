+++
title = "Configuring SystemRescue: `sysconfig` scope"
draft = false
+++

This chapter explains the options available in the `sysconfig` scope of the 
[YAML config files](/manual/Configuring_SystemRescue/) for System Rescue. See
there for details where to place the YAML files and how they are interpreted.

## Synopsis
```
---
sysconfig:
    authorized_keys:
        "user@example.com": "ssh-rsa AAAAB3NzaC1...kQoVPcn3jpgywi/twXcOw=="
        "other-user@example.com": "no-port-forwarding ssh-rsa ZDWo0UmISKEn...dAq33PUQh"

    bash_history:
        100: "setkmap"
        200: "reverse_ssh support.example.com 1234"

    bookmarks:
        0100:
            title: "SystemRescue"
            url: "https://www.system-rescue.org/"
        0200:
            title: "Arch Linux Package Search"
            url: "https://archlinux.org/packages/"

    ca-trust:
        example-ca: |
            -----BEGIN CERTIFICATE-----
            MIIDlTCCAn2gAwIBAgIUbB4K7H53E3spHfMtSb0To+Fyb3wwDQYJKoZIhvcNAQEL
            BQAwWjELMAkGA1UEBhMCWFgxFTATBgNVBAcMDERlZmF1bHQgQ2l0eTEcMBoGA1UE
            [...]
            VtbLuXNBNjfcAk1xqTb1j9dMeHDZKV4Imr0W3qfsHnWFqihxGyKJ79Qb2bL1Kquc
            vgI/6+yHyDlw
            -----END CERTIFICATE-----

    hosts:
        "192.168.1.1": "example.net.lan"
        "192.168.1.10": "foo.net.lan foo"

    rclone:
        config:
            arch-linux-archive:
                type: "http"
                url: "https://archive.archlinux.org/"

            my-nas:
                type: "webdav"
                url: "https://my-nas.local"
                vendor: "other"
                user: "my-login"
                pass: "9JbSJzgcQXsnV2dkzzhBR3za1e_rqixvKKp6"

    sysctl:
        net.ipv4.ip_forward: "1"
        net.ipv4.conf.all.arp_filter: "1"

    timezone: "Europe/Berlin"
```

## SSH authorized_keys
Allows to configure trusted public keys that are allowed to log in as `root` user
via SSH. These are appended to `/root/.ssh/authorized_keys`.

This option is structured as a Mapping / dictionary with the "comment" field of the
SSH authorized_keys line being the key and the beginning of the entry until the comment
being the value. Since the "comment" field is often used to designate the username or
email address of the owner, the entries are ordered by these owner names. If the file
already contains an entry with the given "comment" it is not added again.

You can use additional options for a key as documented by sshd by prepending them to the keytype. 
See for example the `no-port-forwarding` option in the synopsis above.

## Bookmarks
This option allows to configure bookmarks for the installed Firefox browser. This is
implemented via the `policies.json` file of Firefox.

This option is structured as two levels of Mappings / dictionaries. The key of the
first level is used for lexicographic ordering of the entries. Each entry must have
a `title` and `url` key.

When the `policies.json` file already contains an entry with a given `title`, the bookmark
will not be added again. Firefox was observed removing entries with duplicate URLs.

## Certification Authority (CA) trust
If you maintain one or more local Certification Authorities (CA), you can add them
as trust anchors to SystemRescue by listing them in the `ca-trust` section of the
YAML file. You must give each CA an individual name within the `ca-trust` section.
That name will be used as file name within the `/etc/ca-certificates/trust-source/anchors/`
directory. 

The configured CAs will be added to the default trust anchors of System Rescue,
which are derived from the CA list used by Mozilla.

## Timezone
Allows to configure the timezone to use. Takes a timezone name as defined in the 
[IANA Time Zone Database](https://www.iana.org/time-zones) which is used by most Linux
distributions. Default is "UTC".

## Sysctl
Allows to customize kernel parameters through the `sysctl` interface. This option is 
structured as a Mapping / dictionary with the key being the sysctl variable and the
value being the value to set. Using the pattern option of the `sysctl` program is *not*
supported, you must use explicit variable names.

It is suggested to use strings for the values in the YAML config, because numeric values
can get converted to floating point during config merge. The kernel will reject floating
point values for most variables.

## rclone
Allows to configure [rclone](https://rclone.org/). The entries below the `sysconfig.rclone.config`
key are written as sections into the file `/root/.config/rclone/rclone.conf`. To create
the sections in the correct format it is recommended to use the `rclone config` command
to configure rclone and then transfer the data from the `rclone.conf` file into the YAML config.

Be aware that rclone requires all passwords to be encoded in a proprietary, easily reversible
schema. SystemRescue will just copy the passwords and not encode or alter them, so the
YAML config must contain them already in encoded format. If an attacker can read the YAML config,
this encoding will not protect the passwords.

## bash_history
Allows to preconfigure common commands in the bash shell so that they can be accessed by 
just pressing the up arrow key or searched with ctrl+r. The Mapping / dict key is used for 
lexicographic reverse-ordering of the entries. Reverse-ordering means the lowest key will 
show up first when pressing the up arrow key.

By default the `setkmap` command is inserted in the bash_history with key `100` to allow
changing the keyboard mapping without having to type on a possibly foreign keyboard. This
is mentioned in the welcome text that is shown when logging in. Keep in mind that the welcome
text is not adapted automatically when you replace `setkmap` with another command.

## hosts
Allows to manually configure hostname/IP mappings that take precedence over DNS lookups
via the /etc/hosts file. The Mapping / dict key is the IP (IPv4 or IPv6), the value the
hostname and, optionally, alias names for it.
