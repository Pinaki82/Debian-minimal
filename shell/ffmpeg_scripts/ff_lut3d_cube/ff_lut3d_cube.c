#!/usr/bin/c -Wall -Wextra -pedantic --
// Last Change: 2023-11-28  Tuesday: 02:25:23 AM

/*
  Inspired by
  https://youtu.be/c2WNFjKL1fo?si=UdGXKs2O6o9c4HK8
  and
  https://gist.github.com/jordanwesthoff/86d202e0104d3583c4d4
*/

/*
  Apply LUT3d (in *.cube extension) to an input video from a custom LUT file & convert the input using the MJPEG codec in the QuickTime MOV container.

   Usage:
   Linux: chmod +x ff_lut3d_cube.c
   ./ff_lut3d_cube.c <input_video> <lut_file>
   MS-Windows:
   Compile with the command: gcc -Wall -Wextra -pedantic -o2 ff_lut3d_cube.c -o ff_lut3d_cube.exe -s
   ff_lut3d_cube.exe <input_video> <lut_file>

   Example: ./ff_lut3d_cube.c 000XY.MTS /path/to/lut_file.cube
*/

/*
  Create custom LUT files:
  Creating LUT with GMIC in Krita Gimp Kdenlive | cgvirus
  https://youtu.be/c2WNFjKL1fo?si=UdGXKs2O6o9c4HK8
*/

// Linux: Uncomment line 1 and compile it. gcc -Wall -Wextra -pedantic ff_lut3d_cube.c -o ff_lut3d_cube
// MS-Win: gcc -Wall -Wextra -pedantic ff_lut3d_cube.c -o ff_lut3d_cube.exe

// https://stackoverflow.com/questions/5468326/popen-implicitly-declared-even-though-include-stdio-h-is-added
#define _POSIX_C_SOURCE 200809L  // Define this before any includes
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define FFMPEG_STATIC_BUILD_LATEST_PATH "/home/appu/PortablePrograms/ffmpeg-git-amd64-static/ffmpeg"
#define FFPLAY_STATIC_BUILD_LATEST_PATH "/usr/bin/ffplay"
// Download FFMPEG from https://ffmpeg.org/download.html or https://johnvansickle.com/ffmpeg/

#define MAXPATHLEN 512
#define MAXCMDBUFFSIZE 4096
#define THE_WORD_INTERLACED  20
#define FRAMERATE_STR_LEN  10
#define OUTPUT_VID_NAME_PLUS_EXT_LEN  20
#define STORE_TH_WORD_INTERLACED_OR_NONINTERLACED 11

// Structure for playback/conversion
struct CmdCnvrt {
  char play_0[15]; // Specify the size of the array
  char play_1[5];
  char mjpegInterlacedCnvrt_0[116];
  char mjpegInterlacedCnvrt_1[23];
  char mjpegNonInterlacedCnvrt_0[65];
  char mjpegNonInterlacedCnvrt_1[23];
};

// Initialize the variables
struct CmdCnvrt cmdCnvrt = {
  " -vf lut3d=\'",
  "\'",
  " -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v \"yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2,lut3d=\'",
  "\'\" -c:a pcm_s16le -r ",
  " -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v \"lut3d=\'",
  "\'\" -c:a pcm_s16le -r "
};

void scantype(char *inputVido, int *interlacedOrNot);
void framerate(char *inputVido, float *frameRate);
void playback(char *inputVido, char *lut_file);
void cnvrt_to_mjpeg_w_lut3d_cube(char *inputVido, char *lut_file);

