#!/bin/sh
#
# Filename: archzfskey.sh
# Author: Olivier Sirol <czo@free.fr>
# License: GPL-2.0 (http://www.gnu.org/copyleft)
# File Created: Jan 2021
# Last Modified: Saturday 18 June 2022, 18:03
# Edit Time: 0:02:54
# Description:
#
#     Trust archzfs key, to run before doing a pacman install
#
# $Id:$
#

pacman-key --init
pacman-key -r DDF7DB817396A49B2A2723F7403BD972F75D9D76
pacman-key --lsign-key DDF7DB817396A49B2A2723F7403BD972F75D9D76

pacman -Sy


