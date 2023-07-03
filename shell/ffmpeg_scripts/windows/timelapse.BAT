@ECHO OFF
REM ===================================
REM Convert a long video to a timelapse
REM ===================================
REM 1 hour = 60 minutes. 1 minute = 60 seconds. 1 second = 25 frames.
REM So, 1 hour = 3600 seconds and 3600*25=90000 frames.
REM To create a 15 seconds (15*25=375 frames) 25 FPS timelapse
REM from a 12 hour (12*3600*25=1080000 frames) 25 FPS CCTV footage,
REM you'll have to take every 2880-th frame (1080000/375=2880) from
REM the CCTV footage.
REM
REM https://stackoverflow.com/questions/41902160/create-time-lapse-video-from-other-video
REM https://superuser.com/questions/777938/ffmpeg-convert-a-video-to-a-timelapse
REM https://stackoverflow.com/questions/45462731/using-ffmpeg-to-change-framerate/45465730
REM
REM To take every 45th frame, use
@ECHO ON
ffmpeg -i INPUT.AVI -c:v ffv1 -level 3 -g 1 -slices 30 -slicecrc 1 -pass 1 -q:v 0 -preset ultrafast -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -an DE_Interlaced.avi
@ECHO OFF
REM https://trac.ffmpeg.org/wiki/Encode/FFV1
REM To take every 45th frame, use
@ECHO ON
ffmpeg -i DE_Interlaced.avi -c:v ffv1 -level 3 -g 1 -slices 30 -slicecrc 1 -pass 1 -q:v 0 -preset -ultrafast -vf framestep=45,setpts=N/FRAME_RATE/TB -an TEMP_OUT.avi
@ECHO OFF
REM Change the output's framerate (-r 25)
@ECHO ON
ffmpeg -y -r 25 -i TEMP_OUT.avi -c:v libx264 -q:v 0 -preset ultrafast -crf 0 -an OUTPUT.mp4
@ECHO OFF
REM Delete the temp file
@ECHO ON
del TEMP_OUT.AVI
del DE_Interlaced.avi
PAUSE
