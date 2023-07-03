@ECHO OFF
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
REM You can use the -t option instead of the -to option to specify the range. For example, for 45 seconds: 00:03:05 + 45 = 00:03:50REM https://stackoverflow.com/questions/9913032/how-can-i-extract-audio-from-video-with-ffmpeg
@ECHO ON
for %%A in ("*.*") DO ffmpeg -i "%%A" -ss 00:32:13 -to 00:35:46 -vn -ar 48000 -ac 2 -ab 320k -f mp3 "%%A.mp3"
PAUSE
