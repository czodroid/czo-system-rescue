+++
weight = 30020
title = "Partitions attributes"
draft = false
aliases = ["/Sysresccd-Partitioning-EN-Partitions-attributes"]
+++

## Partition identifiers

Each partition of your disk has an identifier. It's written in the
partition table which is in the MBR if it's a disk based on the standard
msdos partition table. This is just a number which says which sort of
partition it is. You can get the list of all the possible partition
identifiers that can be used in an msdos partition table by typing “L”
in fdisk under linux:

    Command (m for help): L

     0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris
     1  FAT12           39  Plan 9          82  Linux swap / So c1  DRDOS/sec (FAT-
     2  XENIX root      3c  PartitionMagic  83  Linux           c4  DRDOS/sec (FAT-
     3  XENIX usr       40  Venix 80286     84  OS/2 hidden C:  c6  DRDOS/sec (FAT-
     4  FAT16 <32M      41  PPC PReP Boot   85  Linux extended  c7  Syrinx
     5  Extended        42  SFS             86  NTFS volume set da  Non-FS data
     6  FAT16           4d  QNX4.x          87  NTFS volume set db  CP/M / CTOS / .
     7  HPFS/NTFS       4e  QNX4.x 2nd part 88  Linux plaintext de  Dell Utility
     8  AIX             4f  QNX4.x 3rd part 8e  Linux LVM       df  BootIt
     9  AIX bootable    50  OnTrack DM      93  Amoeba          e1  DOS access
     a  OS/2 Boot Manag 51  OnTrack DM6 Aux 94  Amoeba BBT      e3  DOS R/O
     b  W95 FAT32       52  CP/M            9f  BSD/OS          e4  SpeedStor
     c  W95 FAT32 (LBA) 53  OnTrack DM6 Aux a0  IBM Thinkpad hi eb  BeOS fs
     e  W95 FAT16 (LBA) 54  OnTrackDM6      a5  FreeBSD         ee  GPT
     f  W95 Ext'd (LBA) 55  EZ-Drive        a6  OpenBSD         ef  EFI (FAT-12/16/
    10  OPUS            56  Golden Bow      a7  NeXTSTEP        f0  Linux/PA-RISC b
    11  Hidden FAT12    5c  Priam Edisk     a8  Darwin UFS      f1  SpeedStor
    12  Compaq diagnost 61  SpeedStor       a9  NetBSD          f4  SpeedStor
    14  Hidden FAT16 <3 63  GNU HURD or Sys ab  Darwin boot     f2  DOS secondary
    16  Hidden FAT16    64  Novell Netware  af  HFS / HFS+      fb  VMware VMFS
    17  Hidden HPFS/NTF 65  Novell Netware  b7  BSDI fs         fc  VMware VMKCORE
    18  AST SmartSleep  70  DiskSecure Mult b8  BSDI swap       fd  Linux raid auto
    1b  Hidden W95 FAT3 75  PC/IX           bb  Boot Wizard hid fe  LANstep
    1c  Hidden W95 FAT3 80  Old Minix       be  Solaris boot    ff  BBT
    1e  Hidden W95 FAT1

When you look at this table, you can see that there are 256 possible
identifiers. In general, they are written in hexadecimal because it
allows representing 256 different combinations with only two characters.
The partition identifier is supposed to be consistent with the contents
of the partition, but it's not always correct. It's perfectly possible
to install Linux on a partition having its identifier set to 7 which is
normally used for NTFS partitions. It's more important to use the right
identifier if you want to install Windows. It may refuse to boot if you
use the wrong identifier for the partition. Anyway it should be correct
if you use a high-level partitioning tool such as parted. This
identifier is also very important if it's an extended partition (types
**5** and **f**). If you want to change the identifier of a partition
you have to use fdisk, and press “T” in the menu. It corresponds to
`change a partition's system id`

**Here are the most important identifiers**:

-   **7**: Normal NTFS (visible Windows partition)
-   **17**: Hidden NTFS (hidden Windows partition)
-   **82**: Linux swap (linux partition for swap)
-   **83**: Linux data (linux partition for data)
-   **8e**: Linux LVM (linux partition for LVM)
-   **5**: Extended partition (contains logical partitions)
-   **f**: Extended LBA partition (contains logical partitions)

## Example of a typical partition table

Here is an example of a disk where both Linux and Windows are installed.
This is the way it looks in `fdisk for linux`:

       Device Boot      Start         End      Blocks   Id  System
    /dev/sda1               1          32      250000   83  Linux
    /dev/sda2   *          32         249     1750000    7  HPFS/NTFS
    /dev/sda3             250         783     4289355    f  W95 Ext'd (LBA)
    /dev/sda5             250         316      538146   83  Linux
    /dev/sda6             317         426      879698+   7  HPFS/NTFS
    /dev/sda7             426         783     2871478   17  Hidden HPFS/NTFS

Here is how the same partition table is printed by another tool:
`GNU Parted`

    Number  Start   End     Size    Type      Filesystem   Flags
     1      512B    256MB   256MB   primary   ext3
     2      256MB   2048MB  1792MB  primary   ntfs         boot
     3      2048MB  6440MB  4392MB  extended               lba
     5      2048MB  2599MB  551MB   logical   ext3
     6      2599MB  3500MB  901MB   logical   ntfs
     7      3500MB  6440MB  2940MB  logical   ntfs         hidden

And now the same in GParted:


![sysresccd-gparted-01.png](/images/sysresccd-gparted-01.png)

## Partition flags

Each partition may also have other attributes, also know as flags:

-   One partition of the disk may be marked as active/bootable
-   FAT/NTFS may be marked as hidden or visible

### The bootable/active flag

The first flag is called either `bootable` or `active`. Only one
partition of the disk may have this flag. This flag is used to mark the
partition that contains the operating system that should be booted when
the computer starts using that disk. When the computer starts, the boot
code of the MBR is executed. By default the MBR contains the
conventional MBR code, which is used to automatically start the
operating system which is installed on the partition marked as active.
This is the typical situation of a computer when Microsoft
Operating-Systems are installed. Other boot managers can be installed in
the MBR boot code, such as Grub which is used to start Linux or Windows
(or any other Operating-System). These boot managers tend to ignore the
`bootable/active` flag since they have their own representation of the
installed systems. You can also install more than one version of Windows
on your disk if you have multiple primary partitions. This
`bootable/active` flag can be used to choose which one you want to boot.

### The hidden flag

Partitions may be either visible or hidden. In reality the
Operating-System can always see the partition of the disk and it can
decide to ignore the partitions which are marked as hidden. You can hide
a partition if you don't want this partition to be visible under
Windows. It can be used to hide data, or to be sure they won't be
accidentally removed. You can clear this flag at any time using a
partitioning tool such as Parted or fdisk. In reality there is no such
flag in the partition table. FAT and NTFS partitions have multiple
identifiers so there is one identifier for a visible NTFS partition, and
another identifier is used for hidden NTFS partitions. Linux partition
don't have such a hidden identifier but that's not a real problem since
it's possible to simply not mount a partition if you don't want its
contents to be visible.

## Disks and partition names

Linux and Windows have different naming conventions for disks and
partitions. Here is a description of **how disk names are set under
Linux**:

-   SCSI and SATA disks are named `/dev/sda` (first disk), `/dev/sdb`
    (second disk), `/dev/sdc`, ...
-   IDE/PATA disks names used to be `/dev/hda` (first disk), `/dev/hdb`
    (second disk), ... but can also be called `sda`, `sdb`, ...
-   RAID arrays use other names such as `/dev/cciss/c0d0p1` (HP
    SmartArray raid controllers)

With traditional [msdos/bios partition
table](/disk-partitioning/Introduction-to-disk-partitioning/)
**numbers 1 to 4 are reserved for primary partitions** (an extended
partition is a primary partition), and **numbers from 5 are used for
logical partitions**. Thus there can be a `/dev/sda5` (first logical
partition inside the extended partition) even if there is no partition
called `/dev/sda4`:

-   `/dev/sda1` is the first primary partition of the disk called
    `/dev/sda`
-   `/dev/sda2` is the second primary partition of the disk called
    `/dev/sda`
-   `/dev/sda5` is the first logical partition of the disk called
    `/dev/sda`
-   `/dev/sda6` is the second logical partition of the disk called
    `/dev/sda`

If you are using the [GPT disk layout](/disk-partitioning/The-new-GPT-disk-layout/)
then there is no need for extended partitions, because there can be more than 4
primary partitions. Then partitions are based on normal numbering starting at 1.

You can look at the file called `/proc/partitions` under Linux to see
your disks and partitions:

    % cat /proc/partitions
    major   minor    #blocks  name
       8        0    6291456  sda
       8        1     250000  sda1
       8        2    1750000  sda2
       8        3          1  sda3
       8        5     538146  sda5
       8        6     879698  sda6
       8        7    2871478  sda7

If it's installed you can also use fsarchiver to show the list of
partitions with more details:

    % fsarchiver probe simple
    [=====DEVICE=====] [==FILESYS==] [=====LABEL=====] [====SIZE====] [MAJ] [MIN]
    [/dev/sda1       ] [ext3       ] [boot           ] [   244.14 MB] [  8] [  1]
    [/dev/sda2       ] [ntfs       ] [windows-xp     ] [     1.67 GB] [  8] [  2]
    [/dev/sda5       ] [ext3       ] [linux-data     ] [   525.53 MB] [  8] [  5]
    [/dev/sda6       ] [ntfs       ] [windows-data   ] [   859.08 MB] [  8] [  6]
    [/dev/sda7       ] [ntfs       ] [backups        ] [     2.74 GB] [  8] [  7]
