#!/bin/bash

# https://askubuntu.com/questions/584688/how-can-i-get-the-monitor-resolution-using-the-command-line

xdpyinfo  | grep -oP 'dimensions:\s+\K\S+' && \
sleep 60 \
