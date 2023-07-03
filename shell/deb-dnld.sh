#!/bin/bash

# Download all installed packages on Ubuntu
# http://www.beginninglinux.com/home/backup/download-all-installed-packages-on-ubuntu

# ------------------------------------------------------------------------
# Download and Create a local repository of the packages
# installed on your system.
# ------------------------------------------------------------------------

# sudo thunar /var/cache
# R-click on the folder 'apt' and
# create an archive.
# Make a .tar.gz archive of the downloaded packages.
# Put that .tar.gz file into a pen drive and take it to other machines
# where you need to install the same packages.
# Extract the archive into the folder /var/cache on that machine.
# NOTE: You'll need an active internet connection to
# install software on any system. Downloaded installer files will save
# your time to fetch packages from a remote repository and may
# also save some bandwidth (depending on the size of each
# program and the number of programs on your system).

# Folder structure: ###############################
#     /var/cache/apt
#               /apt/
#                    archives/
#                             pkgcache.bin
#                             srcpkgcache.bin
#                    archives/
#                    archives/partial/
#                    archives/
#                             a - z package.deb
# ###############################################

# ###############################################
# Alternatively, you can run the following commands
# to keep a list of installed packages in a compressed archive.

# --------------------------------------------------------------------------------
# sudo apt install apt-clone
# mkdir ~/aptback
# sudo apt-clone clone ~/aptback
# apt-clone info ~/aptback/apt-clone-state-YOUR_USERNAME-VirtualBox.tar.gz
# --------------------------------------------------------------------------------

# Run the command written below to restore the packages from the same list:

# --------------------------------------------------------------------------------
# sudo apt-clone restore ~/aptback/apt-clone-state-YOUR_USERNAME-VirtualBox.tar.gz
# --------------------------------------------------------------------------------

# Note that the command 'sudo apt-clone clone xxxxxxxxxx' won't back up the
# installer (*.deb) files. Keep that in mind.
# Run 'sudo apt-clone restore xxxxxxxx' once you've copied the
# installer files into the respective directory (/var/cache/apt).
#
# https://www.2daygeek.com/apt-clone-backup-installed-packages-and-restore-them-on-fresh-ubuntu-system/
# https://ubunlog.com/en/apt-clone-copia-seguridad-paquetes/
# ###############################################

dpkg -l | grep "^ii"| awk ' {print $2} ' | xargs sudo apt-get -y install --reinstall --download-only \
