+++
title = "Backup and transfer your data using rsync"
draft = false
aliases = ["/Sysresccd-manual-en_Backup_and_transfer_your_data_using_rsync"]
+++

## Overview
[Rsync](https://rsync.samba.org/documentation.html) is an open source file
synchronization program. Designed to maintain a mirror of a directory, it is a
**very advanced tool** that can be used to make backups, or to copy files to
another disk or host in the event of a hardware or software catastrophe.

The advantages of rsync over alternate transfer methods include:

* **efficiency**: if a version of a file already exists at the destination,
  only changed **portions** are transferred. This significantly reduces resource
  requirements and elapsed time especially with large files. It uses an
  intelligent algorithm that detects redundancies which minimizes network load.
* **robustness**: in environments with slow connections or random hardware
  failures (especially disks that become non-operational after heating up),
  rsync can resume transfers that were interrupted
* **flexibility**: options include exclusion lists, "dry run" to verify options,
  tuning of compares to detect changes, various methods to handle links and more
* runs on Linux, Unix and under MS Windows with cygwin.

Rsync has few drawbacks:

* Mostly notable, since it is so flexible that there are many options, some of
  which are complementary, some are contradictory. The full documentation for
  [rsync](https://rsync.samba.org/documentation.html) is extensive and should be
  read several times.
* The destination filesystem must support the attributes. With archiving, the
  attributes are stored in the archive, and  the archive can be on any
  filesystem.

Rsync is provided with SystemRescue and this documentation is intended to
provide useful information and examples for use during the recovery process.
After understanding these you will find rsync useful to increase system
reliability during normal operations. See "Using rsync regularly to minimize the
impact of a disaster"

## Basic usage
rsync can be run as server (when started with --daemon) or as client to make
copies of files on a local machine or across the network to another host. The
recommended options include:

* `--progress` displays activity for monitoring progress
* `--archive` preserves basic attributes (permissions, ownership, type such
  as symbolic links.
* `--xattrs` preserve eXtended attributes (same as `-X`)
* `--acls` preserve Access Control Lists (same as `-A`)
* `--hard-links` preserve hard links (don't treat them as files) (same as `-H`)
* `--compress` in flight data ( no effect on destination) (same as `-z`)

### Copying file locally on the same computer
Only one rsync process is involved for local backups. Here is an example which
preserves all attributes (including extended ones) and ACLs:
```
rsync --archive --xattrs --acls --hard-links --progress --compress \
      /home/mydir/data/ /backups/data-20080810/
```

### Remote backup in standalone mode
If rsync is installed as a daemon (listening on port tcp/873) on example.com,
the client running at myhost can either pull files from the daemon or push files
to the daemon.

Here is an example having the client can push a directory to a remote host
(preserving attributes, ACLs and hard links (using single letter options):
```
rsync -aXAHz --progress /home/mydata/ example.com::mybackups/data-20080810/
```
The client could also download the files from the remote hosts:
```
rsync -aXAHz --progress example.com::mybackups/data-20080810/ /home/mydata/
```

Notice two colons between the remote host and the path when the rsync protocol
is used.

### Remote backup over ssh
If the port tcp/873 is blocked (by a firewall) or you need the connection to be
encrypted then you can use rsync through ssh by specifying `-e` on
the client side.

Here is an example where the clients send to the remote host:
```
rsync -aAXHz  --progress -e ssh /home/mydata/ remote.com:/backups/data-20080810/
```
or retrieves:
```
rsync -aAXHz  --progress -e ssh remote.com:/backups/data-20080810/ /home/mydata/
```

Observe only one colon between the remote host address and the remote path when
rsync connects over ssh.

## Saving files with interruptions
When recovering large amount of data, either large files, or thousands of small
file, using scp, ftp or http lacks a means of resuming a interrupted transfer.
Manually restarting the transfer is awkward. If the process was interrupted at
99% of a large file, the transfer must be restarted at the beginning, all the
data transmitted again and may mean the transfer never completes. Even with
`wget -c` a corrupt file may result.

This is also important in those cases where the hard disk only operates while
cool. rsync can handle this well by saving files as long as the disk is
operating. After the disk heats up and becomes un-responsive rsync will abort.
Power off the system and wait an hour or two for the disk to cool down. Power up
and rsync can continue saving files **where it left off**.

### Transferring thousands of small files
Only the files which are not current at the destination will be transferred. By first comparing the source and the destination files only the ones which are different will be transfered. This facilitates the continuation after an interruption and reduces elapsed time and reduces bandwidth requirements for remote transfers.

### Transferring files with slow connections
Rsync is able to **resume transfers** of files if the connection is lost by
using `--partial` and `--inplace`. This is especially
important with large files.

* `--partial` causes partially transferred files to be retained. By
default rsync removes a partial file when interrupted. If  the connection is
lost rsync will stop. When the connection is  reestablished  and rsync resumes
data  will need to be transferred again as rsync will start from the beginning
of the file.

* `--inplace` causes rsync to use original file name at the
destination. By default rsync transfers data to files with a temp name during
the transfer and renames the files once the file is complete.  Without
`--inplace`, on restart rsync will create new temp files and must
restart the transfer from the beginning of the file.

* `--update` must NOT used with `--inplace` as the
partial destination file would be considered the same as than the original file
and skipped.

Rsync uses a very efficient algorithm to compare the source file with the
destination file and only transfers the different parts of the file. To transfer
several versions of the same files on a regular basis, copy the old version
(that you have already transferred) to the new destination file, and rsync will
skip all the common parts.

With these options, rsync can be interrupted then resumed.  Data which has been
transferred is preserved.

Here is an example of good command to copy a directory with large files to a
remote host:
```
rsync --archive --partial --inplace --progress --compress \
           /home/bigfiles/ MYMIRROR::mybackups/bigfiles/
```
Check for updates to rsync at http://rsync.samba.org/

## Important rsync options
rsync has a lot of options. Here are just a few which apply to recovering a
failed system.

### preserving attributes using `--archive`
It is a very important option. Preserves files attributes (permissions, times
and type). As a result, a symbolic link will be copied as a link, without
`--archive` the **contents** of the source file are copied in the
destination. Hard links, extended attributes (xattr), and ACLs (Access Control
Lists) are not preserved with this option, see `-HAX`

### showing progress during transfer using `--progress`
This option will show the progress on the current transfer

### listing files using --verbose
This option shows more details and can be used multiple times to increase the
logging

### do not cross filesystem boundaries using `--one-file-system `
Process only one filesystem.  Important when processing a filesystem
(eg: `/` ) with mounted volumes. Default processes filesystems with mount
points within the source specification.

### compressing file data during the transfer using `--compress`
Rsync can compress the data that are transferred to reduce network activity.
The destination file will be the same as the original.  Use it for remote
transfers when synching files which are uncompressed and will have a large
compression ratio (eg: large text files, CD images or raw partition images).
This option is not efficient on files which are already compressed: zip, gz,
bz2, taz, jpeg, pdf, ... This will cause a significant increase in the CPU usage
on both sourcing and destination systems.

### viewing progress on large files using `--inplace` and `--partial`
Use these options  to transfer large files and insure that the transfer will
resume at a restart point in case of connection failure. See the sections about
Transferring large files for more details.

### excluding files using `--exclude=pattern`
Use this option to exclude files or directories from the transfer. For instance
temporary files or cache directories.

### removing deleted files in the destination using `--delete`
When synchronizing to an existing  destination, files in the **destination**
directory will be removed if they are not in the source directory (The files
have been deleted). By **default** files no longer in the source **remain in the
destination**. Consider the scenario in which files are versioned by date and
are deleted as a new one is created. The default will not remove old versions
and they will accumulate. This will cause the destination to not be a "mirror"
of the source and the space required for the destination will increase with each
run. Processing a single run with this option will delete all accumulated files.

### skipping files that are newer on the destination using `--update`
Defines this run to be an update of an existing destination. Use this option if
files have been modified  in the **destination** directory. For instance, if you
are migrating data from an old server to a new one, and if people have already
started working on the new server. Use `--update` to prevent overwriting
changes with an older version.

### removing synchronized files from the source using `--remove-source-files`
This option is useful to move data to the destination. By default, rsync makes a
copy leaving the original intact. With `--remove-source-files`, the source
files to be deleted if the transfer was successful.

### comparing files based on checksums using `--checksum`
By default rsync uses the file modification-time and size to to decide whether
or not the file needs to be transferred. A file that exists in the destination
directory with the same name, date and size is considered to be the same. This
is accurate in nearly all cases. The comparison is very quick because only the
file attributes are read. In rare cases this is incorrect. There are some
utilities which can modify a file and retain the original modification time. If
the modification does not change the size of the file (very rare) rsync will
erroneously consider the source and destination files to be identical and not
transfer the file. Specify `--checksum` to force rsync to calculate a
checksum of the files and compare this checksum to determine if the files are
the same or not. Be **warned** that this will add significant CPU time and I/O
activity at both the source and destination since the entire contents of both
files must be read to generate the checksum.

## Rsync return status
The return status must be checked to determine whether or not the transfer was
successful. When rsync returns 0, it means that the transfer was successful.
Any other value indicates an error.

Some errors which may indicate a recoverable problem include:

* 22: Error allocating core memory buffers
* 23: Partial transfer due to error

## Installing and configuring the rsync daemon
The rsync client will only transfer data to an rsync server.

The configuration default location is either `/etc/rsyncd.conf` or
`/etc/rsync/rsyncd.conf`.  After changing the configuration, send a HUP
signal using `kill -HUP <pid-of-rsync>`.

Several options are available to restrict connections:

* require a password to connect
* allow only several specific IP addresses to connect
* provide read-only access to the client

Here is an example of basic secured configuration:
```
# ======================/etc/rsyncd.conf======================
pid file = /var/run/rsyncd.pid
read only = yes
uid = root
gid = root

[share1]
    path = /mnt/share1
    read only = yes
    hosts allow = myhost, 10.88.45.0/24

[backups]
    path = /var/tmp/catalyst/tmp
    read only = no
    hosts allow = mybiggie, 10.88.45.0/24

[rootfs]
    path = /
    read only = yes
    hosts allow = myhost, 10.88.45.0/24

[upload]
    path = /upload
    read only = no
    hosts allow = 172.16.0.0/16
```

## MS Windows and cygwin
The rsync daemon can be run on an MS Windows system by using
[cygwin](http://www.cygwin.com) which provides a Linux environment.
Minimal information is provided here to get you started.
It is not emulated programs: it is just the software we use on linux has been
compiled to run on windows, so it is a windows executable which is speaking to
the windows kernel directly

To install cygwin, run the setup.exe program found on the
[cygwin website](http://www.cygwin.com)

The hard disks as seen as `/cygdrive/c/`, `/cygdrive/d/`, ... .

Click on the cygwin icon to run a bash shell.  

You can also install rsync as a daemon on cygwin. To install services in cygwin,
you can use a special program named `cygrunsrv.exe`. It installs a cygwin
service as a normal windows service, so that it can be automatically started at
windows boot time. That way you don't have to start the daemon by hand.

Here is the command to use:
```
cygrunsrv.exe -I "cygrsyncd" -p /usr/bin/rsync.exe -a "--config=/etc/rsyncd.conf --daemon --no-detach"
```

Then, start the new service run `services.msc` and start the service named "cygrsyncd"

## Using rsync regularly to minimize the impact of a disaster
The previous sections of this document focus on the features and operation of
rsync to help recover a system.

Here we present additional information we thought would be useful.

rsync is a utility that maintains a mirror of a filesystem. Updated regularly,
the mirror can be a major asset for recovering a failed system.

Here are some addition notes for using rsync:

* rsync can make remote backups of your data files on windows, or it can
  replicate windows system backups created using other programs
* Combined with [LVM snapshots](/lvm-guide-en/Making-consistent-backups-with-LVM/)
  to make online backups which are consistent.
* **Various backup strategies**: full, differential backups, incrementals.
  Backups can save only the files which have been modified since the previous backup.
* run rsync on a server every night to make a backups of its root file system.
  rsync will probably complain about files which have been deleted during the
  transfer (like temporary files). consider the return status 23 and 24 as
  warnings on a live system

The rsync daemon can be installed in a dedicated listen mode (tcp port 873).
Having [xinetd](http://en.wikipedia.org/wiki/Xinetd) configured to listen on the
behalf of rsync uses less memory and is more secure. It also means rsync is
started  and the configuration file read on each connection so changes will
effected on the next connection.

rsync traps intr so pressing ^C stops when  the current file is completed. Use
the less common quit ^\ to have it quit now.
