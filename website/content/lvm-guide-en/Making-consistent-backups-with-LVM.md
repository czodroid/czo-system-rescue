+++
weight = 20050
title = "Making consistent backups with LVM"
draft = false
aliases = ["/Sysresccd-LVM-EN-Making-consistent-backups-with-LVM"]
+++

## About
All the important stuff you have should be backed up. On production servers,
you don't want to have down time for the backups, but you want the backups to be
consistent anyway. LVM is a very interesting storage system since it provides
**disk snapshots** which are required to make **consistent data backup**. They
can be done when the system is running with **no impact on your production
environment**. It can be used for both desktops and servers running Linux as
long as the filesystem that you want to backup is stored on a Logical-Volume.
No particular backup software is required to make such backups. You can just use
the standard commands such as tar that come for free with Linux. It is
recommended that you read the [previous pages about LVM](/lvm-guide-en/) before
reading this one.

## Backups and consistency
If your operating system is running, files can be written at any time. Because
the backup can take some time, important files which are references to other
files may have changed between the beginning and the end of the backup. Let's
consider that your system hosts a website using Apache and Mysql. People who
visit your website can upload images to their profile. When they do that, the
file is stored in /www/upload and a new entry is added in a mysql table that
refers to that file on the disk.

Here is the situation that we want to avoid:

* The backup which is not based on LVM snapshots starts.
* The backup program does a backup of the upload directory
* A visitor uploads an image. The file is created on the disk and a reference to
  that is added in the database
* The backup program does a backup of the database files
* The backup is now finished

In this example we can see that the backup is inconsistent because the database
files which have been backed up contain a reference to a file which does not
exist in the upload directory when it was backed up, just because the user
uploaded that file when the backup was in the middle of the process. If you
restore your system using this backup, the database will refer to a file which
is missing. The LVM snapshots are a good solution to this sort of problem.

## Creation of an LVM snapshot
An LVM snapshot is a frozen view of an LVM Logical-Volume. When you make
modifications to the files of the original volume, the snapshot is not modified.
So you end up with two volumes: the normal Logical-Volume of your system and the
Logical-Volume of the snapshot. Let's consider that you run that command at 2am.
Then each time you read data from the snapshot you have created, you will see
the data as they were at 2am.

You have to run a command to take a snapshot of an LVM Logical-Volume. This
command is `lvcreate` which is also the command you use to create a
normal LVM Logical-Volume. Here is the general syntax:

**lvcreate -L size  -s -n snapname origlv**

* **origlv**: name of the normal Logical-Volume that you want to backup
* **snapname**: name of the snapshot that will be created
* **size**: space reserved for the snapshot in your Volume-Group

Let's take an example: You are running Linux Redhat Enterprise RHEL5. It's
installed on `/dev/VolGroup00/LogVolRoot`. The size of this Logical-Volume
is 16GB and you want to make a backup of it using LVM snapshots. You have 5GB
available in your Volume-Group which is called `VolGroup00`. Here is the
appropriate command to do that:

* **creation of the LVM snapshot**: `lvcreate -L5G -s -n LogVolSnap /dev/VolGroup00/LogVolRoot`
* **new situation**: now you can see two Logical-Volumes of 16GB each: `/dev/VolGroup00/LogVolRoot` and `/dev/VolGroup00/LogVolSnap`
* **destruction of the LVM snapshot**: `lvremove /dev/VolGroup00/LogVolSnap`

You may be surprised to see that the size of the snapshot is 16GB since we
passed a size of 5GB to `lvcreate`. The reason is that the space reserved
for the snapshot which is 5GB is only used for data that have changed after the
snapshot has been taken. LVM does not keep two copies of the data when you do an
LVM snapshot. That's why the creation of the LVM snapshot is very quick: it's
almost immediate because it does not make any copy at that time.

What really happens is **LVM makes a copy of the original data each time a
modification is requested** on the Logical-Volume. When a block of the
Logical-Volume is modified, LVM first makes a copy of the original version which
is stored in the snapshot, and then the modification is written on the normal
Logical-Volume. So the normal Logical-Volume always contains the latest version
of the data and the snapshot only contains a copy of the blocks which have been
modified. For each block that has not been modified since the snapshot creation,
then the snapshot just contains a reference to the block on the normal
Logical-Volume. As a consequence, having a snapshot makes your Logical-Volume
slower because two blocks have to be written each time a block is modified on
the volume.

