#!/bin/bash


# apt info packagename
# apt search packagename

# ------------------------------------------------------------------------------
# Update:
yes | sudo apt update && sudo apt upgrade && \
yes | sudo apt update && \
yes | sudo apt list --upgradable && \
yes | sudo apt upgrade && \
yes | sudo apt update && \
yes | sudo apt install -f && \
# ------------------------------------------------------------------------------
# Install the common properties package (will be needed later):
yes | sudo apt install software-properties-common && \
# ------------------------------------------------------------------------------
# Install the most essential core build tool:
yes | sudo apt install build-essential dkms module-assistant linux-headers-$(uname -r) && \
yes | sudo apt install curl git git-lfs gitk git-gui patch make cmake diffutils git-extras git-flow diffstat bash fish && \
yes | sudo apt install llvm clang clangd clang-tidy clang-tools lld && \
yes | sudo apt install libomp-dev && \
yes | sudo apt install wget curl git git-lfs && \
yes | sudo apt install python3-pip && \
#python -m pip install --upgrade pip && \
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
yes | sudo apt install nodejs && \
yes | sudo apt install jq && \

# Description: package manager for Node.js
# (npm: Unmet dependencies)

yes | sudo apt install npm && \

# Update Node.js with NPM (Node Package Manager)
# https://phoenixnap.com/kb/update-node-js-version
#
# yes | sudo apt install npm
# npm cache clean -f
# sudo npm install -g n
# sudo n stable
#
# Description: blackbox testing of Unix command line programs
# cmdtest black box tests Unix command line tools. Roughly, it is given a
# script, its input files, and its expected output files. cmdtest runs
# the script, and checks the output is as expected.
yes | sudo apt install cmdtest && \
yes | sudo apt install yarn && \

# ------------------------------------------------------------------------------
# tool for selecting tasks
yes | sudo apt install tasksel && \
# ------------------------------------------------------------------------------
# Network Time Protocol daemon/utilities
yes | sudo apt install ntp && \
yes | sudo apt install chrony && \
yes | sudo systemctl start chronyd && \
yes | sudo systemctl enable chronyd && \
yes | sudo chronyc makestep && \
# ------------------------------------------------------------------------------
# Install PiP:
yes | sudo apt install python3-pip && \
#python -m pip install --upgrade pip && \
# ------------------------------------------------------------------------------
# Debian-XFCE Net-Install ISO didn't install any calculator app.
yes | sudo apt install gnome-calculator && \
#
# Install GVim+Vim:
# yes | sudo apt install vim vim-gtk3 && \
#
yes | sudo apt install vim && \
# ------------------------------------------------------------------------------
# tldr
# https://github.com/tldr-pages/tldr.git
pipx install tldr
# ------------------------------------------------------------------------------
# The Fish Shell:
# OH-MY-FISH:
curl -L https://get.oh-my.fish | fish && \
# ------------------------------------------------------------------------------
# BASH utilities:
yes | sudo apt install bash-completion && \
yes | sudo apt install autojump && \
yes | sudo apt install fzf && \
# ------------------------------------------------------------------------------
# OH-MY-BASH:
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
# ------------------------------------------------------------------------------
# Bash Language Server
# https://github.com/bash-lsp/bash-language-server.git
yes | sudo npm i -g bash-language-server && \
# bash-language-server --help
# ------------------------------------------------------------------------------
# Fish-shell-like autocompletion in Bash-shell
# Ecosia: fish shell like autocomplete in bash
# https://unix.stackexchange.com/questions/109366/does-bash-have-similar-features-such-as-fishs-autosuggestions-and-highlighting
# https://github.com/akinomyoga/ble.sh
# https://github.com/dvorka/hstr

# akinomyoga/ble.sh
# requirement: trash-cli

yes | sudo apt install trash-cli && \

git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git && \
make -C ble.sh install PREFIX=~/.local && \
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc && \
source ~/.bashrc && \
source ~/.bash_aliases && \
trash ble.sh && \
# ------------------------------------------------------------------------------
# AppImage support:
yes | sudo apt install libfuse2 && \
# ------------------------------------------------------------------------------
# Sensor backend:
yes | sudo apt install psensor && \
# ------------------------------------------------------------------------------
# Command-line system info tool # Hardware info from the console
yes | sudo apt install hardinfo && \
# New hardware (firmware)
# sudo update-initramfs -u
yes | sudo apt-get install apt-file && \
yes | sudo apt-file update && \
# Hardware changes
# dmesg | grep firmware
# apt-file search <firmware-file-name>
#
# Power management utility for laptops.
yes | sudo apt install tlp && \
yes | sudo apt install tlp-rdw && \

