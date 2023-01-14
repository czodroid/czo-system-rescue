+++
title = "Secure Deletion of Data"
draft = false
aliases = ["/Sysresccd-manual-en_Secure_Deletion_of_Data"]
+++

## Introduction
The secure removal of data is not as easy as you may think. When you delete a file using the default commands of the operating system (for example "rm" in UNIX or "del" in DOS or emptying the recycle bin in WINDOWS) the operating system does NOT delete the file, the contents of the file remains on your hard disk.

Most operating systems only remove references to the file when they are asked to delete a file. The file - you thought has gone forever - remains on the disk until another file is created over it (until another file overwrites the disk space where the "deleted" file is still stored), and even after that, it might be possible to recover the data by studying the magnetic fields on the disk platter surface using forensic equipment.

Before the file is overwritten by a new file, everyone can easily retrieve the data for example by using a disk undelete utility. And even after that some people (for example the three-letter-agencies) with special equipment are able to restore your data at least partially.

Everybody has sensitive data which they want to keep private. For example financial data, private emails, tracks of your internet surfing habits etc. I have heard of cases where people sold their old computers or harddisks and the buyer recovered their financial business data.

The only way to make recovering of your sensitive data nearly impossible is to overwrite ("wipe" or "shred") the data with several defined patterns.

CAUTION: The use of wiping or shredding tools relies on a very important assumption: that the filesystem overwrites the data in place. This is the traditional way to do things, but many modern filesystem designs do not satisfy this assumption for example Ext4, XFS, ReiserFS, etc.

See http://www.die.net/doc/linux/man/man1/shred.1.html for more information. In this case a solution could be to wipe/shred the entire device (partition) where the sensitive data was stored to ensure that the data is really overwritten.

SystemRescue provides a few tools which are able to make recovering of data nearly impossible - I say nearly impossible, because no one can give you a guarantee that for example the NSA or the FBI could not recover at least a part of that data. but using those tools makes it harder.

CAUTION: On the other hand you will not be able to recover any data, deleted by those tools. Take care. We will not take responsibility for loss of data.

If you want to have ultimate security, use encryption for example LOOP-AES http://loop-aes.sourceforge.net/
Encrypt your home directory or create an encrypted partition or container to save your data there.

## Main tools
* SHRED from the GNU coreutils see https://www.gnu.org/software/coreutils/coreutils.html can use shred to securely delete simple files but also entire partitions or harddisks. Shred uses by default 25 overwriting passes, you can increase and decrease the number of overwriting passes. Therefore shred is faster than wipe (see below).

For example securely deleting all data on the first IDE harddrive:
```
shred -v /dev/hda
```

* WIPE from Sourceforge see http://wipe.sourceforge.net Similar to shred you can use wipe to securely delete simple files but also entire partitions or harddisks. Wipe uses by default 35 overwriting passes. Wipe is slower than shred, because it uses by default more overwriting passes and therefore it is more secure.

For example securely deleting the Windows 98 Swap File from a mounted (FAT) windows partition using 35 overwriting passes:
```
wipe -D  /mnt/windows/win386.swp
```

## Other Tools
There are other tools on the SystemRescue which you can use similarly to overwrite especially devices, for example

* **nwipe**: select disks to wipe in a text UI; several algorithms to choose from; fork of Darik's Boot and Nuke (DBAN)
* **dd**: if=/dev/zero or /dev/urandom, of=device
* **dd_rescue**: works similar to "dd"
* **badblocks**: with -w option for writes 4 static passes

For more information take a look at the manuals.

## Testing
In order to see how the tools work and to check if all sectors for example of a floppy have been overwritten, you can use VCHE, the virtual console hex editor. In our example we will securely erase all data from a floppy.

First type the following command:
```
shred -v -n 1 /dev/fd0
```

Shred will overwrite the floppy with one random pass.

Then let's run:
```
vche-raw /dev/fd0
```

The floppy should be filled with random values.

Then we type the following command:
```
shred -v -n 1 -z /dev/fd0
```

The -z option will make an additional pass with zero values.

And we run VCHE again
```
vche-raw /dev/fd0
```

The floppy should be filled with zero values.

Critical Comments, and Suggestions are welcome: klemens(dot)hofer(at)aon(dot)at
