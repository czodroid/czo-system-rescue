+++
title = "Starting to use the system"
draft = false
aliases = ["/Sysresccd-manual-en_Starting_to_use_the_system"]
+++

When you start, you should read the messages that give you the most important
information about how to use this system. You should read the text.

You can login on another console. The root password is empty. Type
<code>dhcpcd eth0</code> (or similar) to auto-configure the network using DHCP.

To start an ssh server on this system, type <code>systemctl start sshd</code>.
If you need to log in remotely as root, type <code>passwd root</code> to reset
the password of the root user to a known value.

If you need graphical tools (such as GParted) you will have to go to the
graphical environment. You should just type <code>startx</code> to start it.

You may need to use an editor. Editors available: vim, nano in console
mode. You can also use featherpad and geany in the graphical environment.
