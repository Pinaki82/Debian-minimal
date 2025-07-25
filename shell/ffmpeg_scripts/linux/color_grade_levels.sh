#!/bin/bash

# --- Colour Grading Script - Part 1: Levels (MXF/MP4 Output Choice) (With Help) ---
# Uses Zenity for GUI and FFmpeg (ffplay) for processing/preview.

# Script: Colour Grading Levels Adjustment (Part 1)
# Author: Qwen3-Coder (480B parameters, 35B activated; 62 layers; 96 attention heads (Q), 8 (KV))
# https://chat.qwen.ai/
# Date: 2025-07-26
# Description: This script provides a GUI (using Zenity) to adjust video levels
#              (Input Black/White, Gamma, Output Black/White) using FFmpeg.
#              It allows real-time preview with ffplay and saving in either
#              Avid MXF (DNxHR HQX) or MP4 (H.264/AAC) format.
#              Includes user help for parameter understanding.
# Note: This script was developed iteratively based on specific user requirements
#       regarding GUI elements (sliders), FFmpeg filter usage (curves, eq),
#       preview method (ffplay), output formats (MXF/MP4), and inclusion of help.
#       Generated using Qwen3-Coder model capabilities.

# --- Configuration ---
INPUT_VIDEO=""
OUTPUT_DIR=""
OUTPUT_BASENAME=""
FFPLAY_PID="" # Store the PID of the ffplay preview process
TEMP_LOG=$(mktemp) # Create a temporary file for FFmpeg logs
OUTPUT_FORMAT=""   # Will store 'mxf' or 'mp4'

# Function to clean up temporary files on exit
cleanup() {
    rm -f "$TEMP_LOG"
    stop_preview
}
trap cleanup EXIT

# --- Functions ---

# Function to show help dialogue
show_help() {
zenity --info --title="Levels Adjustment Help" --width=600 --height=400 \
--text="<b>Levels Adjustment Parameters:</b>

These controls adjust the brightness and contrast distribution of your video.

<b>Input Black:</b>
  • Selects which input pixel value is treated as pure black.
  • Increasing it makes shadows darker, decreasing makes them lighter.
  • <i>Caution:</i> Setting it too high clips shadow detail.

<b>Input White:</b>
  • Selects which input pixel value is treated as pure white.
  • Decreasing it makes highlights darker, increasing it makes them brighter.
  • <i>Caution:</i> Setting it too low clips highlight detail.

<b>Gamma:</b>
  • Adjusts midtone brightness.
  • Values < 1.0 brighten midtones; > 1.0 darken midtones.
  • Used to correct for non-linear display characteristics or add punch.

<b>Output Black:</b>
  • Sets the darkest pixel value in the output.
  • Increasing it raises the overall brightness (lifts shadows).
  • <i>Tip:</i> Often adjusted in conjunction with Output White for contrast.

<b>Output White:</b>
  • Sets the brightest pixel value in the output.
  • Decreasing it reduces overall brightness (compresses highlights).
  • <i>Tip:</i> Often adjusted with Output Black for contrast.

<b>General Tips:</b>
  • Start with Input Black/White to set the darkest/lightest points correctly.
  • Use Gamma to adjust the midtones.
  • Adjust Output Black/White together to change the overall contrast.
  • Small adjustments often have a big impact. Preview frequently.
  • Avoid clipping (Input Black >= Input White or Output Black >= Output White)." \
--no-wrap --ellipsize
}


# Function to ask the user for the output format
get_output_format() {
    # Use zenity list with radiolist (simulate single selection)
    # Format: TRUE/FALSE <ID> <Display Text>
    CHOICE=$(zenity --list --radiolist --title="Choose Output Format" \
             --text="Select the container format for the graded video:" \
             --column="Select" --column="Format" --column="Description" \
             TRUE "mxf" "Avid MXF (High Quality, recommended for editing)" \
             FALSE "mp4" "MPEG-4 (Smaller file, common playback)" 2>/dev/null)

    if [[ $? -eq 0 && -n "$CHOICE" ]]; then
        OUTPUT_FORMAT="$CHOICE"
        echo "Selected output format: $OUTPUT_FORMAT"
        return 0
    else
        return 1 # User cancelled
    fi
}


