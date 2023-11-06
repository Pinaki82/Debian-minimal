#!/bin/bash

# https://ffmpeg-user.ffmpeg.narkive.com/Y49599n7/can-you-encode-lossless-motion-jpeg-2000-videos-with-ffmpeg-using-the-right-command-line-arguments
# ffmpeg -i input.MTS -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2" -q:v 0 -crf 0 -preset ultrafast -c:v libopenjpeg -strict experimental -c:a pcm_s16le lossless_out.MOV

# SIZE: 00005.MTS -> 22.5 MB. MJPEG -> 35.9 MB (x1.596 larger). MJPEG200 -> 218.3 MB (x9.702 larger).
#
# Converted to MJPEG using the command: ffmpeg -i 00005.MTS  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:a pcm_s16le 00005.MJPEG.AVI

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories and quality level (lower=better):
inputfolder="/media/sf_ffmpeg_linux_tst"
outputfolder="/media/sf_ffmpeg_linux_tst"
videoquality=0
constantratefactor=0 #The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible. A lower value generally leads to higher quality, and a subjectively sane range is 17–28.
SPEED=ultrafast #superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# https://superuser.com/questions/714804/converting-video-from-1080p-to-720p-with-smallest-quality-loss-using-ffmpeg
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared
codecoption=libopenjpeg
audiocodec=pcm_s16le

for inputfile in "$inputfolder"/*.* ; do
    outputfile="$outputfolder/$(basename "${inputfile%}").AVI"
    ffmpeg -i "$inputfile" -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    -q:v $videoquality -crf $constantratefactor -preset $SPEED \
    -c:v $codecoption -strict experimental \
    -c:a $audiocodec \
    "$outputfile"
done
