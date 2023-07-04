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

curl "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts" --output hosts00001.txt && \

# curl "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts" --output hosts00002.txt && \
# curl "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt" --output hosts00003.txt && \
# curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts" --output hosts00004.txt && \
# curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts" --output hosts00005.txt && \
# curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts" --output hosts00006.txt && \
# curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts" --output hosts00007.txt && \
# curl "https://raw.githubusercontent.com/AdguardTeam/cname-trackers/master/combined_disguised_trackers_justdomains.txt" --output hosts00008.txt && \
# curl "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts" --output hosts00009.txt && \
# curl "https://raw.githubusercontent.com/bigdargon/hostsVN/master/option/hosts-VN" --output hosts00010.txt && \
# curl "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt" --output hosts00011.txt && \
# curl "https://raw.githubusercontent.com/MetaMask/eth-phishing-detect/master/src/hosts.txt" --output hosts00012.txt && \
# curl "https://raw.githubusercontent.com/jamiemansfield/minecraft-hosts/master/lists/tracking.txt" --output hosts00013.txt && \
# curl "https://winhelp2002.mvps.org/hosts.txt" --output hosts00014.txt && \
# curl "https://raw.githubusercontent.com/shreyasminocha/shady-hosts/main/hosts" --output hosts00015.txt && \
# curl "https://someonewhocares.org/hosts/zero/hosts" --output hosts00016.txt && \
# curl "https://raw.githubusercontent.com/tiuxo/hosts/master/ads" --output hosts00017.txt && \
# curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts" --output hosts00018.txt && \
# curl "https://urlhaus.abuse.ch/downloads/hostfile/" --output hosts00019.txt && \
# curl "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext&useip=0.0.0.0" --output hosts00020.txt && \

# Brave Search: concatenate multiple text files in linux
# https://unix.stackexchange.com/questions/3770/how-to-merge-all-text-files-in-a-directory-into-one

cat *txt > totalhosts.txt && \

# Delete the downloaded files once the resulting file has been created

trash hosts00001.txt \

# trash hosts00002.txt && \
# trash hosts00003.txt && \
# trash hosts00004.txt && \
# trash hosts00005.txt && \
# trash hosts00006.txt && \
# trash hosts00007.txt && \
# trash hosts00008.txt && \
# trash hosts00009.txt && \
# trash hosts00010.txt && \
# trash hosts00011.txt && \
# trash hosts00012.txt && \
# trash hosts00013.txt && \
# trash hosts00014.txt && \
# trash hosts00015.txt && \
# trash hosts00016.txt && \
# trash hosts00017.txt && \
# trash hosts00018.txt && \
# trash hosts00019.txt && \
# trash hosts00020.txt \
