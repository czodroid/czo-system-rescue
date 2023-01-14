+++
title = "Let your own programs take over a virtual terminal for user interaction: autoterminal"
draft = false
+++

## Autoterminal overview
Linux provides several virtual terminals on the console that can be switched
with ALT+F\<n\>. By default 6 virtual terminals (ALT+F1 to ALT+F6) are created
and used for gettys with automatic root login. See the `noautologin` 
[boot option](/manual/Booting_SystemRescue/) and the `NAutoVTs` option in 
`/etc/systemd/logind.conf` if you want to change these defaults.

Autoterminal allows to replace the getty and shell on a virtual terminal with a program of your own choosing.

## Configuration

Configuration is done solely through entries in the [YAML configuration](/manual/Configuring_SystemRescue/)
using the `autoterminal` scope. The device name of the terminal (`tty<n>`) is the key, the value is
the command to execute:
```
---
autoterminal:
    tty2: "/usr/bin/setkmap"
    tty3: "/root/myscript \"parameter one\""
    tty4: "/usr/bin/tmux"
    tty8: "/usr/bin/journalctl -f"
```

If you want to use command parameters that include spaces or quotes you have to escape them with a backslash ("\\").
The command given is written into a systemd unit file unmodified, so see the systemd documentation for details.

## Execution order

Autoterminals are started only after [autorun](/manual/Run_your_own_scripts_with_autorun/) is finished. This
allows you to use autorun to prepare data or download programs used for autoterminal from a remote server.

Systemd by default delays the start of a getty by 5 seconds (`Type=idle`). This prevents any console output
of other programs to clutter the terminal. Autoterminal always directly starts the configured programs instead (`Type=simple`).
This is to directly allow user interaction without any waiting time.

## Possible conflicts

By default systemd creates 6 virtual terminals. But Linux allows up to 63 virtual terminals, although
usual keyboards don't have more than 12 F-Keys to access them. You can use all virtual terminals you
can access with your keyboard with autoterminal. For each configured autoterminal, the default terminals 
configured in systemd will be masked to prevent conflicts.

When you use the `dostartx` [boot option](/manual/Booting_SystemRescue/), you have to leave `tty1` at it's
default configuration, otherwise `dostartx` won't work. You can still manually execute `startx` on other terminals
when `tty1` is used by autoterminal.

## Serial terminals

You can also use autoterminal on [serial consoles](/manual/Booting_on_a_serial_console/). Since serial devices need different configuration,
autoterminal must know that it is used with a serial console. This is done by prefixing the terminal
name with `serial:`:
```
---
autoterminal:
    "serial:ttyS0": "/usr/bin/tmux"
```

Autoterminal does not configure the serial device in any way, like setting baud rates, stop bits and similar.
This is usually done on the kernel boot command line when using a serial device as serial console, for example
like this: `console=ttyS0,115200n8`. But it can also be done separately, for example with [autorun](/manual/Run_your_own_scripts_with_autorun/).

## Usage examples

* You can run **tmux** on a virtual terminal. This will allow you (among other things) to scroll back in the
terminal again, a feature that was removed from virtual terminals with kernel 5.9 due to bugs.

* You can create small **interactive text menus**. SystemRescue comes with the program `dialog` and a 
[Python library for it](https://pythondialog.sourceforge.io/), which allows to create such menus easily.

* Have the latest messages in the **journal** shown on a virtual terminal, to see failures and warnings.
Use `journalctl -f` to enable follow-mode.
