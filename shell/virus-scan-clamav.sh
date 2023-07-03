#!/bin/bash

# https://askubuntu.com/questions/250290/how-do-i-scan-for-viruses-with-clamav

# Update the AV database
# ------------------------------------------------------------------------------
# sudo freshclam && \
# ------------------------------------------------------------------------------
# clamscan OPTIONS File/Folder

# To check all files on the computer, displaying the name of each file:
# ------------------------------------------------------------------------------
# sudo clamscan -r /
# ------------------------------------------------------------------------------
# 'r' stands for recursive (means: "include files in the subdirectory trees as well")

# To check all files on the computer,
# but only display infected files and ring a bell when found:
# ------------------------------------------------------------------------------
# clamscan -r --bell -i /
# ------------------------------------------------------------------------------

# To scan all files on the computer but only display infected files when
# found and have this run in the background:
# ------------------------------------------------------------------------------
# clamscan -r -i / &
# ------------------------------------------------------------------------------
# Note - Display background process's status by running the jobs command.
# Notice the '&' (ampersand) symbol.
# ------------------------------------------------------------------------------
# Example: clamscan -r -i /home/YOUR_USERNAME/ &
# ------------------------------------------------------------------------------
# https://linuxhandbook.com/jobs-command/
# 'jobs' will display the running background process(es)

# To check files in the all users home directories:
# ------------------------------------------------------------------------------
# clamscan -r /home
# ------------------------------------------------------------------------------

# To check files in the USER home directory and remove infected files
# (WARNING: Files will be deleted):
# ------------------------------------------------------------------------------
# clamscan -r --remove /home/USER
# ------------------------------------------------------------------------------

# To scan all folders in your computer (except /sys):
# ------------------------------------------------------------------------------
# clamscan -r -i --exclude-dir="^/sys" --bell /
# ------------------------------------------------------------------------------