# Function to get level adjustments using Zenity sliders
get_levels_with_sliders() {
    INPUT_BLACK=$(zenity --scale --title="Input Black" --text="Adjust Input Black Level" --min-value=0 --max-value=100 --value=0 --step=1 2>/dev/null)
    [[ $? -ne 0 ]] && return 1

    INPUT_WHITE=$(zenity --scale --title="Input White" --text="Adjust Input White Level" --min-value=0 --max-value=100 --value=100 --step=1 2>/dev/null)
    [[ $? -ne 0 ]] && return 1

    GAMMA_INT=$(zenity --scale --title="Gamma" --text="Adjust Gamma" --min-value=10 --max-value=300 --value=100 --step=5 2>/dev/null)
    [[ $? -ne 0 ]] && return 1

    OUTPUT_BLACK=$(zenity --scale --title="Output Black" --text="Adjust Output Black Level" --min-value=0 --max-value=100 --value=0 --step=1 2>/dev/null)
    [[ $? -ne 0 ]] && return 1

    OUTPUT_WHITE=$(zenity --scale --title="Output White" --text="Adjust Output White Level" --min-value=0 --max-value=100 --value=100 --step=1 2>/dev/null)
    [[ $? -ne 0 ]] && return 1

    echo "$INPUT_BLACK|$INPUT_WHITE|$GAMMA_INT|$OUTPUT_BLACK|$OUTPUT_WHITE"
}

# Function to apply levels using FFmpeg curves and eq filters
apply_levels() {
    local params="$1"
    IFS='|' read -r in_black_int in_white_int gamma_int out_black_int out_white_int <<< "$params"

    # Convert integer slider values to float for FFmpeg
    in_black=$(awk "BEGIN {print $in_black_int/100}")
    in_white=$(awk "BEGIN {print $in_white_int/100}")
    gamma=$(awk "BEGIN {print $gamma_int/100}") # Gamma 0.1 to 3.0
    out_black=$(awk "BEGIN {print $out_black_int/100}")
    out_white=$(awk "BEGIN {print $out_white_int/100}")

    # Validate Black/White levels
    if (( $(echo "$in_white <= $in_black" | bc -l) )) || (( $(echo "$out_white <= $out_black" | bc -l) )); then
        zenity --error --text="Invalid level settings: White must be greater than Black."
        return 1
    fi

    # Validate Gamma
    if (( $(echo "$gamma <= 0" | bc -l) )); then
        zenity --error --text="Gamma value must be greater than 0."
        return 1
    fi

    # --- Filter Construction ---
    CURVES_FILTER_PART="curves=master='$in_black/$out_black $in_white/$out_white'"
    EQ_FILTER_PART="eq=gamma=$gamma"
    FILTER_CHAIN="$CURVES_FILTER_PART,$EQ_FILTER_PART"

    # --- Commands ---
    # Preview command (using ffplay)
    PREVIEW_CMD="ffmpeg -v quiet -stats -y -i \"$INPUT_VIDEO\" -vf \"$FILTER_CHAIN\" -f matroska - | ffplay -autoexit -"

    # --- Output command based on chosen format ---
    OUTPUT_FILE_PATH="${OUTPUT_DIR}/${OUTPUT_BASENAME}_graded_levels.${OUTPUT_FORMAT}"

    if [[ "$OUTPUT_FORMAT" == "mxf" ]]; then
        # Avid MXF settings for high quality (uncompressed or high-quality lossless/visually lossless)
        # Option 1: Truly uncompressed (huge files) - PCM audio
        # -c:v v210 (10-bit uncompressed, specific to MXF) or copy (if source is compatible, unlikely from MJPEG)
        # -c:a pcm_s24le or pcm_s16le

        # Option 2: High-quality lossless or visually lossless (more practical)
        # DNxHD/DNxHR (Avid's professional codec)
        # Example: DNxHD 175 Mbps 1080p25 (good balance)
        # -c:v dnxhd -b:v 175M -pix_fmt yuv422p
        # Example: DNxHR HQX (resolution independent, high quality)
        # -c:v dnxhd -profile:v dnxhr_hqx -pix_fmt yuv422p10le

        # Let's use DNxHR HQX for high quality in MXF
        # Ensure source pixel format is compatible or let FFmpeg convert (yuvj420p -> yuv422p10le)
        # Using yuv422p10le for HQX is recommended [[1]]
        OUTPUT_CMD="ffmpeg -y -i \"$INPUT_VIDEO\" -vf \"$FILTER_CHAIN\" -c:v dnxhd -profile:v dnxhr_hqx -pix_fmt yuv422p10le -c:a pcm_s16le \"$OUTPUT_FILE_PATH\" 2>\"$TEMP_LOG\""

    elif [[ "$OUTPUT_FORMAT" == "mp4" ]]; then
        # MP4 settings (updated with compatible pixel format if needed)
        # libx264 is common, ensure pixel format compatibility
        # yuvj420p (source) might need to be yuv420p for x264 unless using -color_range pc
        # Let's add color_range and let ffmpeg handle pixel format conversion, typically needed
        OUTPUT_CMD="ffmpeg -y -i \"$INPUT_VIDEO\" -vf \"$FILTER_CHAIN,format=yuv420p|yuva420p\" -c:v libx264 -crf 18 -c:a aac -color_range pc \"$OUTPUT_FILE_PATH\" 2>\"$TEMP_LOG\""
        # -crf 18 is high quality, visually lossless
        # -color_range pc preserves full range if source is yuvj*
    else
        zenity --error --text "Unsupported output format selected: $OUTPUT_FORMAT"
        return 1
    fi
    return 0
}

