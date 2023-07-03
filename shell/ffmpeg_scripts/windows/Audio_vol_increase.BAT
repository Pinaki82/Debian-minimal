@ECHO OFF
REM Use this FFmpeg preset in cases where the sound boom of the recording device
REM was accidentally turned off and the audio was not
REM recorded at the proper volume level.

REM audio volume increase ffmpeg
REM http://breakthebit.org/post/53570840966/how-to-increase-volume-in-a-video-without
REM noise reduction ffmpeg
REM http://superuser.com/questions/733061/reduce-background-noise-and-optimize-the-speech-from-an-audio-clip-using-ffmpeg

set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;
@ECHO ON
for %%A in ("*.*") DO ffmpeg -i "%%A" -vcodec copy -c:a pcm_s16le -ar 48000 -ac 2 -ab 384k -af "highpass=f=200, lowpass=f=3000, volume=200" "_2%%A"
PAUSE
