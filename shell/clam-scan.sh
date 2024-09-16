#! /usr/bin/env bash


# https://superuser.com/questions/1814746/what-regex-syntax-is-used-to-specify-include-exclude-for-clamscan

# Update the AV database
# https://askubuntu.com/questions/909273/clamav-error-var-log-clamav-freshclam-log-is-locked-by-another-process
sudo systemctl stop clamav-freshclam.service && \
sudo freshclam && \

# bool function to test if the user is root or not
is_user_root () { [ "${EUID:-$(id -u)}" -eq 0 ]; }

is_user_root || {
    echo 'You are just an ordinary user. Run as root.' >&2
    exit 1
}

# Create an array of mounted drives to exclude
MOUNTED_DRIVES=($(mount | grep -E '^/dev' | awk '{print $3}' | grep -v '^/$'))

# Create an array of folders in HOME to exclude

LOG_FILE=/var/log/clamscan.log

EXCLUDE_ROOT_DIRS=(
    proc
    sys
    dev
    media
    mnt
    var/lib/flatpak
    snap
    timeshift
    home/YOURUSERNAME/Downloads
    home/YOURUSERNAME/.cache
    home/YOURUSERNAME/.local/share/Trash
    home/YOURUSERNAME/.themes
    home/YOURUSERNAME/.arduino15
    home/YOURUSERNAME/.arduinoIDE
    home/YOURUSERNAME/.config
    home/YOURUSERNAME/.dia
    home/YOURUSERNAME/.equalx
    home/YOURUSERNAME/.ffDiaporama
    home/YOURUSERNAME/.gnupg
    home/YOURUSERNAME/.grsync
    home/YOURUSERNAME/.hardinfo
    home/YOURUSERNAME/.hugindata
    home/YOURUSERNAME/.java
    home/YOURUSERNAME/.lyx
    home/YOURUSERNAME/.mplayer
    home/YOURUSERNAME/.pki
    home/YOURUSERNAME/.ssr
    home/YOURUSERNAME/.texlive2019
    home/YOURUSERNAME/.vim
    home/YOURUSERNAME/.vimbackup
    home/YOURUSERNAME/.vimdotcommon
    home/YOURUSERNAME/.vimdotlinux
    home/YOURUSERNAME/.vimdotwin
    home/YOURUSERNAME/.vimswap
    home/YOURUSERNAME/.vimundo
    home/YOURUSERNAME/.vimviews
    home/YOURUSERNAME/.local/share/icons
    home/YOURUSERNAME/.cargo
    home/YOURUSERNAME/.goldendict
    home/YOURUSERNAME/.local/share/icons
    home/YOURUSERNAME/.local/share/Anki2
    home/YOURUSERNAME/.local/share/flatpak
    home/YOURUSERNAME/.local/share/fonts
    home/YOURUSERNAME/.local/share/kdenlive
    home/YOURUSERNAME/.rustup
    home/YOURUSERNAME/.themes
    home/YOURUSERNAME/.local/share/flatpak
    home/YOURUSERNAME/snap
    home/YOURUSERNAME/.config/helix
    home/YOURUSERNAME/.config/obsidian
)

EXCLUDE_SUBDIRS=('lost\+found' .git)

# Build the exclusion string
EXCLUSIONS=""
for drive in "${MOUNTED_DRIVES[@]}"; do
  EXCLUSIONS="$EXCLUSIONS --exclude-dir=$drive"
done

declare -a EXCLUDE_DIRS
if [[ ${#EXCLUDE_ROOT_DIRS[@]} -ne 0 ]]; then
    ED_RE="^/("; for xrd in ${EXCLUDE_ROOT_DIRS[@]}; do ED_RE+="$xrd|"; done; ED_RE="${ED_RE%|})"
    EXCLUDE_DIRS+=("--exclude-dir=$ED_RE")
    #EXCLUDE_DIRS+="--exclude-dir=^/("; for xrd in ${EXCLUDE_ROOT_DIRS[@]}; do EXCLUDE_DIRS+="$xrd|"; done; EXCLUDE_DIRS="${EXCLUDE_DIRS%|})"; echo $EXCLUDE_DIRS
fi
if [[ ${#EXCLUDE_SUBDIRS[@]} -ne 0 ]]; then
    ED_RE="/("; for xsd in ${EXCLUDE_SUBDIRS[@]}; do ED_RE+="$xsd|"; done; ED_RE="${ED_RE%|})"
    EXCLUDE_DIRS+=("--exclude-dir=$ED_RE")
    #EXCLUDE_DIRS+=" --exclude-dir=/("; for xsd in ${EXCLUDE_SUBDIRS[@]}; do EXCLUDE_DIRS+="$xsd|"; done; EXCLUDE_DIRS="${EXCLUDE_DIRS%|})"; echo $EXCLUDE_DIRS
fi

# Adding --verbose will write Scanning messages to stdout e.g.
# Scanning /data/Games/henry/Steam/ubuntu12_32/steam-runtime/usr/share/doc/libglib2.0-0/README.gz
# https://unix.stackexchange.com/questions/211915/how-to-exclude-jpg-jpeg-png-gif-from-a-clamav-scan-clamscan
echo clamscan --suppress-ok-results --log=$LOG_FILE --max-filesize=100M --recursive ${EXCLUDE_DIRS[@]} $EXCLUSIONS --exclude='\\.(jpg|jpeg|png|gif|tga|tiff|bmp|NEF|CR3)$' /
clamscan --suppress-ok-results --log=$LOG_FILE --max-filesize=100M --recursive ${EXCLUDE_DIRS[@]} $EXCLUSIONS --exclude='\\.(jpg|jpeg|png|gif|tga|tiff|bmp|NEF|CR3)$' /

# NOTE: may want to edit the log file and remove the reports on Symbolic links and Empty files
# sed -i -E -e '/: (Symbolic link|Empty file)$/d' $LOG_FILE
echo 'List of any FOUND infected files'
grep FOUND$ /var/log/clamav.log