# Set Up Bluetooth
# https://www.howtogeek.com/829360/how-to-set-up-bluetooth-on-linux/
yes | sudo apt install bluetooth bluemon bluez blueman && \
sudo systemctl enable bluetooth.service && \
sudo systemctl start bluetooth.service && \
rfkill unblock bluetooth && \

# File Compression:
yes | sudo apt install unzip && \
yes | sudo apt install bzip2 && \
yes | sudo apt install tar && \
yes | sudo apt install xz-utils && \
yes | sudo apt install lrzip && \
yes | sudo apt install unrar && \
# MATE archive manager. Works in XFCE
yes | sudo apt install engrampa engrampa-common && \
# Generic archive manager. Works in XFCE
yes | sudo apt install xarchiver && \
yes | sudo apt install thunar-archive-plugin && \
yes | sudo apt install pixz && \
yes | sudo apt install thunar-gtkhash thunar-font-manager thunar-archive-plugin && \
# https://docs.xfce.org/xfce/thunar/thunar-vcs-plugin
yes | sudo apt install thunar-vcs-plugin && \
# ------------------------------------------------------------------------------
# Other utilities:
# Wmctrl is a Command line tool to interact with an
#   EWMH/NetWM compatible X Window Manager (examples include
#   Enlightenment, icewm, kwin, metacity, and sawfish).
yes | sudo apt install wmctrl && \
# Name Service Cache Daemon
yes | sudo apt install nscd && \
# Clipboard from the standard input/output
yes | sudo apt install xclip && \
# simple, lightweight and easy-to-use
#  download manager.
yes | sudo apt install uget && \
# High speed download utility
yes | sudo apt install aria2 && \
# Load programs faster
yes | sudo apt install preload && \
# tool for selecting tasks
yes | sudo apt install tasksel && \
# Disk Utility
yes | sudo apt install gparted && \
yes | sudo apt install gnome-disk-utility && \
# Run apps in sandbox
yes | sudo apt install firejail && \
# ------------------------------------------------------------------------------
# Internet & Network:
# Network Time Protocol daemon/utilities
yes | sudo apt install ntp && \
yes | sudo apt install wavemon && \
# Monitor status of an 802.11 wireless ethernet link.
yes | sudo apt install wmwave && \
# Description: WiFi Share and Connect with QR.
yes | sudo apt install wifi-qr && \
# Description: graphical wireless scanner.
yes | sudo apt install linssid && \
# ------------------------------------------------------------------------------
# USB file transfer from Android phones
yes | sudo apt install gmtp jmtpfs && \
# ------------------------------------------------------------------------------
# Launcher.
yes | sudo apt install rofi && \
# Codecs:
# https://www.sys-hint.com/1075-Installing-Multimedia-Codecs-on-Debian-10
yes | sudo apt install software-properties-common && \
yes | sudo apt-add-repository non-free && \
yes | sudo apt-add-repository contrib && \
# https://serverfault.com/questions/240920/how-do-i-enable-non-free-packages-on-debian
yes | sudo apt-add-repository --component non-free && \
yes | sudo apt install firmware-linux-nonfree && \
yes | sudo apt update && sudo apt upgrade && \
yes | sudo apt install libavcodec-extra && \
yes | sudo apt install libdvdcss2 && \
# Run
sudo dpkg-reconfigure libdvd-pkg && \
#   later.
#
# ----------------------------------------------------------------------
# Codecs:
# https://www.sys-hint.com/1075-Installing-Multimedia-Codecs-on-Debian-10
# https://phoenixnap.com/kb/add-apt-repository-command-not-found-ubuntu

yes | sudo apt install software-properties-common && \
yes | sudo apt-add-repository non-free && \
yes | sudo apt-add-repository contrib && \
# https://serverfault.com/questions/240920/how-do-i-enable-non-free-packages-on-debian
yes | sudo apt-add-repository --component non-free && \

# Edit /etc/apt/sources.list with sudo privileges
# sudo nano /etc/apt/sources.list
# Add the following lines if these lines are not present.
# If the lines are found commented, uncomment the lines.
# ---
## deb http://deb.debian.org/debian/ bookworm non-free main contrib non-free-firmware
## deb-src http://deb.debian.org/debian/ bookworm non-free main contrib non-free-firmware

## deb http://security.debian.org/debian-security bookworm-security non-free main contrib non-free-firmware
## deb-src http://security.debian.org/debian-security bookworm-security non-free main contrib non-free-firmware

## deb http://deb.debian.org/debian/ bookworm-updates non-free main contrib non-free-firmware
## deb-src http://deb.debian.org/debian/ bookworm-updates non-free main contrib non-free-firmware
# ---

