#!/bin/bash


### Perform a Rootkit scan:

### YOUR_USERNAME must be replaced by the actual username.
### Remember that the Search & Replace function in your text editor is your friend.

### 1. Scan with chkrootkit:

# https://www.tecmint.com/scan-linux-for-malware-and-rootkits/
# https://www.makeuseof.com/tag/free-linux-antivirus-programs/
# https://linuxhint.com/install_chkrootkit/
# https://linuxhint.com/detect_linux_system_hacked/
# sudo apt install chkrootkit
# sudo nano /etc/chkrootkit.conf
# RUN_DAILY="true"

USERNAME=$(whoami) && \
sudo chkrootkit >> "/home/$USERNAME/chkrootkit-report.txt" && \

### 2. Scan with rkhunter:

# https://www.tecmint.com/install-rootkit-hunter-scan-for-rootkits-backdoors-in-linux/
# https://wiki.archlinux.org/index.php/Rkhunter
# https://kifarunix.com/how-to-install-rkhunter-rootkit-hunter-on-ubuntu-18-04/
# sudo apt install rkhunter
# DB update:
# sudo rkhunter --update

sudo rkhunter --propupd && \
sudo rkhunter --check --sk --report-warnings-only >> "/home/$USERNAME/rkhunter-report.txt" && \

# https://askubuntu.com/questions/250290/how-do-i-scan-for-viruses-with-clamav
# https://www.2daygeek.com/install-configure-clamav-antivirus-on-linux/
# https://sysnet-adventures.blogspot.com/2013/05/whitelist-files-with-clamav.html

# Prepare a list of directories you want to skip while performing a threat scan with ClamAV.
# ----------------------------------
# touch /home/YOUR_USERNAME/ClamScanExclusionList.txt
# ----------------------------------
# 1. List directories.
# 2. Write one path per line.
# 3. Do not forget to surround the full path with a double-quote if the path contains anything other than a string of usual characters without spaces.
# 4. Directories like "/home/YOUR_USERNAME/Browser Settings/", "/home/YOUR_USERNAME/cinelerra-5.1-ub20.04-20201031.x86_64-static/", or "/home/YOUR_USERNAME/.arduinoIDE/" must be guarded with a double-quote, while a path like /home/YOUR_USERNAME/PortablePrograms/ doesn't need to be covered by a double-quote.
# 5. Never leave any empty line in 'ClamScanExclusionList.txt'.
# ----------------------------------
# Examples are:
# ----------------------------------
# File: ClamScanExclusionList.txt
# ----------------------------------
# Contents:
# ----------------------------------
# /home/YOUR_USERNAME/Arduino/
# "/home/YOUR_USERNAME/Browser Settings/"
# "/home/YOUR_USERNAME/cinelerra-5.1-ub20.04-20201031.x86_64-static/"
# /home/YOUR_USERNAME/Desktop/
# /home/YOUR_USERNAME/Documents/
# "/home/YOUR_USERNAME/.themes/"
# /home/YOUR_USERNAME/Music/
# /home/YOUR_USERNAME/Pictures/
# /home/YOUR_USERNAME/Pictures/
# /home/YOUR_USERNAME/PortablePrograms/
# /home/YOUR_USERNAME/Public/
# /home/YOUR_USERNAME/Templates/
# /home/YOUR_USERNAME/Videos/
# /home/YOUR_USERNAME/Xubuntu_General/
# "/home/YOUR_USERNAME/.arduino15/"
# "/home/YOUR_USERNAME/.arduinoIDE/"
# "/home/YOUR_USERNAME/.config/"
# "/home/YOUR_USERNAME/.dia/"
# "/home/YOUR_USERNAME/.equalx/"
# "/home/YOUR_USERNAME/.ffDiaporama/"
# "/home/YOUR_USERNAME/.gnupg/"
# "/home/YOUR_USERNAME/.grsync/"
# "/home/YOUR_USERNAME/.hardinfo/"
# "/home/YOUR_USERNAME/.hugindata/"
# "/home/YOUR_USERNAME/.java/"
# "/home/YOUR_USERNAME/.lyx/"
# "/home/YOUR_USERNAME/.mplayer/"
# "/home/YOUR_USERNAME/.pki/"
# "/home/YOUR_USERNAME/.ssr/"
# "/home/YOUR_USERNAME/.texlive2019/"
# "/home/YOUR_USERNAME/.vim/"
# "/home/YOUR_USERNAME/.vimbackup/"
# "/home/YOUR_USERNAME/.vimdotcommon/"
# "/home/YOUR_USERNAME/.vimdotlinux/"
# "/home/YOUR_USERNAME/.vimdotwin/"
# "/home/YOUR_USERNAME/.vimswap/"
# "/home/YOUR_USERNAME/.vimundo/"
# "/home/YOUR_USERNAME/.vimviews/"
# "/home/YOUR_USERNAME/.local/share/icons/"
# "/home/YOUR_USERNAME/.local/share/applications/"
# ----------------------------------


### For the complete report about a scan instance:

# sed -e 's/^/--exclude=/' "/home/$USERNAME/ClamScanExclusionList.txt" | xargs clamscan --verbose -r -i --bell "/home/$USERNAME/" >> "/home/$USERNAME/report-file.txt"

### Create an entry to the report file only if the scanner finds a threat:

sed -e 's/^/--exclude=/' "/home/$USERNAME/ClamScanExclusionList.txt" | xargs clamscan --verbose -r -i --bell "/home/$USERNAME/" | grep FOUND >> "/home/$USERNAME/report-file.txt" \

