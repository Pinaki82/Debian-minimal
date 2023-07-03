#!/bin/bash

# DuckDuckGo: test hard drive for bad sectors in linux
# References:
# https://www.ubuntupit.com/how-to-check-bad-sectors-or-bad-blocks-on-hard-disk-in-linux/
# https://www.tecmint.com/check-linux-hard-disk-bad-sectors-bad-blocks/
# https://www.linuxtechi.com/check-hard-drive-for-bad-sector-linux/

BadSectorFinder() { # Show drive info and test the drive
  echo "To cancel the operation, type CTRL+c."
  echo ""
  echo "What is the 'SCSI ID address' of the 'Drive Partition' you want to check for bad sectors?"
  echo "It should look like /dev/sda, /dev/sdb etc. So, please type the full path like '/dev/sda' without quotation marks."
  echo "If you are unsure, please open up 'GNOME Disk Utility' and verify the device partition from there."
  echo "To install GNOME Disk Utility, use the command 'sudo apt install gnome-disk-utility' without quotation marks."
  echo "Or else, you can type these following commands (obviously, without quotation marks) 'lsblk -o NAME,MODEL,FSTYPE,SIZE,MOUNTPOINT' and 'lsblk -d | grep disk' to get the same information."
  echo "The script will do that for you. Relax!"
  # DuckDuckGo:
  # how to know about the drive partitions from the terminal in linux
  # lsblk drive maker model
  # Ref 1: http://support.moonpoint.com/os/unix/linux/utilities/sysmgmt/lsblk-lshw.php
  # ref 2: https://www.cyberciti.biz/faq/linux-list-disk-partitions-command/
  lsblk -o NAME,MODEL,FSTYPE,SIZE,MOUNTPOINT
  lsblk -d | grep disk
  echo "Please, scroll up and read the instructions."
  echo "Now, please type the path to the Drive Partition."
  sleep 2
  read drvparttn
  echo ""
  echo "A report will be generated and saved to your $HOME directory."
  sleep 2
  sudo badblocks -v ${drvparttn} > ~/badsectors.txt
}


# Body of code
BadSectorFinder

# actual command:
## sudo badblocks -v /dev/sda > badsectors.txt

