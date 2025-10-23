#!/bin/bash

# Author: DeepSeek
# Ref: https://learnbyexample.github.io/customizing-pandoc/
# NOTE: Please download this folder to a location of your choice on your computer.
#       Please place the Markdown file you want to convert into this folder.
#       Run ./pdf_from_markdown_deepseek.sh input.md output.pdf

# Required: sudo apt -y install texlive-luatex
# Install Noto Color Emoji font
# sudo apt update
# sudo apt install fonts-noto-color-emoji
# sudo apt install fonts-symbola
# Verify the font is available
# fc-list | grep -i noto.*emoji

pandoc "$1" \
    -f markdown \
    --include-in-header chapter_break.tex \
    -H bullet_style.tex \
    -H inline_code.tex \
    -V linkcolor:blue \
    -V geometry:a4paper \
    -V geometry:margin=2cm \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    -V sansfont="DejaVu Sans" \
    --toc-depth=5 \
    --pdf-engine=lualatex \
    --highlight-style=tango \
    -o "$2"
