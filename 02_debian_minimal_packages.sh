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
# # https://askubuntu.com/questions/800155/service-command-not-found
# service: command not found
# Solve the problem by adding
# export PATH="$PATH:/usr/sbin"
# to your .bashrc, .bash_aliases, .bash_profile, .profile
# =================================================================

# export PATH="$PATH:/usr/sbin"

touch .bash_profile  && \

printf "Add the following entry,\n  then write changes & exit.\n"
echo "    export PATH="'"$PATH:/usr/sbin"'"    "
echo "file:  .bash_profile"

echo "export PATH="'"$PATH:/usr/sbin"'"" >> ~/.bash_profile

sleep 3
######################mousepad .bash_profile  && \
# https://askubuntu.com/questions/108258/what-is-the-bash-equivalent-of-doss-pause-command
read -p ""  && \
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n?rq=1
printf "Add the following entry,\n  then write changes & exit.\n"
echo "    export PATH="'"$PATH:/usr/sbin"'"    "
echo "file:  .bashrc"

echo "export PATH="'"$PATH:/usr/sbin"'"" >> ~/.bashrc

sleep 3
######################mousepad .bashrc  && \
read -p ""  && \
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n?rq=1
printf "Add the following entry,\n  then write changes & exit.\n"
echo "    export PATH="'"$PATH:/usr/sbin"'"    "
echo "file:  .bash_aliases"

echo "export PATH="'"$PATH:/usr/sbin"'"" >> ~/.bash_aliases

sleep 3
######################mousepad .bash_aliases  && \
read -p ""  && \
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n?rq=1
printf "Add the following entry,\n  then write changes & exit.\n"
echo "    export PATH="'"$PATH:/usr/sbin"'"    "
echo "file:  .profile"

echo "export PATH="'"$PATH:/usr/sbin"'"" >> ~/.profile

sleep 3
######################mousepad .profile  && \
# https://askubuntu.com/questions/108258/what-is-the-bash-equivalent-of-doss-pause-command
read -p " "  && \
sleep 1
source "/home/$(whoami)/.bashrc"  && \
source "/home/$(whoami)/.bash_aliases"  && \
source "/home/$(whoami)/.bash_profile"  && \
source "/home/$(whoami)/.profile"  && \

# =================================================================
# pip3 packages - path setup (END)
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

echo "export PATH="'"$HOME/.local/bin/:$PATH"'"" >> ~/.bash_profile


sleep 3
######################mousepad .bash_profile  && \
# https://askubuntu.com/questions/108258/what-is-the-bash-equivalent-of-doss-pause-command
read -p ""  && \
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n?rq=1
printf "Add the following entry,\n  then write changes & exit.\n"
echo "    export PATH="'"$HOME/.local/bin/:$PATH"'"    "
echo "file:  .bashrc"

echo "export PATH="'"$HOME/.local/bin/:$PATH"'"" >> ~/.bashrc

sleep 3
######################mousepad .bashrc  && \
read -p ""  && \
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n?rq=1
printf "Add the following entry,\n  then write changes & exit.\n"
echo "    export PATH="'"$HOME/.local/bin/:$PATH"'"    "
echo "file:  .bash_aliases"

echo "export PATH="'"$HOME/.local/bin/:$PATH"'"" >> ~/.bash_aliases

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

yes | sudo apt install build-essential && \

# yes | sudo apt install tcc && \

yes | sudo apt install patch && \
yes | sudo apt install make && \
yes | sudo apt install bear && \
yes | sudo apt install diffutils && \
yes | sudo apt install llvm && \
yes | sudo apt install clang && \
yes | sudo apt install clangd && \
yes | sudo apt install clang-tidy && \
yes | sudo apt install clang-tools && \
yes | sudo apt install lld && \
yes | sudo apt install libomp-dev && \
yes | sudo apt install curl && \
yes | sudo apt install wget && \
yes | sudo apt install python3-pip && \
#python3 -m pip install --upgrade pip && \
# https://stackoverflow.com/questions/75608323/how-do-i-solve-error-externally-managed-environment-everytime-i-use-pip3
yes | sudo apt install pipx && \
pipx install flawfinder && \
pipx install lizard && \
# https://github.com/joeyespo/grip
# Render local readme files before sending off to GitHub.
pipx install grip && \
# https://github.com/friendlyanon/cmake-init
pipx install cmake-init && \
# https://github.com/gni/offvsix
# offvsix: Offline Visual Studio Code Extension Downloader
pipx install offvsix && \
yes | sudo apt update && \
yes | sudo apt list --upgradable && \
yes | sudo apt upgrade && \
yes | sudo apt update && \
yes | sudo apt install -f && \
yes | sudo apt update && \

yes | sudo apt install nodejs && \
yes | sudo apt install jq && \
# Description: package manager for Node.js
# (npm: Unmet dependencies)

yes | sudo apt install npm && \

# Update Node.js with NPM (Node Package Manager)
# https://phoenixnap.com/kb/update-node-js-version

#   yes | sudo apt install npm && \

#   npm cache clean -f && \
#   sudo npm install -g n -y && \
#   sudo n stable -y && \

# Description: blackbox testing of Unix command line programs
# cmdtest black box tests Unix command line tools. Roughly, it is given a
# script, its input files, and its expected output files. cmdtest runs
# the script, and checks the output is as expected.

yes | sudo apt install cmdtest && \
yes | sudo apt install yarn && \

# Bash Language Server
# https://github.com/bash-lsp/bash-language-server.git
# yes | sudo npm i -g bash-language-server && \
# bash-language-server --help

yes | sudo apt install cdecl && \
yes | sudo apt install cutils && \
yes | sudo apt install kitty && \
yes | sudo apt install sakura && \

# yes | sudo apt install gnome-terminal && \

yes | sudo apt install tree && \
yes | sudo apt install mc && \
yes | sudo apt install xclip && \
yes | sudo apt install vim vim-gtk3 && \
yes | sudo apt install kate && \
yes | sudo apt install notepadqq && \
yes | sudo apt install cppcheck && \
yes | sudo apt install cppcheck-gui && \
yes | sudo apt install splint && \

