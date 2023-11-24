#!/usr/bin/c -Wall -Wextra -pedantic -std=gnu99 -lrt --
// Last Change: 2023-11-24  Friday: 08:14:04 PM

/*
  Create simple and elegant video titles from text files, Lower-Third
  Crawling and Vertically Scrolling type Titles.

  Usage:

  chmod +x ff_scroller.c
  ./ff_scroller.c yourTextFile.txt

  Follow instructions.

  For vertical, bottom-to-top moving Scrolling titles, you can use a word processing application such as AbiWord or LibreOffice Writer, ONLYOFFICE, FreeOffice.com, or Microsoft Office 365 Online for creating a 'Centre-Justified' list of names after initially writing the names in a text file.
  - Configure text editor to convert TABs to Spaces. Conversion should be done as follows: 1 TAB = 4 Spaces.
  - Create a plain-text file and write the names.
  - Copy the content of the text file to a Word processor.
  - Utilise the Centre-Justify option in your Word Processor.
  - Copy the Centre-Justified text from your Word Processor and paste the same back to the text file.
  - Run the script.

  Crawling (Horizontally Moving Lower-Third) Titles should be created from text files containing only one line.
  Use the Text Wrap option in the text editor to edit crawl titles.
*/

/*
  Compile the program if you want to install it (for example, MS Windows where you cannot run C codes as scripts):
  Comment out the line containing: #!/usr/bin/c -Wall -Wextra -pedantic -std=gnu99 -lrt --
  GNU+Linux:
  gcc -Wall -Wextra -pedantic -std=gnu99 -o2 lower_third_roller.c -o lower_third_roller -lrt -s
  Debug version:
  gcc -Wall -Wextra -pedantic -std=gnu99 -g lower_third_roller.c -o lower_third_roller -lrt
  GDB:
  gdb --args /mnt/hdd/Capture_Edit/Shotcut/ChromaTest/ffmpeg_video_scroller/lower_third_roller names.txt
  MS Windows:
  gcc -Wall -Wextra -pedantic -std=gnu99 -o2 lower_third_roller.c -o lower_third_roller.exe -lrt -s
  Debug version:
  gcc -Wall -Wextra -pedantic -std=gnu99 -g lower_third_roller.c -o lower_third_roller.exe -lrt
  GDB:
  gdb --args \path\to\lower_third_roller.exe names.txt

  The FFMPEG command part:
  Inspired by the web article:
  https://www.rickmakes.com/creating-scrolling-credits-with-a-transparent-background-using-ffmpeg/
  Referenced:
  https://stackoverflow.com/questions/48006872/no-such-filter-drawtext
*/

/*
  Commands:

  Horizontal (from the right to the left):

  /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=30:fontcolor=white:x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14:line_spacing=80:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names.txt'"

  Vertical (from the bottom to the top):
  /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=180:fontcolor=white:x=(w-text_w)/2:y=h-40*t:line_spacing=15:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names2.txt'"

  Differences:
  fontsize=30     Vs.    fontsize=180       // will be controlled from the main()
  x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14    Vs.     x=(w-text_w)/2:y=h-40*t // Horizontal Vs. Vertical
  line_spacing=80    Vs.    line_spacing=15 // will be controlled from the main()

  The changed parts in terms of our C code:

  x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14
  x=((%s*w)/1)-%s*t:y=(h-text_h)/%s

  x=(w-text_w)/2:y=h-40*t
  x=(w-text_w)/2:y=h-%s*t
*/

