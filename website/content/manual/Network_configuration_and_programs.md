+++
title = "Network configuration and programs"
draft = false
aliases = ["/Sysresccd-manual-en_Network"]
+++

## Network configuration tools

If your system has supported hardware, the Ethernet or Wifi network adapter 
should be automatically detected, the driver loaded and auto configuration via 
DHCP attempted.

SystemRescue uses NetworkManager as the default network configuration tool. It 
provides a very user friendly graphical interface to configure the network. It 
makes the configuration easier especially for wireless networks. For instance, 
wireless networks will be automatically detected and connecting to them is very 
easy. Within X11 NetworkManager is available as a small icon in the taskbar just 
next to the clock. It also provides `nmcli` and `nmtui` if you want to configure 
the network using a command line or a semi-graphical interface from a terminal.

You can also configure the network with other tools such as the standard 
`ifconfig` or `ip` commands. In that case you will have to stop the 
NetworkManager service first, else it will conflict and you will loose your 
settings. You can stop it by running `systemctl stop NetworkManager` in the 
shell.

## Manually configure the network

By default all network interfaces are activated and automatically configured. 
The command `nmcli` will show an overview of what is currently configured.

To disable and re-enable interfaces use `nmcli conn down "Wired connection 1"` 
and `nmcli conn up "Wired connection 1"`. Note that "Wired connection 1" used as 
example here is not the name of the interface as assigned by the kernel, but a 
name internal to NetworkManager. Use `nmcli` to get an overview of all 
connections and their names.

To manually set a static IP, netmask, gateway you can also use nmcli:
```
nmcli conn mod "Wired connection 1" ipv4.method manual
nmcli conn mod "Wired connection 1" ipv4.addr 192.168.1.20/24
nmcli conn mod "Wired connection 1" ipv4.gateway 192.168.1.1
nmcli conn mod "Wired connection 1" ipv4.dns 192.168.1.1
nmcli conn up "Wired connection 1"
```
The last "conn up" is required to reconfigure the interface with the new parameters.

To switch back to automatic configuration via DHCP use:
```
nmcli conn mod "Wired connection 1" ipv4.method auto
nmcli conn up "Wired connection 1"
```

## Firewall

Since version 6.0.4 SystemRescue comes with the iptables firewall enabled to 
block incoming connections requests by default. You need to update the iptables 
configuration or stop the iptables and ip6tables services if you need to be able 
to receive incoming connections from outside. You can boot SystemRescue using 
the `nofirewall` option on the command line if you don't want the firewall.

## Running an SSH Server

SSH allows you to use a shell on another computer and you can copy files (with 
scp or rsync over ssh). SSHd is already running in the background. But to allow 
incoming connections, you have to allow the connection through the firewall (see 
above) and change the root password. Just type `passwd` to set a password. You 
can also use the `rootpass=xxx` or `rootcryptpass=xxxx` boot options before 
SystemRescue starts to define the root password.

A more secure alternative is to use SSH key files. You can install authorized
keys on your SystemRescue media with [a YAML file](/manual/Configuring_SystemRescue_sysconfig/).

## Accessing a Share on a Windows computer with CIFS

SystemRescue comes with the smbfs/cifs client package that allows you to connect 
to a Windows machine having shared drives. In recent kernels, support for smbfs 
has been replaced with cifs so you should try not to use smbfs.

The mount-cifs package allows you to access a Windows computer on the network. 
Here is an example to explain how to access Windows shared folders. Let’s 
consider the Windows box is on 192.168.10.3 and has a shared directory called 
mydata accessible by the user called robert:

```
mkdir /mnt/windows
mount -t cifs //192.168.10.3/mydata /mnt/windows -o username=robert,password=passwd
cd /mnt/windows
```

Now you should be able to see files in /mnt/windows. Do not forget to unmount 
the directory when you have finished what you are doing in the shared directory.

```
umount /mnt/windows
```

## Mounting remote SSH shares as local file systems

If you want to access files located on a remote system you can connect via SSH 
to, you can mount a remote directory with ssfs and the FuSE library. The 
“Userland FileSystem” allows you to mount the share, and work on the remote 
files just as you would work on any local files. With all these file systems, 
you can umount the share with the standard `umount` command. Here is an example 
of how to mount an SSH file system in /mnt/ssh as anonymous (read only)

```
mkdir /mnt/ssh
passwd root
sshfs login@ssh.server.org:/path/to/dir /mnt/ssh
cd /mnt/ssh
umount /mnt/ssh
```

## Accessing cloud storage (WebDAV, S3 and others)

SystemRescue contains the program [rclone](https://rclone.org) which allows to
access, sync and mount many different cloud storage services. To use it you have 
to configure a storage service with `rclone config` in an interactive menu first.
Each service is assigned a remote name this way.

Afterwards use `rclone ls <remote name>:` to list the remote contents.

Use `rclone copy /local/path  <remote name>:destpath` to upload a file and 
`rclone copy <remote name>:sourcefile /local/targetpath` to download.

