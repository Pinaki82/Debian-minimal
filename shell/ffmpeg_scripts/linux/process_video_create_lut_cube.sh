#!/bin/bash

# ——— SCRIPT HEADER COMMENT ———

# Script Name: process_video_create_lut_cube.sh
# Location: Place in ~/.local/bin/ to run globally from terminal
# Usage: process_video_create_lut_cube.sh <input_video_file>
# Example: process_video_create_lut_cube.sh 00032.AVI
#
# Description:
# This script automates the workflow of extracting a middle frame from a video,
# applying automatic colour correction, prompting the user for manual refinement,
# and generating a 3D LUT (.cube) based on the original and manually adjusted images.
#
# Dependencies:
# - framegrab_middle (C program)
# - correct-color-cli.sh (Bash script)
# - two_img_lut (C program)
# - User must manually edit the “*-corrected.png” file when prompted
#
# Author: qwen3-max-preview
# Platform: LMArena
# Date: 2025.09.19
#
# 💡 Tip: Make sure ~/.local/bin is in your $PATH to run this script from anywhere.

# ——— END HEADER ———

if [ $# -ne 1 ]; then
    echo "❌ Error: Please provide exactly one video file as argument."
    echo "✔️  Usage: $0 <video_file>"
    echo "✔️  Example: $0 00032.AVI"
    exit 1
fi

VIDEO_FILE="$1"

# Validate that video file exists
if [ ! -f "$VIDEO_FILE" ]; then
    echo "❌ Error: Video file '$VIDEO_FILE' not found."
    exit 1
fi

# Extract base name (remove extension)
BASE_NAME="${VIDEO_FILE%.*}"

echo "🎬 Processing video: $VIDEO_FILE"
echo "📁 Base name: $BASE_NAME"

# Step 1: Extract middle frame
echo "🖼️  Running framegrab_middle..."
framegrab_middle "$VIDEO_FILE"

if [ ! -f "${BASE_NAME}.png" ]; then
    echo "❌ Error: ${BASE_NAME}.png was not generated."
    exit 1
fi

# Step 2: Auto-correct colors
echo "🎨 Running correct-color-cli.sh..."
correct-color-cli.sh "${BASE_NAME}.png"

if [ ! -f "${BASE_NAME}-corrected.png" ]; then
    echo "❌ Error: ${BASE_NAME}-corrected.png was not generated."
    exit 1
fi

# Step 3: Wait for manual edit
echo ""
echo "✏️  MANUAL EDIT REQUIRED"
echo "Please open and manually adjust:"
echo "    ${BASE_NAME}-corrected.png"
echo ""
echo "📌 Save your edits under the SAME FILENAME."
echo "✅ When done, return here and press ENTER to continue..."
read -p ""

# Confirm edited file still exists
if [ ! -f "${BASE_NAME}-corrected.png" ]; then
    echo "❌ Error: ${BASE_NAME}-corrected.png is missing. Did you rename or delete it?"
    exit 1
fi

# Step 4: Generate LUT
echo "📊 Generating LUT with two_img_lut..."
two_img_lut "${BASE_NAME}.png" "${BASE_NAME}-corrected.png" 33 "${BASE_NAME}.cube"

if [ $? -eq 0 ]; then
    echo "✅ Successfully created: ${BASE_NAME}.cube"
    echo "🎉 All done!"
else
    echo "❌ Failed to generate LUT file."
    exit 1
fi
