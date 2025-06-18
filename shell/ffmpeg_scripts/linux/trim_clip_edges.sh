#!/bin/bash

# Purpose:
# This script trims video clips from an input folder to remove shaky and blurry sections
# typically found at the start and end of footage captured by unsteady hands.
# It processes all video files (AVI) in the input folder, trims 5 frames from the start
# and 11 frames from the end based on the video's frame rate, and saves the trimmed clips
# to an output folder using FFmpeg's copy option to avoid re-encoding.

# Usage:
# 1. Ensure FFmpeg is installed on your Debian 12 Bookworm system:
#    sudo apt-get install ffmpeg
# 2. Save this script as 'trim_clip_edges.sh' and make it executable:
#    chmod +x trim_clip_edges.sh
# 3. Run the script with input and output folder paths as arguments:
#    ./trim_clip_edges.sh /path/to/input/folder /path/to/output/folder
# 4. The script processes all AVI files in the input folder.
# 5. Output files are saved with 'trimmed_' prepended to the original filename.

# Requirements:
# - FFmpeg installed on Debian 12 Bookworm
# - Input folder containing AVI video files
# - Write permissions for the output folder

# Authorship:
# This script was written by Grok 3, created by xAI, on June 18, 2025.

# Set locale for numeric formatting to ensure dot (.) as decimal separator
export LC_NUMERIC=C

# Function to check if a string is a valid number
is_number() {
    if [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        return 0  # Valid number
    else
        return 1  # Invalid number
    fi
}

# Define input and output directories
input_dir="/mnt/hdd/Capture_Edit/Shotcut/2025.06.18-Folder/AVI"
output_dir="/mnt/hdd/Capture_Edit/Shotcut/2025.06.18-Folder/Trimmed"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Check if FFmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: FFmpeg is not installed. Please install it with 'sudo apt-get install ffmpeg'."
    exit 1
fi

# Prompt user about output filename preference
echo "Do you want to keep the original filenames for trimmed files? (y/n)"
read -r rename_choice
if [[ "$rename_choice" =~ ^[Yy]$ ]]; then
    use_original_names="yes"
else
    use_original_names="no"
fi

# Process each AVI file in the input directory
for file in "$input_dir"/*.AVI; do
    if [[ ! -f "$file" ]]; then
        echo "No AVI files found in $input_dir"
        break
    fi

    filename=$(basename "$file")
    # Set output filename based on user choice
    if [ "$use_original_names" = "yes" ]; then
        output_file="$output_dir/$filename"
    else
        output_file="$output_dir/trimmed_$filename"
    fi

    # Extract frame rate using ffprobe
    framerate=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null | bc -l)

    # Validate frame rate
    if ! is_number "$framerate"; then
        echo "Warning: Invalid frame rate for '$filename'. Skipping."
        continue
    fi

    # Extract total duration of the video
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)

    # Validate duration
    if ! is_number "$duration"; then
        echo "Warning: Invalid duration for '$filename'. Skipping."
        continue
    fi

    # Calculate trimming times based on actual frame rate
    start_trim=$(printf "%.3f" $(bc -l <<< "5 / $framerate"))
    end_trim=$(printf "%.3f" $(bc -l <<< "11 / $framerate"))

    # Calculate new duration after trimming
    new_duration=$(printf "%.3f" $(bc -l <<< "$duration - $start_trim - $end_trim"))

    # Validate new_duration
    if ! is_number "$new_duration"; then
        echo "Warning: Invalid new duration for '$filename'. Skipping."
        continue
    fi

    # Ensure new duration is positive
    if (( $(echo "$new_duration <= 0" | bc -l) )); then
        echo "Warning: Skipping '$filename' - video too short to trim."
        continue
    fi

    # Debugging output
    echo "Processing '$filename':"
    echo "  Frame rate: $framerate FPS"
    echo "  Original duration: $duration seconds"
    echo "  start_trim=$start_trim, end_trim=$end_trim, new_duration=$new_duration seconds"

    # Perform trimming with FFmpeg
    ffmpeg -i "$file" -ss "$start_trim" -t "$new_duration" -c:v copy -c:a copy "$output_file" -y 2>/dev/null

    if [[ $? -eq 0 ]]; then
        echo "Successfully trimmed '$filename' to '$output_file'"
    else
        echo "Error: Failed to trim '$filename'"
    fi
done

echo "Trimming process completed."
