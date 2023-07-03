#!/bin/bash


# https://linuxhint.com/install_tesseract_ocr_linux/
# https://linuxhint.com/install-tesseract-ocr-linux/

# installation:

# sudo apt install tesseract-ocr && \
# sudo apt install imagemagick \

# language pack installation:

# For Bengali
# sudo apt install tesseract-ocr-ben

# For Hindi
# sudo apt install tesseract-ocr-hin

# get a hint of all supported languages
# apt-cache search tesseract-

# usage:
# tesseract image_name.jpg image_name output -l eng
# tesseract dcr240.jpg dcr240 output -l eng

# extract texts from all image files in a directory
for i in *; do tesseract "$i" "output-$i" -l eng; done;