void scantype(char *inputVido, int *interlacedOrNot) {
  // Ref: https://video.stackexchange.com/questions/12980/how-to-see-if-a-video-file-is-progressive-or-interlaced
  // Pass the command "mediainfo --Inform='Video;%ScanType%' <input_video>" to the machine's terminal and check whether the output is "Interlaced".
  char command[MAXCMDBUFFSIZE] = "";
  sprintf(command, "%s", "mediainfo --Inform='Video;%ScanType%' ");
  strcat(command, inputVido);
  //printf("command: %s\n", command);
  FILE *fp = popen(command, "r"); // https://stackoverflow.com/questions/646241/c-run-a-system-command-and-get-output
  char result_from_th_sys[THE_WORD_INTERLACED] = "";

  if(fp == NULL) {
    printf("Failed to run the command.\n");
    exit(EXIT_FAILURE);
  }

  /* Read the output by one line at a time - output it. */
  int i = 0;

  while(fgets(result_from_th_sys, sizeof(result_from_th_sys), fp) != NULL) {
    if(i >= 1) {
      break;
    }

    printf("%s", result_from_th_sys);
    i++;
  }

  /*i = 0;*/
  char str_to_compare[STORE_TH_WORD_INTERLACED_OR_NONINTERLACED] = "";
  strcpy(str_to_compare, result_from_th_sys);
  //printf("str_to_compare: %s\n", str_to_compare);
  /* close */
  pclose(fp);
  const char _interlaced_word[] = "Interlaced\n";
  const char _non_interlaced_word[] = "Progressive\n";
  //printf("_interlaced_word: %s\n", _interlaced_word);
  //printf("_non_interlaced_word: %s\n", _non_interlaced_word);
  *interlacedOrNot = -1;
  //printf("strcmp(str_to_compare, _interlaced_word): %d\n", strcmp(str_to_compare, _interlaced_word));
  //printf("strcmp(str_to_compare, _interlaced_word): %d\n", strcmp(str_to_compare, _non_interlaced_word));

  if(strcmp(str_to_compare, _interlaced_word) == 0) {
    *interlacedOrNot = 1;
  }

  else if(strcmp(str_to_compare, _non_interlaced_word) == 0) {
    *interlacedOrNot = 0;
  }

  //printf("interlacedOrNot: %d\n", *interlacedOrNot);
}

void framerate(char *inputVido, float *frameRate) {
  // Ref: https://video.stackexchange.com/questions/12980/how-to-see-if-a-video-file-is-progressive-or-interlaced
  // Pass the command "mediainfo --Inform='Video;%FrameRate%' <input_video>" to the machine's terminal and check whether the output is "Interlaced".
  char command[MAXCMDBUFFSIZE] = "";
  sprintf(command, "%s", "mediainfo --Inform='Video;%FrameRate%' ");
  strcat(command, inputVido);
  //printf("command: %s\n", command);
  FILE *fp = popen(command, "r"); // https://stackoverflow.com/questions/646241/c-run-a-system-command-and-get-output
  char result_from_th_sys[FRAMERATE_STR_LEN];

  if(fp == NULL) {
    printf("Failed to run the command.\n");
    exit(EXIT_FAILURE);
  }

  /* Read the output by one line at a time - output it. */
  int i = 0;

  while(fgets(result_from_th_sys, sizeof(result_from_th_sys), fp) != NULL) {
    if(i >= 1) {
      break;
    }

    printf("%s", result_from_th_sys);
    i++;
  }

  /*i = 0;*/
  /* close */
  pclose(fp);
  *frameRate = (float)atof(result_from_th_sys);
  //printf("frameRate: %f\n", *frameRate);
}

