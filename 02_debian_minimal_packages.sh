#!/bin/bash

# *********************
# Allow the file to execute (change permission parameters) (common step):
# chmod +x script_to_run.sh
# Run:
# ./script_to_run.sh
# Do not prepend 'sudo' to run this script.
# *********************


# ==================================== ROOT CHECK
# References (root check):
# https://superuser.com/questions/688882/how-to-test-if-a-variable-is-equal-to-a-number-in-shell
# YouTube/DistroTube/How To Use Shell Environment Variables  -  https://youtu.be/9ZpL8iDU7LY

echo "Checking whether you're running this script as root or not..."

if [ "$(id -u)" = 0 ]; then
  echo "You cannot run this script as root!"
  sleep 1
  exit 1
else
  echo "You can proceed..."
fi

# ************************************************************************
# NOTE:
# For string literal comparison:
#	  Spacing around == is a must
#   Spacing around = is a must
#   [[ ... ]] i.e., the double parenthesis reduces errors as no pathname expansion or word splitting takes place between [[ and ]]
#   Prefer quoting strings that are "words"

# For Integer comparison:
#   if [ "$(id -u)" = 0 ];

# Correct code (chmod -x \
#               ./script_to_run.sh): if [ "$(id -u)" = 0 ]; then
# echo $UID on root will always produce 0
# ************************************************************************
# ========================== (END) ROOT CHECK


# =================================================================
# virtualbox-shared-folder-permission
# =================================================================

echo "Are you on a VirtualBox VM (yes=1, no=0)?"
echo "Type 0 [zero in number] if you are on a real machine. (no=0)"
read choice
echo "Your input was $choice"
if [ "${choice}" != '0' ]; then
  echo "Oh no! You're on a VirtualBox VM!!"
  echo "Wait till the setup script stops running..."
   sleep 1
   exit
else
  echo "Ok. You're on a real machine."
  sleep 1

fi

# =================================================================
# virtualbox-shared-folder-permission (END)
# =================================================================


# =================================================================
# pip3 packages - path setup
# =================================================================

# export PATH="$HOME/.local/bin/:$PATH"

touch .bash_profile  && \
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n?rq=1
printf "Add the following entry,\n  then write changes & exit.\n"
echo "    export PATH="'"$HOME/.local/bin/:$PATH"'"    "
echo "file:  .bash_profile"
sleep 3
######################mousepad .bash_profile  && \
# https://askubuntu.com/questions/108258/what-is-the-bash-equivalent-of-doss-pause-command
read -p ""  && \
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n?rq=1
printf "Add the following entry,\n  then write changes & exit.\n"
echo "    export PATH="'"$HOME/.local/bin/:$PATH"'"    "
echo "file:  .bashrc"
sleep 3
######################mousepad .bashrc  && \
# https://askubuntu.com/questions/108258/what-is-the-bash-equivalent-of-doss-pause-command
read -p " "  && \
sleep 1
source "/home/$(whoami)/.bashrc"  && \
source "/home/$(whoami)/.bash_profile"  && \
source "/home/$(whoami)/.profile"  && \

# =================================================================
# pip3 packages - path setup (END)
# =================================================================


# =================================================================
# update
# =================================================================

yes | sudo apt update && \
yes | sudo apt list --upgradable && \
yes | sudo apt upgrade && \
yes | sudo apt update && \
yes | sudo apt install -f && \

# =================================================================
# update (END)
# =================================================================

# =================================================================
# Lock the Desktop folder on Linux
# =================================================================

# to avoid cluttering your Desktop with files and folders
# that in turn spoil the beauty of the installation
# https://www.cyberciti.biz/faq/howto-set-readonly-file-permission-in-linux-unix/
# https://chmodcommand.com/chmod-444/
# https://chmodcommand.com/
# Example: chmod 0444 permissiontest/
# Where 'permissiontest' is the intended folder to be locked
# Unlock:
# https://www.linux.com/training-tutorials/how-manage-file-and-folder-permissions-linux/
# chmod u+rw permissiontest/

yes | sudo chmod 0444 ~/Desktop/ && \

# Unlock (if you ever need):
# sudo chmod u+rw ~/Desktop/
# =================================================================
# Lock the Desktop folder on Linux (END)
# =================================================================


# =================================================================
# developer utilities
# =================================================================

