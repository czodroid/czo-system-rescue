# Filename: Makefile
# Author: Olivier Sirol <czo@free.fr>
# License: GPL-2.0 (http://www.gnu.org/copyleft)
# File Created: 17 June 2023
# Last Modified: Saturday 17 June 2023, 10:05
# Edit Time: 0:02:04
# Description:
#               Makefile for this project
#
#      $@ Target name
#      $< Name of the first dependency
#      $^ List of dependencies
#      $? List of dependencies newer than the target
#      $* Target name without suffix
#
# Copyright: (C) 2023 Olivier Sirol <czo@free.fr>

all: $(EXEC)
	./build.sh -v
	@echo "<- all done!"

clean:
	rm -fr work out
	@echo "<- clean done!"

realclean: clean

fclean: realclean

re: realclean all

.PHONY: all clean realclean fclean re

