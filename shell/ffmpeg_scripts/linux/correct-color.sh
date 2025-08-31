#!/bin/bash

# Automatic colour correction.

# Prompt for input image via drag-and-drop
input=$(zenity --file-selection --title="Select an image to auto-correct")
[ $? -ne 0 ] && exit 1

# Ask for output filename
base=$(basename "${input%.*}")
ext="${input##*.}"
default="${base}-corrected.${ext}"
outfile=$(zenity --entry --title="Output filename" \
  --text="Enter output filename (saved in same folder):" \
  --entry-text="$default")
[ $? -ne 0 ] && exit 1

dir=$(dirname "$input")
tmp="$(mktemp --suffix=".$ext")"

(
  echo "10" ; echo "# Applying white balance..."
  autowhite.sh "$input" "$tmp"

  echo "50" ; echo "# Applying auto levels..."
  convert "$tmp" -auto-gamma -auto-level -normalize "$tmp"

  echo "90" ; echo "# Saving result..."
) | zenity --progress --auto-close --title="Processing image"

mv "$tmp" "$dir/$outfile"
zenity --info --title="Done" \
  --text="Corrected image saved as:\n$dir/$outfile"

# `correct-color.sh`. OpenAI ChatGPT. 2025.07.28

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