/*
  In the context of the drawtext filter within FFmpeg (ChatGPT):

    x=(w-text_w)/2+20*t: This part sets the horizontal position (x) of the text. Let's break it down:
        w: Represents the width of the video frame.
        text_w: Indicates the width of the text being displayed.
        (w-text_w)/2: This calculates the horizontal center of the video frame by subtracting the width of the text from the total width of the frame and then dividing by 2. It ensures that the text is horizontally centered initially.
        20*t: This part introduces movement. t represents time in seconds. Multiplying t by 20 means that the text will move horizontally over time at a speed proportional to t. Adjusting this value will alter the speed of the horizontal movement.

    y=(h-text_h)/2: Similarly, this sets the vertical position (y) of the text:
        h: Stands for the height of the video frame.
        text_h: Refers to the height of the text being displayed.
        (h-text_h)/2: Calculates the vertical center of the video frame by subtracting the height of the text from the total height of the frame and then dividing by 2. It ensures that the text is vertically centered initially.

  In summary, these expressions for x and y position the text at the center of the video frame initially and then the 20*t part in the x position parameter causes horizontal movement proportional to time. Adjusting these expressions allows you to control the initial position and movement of the text within the video frame.

  x=((w-text_w)/2)+20*t Vs. x=((w-text_w)/2)-20*t

  By changing x=(w-text_w)/2+20*t to x=(w-text_w)/2-20*t, the text will move from left to right as time progresses (t increases). Adjust the value 20 to control the speed and direction of the horizontal movement to suit your preference.

  In the command, x=(w-text_w)/2+20*t, the text moved from right to left as time (t) increased due to the positive coefficient (20*t).

  +20*t to -20*t

  To change the direction from left to right, I modified the x parameter in the drawtext filter. Specifically, I changed the sign of the coefficient related to time from positive to negative. The updated x parameter became x=(w-text_w)/2-20*t. This adjustment resulted in the text moving from left to right as time increased (t).

  By altering the sign of the coefficient from positive to negative (20*t to -20*t), the text's horizontal movement direction changed from right to left to left to right.
*/

// https://iq.opengenus.org/detect-operating-system-in-c/
#if ( defined( _WIN32 ) || defined( _WIN64 ) )
  #define PLATFORM_NAME "mswin"
#endif

#if (defined( __linux__ )  && !( defined( __APPLE__ ) ))
  #define PLATFORM_NAME "linux"
#endif

#if (defined( __APPLE__ ) && !( defined( __linux__ ) ))
  #define PLATFORM_NAME "macos"
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
// https://raspberrypi.stackexchange.com/questions/95470/errors-compiling-c-program-with-time-h-library
// https://stackoverflow.com/questions/40515557/compilation-error-on-clock-gettime-and-clock-monotonic
#define _POSIX_C_SOURCE 200809L
#include <time.h>

#define FFMPEG_STATIC_BUILD_LATEST_PATH "/usr/bin/ffmpeg"
#define FFPLAY_STATIC_BUILD_LATEST_PATH "/usr/bin/ffplay"
// Download FFMPEG from https://ffmpeg.org/download.html or https://johnvansickle.com/ffmpeg/

#define MAXPATHLEN 512
#define MAXBUFFSIZE 8092
#define MAX_ALLOWED_LEN_OF_A_LINE 500
#define MAX_LEN_DIMENSION_STR 15
#define OFFSCREEN_OFFSET "1.052" // Default: "1.052"
#define SPEED_OF_CRAWLING_STR_LEN 3
#define DEFAULT_FALLBACK_FONT_FILE_LINUX  "/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf"
#define DEFAULT_FALLBACK_FONT_FILE_MAC_OS "/System/Library/Fonts/Andale Mono.ttf"  // (Sorry, I don't have access to a Mac machine to test this.)
#define DEFAULT_FALLBACK_FONT_FILE_WINDOWS "C:\\Windows\\Fonts\\arial.ttf"
#define TXT_PLACEMENT_STRING_LEN_MAX  5
#define TXT_PLACEMENT_UPPER "1.16"
#define TXT_PLACEMENT_NATURAL_ABOVE_SF_MARGIN "1.14"
#define TXT_PLACEMENT_LOWER "1.10"
#define TXT_PLACEMENT_BOTTOM_BELOW_SF_MARGIN "1.0"

#define LINE_SPACING_CRAWL 80

// Define structure for time conversion
struct Time {
  int hour;
  int minute;
  int second;
};

