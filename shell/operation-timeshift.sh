#!/bin/bash

# =======================================================================
# On-Demand 'System Restore Point'/'System Snapshot' creation
# and restoration from the same.
# Reference: https://dev.to/rahedmir/how-to-use-timeshift-from-command-line-in-linux-1l9b
# Note:
# First, create a timeshift config from the GUI Wizard.
# Then, use this shell script to create a snapshot.
# If anything goes wrong and you are unable to log-in from the GUI,
# press CTRL+ALT+F3, type Administrator username and Administrator password
# when prompted.
# Navigate to the directory where you keep your shell scripts,
# For example, $ cd shell/
# Type $ ls to list the files so that you get an overview of the files
# in that folder.
# Find this shell script 'operation-timeshift.sh'
# Type $ nano operation-timeshift.sh
# Edit the lines. Comment the line containing the commands to
# create snapshots. Uncomment the line that contains the commands
# to restore from a backup. Save the file. Nano is a moderately simple text
# editor, so you won't get into much trouble using it.
# Exit nano after saving the script.
# Type $ sh operation-timeshift.sh
# Follow the instructions.
# =======================================================================

# Examples:

# sudo timeshift --rsync --create --comments "Name_of_your_Snapshot"

# Restoration:

# sudo timeshift --restore

# Or,
# sudo fdisk -l
# https://linuxhandbook.com/linux-list-disks/

# sudo fdisk -l
# Disk /dev/sdb: 1.82 TiB, 2000398934016 bytes, 3907029168 sectors
# Disk model: ST2000NP0011
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disklabel type: dos
# Disk identifier: 0x4xxxxx4

# Device     Boot      Start        End    Sectors  Size Id Type
# /dev/sdb1            65535 3907000094 3906934560  1.8T 83 Linux
# /dev/sdb2                1      65534      65534   32M 83 Linux
# /dev/sdb3       3907000095 3907000095          1  512B 83 Linux

# Partition table entries are not in disk order.


# Disk /dev/sdc: 238.47 GiB, 256060514304 bytes, 500118192 sectors
# Disk model: CONSISTENT SSD S
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disklabel type: dos
# Disk identifier: 0x6xxxxxx1

# Device     Boot Start       End   Sectors   Size Id Type
# /dev/sdc1        2048 500117503 500115456 238.5G 83 Linux


# Disk /dev/sda: 223.57 GiB, 240057409536 bytes, 468862128 sectors
# Disk model: KINGSTON SQ500S3
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disklabel type: dos
# Disk identifier: 0x3xxxxxe

# Device     Boot     Start       End   Sectors   Size Id Type
# /dev/sda1  *         2048 466862079 466860032 222.6G 83 Linux
# /dev/sda2       466864126 468860927   1996802   975M  5 Extended
# /dev/sda5       466864128 468860927   1996800   975M 82 Linux swap / Solaris

# ChatGPT:
# In the `timeshift --restore` command, the `--target` parameter specifies the **target disk or partition** where the snapshot will be restored. Here's a breakdown of the parameters:

### Command Components
# 1. **`--restore`**: Initiates the restoration process for a snapshot.

# 2. **`--snapshot` '2023-10-26_14-34-12'**: Specifies the snapshot you want to restore. This snapshot was created earlier using Timeshift.

# 3. **`--target /dev/sdx`**: This defines the **target partition or disk** where the snapshot will be restored.

# ---

### Understanding `--target`
# - The `--target` parameter allows you to choose a specific disk or partition where Timeshift should restore the snapshot. For example:
#   - If you want to restore the snapshot to the same partition where your Linux installation is located, you would use the partition where your root filesystem (`/`) is stored. In your case, this is `/dev/sda1`.
#   - If you want to restore to a different disk or partition, specify that disk or partition instead.

# **Note:** The `--target` should match the disk where your Linux system resides, typically the partition that was used when creating the snapshot.

# ---

### Which Disk/Partition to Restore to?

# Based on your setup:
# 1. **Linux Installation**: Your Linux system and `HOME` directory are on `/dev/sda1`. This is the correct target if you are restoring your root filesystem and want to return your system to the state captured in the snapshot.

# 2. **Command Example**:
#    ```bash
#    sudo timeshift --restore --snapshot '2023-10-26_14-34-12' --target /dev/sda1
#    ```

# 3. **Important Considerations**:
#    - **Backup Data First**: Restoring a snapshot overwrites the target disk/partition, potentially erasing existing data. Ensure your important files are backed up.
#    - **Bootloader**: If you restore to a new disk or partition, you may need to reinstall or update the bootloader (e.g., GRUB) to boot into the restored system.
#    - **Partition Alignment**: Make sure the partition layout matches the snapshot's configuration. For example, restoring a root filesystem snapshot to a partition not configured as the root might cause boot issues.



# sudo timeshift --restore --snapshot '2023-10-26_14-34-12' --target /dev/sdx [Your Linux system installation partition. The **target partition or disk** where the snapshot will be 'restored'. It is the place where your Linux installation is located. According to what was shown in the output, this is currently `/dev/sda1`.]


sudo timeshift --rsync --create --comments "2024-12-06-01-25-am"

# Delete snapshots:
# sudo timeshift --list
# sudo timeshift --delete --snapshot '2022-10-27_13-30-02'
