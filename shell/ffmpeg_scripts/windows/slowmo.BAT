@ECHO OFF
REM FFMPEG SLOW MOTION VIDEO
REM A crude way of transforming a 25 FPS Video into a Slow Motion Video using FFMPEG
REM For a better implementation using Python-powered AI-enabled Slow Motion Video Creator,
REM follow this link: https://www.youtube.com/watch?v=mXwXtIiOjRA
REM
REM NOTE: First, trim down the parts of the video that you don't need.
REM Otherwise, encoding will take forever to complete.
REM ffmpeg -ss 00:00:01 -to 00:00:02 -i INPUT.mp4 -vcodec copy OUTPUT.mp4
REM
REM Brave: ffmpeg slow mo
REM Brave: ffmpeg slow motion video from regular video
REM https://unix.stackexchange.com/questions/178503/ffmpeg-interpolate-frames-or-add-motion-blur
@ECHO ON

set /p filename="Type the filename with extension: "
echo filename: %filename%
set newfilename=%filename%.slowmo-x264.mp4
echo newfilename: %newfilename%
set /p FPS="Type the new FPS: "
echo FPS: %FPS%
pause

ffmpeg -i %filename% -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -an -c:v ffv1 -level 3 -threads 8 -coder 1 -context 1 -g 1 -slices 24 -slicecrc 1 -q:v 0 -crf 0 -preset ultrafast DE_Interlaced.AVI
@ECHO OFF
REM '-r 120' means 120 FPS. Set it to the desired value.
@ECHO ON
ffmpeg -i DE_Interlaced.AVI -filter:v minterpolate -r %FPS% -an -c:v ffv1 -level 3 -threads 8 -coder 1 -context 1 -g 1 -slices 24 -slicecrc 1 -q:v 0 -crf 0 -preset ultrafast SLOWEDDOWN.AVI
ffmpeg -hwaccel dxva2 -i SLOWEDDOWN.AVI -c:v libx264 -q:v 0 -preset ultrafast -crf 9 -r %FPS% %newfilename%
del DE_Interlaced.AVI
del SLOWEDDOWN.AVI
pause