# yes | sudo apt install cmake-gui && \

yes | sudo apt install cmake && \
yes | sudo apt install wget && \
yes | sudo apt install unzip && \
yes | sudo apt install git && \
yes | sudo apt install git-lfs && \

# https://softwarerecs.stackexchange.com/questions/30351/visualizing-git-diff-linux#30352
# gitk & git-gui added to the installation script.
# Both can show results graphically when launched from the directory
# containing .git folder. These are the simplest alternatives
# to dealing with the command-line diff/merge/commit/stage/push tools.
# Can be supplementary utilities even when a CUI is preferred over the GUI.

yes | sudo apt install gitk && \
yes | sudo apt install git-gui && \
yes | sudo apt install giggle && \

# Below are some (terminal-based) utilities for adding more
# functionalities to the existing Git installation

yes | sudo apt install git-extras && \
yes | sudo apt install git-flow && \
yes | sudo apt install diffutils && \
yes | sudo apt install diffstat && \

# Debuggers, code profilers, memory leak testers, build tools,
# code formatting applications and more

yes | sudo apt install ddd && \
yes | sudo apt install valgrind && \
yes | sudo apt install cgdb && \
yes | sudo apt install astyle && \
yes | sudo apt install universal-ctags && \
yes | sudo apt install autoconf && \
yes | sudo apt install pkg-config && \
yes | sudo apt install libx11-dev && \
yes | sudo apt install libglib2.0-doc && \
yes | sudo apt install libtool && \
yes | sudo apt install autoproject && \
yes | sudo apt install autogen && \
yes | sudo apt install autotools-dev && \
yes | sudo apt install automake && \
yes | sudo apt install m4 && \
yes | sudo apt install make && \
yes | sudo apt install ninja-build && \
yes | sudo apt install meld && \

# Terminal Fonts (MUST):
# * Without these fonts, you'll miss the proper console characters and see boxes everywhere.
yes | sudo apt install fonts-terminus fonts-terminus-otb xfonts-terminus && \
yes | sudo apt install xfonts-terminus-dos xfonts-terminus-oblique && \
yes | sudo apt install xfonts-mona fonts-firacode fonts-league-mono fonts-agave && \
yes | sudo apt install fonts-inconsolata fonts-ricty-diminished && \
yes | sudo apt install fonts-jetbrains-mono fonts-anonymous-pro && \
yes | sudo apt install fonts-monoid fonts-monoid-halfloose && \
yes | sudo apt install fonts-monoid-halftight fonts-monoid-loose fonts-monoid-tight && \
yes | sudo apt install fonts-fantasque-sans fonts-hermit fonts-powerline && \
# https://github.com/ryanoasis/nerd-fonts

# Install Fonts in Debian:
# https://vitux.com/how-to-install-custom-fonts-in-debian/
yes | sudo apt update && sudo apt install font-manager && \

# Powerful screen color picker based on Qt
yes | sudo apt install color-picker && \

# Markdown to HTML etc.

yes | sudo apt install markdown && \

# https://www.howtogeek.com/devops/how-to-create-qr-codes-from-the-linux-command-line/
# https://linuxconfig.org/list-of-qr-code-generators-on-linux
# qrencode -s 6 -l H -o "text.png" "This type of QR holds plain text. This text is shown to the user when they scan the QR code. No other action is automatically triggered."

yes | sudo apt install qrencode && \

# Text search utilities

yes | sudo apt install regexxer && \
yes | sudo apt install searchmonkey && \
yes | sudo apt install ripgrep ugrep && \
# ugrep --help

# CuteCOM: GUI Serial Monitor
# cutecom: Graphical serial terminal, like minicom.
# https://www.pragmaticlinux.com/2021/11/how-to-monitor-the-serial-port-in-linux/
yes | sudo apt install cutecom && \
# minicom: Friendly menu driven serial communication program.
# sympathy: serial port concentrator system - server/client program.
# https://stackoverflow.com/questions/5347962/how-do-i-connect-to-a-terminal-to-a-serial-to-usb-device-on-ubuntu-10-10-maveri
# https://www.makeuseof.com/connect-to-serial-consoles-on-linux/
yes | sudo apt install minicom sympathy && \
# gtkterm: simple GTK+ serial port terminal.
yes | sudo apt install gtkterm && \
# screen: Terminal multiplexer with VT100/ANSI terminal emulation.
yes | sudo apt install screen && \

# Req. by PlatformIO CORE CLI

yes | sudo apt autoremove brltty && \
# or,
# sudo apt purge --auto-remove brltty && \

# Req. by SimulIDE, https://pcotret.github.io/simulide/
yes | sudo apt install libqt5core5a libqt5gui5 libqt5xml5 libqt5svg5 libqt5widgets5 libqt5concurrent5 libqt5multimedia5 libqt5multimedia5-plugins libqt5serialport5 libqt5script5 libelf1 && \

yes | sudo apt update && \
# https://www.pragmaticlinux.com/2021/11/how-to-monitor-the-serial-port-in-linux/
yes | sudo apt install cutecom && \
# https://askubuntu.com/questions/786367/setting-up-arduino-uno-ide-on-ubuntu
# https://askubuntu.com/questions/781571/how-to-identify-devices-connected-to-serial-port
# https://unix.stackexchange.com/questions/390184/dmesg-read-kernel-buffer-failed-permission-denied
# https://0xsuk.github.io/posts/2022-07-19-how-to-install-ch340-on-ubuntu-22.04/
yes | sudo apt install hwinfo && \
yes | sudo apt install setserial && \
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

