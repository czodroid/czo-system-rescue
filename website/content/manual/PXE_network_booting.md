+++
title = "PXE network booting"
draft = false
+++

## About
The [PXE environment](http://en.wikipedia.org/wiki/Preboot_Execution_Environment)
allows you to boot a computer with SystemRescue even if this computer has no
CDRom drive or USB socket. It allows you to boot SystemRescue from the
network, and then it is faster to troubleshoot computers on your network once a
PXE-boot-server is installed. It is also useful if you want to boot a computer
that has no optical drive (CD or DVD) or to troubleshoot a remote computer to
which you have no physical access to insert the disc.

Instructions provided below correspond to files from the 64 bit version
(amd64/x86_64) of SystemRescue. If you use the 32 bit version you need to
replace all instances of `x86_64` with `i686`.

## Requirements

* **Servers to provide PXE services** including DHCP with SystemRescue files
  available to serve clients requests
* **A client computer** with a PXE able network card on the same network and
  enough memory to fully store SystemRescue files

## How the PXE boot process works

### The PXE boot server
The PXE boot server is made of three stages:

* **stage0:** the PXE-booting client sent an extended DHCPDISCOVER
* **stage1:** the DHCP server send an IP address to the client and supplementing
information such as the TFTP server
* **stage2:** the PXE-booting client configures the network and requests the
first boot files from the TFTP server (boot loader, kernel image and
sysresccd.img)
* **stage3:** the PXE-booted client requests the squashfs root file system image
from the HTTP or NFS or NBD server

These three parts can be installed either on a single machine or on several
computers.

### The PXE boot process
You may need to understand what happens when you boot SystemRescue from the
network. You will need this knowledge for troubleshooting in case of problems.
Here are the most important steps of the PXE boot process:

* When the client computer tries to boot with PXE, it first emits a DHCP request
  on the network to get an IP address.
* Then a DHCP server replies with a DHCP offer that contains a new IP address
  that was not already allocated and some specific options (DNS, default route)
  and the IP address of the TFTP server
* The client receives this DHCP offer and accepts it. It connects to the TFTP
  server (it received its IP address in the previous stage) to get the boot
  loader files.
* The TFTP server sends the boot loader files (<code>pxelinux</code>) and the
  text files displayed on the screen by <code>pxelinux</code>.
* The client displays the pxelinux prompt, and the user can choose the boot
  options. It then requests from the TFTP server the kernel and initramfs files
  necessary to boot the system
* The TFTP server sends the kernel and initramfs files
  (eg: <code>vmlinuz</code> + <code>sysresccd.img</code>) to the client
* The client boots this kernel and executes the init programs that come with the
  initramfs.
* During its initialization the kernel makes a DHCP request again because of the
  <code>ip=dhcp</code> kernel boot parameters. Indeed the kernel does not know
  the IP address used by the computer at the pxelinux stage.
* The client needs the <code>airootfs.sfs</code> file. If you use HTTP or TFTP for
  the third stage, then <code>airootfs.sfs</code> will be downloaded into RAM so
  the client has to have enough memory (estimated requirement: 1GB). If you
  use either NFS or NBD then you don't have this memory requirement and the
  client will make permanent requests to the server each time it needs a file
  from the root filesystem.
* The client mounts <code>airootfs.sfs</code> and it can now complete the boot
  process.
* At this stage the client holds all the files in memory, if you used TFTP/HTTP
  for the third stage, so it does not require a boot server any more. If you are
  using NFS or NBD, the connection is still required.

### Customization of the boot command line
The PXE server is made of several services. In the second stage, the server uses
TFTP to send multiple things to the client: boot loader (pxelinux.0), kernel
image (vmlinuz), initramfs (sysresccd.img). The boot loader is
<code>pxelinux.0</code> and it comes with a configuration file which
is sent to the client. This configuration file contains the boot command line
which will be used by the client to start the Linux kernel. This command line is
important since it contains the SystemRescue boot options that are required to
run the third stage. The boot command line can be used to specify the network
settings and the method that the PXE client will use in the third stage of the
PXE boot process. Here are two examples of valid command lines for PXE boot:

### PXE boot options supported by SystemRescue
SystemRescue is based on Arch Linux since version 6.0 hence it supports PXE
boot options implemented by the upstream. These boot options provide support for
various protocols (HTTP, NFS, NBD) and are documented on the following page:
https://gitlab.archlinux.org/archlinux/archiso/-/raw/v43/docs/README.bootparams

The most important ones are the following:

#### HTTP option

* **archiso_http_srv=** Set a HTTP URL (must end with /) where to download
the *.sfs file from when using HTTP. ${archisobasedir} and the architecture (`x86_64`)
are added to the supplied URL.
http and https are supported. When using https, no certificate check is done as the
initramfs environment doesn't contain a trusted CA database.

#### NFS option

* **archiso_nfs_srv=** Set the NFS-IP:/path of the server where to download
the *.sfs file from when using NFS. ${archisobasedir} and the architecture (`x86_64`)
are added to the supplied path. Note that due to tooling limitations only IPv4 addresses
are supported, no DNS hostnames or IPv6.

### Example of a PXE configuration to boot SystemRescue using TFTP and HTTP
Here is an example of a PXE configuration which allows to boot SystemRescue
using TFTP and HTTP only. It is one of the simplest PXE configuration you can
have hence it is recommended to follow this example if you want a simple PXE
configuration for SystemRescue.

In this example the boot loader is <code>pxelinux.0</code> and TFTP is used to
get the kernel image and initramfs images. It then uses an HTTP server to
download the large squashfs file system <code>airootfs.sfs</code>.

When you configure the TFTP server you have to copy the boot loader (pxelinux
binary files), a pxelinux configuration file in `pxelinux.cfg/default`, and you
need to copy the `sysresccd` directory as it is (even though not all files are
required by the TFTP server) from the ISO image to provide files that will be
requested via TFTP.

Here is the list of all required files and their location on the TFTP server:
```
./sysresccd/boot/x86_64/vmlinuz
./sysresccd/boot/x86_64/sysresccd.img
./sysresccd/boot/memtest.COPYING
./sysresccd/boot/memtest
./sysresccd/boot/intel_ucode.LICENSE
./sysresccd/boot/intel_ucode.img
./sysresccd/boot/amd_ucode.LICENSE
./sysresccd/boot/amd_ucode.img
./sysresccd/VERSION
./sysresccd/pkglist.x86_64.txt
./pxelinux.cfg/default
./ldlinux.c32
./pxelinux.0
```

And here is the example of a configuration located in `pxelinux.cfg/default`:
```
DEFAULT sysresccd
LABEL sysresccd
  LINUX sysresccd/boot/x86_64/vmlinuz
  INITRD sysresccd/boot/intel_ucode.img,sysresccd/boot/amd_ucode.img,sysresccd/boot/x86_64/sysresccd.img
  APPEND archisobasedir=sysresccd ip=dhcp archiso_http_srv=http://10.0.2.4/ checksum
  SYSAPPEND 3
```
The SYSAPPEND option is important and you need to make sure you are using a
recent version of pxelinux as versions older than 5.10 do not support it. Also
users of the PXE boot feature are encouraged to use recent versions of SystemRescue.

You need to update the IP address of the HTTP server from which the squashfs
image will be downloaded. In this example it will download this file and its
checksum from the following URLs:
```
http://10.0.2.4/sysresccd/x86_64/airootfs.sfs
http://10.0.2.4/sysresccd/x86_64/airootfs.sha512
```

Make sure you are able to successfully download these files from a regular web
client before you try to boot from PXE. You can customize the boot command line
by adding options such as `setkmap=us` after the `checksum` option.
