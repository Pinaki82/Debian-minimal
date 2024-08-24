#!/bin/bash

# Start screenkey in the background with mouse clicks and keystrokes displayed
# sudo apt instal screenkey
screenkey --mouse &

# Save the screenkey process ID (PID) so we can stop it later
SCREENKEY_PID=$!

# Start ffmpeg screen recording at 10 fps
# https://rmauro.dev/how-to-record-video-and-audio-with-ffmpeg-a-minimalist-approach/
ffmpeg -f x11grab -r 10 -i :0.0 -codec:v libx264 -pix_fmt yuv420p recording.mkv

# After ffmpeg finishes, stop the screenkey process
kill $SCREENKEY_PID

echo "Recording complete. screenkey and ffmpeg processes have been stopped."

