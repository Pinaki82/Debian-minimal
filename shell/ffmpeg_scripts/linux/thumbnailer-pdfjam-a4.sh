#!/bin/bash

# Generate video thumbnails from a folder and print them on A4 sheets.

# https://theserveradmin.com/generate-thumbnails-for-all-videos-inside-folder-with-ffmpeg/
# for f in *.mp4; do ffmpeg -i "$f" -ss 00:01:00 -vframes 1 "${f%.mp4}.jpg"; done

# for f in *.mp4 -> In the folder look for all files with a mp4 extension.
# do ffmpeg -i “$f -> Look over those mp4 files and then.
# -ss 00:01:00 -vframes 1 -> Grab the frame at the 1 Minute Mark.
# ${f%.mp4}.jpg” -> Grab this from every file, and then name the new file matching the old file, but change the mp4 to jpg.

# AI Assistant: https://codeium.com/live/general
mkdir -p thumbs && for f in *.*; do ffmpeg -i "$f" -ss 00:00:01 -vframes 1 "thumbs/${f%.*}.jpg"; done

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
pdfjam --twoside --nup 4x9 --offset '1cm 0cm' --suffix 'offset' --a4paper *.jpg
mv *.pdf ../../
cd ../
# Requirement: trash-cli
trash annotated
