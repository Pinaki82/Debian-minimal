#!/bin/bash

sudo fstrim -av && \
sudo fstrim -v /  \

# chmod +x ssd_trim.sh

# Run at each login
#
# echo '~/shell/ssd_trim.sh' >> ~/.bash_profile
# Or
# mousepad ~/.bash_profile
# Add:
# ~/shell/ssd_trim.sh
#
# sudo mousepad /etc/rc.local
# Add:
# sudo -u YOUR_USERNAME ~/shell/ssd_trim.sh
# Like: sudo -u spiderman ~/shell/ssd_trim.sh
# Or
# sudo -u $(whoami) /home/$(whoami)/shell/ssd_trim.sh
#
# Reboot
#
# Is it working?
# Test with one (unrelated) example
# xterm -ls -xrm 'XTerm*selectToClipboard: true'&
