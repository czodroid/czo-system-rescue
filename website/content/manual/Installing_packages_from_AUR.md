+++
title = "Installing additional packages from AUR with yay"
draft = false
+++

Arch Linux provides software packages with different levels of support. Core
packages receive comprehensive testing and are provided as binary packages.
These [can directly be installed with pacman](/manual/Installing_packages_with_pacman/).

More niche software is offered in the [Arch User Repository (AUR)](https://wiki.archlinux.org/title/Arch_User_Repository). AUR only contains instructions (`PKGBUILD` file) how to build a package,
the user has to compile their packages themselves. This can be automated
with helper programs like `yay`.

## AUR package list

Search the AUR package list: https://aur.archlinux.org/packages

## yay AUR helper

[yay](https://github.com/Jguer/yay) is an AUR helper program that can search
for packages in AUR, download, build and install them from the commandline. It is included in SystemRescue since version 9.05.

## SystemRescue preparation

SystemRescue just comes with software that is directly related to the goals of diagnosing and fixing system problems. To keep it lightweight and fast, components required to compile
programs are stripped out. Before a package from AUR can be compiled, these parts have
to be downloaded and (re-)installed from the Arch Linux online repositories.

Installing these packages will take over a gigabyte in Copy-on-Write (CoW) storage. CoW data
is by default stored in RAM and is by default allowed to grow up to 25% of the available RAM
(`cow_spacesize=` [boot option](/manual/Booting_SystemRescue/)). 
This can become a limitation quickly. Because of this it is
recommended to store the Copy-on-Write (CoW) data on a hard drive instead. See 
[Creating a backing-store to keep your modifications](/manual/Creating_a_backing_store/)
for details.

To prepare SystemRescue call: `yay-prepare`.

## Building packages

Search for packages with `yay <Search Term>`.

If one or more packages are found, you can directly choose to download, build and
install them.

Be careful with these steps though: Packages in AUR do not run through a peer
review process. So uploading malicious packages is possible. They can execute
arbitrary commands during build and install. So review the package source
before building and watch for comments and votes on the AUR website.

## Build Details

Building packages as root user is not advised and yay prevents it. SystemRescue
creates a dedicated user `yay` when `yay-prepare` is run. The `yay` command is
routed through a wrapper that automatically changes to the `yay` user when running
the `yay` command.

When the build is finished, you can find the packages as `*.pkg.tar.zst` files below `/home/yay/.cache/yay/`. From there you can save and reinstall them later, for example with a 
[SystemRescue Module (SRM)](/Modules/).

You can install a local `*.pkg.tar.zst` file with the command `pacman -U <filename>`.