void playback(char *inputVido, char *lut_file) {
  char ffplay_exe[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  strcat(ffplay_exe, FFPLAY_STATIC_BUILD_LATEST_PATH);
  /*
    If the input video is interlaced, apply a specific ffmpeg video filter `-filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2"` to convert it to progressive.
    Then, apply the LUT3d file (in .cube extension) to convert it to MJPEG.
    ffmpeg -i input -vf lut3d=<lut file> -c:a copy output
    Ref: https://gist.github.com/jordanwesthoff/86d202e0104d3583c4d4

    Precisely, we will need these two commands. One is for playing back the video with the LUT file applied, and then converting the video with fine-grained settings.

    ffplay -i input  -vf lut3d='vlcsnap-2023-11-26-00h41m50s633.cube'

    ffmpeg -i input  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2,lut3d='vlcsnap-2023-11-26-00h41m50s633.cube'" -c:a pcm_s16le -r 25 output.MOV
  */
  char command[MAXCMDBUFFSIZE] = "";
  sprintf(command, "%s %s%s%s%s", ffplay_exe, inputVido, cmdCnvrt.play_0, lut_file, cmdCnvrt.play_1);
  printf("\ncommand: %s\n\n", command);
  system(command);
}

void cnvrt_to_mjpeg_w_lut3d_cube(char *inputVido, char *lut_file) {
  char ffmpeg_exe[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  strcat(ffmpeg_exe, FFMPEG_STATIC_BUILD_LATEST_PATH);
  strcat(ffmpeg_exe, " -i "); // including the -i option
  int interlacedOrNot = 0;
  float frameRate = 0;
  framerate(inputVido, &frameRate);
  /*
    If the input video is interlaced, apply a specific ffmpeg video filter `-filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2"` to convert it to progressive.
    Then, apply the LUT3d file (in .cube extension) to convert it to MJPEG.
    ffmpeg -i input -vf lut3d=<lut file> -c:a copy output
    Ref: https://gist.github.com/jordanwesthoff/86d202e0104d3583c4d4

    Precisely, we will need these two commands. One is for playing back the video with the LUT file applied, and then converting the video with fine-grained settings.

    ffplay -i input  -vf lut3d='vlcsnap-2023-11-26-00h41m50s633.cube'

    ffmpeg -i input  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2,lut3d='vlcsnap-2023-11-26-00h41m50s633.cube'" -c:a pcm_s16le -r 25 output.MOV
  */
  char outputVideo[OUTPUT_VID_NAME_PLUS_EXT_LEN] = "";
  sprintf(outputVideo, "%s.MOV", inputVido);
  char command[MAXCMDBUFFSIZE] = "";
  scantype(inputVido, &interlacedOrNot);

  if(interlacedOrNot == 1) {
    sprintf(command, "%s %s%s%s%s%f %s", ffmpeg_exe, inputVido, cmdCnvrt.mjpegInterlacedCnvrt_0, lut_file, cmdCnvrt.mjpegInterlacedCnvrt_1, frameRate, outputVideo);
    printf("\ncommand: %s\n\n", command);
    system(command);
  }

  else {
    sprintf(command, "%s %s%s%s%s%f %s", ffmpeg_exe, inputVido, cmdCnvrt.mjpegNonInterlacedCnvrt_0, lut_file, cmdCnvrt.mjpegNonInterlacedCnvrt_1, frameRate, outputVideo);
    printf("\ncommand: %s\n\n", command);
    system(command);
  }
}

int main(int argc, char *argv[]) {
  if(argc != 3) {
    fprintf(stderr, "Usage: %s <input_video> <lut3d_file_with_dot_cube_extension>\n", argv[0]);
    return EXIT_FAILURE;
  }

  int interlacedOrNot = 0; // 0 = n, 1 = yes (interlaced)
  scantype(argv[1], &interlacedOrNot);

  if(interlacedOrNot == 1) {
    printf("Interlaced video detected.\n");
  }

  else if(interlacedOrNot == 0) {
    printf("Non-Interlaced video detected.\n");
  }

  playback(argv[1], argv[2]);
  char yesOrNo = '\0';
  printf("\nDo you want to convert the video using the LUT file? (y/n): ");
  scanf("%c", &yesOrNo);
  printf("\n\n");

  if(yesOrNo != 'n' && yesOrNo != 'N') {
    cnvrt_to_mjpeg_w_lut3d_cube(argv[1], argv[2]);
    printf("Done!\n");
  }

  else {
    printf("Exiting without proceeding with the conversion.\n");
  }

  return EXIT_SUCCESS;
}