yes | sudo apt install gufw && \
yes | sudo apt install resolvconf && \
yes | sudo apt install clamtk-gnome && \
yes | sudo apt install chkrootkit && \
yes | sudo apt install rkhunter && \
yes | sudo apt install firejail && \
# screen: req. by i2pdbrowser
yes | sudo apt install screen && \
yes | sudo apt install network-manager && \
yes | sudo apt install openvpn && \
yes | sudo apt install network-manager-openvpn && \
yes | sudo apt install smartmontools && \
yes | sudo apt install gsmartcontrol && \
# X display manager
yes | sudo apt install xdm && \
# ------------------------------------------------------------------------------
# Debian-XFCE Net-Install ISO didn't install any calculator app.
# yes | sudo apt install gnome-calculator && \ (Feb. 21, 2025: 'gnome-calculator' is crashing.)
# Install Qalculate
# https://www.linuxlinks.com/calculators/
# https://qalculate.github.io/index.html
sh -c 'flatpak --assumeyes install flathub io.github.Qalculate' && \
#
# Description: a tool for selecting tasks for installation on Debian systems
# This package provides 'tasksel', a simple interface for users who
# want to configure their system to perform a specific task.
yes | sudo apt install tasksel && \

# yes | sudo apt install firetools && \

yes | sudo apt install ntp && \
yes | sudo apt install gparted && \
yes | sudo apt install gnome-disk-utility && \
yes | sudo apt install rsync && \
yes | sudo apt install timeshift && \
yes | sudo apt install grsync && \

# OpenCL support:
# https://www.arri.com/en/learn-help/learn-help-camera-system/tools/legacy-software/arriraw-converter
# https://superuser.com/questions/1281454/error-while-loading-shared-libraries-libopencl-so-1-cannot-open-shared-objectsudo apt install ocl-icd-opencl-dev
yes | sudo apt install ocl-icd-opencl-dev && \

# RPM to DEB and DEB to RPM:
# [How to Convert .rpm package to .deb using alien Package Converter? - GeeksforGeeks](https://www.geeksforgeeks.org/how-to-convert-rpm-package-to-deb-using-alien-package-converter/)
# https://ostechnix.com/convert-linux-packages-alien/
# sudo alien --to-tgz/--to-deb/--to-rpm --scripts package.deb/rpm
# sudo alien --to-tgz --scripts blackmagic-raw-3.4.x86_64.rpm
yes | sudo apt install alien && \

# how to clone a drive in linux
# https://www.makeuseof.com/tag/2-methods-to-clone-your-linux-hard-drive/
yes | sudo apt install clonezilla && \

#      SyncThing File synchronisation app
# flatpak install flathub com.github.zocker_160.SyncThingy && \
yes | sudo apt install synaptic && \
yes | sudo apt install preload && \
# seahorse: GUI Keyring Manager
# https://mexpolk.wordpress.com/2008/02/06/ubuntu-change-default-keyring-password/
yes | sudo apt install seahorse && \

# #################################################

# Power management utility for laptops.

yes | sudo apt install tlp && \
yes | sudo apt install tlp-rdw && \

# #################################################
# Set Up Bluetooth
# https://www.howtogeek.com/829360/how-to-set-up-bluetooth-on-linux/
yes | sudo apt install bluetooth bluemon bluez blueman && \
sudo systemctl enable bluetooth.service && \
sudo systemctl start bluetooth.service && \
rfkill unblock bluetooth && \

# #################################################
# DVTM. A Tiling Window Manager in the Console.

yes | sudo apt install dvtm && \

# #################################################
yes | sudo apt install redshift-gtk && \
#yes | sudo apt install caffeine && \
yes | sudo apt install hardinfo && \
yes | sudo apt install htop && \
# btop++: Modern and colourful command-line resource monitor that shows
# usage and stats for the processor, memory, disks, network and processes.
# yes | sudo apt install btop && \
# Usage:
# btop --utf-force
# q
# ranger: Console File Manager with VI Key Bindings
yes | sudo apt install ranger && \
# nnn: Free, fast, friendly file manager
# yes | sudo apt install nnn && \
# Usage:
# nnn
# Arrow-keys
# q
# zoxide: Faster way to navigate your filesystem
yes | sudo apt install zoxide && \
# trash-cli: Send files to trash from the terminal instead of permanently deleting them
yes | sudo apt install trash-cli && \
# ncdu: ncurses disk usage viewer
yes | sudo apt install ncdu && \
# Pfetch/Neofetch: Shows Linux System Information with Distribution Logo
yes | sudo apt install neofetch && \
# The FISH Shell
# Open a terminal emulator and type
# fish_config
# to configure fish shell (e.g. aliases)
yes | sudo apt install fish && \
yes | sudo apt install kitty && \
# The Suckless ST Terminal Emulator basic package:
# yes | sudo apt install stterm  && \
# Build it from the source
# https://github.com/bakkeby/st-flexipatch.git
#
# Midnight Commander command-line file manager
yes | sudo apt install mc && \
yes | sudo apt install simplescreenrecorder && \

# ---------
# 9 AMAZING COMMAND LINE TOOLS for Linux
# https://youtu.be/kFh1acsQ8DQ

# Install OH-MY-BASH:
yes | sudo apt install curl git git-lfs fish && \
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" && \

# Change the theme: .bashrc -> Uncomment:

# OSH_THEME="powerline-plain"
# OSH_THEME="powerline"
## OSH_THEME="brunton"
## OSH_THEME="kitsune"
# OSH_THEME="mairan"
# OSH_THEME="rr"

source ~/.bashrc && \

# ------------------------------------------------------------------------------
# tldr
# https://github.com/tldr-pages/tldr.git
pipx install tldr
# ------------------------------------------------------------------------------

# git clone https://github.com/wting/autojump.git && \
# cd autojump && \
# python3 install.py && \
# cd ~/ && \
# echo "[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh" >> ~/.bashrc && \
# https://www.cyberciti.biz/faq/add-bash-auto-completion-in-ubuntu-linux/
yes | sudo apt install bash-completion && \
echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc && \

# autojump
# https://github.com/wting/autojump.git
yes | sudo apt install autojump && \
yes | sudo apt install fzf && \
echo '. /usr/share/autojump/autojump.sh' >> ~/.bashrc && \
source ~/.bashrc && \
# https://www.tecmint.com/autojump-a-quickest-way-to-navigate-linux-filesystem/1/

# thef**k
yes | sudo apt install thefuck && \
# https://github.com/nvbn/thefuck/#requirements
# Just type luck instead of typing f__k in an office or in front of clients.
echo 'eval "$(thefuck --alias luck)"' >> ~/.bashrc && \
# https://github.com/nvbn/thefuck
# https://programmerall.com/article/10391819507/
# https://www.cyberciti.biz/media/new/cms/2017/08/demo-thefuck-command.gif

