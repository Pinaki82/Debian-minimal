// Last Change: 2025-09-19  Friday: 12:48:07 AM
/*
   framegrab_middle.c - Extract a representative frame from the middle of a video

   Author: DeepSeek (https://www.deepseek.com/en)
   Created on: 2025-09-19

   License: MIT-0 (No Attribution)
     Permission is hereby granted, free of charge, to any person obtaining a copy
     of this software and associated documentation files (the "Software"), to deal
     in the Software without restriction, including, without limitation, the rights
     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     copies of the Software, and to permit persons to whom the Software is
     furnished to do so.

     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     SOFTWARE.

   Description:
     This tool automatically extracts a frame from the temporal middle of a video
     file, avoiding problematic beginning and ending sections. It automatically
     detects interlaced video and applies the yadif deinterlacing filter when needed.
     The output frame is saved as a PNG file with the same base name as the input.

   Dependencies:
     - ffmpeg (for frame extraction)
     - ffprobe (for duration detection)
     - mediainfo (for interlacing detection)

   Compilation:
     gcc -Wall -Wextra -pedantic framegrab_middle.c -o framegrab_middle

   Installation:
     mkdir -p ~/.local/bin && install -m 755 framegrab_middle ~/.local/bin

   Usage:
     framegrab_middle <input_video>

   Examples:
     framegrab_middle my_video.mp4
     framegrab_middle "video with spaces.mov"
     framegrab_middle 00074.AVI

   Output:
     Creates a PNG file with the same base name as input (e.g., input_video.png)
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_CMD_LENGTH 8192

// Function to check if mediainfo output indicates interlaced video
int is_interlaced(const char *mediainfo_output) {
  // Convert to lowercase for case-insensitive search
  char lower_output[MAX_CMD_LENGTH];
  strncpy(lower_output, mediainfo_output, MAX_CMD_LENGTH);

  for(int i = 0; lower_output[i]; i++) {
    lower_output[i] = tolower(lower_output[i]);
  }

  // Look for the specific pattern "scan type.*: interlaced"
  // This matches lines like: "Scan type                                : Interlaced"
  const char *pattern = "scan type";
  const char *ptr = lower_output;

  while((ptr = strstr(ptr, pattern)) != NULL) {
    // Move pointer to the end of "scan type"
    ptr += strlen(pattern);

    // Skip any characters until we find a colon
    while(*ptr && *ptr != ':') {
      ptr++;
    }

    if(*ptr == ':') {
      // Skip the colon and any whitespace after it
      ptr++;

      while(*ptr && isspace(*ptr)) {
        ptr++;
      }

      // Now check if the next word is "interlaced"
      if(strncmp(ptr, "interlaced", 10) == 0) {
        return 1;
      }
    }
  }

  return 0;
}

int main(int argc, char *argv[]) {
  if(argc != 2) {
    fprintf(stderr, "Usage: %s <input_video>\n", argv[0]);
    return EXIT_FAILURE;
  }

  const char *input_video = argv[1];
  // Create output filename
  char output_image[MAX_CMD_LENGTH];
  strncpy(output_image, input_video, MAX_CMD_LENGTH);
  // Replace extension with .png
  char *last_dot = strrchr(output_image, '.');

  if(last_dot != NULL) {
    strcpy(last_dot, ".png");
  }

  else {
    strncat(output_image, ".png", MAX_CMD_LENGTH - strlen(output_image) - 1);
  }

  // First, get the duration of the video using ffprobe
  char duration_cmd[MAX_CMD_LENGTH];
  snprintf(duration_cmd, MAX_CMD_LENGTH,
           "ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 '%s'",
           input_video);
  FILE *fp = popen(duration_cmd, "r");

  if(fp == NULL) {
    perror("Error getting video duration");
    return EXIT_FAILURE;
  }

  float duration = 0;

  if(fscanf(fp, "%f", &duration) != 1) {
    fprintf(stderr, "Error: Could not read video duration\n");
    pclose(fp);
    return EXIT_FAILURE;
  }

  pclose(fp);

  if(duration <= 0) {
    fprintf(stderr, "Error: Invalid video duration: %.2f seconds\n", duration);
    return EXIT_FAILURE;
  }

  // Calculate middle time in seconds
  float middle_time = duration * 0.5;

  if(middle_time < 1.0) {
    middle_time = 1.0;
  }

  // Check if video is interlaced using mediainfo
  char mediainfo_cmd[MAX_CMD_LENGTH];
  snprintf(mediainfo_cmd, MAX_CMD_LENGTH,
           "mediainfo '%s'",
           input_video);
  fp = popen(mediainfo_cmd, "r");

  if(fp == NULL) {
    perror("Error checking interlacing with mediainfo");
    fprintf(stderr, "Please ensure mediainfo is installed: sudo apt install mediainfo\n");
    return EXIT_FAILURE;
  }

  char mediainfo_output[MAX_CMD_LENGTH] = {0};
  size_t bytes_read = fread(mediainfo_output, 1, MAX_CMD_LENGTH - 1, fp);
  mediainfo_output[bytes_read] = '\0';
  pclose(fp);
  int interlaced = is_interlaced(mediainfo_output);
  printf("Video analysis: %s\n", interlaced ? "INTERLACED detected" : "Progressive scan");
  // Build the FFmpeg command
  char command[MAX_CMD_LENGTH];

  if(interlaced) {
    // For interlaced video: apply yadif filter before capturing frame
    snprintf(command, MAX_CMD_LENGTH,
             "ffmpeg -ss %.2f -i '%s' -vf \"yadif=mode=0:parity=auto:deint=0,select=eq(n\\,0)\" -frames:v 1 -y '%s'",
             middle_time, input_video, output_image);
  }

  else {
    // For progressive video: simple frame capture
    snprintf(command, MAX_CMD_LENGTH,
             "ffmpeg -ss %.2f -i '%s' -vf \"select=eq(n\\,0)\" -frames:v 1 -y '%s'",
             middle_time, input_video, output_image);
  }

  printf("Video duration: %.2f seconds\n", duration);
  printf("Capturing frame at: %.2f seconds\n", middle_time);
  printf("Executing: %s\n", command);
  int return_code = system(command);

  if(return_code == -1) {
    perror("Error: system() call failed");
    return EXIT_FAILURE;
  }

  else if(return_code != 0) {
    fprintf(stderr, "FFmpeg failed with return code: %d\n", return_code);
    // Fallback: try without filters
    printf("Trying fallback approach...\n");
    snprintf(command, MAX_CMD_LENGTH,
             "ffmpeg -ss %.2f -i '%s' -frames:v 1 -y '%s'",
             middle_time, input_video, output_image);
    return_code = system(command);

    if(return_code != 0) {
      fprintf(stderr, "Fallback approach also failed.\n");
      return EXIT_FAILURE;
    }
  }

  printf("Successfully captured frame to: %s\n", output_image);
  return EXIT_SUCCESS;
}

