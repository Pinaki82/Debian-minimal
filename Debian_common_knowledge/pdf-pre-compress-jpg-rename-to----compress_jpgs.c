/*
  MS-Edge Copilot. 2025.12.2025.
  File: compress_jpgs.c
  gcc -Wall -Wextra -pedantic -o2 compress_jpgs.c -o compress_jpgs -s
  install -m 755 ~/.local/bin
  compress_jpgs
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

#define BUFFER 2048

// Adjustable settings
#define QUALITY 43 // 75, 61, 52, 43, 34, etc.
#define SAMPLE "2x1"
#define PROGRESSIVE 1   // 1 = progressive, 0 = baseline

/*
  Change #define QUALITY 61 → e.g. 75 for higher quality.
  Change #define SAMPLE "2x1" → "2x2" or "1x1" for different chroma subsampling.
  Toggle #define PROGRESSIVE 1 → 0 if you want baseline JPEG instead of progressive.
*/

int main(void) {
  const char *input_dir = ".";          // current folder
  const char *output_dir = "compressed";
  // Create output directory if it doesn't exist
  struct stat st = {0};

  if(stat(output_dir, &st) == -1) {
    if(mkdir(output_dir, 0755) != 0) {
      perror("mkdir");
      return 1;
    }
  }

  DIR *dir = opendir(input_dir);

  if(!dir) {
    perror("opendir");
    return 1;
  }

  struct dirent *entry;

  while((entry = readdir(dir)) != NULL) {
    // Only process .jpg files
    const char *name = entry->d_name;
    size_t len = strlen(name);

    if(len > 4 && (strcasecmp(name + len - 4, ".jpg") == 0)) {
      char input_path[512];
      char output_path[512];
      snprintf(input_path, sizeof(input_path), "%s/%s", input_dir, name);
      snprintf(output_path, sizeof(output_path), "%s/%s", output_dir, name);
      // Build pipeline: djpeg input | cjpeg -sample 2x1 -quality 61/52/43 -progressive > output
      // Build pipeline command dynamically
      char command[BUFFER];
      snprintf(command, sizeof(command),
               "djpeg \"%s\" | cjpeg -sample %s -quality %d %s > \"%s\"",
               input_path, SAMPLE, QUALITY,
               PROGRESSIVE ? "-progressive" : "",
               output_path);
      printf("Compressing %s -> %s\n", input_path, output_path);
      int ret = system(command);

      if(ret != 0) {
        fprintf(stderr, "Failed to process %s\n", input_path);
      }
    }
  }

  closedir(dir);
  return 0;
}

