@ECHO OFF
REM FFMPEG Motion/Video Stabiliser
REM USAGE:
REM Run and then type the filename with extension.

REM # https://www.paulirish.com/2021/video-stabilization-with-ffmpeg-and-vidstab/
REM # https://www.marache.net/post/shake-reduction-ffmpeg.html
REM # The first pass ('detect') generates stabilization data and saves to `transforms.trf`
REM # The `-f null -` tells ffmpeg there's no output video file
del transform_file

REM ===================================================================
REM Variable Name/File Name: 00000.MTS (Example)
REM (Ref: REM https://stackoverflow.com/questions/10552812/defining-and-using-a-variable-in-batch-file)

REM set filename=00000.MTS

REM ===================================================================
REM https://stackoverflow.com/questions/1223721/in-windows-cmd-how-do-i-prompt-for-user-input-and-use-the-result-in-another-com
REM User Input EXAMPLES:
REM set /p variable="Type Something: "
rem echo variable %variable%
REM echo %variable% > echoed.txt
REM ===================================================================
@ECHO ON

set /p filename="Type the filename with extension: "
echo filename: %filename%
set newfilename=%filename%.AVI
echo newfilename: %newfilename%
copy %filename% %newfilename%

@ECHO OFF
REM ===================================================================
@ECHO ON

REM DEFAULT OPTION: ffmpeg -i %newfilename% -vf vidstabdetect -f null -
ffmpeg -i %newfilename% -vf "vidstabdetect=stepsize=15:shakiness=10:accuracy=15:show=2:result=transform_file" -f null -

REM # The second pass ('transform') uses the .trf and creates the new stabilised video.

ffmpeg -i %newfilename% -filter:v vidstabtransform=zoom=3.5:relative=1:smoothing=55:input="transform_file":interpol=bicubic -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -preset ultrafast -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset fast %newfilename%-stabilised.AVI

@ECHO OFF
REM Ultra/Extra/Normal/Mild
REM stepsize=15/20/25/30
REM zoom=3.5/2/1/0.7 smoothing=55/35/25/20
@ECHO ON


@ECHO OFF
REM =========OPTIONAL======================
@ECHO ON

REM # vertically stacked
ffmpeg -i %newfilename% -i %newfilename%-stabilised.AVI -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset ultrafast -filter_complex vstack %newfilename%-stacked.avi

REM # side-by-side
ffmpeg -i %newfilename% -i %newfilename%-stabilised.AVI -c:v mjpeg -pix_fmt yuvj420p -q:v 0 -crf 0 -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -preset ultrafast -filter_complex hstack %newfilename%-sxs.avi

@ECHO OFF
REM =========OPTIONAL======================
@ECHO ON

del transform_file
del %newfilename%

PAUSE
