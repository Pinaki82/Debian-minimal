#!/bin/bash

latex cnvrt.tex && \
dvisvgm --no-fonts cnvrt.dvi cnvrt.svg && \

rm *.aux *.dvi *.log \

