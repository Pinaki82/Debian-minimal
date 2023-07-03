#!/bin/bash


# https://www.linuxquestions.org/questions/linux-general-1/remove-%27write-protection-on-pendrive-4175623445/
# https://frameboxxindore.com/linux/how-do-i-remove-write-protection-from-a-flash-drive-in-ubuntu.html

# -----------
# lsusb
# dmesg
# dmesg | less
# usb-devices
# lsblk
# sudo blkid
# sudo fdisk -l
# -----------

lsusb && \
lsblk && \
lsblk -o model && \
sudo fdisk -l \


# Remove the write protection: (1 of 2)
# -----------
# Mount the drive.

# Examples:

# /usr/bin/udisksctl mount -b /dev/sdb2 /media/appu/LINUX_BAK/ > /dev/null 2>&1

# or

# /usr/bin/udisksctl mount -b /dev/sdc1 /media/jj/external  > /dev/null 2>&1

# That means,

# /usr/bin/udisksctl mount -b /dev/[DEVICE_and_DRIVEPARTITION] /media/YOUR_USERNAME/PARTITION_NAME/ > /dev/null 2>&1

# DEVICE == /dev/sdb or /dev/sdc etc.
# DRIVEPARTITION == /dev/sdb1, sdb2, sdc1, sdc2, sdc3 etc.
# Trick: Hit the TAB key to get some hint about the DEVICE and
# DRIVEPARTITION parameters.

# Remove the write protection: (2 of 2)
# -----------

# sudo hdparm -r0 /dev/sdX

# 'X' being the DEVICE.
# -----------
printf "\n"
echo "**NOTE:** Open this script with a text editor and read the instructions provided under the comments."
