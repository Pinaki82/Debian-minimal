@ECHO OFF
REM Brave: ffmpeg record a portion of the screen
REM https://stackoverflow.com/questions/6766333/capture-windows-screen-with-ffmpeg
REM Hit 'Q' to quit.
REM First, capture a screenshot of the region that you are going to record and determine the resolution of that image.
REM Adjust the X-Y offset with some trial and error.
REM It may require some fine-tuning at the last stage.
REM -------------------------
REM One of my clients demanded a preview of an edited project that he could share
REM with his senior for approval. I was trying to avoid hours of encoding.
REM I didn't need a very accurate result. Considering a slight jitter is
REM acceptable at some timecodes, I had to find a way of recording
REM from the preview window of Adobe Premiere Pro without exporting it to a
REM file from the program. It worked as expected. However, I had to
REM export the audio and sync the same with the screengrabbed output,
REM which resulted in an inaccurate Lip Synchronisation.
@ECHO ON

ffmpeg -f gdigrab -framerate pal -offset_x 961 -offset_y 105 -video_size 357x210 -show_region 1 -i desktop output.mp4
cmd