void convertTime(int seconds, struct Time *time);
double currenttime(void);
int read_dimensions(char *input, int *w, int *h);
void write_dimensions_string(char *output, int *w, int *h);
void proxy_downscale(int *origWidth, int *origHeight, int *proxWidth, int *proxHeight);
void playback(const char *inputTextFile, int crawlVsCcroll, char *resolution, int frameRate, char *fontFileWithPath, float fontsize, char *txtplacement, int lineSpacing, char *CrawlingSpeed);
void render(const char *inputTextFile, int crawlVsCcroll, char *endtimecode, char *resolution, int frameRate, char *fontFileWithPath, float fontsize, char *txtplacement, int lineSpacing, char *CrawlingSpeed, char *outputfile);
void centerJustifyTextFile(const char *filename, const char *outputFilename);

// Function to convert seconds to hours, minutes, and seconds (hh:mm:ss), termed as timecode.
void convertTime(int seconds, struct Time *time) { // HuggingChat Mistral-7b
  // Calculate the number of hours in seconds
  time->hour = seconds / 3600;
  seconds %= 3600;
  // Calculate the number of minutes in seconds
  time->minute = seconds / 60;
  seconds %= 60;
  // Calculate the number of seconds in seconds
  time->second = seconds;
}

double currenttime(void) { // https://stackoverflow.com/questions/3557221/how-do-i-measure-time-in-c
  // https://stackoverflow.com/questions/71294793/gcc-clock-realtime-is-undeclared
  struct timespec now;
  clock_gettime(CLOCK_REALTIME, &now);
  return ((double)now.tv_sec + (double)now.tv_nsec * 1e-9);
}

/* Reads an input string as ` 12920 x 1080 ` and splits the two into two integer variables, `w` and `h`.
   To use this function, you would call it with the input string and two integer pointers as arguments:
   char input[] = "12920 x 1080";
   int w = 0, h = 0, result = 0;
   result = read_dimensions(input, &w, &h);
   printf("w: %d, h: %d\n", w, h);
   if(result != 0) {
    printf("Received invalid input dimension.\n");
  }
*/
int read_dimensions(char *input, int *w, int *h) {
  // Split the input string by the delimiter 'x'
  char *token = strtok(input, "x");

  if(token == NULL) {
    return -1;
  }

  // Convert the first token to an integer and store it in `w`
  *w = atoi(token);
  // Get the next token
  token = strtok(NULL, "x");

  if(token == NULL) {
    return -1;
  }

  // Convert the second token to an integer and store it in `h`
  *h = atoi(token);
  return 0;
}

void write_dimensions_string(char *output, int *w, int *h) {
  sprintf(output, "%d%c%d", *w, 'x', *h);
}

// Scales down the original resolution to 540p proxy standard, maintaining the display aspect ratio.
void proxy_downscale(int *origWidth, int *origHeight, int *proxWidth, int *proxHeight) {
  *proxHeight = 540; // 540p
  *proxWidth = (((*origWidth) * (*proxHeight)) / (*origHeight));
  /*
    Explanation:
    x:y = w:h
    Means, xh = yw implying, wy = xh
    Thus,
    w = (xh)/y
  */
}

