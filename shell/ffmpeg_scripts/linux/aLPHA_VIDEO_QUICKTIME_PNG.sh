#!/bin/bash

# Create Transparent PNG encoded QuickTime MOV Video files from Uncompressed
# Transparent (with RGBA channel) AVI files.
# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# DuckDuckGo: ffmpeg qtrle
# https://video.stackexchange.com/questions/16809/ffmpeg-overlay-rotated-video-with-transparency
# DuckDuckGo: ffmpeg transparent mov
# https://gist.github.com/lichuan80/ec40ded1f11e0a31327ce236a612a073
# https://video.stackexchange.com/questions/27868/ffmpeg-transparent-background-with-showwaves-or-showspectrum

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion

inputfolder="/media/sf_ffmpeg_linux_tst"
outputfolder="/media/sf_ffmpeg_linux_tst"
codecoption=png
videoquality=0

# Change Output Aspect Ratio, Output Resolution, and Framerate: -aspect 16:9 -s hd1080 -r 50000/2000
# '-an' will disable audio in the output.

for inputfile in "$inputfolder"/*.* ; do
    outputfile="$outputfolder/$(basename "${inputfile%}").PNG.mov"
    ffmpeg -i "$inputfile" -an -c:v $codecoption \
    -q:v $videoquality -filter_complex "format=rgba[v]" -map "[v]" \
    "$outputfile"
done
