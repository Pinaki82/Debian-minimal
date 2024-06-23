#!/bin/bash

# Fix Action Camera Fish-Eye lens barrel distortion (GoPro etc.).
# https://stackoverflow.com/questions/30832248/is-there-a-way-to-remove-gopro-fisheye-using-ffmpeg#40659507
# ffmpeg -i input.MOV -vf 'lenscorrection=k2==0.009:k1=-0.21' output.MOV
# NOTE: This filter (lenscorrection) doesn't work on the MS Windows version of FFMPEG.

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

# https://askubuntu.com/questions/1011550/how-can-i-convert-all-video-files-in-nested-folders-batch-conversion
# Change the directories and quality level (lower=better):

# inputfolder="/media/sf_ffmpeg_linux_tst"
# outputfolder="/media/sf_ffmpeg_linux_tst"

codecoption=libx264
videoquality=0
constantratefactor=16 #The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible. A lower value generally leads to higher quality, and a subjectively sane range is 17–28.
SPEED=superfast #ultrafast, #superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# https://superuser.com/questions/714804/converting-video-from-1080p-to-720p-with-smallest-quality-loss-using-ffmpeg
# https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
# https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared

# To disable audio, use the '-an' flag.

for inputfile in "$inputfolder"/*.* ; do
    outputfile="$outputfolder/$(basename "${inputfile%}")-lens-fixed.MOV"
    ffmpeg -i "$inputfile" -vf 'lenscorrection=k2=0.009:k1=-0.21' -c:v $codecoption \
    -q:v $videoquality -preset $SPEED -crf $constantratefactor \
    "$outputfile"
done

# Loop through all files with the .MOV-lens-fixed.MOV extension
for file in *.MOV-lens-fixed.MOV; do
  # Check if the file exists to handle the case when no files match the pattern
  [ -e "$file" ] || continue

  # Remove the .MTS part of the extension
  newfile="${file/.MOV-lens-fixed.MOV/-lens-fixed.MOV}"

  # Rename the file
  mv "$file" "$newfile"
done
