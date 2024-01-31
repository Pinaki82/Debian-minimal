#!/bin/bash

# WEBM-VP8 (with alpha channel)
# https://stackoverflow.com/questions/34856236/convert-mov-with-alpha-to-vp9-webm-with-alpha-using-ffmpeg
# ffmpeg -i input.mov -preset ultrafast -c:v libvpx -pix_fmt yuva420p -b:v 3M -an -auto-alt-ref 0 -hide_banner -map 0:v:0 -aspect 16:9 -s hd1080 output.webm

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories
inputfolder="/media/sf_ffmpeg_linux_tst/"
outputfolder="/media/sf_ffmpeg_linux_tst/cnvrt/"
codecoption=libvpx
aspectratio=16:9
dimension=hd1080
SPEED=ultrafast #ultrafast, #superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# https://superuser.com/questions/714804/converting-video-from-1080p-to-720p-with-smallest-quality-loss-using-ffmpeg
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared


# To disable audio, use the '-an' flag.

for inputfile in "$inputfolder"/*.* ; do
    outputfile="$outputfolder/$(basename "${inputfile%}").webm"
    ffmpeg -i "$inputfile" -preset $SPEED -c:v $codecoption -pix_fmt yuva420p \
    -b:v 3M -an \
    -auto-alt-ref 0 -hide_banner -map 0:v:0 \
    -aspect $aspectratio -s $dimension \
    "$outputfile"
done


