# Debian-minimal

Configure Debian and install only essential packages after installing the OS.

---

https://github.com/Pinaki82/Debian-minimal

---

## What this repository is for?

### Guides to:

- Install Debian-XFCE on a system.

- Install programs commonly used by most people.

- _Modify_ and _back up_ 'only one install script' that serves you forever. You'll get a workable installation.

### Serves:

Desktop Computer Users.

## What this repository is not?

- This repository doesn't aim to be a Debian-descendant distribution.

This repository was started as a backup to the config files I use on my Debian-XFCE system. Then, I decided to split the core parts from basic to minimal. Basic means, you'll need those packages and configurations as a starting point. Here, Minimal stands for, you'll find packages most people use. Now it is your responsibility to include/discard sections of the 'minimal' unit and keep a backup of your final version that you will use forever. Feel free to clone this repository as a starting point for your own desktop configuration.

# Thou Shalt Never:

- Ever try to install Ubuntu PPAs. Debian does not have a mechanism to recognise PPAs, and doing so may corrupt your system.

- Install DEB packages that are not meant for Debian and are only meant for Ubunu-descendant Linux distributions. These packages may not be compatible with your system and could cause problems.

- Enable backports unless absolutely necessary. Backports are packages that have been ported from a newer version of Debian to an older version. They can sometimes cause problems, so only enable them if you need a specific updated version of a package that is not available in the main Debian repositories. Even if you have enabled backports, do not install more than one or two apps from there, that too, never without thorough consideration.

- Run commands or scripts from unverified sources. These commands could contain malicious code that could damage your system. Every time you run a command you must try to understand what that does.

- Install more apps than you need. This can clutter your system and make it less stable.

- Install a GUI-Userspace app (like GIMP, Inkscape, Krita, or Blender) from the Debian repository. Instead, you must prefer AppImage, Snap and Flatpak over the default repository as long as it is feasible.

- Install GUI-Userspace apps (like GIMP, Inkscape, Krita, and Blender) from the Debian repository. These extra apps will clutter your system. Instead, use AppImage, Snap, or Flatpak, which are newer formats that are more stable and up-to-date. Choose these newer containerised packaging platforms over the default repository as long as it is feasible.

- Avoid reading the documentation found here, online, discussions found in online forums, doing a web search, asking an AI engine when in doubt, RTFM - Read The Friendly Man Page before taking any steps no matter how trivial the step is when you do not know the deal.

## What you're allowed to do:

You can do an `apt search` for a package from the command line. There's no harm in trying to install packages in Debian as `sudo apt install package-gtk` when that particular package is `package-gtk3` in Debian. The command will not find the package in Debian's repository and return an error message without installing anything. However, adding PPAs or installing packages meant exclusively for Ubuntu will certainly damage your installation.

Your best bet will be to find a similar package as:

`apt search package-you-have-seen-in-ubuntu-repository`

You'll get an overall view and find the right direction.

Remember that Debian and Ubuntu have different package repositories. One doesn't pull anything directly from another's repository. Especially, Debian pulls nothing from Ubuntu's repository. Do not try to mix them.

## How to Use instructions and scripts provided here:

======

Programs to Create Bootable USB Drives:

https://rufus.ie/en/ (Recommended for Microsoft Windows users)

https://etcher.balena.io/

Debian Homepage: https://www.debian.org/

Debian Non-Free Firmware:

https://cdimage.debian.org/images/unofficial/non-free/firmware/

Download Debian (Recommended):

https://www.debian.org/download

_debian-xx.x.x-amd64-netinst.iso_

Debian Live Images:

Ref: https://unix.stackexchange.com/questions/307251/is-there-a-try-debian-without-install-option

Download: https://www.debian.org/CD/live/

Debian-12-bookworm firmware:

https://cdimage.debian.org/images/unofficial/non-free/firmware/bookworm/12.0.0/

File: `firmware.zip`

A Basic Guide:

https://phoenixnap.com/kb/how-to-install-debian-10-buster

Troubleshoot Blank Screen after crossing the GRUB Menu section:

https://forums.debian.net/viewtopic.php?t=63844

Press `e` when the GRUB appears.

Find the line containing `ro quiet` or `quiet`.

Add/Type the following commands to the end of the line,

`splash nomodeset`

`CTRL`+`x` [NOTE: On VirtualBox, use the Soft Keyboard from the menu bar.]

Once you enter the desktop:

Add the current user to **sudoers**:

`su`

`sudo su root`

`sudo nano /etc/sudoers`

Find the section:

```bash
#User privilege specification
root  ALL=(ALL:ALL) ALL
```

Then, add your username there as described below (`yourusername ALL=(ALL: ALL) ALL`).

-------------------------------------

```bash
#User privilege specification
root  ALL=(ALL:ALL) ALL
yourusername ALL=(ALL: ALL) ALL
```

-------------------------------------

Reboot the system.

`sudo reboot now`

Add the current user to **sudoers** again by doing:

`sudo usermod -aG sudo $(whoami)`

Edit the GRUB Bootloader:

Ref: https://unix.stackexchange.com/questions/538562/how-do-i-edit-grub-cfg-and-save-it

`sudo nano /etc/default/grub`

Find the line containing `ro quiet` or `quiet`

Add the following in the same line

`splash nomodeset`

Update the GRUB Bootloader:

`sudo update-grub`

`sudo update-grub2`

Troublshoot: https://serverfault.com/questions/717725/journalctl-access-for-non-root-users

```
Hint: You are currently not seeing messages from other users and the system.
      Users in groups 'adm', 'systemd-journal' can see all messages.
      Pass -q to turn off this notice.
```

`sudo usermod -a -G systemd-journal $(whoami)`

Reboot:

`sudo reboot now`

Update the system:

`yes | sudo apt update && sudo apt upgrade`

======

- Now, read the text file `00_debian-fresh-install.txt`.
  You'll know when to look at specific files.

- Next, read the script `01_debian_essential.sh` before running it. The script is about installing basic dependency/userspace packages that you usually expect from a computer or you'll need later.

Change the permission of the script before executing the script [Give it permission to execute].

```bssh
chmod +x 01_debian_essential.sh
```

To Run:

```bssh
./01_debian_essential.sh
```

- Come back to the primary instruction file `00_debian-fresh-install.txt`. Simply, read it without doing anything.

- When you come to see that the instruction tells you to READ/MODIFY/RUN the final script `02_debian_minimal_packages.sh`, do that and then come back again to the instruction file `00_debian-fresh-install.txt`.

```bssh
chmod +x 02_debian_minimal_packages.sh
```

```bssh
./02_debian_minimal_packages.sh
```

- Read the files in the folder 'shell' to get an overview of more packages.

- Look at other folders given here for desktop/app/system configurations.

## As a Mega-Bonus Offer for FREE, you'll find:

- Some essential MS Windows configurations.

- Suggestions for truly cross-platform alternative software in practical terms.

- Most applications are curated to work on MS Windows for an uncompromising cross-platform experience.
