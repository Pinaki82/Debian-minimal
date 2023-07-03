#!/bin/bash

# Color Grading with Photoshop Curve Preset (*.acv) files
# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories and quality level (lower=better):
inputfolder="/media/sf_ffmpeg_linux_tst"
outputfolder="/media/sf_ffmpeg_linux_tst"
codecoption=mjpeg
audiocodec=pcm_s16le
audiosamplerate=48000
audiochannel=2
audiobitrate=384k
videoquality=0
constantratefactor=0 #The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible. A lower value generally leads to higher quality, and a subjectively sane range is 17–28.
framerateconversionratio_at_output=25
SPEED=ultrafast #superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# https://superuser.com/questions/714804/converting-video-from-1080p-to-720p-with-smallest-quality-loss-using-ffmpeg
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared

for inputfile in "$inputfolder"/*.* ; do
    outputfile="$outputfolder/$(basename "${inputfile%}").AVI"
    ffmpeg -i "$inputfile" -c:v $codecoption -c:a $audiocodec -ar $audiosamplerate \
    -ac $audiochannel -ab $audiobitrate \
    -q:v $videoquality -preset $SPEED -crf $constantratefactor \
	-filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2, curves=m=0.0/0.0 0.15915915915915912/0.08203125 0.3243243243243243/0.25390625 0.4924924924924926/0.4765625 0.6486486486486487/0.671875 0.7747747747747747/0.81640625 1.0/1.0:r=0.0/0.0 1.0/1.0:g=0.0/0.0 1.0/1.0:b=0.0/0.0 1.0/1.0" \
    -r $framerateconversionratio_at_output "$outputfile"
done
