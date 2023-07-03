#!/bin/bash

# Google: error writing to output file -write ubuntu update
# Usually occurs after a Linux-image update.
# https://www.maketecheasier.com/fix-ubuntu-update-errors
# Package Hash Mismatch

# sudo apt update
# gives:

# W:Failed to fetch package:/var/lib/apt/lists/partial/in.archive.ubuntu.com_ubuntu_dists_oneiric_restricted_binary-i386_Packages Hash Sum mismatch
# W:Failed to fetch package:/var/lib/apt/lists/partial/in.archive.ubuntu.com_ubuntu_dists_oneiric_multiverse_binary-i386_Packages Hash Sum mismatch
# E:Some index files failed to download. They have been ignored, or old ones used instead
# In order to fix this, you can enter this into the Terminal:

# sudo apt clean && \

sudo apt autoclean && \
sudo rm -rf /var/lib/apt/lists/*  && \
sudo apt update && \
sudo apt autoclean && \
sudo apt autoremove \

