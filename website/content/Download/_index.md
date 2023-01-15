+++
weight = 110
title = "Download"
nameInMenu = "Download"
draft = false
aliases = ["/download"]
+++

## Download links
You can download SystemRescue immediately from this page. It is highly
recommended to use the 64bit version (amd64) but a 32bit version (i686) is also
available.

| Release           | systemrescue-9.06 for amd64                                                      | systemrescue-9.03 for i686                                                       |
|:-----------------:|:--------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------:|
| State             | active                                                                           | [deprecated](https://gitlab.com/systemrescue/systemrescue-sources/-/issues/278)  |
| Release date      | 2022-12-18                                                                       | 2022-05-28                                                                       |
| Download size     | 748 MiB                                                                          | 758 MiB                                                                          |
| Download ISO      | [systemrescue-9.06-amd64.iso](https://sourceforge.net/projects/systemrescuecd/files/sysresccd-x86/9.05/systemrescue-9.06-amd64.iso/download) | [systemrescue-9.03-i686.iso](https://sourceforge.net/projects/systemrescuecd/files/sysresccd-x86/9.03/systemrescue-9.03-i686.iso/download) |
| SHA256 checksum   | [systemrescue-9.06-amd64.iso.sha256](/releases/9.05/systemrescue-9.06-amd64.iso.sha256) |[systemrescue-9.03-i686.iso.sha256](/releases/9.03/systemrescue-9.03-i686.iso.sha256) |
| SHA512 checksum   | [systemrescue-9.06-amd64.iso.sha512](/releases/9.05/systemrescue-9.06-amd64.iso.sha512) |[systemrescue-9.03-i686.iso.sha512](/releases/9.03/systemrescue-9.03-i686.iso.sha512) |
| Signature         | [systemrescue-9.06-amd64.iso.asc](/releases/9.05/systemrescue-9.06-amd64.iso.asc)       |[systemrescue-9.03-i686.iso.asc](/releases/9.03/systemrescue-9.03-i686.iso.asc)       |

## Other versions
You can also download
[previous versions](https://sourceforge.net/projects/systemrescuecd/files/sysresccd-x86/), or
[beta versions](http://beta.system-rescue.org/) if you want to have more recent
versions of packages or to try the latest features.

## Applying customizations
Before you install SystemRescue on a boot device, you may want to apply your own
customizations to the ISO image. This can be achieved easily through
[sysrescue-customize](/scripts/sysrescue-customize/).

## Installation on a USB stick or internal disk
It is possible to use SystemRescue without having a DVD drive as it can be
installed on [USB sticks](/Installing-SystemRescue-on-a-USB-memory-stick/),
or on [a local disk](/manual/Installing_SystemRescue_on_the_disk/). In any
case you will need to download the ISO image from the current page.

## Checking the downloaded file
To confirm that the download was successful, you should download the checksum
files and then run verification commands such as the following ones:
```
sha256sum --check systemrescue-x.y.z.iso.sha256
sha512sum --check systemrescue-x.y.z.iso.sha512
```
These command will recalculate the checksum on the downloaded file, and compare
it with the expected checksums. These checksum programs are part of
[coreutils](https://www.gnu.org/software/coreutils/coreutils.html)
on Linux and should be pre-installed with most distributions.

You can download [sha256sum.exe for windows](http://www.labtestproject.com/files/sha256sum/sha256sum.exe),
and you can run the command from a cmd.exe terminal.

## Checking the signature
You can also verify the signature of the ISO image using GnuPG. The signature
is located in the ASC file named after the ISO image that you can get from the
main download links at the top of this page. You will also need
[the public signing key](/security/signing-keys/gnupg-pubkey-fdupoux-20210704-v001.pem).
```
gpg --import gnupg-pubkey.txt
gpg --verify systemrescue-x.y.z.iso.asc systemrescue-x.y.z.iso
```

## Errors during the boot process
Various issues can cause SystemRescue to hangs or fail with unexpected errors
during the boot process. Please do not report these as bugs unless you have
verified the frequent causes of these issues:

* Boot medias such as DVD, and USB stick are often unreliable and bad
  blocks will cause problems. You can try another media to see if it makes a
  difference, and you can enable verification when you burn/copy the ISO image
  to make sure data written to the device can be read and match the original.
* Damaged RAM will cause all type of programs to behave unexpectedly. Computers
  memory can be tested using program such as memtest which is included with
  SystemRescue.
* You will also get problems if the system runs out of memory. So make sure your
  computers has at least 2GB of memory if you start with the default boot
  options or 4GB if you cache the system into RAM.

## Writing the ISO image file to a DVD
On Linux you can use either command line tools such as cdrecord/wodim or
graphical tools such as k3b, brasero or xfburn.

## Online documentation
**Reading the [Quick Start Guide](/Quick_start_guide/) is recommended** if it
is your first time using SystemRescue. You may also be interested in the
[Complete documentation](/manual/) for more details.
