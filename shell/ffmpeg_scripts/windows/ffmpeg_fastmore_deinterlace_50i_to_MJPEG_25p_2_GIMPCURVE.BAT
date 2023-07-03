@ECHO OFF
rem https://trac.ffmpeg.org/wiki/HWAccelIntro
rem -pix_fmt yuv422p10le -profile:v 3 can be added but it's slow and renders extra vibrant colours that is not what we want
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON

for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A"  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2, curves=m=0.0/0.0 0.15915915915915912/0.08203125 0.3243243243243243/0.25390625 0.4924924924924926/0.4765625 0.6486486486486487/0.671875 0.7747747747747747/0.81640625 1.0/1.0:r=0.0/0.0 1.0/1.0:g=0.0/0.0 1.0/1.0:b=0.0/0.0 1.0/1.0" -c:a pcm_s16le -r 25 "%%A.MJPEG.AVI"
cmd

