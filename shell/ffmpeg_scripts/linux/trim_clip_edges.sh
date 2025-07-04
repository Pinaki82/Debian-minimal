#!/bin/bash

# Purpose:
# This script trims video clips from an input folder to remove shaky and blurry sections
# typically found at the start and end of footage captured by unsteady hands.
# It processes all video files (AVI) in the input folder, trims 5 frames from the start
# and a user-specified number of frames from the end (between 11 and 18), and saves the
# trimmed clips to an output folder using FFmpeg's copy option to avoid re-encoding.

# Usage:
# 1. Ensure FFmpeg is installed on your Debian 12 Bookworm system:
#    sudo apt-get install ffmpeg
# 2. Save this script as 'trim_clip_edges.sh' and make it executable:
#    chmod +x trim_clip_edges.sh
# 3. Run the script with input and output folder paths as arguments:
#    ./trim_clip_edges.sh '/path/to/input/folder' '/path/to/output/folder'
# 4. The script processes all AVI files in the input folder.
# 5. Output files are saved with 'trimmed_' prepended to the original filename.

# Requirements:
# - FFmpeg installed on Debian 12 Bookworm
# - Input folder containing AVI video files
# - Write permissions for the output folder

# Authorship:
# This script was written by Grok 3, created by xAI, on June 18, 2025.
# Modified by: LLAMA.CPP Model: qwen2.5-coder-3b-instruct-q4_0.gguf Build: b5819-7b63a71a Date: 2025.07.04
# Modified by: Grok 3 Date: 2025.07.04

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

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 '/path/to/input/folder' '/path/to/output/folder'"
    exit 1
fi

# Assign input and output directories
input_dir="$1"
output_dir="$2"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Check if FFmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: FFmpeg is not installed. Please install it with 'sudo apt-get install ffmpeg'."
    exit 1
fi

# Prompt the user to specify the number of frames to trim from the end with validation
while true; do
    echo "Please specify the number of frames to be trimmed from the end (integer between 11 and 18):"
    read -r end_frames
    if [[ "$end_frames" =~ ^[0-9]+$ ]] && [ "$end_frames" -ge 11 ] && [ "$end_frames" -le 18 ]; then
        break
    else
        echo "Invalid input. Please enter an integer between 11 and 18."
    fi
done

# Set the number of frames to trim from the start (hardcoded)
start_frames=5

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
    # Check if there are any AVI files
    if [[ ! -f "$file" ]]; then
        echo "No AVI files found in $input_dir"
        break
    fi

    # Extract the filename from the full path
    filename=$(basename "$file")

    # Decide the output filename based on user preference
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

    # Extract total duration of the video from the video stream
    duration=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)

    # Validate duration
    if ! is_number "$duration"; then
        echo "Warning: Invalid duration for '$filename'. Skipping."
        continue
    fi

    # Calculate trimming times based on actual frame rate
    start_trim_time=$(printf "%.3f" $(bc -l <<< "$start_frames / $framerate"))
    end_trim_time=$(printf "%.3f" $(bc -l <<< "$end_frames / $framerate"))

    # Calculate new duration after trimming
    new_duration=$(printf "%.3f" $(bc -l <<< "$duration - $start_trim_time - $end_trim_time"))

    # Validate new_duration
    if ! is_number "$new_duration"; then
        echo "Warning: Invalid new duration for '$filename'. Skipping."
        continue
    fi

    # Ensure new_duration is positive
    if (( $(echo "$new_duration <= 0" | bc -l) )); then
        echo "Warning: Skipping '$filename' - video too short to trim."
        continue
    fi

    # Debugging output
    echo "Processing '$filename':"
    echo "  Frame rate: $framerate FPS"
    echo "  Original duration: $duration seconds"
    echo "  start_trim_time=$start_trim_time, end_trim_time=$end_trim_time, new_duration=$new_duration seconds"

    # Perform trimming with FFmpeg
    ffmpeg -i "$file" -ss "$start_trim_time" -t "$new_duration" -c:v copy -c:a copy "$output_file" -y 2>/dev/null

    if [[ $? -eq 0 ]]; then
        echo "Successfully trimmed '$filename' to '$output_file'"
    else
        echo "Error: Failed to trim '$filename'"
    fi
done

echo "Trimming process completed."