# thef__k for the FISH SHELL:
# https://github.com/oh-my-fish/plugin-thefuck
# https://github.com/oh-my-fish/oh-my-fish#installation
yes | sudo apt install git && \
# =======================================================
# Install OH-MY-FISH (instructions): ====================
# git clone https://github.com/oh-my-fish/oh-my-fish && \
# Install manually:
# cd oh-my-fish && \
# bin/install --offline
# omf install thefuck

# Or, (OMF)
# https://github.com/oh-my-fish/oh-my-fish
yes | sudo apt install curl git fish && \
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
yes | sudo apt install googler && \
# googler disable swap in Ubuntu
# ddgr: DuckDuckGo from the terminal
yes | sudo apt install ddgr && \
# ddgr disable swap in ubuntu
# 3 Command Line Apps To Search The Web | DistroTube. https://youtu.be/RvzY3gQsLLk?si=FaLlxRwxtkiwu53O
# http://surfraw.org/
yes | sudo apt install surfraw surfraw-extra && \
# surfraw -elvi
# surfraw bing disable swap in debian
# sr google debian ports
# sr google -l debian ports

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
# Update Snaps:
# snap refresh --list
# sudo snap refresh
# snap
# add '/snap/bin' to '$PATH'
# https://askubuntu.com/questions/965599/where-is-the-install-location-for-the-snap-download-tool
# .bashrc or .bash_aliases
# export PATH="$PATH:/snap/bin/"
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
# Update Flatpak Apps:
# flatpak update
#
# Install MS Windows layer translator, Bottle from Flatpak:
# flatpak install flathub com.usebottles.bottles
# flatpak run com.usebottles.bottles
#
# ------------------------------------------------------------------------------

# AppImage support

yes | sudo apt install libfuse2 && \

# yes | sudo apt install gkrellm && \

yes | sudo apt install psensor && \

# Command-line system info tool # Hardware info from the console
yes | sudo apt install hardinfo && \

# New hardware (firmware)
# yes | sudo update-initramfs -u && \
#
yes | sudo apt-get install apt-file && \
yes | sudo apt-file update && \
#
# Hardware changes
# dmesg | grep firmware
# apt-file search <firmware-file-name>
#

# yes | sudo apt install torbrowser-launcher && \ # Use Flatpak
# yes | sudo apt install epiphany-browser && \

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
yes | sudo apt install surf && \

# BitTorrent client
yes | sudo apt install transmission && \

# # # # # # # # # # # # # # # # # # # # #
# GoldenDict Dictionary DB Reader
# Solve GoldenDict's High CPU usage problem.
# http://goldendict.org/forum/viewtopic.php?f=4&t=2830
# Edit -> Preferences > Full-text search tab ->
# -> "Allow full-text search for:" option is enabled (default option) ->
# -> Disable.
# yes | sudo apt install goldendict # Install Flatpak
# flatpak install flathub org.goldendict.GoldenDict
#
# Goldendict alternative
# yes | sudo apt install stardict && \
# See shell/stardict.txt for details.
#
# A cross-platform dictionary similar to Wordweb
yes | sudo apt install artha && \

# CD/DVD:
yes | sudo apt install brasero && \

# PDF Reader
yes | sudo apt install okular && \
# yes | sudo apt install ghostwriter && \ # Markdown Editor

yes | sudo apt install bzip2 && \
yes | sudo apt install tar && \
yes | sudo apt install xchm && \

yes | sudo apt install unrar && \
yes | sudo apt install rar && \
yes | sudo apt install p7zip-full && \
yes | sudo apt install p7zip-rar && \
yes | sudo apt install xz-utils && \
yes | sudo apt install lrzip && \
yes | sudo apt install pixz && \
yes | sudo apt install wmctrl && \
yes | sudo apt install nscd && \
yes | sudo apt install xclip && \
yes | sudo apt install uget && \
yes | sudo apt install aria2 && \
# yes | sudo apt install xpdf && \
# MATE archive manager. Works in XFCE
yes | sudo apt install engrampa engrampa-common && \
# GUI Archive manager.
yes | sudo apt install xarchiver && \
yes | sudo apt install thunar-archive-plugin && \
yes | sudo apt install pixz && \
yes | sudo apt install thunar-gtkhash thunar-font-manager thunar-archive-plugin && \
# https://docs.xfce.org/xfce/thunar/thunar-vcs-plugin
yes | sudo apt install thunar-vcs-plugin && \
# GUI Wallpaper Selector.
# yes | sudo apt install nitrogen && \
# Text Editor.
yes | sudo apt install geany && \
# File Manager.
# yes | sudo apt install pcmanfm && \
# Wireless Device Monitoring Application.
yes | sudo apt install wavemon && \
# Monitor the status of an 802.11 wireless ethernet link.
yes | sudo apt install wmwave && \
# Description: WiFi Share and Connect with QR.
yes | sudo apt install wifi-qr && \
# Launcher.
yes | sudo apt install rofi && \
# yes | sudo apt install vlc && \
# Description: graphical wireless scanner.
yes | sudo apt install linssid && \
# Image Viewer & Wallpaper Changer.
# yes | sudo apt install feh && \
# Screenshot Utility.
yes | sudo apt install flameshot && \
# Image Viewer.
yes | sudo apt install ristretto && \

# Find duplicate files
# https://www.makeuseof.com/best-tools-find-and-remove-duplicate-files-linux/

yes | sudo apt install fdupes && \

# fdupes -r ~/Pictures/MaterialDesign/
# Or,
# fdupes -r -d ~/Pictures/MaterialDesign/
# To delete

yes | sudo apt install rdfind && \

# rdfind ~/Pictures/MaterialDesign/

yes | sudo apt install dupeguru && \

# Python3 PiP

yes | sudo apt install python3-pip && \

# Defrag NTFS Volumes.
# https://askubuntu.com/questions/59007/defragging-ntfs-partitions-from-linux
# https://github.com/tuxera/ntfs-3g
yes | sudo apt install ntfs-3g && \

