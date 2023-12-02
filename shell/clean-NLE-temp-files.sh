#!/bin/bash

numberedfolder='1701440443408'

rm -rf /home/$(whoami)/.cache/Meltytech/Shotcut/qmlcache && \
mkdir /home/$(whoami)/.cache/Meltytech/Shotcut/qmlcache && \
rm -rf /home/$(whoami)/.cache/kdenlive/qmlcache && \
mkdir /home/$(whoami)/.cache/kdenlive/qmlcache && \
rm -rf /home/$(whoami)/.cache/kdenlive/proxy && \
mkdir /home/$(whoami)/.cache/kdenlive/proxy && \
rm -rf /home/$(whoami)/.cache/kdenlive/$numberedfolder/audiothumbs && \
mkdir /home/$(whoami)/.cache/kdenlive/$numberedfolder/audiothumbs && \
rm -rf /home/$(whoami)/.cache/kdenlive/$numberedfolder/preview/ && \
mkdir /home/$(whoami)/.cache/kdenlive/$numberedfolder/preview/ && \
rm -rf /home/$(whoami)/.cache/kdenlive/$numberedfolder/sequences/ && \
mkdir /home/$(whoami)/.cache/kdenlive/$numberedfolder/sequences/ && \
rm -rf /home/$(whoami)/.cache/kdenlive/$numberedfolder/videothumbs/ && \
mkdir /home/$(whoami)/.cache/kdenlive/$numberedfolder/videothumbs/ && \
rm -rf /home/$(whoami)/.cache/kdenlive/$numberedfolder/workfiles/ && \
mkdir /home/$(whoami)/.cache/kdenlive/$numberedfolder/workfiles/ \
