#!/usr/bin/c -Wall -Wextra -pedantic --

// Last Change: 2023-11-28  Tuesday: 02:25:23 AM
// Modified on: 2025-07-26  Saturday: 11:35:55 AM,
//   By: Qwen3-Coder (480B parameters, 35B activated; 62 layers; 96 attention heads (Q), 8 (KV)),
//   https://chat.qwen.ai/

/*
  Inspired by
  https://youtu.be/c2WNFjKL1fo?si=UdGXKs2O6o9c4HK8
  and
  https://gist.github.com/jordanwesthoff/86d202e0104d3583c4d4
*/

/*
  Apply LUT3d (in *.cube extension) to an input video from a custom LUT file & convert the input using the Avid DNxHR codec in the MXF container.
   Usage:
   Linux: chmod +x ff_lut3d_cube_dnxhr_mxf.c
   ./ff_lut3d_cube_dnxhr_mxf.c <input_video> <lut_file>
   MS-Windows:
   Compile with the command: gcc -Wall -Wextra -pedantic -o2 ff_lut3d_cube_dnxhr_mxf.c -o ff_lut3d_cube_dnxhr_mxf.exe -s
   ff_lut3d_cube_dnxhr_mxf.exe <input_video> <lut_file>
   Example: ./ff_lut3d_cube_dnxhr_mxf.c 000XY.MTS /path/to/lut_file.cube
*/

/*
  Create custom LUT files:
  Creating LUT with GMIC in Krita Gimp Kdenlive | cgvirus
  https://youtu.be/c2WNFjKL1fo?si=UdGXKs2O6o9c4HK8
*/

// Linux: Uncomment line 1 and compile it. gcc -Wall -Wextra -pedantic ff_lut3d_cube_dnxhr_mxf.c -o ff_lut3d_cube_dnxhr_mxf
// MS-Win: gcc -Wall -Wextra -pedantic ff_lut3d_cube_dnxhr_mxf.c -o ff_lut3d_cube_dnxhr_mxf.exe
// https://stackoverflow.com/questions/5468326/popen-implicitly-declared-even-though-include-stdio-h-is-added

#define _POSIX_C_SOURCE 200809L  // Define this before any includes
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <sys/stat.h> // Include for stat() to check file existence

#define FFMPEG_STATIC_BUILD_LATEST_PATH "/mnt/hdd2/PortablePrograms/ffmpeg-git-amd64-static/ffmpeg"
#define FFPLAY_STATIC_BUILD_LATEST_PATH "/usr/bin/ffplay"
// Download FFMPEG from https://ffmpeg.org/download.html or https://johnvansickle.com/ffmpeg/

// Ensure your FFmpeg build includes the dnxhd encoder.
#define MAXPATHLEN 512
#define MAXCMDBUFFSIZE 4096
#define THE_WORD_INTERLACED  20
#define FRAMERATE_STR_LEN  10
#define OUTPUT_VID_NAME_PLUS_EXT_LEN  512 // Increased significantly to handle full paths + .mxf
#define STORE_TH_WORD_INTERLACED_OR_NONINTERLACED 11

