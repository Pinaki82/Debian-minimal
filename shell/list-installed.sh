#!/bin/bash

# ---------------------------------------------------------------------------
# Get an overview of the packages you've installed on your system.
# Dependencies may show up. However, the script will try to list packages
# you've manually installed wherever possible.
#
# Always keep an inventory of packages you've
# installed. It's the best practice.
# ---------------------------------------------------------------------------

# Brave: ubuntu list installed packages without listing dependencies
# https://askubuntu.com/questions/680392/how-to-get-the-list-of-installed-packages-without-dependencies
# https://askubuntu.com/questions/17823/how-to-list-all-installed-packages/496042

cd ~/ && \
zcat /var/log/apt/history.log.*.gz | cat - /var/log/apt/history.log | grep -Po '^Commandline:(?= apt(-get)?)(?=.* install ) \K.*' | sed '1,4d' > packages.txt \
