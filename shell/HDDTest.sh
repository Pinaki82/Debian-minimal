#!/bin/bash

# Test your Hard Drive Speed.
# The Linux Way of measuring drive read/write speed similar to
# doing the same with 'HD Tune Pro' on MS Windows.

# References:
# https://www.linux-magazine.com/Online/Features/Tune-Your-Hard-Disk-with-hdparm
# https://www.geeksforgeeks.org/hdparm-command-in-linux-with-examples/
# https://www.geekyard.com/os/linux-os/check-your-hard-disk-speed-on-ubuntu-with-benchmark/


# Function declarations
DriveTest() { # Show drive info and test the drive
  echo "To cancel the operation, type CTRL+c."
  echo ""
  echo "What is the 'SCSI ID address' of the 'Drive Partition' you want to test?"
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
  echo "Would you like to see the drive info in detail? (no=0). Type ZERO in Numbers to say NO."
  sleep 2
  read choice
  echo "Your input was $choice"
  sleep 1
  if [ "${choice}" != '0' ]; then
    sudo hdparm -I ${drvparttn} | more
  else
    sudo hdparm -I ${drvparttn}

  echo ""
  echo ""
  echo "A rough less-accurate value of the read speed will be calculated."
  sudo hdparm -t ${drvparttn}
  echo ""
  echo ""
  echo "A less-accurate value of the drive cache speed is going to be obtained."
  sudo hdparm -T ${drvparttn}
  echo ""
  echo ""
  echo "The kernel will directly read/write to the drive and obtain the read speed value. It's relatively accurate."
  sudo hdparm -t --direct ${drvparttn}
  echo ""
  echo ""
  echo "A fairly accurate drive cache speed will be obtained from the read/write operation performed directly by the kernel."
  sudo hdparm -T --direct ${drvparttn}
  fi
}


# Body of code
DriveTest

# actual commands:
## sudo hdparm -I /dev/sda | more
## sudo hdparm -t /dev/sda
## sudo hdparm -t --direct /dev/sda
## sudo hdparm -T /dev/sda
## sudo hdparm -T --direct /dev/sda

