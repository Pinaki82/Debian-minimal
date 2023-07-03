#!/bin/bash

# FFMPEG Timelapse
# USAGE:
# chmod +x timelapse.sh
# ./timelapse.sh 00000.MTS

# ===================================
# Convert a long video to a timelapse
# ===================================
# 1 hour = 60 minutes. 1 minute = 60 seconds. 1 second = 25 frames.
# So, 1 hour = 3600 seconds and 3600*25=90000 frames.
# To create a 15 seconds (15*25=375 frames) 25 FPS timelapse
# from a 12 hour (12*3600*25=1080000 frames) 25 FPS CCTV footage,
# you'll have to take every 2880-th frame (1080000/375=2880) from
# the CCTV footage.
#
# https://stackoverflow.com/questions/41902160/create-time-lapse-video-from-other-video
# https://superuser.com/questions/777938/ffmpeg-convert-a-video-to-a-timelapse
# https://stackoverflow.com/questions/45462731/using-ffmpeg-to-change-framerate/45465730
#
# To take every 45th frame, use

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
convrtd_file_s_extnsn='.mp4'
newfilename="${filename}${convrtd_file_s_extnsn}"
echo newfilename: $newfilename

ffmpeg -i $filename -c:v ffv1 -level 3 -g 1 -slices 30 -slicecrc 1 -pass 1 -q:v 0 -preset ultrafast -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -an DE_Interlaced.avi
# https://trac.ffmpeg.org/wiki/Encode/FFV1
# To take every 45th frame, use
ffmpeg -i DE_Interlaced.avi -c:v ffv1 -level 3 -g 1 -slices 30 -slicecrc 1 -pass 1 -q:v 0 -preset -ultrafast -vf framestep=45,setpts=N/FRAME_RATE/TB -an TEMP_OUT.avi

# ===================================================================
# Change the output's framerate (-r 25)

ffmpeg -y -r 25 -i TEMP_OUT.avi -c:v libx264 -q:v 0 -preset ultrafast -crf 0 -an $newfilename

# Delete the temp file
rm TEMP_OUT.avi
rm DE_Interlaced.avi
