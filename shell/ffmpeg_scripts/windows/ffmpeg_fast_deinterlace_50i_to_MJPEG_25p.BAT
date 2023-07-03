@ECHO OFF
rem https://trac.ffmpeg.org/wiki/HWAccelIntro
rem -pix_fmt yuv422p10le -profile:v 3 can be added but it's slow and renders extra vibrant colours that is not what we want
rem this preset generates some extra blending which looks smooth in motion
rem but looks blended when paused
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON

for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A"  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "unsharp=3:3:-0.7:3:3:-0.7, yadif=0:-1:1, hqdn3d=1.5:1.5:6:6, scale=trunc(iw/2)*2:trunc(ih/2)*2, unsharp=3:3:0.2:3:3:0.2" -c:a pcm_s16le -r 25 "%%A.AVI"
cmd