// Helper function to generate a unique output filename
// Attempts to create a name like base_lut_corrected.mxf, base_lut_corrected_1.mxf, etc.
void generate_output_filename(const char *inputVido, char *outputVideo, size_t outputVideoSize) {
    char base_name[OUTPUT_VID_NAME_PLUS_EXT_LEN] = "";
    char *dot = strrchr(inputVido, '.'); // Find the last dot

    // Extract the base name (without extension)
    if (dot != NULL) {
        size_t prefix_len = dot - inputVido;
        if (prefix_len >= sizeof(base_name) - 1) { // Check for buffer overflow risk
            fprintf(stderr, "Error: Input filename too long for processing.\n");
            // Fallback name if input name is too long
            strncpy(outputVideo, "output_lut_corrected.mxf", outputVideoSize - 1);
            outputVideo[outputVideoSize - 1] = '\0';
            return;
        }
        strncpy(base_name, inputVido, prefix_len);
        base_name[prefix_len] = '\0';
    } else {
        // If no dot, use the whole name as base (ensure space)
        strncpy(base_name, inputVido, sizeof(base_name) - 1);
        base_name[sizeof(base_name) - 1] = '\0'; // Ensure null termination
    }

    // Variable for checking file existence - MUST be declared outside the loop
    struct stat buffer;
    int counter = 0;
    int result_stat;

    // Use a do-while to ensure the loop runs at least once to check the initial name
    do {
        if (counter == 0) {
            snprintf(outputVideo, outputVideoSize, "%s_lut_corrected.mxf", base_name);
        } else {
            snprintf(outputVideo, outputVideoSize, "%s_lut_corrected_%d.mxf", base_name, counter);
        }
        counter++;

        // Safety check to prevent (almost) infinite loop (highly unlikely, but good practice)
        if (counter > 10000) {
             fprintf(stderr, "Error: Could not generate a unique filename after many attempts.\n");
             // Final fallback
             snprintf(outputVideo, outputVideoSize, "output_lut_corrected_final.mxf");
             // Check this last resort name, but don't loop again
             result_stat = stat(outputVideo, &buffer);
             if (result_stat == 0) {
                // Even the final fallback exists, append timestamp or similar might be needed,
                // but for now, just overwrite the check result to exit loop.
                // A real robust solution might involve tmpnam or similar, but this covers common cases.
                // Let's assume it's okay to overwrite the check result to break.
                // Or, just accept it might fail if this file also exists, which is very unlikely.
                // For simplicity here, we'll break.
             }
             break; // Exit the loop regardless
        }

        // Check if the file exists using stat
        // The variable 'buffer' must be declared before this line
        result_stat = stat(outputVideo, &buffer);
        // If stat returns 0, the file exists.
        // If stat returns -1 (and errno is typically ENOENT), the file does not exist.
    } while (result_stat == 0); // Loop while the file exists

    // At this point, outputVideo holds a name that should not exist.
    // If it existed originally, a _1, _2, ... suffix would have been added.
    // If the initial _lut_corrected name was free, it's used.
    // Note: There's a tiny race condition here: if another process creates the file
    // between our check and ffmpeg's creation, ffmpeg might still fail.
    // For most single-user scenarios, this is negligible.
}

// Structure for playback/conversion - Updated for DNxHR MXF
struct CmdCnvrt {
  char play_0[15]; // Specify the size of the array
  char play_1[5];
  // Updated sizes for DNxHR commands
  char dnxhrInterlacedCnvrt_0[116]; // Kept similar, might need adjustment if path is very long
  // Increased size to fit the longer string with format filter
  char dnxhrInterlacedCnvrt_1[40]; // *** CHANGED FROM 23 ***
  char dnxhrNonInterlacedCnvrt_0[75]; // Kept similar, might need adjustment
  // Increased size to fit the longer string with format filter
  char dnxhrNonInterlacedCnvrt_1[40]; // *** CHANGED FROM 23 ***
};

// Initialize the variables - Updated for DNxHR MXF with format filter
// Initialize the variables - Updated for DNxHR MXF with format filter AND CORRECT PROFILE
struct CmdCnvrt cmdCnvrt = {
  " -vf lut3d=\'",
  "\'",
  // Updated command parts for DNxHR HQ MXF - Interlaced (CHANGED PROFILE)
  // Part 0: Encoder and start of filter chain
  " -c:v dnxhd -profile:v dnxhr_hq -filter:v \"yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2,lut3d=\'", // *** CHANGED PROFILE ***
  // Part 1: End of filter chain (including format), audio codec, and start of rate setting
  "\',format=yuv422p\" -c:a pcm_s16le -r ", // *** CHANGED ***

  // Updated command parts for DNxHR HQ MXF - Non-Interlaced (CHANGED PROFILE)
  // Part 0: Encoder and start of filter chain
  " -c:v dnxhd -profile:v dnxhr_hq -filter:v \"lut3d=\'", // *** CHANGED PROFILE ***
  // Part 1: End of filter chain (including format), audio codec, and start of rate setting
  "\',format=yuv422p\" -c:a pcm_s16le -r " // *** CHANGED ***
};

