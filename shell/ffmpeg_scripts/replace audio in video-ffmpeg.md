# ffmpeg - replace audio in video

https://superuser.com/questions/1137612/ffmpeg-replace-audio-in-video#1137613

> You will want to copy the video stream without re-encoding to save a lot of time but re-encoding the audio might help to prevent incompatibilities:

```bash
ffmpeg -i v.mp4 -i a.wav -c:v copy -map 0:v:0 -map 1:a:0 new.mp4
```

`-map 0:v:0` maps the first (index 0) video stream from the input to the first (index 0) video stream in the output.

`-map 1:a:0` maps the second (index 1) audio stream from the input to the first (index 0) audio stream in the output.

If the audio is longer than the video, you will want to add `-shortest` before the output file name.

Not specifying an audio codec, will automatically select a working one. You can specify one by for example adding `-c:a libvorbis` after `-c:v copy`. You can also use `-c copy` to avoid re-encoding the audio, but this has lead to compatibility and synchronization problems in my past.

--qubodup
