@ECHO OFF
REM Create Transparent RLE encoded QuickTime MOV Video files from Uncompressed
REM Transparent (with RGBA channel) AVI files.
REM \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
REM DuckDuckGo: ffmpeg qtrle
REM https://video.stackexchange.com/questions/16809/ffmpeg-overlay-rotated-video-with-transparency
REM DuckDuckGo: ffmpeg transparent mov
REM https://gist.github.com/lichuan80/ec40ded1f11e0a31327ce236a612a073
REM https://video.stackexchange.com/questions/27868/ffmpeg-transparent-background-with-showwaves-or-showspectrum
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON
for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -an -c:v qtrle -q:v 0 "%%A.RLE.mov"
pause
