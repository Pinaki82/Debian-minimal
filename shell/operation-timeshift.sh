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

# sudo timeshift --restore


sudo timeshift --rsync --create --comments "2020-11-27-02-30-pm"

# Delete snapshots:
# sudo timeshift --list
# sudo timeshift --delete --snapshot '2022-10-27_13-30-02'
