@ECHO OFF
rem alternative filter for better (but very slow) conversion
rem -filter:v "yadif=1:-1:0, mcdeint=0:0:20, framestep=2, hqdn3d=1.5:1.5:6:6, scale=trunc(iw/2)*2:trunc(ih/2)*2"
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON
for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -c:v mjpeg -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -pix_fmt yuvj420p -aspect 16:9 -s hd720 -r 50000/2000 "%%A.MJPEG.AVI"
pause
