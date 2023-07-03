@ECHO OFF
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON

for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -q:v 0 -crf 0 -preset ultrafast -c:v mjpeg -c:a copy -s 854x480 -aspect 16:9 "%%A.YOU.AVI"
cmd
