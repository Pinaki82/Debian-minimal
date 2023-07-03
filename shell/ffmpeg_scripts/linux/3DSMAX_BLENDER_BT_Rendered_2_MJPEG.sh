#!/bin/bash

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories and quality level (lower=better):
inputfolder="/media/sf_ffmpeg_linux_tst"
outputfolder="/media/sf_ffmpeg_linux_tst"
codecoption=mjpeg
videoquality=0
constantratefactor=0 #The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible. A lower value generally leads to higher quality, and a subjectively sane range is 17–28.
SPEED=ultrafast #superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared
chromasubsampling_pixelformat=yuvj420p

for inputfile in "$inputfolder"/*.* ; do
    outputfile="$outputfolder/$(basename "${inputfile%}").AVI"
    ffmpeg -i "$inputfile" -c:v $codecoption \
    -q:v $videoquality -crf $constantratefactor -preset $encodingspeed -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    -pix_fmt $chromasubsampling_pixelformat \
    "$outputfile"
done
