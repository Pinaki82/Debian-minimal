#!/bin/bash


# batch-video-brightness-adjuster
#  Partly written by: Claude 3.5 Sonnet
# A variant of 'increase-brightness-simple.sh'

inputfolder="/media/sf_ffmpeg_linux_tst"
folder_path="$inputfolder"

# Remove surrounding quotes if present
folder_path="${folder_path%\"}"
folder_path="${folder_path#\"}"

if [ ! -d "$folder_path" ]; then
    echo "Error: The specified folder does not exist. The program will exit."
    exit 1
fi

echo "Using folder: $folder_path"

echo "This script will use FFmpeg's Curves filter to adjust video brightness. Example: -vf \"curves=all='0/0 0.5/0.8 1/1'\""
echo "The filter syntax is: curves=all='0/0 midpoint/brightness 1/1'"
echo "For example, '0/0 0.5/0.8 1/1' maps midtone brightness (0.5) to brightness level (0.8)"
echo "Any value in the range of 0.1 to 1 can be used. Thus, any ratio, such as 0.8/1, 0.5/0.7, or 0.7/0.9, is possible."

read -p "Enter the brightness factor numerator (e.g., 0.5): " numerator
read -p "Enter the brightness factor denominator (e.g., 0.8): " denominator

# Function to process a single video file
process_video() {
    local inputfile="$1"
    local outputfile="${inputfile%.*}-bright.AVI"

    echo "Processing file: $inputfile"

    echo "Previewing the video with adjusted brightness..."
    ffplay -vf "curves=all='0/0 $numerator/$denominator 1/1':plot=out.plt" "$inputfile"

    echo "Generating brightness curve plot..."
    gnuplot -e "set terminal png size 800,600; set output 'brightness_curve.png'" out.plt

    if command -v display &> /dev/null; then
        display brightness_curve.png
        rm brightness_curve.png
        rm out.plt
    else
        echo "ImageMagick's 'display' command not found."
    fi

    read -p "Do you want to save the processed video? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "Processing and saving the video..."
        ffmpeg -i "$inputfile" -vf "curves=all='0/0 $numerator/$denominator 1/1'" -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -c:a pcm_s16le "$outputfile"
        echo "Processed video saved as: $outputfile"

        read -p "Would you like the processed video to replace the original one? (y/n): " replace_choice
        if [[ "$replace_choice" =~ ^[Yy]$ ]]; then
            if command -v trash &> /dev/null; then
                # =========Required: 'trash-cli'. yes | sudo apt install trash-cli =====
                trash "$inputfile"
            else
                rm "$inputfile"
            fi
            mv "$outputfile" "$inputfile"
            echo "Original video replaced with the processed version."
        else
            echo "The original video has been retained."
        fi
    else
        echo "Video processing skipped for this file."
    fi
}

# Process all files in the folder
for inputfile in "$inputfolder"/*.* ; do
    if [ -f "$inputfile" ]; then
        process_video "$inputfile"
    else
        echo "Warning: $inputfile is not a regular file, skipping."
    fi
done

echo "Script execution completed for all files in the folder."
