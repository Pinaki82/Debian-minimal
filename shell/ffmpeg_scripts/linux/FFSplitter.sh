#!/bin/bash

ffmpeg -ss 00:00:00 -to 00:36:00 -i final.mp4 -vcodec copy -acodec copy final_p1.mp4
ffmpeg -ss 00:35:30 -i final.mp4 -vcodec copy -acodec copy final_p2.mp4
