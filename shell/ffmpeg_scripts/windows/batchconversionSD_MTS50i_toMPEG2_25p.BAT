@ECHO OFF
rem https://trac.ffmpeg.org/wiki/HWAccelIntro
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON
for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -acodec mp2 -ar 48000 -ac 2 -ab 384k -q:v 0 -crf 0 -preset ultrafast -filter:v "unsharp=3:3:-0.7:3:3:-0.7, yadif=0:-1:1, hqdn3d=1.5:1.5:6:6, scale=trunc(iw/2)*2:trunc(ih/2)*2, unsharp=3:3:0.2:3:3:0.2" -vcodec mpeg2video -preset fast -vb 15M -minrate 15M -maxrate 15M -bufsize 10M -g 1 -bf 1 "%%A.mpg"
pause
