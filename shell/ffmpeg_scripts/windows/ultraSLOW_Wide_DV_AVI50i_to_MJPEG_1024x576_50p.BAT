@ECHO OFF
rem https://trac.ffmpeg.org/wiki/HWAccelIntro
rem -pix_fmt yuv422p10le -profile:v 3 can be added but it's slow and renders extra vibrant colours that is not what we want
rem  How to do good deinterlacing with mencoder ?
rem http://forum.doom9.org/archive/index.php/t-163989.html
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON

for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A"  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=1:-1:0, mcdeint=0:0:20" -s 1024x576 -aspect 16:9 -c:a pcm_s16le "%%A.AVI"
cmd

