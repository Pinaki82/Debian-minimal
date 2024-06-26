#!/bin/bash

# Create WEBM-VP8 alpha-channel-enabled videos from motion graphics with chroma (green/blue) keys.

# https://chat.lmsys.org/
# claude-3-5-sonnet-20240620

# Please give me an FFMPEG command that does the following:
# 1. Applies a chroma-key (green) on the input video.
# 2. Removes that green chroma-key colour from the provided input and adds an alpha channel.
# 3. Produces a final output in WEBM VP8 format including the added alpha channel, and the green chroma colour removed.

# Here's an FFmpeg command that accomplishes the tasks you've described:

# ```
# ffmpeg -i input.mp4 -filter_complex "[0:v]chromakey=0x00FF00:0.1:0.2[ckout];[ckout]format=yuva420p" -c:v libvpx -auto-alt-ref 0 -b:v 1M output.webm
# ```

# Let's break down this command:

# 1. `-i input.mp4`: Specifies the input video file.

# 2. `-filter_complex`: This option allows us to use complex filtering operations.

# 3. `"[0:v]chromakey=0x00FF00:0.1:0.2[ckout]"`:
#    - `[0:v]` selects the first (0) video (v) stream
#    - `chromakey=0x00FF00:0.1:0.2` applies the chroma key effect
#      - `0x00FF00` is the hex code for green
#      - `0.1` is the similarity threshold (0-1)
#      - `0.2` is the blend threshold (0-1)
#    - `[ckout]` names the output of this filter

# 4. `[ckout]format=yuva420p`: This converts the output to YUV420 format with an alpha channel.

# 5. `-c:v libvpx`: Sets the video codec to VP8.

# 6. `-auto-alt-ref 0`: This disables the use of alternate reference frames, which is necessary for alpha channel support in VP8.

# 7. `-b:v 1M`: Sets the video bitrate to 1 Mbps. Adjust this value as needed for your quality requirements.

# 8. `output.webm`: Specifies the output file name and format.

# This command will take your input video, apply a green screen chroma key effect, remove the green color, add an alpha channel, and output the result as a WebM file with VP8 encoding and alpha channel support.

# Note: The similarity and blend thresholds (0.1 and 0.2 in this example) may need to be adjusted depending on your specific video to get the best results. You might need to experiment with these values.

# Also, ensure that you have FFmpeg installed with libvpx support to use this command.

# ========= Extra:
# From videos that already contain an alpha channel:
# ffmpeg -i input.mov -preset ultrafast -c:v libvpx -pix_fmt yuva420p -b:v 3M -an -auto-alt-ref 0 -hide_banner -map 0:v:0 -aspect 16:9 -s hd1080 output.webm

# ffmpeg -i input.mp4 -filter_complex "[0:v]chromakey=0x00FF00:0.1:0.2[ckout];[ckout]format=yuva420p" -c:v libvpx -auto-alt-ref 0 -b:v 1M output.webm

# https://stackoverflow.com/questions/8299252/ffmpeg-chroma-key-greenscreen-filter-for-images-video
# https://superuser.com/questions/1563712/ffmpeg-blend-choice-with-video-green-screen
# [1:v]colorkey=0x00ff00:0.4:0.2[ckout];[0:v][ckout]overlay[out]' -map '[out]
# 0.4 is the similarity factor and 0.2 is the opacity factor
# =========


echo "Type the filename with extension: (Press TAB to autocomplete.) $1"
filename=$1
echo "filename: $filename" # Added quotes around $filename in the echo statement to handle filenames with spaces.

if [ -z "$filename" ]; then # The -z flag checks if the variable is empty, which is a more appropriate check for the purpose of this script.
  echo "No filename. The program will Exit!"
  sleep 1
  exit
fi

echo "One of the three different colours can be selected. A custom HTML colour value can also be entered."
echo "1. Green 0x00FF00 #00ff00"
echo "2. Black 0x000000 #000000"
echo "3. Blue  0X0000FF #0000ff"
echo "4. Submit a custom colour value in HTML Colour format:"
echo "Choose one option from above:"

read -p "Enter the choice number (1-4): " choice # The `read -p` command is employed to prompt the user to enter the choice, instead of just `read`.

case "$choice" in # The Case statement is used, which is a more concise way to handle multiple conditions.
  1)
    echo "1. Green 0x00FF00 #00ff00"
    colour=0x00FF00
    # The value to the variable colour is directly assigned instead of using $ before the variable name.
    ;; # a default case is added to handle invalid input, which prints an error message and exits the script.
  2)
    echo "2. Black 0x000000 #000000"
    colour=0x000000
    ;;
  3)
    echo "3. Blue  0X0000FF #0000ff"
    colour=0X0000FF
    ;;
  4)
    echo "4. Submit a custom colour value in HTML Colour format:"
    echo "Use the Color-Picker app if required: sudo apt install color-picker"
    read -p colour_custom
    colour=$colour_custom
    ;;
  *)
    echo "Invalid choice. Exiting..."
    exit 1
    ;;
esac

echo "colour: $colour"

sleep 1

read -p "Enter the similarity factor (Recommended: 0.1 or 0.15 (preferably 0.15 if there are no sharp edges around), can go up to 0.4)/ ** Pitch-black: 0.01: " similarity # The `read -p` command is employed to prompt the user to enter the value, instead of just `read`.

sleep 1

read -p "Adjust the opacity factor/blend threshold (Recommended values: Pitch-black: 0.001, Green-screen: 0.2): " opacity # The `read -p` command is employed to prompt the user to enter the value, instead of just `read`.

convrtd_file_s_extnsn='.webm'
newfilename="${filename}${convrtd_file_s_extnsn}"

ffmpeg -i $filename -filter_complex "[0:v]chromakey=$colour:$similarity:$opacity[ckout];[ckout]format=yuva420p" -preset ultrafast -c:v libvpx -auto-alt-ref 0 -b:v 15M $newfilename