sudo apt install build-essential -y && \
# sudo apt install tcc -y && \
sudo apt install patch -y && \
sudo apt install make -y && \
sudo apt install diffutils -y && \
sudo apt install llvm -y && \
sudo apt install clang -y && \
sudo apt install clangd -y && \
sudo apt install clang-tidy -y && \
sudo apt install clang-tools -y && \
sudo apt install lld -y && \
sudo apt install libomp-dev -y && \
sudo apt install curl -y && \
sudo apt install python3-pip -y && \
#python3 -m pip install --upgrade pip && \
# https://stackoverflow.com/questions/75608323/how-do-i-solve-error-externally-managed-environment-everytime-i-use-pip3
yes | sudo apt install pipx && \
pipx install flawfinder && \
# https://github.com/friendlyanon/cmake-init
pipx install cmake-init && \
yes | sudo apt update && \
yes | sudo apt list --upgradable && \
yes | sudo apt upgrade && \
yes | sudo apt update && \
yes | sudo apt install -f && \
yes | sudo apt update && \

sudo apt install nodejs -y && \
sudo apt install jq -y && \
# Description: package manager for Node.js
# (npm: Unmet dependencies)

sudo apt install npm -y && \

# Update Node.js with NPM (Node Package Manager)
# https://phoenixnap.com/kb/update-node-js-version

#   sudo apt install npm -y && \

#   npm cache clean -f && \
#   sudo npm install -g n -y && \
#   sudo n stable -y && \

# Description: blackbox testing of Unix command line programs
# cmdtest black box tests Unix command line tools. Roughly, it is given a
# script, its input files, and its expected output files. cmdtest runs
# the script, and checks the output is as expected.

sudo apt install cmdtest -y && \
sudo apt install yarn -y && \
# https://pnpm.io/installation
curl -fsSL https://get.pnpm.io/install.sh | sh -  && \
sudo apt install cdecl -y && \
sudo apt install cutils -y && \
sudo apt install kitty -y && \
sudo apt install sakura -y && \
# sudo apt install gnome-terminal -y && \
sudo apt install tree -y && \
sudo apt install mc -y && \
sudo apt install xclip -y && \
sudo apt install vim-gtk3 -y && \
sudo apt install kate -y && \
sudo apt install cppcheck -y && \
sudo apt install cppcheck-gui -y && \
sudo apt install splint -y && \
sudo apt install cmake-gui -y && \
sudo apt install cmake -y && \
sudo apt install wget -y && \
sudo apt install unzip -y && \
sudo apt install git -y && \
sudo apt install git-lfs -y && \

# https://softwarerecs.stackexchange.com/questions/30351/visualizing-git-diff-linux#30352
# gitk & git-gui added to the installation script.
# Both can show results graphically when launched from the directory
# containing .git folder. These are the simplest alternatives
# to dealing with the command-line diff/merge/commit/stage/push tools.
# Can be supplementary utilities even when a CUI is preferred over the GUI.

sudo apt install gitk -y && \
sudo apt install git-gui -y && \
# sudo apt install giggle -y && \

# Below are some (terminal-based) utilities for adding more
# functionalities to the existing Git installation

sudo apt install git-extras -y && \
sudo apt install git-flow -y && \
sudo apt install diffutils -y && \
sudo apt install diffstat -y && \

# Debuggers, code profilers, memory leak testers, build tools,
# code formatting applications and more

sudo apt install ddd -y && \
sudo apt install valgrind -y && \
sudo apt install cgdb -y && \
sudo apt install astyle -y && \
sudo apt install universal-ctags -y && \
sudo apt install autoconf -y && \
sudo apt install pkg-config -y && \
sudo apt install libx11-dev -y && \
sudo apt install libglib2.0-doc -y && \
sudo apt install libtool -y && \
sudo apt install autoproject -y && \
sudo apt install autogen -y && \
sudo apt install autotools-dev -y && \
sudo apt install automake -y && \
sudo apt install m4 -y && \
sudo apt install make -y && \
sudo apt install ninja-build -y && \
sudo apt install meld -y && \

# Markdown to HTML etc.

sudo apt install markdown -y && \

# Text search utilities

sudo apt install regexxer -y && \
sudo apt install searchmonkey -y && \
# CuteCOM: GUI Serial Monitor
# https://www.pragmaticlinux.com/2021/11/how-to-monitor-the-serial-port-in-linux/
sudo apt install cutecom -y && \

# Req. by PlatformIO CORE CLI

yes | sudo apt autoremove brltty && \
# or,
# sudo apt purge --auto-remove brltty && \

