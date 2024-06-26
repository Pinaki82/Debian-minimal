@ECHO OFF
rem alternative filter for better (but very slow) conversion
rem -filter:v "yadif=1:-1:0, mcdeint=0:0:20, framestep=2, hqdn3d=1.5:1.5:6:6, scale=trunc(iw/2)*2:trunc(ih/2)*2"
REM https://www.macxdvd.com/mac-dvd-video-converter-how-to/ffmpeg-avi-to-mp4-free.htm
REM https://superuser.com/questions/1556953/why-does-preset-veryfast-in-ffmpeg-generate-the-most-compressed-file-compared
REM Preset Options:
REM ultrafast
REM superfast
REM veryfast
REM fast
REM medium
REM slow
REM slower
REM veryslow
REM 'veryslow' results in better compression and smaller file size, thus, the
REM produced files may be of compromised (slightly) quality.
REM It also requires more CPU time to encode. The converted files are often
REM hard to deal with when used in NLE timelines as stock footage.

REM Whereas, 'ultrafast' produces much bigger converted files, but the generated
REM files are usually of better quality due to less compression.

REM Slow results in high compression. Similarly, '-crf 0' means lossless,
REM hence, it produces bigger files. '-crf 26' means high compression, so the
REM converted files take less disc space, and the quality of the highly
REM compressed files are generally a little worse. The reasonable range is
REM -crf 16 to 18, -preset superfast to fast.

REM Initially, I chose -crf 0 (lossless) and -preset fast (visually near-lossless). The resulting
REM files are easier to deal with when used in NLE timelines as
REM stock footage. The good thing is, the produced files are not too big to keep.
REM However, in my current settings, I set '-crf' to '16' and '-preset' to
REM 'fast' because stock footage files are something you would like to store
REM permanently. And those files eats away chunks of storage space.
REM A good balance between file size and no noticeable loss in quality
REM is '-crf 16 -preset fast'. It's acceptable in case you want to keep a
REM file for later use as stock footage. Save your drive space, put less stress
REM on the CPU, and save encoding time.

set path="C:\Program Files\ffmpeg-20160522-git-566be4f-win64-shared\bin"; %path%;

@ECHO ON

set /p filename="Type the filename with extension: "
echo filename: %filename%
set newfilename=%filename%.-480p.mp4
echo newfilename: %newfilename%

ffmpeg -hwaccel dxva2 -i %filename% -c:v libx264 -q:v 0 -preset medium -crf 22 -profile:v main -level:v 3.1 -s 854x480 -r 25 %newfilename%

PAUSE

