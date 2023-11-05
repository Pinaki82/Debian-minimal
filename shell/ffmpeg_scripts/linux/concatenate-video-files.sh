#!/bin/bash

# Combine all MJPEG+pcm_s16le encoded video files found in a folder.
# The script works best with MJPEG+pcm_s16le encoded video files.
# USAGE:
# chmod +x concatenate-video-files.sh
# ./concatenate-video-files.sh output
# The file name of the generated output will be 'output.AVI'
#
# A general command to convert interlaced video files recorded in MTS format to MJPEG+pcm_s16le encoded AVI files.
# ffmpeg -i input.MTS  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:a pcm_s16le -r 25 output.MJPEG.AVI
# For converting non-interlaced DSLR video files you should skip the de-interlace filter option -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2".
# ffmpeg -i input.MOV  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -c:a pcm_s16le -r 25 output.MJPEG.AVI

echo "Type the output filename (without extension): $1"
filename=$1
echo filename: $filename

ffmpeg -f concat -safe 0 -i <(for f in ./*.AVI; do echo "file '$PWD/$f'"; done) -c copy $filename.AVI
