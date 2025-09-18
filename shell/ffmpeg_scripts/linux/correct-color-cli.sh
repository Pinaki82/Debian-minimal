#!/bin/bash

# Automatic colour correction - CLI version
#
# USAGE:
#   correct-color-cli.sh [INPUT_IMAGE] [OUTPUT_IMAGE]
#
# If arguments are omitted, you will be prompted interactively.
#
# INSTALLATION TIP:
# Place this script along with 'autowhite.sh' and any related tools
# into ~/.local/bin and make them executable:
#
#   cp correct-color-cli.sh ~/.local/bin/
#   cp autowhite.sh ~/.local/bin/          # if not already there
#   chmod +x ~/.local/bin/correct-color-cli.sh
#   chmod +x ~/.local/bin/autowhite.sh
#
# Ensure ~/.local/bin is in your PATH (usually it is by default on modern Linux).
# Then you can run from anywhere:
#
#   correct-color-cli.sh photo.jpg photo-corrected.jpg

set -euo pipefail

# Check for required tools
command -v autowhite.sh >/dev/null 2>&1 || { echo "Error: autowhite.sh not found in PATH" >&2; exit 1; }
command -v convert >/dev/null 2>&1 || { echo "Error: ImageMagick 'convert' not found" >&2; exit 1; }

# Get input file
input=""
if [[ $# -ge 1 ]]; then
    input="$1"
else
    read -rp "Enter path to input image: " input
fi

[[ ! -f "$input" ]] && { echo "Error: Input file '$input' not found." >&2; exit 1; }

# Derive default output filename
base=$(basename "${input%.*}")
ext="${input##*.}"
default="${base}-corrected.${ext}"

# Get output filename
outfile=""
if [[ $# -ge 2 ]]; then
    outfile="$2"
else
    read -rp "Enter output filename (saved in same folder) [$default]: " user_outfile
    outfile=${user_outfile:-$default}
fi

dir=$(dirname "$input")
tmp="$(mktemp --suffix=".$ext")"

# Cleanup on exit
trap 'rm -f "$tmp"' EXIT

echo "[10%] Applying white balance..."
autowhite.sh "$input" "$tmp"

echo "[50%] Applying auto levels and normalization..."
convert "$tmp" -auto-gamma -auto-level -normalize "$tmp"

echo "[90%] Saving result..."
mv "$tmp" "$dir/$outfile"

echo "[DONE] Corrected image saved as: $dir/$outfile"

# `correct-color-cli.sh`. Qwen: qwen3-max-preview. 2025.09.19. LMArena.

# https://superuser.com/questions/370920/auto-image-enhance-for-ubuntu
# convert -auto-gamma -auto-level -normalize original.jpg improved.jpg
# https://github.com/ImageMagick/ImageMagick/discussions/5197
# -white-balance
# https://stackoverflow.com/questions/5250409/imagemagick-auto-adjust-the-colours-of-an-image-a-la-other-photo-management-ap
# ./autowhite.sh input.jpg output.jpg

# https://stackoverflow.com/questions/5250409/imagemagick-auto-adjust-the-colours-of-an-image-a-la-other-photo-management-ap
# http://www.fmwconcepts.com/imagemagick/autowhite/index.php
# Place the `autowhite.sh` file into ~/.local/bin
# Change the permission parameter: chmod +x autowhite.sh
