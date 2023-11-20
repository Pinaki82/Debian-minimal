#!/bin/bash

# https://video.stackexchange.com/questions/19590/convert-mp4-to-webm-without-quality-loss-with-ffmpeg
# ffmpeg  -i input.mp4  -b:v 0  -crf 30  -pass 1  -an -f webm -y /dev/null
# ffmpeg  -i input.mp4  -b:v 0  -crf 30  -pass 2  output.webm

# If you're using Microsoft Windows™ instead of UNIX, change /dev/null to NUL.

# (Not tested on Windows)
# ffmpeg  -i input.mp4  -b:v 0  -crf 30  -pass 1  -an -f webm -f null -
# ffmpeg  -i input.mp4  -b:v 0  -crf 30  -pass 2  output.webm
# -an -> no audio.

echo "Type the filename with extension: (Press TAB to autocomplete.) $1"
filename=$1
echo filename: $filename
# ----------------------------------------------------------------
# Concatenate Stings in Shell Scripts
# https://stackoverflow.com/questions/4181703/how-to-concatenate-string-variables-in-bash#4181721
# ----------------------------------------------------------------
convrtd_file_s_extnsn='.webm'
echo convrtd_file_s_extnsn: ${convrtd_file_s_extnsn}
intermediate_file_s_extnsn='.AVI'
intermediate_filename="${filename}${intermediate_file_s_extnsn}"
echo intermediate_filename: ${intermediate_filename}
convrtd_filename="${intermediate_filename}${convrtd_file_s_extnsn}"
echo convrtd_filename $convrtd_filename

#ffmpeg -i $filename -c:a copy -c:v ffv1 -level 3 -threads 8 -coder 1 -context 1 -g 1 -slices 24 -slicecrc 1 -q:v 0 -crf 0  $intermediate_filename
# OR (with the deinterlace filter):
ffmpeg -i $filename -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:a copy -c:v ffv1 -level 3 -threads 8 -coder 1 -context 1 -g 1 -slices 24 -slicecrc 1 -q:v 0 -crf 0  $intermediate_filename

# ===================================================================

# DEFAULT OPTION: ffmpeg -i $intermediate_filename  -b:v 0  -crf 30  -pass 1 -f webm -y /dev/null
ffmpeg -i $intermediate_filename  -b:v 0  -crf 30  -pass 1 -f webm -y /dev/null
# The second pass: ffmpeg  -i $intermediate_filename -b:v 0  -crf 30  -pass 2  $convrtd_filename
ffmpeg -i $intermediate_filename -b:v 0  -crf 30  -pass 2 $convrtd_filename

rm ffmpeg2pass-0.log

rm $intermediate_filename

