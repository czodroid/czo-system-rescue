+++
title = "Backup data from an unbootable windows computer"
draft = false
aliases = ["/Sysresccd-manual-en_Backup_data_from_an_unbootable_windows_computer"]
+++

## About
This tutorial explains how you can backup the data from a Windows computer that
cannot be booted any more. There are many reasons why a windows computer could
stop working: installation of a bad driver, system crash with disk corruption,
system files deleted, ... In that case you can just reinstall the operating
system, but the most important thing is to first backup your data. If Windows is
not bootable, you can just boot using SystemRescue to do that. Even running
Linux, it's able to read the windows disk, and then you will be able to backup
your data through the network. All the steps are detailed in this tutorial so
that windows users with no knowledge of Linux can follow it to backup their data.

If this is the first time that you are using SystemRescue, it is recommended
that you read the [Quick start Guide](/Quick_start_guide/) to avoid problems.

## Overview
SystemRescue is a livecd. It contains a complete operating system based on
Linux. This means that you will be able to manipulate files from its environment
even if the Windows OS, which is installed on that computer, is broken. Of
course, you will need a working computer to download and burn SystemRescue.

* **Step-1: prepare the bootable cdrom/usb-key**
  First, you have to download and burn SystemRescue. To do that you need a
  working computer. If you can't boot SystemRescue from a cdrom, you can also
  [Install SystemRescue on an USB stick](/Installing-SystemRescue-on-a-USB-memory-stick/)
  and boot from it.
* **Step-2: get access to your windows disk**
  In this section, we will see how to read the windows disk(s) from Linux, to
  see what files can be backed up.
* **Step-3: backup your data through the network**
  If you have network access (Ethernet card and another computer to which the
  data can be copied) this section explains how to configure the network and
  copy the data to another box.
* **Step-4: reboot properly**

## Step-1: prepare the bootable cdrom or usb-key
All you have to do is to download the latest ISO image of SystemRescue for x86,
burn it onto a cdrom disc using any burning software. If the computer where
windows is broken cannot boot from a cdrom disc, you can also
[Install SystemRescue on an USB stick](/Installing-SystemRescue-on-a-USB-memory-stick/)
and boot from that.

Then, go into the BIOS of your computer (you often have to press F2 or DEL
  during the hardware initialisation period), go into the section where the boot
  order is defined, and make sure the cdrom or the USB device is the first
  device in the list (or before the hard drive).

Now, reboot with the cdrom / usb stick inserted. If it works, you should see a
SystemRescue ASCII art logo, and boot instructions. You can then just press
enter to boot SystemRescue with the default settings. If you plan to use the
network, it is recommended to boot with your network settings so that you don't
have to configure it later. To do that, just type the following line at the
prompt and press enter. Of course, you will have to replace this address with
the relevant IP address for this computer:
```
rescue64 ethx=192.168.1.158 gateway=192.168.1.254
```
The gateway address is required only if you want to connect to a computer that
is located on a different network. To use a dynamic IP address instead of a
static IP, you can type the following:
```
rescue64 dodhcp
```

Don't worry about the network settings now, you can change them later if it
fails. You can also read the chapter about the [boot options]
(/manual/Booting_SystemRescue/) to get more details about that.

## Step-2: get access to your windows disk
When the boot process is finished, you should get a black screen on which to
type commands. All the following steps will be based on commands so you may stay
in this environment. You can also run commands from a terminal in the graphical
environment if you prefer. Just type `startx` in that case.

### Detection of the disks
The first thing to do is to detect the partition where your data are located.
Linux uses names that are different from windows for the disks, so you will see
names such as `/dev/sda1`, `/dev/sda2` instead of `C:` or `D:`.
To detect the disks and partitions, just run the following command:
`fsarchiver probe simple`. You should see an output such as:

```
root@sysresccd /root % fsarchiver probe -v
[=====DEVICE=====] [==FILESYS==] [=====LABEL=====] [====SIZE====] [MAJ] [MIN]
[/dev/sda1       ] [ntfs       ] [Windows-XP     ] [    25.00 GB] [  8] [  1]
[/dev/sda5       ] [ntfs       ] [Data           ] [   120.00 GB] [  8] [  5]
[/dev/sda6       ] [ntfs       ] [Backup         ] [    70.00 GB] [  8] [  6]
```
In that example there were three partitions on the computer, you may have only
one or two partitions. The first column is very important since it is the device
name of the partition that we will need to access your data. You should write
that name on a piece of paper.

