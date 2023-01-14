+++
weight = 140
title = "Installing SystemRescue on a USB memory stick"
nameInMenu = "Bootable USB"
draft = false
aliases = ["/Sysresccd-manual-en_How_to_install_SystemRescueCd_on_an_USB-stick",
           "/Installing-SystemRescueCd-on-a-USB-stick"]
+++

This page explains how to install SystemRescue on a USB stick. All data on the
memory stick will be deleted so make sure it does not contain any important data.

You need a recent SystemRescue, and a USB stick with enough capacity. You
should use a 2GB memory stick or anything larger. You will have to get your
firmware (BIOS/UEFI) to boot from the USB device before it attempts to boot from
the local disk. This can be configured either in the firmware settings or by
pressing a key at boot time.

This page describes multiple approaches available for installing the .iso-file
you [downloaded](/Download/) onto such a USB stick and making it bootable.

-------------------------------------------------------------------------------------

## On Windows

### Rufus: Recommended USB installation method on Windows

If you are running Windows on your computer the recommended installation program
is [Rufus](https://rufus.ie/) as it is easy to use and creates writable filesystems.

* **Download** [Rufus](https://rufus.ie/) and install it on Windows
* **Plug in your USB-stick** and wait a few seconds to allow enough time for the system to detect it
* **Execute Rufus** and select the USB stick in the drop-down list
* **Select the SystemRescue ISO image** that you have downloaded
* **Select 'MBR' partition scheme** as it will be compatible with both BIOS and UEFI
* **Select 'BIOS or UEFI' in target** to get the best compatibility
* **Check the 'volume label' is correct** as it must be set to <code>RESCUEXYZ</code> (cf below)
* **Select FAT32 filesystem** as the UEFI boot process only works from FAT file systems
* **Click on the start button** and wait until the operation is complete
* **Choose the 'ISO mode' when prompted** so you get a writable file system

In the previous steps `RESCUEXYZ` refers to the version number, eg: `RESCUE803`
for SystemRescue-8.03. Rufus should automatically use the label which was set
on the ISO filesystem and hence it should set this label automatically on the
USB device. You should not have to change it but you should make sure the label
is correct as this is required for the device to start properly. What matters is
that the label matches the value passed to the `archisolabel` boot option in the
boot loader configuration files on the device (`grubsrcd.cfg` and
`sysresccd_sys.cfg`) so files can be found at the time the system starts from
the USB device.

When using rufus this way, a USB memory stick with a **writable filesystem** is created. This allows
you to easily copy for example autorun scripts or YAML config files onto the USB stick with
a regular file manager.

### Fedora Media Writer

This is an alternative if Rufus doesn't work for some reason.

* [Download Fedora Media Writer](https://github.com/FedoraQt/MediaWriter/releases)
* **Plug in your USB-stick** and wait a few seconds to allow enough time for the system to detect it
* **Execute Fedora Media Writer** and `Select .iso file` in the first menu
* **Select the SystemRescue ISO image** that you have downloaded
* **Select the USB-stick** you want to install on
* Start writing

Fedora Media Writer only creates a **read-only filesystem**. This doesn't allow
you to easily modify the YAML config files or add autorun scripts.

-------------------------------------------------------------------------------------

## On Linux

## SystemRescue USB writer: Recommended USB installation method on Linux

The recommended tool for installing SystemRescue to a memory stick on Linux
is [SystemRescue USB writer](https://gitlab.com/systemrescue/systemrescue-usbwriter).
It runs as a text-UI (or optionally, pure cli) program and is distributed
as AppImage. This means it can be easily run on most Linux systems without dealing
with dependency issues or similar.

* [Download the latest release](https://download.system-rescue.org/usbwriter/1.0.1/sysrescueusbwriter-x86_64.AppImage)
* [Download the checksum file](/usbwriter/1.0.1/sysrescueusbwriter-x86_64.AppImage.sha256) and verify the authenticity with `sha256sum --check sysrescueusbwriter-x86_64.AppImage.sha256`
* Mark it as executable with `chmod 755 sysrescueusbwriter-x86_64.AppImage`
* Run it `./sysrescueusbwriter-x86_64.AppImage [OPTIONS] <ISO-FILE>`
* It will show viable USB devices to select from 
* If you don't have enough permissions to write to the USB media, it will try `sudo`, `pkexec` and `su`

All options and details are explained on [it's homepage](https://gitlab.com/systemrescue/systemrescue-usbwriter).
Also look there in case you have any issues running it as some distribution specific requirements
and tips are explained there.

SystemRescue USB writer creates a USB memory stick with a **writable filesystem**. This allows
you to easily copy for example autorun scripts or YAML config files onto the USB stick with
a regular file manager.

## usbimager

If SystemRescue USB writer doesn't work for you, you can use 
[usbimager](https://gitlab.com/bztsrc/usbimager/) as alternative. It can be
[downloaded](https://gitlab.com/bztsrc/usbimager/-/releases) and executed without installation. 
The archive can be extracted using `unzip` and the program must be run via `sudo` so it can write to the memory stick device.
This program is very simple to use as you just need to select the ISO image and
the destination removable device using the graphical interface.

usbimager only creates a **read-only filesystem**. This doesn't allow
you to easily modify the YAML config files or add autorun scripts.

## Fedora Media Writer

This is an alternative if SystemRescue USB writer doesn't work for some reason.

* **Install flatpak** using the official package from your Linux distribution (dnf, apt, pacman, etc)
* **Install Fedora Media Writer** using flatpak as documented on [flathub](https://flathub.org/apps/details/org.fedoraproject.MediaWriter)
* **Plug in your USB stick** and wait a few seconds to allow enough time for the system to detect it
* **Execute Fedora Media Writer** and `Select .iso file` in the first menu
* **Select the SystemRescue ISO image** that you have downloaded
* **Select the USB-stick** you want to install on
* Start writing

Fedora Media Writer only creates a **read-only filesystem**. This doesn't allow
you to easily modify the YAML config files or add autorun scripts.

## dd

This is a minimalist approach with a tool that is already installed on most Linux systems: `dd`.
Make sure you use the right device with dd as the operation is
destructive if you write to the wrong device.

* **Plug in your USB stick** and wait a few seconds to allow enough time for the system to detect it
* **Unmount the USB stick** if auto-mount is enabled or if it was already mounted
* **Run <code>lsblk</code>** in a terminal to identify the device name for your USB device
* **Run <code>sudo dd if=/path/to/systemrescue-x.y.z.iso of=/dev/sdx status=progress</code>** where `/dev/sdx` is the USB stick

dd only creates a **read-only filesystem**. This doesn't allow
you to easily modify the YAML config files or add autorun scripts.

## Alternative USB installation method using Ventoy for Multiboot

Another approach to install Systemrescue makes use of the software [Ventoy](https://www.ventoy.net/en/index.html). Ventoy allows you to create a bootable multi ISO USB drive without the need to reformat every time you want to use a different ISO.

- **Make sure to backup** the contents of your USB stick, before formatting it, if there is any important data.
- **Format your USB drive**.
- **Install Ventoy on your USB drive** according to this [manual](https://www.ventoy.net/en/doc_start.html) either on Linux or Windows. 
- **After installing Ventoy on your USB drive simply place the Systemrescue ISO inside the first partition.** Ventoy will automatically find the ISO and list it for boot if you insert the USB drive for booting.

You can also place the 32 and 64 bit version together on the USB drive, so you can choose between the necessary architecture without the need to reformat. 
