#!/bin/bash
# kimi-k2-0711-preview. 2025.08.29 02:07 AM. LMArena.
# convert_all.sh – batch-shrink every video in the current folder

# ---------- user-tweakable knobs ----------
VIDEO_QUALITY=23          # lower = better / bigger
SPEED=slow                # ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow
CONSTANT_RATE_FACTOR=22   # CRF for libx264
FRAMERATE_RATIO=25         # change to 24000/1001, 30000/1001, etc. if you need
# -----------------------------------------

shopt -s nullglob nocaseglob   # "*.MP4" and "*.mp4" are the same

for input in *.{mp4,mkv,mov,avi,mts,m2ts,wmv,flv,webm}; do
    [ -e "$input" ] || continue                       # no files of this type

    base="${input%.*}"                                # strip last extension
    output="${base}-480p.mp4"

    # Skip if the target already exists
    [[ -f $output ]] && { echo "Skip: $output exists"; continue; }

    echo "Converting $input  ->  $output"

    ffmpeg -hide_banner -loglevel error -stats \
        -i "$input" \
        -c:v libx264 -profile:v main -level 3.1 \
        -preset "$SPEED" -crf "$CONSTANT_RATE_FACTOR" \
        -vf scale=854:480 -r "$FRAMERATE_RATIO" \
        -c:a aac -b:a 128k \
        "$output"
done

echo "All done."