yes | sudo apt update && sudo apt upgrade && \
yes | sudo apt install firmware-linux-nonfree && \


# Intel CPU support:
yes | sudo apt install software-properties-common apt-transport-https ca-certificates curl -y && \
yes | sudo apt install i965-va-driver-shaders && \
yes | sudo apt install intel-media-va-driver-non-free && \
yes | sudo apt install xserver-xorg-video-intel && \
yes | sudo apt install mesa-utils && \
yes | sudo apt install intel-opencl-icd intel-media-va-driver-non-free libmfx1 && \
#
# ==============================================================================
# Edit the GRUB Bootloader Menu after installing drivers from Intel:
#
# sudo mousepad /etc/default/grub
# https://askubuntu.com/questions/1383040/no-dev-dri-directory-in-ubuntu-server-20-04
# https://askubuntu.com/questions/1153746/intel-graphics-card-not-bound-to-driver-after-nvidia-driver-installed-ubuntu-18/1154067#1154067
#
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset"
#https://askubuntu.com/questions/1383040/no-dev-dri-directory-in-ubuntu-server-20-04
#https://askubuntu.com/questions/1153746/intel-graphics-card-not-bound-to-driver-after-nvidia-driver-installed-ubuntu-18/1154067#1154067
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.alpha_support=1"

# Change this line

# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset"

# to

# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.alpha_support=1"

# (*** uncommented).

# Update GRUB:
# https://itsfoss.com/update-grub/
#
# sudo update-grub
# sudo grub-mkconfig -o /boot/grub/grub.cfg
# ==============================================================================
#
# Intel HW-Acceleration (didn't work. You might need the following packages later).
# sudo apt install jellyfin jellyfin-ffmpeg5 jellyfin-server jellyfin-web
# See jellyfin.txt for details.
# ----------------------------------------------------------------------
#
# MS Core Fonts:
# https://www.linuxcapable.com/how-to-install-microsoft-fonts-on-debian-linux/
yes | sudo apt update && sudo apt upgrade && \
yes | sudo apt-add-repository contrib non-free && \
yes | sudo apt install ttf-mscorefonts-installer && \
# https://averagelinuxuser.com/microsoft-fonts-linux/#:~:text=Calibri%20and%20Cambria%20fonts,-Unfortunately%2C%20this%20package&text=These%20Google%20fonts%20are%20metric,package%20manager%20and%20install%20them
yes | sudo apt install fonts-crosextra-carlito fonts-crosextra-caladea && \
sudo fc-cache && \
# Themes and Icons:
# Search the web version of the Debian repository for the package.
# search the apt repo from the command line.
# Grey Bird:
# apt search greybird-gtk-theme
yes | sudo apt install greybird-gtk-theme && \
# XFCE Calendar
yes | sudo apt install orage && \
# Papyrus:
# apt search papirus-icon-theme
yes | sudo apt install papirus-icon-theme && \
# PRO-dark-XFCE-4.14
# https://www.xfce-look.org/p/1207818/
# Extract to: /usr/share/themes
# sudo thunar /usr/share/themes
# sudo chmod -R 755 /usr/share/themes
yes | sudo apt install neofetch && \
yes | sudo apt install htop && \
yes | sudo apt install rofi && \
# Settings -> Keyboard -> Application Shortcut -> Add
# rofi -combi-modi window,drun,ssh -theme solarized -font "hack 10" -show combi -icon -theme "papyrus" -show-icons
# SUPER (WINDOWS) + SPACE
# Another theme:
# rofi -combi-modi window,drun,ssh -theme arthur -font "hack 25" -show combi -icon -show-icons -icon-size 35
# rofi-theme-selector
#
# Install some Command-line tools.
yes | sudo apt install neofetch && \
yes | sudo apt install htop && \
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
# Flatpak Example:
# Install MS Windows layer translator, Bottle from Flatpak:
# flatpak install flathub com.usebottles.bottles
# flatpak run com.usebottles.bottles
#
# ------------------------------------------------------------------------------
# Install a Firewall:
yes | sudo apt install gufw && \
# ------------------------------------------------------------------------------
# File and directory monitoring system
# Gamin is a file and directory monitoring system which allows
# applications to detect when a file or a directory has been added,
# removed or modified by somebody else.
yes | sudo apt install gamin && \
# ------------------------------------------------------------------------------
# HDD tools
yes | sudo apt install smartmontools && \
yes | sudo apt install gsmartcontrol && \
# Install an Antivirus:
yes | sudo apt install chkrootkit && \
# sudo nano /etc/chkrootkit.conf
# RUN_DAILY="true"
# USERNAME=$(whoami)
# Usage (you do not have to scan immediately):
# sudo chkrootkit >> "/home/$USERNAME/chkrootkit-report.txt"
yes | sudo apt install rkhunter && \
sudo rkhunter --propupd && \
# sudo rkhunter --update
# Usage (you do not have to scan immediately):
# sudo rkhunter --check --sk --report-warnings-only >> "/home/$USERNAME/rkhunter-report.txt"
# ------------------------------------------------------------------------------
# Install System Restore/Maintenance Tools:
# Network Time Protocol daemon/utilities
yes | sudo apt install ntp && \
# tool for selecting tasks
yes | sudo apt install tasksel && \
# Partition Manager
yes | sudo apt install gparted && \
yes | sudo apt install gnome-disk-utility && \
# File Sync
yes | sudo apt install rsync && \
yes | sudo apt install grsync && \
# Drive Cloning
# how to clone a drive in linux
# https://www.makeuseof.com/tag/2-methods-to-clone-your-linux-hard-drive/
yes | sudo apt install clonezilla && \
# System Restore
yes | sudo apt install timeshift && \
# Load Program Faster while launching for the second time
yes | sudo apt install preload && \
# seahorse: GUI Keyring Manager
# https://mexpolk.wordpress.com/2008/02/06/ubuntu-change-default-keyring-password/
yes | sudo apt install seahorse && \
# Reduce Eyestrain # Yellow filter for the screen
yes | sudo apt install redshift-gtk && \
# Very simple screen magnifier
yes | sudo apt install magnus && \
# Advanced FreeDesktop.org compliant menu editor
yes | sudo apt install menulibre && \
# Prevent Screen from falling asleep # Keep the screen from turning off
#yes | sudo apt install caffeine && \
# Command-line system info tool # Hardware info from the console
yes | sudo apt install hardinfo && \
# The Fish Shell
yes | sudo apt install fish && \
# ------------------------------------------------------------------------------
# Other utilities:
#
# Bittorrent client
yes | sudo apt install transmission && \
# simple browser #ex: firejail surf google.com
yes | sudo apt install surf && \
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

