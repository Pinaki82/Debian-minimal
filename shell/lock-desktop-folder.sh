#!/bin/bash

# Lock the Desktop folder on Linux
# to avoid cluttering your Desktop with files and folders
# that in turn spoil the beauty of the installation
# https://www.cyberciti.biz/faq/howto-set-readonly-file-permission-in-linux-unix/
# https://chmodcommand.com/chmod-444/
# https://chmodcommand.com/
# Example: chmod 0444 permissiontest/
# Where 'permissiontest' is the intended folder to be locked
# Unlock:
# https://www.linux.com/training-tutorials/how-manage-file-and-folder-permissions-linux/
# chmod u+rw permissiontest/

chmod 0444 ~/Desktop/ \
# Unlock (if you ever need):
# chmod u+rw ~/Desktop/