### Access to the correct partition
Now we will have to make this data accessible from the system. Let's consider
that you want to backup the data located on the disk called `/dev/sda1`. The
first thing to do is to mount the partition to a directory. This only means that
this directory will contain a view of your disk, nothing will be written to it:
```
ntfs-3g -o ro /dev/sda1 /mnt/windows
```
The only option which is used here is `ro`, it means that the data on the
disk are mounted with read-only access. We just use this option to make sure we
can't make any errors that could destroy this data, but you can mount the disk
with full read-write access if you prefer (just remove that option from the
command). Now, let's see the contents of the partition:
```
cd /mnt/windows
ls -l
```
You should see something like this:
```
root@sysresccd /mnt/windows % ls -l
total 132856
-r-------- 1 root root      245 2008-08-05 19:36 boot.ini
dr-x------ 1 root root     4096 2008-07-02 07:34 cygwin
dr-x------ 1 root root     4096 2007-10-23 21:18 Documents and Settings
-r-------- 1 root root    47772 2005-03-25 12:00 NTDETECT.COM
-r-------- 1 root root   297072 2007-10-21 18:50 ntldr
-r-------- 1 root root 16777216 2008-09-22 16:41 pagefile.sys
dr-x------ 1 root root     4096 2008-08-10 19:07 Program Files
dr-x------ 1 root root        0 2008-07-02 07:45 RECYCLER
dr-x------ 1 root root     4096 2007-10-21 17:59 System Volume Information
dr-x------ 1 root root    32768 2008-08-29 22:48 WINDOWS
```

If you want to browse your data, it's recommended to use Midnight Commander.
Just type `mc` in the console to get it. It's a very intuitive tool similar
to Norton Commander that can be used to browse your disk. It can also be used to
copy, move, rename files and directories using the function keys. Press F10 to
exit from Midnight Commander.

## Step-3: backup your data through the network
There are multiple ways to backup your data. Using the network is recommended
since it's quick and it's only limited by the amount of space there is on the other computer. The basic network configuration is not complex under Linux if you have an ethernet card.

### Configuration of the IP network
First, let's check which cards are detected. There is no driver to install.
Linux comes with all the network drivers by default. The ethernet cards are
called `eth0`, `eth1`, `eth2`, ... under Linux. If you just have one
card it will be `eth0`. If you have more that one card, keep in mind that
the first one may not be the one that you expect. In that case you can just
configure all the cards with the IP address and it should work. Type the
following command:
```
ifconfig -a
```
You should see a screen such as:
```
root@sysresccd /mnt/windows % ifconfig -a
eth0      Link encap:Ethernet  HWaddr 00:18:f3:ce:0e:36
          inet addr:192.168.1.158  Bcast:192.168.1.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Interrupt:16 Base address:0xe000
```

If the IP address is not yet configured, you can set a static IP address (and a
```
gateway if required) as follows:
ifconfig eth0 192.168.1.158 netmask 255.255.255.0
route add default gw 192.168.1.254
```
To get a dynamic address via DHCP, just give the command:
```
dhclient eth0
```

### Configuration of the SFTP server
In this section we will consider that the broken computer is using 192.168.1.158
and the computer to which you want to copy the data is 192.168.1.20.

Multiple protocols can be used to transfer your data. In this tutorial we will
use the SCP/SSH protocol for several reasons:

* it uses only a single TCP connection on port 22 which is easier to configure
  than FTP which requires two connections to work
* it's reliable, and it's encrypted so there is no risk to your data if you
  don't trust the people connected to your local network.
* it's very easy to configure on the client and server side (samba can be used
  to share your files but the configuration may be tricky)

The broken computer runs an OpenSSH server which means another computer can
connect to it using port tcp/22 as long as it knows the password. The computer
to which the data will be copied will have to run an SFTP client. We recommend
Filezilla-client which is a very good free and multiplatform FTP/SFTP client.
you can use it exactly as any other FTP client except the protocol will be SFTP.
You could also use WinSCP if you prefer.

Now, we will have to set the password on the server side (on linux) so that we
can connect from the other end. Just type the following command, and type the
password twice (it won't be displayed on the screen for security reasons):
```
passwd
```

### Configuration of the SFTP client
Now the server is ready, you can go to the other computer (which is working),
install Filezilla-client to it (Filezilla works on Windows and Linux), and do this:

* click on File/Site-manager in the menu bar
* click on new-site to create a new connection
* fill the dialogue window with the following information:
  * Host: 192.168.1.158 (IP address of the computer running SystemRescue)
  * Port: 22
  * Server type: SFTP (SSH File Transfer Protocol)
  * Longon type: Normal
  * Login: root
  * Password: type the password you typed in the previous step.
  * Click on "Advanced"
  * Default Directory: /mnt/windows
* Now click on connect

You should now be connected to the OpenSSH server running on SystemRescue,
and you should see the local disk on one side of the window, and the remote
disk on the other side. If you don't see your remote files, you have to go into
the directory `/mnt`, and then into `windows` .

## Step-4: reboot your computer
When you have finished using SystemRescue, it's recommended to unmount your
windows partition, and then reboot the computer properly:
```
umount /mnt/windows
reboot
```
