#!/bin/bash

# alternative filter for better (but very slow) conversion
# -filter:v "yadif=1:-1:0, mcdeint=0:0:20, framestep=2, hqdn3d=1.5:1.5:6:6, scale=trunc(iw/2)*2:trunc(ih/2)*2"
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared
# Preset Options:
# ultrafast
# superfast
# veryfast
# fast
# medium
# slow
# slower
# veryslow
# 'veryslow' results in better compression and smaller file size, thus, the
# produced files may be of compromised (slightly) quality.
# It also requires more CPU time to encode. The converted files are often
# hard to deal with when used in NLE timelines as stock footage.

# Whereas, 'ultrafast' produces much bigger converted files, but the generated
# files are usually of better quality due to less compression.

# Slow results in high compression. Similarly, '-crf 0' means lossless,
# hence, it produces bigger files. '-crf 26' means high compression, so the
# converted files take less disc space, and the quality of the highly
# compressed files are generally a little worse. The reasonable range is
# -crf 16 to 18, -preset superfast to fast.

# Initially, I chose -crf 0 (lossless) and -preset fast (visually near-lossless). The resulting
# files are easier to deal with when used in NLE timelines as
# stock footage. The good thing is, the produced files are not too big to keep.
# However, in my current settings, I set '-crf' to '16' and '-preset' to
# 'fast' because stock footage files are something you would like to store
# permanently. And those files eats away chunks of storage space.
# A good balance between file size and no noticeable loss in quality
# is '-crf 16 -preset fast'. It's acceptable in case you want to keep a
# file for later use as stock footage. Save your drive space, put less stress
# on the CPU, and save encoding time.

echo "Type the filename with extension: (Press TAB to autocomplete.) $1"
filename=$1
echo filename: $filename
# ----------------------------------------------------------------
# Concatenate Stings in Shell Scripts
# https://stackoverflow.com/questions/4181703/how-to-concatenate-string-variables-in-bash#4181721
# ----------------------------------------------------------------
convrtd_file_s_extnsn='-240p.mp4'
newfilename="${filename}${convrtd_file_s_extnsn}"
echo newfilename: $newfilename

# Change the quality level (lower=better):
codecoption=libx264
videoquality=0
constantratefactor=22 #The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible. A lower value generally leads to higher quality, and a subjectively sane range is 17–28.
SPEED=slower #ultrafast, #superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# https://superuser.com/questions/712404/converting-video-from-1080p-to-720p-with-smallest-quality-loss-using-ffmpeg
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared
framerateconversionratio_at_output=25 # 50000/2000
# Profile & Level: https://superuser.com/questions/563997/how-can-i-set-a-h-264-profile-level-with-ffmpeg
# -profile:v – one of high, main, or baseline
# -level:v – as defined in Annex A of the H.264 standard, e.g., 4.0.

ffmpeg -i $filename -c:v $codecoption -profile:v main -level:v 3.1 \
    -q:v $videoquality -preset $SPEED -crf $constantratefactor -s 428x240 \
    -r $framerateconversionratio_at_output "$newfilename"

    # Loop through all files with the .MTS.mp4 extension
for file in *.mp4-240p.mp4; do
    # Check if the file exists to handle the case when no files match the pattern
    [ -e "$file" ] || continue

    # Remove the first .mp4 part of the extension
    newfile="${file/.mp4-240p.mp4/-240p.mp4}"

    # Rename the file
    mv "$file" "$newfile"
done
