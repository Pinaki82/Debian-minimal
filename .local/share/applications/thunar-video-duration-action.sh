#!/bin/bash

# Anthropic Claude 3.5 Haiku

# Prerequisites:
# sudo apt install ffmpeg zenity bc
# Ensure the script works with Thunar's variable
if [ $# -eq 0 ]; then
    zenity --error --text="No files selected"
    exit 1
fi

# Create a temporary file for output
OUTPUT_FILE=$(mktemp --suffix=_video_duration.txt)

# Calculate duration
{
    echo "Video Duration Report"
    echo "===================="
    echo ""

    total_seconds_float=0

    for file in "$@"; do
        # Check if file exists
        if [ ! -f "$file" ]; then
            echo "File not found: $file"
            continue
        fi

        # Convert file extension to lowercase for matching
        ext="${file##*.}"
        ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

        # Check if extension is a video file (case-insensitive)
        if [[ ! "$ext_lower" =~ ^(mp4|avi|mkv|mov|wmv|webm)$ ]]; then
            echo "Skipping non-video file: $file"
            continue
        fi

        # Use ffprobe to get duration with high precision
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)
        
        if [ -z "$duration" ]; then
            echo "Could not read duration for: $file"
            continue
        fi

        # Convert duration to hours, minutes, seconds
        hours=$(echo "$duration / 3600" | bc)
        minutes=$(echo "($duration % 3600) / 60" | bc)
        seconds=$(echo "$duration % 60" | bc | xargs printf "%05.2f")

        # Print individual file duration
        printf "%-40s %02d:%02d:%05.2f\n" "$(basename "$file")" "$hours" "$minutes" "$seconds"

        # Accumulate total seconds
        total_seconds_float=$(echo "$total_seconds_float + $duration" | bc)
    done

    # Calculate total duration
    total_hours=$(echo "$total_seconds_float / 3600" | bc)
    total_minutes=$(echo "($total_seconds_float % 3600) / 60" | bc)
    total_seconds=$(echo "$total_seconds_float % 60" | bc | xargs printf "%05.2f")

    echo "-------------------------------------------"
    printf "Total Duration (%d files):  %02d:%02d:%05.2f\n" "$#" "$total_hours" "$total_minutes" "$total_seconds"
} > "$OUTPUT_FILE"

# Display the results in a text viewer
xdg-open "$OUTPUT_FILE"
