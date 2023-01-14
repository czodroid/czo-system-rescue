+++
title = "Downloading and burning"
draft = false
aliases = ["/Sysresccd-manual-en_Downloading_and_burning"]
+++

## Downloading
SystemRescue is provided as an ISO image file to be burned to a CD/DVD and
will produce a bootable media. SystemRescue cannot be executed as part of your
original operating system.

You can download the ISO image file with your favourite browser. If you
have problems, download the file using [wget](https://www.gnu.org/software/wget/)
which is often installed by default under Linux, or get
[a windows version of wget](http://gnuwin32.sourceforge.net/packages/wget.htm).
Downloading using wget is easy. You just need to run the following command in
a terminal (cmd.exe on windows)
```
wget -c address-of-the-iso-file
```

Once the file is downloaded, check that there was no error by comparing the
checksum matches the one shows on the download page. You can run sha256sum on
the iso file to get the checksum of your local copy amd make sure the file
has not been corrupted.

## Burning
You can burn the ISO image file with most burning software. Under Windows, you
can right click on the ISO image in the explorer to find an contextual menu
which offers to burn the ISO image to the DVD writer.

Under Linux, you can use graphical programs such as k3b, xfburn, brasero or
command line programs such as wodim or xorriso.

Burning with wodim is easy. First, type ```wodim --devices``` in order to get
the identifier for your device. Then, type the following to actually burn an iso
image:
```
wodim dev=/dev/scXX -v systemrescue-x.y.z.iso
```

For instance:
```
wodim dev=/dev/sr0 speed=8 -v systemrescue-x.y.z.iso
```

## Installing on USB Memory Stick

Today installing on USB memory stick is often a good alternative to burning on
optical media. See [here](/Installing-SystemRescue-on-a-USB-memory-stick/) for details.