void playback(const char *inputTextFile, int crawlVsCcroll, char *resolution, int frameRate, char *fontFileWithPath, float fontsize, char *txtplacement, int lineSpacing, char *CrawlingSpeed) {
  //printf("fn:playback.\n");
  //printf("Received input: %s\n", resolution);
  struct Time time; // HuggingChat Mistral-7b
  char command[MAXBUFFSIZE];
  char ffmpeg_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  char ffplay_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  sprintf(ffmpeg_exec, "%s", FFMPEG_STATIC_BUILD_LATEST_PATH);
  sprintf(ffplay_exec, "%s", FFPLAY_STATIC_BUILD_LATEST_PATH);
  int width = 0, height = 0, proxywidth = 0, proxyheight = 0;
  char dimensions_as_str[MAX_LEN_DIMENSION_STR] = "";
  char res4thfn[MAX_LEN_DIMENSION_STR] = "";
  strcpy(res4thfn, resolution);
  short int ret_err_succ = (short int)read_dimensions(res4thfn, &width, &height);
  //printf("fn:playback.\n");
  //printf("output as int: %d : %d\n", width, height);
  printf("\n");

  if(ret_err_succ != 0) {
    printf("An error occurred!\n");
  }

  else {
    proxy_downscale(&width, &height, &proxywidth, &proxyheight);
    //printf("proxy as int: %d : %d, %d : %d\n", width, height, proxywidth, proxyheight);
    write_dimensions_string(dimensions_as_str, &proxywidth, &proxyheight);
  }

  fontsize = (float)((int)fontsize * (int)proxywidth / (int)width);  // Scaling down the font size to maintain proportions in the proxy preview.
  char framerate_str[3] = ""; // 3 digits. frame rate usually does not exceed 999

  if(atoi(framerate_str) >= (999 / 2)) { // Frame rate should not exceed 999 in the output.
    exit(EXIT_FAILURE);
  }

  sprintf(framerate_str, "%d", (2 * frameRate)); // doubling down the frame rate to make room for time remapping later in the NLE

  /*
    Horizontal Vs. Vertical:

    /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=30:fontcolor=white:x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14:line_spacing=80:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names.txt'"

    /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=180:fontcolor=white:x=(w-text_w)/2:y=h-40*t:line_spacing=15:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names2.txt'"

    fontsize=30 Vs. fontsize=180 // will be controlled from the main()
    x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14 Vs. x=(w-text_w)/2:y=h-40*t
    line_spacing=80 Vs. line_spacing=15 // will be controlled from the main()

    x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14
    x=((%s*w)/1)-%s*t:y=(h-text_h)/%s
    Vs.
    x=(w-text_w)/2:y=h-40*t
    x=(w-text_w)/2:y=h-%s*t
  */
  if(crawlVsCcroll == 1) {
    // /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=30:fontcolor=white:x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14:line_spacing=80:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names.txt'"
    sprintf(command, "%s -f lavfi -i color=white@0.0:s=%s:rate=%s,format=rgba -ss 00:00:00 -vf \"drawtext=fontfile=\'%s\':fontsize=%f:fontcolor=white:shadowcolor=green@0.7:shadowx=1:shadowy=2:x=((%s*w)/1)-%s*t:y=(h-text_h)/%s:line_spacing=%d:textfile=\'%s\'\"", ffplay_exec, dimensions_as_str, framerate_str, fontFileWithPath, fontsize, OFFSCREEN_OFFSET, CrawlingSpeed, txtplacement, lineSpacing, inputTextFile); // system() should return 0 upon successful execution.
    /*const char cmd[] = "ffplay"; // system() will return 256.*/
  }

  else {
    // /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=180:fontcolor=white:x=(w-text_w)/2:y=h-40*t:line_spacing=15:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names2.txt'"
    sprintf(command, "%s -f lavfi -i color=white@0.0:s=%s:rate=%s,format=rgba -ss 00:00:00 -vf \"drawtext=fontfile=\'%s\':fontsize=%f:fontcolor=white:shadowcolor=green@0.7:shadowx=1:shadowy=2:x=(w-text_w)/2:y=h-%s*t:line_spacing=%d:textfile=\'%s\'\"", ffplay_exec, dimensions_as_str, framerate_str, fontFileWithPath, fontsize, CrawlingSpeed, lineSpacing, inputTextFile); // system() should return 0 upon successful execution.
    /*const char cmd[] = "ffplay"; // system() will return 256.*/
  }

  printf("command passed: %s\n\n", command);
  // Calculate the time taken by system().
  double time_at_present = currenttime();
  int ret = system(command);
  double time_elapsed_sec = (currenttime() - time_at_present);
  printf("The process returned %d\n", ret);
  printf("FFPLAY took %.6lf seconds to execute.\n", time_elapsed_sec);
  // Call the ConvertTime function with input seconds and store the result in the time variable.
  convertTime((int)time_elapsed_sec + 1, &time); // HuggingChat Mistral-7b
  // Print converted time in hh:mm:ss format // HuggingChat Mistral-7b
  printf("%d:%d:%d\n", time.hour, time.minute, time.second);
}