yes | sudo apt update && \
# https://www.pragmaticlinux.com/2021/11/how-to-monitor-the-serial-port-in-linux/
sudo apt install -y cutecom && \
# https://askubuntu.com/questions/786367/setting-up-arduino-uno-ide-on-ubuntu
# https://askubuntu.com/questions/781571/how-to-identify-devices-connected-to-serial-port
# https://unix.stackexchange.com/questions/390184/dmesg-read-kernel-buffer-failed-permission-denied
# https://0xsuk.github.io/posts/2022-07-19-how-to-install-ch340-on-ubuntu-22.04/
sudo apt install -y hwinfo && \
sudo apt install -y setserial && \
pipx install esptool && \
# sudo usermod -a -G plugdev $USER  && \
# sudo usermod -a -G dialout $USER && \
# https://docs.platformio.org/en/latest/core/userguide/device/cmd_monitor.html#cmd-device-monitor
# https://docs.platformio.org/en/latest/core/installation/udev-rules.html
# curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules  && \
# sudo service udev restart && \
# sudo udevadm control --reload-rules && \
# sudo udevadm trigger && \
# sudo usermod -a -G dialout $USER && \
# sudo usermod -a -G plugdev $USER && \
# sudo reboot
# sudo chmod a+rw /dev/ttyUSB0 && \
# sudo chmod a+rw /dev/ttyS0 && \
# setserial -g /dev/ttyS0 && \
# setserial -g /dev/ttyS[0123] && \
# sudo sysctl kernel.dmesg_restrict=0 && \
# sudo reboot
# echo "ls -l /dev/ttyUSB* /dev/ttyACM* ..." && \
# ls -l /dev/ttyUSB* /dev/ttyACM* && \
# ls -l /dev/ttyUSB* /dev/ttyACM*
# ls: cannot access '/dev/ttyACM*': No such file or directory
# crw-rw-rw- 1 root dialout 188, 0 Mar 20 01:08  /dev/ttyUSB0
# hwinfo --short
#
#                        Serial controller
#   /dev/ttyUSB0         QinHeng Electronics HL-340 USB-Serial adapter
# echo "dmesg | egrep --color 'serial|ttyS' ..." && \
# dmesg | egrep --color 'serial|ttyS' && \
# echo "dmesg | grep tty ..." && \
# dmesg | grep tty && \
# echo "dmesg | tail -f ..." && \
# dmesg | tail -f && \
# echo "hwinfo --short ..." && \
# hwinfo --short && \
# echo "lsusb ..." && \
# lsusb && \
# echo "ls -l /dev/tty* ..." && \
# ls -l /dev/tty* && \
# echo "dmesg | grep tty ..." && \
# dmesg | grep tty \
#                                                  For PlaltformIO

# =================================================================
# developer utilities (END)
# =================================================================


# =================================================================
# essential packages
# =================================================================

sudo apt install gufw -y && \
sudo apt install resolvconf -y && \
sudo apt install clamtk-gnome -y && \
sudo apt install chkrootkit -y && \
sudo apt install rkhunter -y && \
sudo apt install firejail -y && \
# screen: req. by i2pdbrowser
sudo apt install screen -y && \
sudo apt install network-manager -y && \
sudo apt install openvpn -y && \
sudo apt install network-manager-openvpn -y && \
sudo apt install smartmontools -y && \
sudo apt install gsmartcontrol -y && \
# X display manager
sudo apt install xdm -y && \
# Description: a tool for selecting tasks for installation on Debian systems
# This package provides 'tasksel', a simple interface for users who
# want to configure their system to perform a specific task.
sudo apt install tasksel -y && \
# sudo apt install firetools -y && \
sudo apt install ntp -y && \
sudo apt install gparted -y && \
sudo apt install gnome-disk-utility -y && \
sudo apt install rsync -y && \
sudo apt install timeshift -y && \
sudo apt install grsync -y && \
sudo apt install synaptic -y && \
sudo apt install preload -y && \
# seahorse: GUI Keyring Manager
# https://mexpolk.wordpress.com/2008/02/06/ubuntu-change-default-keyring-password/
sudo apt install seahorse -y && \

# #################################################

# Power management utility for laptops.

sudo apt install tlp -y && \
sudo apt install tlp-rdw -y && \

# #################################################
# DVTM. A Tiling Window Manager in the Console.

sudo apt install dvtm -y && \

