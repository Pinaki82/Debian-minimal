#!/bin/bash

# https://theserveradmin.com/generate-thumbnails-for-all-videos-inside-folder-with-ffmpeg/
# for f in *.mp4; do ffmpeg -i "$f" -ss 00:01:00 -vframes 1 "${f%.mp4}.jpg"; done

# for f in *.mp4 -> In the folder look for all files with a mp4 extension.
# do ffmpeg -i “$f -> Look over those mp4 files and then.
# -ss 00:01:00 -vframes 1 -> Grab the frame at the 1 Minute Mark.
# ${f%.mp4}.jpg” -> Grab this from every file, and then name the new file matching the old file, but change the mp4 to jpg.

# AI Assistant: https://codeium.com/live/general
mkdir -p thumbs && for f in *.*; do ffmpeg -i "$f" -ss 00:00:01 -vframes 1 "thumbs/${f%.*}.jpg"; done
