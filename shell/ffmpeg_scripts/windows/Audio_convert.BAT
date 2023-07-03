@ECHO OFF
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON
for %%A in ("*.*") DO ffmpeg -i "%%A" -vn -ar 48000 -ac 2 -ab 320k -f mp3 "%%A.mp3"
PAUSE
