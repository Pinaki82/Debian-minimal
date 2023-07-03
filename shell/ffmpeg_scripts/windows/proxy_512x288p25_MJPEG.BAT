@ECHO OFF
rem proxy HD 16x9 MJPEG files
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON
for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -c:v mjpeg -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -q:v 4 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -pix_fmt yuvj420p -aspect 16:9 -s 512x288 -r 25 "%%A.MJPEG.AVI"
pause
