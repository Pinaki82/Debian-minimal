#!/bin/bash

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories and quality level (lower=better).
# For libtheora, it's the opposite - higher values are better. Range is 0-10.
#
# https://www.s-config.com/video-transcoding-ffmpeg/
# https://superuser.com/questions/1096841/how-do-i-convert-mp4-to-ogv-while-still-retaining-the-same-quality-using-ffmpeg
# ffmpeg -i input.MTS -preset ultrafast -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -codec:v libtheora -qscale:v 5 -codec:a libvorbis -qscale:a 3 output.ogv
# Avg. speed on a 4th-Gen Dual Core Intel Pentium Gold G3240 @ 3.10GHz (H81M-WW): x0.27 [audioquality=4, videoquality=6], and x0.29 [audioquality=3, videoquality=5]
#
inputfolder="/media/sf_ffmpeg_linux_tst"
outputfolder="/media/sf_ffmpeg_linux_tst"
codecoption=libtheora
audiocodec=libvorbis
audioquality=4
audiochannel=2
videoquality=6
constantratefactor=0 #The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible. A lower value generally leads to higher quality, and a subjectively sane range is 17–28.
aspectratio=16:9
dimension=hd1080
SPEED=ultrafast #superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# https://superuser.com/questions/714804/converting-video-from-1080p-to-720p-with-smallest-quality-loss-using-ffmpeg
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared
framerateconversionratio_at_output=50000/2000

for inputfile in "$inputfolder"/*.* ; do
    outputfile="$outputfolder/$(basename "${inputfile%}").ogv"
    ffmpeg -i "$inputfile" -preset $SPEED \
    -crf $constantratefactor \
    -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    -codec:v $codecoption -qscale:v $videoquality \
    -codec:a $audiocodec -qscale:a $audioquality \
    -ac $audiochannel \
    -aspect $aspectratio -s $dimension \
    -r $framerateconversionratio_at_output \
    "$outputfile"
done
