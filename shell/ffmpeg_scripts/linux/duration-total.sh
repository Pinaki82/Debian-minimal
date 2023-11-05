#!/bin/bash

# Calculate the total duration of all video files in a directory.
#
# https://askubuntu.com/questions/1056637/calculate-total-video-length-of-files-inside-a-folder
# https://unix.stackexchange.com/questions/170961/get-total-duration-of-video-files-in-a-directory

mediainfo '--Output=Video;%Duration%\n' *.* | awk '{ sum += $1 } END { secs=sum/1000; h=int(secs/3600);m=int((secs-h*3600)/60);s=int(secs-h*3600-m*60); printf("%02d:%02d:%02d\n",h,m,s) }'