void scantype(char *inputVido, int *interlacedOrNot);
void framerate(char *inputVido, float *frameRate);
void playback(char *inputVido, char *lut_file);
// Updated function name and implementation for DNxHR MXF
// Modified to take output filename as argument
void cnvrt_to_dnxhr_mxf_w_lut3d_cube(char *inputVido, char *lut_file, char *outputVideo);

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
    If the input video is interlaced, apply a specific ffmpeg video filter `-filter:v "yadif=0:-1:1, scale=trunc(iw/2)*2:trunc(ih/2)*2"`.
    Then, apply the LUT3d file (in .cube extension).
    For playback, the output container/codec isn't relevant, so MJPEG command structure is fine for preview.
    ffplay -i input  -vf lut3d='vlcsnap-2023-11-26-00h41m50s633.cube'
    ffmpeg (conversion) - DNxHR HQX MXF command structure is used in cnvrt_to_dnxhr_mxf_w_lut3d_cube.
  */
  char command[MAXCMDBUFFSIZE] = "";
  sprintf(command, "%s %s%s%s%s", ffplay_exe, inputVido, cmdCnvrt.play_0, lut_file, cmdCnvrt.play_1);
  printf("\nPlayback command: %s\n", command); // Clarified message
  system(command);
}

// Updated function name and implementation for DNxHR MXF
// Modified to take output filename as argument
void cnvrt_to_dnxhr_mxf_w_lut3d_cube(char *inputVido, char *lut_file, char *outputVideo) {
  char ffmpeg_exe[MAXPATHLEN] = "\0";
  strcat(ffmpeg_exe, FFMPEG_STATIC_BUILD_LATEST_PATH);
  strcat(ffmpeg_exe, " -i "); // including the -i option
  int interlacedOrNot = 0;
  float frameRate = 0;
  framerate(inputVido, &frameRate);
  // Note: outputVideo is now passed in, not generated here.
  char command[MAXCMDBUFFSIZE] = "";
  scantype(inputVido, &interlacedOrNot);
  if(interlacedOrNot == 1) {
    // Corrected sprintf: frameRate is now correctly placed after -r
    sprintf(command, "%s %s%s%s%s%f %s", ffmpeg_exe, inputVido, cmdCnvrt.dnxhrInterlacedCnvrt_0, lut_file, cmdCnvrt.dnxhrInterlacedCnvrt_1, frameRate, outputVideo);
    printf("\nConversion command (Interlaced -> DNxHR MXF): %s\n", command);
    system(command);
  }
  else {
    // Corrected sprintf: frameRate is now correctly placed after -r
    sprintf(command, "%s %s%s%s%s%f %s", ffmpeg_exe, inputVido, cmdCnvrt.dnxhrNonInterlacedCnvrt_0, lut_file, cmdCnvrt.dnxhrNonInterlacedCnvrt_1, frameRate, outputVideo);
    printf("\nConversion command (Progressive -> DNxHR MXF): %s\n", command);
    system(command);
  }
}

int main(int argc, char *argv[]) {
  if(argc != 3) {
    fprintf(stderr, "Usage: %s <input_video> <lut3d_file_with_dot_cube_extension>\n", argv[0]);
    return EXIT_FAILURE;
  }
  int interlacedOrNot = 0;
  scantype(argv[1], &interlacedOrNot);
  if(interlacedOrNot == 1) {
    printf("Interlaced video detected.\n");
  }
  else if(interlacedOrNot == 0) {
    printf("Non-Interlaced (Progressive) video detected.\n");
  }
  playback(argv[1], argv[2]);
  char yesOrNo = '\0';
  printf("\nDo you want to convert the video using the LUT file to Avid DNxHR HQX in MXF format? (y/n): ");
  scanf(" %c", &yesOrNo); // Added space before %c
  printf("\n");
  if(yesOrNo != 'n' && yesOrNo != 'N') {
    char outputVideo[OUTPUT_VID_NAME_PLUS_EXT_LEN] = "";
    generate_output_filename(argv[1], outputVideo, sizeof(outputVideo)); // Generate filename in main
    cnvrt_to_dnxhr_mxf_w_lut3d_cube(argv[1], argv[2], outputVideo); // Pass filename to conversion function
    // Updated success message - now outputVideo is accessible
    printf("Done! Output file is likely named: %s\n", outputVideo);
  }
  else {
    printf("Exiting without proceeding with the conversion.\n");
  }
  return EXIT_SUCCESS;
}
