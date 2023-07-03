@ECHO OFF
rem https://trac.ffmpeg.org/wiki/HWAccelIntro
rem -noautorotate
rem http://stackoverflow.com/questions/3937387/rotating-videos-with-ffmpeg
rem http://stackoverflow.com/questions/9408542/video-captured-from-iphone-gets-rotated-when-converted-to-mp4-using-ffmpeg
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON

for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -noautorotate -i "%%A"  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:0, hqdn3d=1.5:1.5:6:6, scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:a pcm_s16le -r 25 "%%A.AVI"
cmd

