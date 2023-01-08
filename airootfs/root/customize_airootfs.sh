#!/bin/bash

set -e -u

echo "customize_airootfs.sh started..."

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

#cp -aT /etc/skel/ /root/

# Permissions
chmod 750 /root
chmod 755 /etc/systemd/scripts/*

# Configuration
sed -i 's/#\(PermitRootLogin \).\+/\1yes\nAllowUsers root/' /etc/ssh/sshd_config
sed -i 's/#\(PermitEmptyPasswords \).\+/\1no/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf
sed -i 's/#\(Audit=\)yes/\1no/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

# PulseAudio takes care of volume restore
ln -sf /dev/null /etc/udev/rules.d/90-alsa-restore.rules

# Services
systemctl enable NetworkManager.service
systemctl enable iptables.service
systemctl enable ip6tables.service
#systemctl enable pacman-init.service
systemctl enable choose-mirror.service
systemctl enable sshd.service
systemctl enable sysrescue-initialize.service
systemctl enable sysrescue-autorun.service
systemctl enable cronie.service
systemctl enable qemu-guest-agent.service
systemctl set-default multi-user.target

# Mask irrelevant timer units (#140)
systemctl mask atop-rotate.timer
systemctl mask shadow.timer
systemctl mask man-db.timer
systemctl mask updatedb.timer

# setup pacman signing key storage, trust archzfs key
/usr/bin/pacman-key --init
/usr/bin/pacman-key          -r DDF7DB817396A49B2A2723F7403BD972F75D9D76
/usr/bin/pacman-key --lsign-key DDF7DB817396A49B2A2723F7403BD972F75D9D76
/usr/bin/pacman-key --populate
rm -f /etc/pacman.d/gnupg/*~

# Provide additional commands (using busybox instead of binutils to save space)
ln -sf /usr/bin/busybox /usr/local/bin/ar
ln -sf /usr/bin/busybox /usr/local/bin/strings

# Cleanup

# pacman --noconfirm -Rs linux-lts-headers
rm -rf /usr/lib/modules/$(uname -r)/build/
# czo: I'll do an debian zfs sysrescue !!!
# and, sysrecue team, thanks for your work !!!

find /usr/lib -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
find /usr/lib -type f,l -name '*.a' -delete
rm -rf /usr/lib/{libgo.*,libgphobos.*,libgfortran.*}
rm -rf /usr/share/gtk-doc /usr/share/doc
rm -rf /usr/share/keepassxc/docs /usr/share/keepassxc/translations
rm -rf /usr/share/help
#rm -rf /usr/share/gir*
#rm -rf /usr/include
#rm -rf /usr/share/man/man3

# Cleanup XFCE menu
sed -i '2 i NoDisplay=true' /usr/share/applications/{xfce4-mail-reader,xfce4-web-browser}.desktop
sed -i "s/^\(Categories=\).*\$/Categories=Utility;/" /usr/share/applications/{geany,*ristretto*,*GHex*}.desktop

# Remove large/irrelevant firmwares
rm -rf /usr/lib/firmware/{liquidio,netronome,mellanox,mrvl/prestera,qcom}

# Remove extra locales
if [ -x /usr/bin/localepurge ]
then
    echo -e "MANDELETE\nDONTBOTHERNEWLOCALE\nSHOWFREEDSPACE\nen\nen_US\nen_US.UTF-8" > /etc/locale.nopurge
    /usr/bin/localepurge
fi

# Update pacman.conf
sed -i -e '/# ==== BEGIN sysrescuerepo ====/,/# ==== END sysrescuerepo ====/d' /etc/pacman.conf

# Check for issues with binaries
/usr/bin/check-binaries.sh

# Customizations
/usr/bin/updatedb

# Packages
pacman -Q > /root/packages-list.txt
expac -H M -s "%-30n %m" | sort -rhk 2 > /root/packages-size.txt

# Generate HTML version of the manual
markdown -o usr/share/sysrescue/index.html usr/share/sysrescue/index.md

## 2021/01/30 : Modified by Olivier Sirol <czo@free.fr>

# date
date > /root/czo@free.fr
echo $(date +%Y-%m-%d) > /etc/lsb-czo-installdate
echo $(date +%Y-%m-%d) > /etc/lsb-czo-updatedate

# allow ssh X11Forwarding
perl -i -pe 's,^#?X11Forwarding.*,X11Forwarding yes,' /etc/ssh/sshd_config

# cron czo-motd-czolsb
cat << 'EOF' > /etc/cron.d/czo-motd-czolsb
# Filename: czo-email-at-reboot
# 2022/05/21 : Modified by Olivier Sirol <czo@free.fr>

@reboot      root   /etc/czolsb > /etc/motd 2> /dev/null
EOF
chmod 644 /etc/cron.d/czo-motd-czolsb

# # cp font
# cp -f /root/SourceCodeProforPowerline-Regular.otf /usr/share/fonts
# rm -f /root/SourceCodeProforPowerline-Regular.otf

# # cp wallpaper
# cp -f /root/root.jpg /usr/share/backgrounds/xfce/xfce-teal.jpg
# cp -f /root/root.png /usr/share/backgrounds/xfce/xfce-verticals.png
# rm -f /root/root.jpg
# rm -f /root/root.png

# mnt
mkdir -p /mnt/sda1
mkdir -p /mnt/sdb1

# config files
cd /root
wget -qO- http://git.io/JkHdk | sh