# #################################################
sudo apt install redshift-gtk -y && \
sudo apt install caffeine -y && \
sudo apt install hardinfo -y && \
sudo apt install htop -y && \
# btop++: Modern and colourful command-line resource monitor that shows
# usage and stats for the processor, memory, disks, network and processes.
#sudo apt install btop -y && \
# Usage:
# btop --utf-force
# q
# ranger: Console File Manager with VI Key Bindings
sudo apt install ranger -y && \
# nnn: Free, fast, friendly file manager
#sudo apt install nnn -y && \
# Usage:
# nnn
# Arrow-keys
# q
# zoxide: Faster way to navigate your filesystem
sudo apt install zoxide -y && \
# trash-cli: Send files to trash from the terminal instead of permanently deleting them
sudo apt install trash-cli -y && \
# ncdu: ncurses disk usage viewer
sudo apt install ncdu -y && \
# Pfetch/Neofetch: Shows Linux System Information with Distribution Logo
sudo apt install neofetch -y && \
# Open a terminal emulator and type
# fish_config
# to configure fish shell (e.g. aliases)
sudo apt install fish -y && \
sudo apt install kitty -y && \
# Midnight Commander command-line file manager
#sudo apt install mc -y && \
sudo apt install simplescreenrecorder -y && \

# ---------
# 9 AMAZING COMMAND LINE TOOLS for Linux
# https://youtu.be/kFh1acsQ8DQ

# Install OH-MY-BASH:
sudo apt install curl git git-lfs fish -y && \
#bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" && \

# Change the theme: .bashrc -> Uncomment:

# OSH_THEME="powerline-plain"
# OSH_THEME="powerline"
## OSH_THEME="brunton"
## OSH_THEME="kitsune"
# OSH_THEME="mairan"
# OSH_THEME="rr"

source ~/.bashrc && \

# git clone https://github.com/wting/autojump.git && \
# cd autojump && \
# python3 install.py && \
# cd ~/ && \
# echo "[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh" >> ~/.bashrc && \
# https://www.cyberciti.biz/faq/add-bash-auto-completion-in-ubuntu-linux/
sudo apt install bash-completion -y && \
echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc && \

# autojump
# https://github.com/wting/autojump.git
sudo apt install autojump -y && \
sudo apt install fzf -y && \
echo '. /usr/share/autojump/autojump.sh' >> ~/.bashrc && \
source ~/.bashrc && \
# https://www.tecmint.com/autojump-a-quickest-way-to-navigate-linux-filesystem/1/

# thef**k
sudo apt install thefuck -y && \
# https://github.com/nvbn/thefuck/#requirements
# Just type luck instead of typing f__k in an office or in front of clients.
echo 'eval "$(thefuck --alias luck)"' >> ~/.bashrc && \
# https://github.com/nvbn/thefuck
# https://programmerall.com/article/10391819507/
# https://www.cyberciti.biz/media/new/cms/2017/08/demo-thefuck-command.gif

# thef__k for the FISH SHELL:
# https://github.com/oh-my-fish/plugin-thefuck
# https://github.com/oh-my-fish/oh-my-fish#installation
sudo apt install git -y && \
# =======================================================
# Install OH-MY-FISH (instructions): ====================
# git clone https://github.com/oh-my-fish/oh-my-fish && \
# Install manually:
# cd oh-my-fish && \
# bin/install --offline
# omf install thefuck

# Or, (OMF)
# https://github.com/oh-my-fish/oh-my-fish
sudo apt install curl git fish -y && \
#curl -L https://get.oh-my.fish | fish && \
# fish
# Theming:
# omf list
# omf theme
# omf install thefuck
# omf install bobthefish
# omf install agnoster
# omf theme bobthefish
# omf reload

# ---------

# Googler: Power tool to Google (Web & News) and Google Site Search from the terminal
sudo apt install googler -y && \
# googler disable swap in Ubuntu
# ddgr: DuckDuckGo from the terminal
sudo apt install ddgr -y && \
# ddgr disable swap in ubuntu

# ------------------------------------------------------------------------------
# Snap and Flatpak:
# Synaptic Package Manager:
yes | sudo apt install synaptic && \
# Install GNOME Software:
yes | sudo apt install gnome-software && \
# ------------------------------------------------------------------------------
# Install Manually
# Snap:
#   yes | sudo apt update && sudo apt upgrade && \
#   yes | sudo apt install snapd && \
#   yes | sudo snap install core && \
#   yes | sudo snap install snap-store && \
# ------------------------------------------------------------------------------
# Flatpak:
# *** Install Flatpak as root: ***
# Run 'flatpak_install_as_root.sh' if needed
#
#   sudo su root
#   yes | sudo apt install flatpak
#   yes | sudo apt install gnome-software-plugin-flatpak
#   yes | flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Exit su:
#   exit
#   sudo reboot now
#
# Install MS Windows layer translator, Bottle from Flatpak:
# flatpak install flathub com.usebottles.bottles
# flatpak run com.usebottles.bottles
# [BluffTitler 15.0.0.1 worked in Bottles.]
# ------------------------------------------------------------------------------

