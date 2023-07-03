#!/bin/bash

latex int01.tex && \
dvisvgm --no-fonts int01.dvi int01.svg && \

rm *.aux *.dvi *.log \

