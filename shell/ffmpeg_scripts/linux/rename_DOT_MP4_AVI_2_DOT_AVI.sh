#!/bin/bash

# Loop through all files with the .MTS.mp4 extension
for file in *.MP4.AVI; do
  # Check if the file exists to handle the case when no files match the pattern
  [ -e "$file" ] || continue

  # Remove the .MTS part of the extension
  newfile="${file/.MP4.AVI/.AVI}"

  # Rename the file
  mv "$file" "$newfile"
done

# ChatGPT
# 2024.06 (June).11
# Below is a Linux Bash shell script that renames all files with the extension `*.MP4.AVI` to `*.AVI` in the current directory.

# Create a script file, for example, `rename_files.sh`, with the following content:



### Explanation:
# - `#!/bin/bash`: Indicates that the script should be run in the Bash shell.
# - `for file in *.MP4.AVI; do`: Loops through all files with the `.MP4.AVI` extension.
# - `[ -e "$file" ] || continue`: Checks if the file exists. This handles the case when no files match the pattern and avoids running the loop body.
# - `newfile="${file/.MP4.AVI/.AVI}"`: Removes the `.MTS` part of the extension using parameter substitution.
# - `mv "$file" "$newfile"`: Renames the file using the `mv` command.

### Steps to execute the script:
# 1. Open a text editor and paste the script above.
# 2. Save the file as `rename_files.sh`.
# 3. Make the script executable by running:
#   ```bash
#    chmod +x rename_files.sh
#    ```
# 4. Run the script in the directory containing your files:
#    ```bash
#    ./rename_files.sh
#    ```

# This will rename all files with the `.MP4.AVI` extension to `.AVI` in the current directory.
