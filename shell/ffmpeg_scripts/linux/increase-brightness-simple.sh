#!/bin/bash


# DuckDuckGo: ffmpeg curve average brightness contrast increase
# https://video.stackexchange.com/questions/20962/ffmpeg-color-correction-gamma-brightness-and-saturation
# https://ayosec.github.io/ffmpeg-filters-docs/3.0.12/Filters/Video/curves.html
# https://hhsprings.bitbucket.io/docs/programming/examples/ffmpeg/manipulating_video_colors/curves.html

echo "Type the filename with extension: (Press TAB to autocomplete.) $1"
filename=$1
echo "filename: $filename" # Added quotes around $filename in the echo statement to handle filenames with spaces.

if [ -z "$filename" ]; then # The -z flag checks if the variable is empty, which is a more appropriate check for the purpose of this script.
  echo "No filename. The program will Exit!"
  sleep 1
  exit
fi

echo "This script will use FFmpeg's Curves filter to adjust video brightness. Example: -vf \"curves=all='0/0 0.5/0.8 1/1'\""
echo "The filter syntax is: curves=all='0/0 midpoint/brightness 1/1'"
echo "For example, '0/0 0.5/0.8 1/1' maps midtone brightness (0.5) to brightness level (0.8)"
echo "Any value in the range of 0.1 to 1 can be used. Thus, any ratio, such as 0.8/1, 0.5/0.7, or 0.7/0.9, is possible."

read -p "Enter the brightness factor numerator (e.g., 0.5): " numerator
read -p "Enter the brightness factor denominator (e.g., 0.8): " denominator

echo "Previewing the video with adjusted brightness..."
ffplay -vf "curves=all='0/0 $numerator/$denominator 1/1':plot=out.plt" "$filename"

echo "Generating brightness curve plot..."
gnuplot -e "set terminal png size 800,600; set output 'brightness_curve.png'" out.plt

# https://chat.lmsys.org/
# claude-3-5-sonnet-20240620
# This command does the following:
# 1. `gnuplot`: Calls the gnuplot program
# 2. `-e`: Allows you to execute gnuplot commands directly from the command line
# 3. `"set terminal png; set output 'output.png'"`: These are the gnuplot commands to set the output terminal to PNG and specify the output file name
# 4. `out.plt`: This is your input gnuplot script file
# 5. If you need a different image format, you can replace 'png' with other formats like 'jpeg', 'gif', or 'svg'.
# 6. You can adjust the size of the output image by adding size parameters, like this:
# gnuplot -e "set terminal png size 800,600; set output 'output.png'" out.plt

# https://www.baeldung.com/linux/view-images-from-terminal
# Requires ImageMagick

# Display the generated plot if ImageMagick is installed
if command -v display &> /dev/null; then
    display brightness_curve.png
    # Clean up temporary files
    rm brightness_curve.png
    rm out.plt
else
    echo "ImageMagick's 'display' command not found."
fi

read -p "Do you want to save the processed video? (y/n): " choice # The `read -p` command is employed to prompt the user to enter the choice, instead of just `read`.
if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo "Processing and saving the video..."
    output_filename="${filename%.*}-bright.AVI"
    ffmpeg -i "$filename" -vf "curves=all='0/0 $numerator/$denominator 1/1'" -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -c:a pcm_s16le "$output_filename"
    echo "Processed video saved as: $output_filename"
else
    echo "Video processing cancelled."
fi

# =========Required: 'trash-cli'. yes | sudo apt install trash-cli =====
read -p "Would you like the processed video to replace the original one? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    trash $filename
    mv $output_filename $filename
else
    echo "The original video has been retained."
fi

echo "Script execution completed."