void render(const char *inputTextFile, int crawlVsCcroll, char *endtimecode, char *resolution, int frameRate, char *fontFileWithPath, float fontsize, char *txtplacement, int lineSpacing, char *CrawlingSpeed, char *outputfile) {
  //printf("fn:render.\n"); // Debug
  //printf("Received input: %s\n", resolution); // Debug
  struct Time time; // HuggingChat Mistral-7b
  char command[MAXBUFFSIZE];
  char ffmpeg_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  char ffplay_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  sprintf(ffmpeg_exec, "%s", FFMPEG_STATIC_BUILD_LATEST_PATH);
  sprintf(ffplay_exec, "%s", FFPLAY_STATIC_BUILD_LATEST_PATH);
  printf("endtimecode received: %s\n", endtimecode);
  char framerate_str[3] = ""; // 3 digits. frame rate usually does not exceed 999

  if(atoi(framerate_str) >= (999 / 2)) { // Frame rate should not exceed 999 in the output.
    exit(EXIT_FAILURE);
  }

  sprintf(framerate_str, "%d", (2 * frameRate)); // doubling down the frame rate to make room for time remapping later in the NLE

  /*
    Horizontal Vs. Vertical:

    /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=30:fontcolor=white:x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14:line_spacing=80:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names.txt'"

    /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=180:fontcolor=white:x=(w-text_w)/2:y=h-40*t:line_spacing=15:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names2.txt'"

    fontsize=30 Vs. fontsize=180 // will be controlled from the main()
    x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14 Vs. x=(w-text_w)/2:y=h-40*t
    line_spacing=80 Vs. line_spacing=15 // will be controlled from the main()

    x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14
    x=((%s*w)/1)-%s*t:y=(h-text_h)/%s
    Vs.
    x=(w-text_w)/2:y=h-40*t
    x=(w-text_w)/2:y=h-%s*t
  */
  if(crawlVsCcroll == 1) {
    // /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=30:fontcolor=white:x=((1.052*w)/1)-20*t:y=(h-text_h)/1.14:line_spacing=80:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names.txt'"
    sprintf(command, "%s -f lavfi -i color=white@0.0:s=%s:rate=%s,format=rgba -ss 00:00:00 -to %s -vf \"drawtext=fontfile=\'%s\':fontsize=%f:fontcolor=white:shadowcolor=black@0.77:shadowx=4:shadowy=4:x=((%s*w)/1)-%s*t:y=(h-text_h)/%s:line_spacing=%d:textfile=\'%s\'\" -c:v png \'%s.mov\'", ffmpeg_exec, resolution, framerate_str, endtimecode, fontFileWithPath, fontsize, OFFSCREEN_OFFSET, CrawlingSpeed, txtplacement, lineSpacing, inputTextFile, outputfile); // system() should return 0 upon successful execution.
    /*const char cmd[] = "ffplay"; // system() will return 256.*/
  }

  else {
    // /usr/bin/ffplay -f lavfi -i color=white@0.0:s=1920x1080:rate=50,format=rgba -ss 00:00:00 -t 00:01:30 -vf "drawtext=fontfile=/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf:fontsize=180:fontcolor=white:x=(w-text_w)/2:y=h-40*t:line_spacing=15:shadowcolor=green@0.7:shadowx=4:shadowy=4:textfile='names2.txt'"
    sprintf(command, "%s -f lavfi -i color=white@0.0:s=%s:rate=%s,format=rgba -ss 00:00:00 -to %s -vf \"drawtext=fontfile=\'%s\':fontsize=%f:fontcolor=white:shadowcolor=black@0.77:shadowx=4:shadowy=4:x=(w-text_w)/2:y=h-%s*t:line_spacing=%d:textfile=\'%s\'\" -c:v png \'%s.mov\'", ffmpeg_exec, resolution, framerate_str, endtimecode, fontFileWithPath, fontsize, CrawlingSpeed, lineSpacing, inputTextFile, outputfile); // system() should return 0 upon successful execution.
    /*const char cmd[] = "ffplay"; // system() will return 256.*/
  }

  printf("command passed: %s\n\n", command);
  // Calculate the time taken by system().
  double time_at_present = currenttime();
  int ret = system(command);
  double time_elapsed_sec = (currenttime() - time_at_present);
  printf("The process returned %d\n", ret);
  printf("FFMPEG took %.6lf seconds to render the output.\n", time_elapsed_sec);
  // Call the ConvertTime function with input seconds and store the result in the time variable.
  convertTime((int)time_elapsed_sec + 1, &time); // HuggingChat Mistral-7b
  // Print converted time in hh:mm:ss format // HuggingChat Mistral-7b
  printf("%d:%d:%d\n", time.hour, time.minute, time.second);
}

