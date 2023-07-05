#!/bin/bash

# DuckDuckGo Tor: gui frontends of tesseract
# https://tesseract-ocr.github.io/tessdoc/User-Projects-%E2%80%93-3rdParty.html
# gImageReader
# https://github.com/manisandro/gImageReader

# installation:

# install dependencies
sudo apt install tesseract-ocr -y && \
# get a hint of all supported languages
# apt-cache search tesseract-
sudo apt install tesseract-ocr-eng -y && \
sudo apt install tesseract-ocr-enm -y && \
sudo apt install tesseract-ocr-osd -y && \

# install support for additional languages

# sudo apt install tesseract-ocr-ben -y && \
# sudo apt install tesseract-ocr-script-beng -y && \
# sudo apt install tesseract-ocr-hin -y && \
# sudo apt install tesseract-ocr-script-deva -y && \

# install gImageReader
# sudo apt search gimagereader

sudo apt install gimagereader \

# MS Windows:
# Chocolatey: choco install -y gimagereader
# https://github.com/manisandro/gImageReader/releases

