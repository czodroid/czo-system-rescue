+++
title = "Booting on a serial console"
draft = false
aliases = ["/manual/Booting_on_a_serial_console/"]
+++

## Serial console

Serial consoles instead of a regular graphics card with VGA or HDMI/DP output 
are common on embedded systems, but also used for remote management on servers.

For a serial console to work you need to know the baud rate and parameters
used as well of the internal port number used. SystemRescue uses the most common 
setup by default, that is the first serial port (**ttyS0** or COM1:) with a **baud 
rate 115200, 8 Bits, no parity, 1 stop bit**.

## Bootmanager

Both boot managers used (syslinux and grub) allow to use a serial console fully
in parallel to a regular graphical console without priorizing one over the other.
So the serial console is always activated with the parameters set in the config
files (see below).

## Booting a kernel

The Linux kernel also allows to use several consoles in parallel, they are all
configured with the `console=` boot commandline option. But in contrast to the
boot managers, these have a priority with only the one with the highest priority
receiving the boot messages and being usable during the initramfs phase.

So a serial console can't be always activated in parallel, but has a
dedicated boot menu option instead.

## Changing parameters

When the default parameters of SystemRescue don't fit your system, you have
to adapt them in the configuration files prior to booting. You have to adapt these
files on the iso-Image of SystemRescue:

**`/boot/grub/grubsrcd.cfg`**:
```
# enable serial console with common settings (ttyS0, 115200 Baud, 8n1)
# this works in parallel to regular console
serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
terminal_input --append serial
terminal_output --append serial

[...]

menuentry "Boot SystemRescue with serial console (ttyS0,115200n8)" {
        set gfxpayload=keep
        linux /sysresccd/boot/x86_64/vmlinuz archisobasedir=sysresccd archisolabel=RESCUE905 iomem=relaxed console=tty0 console=ttyS0,115200n8
        initrd /sysresccd/boot/intel_ucode.img /sysresccd/boot/amd_ucode.img /sysresccd/boot/x86_64/sysresccd.img
}
```

**`/sysresccd/boot/syslinux/sysresccd_head.cfg`**:
```
SERIAL 0 115200
```

**`/sysresccd/boot/syslinux/sysresccd_sys.cfg`**:
```
LABEL sysresccd-serial
TEXT HELP
Use a serial console.
ENDTEXT
MENU LABEL Boot SystemRescue with serial console (ttyS0,115200n8)
LINUX boot/x86_64/vmlinuz
INITRD boot/intel_ucode.img,boot/amd_ucode.img,boot/x86_64/sysresccd.img
APPEND archisobasedir=sysresccd archisolabel=RESCUE905 iomem=relaxed console=tty0 console=ttyS0,115200n8
```

To change these files, either use [sysrescue-customize](/scripts/sysrescue-customize/) to change the iso image
or automate these changes or [write SystemRescue to USB media](/Installing-SystemRescue-on-a-USB-memory-stick/)
in a way that creates a writeable image, like Rufus or sysrescue-usbwriter, and then do the changes with a
text editor.
