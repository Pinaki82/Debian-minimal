#!/bin/bash

# Generate video thumbnails from a folder and print them on A4 sheets.

# https://theserveradmin.com/generate-thumbnails-for-all-videos-inside-folder-with-ffmpeg/
# for f in *.mp4; do ffmpeg -i "$f" -ss 00:01:00 -vframes 1 "${f%.mp4}.jpg"; done

# for f in *.mp4 -> In the folder look for all files with a mp4 extension.
# do ffmpeg -i “$f -> Look over those mp4 files and then.
# -ss 00:01:00 -vframes 1 -> Grab the frame at the 1 Minute Mark.
# ${f%.mp4}.jpg” -> Grab this from every file, and then name the new file matching the old file, but change the mp4 to jpg.

# AI Assistant: https://codeium.com/live/general
# mkdir -p thumbs && for f in *.*; do ffmpeg -i "$f" -ss 00:00:01 -vframes 1 "thumbs/${f%.*}.jpg"; done

# 1. If the video is exactly **1 second long**, create the thumbnail at the **1-second mark (00:00:01)**.
# 2. If the video is **2 seconds or shorter**, create the thumbnail at the **1-second mark (00:00:01)**.
# 3. If the video is **3 seconds or shorter**, create the thumbnail at the **2-second mark (00:00:02)**.
# 4. If the video is **5 seconds or shorter**, create the thumbnail at the **3-second mark (00:00:03)**.
# 5. If the video is **longer than 5 seconds**, create the thumbnail at **40% of the total video duration**.

# https://lmarena.ai/
# chatgpt-4o-latest-20241120

# Get the name of the folder where the video files are located
folder_name=$(basename "$PWD")
echo "Processing files in folder: $folder_name"

# basename "$PWD" gets the name of the current directory where the script is being run.
# The folder name is stored in the folder_name variable, allowing you to use it for logging, naming files, or other purposes in the script.

# Create the "thumbs" directory if it doesn't exist
mkdir -p thumbs

# Loop through all files in the current directory
for f in *.*; do
  # Get the video duration in seconds using ffprobe
  duration=$(ffprobe -i "$f" -show_entries format=duration -v quiet -of csv="p=0")

  # Round the duration to an integer
  duration=${duration%.*}

  # Determine the timestamp based on the rules
  if [ "$duration" -eq 1 ]; then
    timestamp="00:00:01"
  elif [ "$duration" -le 2 ]; then
    timestamp="00:00:01"
  elif [ "$duration" -le 3 ]; then
    timestamp="00:00:02"
  elif [ "$duration" -le 5 ]; then
    timestamp="00:00:03"
  else
    # Calculate 40% of the video duration
    timestamp=$(awk "BEGIN { printf \"%.2f\", $duration * 0.4 }")
    # Convert the timestamp to HH:MM:SS format
    timestamp=$(date -ud "@$timestamp" +%H:%M:%S)
  fi

  # Use ffmpeg to generate the thumbnail
  ffmpeg -i "$f" -ss "$timestamp" -vframes 1 "thumbs/${f%.*}.jpg"
done

# Explanation:

#     ffprobe to Get Duration:
#         The script uses ffprobe to extract the duration of the video in seconds.
#         The duration is then rounded to an integer for easier comparison.

#     Rules Implementation:
#         The script checks the video's duration against your specified rules (if, elif conditions) to determine the correct timestamp for the thumbnail.

#     40% Calculation:
#         If the video duration is more than 5 seconds, it calculates 40% of the total duration using awk.

#     Converting to HH:MM:SS:
#         The result of the 40% calculation (in seconds) is converted to HH:MM:SS format using date.

#     Generate Thumbnail:
#         Finally, ffmpeg is used to extract the frame at the calculated timestamp and save it as a .jpg in the thumbs directory.

cd thumbs && \

# https://lmarena.ai/
# chatgpt-4o-latest-20241120

mkdir -p annotated && \

for img in *.jpg; do
    convert "$img" -font FreeSans -gravity South -fill black -stroke white -strokewidth 5 -pointsize 90 -annotate +0+10 "$(basename "$img")" "annotated/$img"
    # -fill yellow -stroke blue -strokewidth 3 -pointsize 24
done

# Explanation of Options

#      convert is an ImageMagick command.
#     -gravity South places the text at the bottom.
#     -pointsize 20 sets the font size.
#     -annotate +0+10 adjusts the position of the text (tweak as needed).
#      basename "$img" extracts the filename without the path.

#     -fill: Specifies the text color (e.g., white in this case).
#     -stroke: Specifies the stroke color (e.g., black in this case).
#     -strokewidth: Specifies the thickness of the stroke (e.g., 2 pixels in this case).
#     -gravity South: Places the text at the bottom of the image.
#     -annotate +0+10: Adjusts the position of the text relative to its placement (in this case, 10 pixels above the bottom).

# Use pdfjam on the annotated images:
cd annotated && \
pdfjam --no-twoside --nup 4x9 --offset '1.50cm 0cm' --suffix 'offset' --a4paper *.jpg -o ${folder_name}.pdf
# --no-twoside for spiral binding and keeping in Folio Expanding File Folder Document Organisers, --twoside for bookbinding or similar arrangements
mv *.pdf ../../
cd ../
# Requirement: trash-cli
trash annotated
cd ../
