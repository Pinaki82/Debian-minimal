REM https://stackoverflow.com/questions/3937387/rotating-videos-with-ffmpeg
REM ffmpeg -i in.mov -vf "transpose=1" out.mov

REM 0 = 90CounterCLockwise and Vertical Flip (default)
REM 1 = 90Clockwise
REM 2 = 90CounterClockwise
REM 3 = 90Clockwise and Vertical Flip

ffmpeg -i VID_20190807_175227.mp4 -vf "transpose=3" out.mp4
ffmpeg -i VID_20190807_180236.mp4 -vf "transpose=3" out2.mp4
ffmpeg -i VID_20190807_181526.mp4 -vf "transpose=3" out3.mp4