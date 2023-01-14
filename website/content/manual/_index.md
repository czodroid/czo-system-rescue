+++
title = "Manual"
draft = false
+++

Here is the list of all the detailed documentation available in English for the
SystemRescue project. You can also read the [book](/Books/) if you are new to this
project or if you need a step-by-step guide to start.

## For the impatient

* [Quick start guide](/Quick_start_guide/): read this if this is the first time you use the livecd

## Basic usage

* [Overview of the livecd](/manual/Overview/)
* [Downloading and burning](/manual/Downloading_and_burning/)
* [How to install SystemRescue on an USB-stick](/Installing-SystemRescue-on-a-USB-memory-stick/)
* [Booting SystemRescue and list of boot options supported](/manual/Booting_SystemRescue/)
* [Booting on a serial console](/manual/Booting_on_a_serial_console/)
* [Installing SystemRescue on the disk](/manual/Installing_SystemRescue_on_the_disk/)
* [Starting to use the system](/manual/Starting_to_use_the_system/)
* [Network: configuration and programs](/manual/Network_configuration_and_programs/)
* [Inventory of the System tools provided](/System-tools/)
* [Mounting an NTFS partition with full Read-Write support](/manual/Mounting_ntfs_filesystems/)

## Advanced usage

* [Creating a backing-store to keep your modifications](/manual/Creating_a_backing_store/)
* [Installing additional software packages with pacman](/manual/Installing_packages_with_pacman/)
* [Installing additional packages from AUR with yay](/manual/Installing_packages_from_AUR/)
* [Configuring SystemRescue with YAML files](/manual/Configuring_SystemRescue/)
* [Configuring SystemRescue with YAML files: sysconfig scope](/manual/Configuring_SystemRescue_sysconfig/)
* [Creating SystemRescue Modules with custom files or packages](/Modules/)
* [PXE network booting with SystemRescue](/manual/PXE_network_booting/)
* [Booting a broken linux system on the hard disk](/manual/Booting_a_broken_linux_system_on_the_hard_disk/)
* [Run your own scripts at start-up with autorun](/manual/Run_your_own_scripts_with_autorun/)
* [Let your own programs take over a virtual terminal for user interaction: autoterminal](/manual/autoterminal_scripts_on_virtual_terminal/)
* [Secure Deletion of Data](/manual/Secure_Deletion_of_Data/)
* [Backup data from an unbootable Windows computer](/manual/Backup_data_from_an_unbootable_windows_computer/)
* [Backup and transfer your data using rsync](/manual/Backup_and_transfer_your_data_using_rsync/)

## Administration scripts

* [mountall: Mount all disks and volumes](/scripts/mountall/)
* [Reverse_ssh: Get an SSH access to a SystemRescue host running behind a NAT](/scripts/reverse_ssh/)
* [sysrescue-customize: customize SystemRescue ISO-images and add your own files](/scripts/sysrescue-customize/)

## LVM (Logical Volume Manager)

* [LVM: Overview of the logical volume manager](/lvm-guide-en/Overview-of-the-logical-volume-manager/)
* [LVM: How the logical volume manager works](/lvm-guide-en/How-the-logical-volume-manager-works/)
* [LVM: Booting linux from LVM volumes](/lvm-guide-en/Booting-linux-from-LVM-volumes/)
* [LVM: Moving the linux rootfs to an LVM volume](/lvm-guide-en/Moving-the-linux-rootfs-to-an-LVM-volume/)
* [LVM: Making consistent backups with LVM](/lvm-guide-en/Making-consistent-backups-with-LVM/)

## Disk partitioning

* [Introduction to disk partitioning](/disk-partitioning/Introduction-to-disk-partitioning/)
* [Partitions attributes (identifiers, flags, names)](/disk-partitioning/Partitions-attributes/)
* [Standard partitioning tools for Linux](/disk-partitioning/Standard-partitioning-tools/)
* [The new GPT disk Layout for disk partitioning](/disk-partitioning/The-new-GPT-disk-layout/)
* [Grub: description of the boot stages](/disk-partitioning/Grub-boot-stages/)
* [Repairing a damaged Grub](/disk-partitioning/Repairing-a-damaged-Grub/)
