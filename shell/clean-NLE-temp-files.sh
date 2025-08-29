#!/bin/bash

# Modified by kimi-k2-0711-preview from LMArena on 2025.08.29 10:16 PM.

set -euo pipefail # Exit on error, undefined variables, and pipe failures

# You can also save this as a more flexible version that accepts the numbered folder as an argument:
# Use argument if provided, otherwise use default
numberedfolder="${1:-1701440443408}"

# Define directories in an array for easier management
declare -a directories=(
    "$HOME/.cache/Meltytech/Shotcut/qmlcache"
    "$HOME/.local/share/Meltytech/Shotcut/thumbnails"
    "$HOME/.cache/kdenlive/qmlcache"
    "$HOME/.cache/kdenlive/proxy"
    "$HOME/.cache/kdenlive/$numberedfolder/audiothumbs"
    "$HOME/.cache/kdenlive/$numberedfolder/preview"
    "$HOME/.cache/kdenlive/$numberedfolder/sequences"
    "$HOME/.cache/kdenlive/$numberedfolder/videothumbs"
    "$HOME/.cache/kdenlive/$numberedfolder/workfiles"
)

# Function to clear and recreate the directory
clear_directory() {
    local dir="$1"

    if [[ -d "$dir" ]]; then
        echo "Clearing directory: $dir"
        if ! rm -rf "$dir"/* 2>/dev/null; then
            echo "Warning: Failed to clear some files in $dir" >&2
        fi
    else
        echo "Creating directory: $dir"
        if ! mkdir -p "$dir"; then
            echo "Error: Failed to create directory $dir" >&2
            return 1
        fi
    fi
}

# Main execution
echo "Starting cache cleanup..."
for dir in "${directories[@]}"; do
    clear_directory "$dir" || true  # Continue even if one directory fails
done

echo "Cache cleanup completed."

#
# Key improvements made:
#
#     Added set -euo pipefail for better error handling
#     Used $HOME instead of /home/$(whoami) which is more reliable and handles edge cases
#     Created an array to manage directories more efficiently
#     Added mkdir -p, which creates parent directories if they don't exist and doesn't fail if the directory already exists
#     Added error handling and reporting with descriptive messages
#     Used rm -rf "$dir"/* instead of removing and recreating the entire directory structure, which is safer
#     Added progress messages so you know what's happening
#     Used || true to continue execution even if one directory operation fails
#     Added proper error output to stderr with >&2
#