# Data Recovery
# https://www.ubuntupit.com/top-15-linux-data-recovery-tools-the-professionals-choice

yes | sudo apt install testdisk && \
yes | sudo apt install safecopy && \
yes | sudo apt install foremost && \
yes | sudo apt install gddrescue && \
yes | sudo apt install ddrescueview && \
yes | sudo apt install extundelete && \
yes | sudo apt install ext4magic && \
yes | sudo apt install scalpel && \
# https://www.r-studio.com/free-linux-recovery/Download.shtml
# sudo dpkg -i RLinux6_x64.deb  (~ 68 MB)
yes | sudo apt install recoverjpeg && \
yes | sudo apt install dvdisaster && \
# Ref: https://askubuntu.com/questions/15827/recovering-files-from-a-corrupt-cd-dvd

yes | sudo apt install ffmpeg && \
yes | sudo apt install mediainfo && \
yes | sudo apt install mediainfo-gui && \
yes | sudo apt install libimage-exiftool-perl && \
# 'forensics-extra' requires 1.3 GB drive space.
yes | sudo apt install forensics-extra && \

# Privacy tools (strip metadata)
yes | sudo apt install exiv2 && \
yes | sudo apt install mat2 && \

# FFMPEG-Thumbnailer
# https://askubuntu.com/questions/457317/mpeg2-transport-stream-mts-thumbnails
# https://bugs.launchpad.net/shotwell/+bug/1406546/comments/1
# https://askubuntu.com/questions/1043976/fix-thunar-doesnt-show-image-video-thumbnails-in-xubuntu-18-04

yes | sudo apt install ffmpegthumbnailer && \
yes | sudo apt install tumbler tumbler-plugins-extra ffmpegthumbnailer && \

# killall thunar
# pkill thunar
# thunar -q

# https://unix.stackexchange.com/questions/653974/how-to-generate-thumbnails-previews-for-files
# https://docs.xfce.org/xfce/tumbler/start
# D-Bus/ systemd:
# create a file below ~/.config/environment.d and inside set XDG_CACHE_HOME.
# E.g:
# XDG_CACHE_HOME=$HOME/.my_new_cache
#
# touch ~/.config/environment.d
# geany ~/.config/environment.d
#
# Add:
#
# XDG_CACHE_HOME=$HOME/.my_new_cache


# yes | sudo apt install youtube-dl && \

#      HandBrake Video Converter
# flatpak install fr.handbrake.ghb
# HandBrake Intel QSV plugin
# flatpak install fr.handbrake.ghb.Plugin.IntelMediaSDK

yes | sudo apt install gtkhash && \

# Download QuickHash-GUI-Linux-v3.2.0 from: https://www.quickhash-gui.org

# Simulate (generate) X11 keyboard/mouse input events
# xdotool lets you programmatically (or manually) simulate keyboard
# input and mouse activity, move and resize windows, etc. It does this
# using X11's XTEST extension and other Xlib functions.

yes | sudo apt install xdotool && \
# CCAL is a drop-in replacement for the standard unix calendar program.
yes | sudo apt install ccal && \
# manager and address book modules.
# yes | sudo apt install osmo && \ (segmentation fault)

# sudo snap install chromium && \

# Download Manager programs
# XDM - Xtreme Download Manager
# https://github.com/subhra74/xdm

yes | sudo apt install uget && \

# Screen recorder
yes | sudo apt install peek && \
# Screencast tool to display your keystrokes
yes | sudo apt install screenkey && \
# Capture selected screen area # queries for a selection from the user and prints the region to stdout
yes | sudo apt install slop && \
# https://itsfoss.com/best-linux-screen-recorders/
yes | sudo apt install kazam && \

# install gifski from https://gif.ski/
# Open a terminal emulator, then select a region to display keystrokes by issuing the command:
# screenkey -p fixed -g $(slop -n -f '%g') --persist -s small --font-size small
yes | sudo apt install default-jre && \

######################################################## TicTacSync
# https://sr.ht/~proflutz/TicTacSync/
# https://tictacsync.org/

yes | sudo apt install sox && \
pipx install tictacsync && \
pipx upgrade-all && \
# tictacsync -v sampleFiles
########################################################

# GIMP Essentials:
yes | sudo apt install abr2gbr && \
yes | sudo apt install gimp-data && \
yes | sudo apt install gimp-data-extras && \
yes | sudo apt install gimp-gmic && \
yes | sudo apt install gimp-gutenprint && \
yes | sudo apt install gimp-help-common && \
yes | sudo apt install gimp-help-en-gb && \
yes | sudo apt install gimp-lensfun && \
yes | sudo apt install gimp-plugin-registry && \
yes | sudo apt install gimp-texturize && \
yes | sudo apt install gtkam-gimp && \
yes | sudo apt install icc-profiles-free && \
yes | sudo apt install icc-profiles && \

yes | sudo apt install gimp-plugin-registry && \
yes | sudo apt install gmic && \
yes | sudo apt install gimp-gmic && \

yes | sudo apt install gegl && \
yes | sudo apt install xzgv && \

# To open RAW files with GIMP.
yes | sudo apt install darktable && \

# GIMP:

yes | sudo apt install gimp gimp-data gimp-data-extras gimp-gmic gimp-gutenprint gimp-help-common gimp-help-en-gb gimp-lensfun gimp-plugin-registry gimp-texturize icc-profiles icc-profiles-free gegl gtkam-gimp xzgv && \

# figlet: Make large character ASCII banners out of ordinary text
# https://kerneltalks.com/tips-tricks/create-beautiful-ascii-text-banners-linux/
# Brave: figlet windows
# https://superuser.com/questions/1361312/figlets-installation-on-windows-10
# npm install -g figlet-cli
# Usage: figlet -f Slant Tulu-C-IDE > ascii-banner-output.txt
# figlet My Text Banner

yes | sudo apt install figlet && \

# Inkscape

# Inkscape latest STABLE version # Install the AppImage package from the official channel https://inkscape.org/

# Vector Graphics Editor
yes | sudo apt install xfig && \

