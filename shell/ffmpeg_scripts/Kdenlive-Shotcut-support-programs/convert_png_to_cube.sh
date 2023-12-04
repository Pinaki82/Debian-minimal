#!/bin/bash

for file in *.png; do
  # Extract filename without extension
  filename="${file%.*}"

  # Convert PNG to cube using original filename
  python3 hald_to_cube.py "$file" "$filename.cube"

  # Optionally print a confirmation message
  echo "Converted $file to $filename.cube"
done

echo "All PNG files converted to CUBE files."

# Google Bard:
#
# Here's a shell script that will convert all .png files in the current directory to .cube files using hald_to_cube.py while maintaining the original filenames:
# Explanation:
#
#     #!/bin/bash: This line specifies the interpreter to be used for the script.
#     *for file in .png: This loop iterates over all files ending with .png in the current directory.
#     filename="${file%.*}": This line extracts the filename without the extension from the current loop variable $file using parameter expansion.
#     python3 hald_to_cube.py "$file" "$filename.cube": This line executes the hald_to_cube.py script with the original PNG file ($file) as input and the converted filename ($filename.cube) as output.
#     echo "Converted $file to $filename.cube": This line (optional) prints a message confirming the conversion for each file.
#     echo "All PNG files converted to CUBE files.": This line (optional) prints a final message upon completion.
#
# Usage:
#
#     Save the script as convert_png_to_cube.sh or any other desired filename.
#     Make the script executable using the command chmod +x convert_png_to_cube.sh.
#     Open a terminal and navigate to the directory containing your .png files and the script.
#     Run the script by typing ./convert_png_to_cube.sh.
#
# This will convert all your .png files to corresponding .cube files while preserving their original names.
#
# Remember to adjust the script if you want to customize the behavior, such as changing the output directory or adding error handling.
# 2023/Dec/04 09:10 AM
#