/* NOTE: The following function `void centerJustifyTextFile(const char *filename, const char *outputFilename);` has been written by ChatGPT. */

// Function to centre justify text from an input file and write to an output file. Use the function as: centerJustifyTextFile("input.txt", "output.txt");
void centerJustifyTextFile(const char *filename, const char *outputFilename) {
  // Open the input file for reading
  FILE *inputFile = fopen(filename, "r");

  // Check if input file opened successfully
  if(inputFile == NULL) {
    printf("Failed to open input file: %s\n", filename);
    return;
  }

  // Open the output file for writing
  FILE *outputFile = fopen(outputFilename, "w");

  if(outputFile == NULL) {
    printf("Failed to open/create output file: %s\n", outputFilename);
    fclose(inputFile);
    return;
  }

  char buffer[MAX_ALLOWED_LEN_OF_A_LINE]; // Buffer to store lines read from the file
  int maxWidth = 0; // Variable to hold the maximum line width

  // Calculate the maximum line width in the input file
  while(fgets(buffer, sizeof(buffer), inputFile) != NULL) {
    int len = strlen(buffer);

    if(buffer[len - 1] == '\n') {
      buffer[len - 1] = '\0'; // Remove newline character
      len--;
    }

    if(len > maxWidth) {
      maxWidth = len; // Update maximum width if a longer line is found
    }
  }

  // Reset file position indicator to the beginning
  rewind(inputFile);

  // Process each line in the input file for centre justification
  while(fgets(buffer, sizeof(buffer), inputFile) != NULL) {
    int len = strlen(buffer);

    if(buffer[len - 1] == '\n') {
      buffer[len - 1] = '\0'; // Remove newline character
      len--;
    }

    int spacesToAdd = maxWidth - len; // Calculate spaces needed for justification
    spacesToAdd += 1; // Minor adjustments without which the text is being shifted slightly to the left.
    int spacesBefore = spacesToAdd / 2; // Spaces to add before the line
    spacesBefore = spacesBefore + 1; // Minor adjustments without which the text is being shifted slightly to the left.
    int spacesAfter = spacesToAdd - spacesBefore; // Spaces to add after the line

    // Add spaces before the line
    for(int i = 0; i < spacesBefore; i++) {
      fprintf(outputFile, " ");
    }

    // Write the line to the output file
    fprintf(outputFile, "%s", buffer);

    // Add spaces after the line
    for(int i = 0; i < spacesAfter; i++) {
      fprintf(outputFile, " ");
    }

    // Add a newline to move to the next line
    fprintf(outputFile, "\n");
  }

  // Close both input and output files
  fclose(inputFile);
  fclose(outputFile);
}

