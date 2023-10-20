#!/bin/bash

# Create a montage of one photo on a 4x6-inch canvas

image_file="$1"
output_file="$2"

montage \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
"${image_file}" \
-tile 3x4 \
-geometry '+2+2' \
-resize 893x1663 \
"${output_file}"
