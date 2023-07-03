#!/bin/bash

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories and quality level (lower=better):
inputfolder="/media/sf_ffmpeg_linux_tst"
outputfolder="/media/sf_ffmpeg_linux_tst"
codecoption=mpeg2video
audiocodec=mp2
audiosamplerate=48000
audiochannel=2
audiobitrate=384k
videoquality=0
constantratefactor=0 #The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible. A lower value generally leads to higher quality, and a subjectively sane range is 17–28.
SPEED=ultrafast #superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# https://superuser.com/questions/714804/converting-video-from-1080p-to-720p-with-smallest-quality-loss-using-ffmpeg
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared
videobitrate=15M
videobitrate_min=15M
videobitrate_max=15M
conversion_buffer_size=10M
gop_size=1
b_frames=1

for inputfile in "$inputfolder"/*.* ; do
    outputfile="$outputfolder/$(basename "${inputfile%}").AVI"
    ffmpeg -i "$inputfile" -c:v $codecoption -c:a $audiocodec -ar $audiosamplerate \
    -ac $audiochannel -ab $audiobitrate \
    -q:v $videoquality -preset $SPEED -crf $constantratefactor \
	-filter:v "unsharp=3:3:-0.7:3:3:-0.7, yadif=0:-1:1, hqdn3d=1.5:1.5:6:6, scale=trunc(iw/2)*2:trunc(ih/2)*2, unsharp=3:3:0.2:3:3:0.2" \
	-vb $videobitrate -minrate $videobitrate_min \
	-maxrate $videobitrate_max -bufsize $conversion_buffer_size \
	-g $gop_size -bf $b_frames \
    "$outputfile"
done