# AppImage support

sudo apt install libfuse2 -y && \

#sudo apt install gkrellm -y && \
sudo apt install psensor -y && \
#sudo apt install torbrowser-launcher -y && \ # Use Flatpak
# sudo apt install epiphany-browser -y && \

# # # # # # # # # # # # # # # # # # # # #
# Surf browser
# apt search surf
# Simple web browser by the suckless community
# https://surf.suckless.org/
# Usage:
# Open a terminal emulator (e.g. GNOME Terminal,
# XFCE Terminal, Kitty Terminal Emulator etc.) and type
# 'surf URL'.
# The 'URL' is the site you want to visit.
# Examples:
# surf duckduckgo.com
# surf startpage.com
# surf searx.me
# surf google.com
# Ctrl+H is Back <-
# Ctrl+L is Forward ->
sudo apt install surf -y && \

# BitTorrent client
sudo apt install transmission -y && \

# # # # # # # # # # # # # # # # # # # # #
# sudo snap install goldendictionary && \

sudo apt install stardict -y && \
# See shell/stardict.txt for details.
sudo apt install artha -y && \
sudo apt install okular -y && \
#sudo apt install ghostwriter -y && \

sudo apt install bzip2 -y && \
sudo apt install tar -y && \
sudo apt install xchm -y && \

sudo apt install unrar -y && \
sudo apt install rar -y && \
sudo apt install p7zip-full -y && \
sudo apt install p7zip-rar -y && \
sudo apt install xz-utils -y && \
sudo apt install lrzip -y && \
sudo apt install pixz -y && \
sudo apt install wmctrl -y && \
sudo apt install nscd -y && \
sudo apt install xclip -y && \
sudo apt install uget -y && \
sudo apt install aria2 -y && \
#sudo apt install xpdf -y && \
# GUI Archive manager.
sudo apt install xarchiver -y && \
sudo apt install thunar-archive-plugin -y && \
# GUI Wallpaper Selector.
#sudo apt install nitrogen -y && \
# Text Editor.
sudo apt install geany -y && \
# File Manager.
#sudo apt install pcmanfm -y && \
# Wireless Device Monitoring Application.
sudo apt install wavemon -y && \
# Monitor the status of an 802.11 wireless ethernet link.
sudo apt install wmwave -y && \
# Description: WiFi Share and Connect with QR.
sudo apt install wifi-qr -y && \
# Launcher.
sudo apt install rofi -y && \
#sudo apt install vlc -y && \
# Description: graphical wireless scanner.
sudo apt install linssid -y && \
# Image Viewer & Wallpaper Changer.
#sudo apt install feh -y && \
# Screenshot Utility.
sudo apt install flameshot -y && \
# Image Viewer.
sudo apt install ristretto -y && \

# Find duplicate files
# https://www.makeuseof.com/best-tools-find-and-remove-duplicate-files-linux/

sudo apt install fdupes -y && \

# fdupes -r ~/Pictures/MaterialDesign/
# Or,
# fdupes -r -d ~/Pictures/MaterialDesign/
# To delete

sudo apt install rdfind -y && \

# rdfind ~/Pictures/MaterialDesign/

sudo apt install dupeguru -y && \

# Python3 PiP

sudo apt install python3-pip -y && \

# Defrag NTFS Volumes.
# https://askubuntu.com/questions/59007/defragging-ntfs-partitions-from-linux
# https://github.com/tuxera/ntfs-3g
sudo apt install ntfs-3g -y && \

# Data Recovery
# https://www.ubuntupit.com/top-15-linux-data-recovery-tools-the-professionals-choice

sudo apt install testdisk -y && \
sudo apt install safecopy -y && \
sudo apt install foremost -y && \
sudo apt install gddrescue -y && \
sudo apt install ddrescueview -y && \
sudo apt install recoverjpeg -y && \

sudo apt install ffmpeg -y && \

sudo apt install youtube-dl -y && \

sudo apt install gtkhash -y && \

# Download QuickHash-GUI-Linux-v3.2.0 from: https://www.quickhash-gui.org

