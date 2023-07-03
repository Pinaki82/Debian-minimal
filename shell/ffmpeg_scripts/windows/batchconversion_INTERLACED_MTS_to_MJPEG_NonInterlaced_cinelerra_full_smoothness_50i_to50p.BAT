@ECHO OFF
rem frame drop method
rem do not use dropping and yadiff 0 with mcdeint
rem so do not use this file
rem https://trac.ffmpeg.org/wiki/HWAccelIntro
rem blur: http://randombio.com/linuxsetup141.html
rem https://trac.ffmpeg.org/wiki/HWAccelIntro
rem http://superuser.com/questions/573747/drop-every-even-or-odd-frames-using-ffmpeg
rem https://ffmpeg.org/pipermail/ffmpeg-user/2013-September/017557.html
rem framestep=2 could also be used but its slow, still jerky

set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON

for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=1:-1:1, hqdn3d=1.5:1.5:6:6, mcdeint=fast:0:1, scale=trunc(iw/2)*2:trunc(ih/2)*2, unsharp=3:3:-0.5:3:3:-0.5" -c:a pcm_s16le "%%A.AVI"
cmd

