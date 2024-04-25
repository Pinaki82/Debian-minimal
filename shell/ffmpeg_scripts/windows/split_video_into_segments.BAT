@ECHO OFF

REM Split a lengthy video file (not more than 35 min.) into 6 segments of approximately 4 minutes
REM   59 seconds each using FFmpeg.
REM The script prompts the user to input the filename with an
REM   extension, then uses FFmpeg to split the video into
REM   segments with the same video and audio codecs as the original file.
REM Each segment is saved as a separate MOV file with a numerical
REM   suffix (e.g., input.mov, input.001.mov, input.002.mov, etc.).
REM Note: This script assumes FFmpeg is installed and the path
REM   to the FFmpeg bin directory is set.
REM
REM
REM https://trac.ffmpeg.org/wiki/HWAccelIntro
REM -pix_fmt yuv422p10le -profile:v 3 can be added but it's slow and renders extra vibrant colours that is not what we want
REM
set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON

set /p filename="Type the filename with extension: "
echo filename: %filename%

ffmpeg -i %filename% -ss 00:00:00 -to 00:04:59 -c:v copy -q:v 0 -crf 0 -preset ultrafast -c:a copy %filename%.001.mov

ffmpeg -i %filename% -ss  00:04:58 -to 00:09:57 -c:v copy -q:v 0 -crf 0 -preset ultrafast -c:a copy %filename%.002.mov

ffmpeg -i %filename% -ss  00:09:56 -to 00:14:55 -c:v copy -q:v 0 -crf 0 -preset ultrafast -c:a copy %filename%.003.mov

ffmpeg -i %filename% -ss  00:14:54 -to 00:19:53 -c:v copy -q:v 0 -crf 0 -preset ultrafast -c:a copy %filename%.004.mov

ffmpeg -i %filename% -ss  00:19:52 -to 00:24:51 -c:v copy -q:v 0 -crf 0 -preset ultrafast -c:a copy %filename%.005.mov

ffmpeg -i %filename% -ss  00:24:50 -to 00:29:49 -c:v copy -q:v 0 -crf 0 -preset ultrafast -c:a copy %filename%.006.mov

ffmpeg -i %filename% -ss  00:29:48 -to 00:34:47 -c:v copy -q:v 0 -crf 0 -preset ultrafast -c:a copy %filename%.007.mov

cmd

