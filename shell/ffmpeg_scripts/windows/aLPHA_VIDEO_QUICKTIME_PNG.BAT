@ECHO OFF
REM Create Transparent PNG encoded QuickTime MOV Video files from Uncompressed
REM Transparent (with RGBA channel) AVI files.
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM DuckDuckGo: ffmpeg qtrle
REM https://video.stackexchange.com/questions/16809/ffmpeg-overlay-rotated-video-with-transparency
REM DuckDuckGo: ffmpeg transparent mov
REM https://gist.github.com/lichuan80/ec40ded1f11e0a31327ce236a612a073
REM https://video.stackexchange.com/questions/27868/ffmpeg-transparent-background-with-showwaves-or-showspectrum
REM Change Output Aspect Ratio, Output Resolution, and Framerate: -aspect 16:9 -s hd1080 -r 50000/2000
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON
for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -an -c:v png -q:v 0 -filter_complex "format=rgba[v]" -map "[v]" "%%A.PNG.mov"
pause
