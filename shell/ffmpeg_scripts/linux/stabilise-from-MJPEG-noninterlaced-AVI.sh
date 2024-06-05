#!/bin/bash


# FFMPEG Motion/Video Stabiliser
# USAGE:
# chmod +x stabilise.sh
# ./stabilise.sh 00000.MTS

# https://www.paulirish.com/2021/video-stabilization-with-ffmpeg-and-vidstab/
# https://www.marache.net/post/shake-reduction-ffmpeg.html
# The first pass ('detect') generates stabilization data and saves to `transforms.trf`
# The `-f null -` tells ffmpeg there's no output video file
rm transform_file

# ===================================================================
# Variable Name/File Name: 00000.MTS (Example)
# (Ref: https://linoxide.com/arguments-in-shell-script/)
# ===================================================================

echo "Type the filename with extension: (Press TAB to autocomplete.) $1"
filename=$1
echo filename: $filename
# ----------------------------------------------------------------
# Concatenate Stings in Shell Scripts
# https://stackoverflow.com/questions/4181703/how-to-concatenate-string-variables-in-bash#4181721
# ----------------------------------------------------------------
convrtd_file_s_extnsn='.AVI'
newfilename="${filename}${convrtd_file_s_extnsn}"
echo newfilename: $newfilename

cp $filename $newfilename

# ===================================================================

# DEFAULT OPTION: ffmpeg -i $newfilename -vf vidstabdetect -f null -
ffmpeg -i $newfilename -vf "vidstabdetect=stepsize=15:shakiness=10:accuracy=15:show=2:result=transform_file" -f null -
stabilised_vdo_extnsn='-stabilised.AVI'
stabilised_vdo="${newfilename}${stabilised_vdo_extnsn}"
echo stabilised_vdo: $stabilised_vdo
# The second pass ('transform') uses the .trf and creates the new stabilised video.

ffmpeg -i $newfilename -filter:v vidstabtransform=zoom=3.5:relative=1:smoothing=55:input="transform_file":interpol=bicubic -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset ultrafast $stabilised_vdo

# Ultra/Extra/Normal/Mild
# stepsize=15/20/25/30
# zoom=3.5/2/1/0.7 smoothing=55/35/25/20

# =========OPTIONAL======================
vstacked_vid_extnsn='-stacked.avi'
hstacked_vid_extnsn='-sxs.avi'
vstacked="${newfilename}${vstacked_vid_extnsn}"
hstacked="${newfilename}${hstacked_vid_extnsn}"
echo vstacked: $vstacked
echo hstacked: $hstacked
# vertically stacked
ffmpeg -i $newfilename -i $stabilised_vdo -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset ultrafast -filter_complex vstack $vstacked

# side-by-side
ffmpeg -i $newfilename -i $newfilename-stabilised.AVI -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset ultrafast -filter_complex hstack $hstacked

# =========OPTIONAL======================

rm transform_file
rm $newfilename

# =========(OPTIONAL) AUTO-RENAME STABILISED VIDEO======================
# =========Required: 'trash-cli'. yes | sudo apt install trash-cli =====

# trash $filename
# mv $stabilised_vdo $filename