# Simulate (generate) X11 keyboard/mouse input events
# xdotool lets you programmatically (or manually) simulate keyboard
# input and mouse activity, move and resize windows, etc. It does this
# using X11's XTEST extension and other Xlib functions.

sudo apt install xdotool -y && \
# CCAL is a drop-in replacement for the standard unix calendar program.
sudo apt install ccal -y && \
# manager and address book modules.
#sudo apt install osmo && \ (segmentation fault)

# sudo snap install chromium && \

# Download Manager programs
# XDM - Xtreme Download Manager
# https://github.com/subhra74/xdm

sudo apt install uget -y && \

# Screen recorder
sudo apt install peek -y && \
# Screencast tool to display your keystrokes
sudo apt install screenkey -y && \
# Capture selected screen area # queries for a selection from the user and prints the region to stdout
sudo apt install slop -y && \

# install gifski from https://gif.ski/
# Open a terminal emulator, then select a region to display keystrokes by issuing the command:
# screenkey -p fixed -g $(slop -n -f '%g') --persist -s small --font-size small
sudo apt install default-jre -y && \

sudo apt install gimp-plugin-registry -y && \
sudo apt install gmic -y && \
sudo apt install gimp-gmic -y && \

# figlet: Make large character ASCII banners out of ordinary text
# https://kerneltalks.com/tips-tricks/create-beautiful-ascii-text-banners-linux/
# Brave: figlet windows
# https://superuser.com/questions/1361312/figlets-installation-on-windows-10
# npm install -g figlet-cli
# Usage: figlet -f Slant Tulu-C-IDE > ascii-banner-output.txt
# figlet My Text Banner

sudo apt install figlet -y && \

# Inkscape

# Inkscape latest STABLE version # Install Snap

yes | sudo apt install ttf-mscorefonts-installer && \
yes | sudo fc-cache && \

# =================================================================
# essential packages (END)
# =================================================================


# =================================================================
# authentication
# =================================================================

# sudo apt install keepassxc -y && \ # Install Snap

# =================================================================
# authentication (END)
# =================================================================


# =================================================================
# GnuPG
# =================================================================

# PGP Encryption and file signing
# sudo apt install gpa  && \
# sudo apt install kleopatra \
# Optional (Warning: kleopatra Requires KDE dependencies and 117MB extra space on the drive)

sudo apt install gpa -y && \

sudo apt install libccid -y && \
sudo apt install opensc-pkcs11 -y && \
sudo apt install pcsc-tools -y && \
sudo apt install pcscd -y && \
sudo apt install opensc -y && \

sudo apt install gnupg -y && \

sudo apt install scdaemon -y && \

# =================================================================
# GnuPG (END)
# =================================================================


# =================================================================
# fancy-dock-n-search
# =================================================================

# Use an XFCE Panel as the Dock, Rofi as the launcher/app-search

# =================================================================
# fancy-dock-n-search (END)
# =================================================================


# =================================================================
# video-n-vfx (media file converters - CLI)
# =================================================================

sudo apt install ffmpeg -y && \
# sudo apt install mediainfo -y && \ # Install Snap
# VidCutter # Install Snap
# Create DVDs easily
#sudo apt install devede -y && \
sudo apt install winff -y && \
sudo apt install winff-doc -y && \

# =================================================================
# video-n-vfx (media file converters - CLI) (END)
# =================================================================


# =================================================================
# 'bpytop' System Monitoring Tool
# =================================================================

# https://www.osradar.com/install-bpytop-on-ubuntu-debian-a-terminal-monitoring-tool/

pipx install bpytop && \

# =================================================================
# 'bpytop' System Monitoring Tool (END)
# =================================================================


# =================================================================
# c-c-plus-plus-common-libraries
# =================================================================

# safec: https://rurban.github.io/safeclib/doc/safec-3.6.0/index.html
# This library implements the secure C11 Annex K functions on top of most libc implementations, which are missing from them.

sudo apt install libsafec-dev -y && \

# Boost C++ libraries

#sudo apt install libboost-all-dev -y && \

# OpenGL libraries

# sudo apt install libglu1-mesa-dev -y && \
# sudo apt install freeglut3-dev -y && \
# sudo apt install mesa-common-dev -y && \
# sudo apt install libglew-dev -y && \
# sudo apt-get install binutils -y && \
# sudo apt install libglm-dev -y && \
# sudo apt install libgl-dev -y && \
# sudo apt install libglew-dev -y && \
# sudo apt install libglfw3-dev -y && \
# sudo apt install libglm-dev -y && \
# sudo apt install libglm-doc -y && \

