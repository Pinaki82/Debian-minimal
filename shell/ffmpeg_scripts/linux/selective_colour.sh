#!/bin/bash


# FFMPEG Selective Colour: Keep Red (e.g., lipstick), and adequately desaturate the rest to grayscale.

# NOTE: To further lighten the skin tone during post-production, apply a filter to the video in the NLE.
# Shotcut: Chroma Hold. Cinelerra-GG-Infinity: Resources->Filters->FF_Color_Correction->F_chromahold. Kdenlive: Chroma Hold.

# In Cinelerra-GG-Infinity, you will have to pick the HTML colour value of the skin from the 'Compositor' Window.
# A rather decent software package for Debian is available that can select a colour from any visible area on the desktop.
# https://github.com/keshavbhatt/ColorPicker
# yes | sudo apt install color-picker

# If necessary, you can use the LUT colour profile "selective-color-lut-keep-only-red.cube," which is included with this bash script.
# As an alternative, you can run this bash file on the generated movie clip several times to get the desired outcome.

# Colour value to hold: Around #898180
# Filter strength: In Shotcut, 11 to 15.

# https://hhsprings.bitbucket.io/docs/programming/examples/ffmpeg/manipulating_video_colors/selectivecolor.html
# https://superuser.com/questions/1703076/how-to-use-ffmpeg-to-selectively-replace-a-specific-color-with-another-color-in
# https://ffmpeg.org/ffmpeg-filters.html#selectivecolor-1

# correction_method
#    Select color correction method.
#    Available values are:
#    ‘absolute’
#        Specified adjustments are applied "as-is" (added/subtracted to original pixel component value).
#    ‘relative
#        Specified adjustments are relative to the original component value.

# reds
#     Adjustments for red pixels (pixels where the red component is the maximum)
# yellows
#     Adjustments for yellow pixels (pixels where the blue component is the minimum)
# greens
#     Adjustments for green pixels (pixels where the green component is the maximum)
# cyans
#     Adjustments for cyan pixels (pixels where the red component is the minimum)
# blues
#     Adjustments for blue pixels (pixels where the blue component is the maximum)
# magentas
#     Adjustments for magenta pixels (pixels where the green component is the minimum)
# whites
#     Adjustments for white pixels (pixels where all components are greater than 128)
# neutrals
#     Adjustments for all pixels except pure black and pure white
# blacks
#     Adjustments for black pixels (pixels where all components are lesser than 128)
# -vf "selectivecolor=whites=0 0 0 .19" means 19% of the black value is to be increased or decreased.
# The value must be between -1 and +1.

echo "Type the filename with extension: (Press TAB to autocomplete.) $1"
filename=$1
echo "filename: $filename" # Added quotes around $filename in the echo statement to handle filenames with spaces.

if [ -z "$filename" ]; then # The -z flag checks if the variable is empty, which is a more appropriate check for the purpose of this script.
  echo "No filename. The program will Exit!"
  sleep 1
  exit
fi

convrtd_file_s_extnsn='.AVI'
newfilename="${filename}${convrtd_file_s_extnsn}-red"
echo newfilename: $newfilename

ffmpeg -y -i $filename -filter_complex "
[0:v]split=2[color][gray];
[gray]lutyuv=u=128:v=128[gray];
[color]colorhold=color=0xFF0000:similarity=0.3:blend=0.2[color];
[gray][color]overlay
" -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -c:a pcm_s16le "$newfilename.AVI"

# Loop through all files with the .AVI.AVI-red.AVI extension
for file in *.AVI.AVI-red.AVI; do
  # Check if the file exists to handle the case when no files match the pattern
  [ -e "$file" ] || continue

  # Remove the .MTS part of the extension
  newfile="${file/.AVI.AVI-red.AVI/-red.AVI}"

  # Rename the file
  mv "$file" "$newfile"
done
