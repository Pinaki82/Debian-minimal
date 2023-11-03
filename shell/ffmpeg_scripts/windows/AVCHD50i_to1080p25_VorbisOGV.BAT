@echo OFF
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;

REM Change the quality level (lower=better).
REM For libtheora, it's the opposite - higher values are better. Range is 0-10.

REM  https://www.s-config.com/video-transcoding-ffmpeg/
REM  https://superuser.com/questions/1096841/how-do-i-convert-mp4-to-ogv-while-still-retaining-the-same-quality-using-ffmpeg
REM  ffmpeg -i input.MTS -preset ultrafast -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -codec:v libtheora -qscale:v 5 -codec:a libvorbis -qscale:a 3 output.ogv
REM  Avg. speed on a 4th-Gen Dual Core Intel Pentium Gold G3240 @ 3.10GHz (H81M-WW): x0.27 [audioquality=4, videoquality=6], and x0.29 [audioquality=3, videoquality=5]

REM  SPEED=ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow
REM  https://superuser.com/questions/714804/converting-video-from-1080p-to-720p-with-smallest-quality-loss-using-ffmpeg
REM  https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
REM  https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared
@echo ON

for %%A in ("*.*") DO ffmpeg -i "%%A" -preset ultrafast -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" -codec:v libtheora -qscale:v 5 -codec:a libvorbis -qscale:a 3 -aspect 16:9 -s hd1080 -r 50000/2000 "%%A.ogv"
PAUSE
