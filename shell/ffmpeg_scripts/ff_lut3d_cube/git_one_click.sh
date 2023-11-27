#!/bin/sh

# https://stackoverflow.com/questions/18951276/echoing-date-automated-git-commit

cd /home/appu/HOME/code/ff_lut3d_cube/ && \
git add . && \
git commit -m "one-click commit: $(date)"  \
