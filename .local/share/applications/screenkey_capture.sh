#!/bin/bash

# Qwen2.5-Max 3:38 pm - 2025.03.14 - https://chat.qwen.ai/
# Run the screenkey command
bash -ic "screenkey -p fixed -g \$(slop -n -f '%g') --persist -s small --font-size small; exec bash"
