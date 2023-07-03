@ECHO OFF
REM De-interlace option can be disabled by deleting the line that contains:
REM -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" ^
REM '-an' will disable audio in the output.
@ECHO ON

for %%A in ("*.*") DO ffmpeg -hwaccel dxva2 -i "%%A" ^
  -filter:v "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" ^
  -aspect 16:9 -s hd1080 -r 50000/2000 -q:v 4 -q:a 5 ^
  -c:a libmp3lame -ar 48000 -ab 128k -ac 2 ^
  -c:v libxvid -crf 0 -preset ultrafast ^
  -vtag DIVX -g 2 ^
  "%%A.avi"
PAUSE
