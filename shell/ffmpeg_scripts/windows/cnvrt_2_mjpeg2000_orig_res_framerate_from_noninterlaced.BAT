@ECHO OFF
rem https://trac.ffmpeg.org/wiki/HWAccelIntro
rem -pix_fmt yuv422p10le -profile:v 3 can be added but it's slow and renders extra vibrant colours that is not what we want
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;

rem https://ffmpeg-user.ffmpeg.narkive.com/Y49599n7/can-you-encode-lossless-motion-jpeg-2000-videos-with-ffmpeg-using-the-right-command-line-arguments
rem ffmpeg -i input.MTS -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2" -q:v 0 -crf 0 -preset ultrafast -c:v libopenjpeg -strict experimental -c:a pcm_s16le lossless_out.MOV

rem SIZE: 00005.MTS -> 22.5 MB. MJPEG -> 35.9 MB (x1.596 larger). MJPEG200 -> 218.3 MB (x9.702 larger).

rem Converted to MJPEG using the command: ffmpeg -i 00005.MTS  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:a pcm_s16le 00005.MJPEG.AVI

@ECHO ON

for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -q:v 0 -crf 0 -preset ultrafast -c:v libopenjpeg -strict experimental -c:a pcm_s16le "%%A.JP2K.AVI"
cmd

