@ECHO OFF
SET PATH="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin";%PATH%;
REM You can use the -t option instead of the -to option to specify the range. For example, for 45 seconds: 00:03:05 + 45 = 00:03:50
@ECHO ON
ffmpeg -ss 00:00:00 -to 00:36:00 -i final.mp4 -vcodec copy -acodec copy final_p1.mp4
ffmpeg -ss 00:35:30 -i final.mp4 -vcodec copy -acodec copy final_p2.mp4
CMD