# Function to start preview
start_preview() {
    if [[ -n "$PREVIEW_CMD" ]]; then
        stop_preview
        eval "$PREVIEW_CMD" >/dev/null 2>&1 &
        FFPLAY_PID=$!
        echo "Preview started with PID $FFPLAY_PID"
    else
        zenity --warning --text="No preview command set."
    fi
}

# Function to stop the current preview
stop_preview() {
    if [[ -n "$FFPLAY_PID" ]]; then
        kill $FFPLAY_PID 2>/dev/null
        wait $FFPLAY_PID 2>/dev/null
        FFPLAY_PID=""
        echo "Preview stopped."
    fi
}

# Function to ask user if satisfied,
ask_satisfied() {
    zenity --question --text="Preview is playing. Are you satisfied with the Level adjustments?" --ok-label="Yes, Save" --cancel-label="No, Continue Adjusting" 2>/dev/null
    return $?
}

# Function to save the output (with improved error handling)
save_output() {
    if [[ -n "$OUTPUT_CMD" ]]; then
         zenity --info --text "Saving graded video in .$OUTPUT_FORMAT format, please wait...\nCheck terminal or log if it seems stuck."
         echo "Running FFmpeg command: $OUTPUT_CMD"
         if eval "$OUTPUT_CMD"; then
             zenity --info --text="Graded video saved successfully as:\n${OUTPUT_DIR}/${OUTPUT_BASENAME}_graded_levels.${OUTPUT_FORMAT}"
             return 0
         else
             ERROR_OUTPUT=$(cat "$TEMP_LOG")
             zenity --error --text="Error occurred while saving the video:\n$ERROR_OUTPUT\n\nCheck the terminal for more details."
             echo "FFmpeg Error Log:"
             echo "$ERROR_OUTPUT"
             return 1
         fi
    else
         zenity --warning --text="No output command set."
         return 1
    fi
}

# --- Main Script Logic ---

# 1. Select Input Video
INPUT_VIDEO=$(zenity --file-selection --title="Select Input Video")
if [[ -z "$INPUT_VIDEO" ]]; then
    zenity --error --text="No input video selected. Exiting."
    exit 1
fi

# Set output directory and base name
OUTPUT_DIR=$(dirname "$INPUT_VIDEO")
OUTPUT_BASENAME=$(basename "${INPUT_VIDEO%.*}")

# 2. Select Output Format
if ! get_output_format; then
    zenity --info --text="No output format selected. Exiting."
    exit 0
fi


LEVEL_PARAMS=""
LEVELS_APPLIED=false

# 3. Show initial info with the Help option
INFO_RESPONSE=$(zenity --question --text="Starting Level Adjustments.\nUse the sliders to modify the levels.\n\nClick 'Help' for detailed information about each parameter." --ok-label="Start" --cancel-label="Help" 2>/dev/null; echo $?)

if [[ $INFO_RESPONSE -eq 1 ]]; then # User clicked 'Help' (Cancel button)
    show_help
    # Show the main info dialogue again after help
    zenity --info --text="Starting Level Adjustments.\nUse the sliders to modify the levels."
fi


while true; do
    LEVEL_PARAMS=$(get_levels_with_sliders)
    if [[ $? -eq 0 && -n "$LEVEL_PARAMS" ]]; then
        if apply_levels "$LEVEL_PARAMS"; then
            start_preview
            if ask_satisfied; then
                stop_preview
                if save_output; then
                    LEVELS_APPLIED=true
                fi
                break
            else
                stop_preview
            fi
        else
            zenity --error --text="Failed to configure level adjustments. Check parameters (e.g., White > Black, Gamma > 0)."
            stop_preview
        fi
    else
        zenity --info --text="Level adjustment cancelled."
        stop_preview
        break
    fi
done

if [[ "$LEVELS_APPLIED" == true ]]; then
    zenity --info --text="Level adjustments completed and video saved in .$OUTPUT_FORMAT format."
else
    zenity --info --text="Script finished. No video was saved from level adjustments."
fi

# Cleanup happens via trap
