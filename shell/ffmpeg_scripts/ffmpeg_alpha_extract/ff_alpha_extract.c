#!/usr/bin/c -Wall -Wextra -pedantic --

// Last Change: 2023-11-16  Thursday: 10:12:50 PM

/*
  --------------------------------------------------------------------------------
*/

/*
  Refer to: https://github.com/ryanmjacobs/c
*/

/*
  c: Use C as a shell scripting language:
  https://github.com/ryanmjacobs/c
*/

/*
  Installation (*-ubuntu)/Debian:
  sudo apt install build-essential
  sudo apt install trash-cli
  cd ~/
  wget https://raw.githubusercontent.com/ryanmjacobs/c/master/c
  sudo install -m 755 c /usr/bin/c
  trash c
*/

/*
  --------------------------------------------------------------------------------
*/

/*
  Usage:
  chmod +x ff_alpha_extract.c
  ./ff_alpha_extract.c <input_video>
*/

// or (on MS Windows), gcc -Wall -Wextra -pedantic -o2 ff_alpha_extract.c -o ff_alpha_extract.c -s

/*
  Refrerences (FFMPEG):
  https://superuser.com/questions/1092015/want-to-extract-out-only-alpha-using-ffmpeg
  ffmpeg -i input.avi  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -vf alphaextract,format=yuv420p output-alpha.mov
  ffmpeg -i input.avi  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -c:a pcm_s16le output.mov
  https://stackoverflow.com/questions/61834623/how-to-use-ffmpeg-colorspace-options
  https://trac.ffmpeg.org/wiki/colorspace
*/

/*
   --------------------------------------------------------------------------------
   Extract Alpha Channel and Generate Optimized Motion-JPEG Video
   
  BluffTitler (https://www.outerspace-software.com/blufftitler), a
  Windows-only animation software, can be launched from a
  guest Windows VM to render animations with premultiplied alpha channels
  in AVI containers which are often heavy on the disk.
  While exporting to a PNG sequence might be
  possible in some cases, it might not always be feasible.
  Other animation programs on Linux/Windows can also render animations
  with premultiplied alpha channels in AVI/MOV containers of
  similar file sizes.

   This script addresses this challenge by extracting the premultiplied
  alpha channel from the input video file and generating two separate
  output videos:
   
    1. A grayscale output video containing the alpha channel information
    2. A Motion-JPEG output video discarding the alpha channel,
      significantly reducing disk space and enabling smooth playback
   
   These two separate videos can then be imported into a non-linear video
  editing program to reconstruct the original video with transparency.
   
   The script is compatible with Linux/Unix environments. For MS Windows,
  comment out the line ` #!/usr/bin/c -Wall -Wextra -pedantic -- ` and
  compile with gcc:
   
   gcc -Wall -Wextra -pedantic -o2 ff_alpha_extract.c -o ff_alpha_extract.c -s
   --------------------------------------------------------------------------------
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FFMPEG_STATIC_BUILD_LATEST_PATH "/home/appu/PortablePrograms/ffmpeg-git-amd64-static/ffmpeg"
// Download FFMPEG from https://ffmpeg.org/download.html or https://johnvansickle.com/ffmpeg/

#define MAXPATHLEN 512
#define MAXBUFFSIZE 8092
#define MAX_OUTPUT_VIDEO_FILE_NAME_LENGHT 7056
#define MAX_EXTENSION_LEN 30

void alphamask(char *input_video, char *output_alpha_mask_video);
void opaque(char *input_video, char *output_video);

void alphamask(char *input_video, char *output_alpha_mask_video) {
  char command[MAXBUFFSIZE];
  char ffmpeg_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  strcat(ffmpeg_exec, FFMPEG_STATIC_BUILD_LATEST_PATH);
  //.mov will be appended to the input video name and the output will be produced in the QuickTime .mov container.
  /* ffmpeg -i input.avi -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -vf alphaextract,format=yuv420p output-alpha.mov */
  sprintf(command, "%s -i %s -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -vf alphaextract,format=yuv420p %s", ffmpeg_exec, input_video, output_alpha_mask_video);
  system(command);
}

void opaque(char *input_video, char *output_video) {
  char command[MAXBUFFSIZE];
  char ffmpeg_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  strcat(ffmpeg_exec, FFMPEG_STATIC_BUILD_LATEST_PATH);
  //.mov will be appended to the input video name and the output will be produced in the QuickTime .mov container.
  /* ffmpeg -i input.avi -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -preset placebo -qp 0 -pix_fmt yuv444p10le -sws_flags spline+accurate_rnd+full_chroma_int -vf "colorspace=bt709:iall=bt601-6-625:fast=1" -color_range 1 -colorspace 1 -color_primaries 1 -color_trc 1 -c:a pcm_s16le output-alpha.mov */
  sprintf(command, "%s -i %s -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -preset placebo -qp 0 -pix_fmt yuvj444p -sws_flags spline+accurate_rnd+full_chroma_int -vf \"colorspace=bt709:iall=bt601-6-625:fast=1\" -color_range 1 -colorspace 1 -color_primaries 1 -color_trc 1 -c:a pcm_s16le %s", ffmpeg_exec, input_video, output_video);
  system(command);
}

int main(int argc, char *argv[]) {
  if(argc != 2) {
    fprintf(stderr, "Usage: %s <input_video>\n", argv[0]);
    return 1;
  }

  char *input_video = argv[1];
  char output_alpha_mask_video[MAX_OUTPUT_VIDEO_FILE_NAME_LENGHT];
  char output_video[MAX_OUTPUT_VIDEO_FILE_NAME_LENGHT];
  strcpy(output_alpha_mask_video, input_video);
  strcat(output_alpha_mask_video, "-alphaM.mjpeg.mov");
  strcpy(output_video, input_video);
  strcat(output_video, ".mjpeg.mov");
  alphamask(input_video, output_alpha_mask_video);
  opaque(input_video, output_video);
  return 0;
}

