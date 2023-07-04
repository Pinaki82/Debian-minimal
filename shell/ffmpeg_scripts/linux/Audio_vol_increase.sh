#!/bin/bash

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories and quality level (lower=better):
inputfolder="/media/sf_ffmpeg_linux_tst"
outputfolder="/media/sf_ffmpeg_linux_tst"
audiocodec=pcm_s16le
audiosamplerate=48000
audiochannel=2
audiobitrate=384k

for inputfile in "$inputfolder"/*.* -hwaccel ; do
    outputfile="$outputfolder/$(basename "${inputfile%}")._2${inputfile%}"
    ffmpeg -i "$inputfile" -vcodec copy -c:a $audiocodec -ar $audiosamplerate \
    -ac $audiochannel -ab $audiobitrate \
    -af "highpass=f=200, lowpass=f=3000, volume=200" \
    "$outputfile"
done
