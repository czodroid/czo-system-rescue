+++
title = "reverse_ssh for remote support"
+++

## Overview

Consider a system doesn't work anymore and it is in a remote location you can't
easily get to. Users on site only have limited knowledge and can be instructed
over telephone to do simple tasks, like boot a prepared SystemRescue or enter
basic commands, but not diagnose and fix the actual problem. You can not
directly connect to it via SSH because the system is behind a NAT router or
firewall.

reverse_ssh will help to get around that by opening the SSH connection from
within SystemRescue to a remote host. This outgoing TCP connection has a much
better chance to pass through the NAT router or firewall.

## Preparation

 - Boot SystemRescue (reverse_ssh is included in SystemRescue since version 7.01)
 - Make sure the system is connected to internet. SystemRescue uses and enables
   DHCP by default, but depending on local network setup you may have
   to do some tweaks like setting a different default gateway or configuring
   VLAN tagging.
 - Set a root password to allow the remote session to authenticate. You can use
   the `passwd` command or set the `rootpass=` or `rootcryptpass=` boot
   parameters. Public keys in `/root/.ssh/authorized_key` are supported too.
 - Run `reverse_ssh` on the shell, see below for details

## Using reverse_ssh on SystemRescue (SSH server)
```
reverse_ssh [-h] [-d] [-b] [-t TRIES] hostname port

positional arguments:
  hostname              hostname (or IP) to connect to
  port                  TCP port number to connect to

optional arguments:
  -h, --help               show this help message and exit
  -d, --debug              enable debug output
  -b, --background         fork to background once the connection is established
  -t TRIES, --tries TRIES  connection tries (0: endless, this is the default)
```

`reverse_ssh` will output messages about the connection status (like connection
errors) to the console. Once a connection is made it blocks by default. In this
state the remote connection can be disconnected with `Ctrl-C`. If used with the
`--background option`, it forks into background once a connection is
established, so the shell can be used for other commands.

## Receiving reverse_ssh connections on the ssh client

If your client is accessible from the internet, either directly or via port
forwarding, you can receive the reverse_ssh connection with these commands:
```
export RECEIVEPORT=2222
ssh -l root -o "ProxyCommand socat - TCP4-LISTEN:${RECEIVEPORT},reuseaddr" -o StrictHostKeyChecking=no none
```

`StrictHostKeyChecking` is disabled here because SystemRescue uses randomly
generated host keys. Also when using the `ProxyCommand` like this, ssh can't
associate the host key to a specific remote host anymore.

You need to have [socat](http://www.dest-unreach.org/socat/) installed and maybe
have to open a local firewall (e.g. iptables, nftables) to allow the inbound
connection.

## Receiving reverse_ssh connections with a bounce host

If your ssh client is also behind a NAT router or firewall and thus not directly
accessible from the internet, you can use a bounce host to "catch" the
connection and forward it to your client machine.

The requirements for such a bounce host are minimal, so this can be anything
from a OpenWRT router to virtual machine in a data centre:

- Accessible from the internet with SSH and some other arbitrary TCP port number
- You have the credentials to log in via SSH as an ordinary user
- The option `GatewayPorts yes` is set in `/etc/ssh/sshd_config`

To receive the connection use these commands:

```
export RECEIVEPORT=2222
ssh -R ${RECEIVEPORT}:/tmp/reverse_ssh -N -f bouncehost.example.com
ssh -l root -o "ProxyCommand socat - UNIX-LISTEN:/tmp/reverse_ssh" -o StrictHostKeyChecking=no none
```

You need to have [socat](http://www.dest-unreach.org/socat/) installed on your
client machine (it is not necessary on the bounce host). If the bounce host has
a local firewall (e.g. iptables, nftables), you may need to open it for the TCP
port you receive the connection on.

The SSH connection to the bounce host will be forked into the background by the
"-f" parameter. You should kill the process when you are done. Alternatively,
remove the "-f" and call the second ssh in a separate shell.
