#!/bin/bash

# A script to compare multiple versions of a text document using `diff`.
#
# Usage: ./compare_versions.sh version1.txt version2.txt version3.txt version4.txt version5.txt ...
#
# The script will compare each version with every other version and output the differences.
# The script assumes that the files are in the same directory where the script is being run.

# AUTHORSHIP: Google Gemini 2.5 Flash. 2025/June/29.

# Check if at least two files are provided as arguments.
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <file1> <file2> [file3] [file4] ..."
    exit 1
fi

echo "Comparing text document versions:"
echo "---------------------------------"

# Get the list of all files passed as arguments.
files=("$@")
num_files=${#files[@]}

# Loop through the files to compare each one with every other one.
for ((i = 0; i < num_files; i++)); do
    for ((j = i + 1; j < num_files; j++)); do
        file1="${files[i]}"
        file2="${files[j]}"

        # Check if the files exist.
        if [ ! -f "$file1" ]; then
            echo "Error: File not found: $file1"
            continue
        fi
        if [ ! -f "$file2" ]; then
            echo "Error: File not found: $file2"
            continue
        fi

        echo "Comparing '$file1' and '$file2'..."

        # Use `diff` to show the differences.
        # -u: output in unified diff format (more readable)
        diff -u "$file1" "$file2"

        # Check if `diff` found any differences.
        if [ $? -eq 0 ]; then
            echo "No differences found between '$file1' and '$file2'."
        fi
        echo "---------------------------------"
    done
done

echo "Comparison complete."