yes | sudo apt install ttf-mscorefonts-installer && \
# https://averagelinuxuser.com/microsoft-fonts-linux/#:~:text=Calibri%20and%20Cambria%20fonts,-Unfortunately%2C%20this%20package&text=These%20Google%20fonts%20are%20metric,package%20manager%20and%20install%20them
yes | sudo apt install fonts-crosextra-carlito fonts-crosextra-caladea && \
yes | sudo fc-cache && \
#
yes | sudo apt install fonts-texgyre fonts-texgyre-math fonts-urw-base35 && \
yes | sudo apt install fonts-apropal fonts-beteckna fonts-breip fonts-cabin && \
yes | sudo apt install fonts-liberation fonts-liberation2 fonts-lindenhill fonts-oxygen && \
yes | sudo apt install fonts-play fonts-ubuntu fonts-ubuntu-console fonts-tiresias && \
yes | sudo apt install texlive-fonts-extra && \
yes | sudo apt install fonts-croscore && \
sudo fc-cache && \
#
# Slideshow:

# https://imagination.sourceforge.net/
# https://github.com/colossus73/imagination
yes | sudo apt install imagination && \

# Dependencies for some markdown editors.
yes | sudo apt install python3-gtkspellcheck wkhtmltopdf && \


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

yes | sudo apt install gpa && \

yes | sudo apt install libccid && \
yes | sudo apt install opensc-pkcs11 && \
yes | sudo apt install pcsc-tools && \
yes | sudo apt install pcscd && \
yes | sudo apt install opensc && \

yes | sudo apt install gnupg && \

yes | sudo apt install scdaemon && \

yes | sudo apt install debian-keyring && \

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

yes | sudo apt install ffmpeg && \
yes | sudo apt install sox && \
# sudo apt install mediainfo -y && \
# VidCutter # Install Flatpak # VidCutter - Media Cutter + Joiner # flatpak install com.ozmartians.VidCutter
# Create Video DVDs and VCDs easily
yes | sudo apt install devede && \

# Winamp alternative
# https://www.reddit.com/r/Ubuntu/comments/tno11g/looking_for_a_winamp_equivalent_for_ubuntu/
yes | sudo apt install audacious && \

yes | sudo apt install winff && \
yes | sudo apt install winff-doc && \

# =================================================================
# video-n-vfx (media file converters - CLI) (END)
# =================================================================


# =================================================================
# 'bpytop' System Monitoring Tool
# =================================================================

# https://www.osradar.com/install-bpytop-on-ubuntu-debian-a-terminal-monitoring-tool/

yes | pipx install bpytop && \

# =================================================================
# 'bpytop' System Monitoring Tool (END)
# =================================================================


# =================================================================
# c-c-plus-plus-common-libraries
# =================================================================

# safec: https://rurban.github.io/safeclib/doc/safec-3.6.0/index.html
# This library implements the secure C11 Annex K functions on top of most libc implementations, which are missing from them.

yes | sudo apt install libsafec-dev && \

# Required, if you ever need to build Surf Browser (https://surf.suckless.org/) manually.
yes | sudo apt install libgtk-3-dev && \
yes | sudo apt install libwebkit2gtk-4.0-dev && \
yes | sudo apt install libgcr-3-dev && \

# Required by https://nappgui.com/
yes | sudo apt install libgtk-3-dev libcurl4-openssl-dev libwebkit2gtk-4.1-dev mesa-common-dev libgl1-mesa-dev && \

# Required by ggerganov/llama.cpp
yes | sudo apt install libopenblas-dev && \

# Boost C++ libraries

# yes | sudo apt install libboost-all-dev && \

# OpenGL libraries

# yes | sudo apt install libglu1-mesa-dev && \
# yes | sudo apt install freeglut3-dev && \
# yes | sudo apt install mesa-common-dev && \
# yes | sudo apt install libglew-dev && \
# yes | sudo apt-get install binutils && \
# yes | sudo apt install libglm-dev && \
# yes | sudo apt install libgl-dev && \
# yes | sudo apt install libglew-dev && \
# yes | sudo apt install libglfw3-dev && \
# yes | sudo apt install libglm-dev && \
# yes | sudo apt install libglm-doc && \

# Some useful libraries

yes | sudo apt install libbsd-dev && \
#    #include <bsd/string.h>
# pass -lbsd flag to the linker, like
# gcc -g -Wall -Wextra -pedantic -fstack-protector-all prog.c -o prog -lbsd

# yes | sudo apt install zlibc && \
# yes | sudo apt install libxml2-utils && \
# yes | sudo apt install libtinyxml2-dev && \
# yes | sudo apt install zlib1g-dev && \
# yes | sudo apt install libxml2-dev && \
# yes | sudo apt install libtinyxml2-dev && \
# yes | sudo apt install libsigc++-2.0-dev && \
# yes | sudo apt install libsigc++-2.0-doc && \
# yes | sudo apt install libssl-dev && \
# yes | sudo apt install libssl-doc && \
# yes | sudo apt install libsdl2-dev && \
# yes | sudo apt install libasound2-doc && \
# yes | sudo apt install libsfml-dev && \
# yes | sudo apt install libsfml-doc && \

# Development Library and Toolkit for FLTK 1.3 GUI Library

# yes | sudo apt install libfltk1.3-dev && \
# yes | sudo apt install libfltk1.3-compat-headers && \
# yes | sudo apt install pinentry-fltk && \

# Tk C programming GUI Library (Development Library)
# Tcl & Tk are components of the base distribution

yes | sudo apt install tk-dev && \

# AI and Machine Learning

# Dlib
# yes | sudo apt install libdlib-dev && \
# OpenCV
# https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html
# https://opencv.org
# TensorFlow
# https://www.tensorflow.org/install/lang_c

# Scientific computing
# https://www.findbestopensource.com/product/kthohr-stats
# https://github.com/kthohr/stats
# https://www.thefreecountry.com/sourcecode/mathematics.shtml

# yes | sudo apt install libgsl-dev && \
# yes | sudo apt install gsl-ref-psdoc && \
# yes | sudo apt install gsl-doc-pdf && \
# yes | sudo apt install gsl-doc-info && \
# yes | sudo apt install gsl-ref-html && \
# yes | sudo apt install libarmadillo-dev \