# Some useful libraries

sudo apt install libbsd-dev -y && \
#    #include <bsd/string.h>
# pass -lbsd flag to the linker, like
# gcc -g -Wall -Wextra -pedantic -fstack-protector-all prog.c -o prog -lbsd

# sudo apt install zlibc && \
# sudo apt install libxml2-utils && \
# sudo apt install libtinyxml2-dev && \
# sudo apt install zlib1g-dev && \
# sudo apt install libxml2-dev && \
# sudo apt install libtinyxml2-dev && \
# sudo apt install libsigc++-2.0-dev && \
# sudo apt install libsigc++-2.0-doc && \
# sudo apt install libssl-dev && \
# sudo apt install libssl-doc && \
# sudo apt install libsdl2-dev && \
# sudo apt install libasound2-doc && \
# sudo apt install libsfml-dev && \
# sudo apt install libsfml-doc && \

# Development Library and Toolkit for FLTK 1.3 GUI Library

# sudo apt install libfltk1.3-dev -y && \
# sudo apt install libfltk1.3-compat-headers -y && \
# sudo apt install pinentry-fltk -y && \

# Tk C programming GUI Library (Development Library)
# Tcl & Tk are components of the base distribution

sudo apt install tk-dev -y && \

# AI and Machine Learning

# Dlib
# sudo apt install libdlib-dev && \
# OpenCV
# https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html
# https://opencv.org
# TensorFlow
# https://www.tensorflow.org/install/lang_c

# Scientific computing
# https://www.findbestopensource.com/product/kthohr-stats
# https://github.com/kthohr/stats
# https://www.thefreecountry.com/sourcecode/mathematics.shtml

# sudo apt install libgsl-dev && \
# sudo apt install gsl-ref-psdoc && \
# sudo apt install gsl-doc-pdf && \
# sudo apt install gsl-doc-info && \
# sudo apt install gsl-ref-html && \
# sudo apt install libarmadillo-dev \

# Other libraries to consider:

# posix
# libcerror

# =================================================================
# c-c-plus-plus-common-libraries (END)
# =================================================================


# =================================================================
# cpplint
# =================================================================
# https://pypi.org/project/cpplint/

pipx install cpplint && \

# https://github.com/JossWhittle/FlintPlusPlus
# Create a symbolic link:
cd ~/  && \
rm -rf ~/FlintPlusPlus && \
git clone https://github.com/JossWhittle/FlintPlusPlus.git  && \

rm -rf ~/FlintPlusPlus/.git  && \
rm -rf ~/FlintPlusPlus/bin/deb32  && \
rm -rf ~/FlintPlusPlus/bin/raspberry\ pi/  && \
rm -rf ~/FlintPlusPlus/bin/Win32  && \
rm -rf ~/FlintPlusPlus/bin/x64  && \
rm -rf ~/FlintPlusPlus/debian  && \
rm -rf ~/FlintPlusPlus/flint  && \
rm ~/FlintPlusPlus/.gitattributes ~/FlintPlusPlus/.gitignore ~/FlintPlusPlus/flint++.1 && \

# uncomment the line below before running this automated installation script for the second time

# sudo rm /usr/bin/flint++ && \

sudo ln -s ~/FlintPlusPlus/bin/deb64/flint++ /usr/bin/flint++ && \
chmod +x ~/FlintPlusPlus/bin/deb64/flint++ && \
cd ~/  && \

# Ref: https://github.com/mcandre/linters

# =================================================================
# cpplint (END)
# =================================================================


# =================================================================
# Conky-Resource-Monitor-Gadget
# =================================================================

sudo apt install conky-all -y && \

# =================================================================
# Conky-Resource-Monitor-Gadget (END)
# =================================================================


# =================================================================
# orphaned-package-cleaners
# =================================================================

# https://linoxide.com/linux-how-to/remove-orphaned-packages-ubuntu/
# Simply run 'deborphan' (without quotes) to get an overview of the
# leftover packages, then uninstall them manually.

sudo apt install deborphan -y && \

# =================================================================
# orphaned-package-cleaners (END)
# =================================================================


# =================================================================
# LATeX-Equation-Editor-Base
# =================================================================

# WYSIWYG LATeX Equation Editors

# References:
# https://equalx.sourceforge.io/
# https://www.thrysoee.dk/laeqed/

sudo apt install texlive-base -y && \
sudo apt install texlive-latex-base -y && \
sudo apt install dvipng -y && \
sudo apt install dvisvgm -y && \
sudo apt install ghostscript -y && \

