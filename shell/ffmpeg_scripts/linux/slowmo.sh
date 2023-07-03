#!/bin/bash


# FFMPEG SLOW MOTION VIDEO
# A crude way of transforming a 25 FPS Video into a Slow Motion Video using FFMPEG
# For a better implementation using Python-powered AI-enabled Slow Motion Video Creator,
# follow this link: https://www.youtube.com/watch?v=mXwXtIiOjRA
#
# NOTE: First, trim down the parts of the video that you don't need.
# Otherwise, encoding will take forever to complete.
# ffmpeg -ss 00:00:01 -to 00:00:02 -i INPUT.mp4 -vcodec copy OUTPUT.mp4
#
######################################
## USAGE:
# chmod +x slowmo.sh
# ./slowmo.sh INPUT.MTS 120
# 120 is the new FPS.
######################################
#
# Brave: ffmpeg slow mo
# Brave: ffmpeg slow motion video from regular video
# https://unix.stackexchange.com/questions/178503/ffmpeg-interpolate-frames-or-add-motion-blur

# ===================================================================

echo "Type the filename with extension: (Press TAB to autocomplete.) $1"
filename=$1
echo filename: $filename

echo "Type the new framerate in FPS $2"
fps=$2
echo FPS: $fps

sleep 3

# ----------------------------------------------------------------
# Concatenate Stings in Shell Scripts
# https://stackoverflow.com/questions/4181703/how-to-concatenate-string-variables-in-bash#4181721
# ----------------------------------------------------------------
convrtd_file_s_extnsn='.mp4'
newfilename="${filename}${convrtd_file_s_extnsn}"
echo newfilename: $newfilename

ffmpeg -i $filename -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -an -c:v ffv1 -level 3 -threads 8 -coder 1 -context 1 -g 1 -slices 24 -slicecrc 1 -q:v 0 -crf 0 -preset ultrafast DE_Interlaced.AVI
# ===================================================================
ffmpeg -i DE_Interlaced.AVI -filter:v minterpolate -r $fps -an -c:v ffv1 -level 3 -threads 8 -coder 1 -context 1 -g 1 -slices 24 -slicecrc 1 -q:v 0 -crf 0 -preset ultrafast SLOWEDDOWN.AVI
ffmpeg -i SLOWEDDOWN.AVI -c:v libx264 -q:v 0 -preset ultrafast -crf 9 -r $fps $newfilename

rm DE_Interlaced.AVI
rm SLOWEDDOWN.AVI
