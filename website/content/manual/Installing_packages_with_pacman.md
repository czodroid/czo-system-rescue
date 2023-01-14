+++
title = "Installing additional software packages with pacman"
draft = false
+++

To keep it lightweight and fast, SystemRescue just comes with software that is 
directly related to the goals of diagnosing and fixing system problems. But 
additional programs can easily be installed from the repositories provided by 
Arch Linux.

## pacman Basics

pacman is the program used for installing and managing packages. Before using 
it, you have to download a copy of the package repository database, so that 
pacman knows which packages are available and how they relate to each other.

This can be done like this (requires Internet access): `pacman -Sy`

Afterwards you can download and install new packages like this: 
`pacman -S <package name>`

Keep in mind that it may require a lot of space in the writable layer (stored in 
memory by default) to download and install additional packages. So it can fail 
if too many packages are requested.

## Searching

When you don't know the exact name of a package you want to install, you can 
search for text parts in the package name and description: 
`pacman -Ss <search string>`

Once you know the package name, you can get more information about a not yet 
installed package like this: `pacman -Si <package name>`

You can also search for packages that provide a given filename. You have to 
download the separate files database first: `pacman -Fy` Afterwards you can 
search for packages by filename: `pacman -F <filename>`

## Snapshot vs. Rolling

SystemRescue from Version 8.07 onwards by default accesses the repositories in a 
state frozen at the moment of the SystemRescue release. This is done to prevent 
huge downloads due to dependencies and conflicts. This is called the *snapshot* 
configuration of pacman. It is implemented by using the 
[Arch Linux Archive](https://wiki.archlinux.org/title/Arch_Linux_Archive)
from the release date.

Arch Linux in contrast has a rolling release scheme where even older 
installations always get the newest packages. This can also be accessed from 
SystemRescue by activating the *rolling* configuration of pacman.
 
## Changing to Rolling configuration

Both configuration variants of pacman are installed in parallel. You can change 
to the rolling variant on a per-command basis with the `--config` parameter: 
`pacman --config=/etc/pacman-rolling.conf <pacman command>`

Both configurations have separate remote repository databases. So you have to 
download them for the rolling config before you can use it: 
`pacman --config=/etc/pacman-rolling.conf -Sy`
 
You can also permanently change to the rolling configuration by pointing the 
symlink `/etc/pacman.conf` to `/etc/pacman-rolling.conf`.

Be extra careful when using the rolling configuration though. You can accidently 
render your system unstable for example by updating the Linux kernel package. 
Then the modules won't match the running kernel anymore. Updates like this don't 
necessarily need to be done on purpose, but could come through a dependency from 
installing or updating another package.
 
## Repositories

Arch Linux provides several different repositories. SystemRescue only has the 
official repositories `core`, `extra` and `community` preconfigured.

You can configure more 
[Official](https://wiki.archlinux.org/title/Official_repositories) and 
[Unofficial](https://wiki.archlinux.org/title/Unofficial_user_repositories) 
repositories. But be aware that other repositories often will conflict with the 
default snapshot configuration.

You can search for packages here: https://archlinux.org/packages/

If some software is not packaged in any of these repositories, it could be
available in [Arch User Repository (AUR)](/manual/Installing_packages_from_AUR/).

## Signing key expiry

Arch Linux (and thus SystemRescue) uses GnuPG and a web of trust to sign packages and verify package authenticity.
Some of the keys used have a defined expiration date. This can lead to problems when using
the snapshot configuration and a key used to sign a package or in the trust path has expired since your version
of SystemRescue was released.

The error message will look like this:
```
error: foobar: signature from "John Doe <john@example.com>" is unknown trust
:: File /var/cache/pacman/pkg/foobar-1.2-3-x86_64.pkg.tar.zst is corrupted (invalid or corrupted package (PGP signature)).
Do you want to delete it? [Y/n] 
```

SystemRescue contains a wrapper called `pacman-faketime` since version 9.06. This can be called instead
of `pacman` and makes pacman think the current date is the original release date of your version of SystemRescue.
Since the key wasn't expired at that date, the key verification passes.

An alternative workaround for this problem is to update the trust database of SystemRescue
to the current one from the rolling Arch Linux release:
```
pacman --config=/etc/pacman-rolling.conf -Sy archlinux-keyring
```
This is the recommended way when using the rolling configuration. But be aware that using 
`pacman-faketime` will most probably not work as expected anymore and some packages from the
snapshot config may always show signature errors.

Since the changed date also affects the validity period of SSL/TLS certificates used for downloading,
`pacman-snapshot.conf` is configured to call curl wrapped in faketime again to restore the original
date. While this approach solves the problem, faketime shows a warning message on each download:
```
faketime: You appear to be running faketime within a libfaketime environment. Proceeding, but check for unexpected results...
```

There also is the sledgehammer solution: set `SigLevel = Never` in `/etc/pacman-snapshot.conf`. This works around the problem,
but also destroys any hope of blocking tampered packages. So this is not recommended.

## More information

You can find more information about pacman and it's usage at 
https://wiki.archlinux.org/title/pacman
