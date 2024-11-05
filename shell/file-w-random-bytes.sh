#!/bin/bash

# DDG: Create a binary file containing random bytes in Linux (to be used as key files, or for test programs (C/C++/Rust) to test their file loading capabilities).

# https://unix.stackexchange.com/questions/33629/how-can-i-populate-a-file-with-random-data
# Q: How can I create a new file and fill it with 1 Gigabyte worth of random data?
# I need this to test some software.
# https://stackoverflow.com/questions/1462893/generating-a-random-binary-file
# Q: Generating a random binary file

# 1024*1024*(Size in MB)
# 300 MB --> 1024*1024*300
# dd if=/dev/urandom of=target-file bs=314572800 count=1 iflag=fullblock

# gpt-4o-mini-2024-07-18
# Hello! The code below creates a file of 300MB containing random files.
# Could you please turn it into a bash script that asks the user to submit a filename and the size of the resulting file?

# ```bash
#   dd if=/dev/urandom of=target-file bs=314572800 count=1 iflag=fullblock
# ```

# Certainly! Below is a Bash script that prompts the user for a filename and the desired size of the resulting file. The script then uses the dd command to create that file with random data.

# Prompt the user for a filename
read -p "Enter the filename (including path if needed): " filename

# Prompt the user for the size of the file in MB
read -p "Enter the size of the file in MB: " size_mb

# Calculate the block size in bytes
size_bytes=$((size_mb * 1024 * 1024))

# Create the file with the specified size using dd
dd if=/dev/urandom of="$filename" bs="$size_bytes" count=1 iflag=fullblock

echo "File '$filename' of size ${size_mb}MB created."

#  ### How to Use the Script
# 1. **Create the Script File**:
#    - Open your terminal.
#    - Use a text editor (like `nano`, `vim`, or `gedit`) to create a new script file. For example:
#      ```bash
#      nano create_random_file.sh
#      ```

# 2. **Copy and Paste the Script**:
#    - Copy the script above and paste it into your text editor.

# 3. **Make the Script Executable**:
#    - Save the file and exit the text editor.
#    - Run the following command to make the script executable:
#      ```bash
#      chmod +x create_random_file.sh
#      ```

# 4. **Run the Script**:
#    - Execute the script by running:
#      ```bash
#      ./create_random_file.sh
#      ```

# 5. **Follow the Prompts**:
#    - Enter the desired filename and size when prompted.

# ### Notes:
# - The script calculates the size in bytes based on the MB input, and the `dd` command is used to generate the file using random data from `/dev/urandom`.
# - Ensure you have sufficient disk space for the file you want to create.
