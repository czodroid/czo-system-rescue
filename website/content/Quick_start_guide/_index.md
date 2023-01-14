+++
title = "Quick Start Guide"
draft = false
aliases = ["/Quick-start-guide_EN"]
+++

## About
This Quick Start Guide discusses things you need to know to use SystemRescue.
Read the [manual](/manual/) for more information. It is highly recommended to
read the [book](/Books/) if you are new to this project or if you need a
step-by-step guide to start.

## Downloading and writing a DVD
First download the ISO file for your architecture. Most people use the x86
edition that supports 64bit (AMD64 / EM64T) processors. Once you have downloaded
the ISO image file, check the checksum. Next write a DVD-ROM using the ISO file
as an ISO image or install SystemRescue from the ISO image to an USB stick.
Read [Downloading and burning](/manual/Downloading_and_burning/) for more details.

## Booting from SystemRescue
Insert the SystemRescue device and boot your system. Keep the default boot
entry or choose an alternative option from the list. You can press TAB to modify
the boot options if you are booting in BIOS mode (blue screen), or you have to
press <code>e</code> if you are booting in UEFI mode (black screen).

You may want to add boot options such as <code>copytoram</code> to copy the
system to RAM or <code>setkmap=uk</code> to select a keyboard layout. Use spaces
between options. Finally press Enter when you are ready to boot. Additional
options are at documented on the following page:
[Booting SystemRescue](/manual/Booting_SystemRescue/)

### Main boot options
Here are the most common boot options:

* **copytoram**: copy the files to RAM, which allows the SystemRescue boot
  device to be removed after boot time. Programs will also load faster.
* **setkmap=xx**: Specify keyboard: 'us' for USA, 'uk' for british, 'de' for
  german, ...

### Additional Programs
Some additional programs are also included on the media, such as memtest to run
a memory test.

## Working in the console mode
Mount partitions in order to troubleshoot a Linux or a Windows system installed
on your disk. You can mount linux filesystems (ext4, xfs, btrfs, reiserfs)
and FAT and NTFS partitions used by MS Windows using ntfs-3g with a command such
as <code>mkdir /mnt/windows ; ntfs-3g /dev/sda1 /mnt/windows</code>). You can
backup/restore data or operating system files.

Midnight Commander (type <code>mc</code>) is able to copy/move/delete/edit files
and directories. The <code>vim</code> and <code>nano</code> editors can be
used to edit files. Read the list of the main
[system tools you can use](/System-tools/) and the documentation related to
these programs.

Six virtual consoles are available. Press <code>Alt+F1</code> for the first
virtual console, <code>Alt+F2</code> for the second one, ...

## Working in the graphical environment
If you need graphical tools you can start the graphical environment by typing
<code>startx</code>. The graphical environment allows you to work with GParted
(partition manager), to use graphical editors such as Geany or Featherpad, to
browse the web and use terminals such as <code>xfce-terminal</code>.

## Setting up your network
SystemRescue can connect you to your network. This functionality allows you
to make a backup over the network, download files, work remotely using ssh
or access files that are shared on a Unix server (with NFS) or on a MS Windows
system (with Samba).

The most convenient way to configure your network is to use the Network-Manager
service. It provides a very user friendly graphical tool to configure the
network. It makes the network configuration much easier especially if you are
attempting to connect to wireless networks. This tool is available as a small
icon in the task bar next to the clock when you are in the graphical environment.

If you want to configure the network by hand you can use command line tools such
as <code>ifconfig</code> or <code>dhclient</code> but you may have to stop the
Network-Manager service first using <code>systemctl stop NetworkManager</code>

If your system has supported hardware, the network interface card (NIC) was
auto-detected, and the driver loaded. The interface needs to be assigned an
IP address and a default gateway.

More information is available at the
[page about the network](/manual/Network_configuration_and_programs/).