# Pandoc:
sudo apt install pandoc -y && \

sudo apt install equalx -y && \

#sudo apt install klatexformula -y && \
# JVM Runtime is required by Laeqed
sudo apt install default-jre -y && \

# On MS Windows, use MiKTeX (https://miktex.org/),
# Ghostscript (https://www.ghostscript.com/),
# EqualX (https://equalx.sourceforge.io/),
# Laeqed (https://www.thrysoee.dk/laeqed/).

# =================================================================
# LATeX-Equation-Editor-Base (END)
# =================================================================


# =================================================================
# ocr-tesseract-install
# =================================================================

# https://linuxhint.com/install_tesseract_ocr_linux/
# https://linuxhint.com/install-tesseract-ocr-linux/

# installation:

sudo apt install tesseract-ocr -y && \
sudo apt install imagemagick -y && \

# language pack installation:

# For Bengali
# sudo apt install tesseract-ocr-ben

# For Hindi
# sudo apt install tesseract-ocr-hin

# get a hint of all supported languages
# apt-cache search tesseract-

# usage:
# tesseract image_name.jpg image_name output -l eng
# tesseract dcr240.jpg dcr240 output -l eng

# extract texts from all image files in a directory
# for i in *; do tesseract "$i" "output-$i" -l eng; done;

# Tesseract GUI frontend: gImageReader
sudo apt install tesseract-ocr-eng -y && \
sudo apt install tesseract-ocr-enm -y && \
sudo apt install tesseract-ocr-osd -y && \

# install support for additional languages
# sudo apt install tesseract-ocr-ben -y && \
# sudo apt install tesseract-ocr-script-beng -y && \
# sudo apt install tesseract-ocr-hin -y && \
# sudo apt install tesseract-ocr-script-deva -y && \

# install gImageReader
# sudo apt search gimagereader

sudo apt install gimagereader -y && \

# See 'shell/ocr-tesseract-frontend-gimagereader.sh' for details

# =================================================================
# ocr-tesseract-install (END)
# =================================================================


# =================================================================
# smartcardsupport
# =================================================================

sudo apt install libccid -y && \
sudo apt install opensc-pkcs11 -y && \
sudo apt install pcsc-tools -y && \
sudo apt install pcscd -y && \
sudo apt install opensc -y && \

# systemctl start pcscd && \
# systemctl enable pcscd && \
# systemctl status pcscd && \
# lsusb && \
# pcsc_scan && \
# opensc-tool -l && \

# =================================================================
# smartcardsupport (END)
# =================================================================


# =================================================================
# site blocker
# =================================================================

sudo apt install nscd -y && \

# =================================================================
# site blocker (END)
# =================================================================


# =================================================================
# YouTube-SMTube
# =================================================================

# SMTube
# YouTube video playback without Flash Player.
# Helps to play YouTube videos on low-end machines.

# http://www.smtube.org/
# "SMTube - YouTube browser for SMPlayer.
# SMTube is an application that allows to browse, search and play YouTube videos.
# Videos are played back with a media player (by default SMPlayer)
# instead of a flash player, this allows better performance,
# particularly with HD content."

# yes | echo 'deb http://download.opensuse.org/repositories/home:/smplayerdev/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:smplayerdev.list && \
# yes | curl -fsSL https://download.opensuse.org/repositories/home:smplayerdev/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_smplayerdev.gpg > /dev/null && \
# sudo apt update -y && \
# sudo apt install youtube-dl -y && \
# sudo apt install smtube -y \

# https://www.smtube.org/
sudo apt install smtube smplayer -y && \


# ------------------------------------------------------------------------------
# I tested SMTube on a VM. SMTube behaved unexpectedly when installed inside the guest VM.
# It changed the cursor/'mouse pointer' to a
# black cross-mark. As a quick fix around the system without needing to install
# any extraneous package, I restarted the lightdm service and everything went
# back to normal again.
# -----------------------Jot the following lines down to a piece of paper------
# CTRL+ALT+F3
# sudo systemctl restart lightdm.service
# ALT+F7
# ------------------------------------------------------------------------------


# =================================================================
# YouTube-SMTube (END)
# =================================================================

# VeraCrypt
# https://www.veracrypt.fr/en/Downloads.html
yes | sudo apt install libwxgtk3.2-1 && \
# sudo apt --fix-broken install
# sudo dpkg -i  veracrypt-x.xx.x-Debian-xx-amd64.deb \


echo "--------------------------------------"
echo "Done!"
echo "--------------------------------------"