int main(int argc, char *argv[]) {
  // Delete the file 'centered_text.txt' if it exists
  remove("centered_text.txt");

  if(argc != 2) {
    fprintf(stderr, "Usage: %s <input_text_file>\n", argv[0]);
    return 1;
  }

  printf("Remember that you can press CTRL+c at any time to close the program!\n\n");
  printf("How do you want to render the text?\n1. Crawl horizontally from the right to the left.\n2. Scroll vertically from the top to bottom.\n");
  int crawlVsCroll = 0;
  scanf("%d", &crawlVsCroll);

  if(crawlVsCroll == 1) {
    printf("You chose to Crawl the text horizontally from right to left (Lower-third titles).\n");
  }

  else if(crawlVsCroll == 2) {
    printf("You chose to Scroll the text vertically from the top to bottom.\n");
    printf("Would you like to Centre-Justify the text? (y/n): ");
    char yesno[2] = "";
    scanf("%1s", yesno);

    if(strcmp(yesno, "y") == 0) {
      centerJustifyTextFile(argv[1], "centered_text.txt");
      argv[1] = "centered_text.txt";
      printf("The text has been centred and written to a temporary file named 'centered_text.txt'.\n");
    }
  }

  else {
    printf("You chose an invalid option. Closing the program.\n");
    // Delete the file 'centered_text.txt' if it exists
    remove("centered_text.txt");
  }

  // Ask the user to enter the resolution
  char resolution[MAX_LEN_DIMENSION_STR] = "";
  printf("Some common screen resolutions:\n");
  printf("- SD VCD 4:3 Square Pixels (both PAL & NTSC): 640x480\n- SD DVD Square Pixels (both PAL & NTSC): 800x600\n- SD DVD 16:9 Square Pixels: 1024x576\n- HD-1: 1280x720\n- Full HD: 1920x1080\n- 4K UHD: 3840x2160\n- Digital Cinema Initiative 4K (Referenced: GIMP): 4096x2160\n");
  printf("Enter the resolution (example: 1920x1080): ");
  scanf("%s", resolution);
  // Ask the user to enter the frame rate
  int frameRate = 0;
  printf("Enter the frame rate (Film: 24, PAL: 25, NTSC: 30, or custom. example: 25): ");
  scanf("%d", &frameRate);
  printf("NOTE: The frame rate will be doubled to make room for adjusting the time-remap parameter later in the NLE.\n");

  if(frameRate >= (999 / 2)) { // Frame rate should not exceed 999 in the output.
    printf("The frame rate should not exceed 999 in the output, considering that the input value will be doubled.\n");
    // Delete the file 'centered_text.txt' if it exists
    remove("centered_text.txt");
    exit(EXIT_FAILURE);
  }

  char fontdir_explore[MAXPATHLEN] = "";

  if(strcmp(PLATFORM_NAME, "linux") == 0) {
    printf("You are on Linux.\n");
    sprintf(fontdir_explore, "%s", "xdg-open /usr/share/fonts/truetype/");
    system(fontdir_explore);
  }

  else if(strcmp(PLATFORM_NAME, "macos") == 0) {
    printf("You are on MacOS.\n");
    sprintf(fontdir_explore, "%s", "open /Library/Fonts/");
    system(fontdir_explore);
  }

  else if(strcmp(PLATFORM_NAME, "windows") == 0) {
    printf("You are on Microsoft Windows.\n");
    sprintf(fontdir_explore, "%s", "explorer C:\\Windows\\Fonts\\");
    system(fontdir_explore);
  }

  // Ask the user to enter the font file
  char fontFileWithPath[MAXPATHLEN] = "";
  printf("Enter the font file (filename with path. examples: /usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf (Linux) or C:\\Windows\\Fonts\\arial.ttf (Windows) or /System/Library/Fonts/Andale Mono.ttf (MacOS)):\nType \'default\' without the quotes to use the default font file: ");
  scanf("%s", fontFileWithPath);

  // Set fallback font file if the user enters nothing
  if(strcmp(fontFileWithPath, "default") == 0) {
    printf("No font file has been entered. Using the default font file.\n");

    // Detect the OS and set the font file accordingly, guaranteed to be found on the system.
    if(strcmp(PLATFORM_NAME, "linux") == 0) {
      strcpy(fontFileWithPath, DEFAULT_FALLBACK_FONT_FILE_LINUX);
    }

    else if(strcmp(PLATFORM_NAME, "macos") == 0) {
      strcpy(fontFileWithPath, DEFAULT_FALLBACK_FONT_FILE_MAC_OS);
    }

    else if(strcmp(PLATFORM_NAME, "windows") == 0) {
      strcpy(fontFileWithPath, DEFAULT_FALLBACK_FONT_FILE_WINDOWS);
    }
  }

  // Ask the user to enter the font size
  float fontsize = 0;

  if(crawlVsCroll == 1) {
    //printf("You chose to Crawl the text horizonally from the right to left (Lower-Third).\n");
    printf("Enter the font size (example: 70 (recommended for crawling lower-third texts)): ");
    scanf("%f", &fontsize);
  }

  else if(crawlVsCroll == 2) {
    //printf("You chose to Scroll the text vertically from the top to bottom.\n");
    printf("Enter the font size (example: 180 (recommended for scrolling  titles)): ");
    scanf("%f", &fontsize);
  }

  int txtplacement = 0;
  char txtplacementstr[TXT_PLACEMENT_STRING_LEN_MAX] = "";

  if(crawlVsCroll == 1) {
    //printf("You chose to Crawl the text horizonally from the right to left (Lower-Third).\n");
    // Ask the user to choose one of three text placement schemes
    printf("The text can placed on\n1. Slightly above the Bottom Safe Margin\n2. In a convenient height above the Bottom Safe Margin (recommended)\n3. Adjacent to the Bottom Safe Margin\n4. At the Lowest Position of the Screen\nChoose one: ");
    scanf("%d", &txtplacement);

    switch(txtplacement) {
      case 1:
        sprintf(txtplacementstr, "%s", TXT_PLACEMENT_UPPER);
        break;

      case 2:
        sprintf(txtplacementstr, "%s", TXT_PLACEMENT_NATURAL_ABOVE_SF_MARGIN);
        break;

      case 3:
        sprintf(txtplacementstr, "%s", TXT_PLACEMENT_LOWER);
        break;

      case 4:
        sprintf(txtplacementstr, "%s", TXT_PLACEMENT_BOTTOM_BELOW_SF_MARGIN);
        break;

      default:
        printf("Invalid choice. Setting default text placement to \'choice 2\'.\n");
        sprintf(txtplacementstr, "%s", TXT_PLACEMENT_NATURAL_ABOVE_SF_MARGIN);
        /*return 1;*/
        break;
    }
  }

  int linespacing = 0;

  if(crawlVsCroll == 1) {
    //printf("You chose to Crawl the text horizonally from the right to left (Lower-Third).\n");
    linespacing = LINE_SPACING_CRAWL;
  }

  else if(crawlVsCroll == 2) {
    //printf("You chose to Scroll the text vertically from the top to bottom.\n");
    printf("Choose a Line-Spacing Factor. It can be any integer-only number between 5 to 250. Higher value = More space between lines. (Recommended value for scrolling titles: 15): ");
    scanf("%3d", &linespacing);
  }

  // Ask the user to enter the crawling speed
  char CrawlingSpeed[SPEED_OF_CRAWLING_STR_LEN] = "";

  if(crawlVsCroll == 1) {
    //printf("You chose to Crawl the text horizonally from the right to left (Lower-Third).\n");
    printf("Enter the crawling speed (higher value = faster) (recommended: 30): ");
    scanf("%s", CrawlingSpeed);
  }

  else if(crawlVsCroll == 2) {
    //printf("You chose to Scroll the text vertically from the top to bottom.\n");
    printf("Enter the crawling speed (higher value = faster) (recommended: 40): ");
    scanf("%s", CrawlingSpeed);
  }

  printf("\n"); // Add a new line
  playback(argv[1], crawlVsCroll, resolution, frameRate, fontFileWithPath, fontsize, txtplacementstr, linespacing, CrawlingSpeed); // HuggingChat Mistral-7b
  // Ask the users if they want to render the output
  char outputfile[MAXPATHLEN] = "";
  printf("Do you want to render the output? (y/n): ");
  // If the user chooses yes, ask the user to enter the output file.
  char yesno[2] = "";
  scanf("%1s", yesno);

  if(strcmp(yesno, "y") == 0) {
    printf("Enter the output filename (Without path and extension. The resulting file will automatically be encoded with RGBA PhotoPNG codec in QuickTime MOV container): ");
    scanf("%s", outputfile);
    // Ask the user to enter the end timecode in the format hh:mm:ss
    printf("Enter the end timecode (format hh:mm:ss): ");
    char endtimecode[10] = "";
    scanf("%9s", endtimecode);
    printf("End timecode entered: %s\n", endtimecode);
    render(argv[1], crawlVsCroll, endtimecode, resolution, frameRate, fontFileWithPath, fontsize, txtplacementstr, linespacing, CrawlingSpeed, outputfile); // HuggingChat Mistral-7b
    printf("\n"); // Add a new line
  }

  else {
    printf("Exiting...\n");
    // Delete the file 'centered_text.txt' if it exists
    remove("centered_text.txt");
    return 0;
  }

  // Delete the file 'centered_text.txt' if it exists
  remove("centered_text.txt");
  return 0;
}

