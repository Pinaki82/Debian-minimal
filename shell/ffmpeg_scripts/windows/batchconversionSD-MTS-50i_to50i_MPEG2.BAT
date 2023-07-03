@ECHO OFF
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON
for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" -acodec mp2 -ar 48000 -ac 2 -ab 384k -q:v 0 -crf 0 -preset ultrafast -filter:v "fieldorder=bff" -vcodec mpeg2video -preset fast -vb 19M -minrate 19M -maxrate 19M -bufsize 11M -g 1 -bf 0 -flags +ilme+ildct "%%A.mpg"
pause

