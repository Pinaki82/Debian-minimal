#!/bin/bash

# https://linoxide.com/linux-how-to/remove-orphaned-packages-ubuntu/
# Simply run 'deborphan' (without quotes) to get an overview
# of the leftover packages, then uninstall them manually.

deborphan \

# To remove all orphaned packages, run:
# sudo apt remove --purge `deborphan`
# sudo apt remove --purge `deborphan --exclude=package_name`
# sudo apt remove --purge `deborphan --exclude=libsensors-applet-plugin0:amd64`

