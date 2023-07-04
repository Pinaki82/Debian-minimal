#!/bin/bash

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories and quality level (lower=better):
inputfolder="/media/sf_ffmpeg_linux_tst"
outputfolder="/media/sf_ffmpeg_linux_tst"
format=mp3
audiosamplerate=48000
audiochannel=2
audiobitrate=384k

for inputfile in "$inputfolder"/*.* -hwaccel ; do
    outputfile="$outputfolder/$(basename "${inputfile%}").mp3"
    ffmpeg -i "$inputfile" -vn -ar $audiosamplerate \
    -ac $audiochannel -ab $audiobitrate -f $format \
    "$outputfile"
done