# Other libraries to consider:

# posix
# libcerror

# =================================================================
# c-c-plus-plus-common-libraries (END)
# =================================================================

# =================================================================
# Conky-Resource-Monitor-Gadget
# =================================================================

yes | sudo apt install conky-all && \

# =================================================================
# Conky-Resource-Monitor-Gadget (END)
# =================================================================


# =================================================================
# orphaned-package-cleaners
# =================================================================

# https://linoxide.com/linux-how-to/remove-orphaned-packages-ubuntu/
# Simply run 'deborphan' (without quotes) to get an overview of the
# leftover packages, then uninstall them manually.

yes | sudo apt install deborphan && \

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

yes | sudo apt install texlive-base && \
yes | sudo apt install texlive-latex-base && \
yes | sudo apt install dvipng && \
yes | sudo apt install dvisvgm && \
yes | sudo apt install ghostscript && \
# pdfjam
# https://askubuntu.com/questions/246647/convert-a-directory-of-jpeg-files-to-a-single-pdf-document
yes | sudo apt install texlive-extra-utils && \
# pdfjam --nup 2x4 --papersize '{4in,6in}'  *.jpg
# https://www.tomshardware.com/how-to/manipulate-pdf-files-with-pdftk
# pdftk 1.pdf another.pdf 3.pdf yet-another.pdf fifth.pdf output combined.pdf
yes | sudo apt install pdftk && \

# Pandoc:
yes | sudo apt install pandoc && \

yes | sudo apt install equalx && \

# yes | sudo apt install klatexformula && \
# JVM Runtime is required by Laeqed
yes | sudo apt install default-jre && \

# On MS Windows, use MiKTeX (https://miktex.org/),
# Ghostscript (https://www.ghostscript.com/),
# EqualX (https://equalx.sourceforge.io/),
# Laeqed (https://www.thrysoee.dk/laeqed/).

# =================================================================
# LATeX-Equation-Editor-Base (END)
# =================================================================

# =================================================================
# Pandoc EPUB/PDF Export Dependencies.
# =================================================================

# https://pandoc.org/epub.html
# https://www.thepolyglotdeveloper.com/2019/10/creating-ebook-pandoc-markdown/
# https://cmichel.io/how-to-create-beautiful-epub-programming-ebooks/

yes | sudo apt install texlive-xetex && \
yes | sudo apt-get install python3-pygments latexmk && \
yes | sudo apt-get install texlive-extra-utils texlive-latex-extra && \
yes | sudo apt install fonts-firacode && \
yes | sudo apt install fonts-dejavu fonts-liberation && \
yes | sudo apt-get install wkhtmltopdf && \
# wkhtmltopdf  # The HTML-to-PDF engine
# https://stackoverflow.com/questions/37208051/pandoc-xelatex-not-found-xelatex-is-needed-for-pdf-output
# DeepSeek R1
# https://github.com/jgm/pandoc/issues/4871

# =================================================================
# Pandoc EPUB/PDF Export Dependencies. (END)
# =================================================================

# =================================================================
# Img2PDF: Lossless conversion of raster images to PDF
# =================================================================
yes | sudo apt install img2pdf && \
#
# Usage examples;
# convert -density 600 input.pdf output.jpg
# img2pdf --pagesize A4 -s 600dpi output-0.jpg output-1.jpg > page001.pdf
# WARNING: Time-consuming process involved.
# ==================================Img2PDF========================

# =================================================================
# ocr-tesseract-install
# =================================================================

# https://linuxhint.com/install_tesseract_ocr_linux/
# https://linuxhint.com/install-tesseract-ocr-linux/

# installation:

yes | sudo apt install tesseract-ocr && \
yes | sudo apt install tesseract-ocr-eng tesseract-ocr-enm && \
yes | sudo apt install imagemagick && \
yes | sudo apt install graphicsmagick-imagemagick-compat && \
yes | sudo apt install ocrmypdf && \
# https://github.com/ocrmypdf/OCRmyPDF?tab=readme-ov-file#feature-demo
yes | sudo apt-get install gnome-common && \
# https://www.openpaper.work/en/
yes | sudo apt install paperwork-gtk paperwork-gtk-l10n-en paperwork-shell && \
# Usage: https://www.openpaper.work/en/download/linux#debian



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
yes | sudo apt install tesseract-ocr-eng && \
yes | sudo apt install tesseract-ocr-enm && \
yes | sudo apt install tesseract-ocr-osd && \

# install support for additional languages
# yes | sudo apt install tesseract-ocr-ben && \
# yes | sudo apt install tesseract-ocr-script-beng && \
# yes | sudo apt install tesseract-ocr-hin && \
# yes | sudo apt install tesseract-ocr-script-deva && \

# install gImageReader
# apt search gimagereader

yes | sudo apt install gimagereader && \

# See 'shell/ocr-tesseract-frontend-gimagereader.sh.txt' for details

# =================================================================
# ocr-tesseract-install (END)
# =================================================================


# =================================================================
# smartcardsupport
# =================================================================

yes | sudo apt install libccid && \
yes | sudo apt install opensc-pkcs11 && \
yes | sudo apt install pcsc-tools && \
yes | sudo apt install pcscd && \
yes | sudo apt install opensc && \

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

yes | sudo apt install nscd && \

# =================================================================
# site blocker (END)
# =================================================================


