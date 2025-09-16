# Best Quality OGV:

>  SuperUser_dot_com: How do I convert MP4 to OGV while still retaining the same quality using FFMPEG?

http://superuser.com/questions/1096841/ddg#1096865

https://superuser.com/questions/1096841/how-do-i-convert-mp4-to-ogv-while-still-retaining-the-same-quality-using-ffmpeg#1096865

> Basic command is

```bash
ffmpeg -i input.mov -c:v libtheora -q:v 10 -c:a libvorbis -q:a 5 output.ogv
```

> You'll have to fiddle with the q values for video and audio if the result's not acceptable. Lower values are better but produce bigger files. For libtheora, it's the opposite - higher values are better. Range is 0-10.
> 
> --Gyan