It's important to remember that **LVM works at the block level**. As a hard disk,
LVM just considers the data as a list of fixed size blocks. It does not know
anything about files and directories. This is the job of the filesystem which
uses that LVM Logical-Volume. Also there is a problem if you want to make too
many modifications to the volume. If you created a snapshot of 5GB, the snapshot
won't be able to store the data if you modify more than 5GB of data on your
Logical-Volume. When that happens the snapshot is automatically destroyed, and
you loose the original version of your volume. The latest version with
modification is always preserved. You can create snapshots which are as big as
the original Logical-Volume if you want to be sure not to loose the snapshot in
case of modifications.

## Backup based on the snapshot
The snapshot that has been created is just like a standard LVM Logical-Volume,
so you can read it just as you would read any other Logical-Volume of your
system. Internally LVM only stores the blocks which have been modified, but the
user can read all the blocks of the volume. Reading blocks of an LVM snapshot is
just the same as reading the blocks of the original volume at the time the
snapshot has been created. As a consequence the snapshot should contain a valid
filesystem that can be mounted read-only.

Then you have two options to make a backup of an LVM snapshot:

* **work at the block level**: you can consider the snapshot at the block level
  and make a backup with tools such as `dd` or `partimage`
* **work at the file level**: you can mount the snapshot on an alternative mount
  point and use [rsync](/manual/Backup_and_transfer_your_data_using_rsync/)
  or archivers such as `tar`, `dar`, or `fsarchiver`

The second option is recommended because it will be more flexible, because you
can just work with all of the tools that can perform disk or file backups.

## Backup script using fsarchiver
Here is an example of a simple shell script that performs a backup using
[fsarchiver](http://www.fsarchiver.org). This tool has been used because it
provides high compression, good performance as well as reliability because of
the checksums. You can probably reuse this script by just changing the details
at the top of the file to the names of your own volumes:
```
#!/bin/bash
VOLGROP='vgmain'                 # name of the volume group
ORIGVOL='rootfs'                 # name of the logical volume to backup
SNAPVOL='mysnap'                 # name of the snapshot to create
SNAPSIZ='5G'                     # space to allocate for the snapshot in the volume group
FSAOPTS='-z7 -j3'                # options to pass to fsarchiver
BACKDIR='/backups/'              # where to put the backup
BACKNAM='backup-of-mysystem'     # name of the archive

# ----------------------------------------------------------------------------------------------

PATH="${PATH}:/usr/sbin:/sbin:/usr/bin:/bin"
TIMESTAMP="$(date +%Y%m%d-%Hh%M)"

# only run as root
if [ "$(id -u)" != '0' ]
then
        echo "this script has to be run as root"
        exit 1
fi

# check that the snapshot does not already exist
if [ -e "/dev/${VOLGROP}/${SNAPVOL}" ]
then
        echo "the lvm snapshot already exists, please destroy it by hand first"
        exit 1
fi

# create the lvm snapshot
if ! lvcreate -L${SNAPSIZ} -s -n ${SNAPVOL} /dev/${VOLGROP}/${ORIGVOL} >/dev/null 2>&1
then
        echo "creation of the lvm snapshot failed"
        exit 1
fi

# main command of the script that does the real stuff
if fsarchiver savefs ${FSAOPTS} ${BACKDIR}/${BACKNAM}-${TIMESTAMP}.fsa /dev/${VOLGROP}/${SNAPVOL}
then
        md5sum ${BACKDIR}/${BACKNAM}-${TIMESTAMP}.fsa > ${BACKDIR}/${BACKNAM}-${TIMESTAMP}.md5
        RES=0
else
        echo "fsarchiver failed"
        RES=1

##      exit (1);  # don't remove the snapshot just yet
                   # perhaps we will want to try again ?

fi

if [ "$RES" != '1' ]  # prevent removal if error occurred above.
then

  # remove the snapshot
  if ! lvremove -f /dev/${VOLGROP}/${SNAPVOL} >/dev/null 2>&1
  then
        echo "cannot remove the lvm snapshot"
        RES=1
  fi

fi

exit ${RES}
```