# Screenshot Utility.
yes | sudo apt install flameshot && \
# Defrag NTFS Volumes.
yes | sudo apt install ntfs-3g && \
# Terminal Emulator
yes | sudo apt install kitty && \
yes | sudo apt install sakura && \
# The Suckless ST Terminal Emulator basic package:
# yes | sudo apt install stterm && \
# Build it from the source
# https://github.com/bakkeby/st-flexipatch.git
#
yes | sudo apt install tree && \
# Midnight commander command-line file manager
# sudo apt install mc && \
# KDE Advanced Text Editor (supports LSP)
yes | sudo apt install kate && \
# ------------------------------------------------------------------------------
# Developer Utilities:
yes | sudo apt install cdecl && \
yes | sudo apt install cutils && \
yes | sudo apt install cppcheck && \
yes | sudo apt install cppcheck-gui && \
yes | sudo apt install splint && \
#yes | sudo apt install cmake-gui && \
yes | sudo apt install cmake && \
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

# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# Req. by PlatformIO Embedded Systems Development Platform
# CuteCOM: GUI Serial Monitor
# https://www.pragmaticlinux.com/2021/11/how-to-monitor-the-serial-port-in-linux/
yes | sudo apt install cutecom && \

# Req. by PlatformIO CORE CLI

yes | sudo apt purge --auto-remove brltty && \

yes | sudo apt update && \
# https://www.pragmaticlinux.com/2021/11/how-to-monitor-the-serial-port-in-linux/
yes | sudo apt install cutecom && \
# https://askubuntu.com/questions/786367/setting-up-arduino-uno-ide-on-ubuntu
# https://askubuntu.com/questions/781571/how-to-identify-devices-connected-to-serial-port
# https://unix.stackexchange.com/questions/390184/dmesg-read-kernel-buffer-failed-permission-denied
# https://0xsuk.github.io/posts/2022-07-19-how-to-install-ch340-on-ubuntu-22.04/
yes | sudo apt install hwinfo && \
yes | sudo apt install setserial && \

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
yes | sudo apt install icc-profiles \

yes | sudo apt install gimp-plugin-registry && \
yes | sudo apt install gmic && \
yes | sudo apt install gimp-gmic && \

yes | sudo apt install gegl && \
yes | sudo apt install xzgv && \

# GIMP:

yes | sudo apt install gimp gimp-data gimp-data-extras gimp-gmic gimp-gutenprint gimp-help-common gimp-help-en-gb gimp-lensfun gimp-plugin-registry gimp-texturize icc-profiles icc-profiles-free gegl gtkam-gimp xzgv \

# Converseen: A free cross-platform batch image processor. https://converseen.fasterland.net/

yes | sudo apt install converseen && \

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

