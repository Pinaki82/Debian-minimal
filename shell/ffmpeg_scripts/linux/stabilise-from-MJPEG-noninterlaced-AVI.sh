#!/bin/bash


# FFMPEG Motion/Video Stabiliser
# USAGE:
# chmod +x stabilise.sh
# ./stabilise.sh 00000.MTS

# https://www.paulirish.com/2021/video-stabilization-with-ffmpeg-and-vidstab/
# https://www.marache.net/post/shake-reduction-ffmpeg.html
# The first pass ('detect') generates stabilization data and saves to `transforms.trf`
# The `-f null -` tells ffmpeg there's no output video file
rm transform_file

# ===================================================================
# Variable Name/File Name: 00000.MTS (Example)
# (Ref: https://linoxide.com/arguments-in-shell-script/)
# ===================================================================

echo "Type the filename with extension: (Press TAB to autocomplete.) $1"
filename=$1
echo "filename: $filename" # Added quotes around $filename in the echo statement to handle filenames with spaces.

if [ -z "$filename" ]; then # The -z flag checks if the variable is empty, which is a more appropriate check for the purpose of this script.
  echo "No filename. The program will Exit!"
  sleep 1
  exit
fi

# The changed script first prompts the user to enter a filename, then checks if the $filename variable is empty. If it is, the script prints a message and exits. If the $filename variable is not empty, the script proceeds with the rest of the logic.

echo "Four stabilisation modes are available."
echo "1. Mild"
echo "2. Normal (recommended)"
echo "3. Extra"
echo "4. Ultra"
echo "Choose one option from above:"

read -p "Enter mode (1-4): " mode # The `read -p` command is employed to prompt the user to enter the mode, instead of just `read`.

case "$mode" in # The Case statement is used, which is a more concise way to handle multiple conditions.
  1)
    echo "stepsize=30, zoom=0.7, smoothing=20"
    stepsize=30
    zoom=0.7
    smoothing=20
    # The values to the variables stepsize, zoom, and smoothing are directly assigned instead of using $ before the variable names.
    ;; # a default case is added to handle invalid input, which prints an error message and exits the script.
  2)
    echo "stepsize=25, zoom=1, smoothing=25"
    stepsize=25
    zoom=1
    smoothing=25
    ;;
  3)
    echo "stepsize=20, zoom=2, smoothing=35"
    stepsize=20
    zoom=2
    smoothing=35
    ;;
  4)
    echo "stepsize=15, zoom=3.5, smoothing=55"
    stepsize=15
    zoom=3.5
    smoothing=55
    ;;
  *)
    echo "Invalid mode. Exiting..."
    exit 1
    ;;
esac

sleep 1

# The simplified script first prompts the user to enter a mode (1-4), then uses a case statement to set the appropriate values for stepsize, zoom, and smoothing based on the user's input. If the user enters an invalid mode, the script prints an error message and exits.

# ----------------------------------------------------------------
# Concatenate Stings in Shell Scripts
# https://stackoverflow.com/questions/4181703/how-to-concatenate-string-variables-in-bash#4181721
# ----------------------------------------------------------------
convrtd_file_s_extnsn='.AVI'
newfilename="${filename}${convrtd_file_s_extnsn}"
echo newfilename: $newfilename

cp $filename $newfilename

# ===================================================================

# DEFAULT OPTION: ffmpeg -i $newfilename -vf vidstabdetect -f null -
ffmpeg -i $newfilename -vf "vidstabdetect=$stepsize:shakiness=10:accuracy=15:show=2:result=transform_file" -f null -
stabilised_vdo_extnsn='-stabilised.AVI'
stabilised_vdo="${newfilename}${stabilised_vdo_extnsn}"
echo stabilised_vdo: $stabilised_vdo
# The second pass ('transform') uses the .trf and creates the new stabilised video.

ffmpeg -i $newfilename -filter:v vidstabtransform=$zoom:relative=1:$smoothing:input="transform_file":interpol=bicubic -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset ultrafast $stabilised_vdo

# Ultra/Extra/Normal/Mild
# stepsize=15/20/25/30
# zoom=3.5/2/1/0.7 smoothing=55/35/25/20

# =========OPTIONAL======================
vstacked_vid_extnsn='-stacked.avi'
hstacked_vid_extnsn='-sxs.avi'
vstacked="${newfilename}${vstacked_vid_extnsn}"
hstacked="${newfilename}${hstacked_vid_extnsn}"
echo vstacked: $vstacked
echo hstacked: $hstacked
# vertically stacked
ffmpeg -i $newfilename -i $stabilised_vdo -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset ultrafast -filter_complex vstack $vstacked

# side-by-side
ffmpeg -i $newfilename -i $newfilename-stabilised.AVI -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset ultrafast -filter_complex hstack $hstacked

# =========OPTIONAL======================

rm transform_file
rm $newfilename

# =========(OPTIONAL) AUTO-RENAME STABILISED VIDEO======================
# =========Required: 'trash-cli'. yes | sudo apt install trash-cli =====

# trash $filename
# mv $stabilised_vdo $filename


# ======================================================================
# The key components:

# 1. **User Input**: The script prompts the user to input the filename and choose a stabilisation mode (Mild, Normal, Extra, or Ultra).

# 2. **Variable Initialisation**: Based on the user's mode selection, the script sets the appropriate values for `stepsize`, `zoom`, and `smoothing` parameters.

# 3. **File Handling**: The script creates a copy of the input file with a `.AVI` extension and stores it as `$newfilename`.

# 4. **First Pass: Detect Motion**: The first FFmpeg command runs the `vidstabdetect` filter to generate the stabilisation data and save it to the `transform_file`.

# 5. **Second Pass: Transform Video**: The second FFmpeg command uses the `vidstabtransform` filter to apply the stabilisation to the video, creating a new stabilised video file with a `-stabilised.AVI` extension.

# 6. **Optional Stacked Outputs**: The script includes commented-out sections to create vertically stacked and side-by-side comparisons of the original and stabilised videos.

# 7. **Cleanup**: Finally, the script removes the temporary `transform_file` and the original copy of the input file.