# =================================================================
# YouTube-SMTube
# =================================================================
# NOTE: Do not use SMTube. Use pystardust/ytfzf instead.
# The MPV Player can already be used for watching YouTube videos.
# mpv https://youtu.be/ciio80nkjB8?si=v-tRAHYG5gqTwecI
# However, getting the link from YouTube defeats the purpose of watching videos from the command-line interface.
# pystardust/ytfzf solves that problem.
# https://www.makeuseof.com/watch-youtube-videos-in-linux-terminal/
# https://github.com/pystardust/ytfzf.git
# Install dependencies:
# sudo apt install jq curl mpv fzf ueberzug kitty
# Install yt-dlp & youtube-dl
# ---
# youtube-dl
# https://github.com/ytdl-org/youtube-dl
# pipx install youtube-dl
# pipx ensurepath
# source ~/.bashrc
# source ~/.bash_aliases
# youtube-dl --help
# ---
# yt-dlp
# https://github.com/yt-dlp/yt-dlp
# pipx install yt-dlp
# pipx ensurepath
# source ~/.bashrc
# source ~/.bash_aliases
# yt-dlp --help
# ---
# git clone https://github.com/pystardust/ytfzf
# cd ytfzf
# sudo make install doc addons
# cd ~/
# ytfzf "Jacob Sorber"
# ytfzf "Another way to check pointers at runtime in C"
#
# I couldn't figure out a way to set the resolution to 480p, let me know if you have.
#

# SMTube
# YouTube video playback without Flash Player.
# Helps to play YouTube videos on low-end machines.

# http://www.smtube.org/
# "SMTube - YouTube browser for SMPlayer.
# SMTube is an application that allows to browse, search and play YouTube videos.
# Videos are played back with a media player (by default SMPlayer)
# instead of a flash player, this allows better performance,
# particularly with HD content."

# yes | sudo apt update && \
# yes | sudo apt install youtube-dl && \

# https://www.smtube.org/
# yes | sudo apt install smtube && \
yes | sudo apt install smplayer && \


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

# Volume/Drive/Container Encryption
#    https://www.cyberciti.biz/security/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/
#    http://security.stackexchange.com/questions/4590/ddg#4592
yes | sudo apt install gnome-disk-utility && \
yes | sudo apt install zulucrypt-gui zulucrypt-cli zulumount-gui libzulucrypt-plugins && \
yes | sudo apt install pmount && \
yes | sudo apt install luckyluks && \
yes | sudo apt install cryptsetup cryptmount cryptsetup-bin cryptsetup-initramfs cryptsetup-nuke-password && \

# zuluCrypt (*Linux only*) - A simple, feature rich and powerful solution for hard drives encryption.
#
# https://mhogomchungu.github.io/zuluCrypt/
# https://github.com/mhogomchungu/zuluCrypt
# zuluCrypt is currently Linux only and it does hard drives encryption and it can manage PLAIN dm-crypt volumes,
#   LUKS encrypted volumes, TrueCrypt encrypted volumes,
#   VeraCrypt encrypted volumes and Microsoft’s BitLocker volumes.
# zuluCrypt can manage encrypted volumes that are hosted in image files, lvm, mdraid, hard drives, usb sticks or any other block device.
# zuluCrypt can also encrypt stand alone files (zuluCrypt menu -> zC -> encrypt a file).

yes | sudo apt install zulucrypt-gui zulucrypt-cli zulumount-gui libzulucrypt-plugins && \

# VeraCrypt
# https://www.veracrypt.fr/en/Downloads.html
yes | sudo apt install libwxgtk3.2-1 \
# sudo apt --fix-broken install
# sudo dpkg -i  veracrypt-x.xx.x-Debian-xx-amd64.deb \

# pnpm package manager:
echo "If you've executed the first install script 01_debian_essential.sh already, you have pnpm installed on your system. (yes I did = 1. No, I did not = 0)"
read choice
if [ "${choice}" != '1' ]; then
  echo "Ok!"
   sleep 1
   # https://pnpm.io/installation
   curl -fsSL https://get.pnpm.io/install.sh | sh -

fi

# Install 'c': Use C as a shell scripting language:
echo "If you've installed the 'c' scripting language support already, type 0 to skip installing it again. Type any other numbers to proceed with the installation."
echo "https://github.com/ryanmjacobs/c"
read choice
if [ "${choice}" != '0' ]; then
  echo "Ok! You'll install the 'c' scripting language support."
   sleep 1
   # ------------------------------------------------------------------------------
   # Install 'c': Use C as a shell scripting language:
   # Refer to '01_debian_essential.sh'.
   # https://github.com/ryanmjacobs/c
   cd ~/
   yes | sudo apt install build-essential trash-cli
   wget https://raw.githubusercontent.com/ryanmjacobs/c/master/c
   sudo install -m 755 c /usr/bin/c
   trash c
   # ------------------------------------------------------------------------------
else
  echo "Skipping..."
  sleep 1

fi

# =================================================================
# cpplint
# =================================================================
# https://pypi.org/project/cpplint/

pipx install cpplint && \

echo "Install Flint++? (Yes, do it = 1. No = anything else.)."
read choice
if [ "${choice}" != '0' ]; then
  echo "Ok! Installing Flint++."
   sleep 1
   # Flint++
   # https://github.com/JossWhittle/FlintPlusPlus
   # Create a symbolic link:
   cd ~/
   rm -rf ~/FlintPlusPlus
   git clone https://github.com/JossWhittle/FlintPlusPlus.git

   rm -rf ~/FlintPlusPlus/.git
   rm -rf ~/FlintPlusPlus/bin/deb32
   rm -rf ~/FlintPlusPlus/bin/raspberry\ pi/
   rm -rf ~/FlintPlusPlus/bin/Win32
   rm -rf ~/FlintPlusPlus/bin/x64
   rm -rf ~/FlintPlusPlus/debian
   rm -rf ~/FlintPlusPlus/flint
   rm ~/FlintPlusPlus/.gitattributes ~/FlintPlusPlus/.gitignore ~/FlintPlusPlus/flint++.1


   echo "Type 1 (numeric one) if you already have Flint++ on your system."
   read choice
   if [ "${choice}" != '0' ]; then
     # Performing checks before running this automated installation script for the second time.

     sudo rm /usr/bin/flint++

    fi

   sudo ln -s ~/FlintPlusPlus/bin/deb64/flint++ /usr/bin/flint++
   chmod +x ~/FlintPlusPlus/bin/deb64/flint++

   # Ref: https://github.com/mcandre/linters
else
  echo "Ok, skipping..."
  sleep 1

fi

# =================================================================
# cpplint (END)
# =================================================================

echo "--------------------------------------"
echo "Done!"
echo "--------------------------------------"

