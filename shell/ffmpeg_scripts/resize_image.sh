#!/bin/bash

# Set the target dimensions
TARGET_WIDTH=1920
TARGET_HEIGHT=1080

# Prompt the user for the input image file
read -p "Enter the path to the input image file: (Copy the file from the file manager and paste it into the console by pressing CTRL+SHIFT+v.)" INPUT_IMAGE

# Check if the input file exists
if [ ! -f "$INPUT_IMAGE" ]; then
    echo "Error: File '$INPUT_IMAGE' not found."
    exit 1
fi

# Determine the output file name
OUTPUT_IMAGE="${INPUT_IMAGE%.*}_resized.${INPUT_IMAGE##*.}"

# Resize the image
convert "$INPUT_IMAGE" -resize "${TARGET_WIDTH}x${TARGET_HEIGHT}!" "$OUTPUT_IMAGE"

echo "Image resized successfully. The output file is: $OUTPUT_IMAGE"

# Assistant
# By
# Poe
# @poe
# General-purpose assistant bot.
# OFFICIAL
# This bot is powered by Anthropic. Learn more

# Could you please give me a bash script that upscales any image to a specific dimension without maintaining the aspect of the original image? I need the resulting image in a specific dimension, so the aspect ratio has to be overridden.

# Here's how the script works:

# The script starts by setting the target dimensions for the output image. You can modify these values (TARGET_WIDTH and TARGET_HEIGHT) to your desired dimensions.
# The script prompts the user to enter the path to the input image file.
# It checks if the input file exists, and exits with an error message if it doesn't.
# The output file name is determined by appending "_resized" to the original file name, keeping the same file extension.
# The magick command from ImageMagick is used to resize the image to the target dimensions, with the ! modifier to ignore the original aspect ratio.
# Finally, the script prints a message indicating the successful resizing and the output file path.
