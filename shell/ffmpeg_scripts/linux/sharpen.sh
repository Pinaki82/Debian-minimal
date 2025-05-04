#!/bin/bash

###############################################################################
# Video Sharpening Script with Contrast Adaptive Sharpening (CAS) Option
# Created by DeepSeek Chat (AI Assistant) on 2025.05.04
#
# Features:
# - Multiple sharpening methods (Standard Unsharp or Advanced CAS)
# - Optional noise reduction
# - Interactive preview before final processing
# - Quality-preserving encoding settings
#
# Requirements:
# - FFmpeg v4.3+ (for CAS support)
# - ffplay (for preview)
# - bc (for floating-point math)
###############################################################################

# Check for required dependencies
for cmd in ffmpeg ffplay bc; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "ERROR: $cmd not found. Please install it first."
        exit 1
    fi
done

# Verify input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input_video.mp4"
    exit 1
fi

# File name handling
input_file="$1"
output_file="${input_file%.*}_sharpened.${input_file##*.}"
preview_file="preview_${input_file}"

# Cleanup function to remove preview file
cleanup() {
    [ -f "$preview_file" ] && rm -f "$preview_file"
}
trap cleanup EXIT

###############################################################################
# USER INPUT SECTION
###############################################################################

# Sharpening method selection
echo -e "\nSelect sharpening method:"
echo "1) Standard Unsharp (faster, more basic)"
echo "2) Contrast Adaptive (CAS - better quality, preserves edges)"
read -p "Choose (1/2): " method_choice

# Common parameters
read -p "Enter sharpening strength (0.1-2.0, typical 0.3-1.0): " sharpen_strength
read -p "Enable noise reduction? (y/n, recommended for noisy sources): " denoise
read -p "Preview duration in seconds (5-30): " preview_duration

###############################################################################
# INPUT VALIDATION
###############################################################################

# Validate sharpening strength
if ! [[ "$sharpen_strength" =~ ^[0-9]+(\.[0-9]+)?$ ]] || \
   (( $(echo "$sharpen_strength < 0.1" | bc -l) )) || \
   (( $(echo "$sharpen_strength > 2" | bc -l) )); then
    echo "Invalid strength. Using default 0.5."
    sharpen_strength=0.5
fi

# Validate preview duration
if ! [[ "$preview_duration" =~ ^[0-9]+$ ]] || \
   [ "$preview_duration" -lt 5 ] || \
   [ "$preview_duration" -gt 30 ]; then
    preview_duration=10
fi

###############################################################################
# FILTER CHAIN CONSTRUCTION
###############################################################################

filter_chain=""

# Add denoising if enabled (hqdn3d is a high quality denoiser)
if [[ "$denoise" =~ ^[Yy] ]]; then
    filter_chain+="hqdn3d=4:3:6:4,"  # luma_spatial:chroma_spatial:luma_tmp:chroma_tmp
fi

# Select sharpening method
case "$method_choice" in
    1)
        # Standard unsharp masking
        # Parameters: lx:ly:la:cx:cy:ca
        filter_chain+="unsharp=5:5:${sharpen_strength}:5:5:0.0"
        method_name="unsharp"
        ;;
    2)
        # Contrast Adaptive Sharpening (CAS)
        # Automatically adapts to local contrast
        # Note: Requires FFmpeg with 'cas' filter (v4.3+)
        filter_chain+="cas=${sharpen_strength}"
        method_name="CAS"
        ;;
    *)
        echo "Invalid choice. Using CAS method."
        filter_chain+="cas=0.5"
        method_name="CAS"
        ;;
esac

###############################################################################
# PREVIEW GENERATION
###############################################################################

echo -e "\nProcessing preview with:"
echo "- Method: $method_name"
echo "- Strength: $sharpen_strength"
echo "- Denoising: ${denoise:-no}"
echo "- Duration: ${preview_duration}s"

# Generate preview from middle of video (where content is usually representative)
    # -c:v libx264 -preset fast -crf 18 \ Fast encoding for preview
ffmpeg -y -ss 00:01:00 -i "$input_file" -t "$preview_duration" \
    -vf "$filter_chain" \
    -c:v libx264 -preset fast -crf 18 \
    -c:a copy \
    "$preview_file" 2>/dev/null

# Check if preview was generated (especially important for CAS)
if [ ! -f "$preview_file" ]; then
    echo "Error: Preview not generated. Possible reasons:"
    echo "1) Your FFmpeg lacks CAS support (requires v4.3+)"
    echo "2) Invalid filter parameters"
    echo "Try method 1 (unsharp) or update FFmpeg."
    exit 1
fi

###############################################################################
# PREVIEW PLAYBACK
###############################################################################

ffplay -window_title "Preview - $method_name @ ${sharpen_strength} - Press Q to continue" \
    "$preview_file" 2>/dev/null

###############################################################################
# FINAL PROCESSING
###############################################################################

        # -c:v libx264 -preset slower -crf 18 -x264-params ref=6 \  # Quality settings
        # -movflags +faststart \  # For web compatibility
        # -c:a copy \  # Copy audio without re-encoding

read -p "Proceed with full processing? (y/n): " proceed
if [[ "$proceed" =~ ^[Yy] ]]; then
    echo -e "\nProcessing full video (this may take a while)..."
    
    # Final encode with quality settings
    ffmpeg -i "$input_file" \
        -vf "$filter_chain" \
        -c:v libx264 -preset slower -crf 18 -x264-params ref=6 \
        -movflags +faststart \
        -c:a copy \
        "$output_file"

    if [ $? -eq 0 ]; then
        echo -e "\nSuccess! Output saved to: $output_file"
        echo "Final settings:"
        echo "- Method: $method_name"
        echo "- Strength: $sharpen_strength"
        echo "- Denoising: ${denoise:-no}"
    else
        echo "Error processing video"
    fi
else
    echo "Processing cancelled"
fi
