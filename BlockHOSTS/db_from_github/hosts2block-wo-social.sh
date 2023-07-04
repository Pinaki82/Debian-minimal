#!/bin/bash

# Automated update for malicious hostnames curated by users from across the world.

# update the system and install 'trash-cli' and 'curl' (required)

yes | sudo apt update && \
yes | sudo apt list --upgradable && \
yes | sudo apt upgrade && \
yes | sudo apt update && \
yes | sudo apt install -f && \
sudo apt install trash-cli -y && \
sudo apt install curl -y && \

# Download the lists of hostnames in multiple files, then merge the downloaded file into one large text blob

# Block everything without social media sites.

curl "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts" --output hosts00001.txt && \

# Brave Search: concatenate multiple text files in linux
# https://unix.stackexchange.com/questions/3770/how-to-merge-all-text-files-in-a-directory-into-one

cat *txt > totalhosts.txt && \

# Delete the downloaded files once the resulting file has been created

trash hosts00001.txt \

