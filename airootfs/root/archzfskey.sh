#!/bin/sh
#
# Filename: archzfskey.sh
# Author: Olivier Sirol <czo@free.fr>
# License: GPL-2.0
# File Created: Jan 2021
# Last Modified: Saturday 30 January 2021, 19:55
# Edit Time: 0:01:23
# Description:
#                Trust archzfs key
#
# $Id:$
#

pacman-key --init
pacman-key -r DDF7DB817396A49B2A2723F7403BD972F75D9D76
pacman-key --lsign-key DDF7DB817396A49B2A2723F7403BD972F75D9D76

pacman -Sy


