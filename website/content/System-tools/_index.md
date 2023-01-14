+++
weight = 130
title = "System tools"
nameInMenu = "System tools"
draft = false
+++

This page tells you more about the important programs which comes with this
system rescue distribution, and which tools can be used for common tasks. Please
use the **man** command in a terminal to get more details about these programs.

## Packages
As SystemRescue is based on ArchLinux you can use the **pacman** command to
install additional packages using a command such as `pacman -Syu <package>`.
You can find more details about using pacman on SystemRescue at
[Installing additional software packages with pacman](/manual/Installing_packages_with_pacman/)

## Storage and disk partitioning

* You can run **lsblk** and **blkid** in the terminal to identify block devices
* **GParted** is a graphical partition editor which displays, checks, resizes,
copies, moves, creates, formats, deletes, and modifies disk partitions.
* **GNU Parted** can also be used to manipulate partitions and it can be run
from the **parted** command in the terminal.
* **GNU ddrescue** can copy data from and to block devices just like the
standard **dd** program and it is optimized to deal with disks with bad blocks.
* **fsarchiver** and **partclone** allows you to save and restore the contents
of file systems to/from a compressed archive file. It needs to be run using the
command line from the terminal.
* You can use **fdisk**, **gdisk** and **cfdisk** to edit MBR and GPT partition
tables from the terminal
* **sfdisk** is a tool to save and restore partition tables to/from a file.
* You can use **growpart** in order to grow a partition so it uses all the space
available on the block storage. You normally need this command after you have
extended the disk of a virtual machine and need to make the additional space
usable.
* The **lvm** package provide all tools required to access Linux logical volumes
* Use **qemu-img** and **qemu-nbd** to access, convert and mount disk images in
common virtualization formats like qcow2, vhdx and vmdk

## Network tools

* You can configure the network (Ethernet or wifi) very easily using the
**Network-Manager** icon located next to the clock at the bottom of the screen.
* You can also configure the network using traditional Linux commands from a
terminal. The following commands are available: **nmcli**, **ifconfig**, **ip**,
**route**, **dhclient**.
* You can use **tcpdump** if you need to see network packets being transmitted.
* Both **netcat** and **udpcast** allow to transfer data via network connections.
* You can connect to VPNs using **OpenVPN**, **WireGuard**, and **openconnect**

## File system tools

* Tools for the most common linux file systems are included and allow you to
create new file systems, or administrate these (check consistency, repair,
reisize, ...). You can use **e2fsprogs**, **xfsprogs**, **btrfs-progs**, ...
* You can use **ntfs-3g** if you need to access NTFS file systems and
**dosfstools** if you need to work with FAT file systems.

## Web Browsers and Internet

* **Firefox** is available via an icon in the taskbar if you need to search for
additional information from internet while you are using SystemRescue.
* You can also use **elinks** from a terminal if you prefer a text mode browser
* Both **curl** and **wget** allow you to download files from the command line
* The **lftp** program can be run from a terminal if you need an FTP client

## Remote control

* You can run an **OpenSSH client** by using the **ssh** or **sftp** commands
from a terminal
* You can also connect from another machine to the **OpenSSH server** running
on SystemRescue via the **sshd** service. You will need to set a root password
and update firewall rules to be able to connect.
* You can run **Remmina** from the menu if you need to connect to another
machine via VNC or NX, and you can run **rdekstop** from a terminal in order to
connect to remote Windows machines over RDP.
* You can use **screen**, **minicom** or **picocom** in order to connect to a
serial console.

## Security

* **GnuPG** is the most common command to perform encryption and decryption of
files. It can be executed via the **gpg** command from a terminal.
* **KeepassXC** is a very good tool for securely storing your passwords in a
file which is encrypted using a master password.
* The **cryptsetup** command is available if you need to access Linux encrypted
disks.
* The **chntpw** command can be used to reset Windows passwords by accessing the
disk where Windows is installed.

## Recovery tools

* **testdisk** is a popular disk recovery software. It recovers lost partitions
and repairs unbootable systems by repairing boot sectors. It can also be used to
recover deleted files from FAT, NTFS and ext4 filesystems.
* **photorec** is a data recovery software focused on lost files including
video, photos, documents and archives.
* **whdd** is another diagnostic and recovery tool for block devices

## Secure deletion

Both **wipe**, **nwipe** and **shred** are available if you need to securely
delete data. Be careful as these tools are destructive.

## File managers

* **Midnight Commander** is a text based file manager that you can run from the
terminal using the **mc** command. It is very convenient to manipulate files
and folders.
* **Thunar** is a graphical file manager provided as part of the XFCE environment.

## Hardware information

* The **lspci** and **lsusb** commands are useful to list PCI and USB devices
connected your your system, and they can display the exact hardware IDs of these
devices that are used to find the right drivers.
* The **lscpu** command displays information about the CPU.
* The **hwinfo** and **inxi** commands can be run from the terminal and will display a detail
report about the hardware.

## Hardware testing

* You can run **Memtest86+** from the boot menu, both in BIOS/Legacy and UEFI mode.
* You can also run the **memtester** command from within SystemRescue if you want to test your
system memory. But since it is running from within Linux it can't test all memory, as the
kernel will reserve some amount for itself.
* The **stress** commmand can be used from a terminal in order to stress tests
your system (CPU, memory, I/O, disks)

## Boot loader and UEFI

* The **Grub** bootloader programs can be used if you need to repair the boot
loader of your Linux distribution.
* You will need **efibootmgr** if you want to change the definitions or the
order of the UEFI boot entries on your computer.

## Text editors

* You can use graphical text editors such as **featherpad** and **geany**
* You can use text editors such as **vim**, **nano** and **joe** from the
terminal
* If you need an hexadecimal editor then you can use either **ghex** which has
a graphical user interface or **hexedit** from the terminal

## Archival and file transfer

* The **tar** command is often used to create and extract unix file archives
from the command line.
* The system comes with all the common compression programs such as **gzip**,
**xz**, **zstd**, **lz4**, **bzip2**
* You can also use the **zip** and **unzip** commands for manipulate ZIP archives
* Also **p7zip** is available using the **7z** command in the terminal if you
need to work with 7zip files.
* The **rsync** utility is very powerful for copying files either locally or
remotely over an SSH connection. You can also use **grsync** if you prefer a
graphical interface.
* **rclone** allows to transfer and sync files to or from a wide variety of 
network and cloud storage systems, including S3, Ceph and WebDAV.

## CD/DVD utilities

* You can use CD/DVD command line utilities such as **growisofs**, **cdrecord**
and **mkisofs** if you need to work with ISO images and need to burn CD/DVD
medias from the system. Also **udftools** are available to manipulate UDF
filesystems.

## Scripting languages

* You can use **bash** for running scripts as well as **Perl**, **Python** and
**Ruby** dynamic languages which are all available.

## Miscellaneous

* **flashrom** is an utility for reading, writing, erasing and verifying flash ROM chips
* **nvme** is a tool for manipulating NVM-Express disks.
