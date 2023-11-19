#!/usr/bin/c -Wall -Wextra -pedantic --

// Last Change: 2023-11-19  Sunday: 02:40:43 PM

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
  chmod +x ff_scroller.c
  ./ff_scroller.c <input_png> <input_mask>
*/

// or (on MS Windows), gcc -Wall -Wextra -pedantic -o2 ff_scroller.c -o ff_scroller.exe -s

/*
  Refrerences (FFMPEG):
  https://superuser.com/questions/1092015/want-to-extract-out-only-alpha-using-ffmpeg
  ffmpeg -i input.avi  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -vf alphaextract,format=yuv420p output-alpha.mov
  ffmpeg -i input.avi  -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -c:a pcm_s16le output.mov
  https://stackoverflow.com/questions/61834623/how-to-use-ffmpeg-colorspace-options
  https://trac.ffmpeg.org/wiki/colorspace
  Ecosia: ffmpeg scrolling vertically a 1920x1080 image
  https://stackoverflow.com/questions/56288245/how-to-scroll-an-image-vertically-using-ffmpeg-and-detect-the-end-of-image-eoi
  https://superuser.com/questions/1738107/ffmpeg-scroll-smoothly-an-image-and-text-in-a-defined-area
  https://video.stackexchange.com/questions/32419/ffmpeg-vertical-pan-over-an-image-top-to-bottom-scrolling-effect
  https://stackoverflow.com/questions/46916778/use-ffmpeg-to-generate-a-movie-with-alpha-channel-from-separate-video-and-fill-m
*/

/*
  Synopsis of the FFMPEG command (*according to Google Bard):

  ffmpeg -f lavfi -i color=s=1920x1080 -loop 1 -t 1.5 -i "input.png" -filter_complex "[1:v]scale=1920:-2,setpts=if(eq(N\,0)\,0\,1+1/0.005/TB),fps=25[fg]; [0:v][fg]overlay=y=-'t*h*0.005':eof_action=endall[v]" -map "[v]" output.MOV

  Input Streams:

    -f lavfi -i color=s=1920x1080 -loop 1 -t 1.5: This part of the command defines the first input stream, which is a solid color video generated using the Lavfi library. It has a resolution of 1920x1080 pixels, loops once, and has a duration of 1.5 seconds.
    -i color=s=1920x1080: This creates a solid color input stream with a resolution of 1920x1080 pixels.
    -loop 1: This loops the color input stream once.
    -t 1.5: This sets the duration of the color input stream to 1.5 seconds.
    -i "input.png": This adds an additional input stream from the PNG image file named "input.png".

  Processing:

    -filter_complex: This marks the beginning of the complex filter graph section of the command.
    [1:v]scale=1920:-2: This filter selects the video stream from the second input (the PNG image), scales it to a width of 1920 pixels while maintaining the original aspect ratio.
    scale=1920:-2: This scales the video stream to a width of 1920 pixels and maintains the original aspect ratio.
    setpts=if(eq(N\,0)\,0\,1+1/0.005/TB): This filter adjusts the PTS (presentation timestamps) of the scaled video stream. If the frame number (N) is 0, the PTS is set to 0. Otherwise, the PTS is calculated using the timebase (TB) [the PTS is set to 1 plus an increment based on the timebase (TB)] and a specified frame rate of 0.005 frames per millisecond..
    fps=25: This filter sets the output frame rate to 25 frames per second.
    [fg]: This assigns the processed video stream to a temporary variable named [fg].
    [0:v][fg]overlay=y=-'t*h*0.005':eof_action=endall[v]: This filter overlays the original video stream (from the first input) onto the processed video stream ([fg]). The vertical offset of the overlay is dynamically adjusted based on the time (t), the height (h), and a factor of 0.005. The eof_action=endall option ensures that the output ends when either input stream reaches its end.

  Output:

    -map "[v]": This maps the processed video stream (after the overlay) to the output stream.
    output.MOV: This specifies the filename for the output MOV file.

  In summary, this FFmpeg command generates a 1.5-second video by overlaying a PNG image onto a solid color background. The PNG image is scaled to fit the background and the overlay position is dynamically adjusted over time. The output is saved as a MOV file with a frame rate of 25 frames per second.

  To change the speed of the scrolling overlay in the FFmpeg command, you can modify the following part:

  [1:v]scale=1920:-2,setpts=if(eq(N\,0)\,0\,1+1/0.005/TB),fps=25[fg]

  Specifically, you'll need to adjust the value within the setpts filter:

  setpts=if(eq(N\,0)\,0\,1+1/X/TB) [X: 0.005 (found in the command above)]

  The value X determines the speed of the scrolling. A lower value of X will slow down the scrolling, while a higher value will speed it up. For example, to slow down the scrolling by half, you would change the value to 0.0025. Conversely, to double the scrolling speed, you would change the value to 0.01.

  Here's an example of how to slow down the scrolling by half:

  ffmpeg -f lavfi -i color=s=1920x1080 -loop 1 -t 1.5 -i "input.png" -filter_complex "[1:v]scale=1920:-2,setpts=if(eq(N\,0)\,0\,1+1/0.0025/TB),fps=25[fg]; [0:v][fg]overlay=y=-'t*h*0.0025':eof_action=endall[v]" -map "[v]" output.MOV

  And here's an example of how to double the scrolling speed:

  ffmpeg -f lavfi -i color=s=1920x1080 -loop 1 -t 1.5 -i "input.png" -filter_complex "[1:v]scale=1920:-2,setpts=if(eq(N\,0)\,0\,1+1/0.01/TB),fps=25[fg]; [0:v][fg]overlay=y=-'t*h*0.01':eof_action=endall[v]" -map "[v]" output.MOV

  Adjust the value of X according to your desired scrolling speed.

  Add motion blur if needed:
  https://unix.stackexchange.com/questions/178503/ffmpeg-interpolate-frames-or-add-motion-blur
  ffmpeg -f lavfi -i color=s=1920x1080 -loop 1 -t 5 -i "input.png" -filter_complex "[1:v]scale=1920:-2,setpts=if(eq(N\,0)\,0\,1+1/0.00625/TB),fps=25,tblend[fg]; [0:v][fg]overlay=y=-'t*h*0.00625':eof_action=endall[v]" -map "[v]" output.MOV
*/

/*
   --------------------------------------------------------------------------------
   Create Eye-Catching Scrolling Titles with ff_scroller

  Elevate your videos to new heights of visual appeal with ff_scroller, a versatile tool that enables you to create captivating scrolling titles for your videos. It seamlessly transforms a transparent PNG image into a dynamic video by scrolling through its content. This process empowers you to craft titles that are far more visually appealing and engaging than the standard titling options offered by conventional video editing software.

  Design Captivating Titles:
  Unleash your creativity by designing eye-catching titles in Inkscape, incorporating diverse fonts, colours, styles, vectors, and sizes.

  Seamless Integration:
  Effortlessly integrate your static titles into videos using premultiplied alpha channels, ensuring compatibility with popular video editing software.

  Cross-Platform Compatibility:
  Create stunning titles on your preferred platform, as ff_scroller supports both Linux/Unix and MS Windows environments.

  Step-by-Step Guide:

    Generate Blank SVG: Execute the script without arguments to produce a blank SVG template file.

    Design Titles in Inkscape: Import the SVG file into Inkscape and unleash your creativity by incorporating eye-catching texts with diverse fonts, colours, styles, vectors, and sizes.

    Export from Inkscape: Navigate to File Menu > Export (CTRL+SHIFT+e) in Inkscape. Under the Export Tab, select 'Single Image' > 'Page'. Choose a destination and export the file.

    Prepare the Matte in GIMP: Launch GIMP and import the PNG file exported from Inkscape. Right-click on the Layers Panel and select 'Alpha to Selection'. Invert the selection (Menu > Invert, CTRL+i). Disable the input PNG layer (click the Eye Icon). Create a new layer (Layer Menu > New Layer, SHIFT+CTRL+n or click the 'New' icon in the layer panel). Utilise the Bucket Fill Tool (SHIFT+b) to fill the new layer with a solid black colour. Delete the original input layer. Export the matte as a JPEG file (File Menu > Export As, CTRL+SHIFT+e). Append '-m' to the filename and proceed with the export.

    If needed, add two pixels of motion blur to both the title image and the matte file.

    Generate Videos: Run the script with the command ./ff_scroller.c input.png input-m.jpg. The program will generate two video files: one containing the title and the other containing the mask/matte information.

   1. A grayscale output video containing the alpha channel information (from your JPG file containing the grayscale mask/matte)
   2. A scrolling video with the colour and the text (from your PNG file containing the coloured title)

    Choose Your Output Format: Combine the two video files or use the single-file premultiplied alpha option. You can either combine the two separate video files, one with the title and the other containing the mask/matte information or use the single-file premultiplied alpha option, depending on your NLE preferences.

  Key Features:

    Create captivating scrolling titles that surpass the limitations of built-in video titlers of NLEs
    Achieve full control over text design and visual aesthetics
    Compatible with popular video editing software
    Experience cross-platform compatibility (Linux/Unix, MS Windows)

  Embark on a journey of creative expression with ff_scroller and transform your videos into captivating masterpieces.

   The script is compatible with Linux/Unix environments. For MS Windows,
  comment out the line ` #!/usr/bin/c -Wall -Wextra -pedantic -- ` and
  compile with gcc:
   
   gcc -Wall -Wextra -pedantic -o2 ff_scroller.c -o ff_scroller.exe -s
   --------------------------------------------------------------------------------
*/

/*
  Creating Templates in Inkscape:
  The width remains the same.
  Add 80/90 safe margins on both sides.
  -----------
  | |    |  | height of a single frame x 2 to start offscreen
  | |    |  | Keep blank
  -----------
  -----------
  | |    |  |
  | |    |  |
  -----------
  |         |
  |         |
  |         |
  |         |
  |         |
  |         | height of a single frame x 20 for your text design
  |         |
  |         |
  |         |
  |         |
  |         |
  |         |
  |         |
  |         |
  -----------
  | |    |  |
  | |    |  |
  -----------
  -----------
  | |    |  | Keep blank
  | |    |  | height of a single frame x 2 to end offscreen
  -----------
*/

// https://iq.opengenus.org/detect-operating-system-in-c/
#if ( defined( _WIN32 ) || defined( _WIN64 ) || ( WIN32 ))
  #define PLATFORM_NAME "mswin"
#endif

#if ( defined( __unix__ ) || defined( __linux__ ) || defined( __APPLE__ ) || defined(_POSIX_VERSION) )
  #define PLATFORM_NAME "nix"
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FFMPEG_STATIC_BUILD_LATEST_PATH "/home/YOURUSERNAME/PortablePrograms/ffmpeg-git-amd64-static/ffmpeg"
// Download FFMPEG from https://ffmpeg.org/download.html or https://johnvansickle.com/ffmpeg/

#define MAXPATHLEN 512
#define MAXBUFFSIZE 8092
#define MAX_OUTPUT_VIDEO_FILE_NAME_LENGHT 7056
#define MAX_EXTENSION_LEN 30
#define DURATION_OF_THE_COLOR_INPUT_STREAM 1.5
#define MAX_FACTOR_STR_LEN 10
#define MAX_FRAMERATE  100

char output_alpha_mask_video[MAX_OUTPUT_VIDEO_FILE_NAME_LENGHT] = "";
char output_video[MAX_OUTPUT_VIDEO_FILE_NAME_LENGHT] = "";
char output_png_video_w_real_alpha_channel[MAX_OUTPUT_VIDEO_FILE_NAME_LENGHT] = "";

// SVG Scroller Template
const char *predefinedXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<!-- Created with Inkscape (http://www.inkscape.org/) -->\n<svg width=\"1920\"\n height=\"25920\"\n viewBox=\"0 0 508 6858\"\n version=\"1.1\"\n id=\"svg5\"\n inkscape:version=\"1.2.2 (732a01da63, 2022-12-09, custom)\"\n sodipodi:docname=\"template.svg\"\n inkscape:export-filename=\"../86efe3da/scroller-template.png\"\n inkscape:export-xdpi=\"96\"\n inkscape:export-ydpi=\"96\"\n xmlns:inkscape=\"http://www.inkscape.org/namespaces/inkscape\"\n xmlns:sodipodi=\"http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd\"\n xmlns=\"http://www.w3.org/2000/svg\"\n xmlns:svg=\"http://www.w3.org/2000/svg\">\n  <!-- Your SVG content here -->\n  <sodipodi:namedview\n     id=\"namedview7\"\n     pagecolor=\"#ffffff\"\n     bordercolor=\"#999999\"\n     borderopacity=\"1\"\n     inkscape:showpageshadow=\"0\"\n     inkscape:pageopacity=\"0\"\n     inkscape:pagecheckerboard=\"0\"\n     inkscape:deskcolor=\"#d1d1d1\"\n     inkscape:document-units=\"mm\"\n     showgrid=\"false\"\n     inkscape:zoom=\"0.40416667\"\n     inkscape:cx=\"960\"\n     inkscape:cy=\"2706.8041\"\n     inkscape:window-width=\"1368\"\n     inkscape:window-height=\"716\"\n     inkscape:window-x=\"0\"\n     inkscape:window-y=\"26\"\n     inkscape:window-maximized=\"1\"\n     inkscape:current-layer=\"layer1\"\n     showguides=\"true\">\n    <sodipodi:guide\n       position=\"51.483644,6834.9091\"\n       orientation=\"1,0\"\n       id=\"guide870\"\n       inkscape:locked=\"false\" />    <sodipodi:guide       position=\"456.4063,6851.3022\"       orientation=\"1,0\"       id=\"guide872\"       inkscape:locked=\"false\" />\n    <sodipodi:guide\n       position=\"646.7835,6281.9175\"\n       orientation=\"0,-1\"\n       id=\"guide516\"\n       inkscape:locked=\"false\" />\n    <sodipodi:guide\n       position=\"540.12753,575.4626\"\n       orientation=\"0,-1\"\n       id=\"guide526\"\n       inkscape:locked=\"false\" />\n  </sodipodi:namedview>  <g inkscape:label=\"Container\" inkscape:groupmode=\"layer\" id=\"layer1\" transform=\"translate(-181.87399,739.6633)\" />\n</svg>";

void scroller_mask(char *input_mask, char *output_mask_video, int frame_rate, long double speed_of_scrolling, int choose_tblend);
void scroller(char *input_png, char *output_video, int frame_rate, long double speed_of_scrolling, int choose_tblend);
void merge(char *input_video, char *input_mask, char *output_png_video_w_real_alpha_channel);
void intermediate_file_cleanup_w_trash_cli(char *temp_file);
void dumpXMLToFile(const char *filename, const char *xmlContent);
int checkAvailability(const char *programName);

void scroller_mask(char *input_mask, char *output_mask_video, int frame_rate, long double speed_of_scrolling, int choose_tblend) {
  char command[MAXBUFFSIZE];
  char ffmpeg_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  // Convert the variable speed_of_scrolling to a string
  char speed_of_scrolling_str[MAX_FACTOR_STR_LEN] = "";
  sprintf(speed_of_scrolling_str, "%9Lf", speed_of_scrolling);
  // Convert frame_rate to a string
  char frame_rate_str[MAX_FRAMERATE] = "";
  sprintf(frame_rate_str, "%d", frame_rate);
  strcat(ffmpeg_exec, FFMPEG_STATIC_BUILD_LATEST_PATH);
  char option_tblend[10];

  // If the answer is not YES, then set the choose_tblend to 0.
  if(choose_tblend != 1) {
    strcpy(option_tblend, "");
  }

  else {
    strcpy(option_tblend, ",tblend");
  }

  //.mov will be appended to the output file and the output will be produced in the QuickTime .mov container.
  /* ffmpeg -f lavfi -i color=s=1920x1080 -loop 1 -t 1.5 -i "scroller-m.jpg" -filter_complex "[1:v]scale=1920:-2,setpts=if(eq(N\,0)\,0\,1+1/0.005/TB),fps=25[fg]; [0:v][fg]overlay=y=-'t*h*0.005':eof_action=endall[v]" -map "[v]" scroller-m.MOV */
  sprintf(command, "%s -f lavfi -i color=s=1920x1080 -loop 1 -t %f -i %s -filter_complex \"[1:v]scale=1920:-2,setpts=if(eq(N\\,0)\\,0\\,1+1/%s/TB),fps=%s%s[fg]; [0:v][fg]overlay=y=-'t*h*%s':eof_action=endall[v]\" -map \"[v]\" %s", ffmpeg_exec, DURATION_OF_THE_COLOR_INPUT_STREAM, input_mask, speed_of_scrolling_str, frame_rate_str, option_tblend, speed_of_scrolling_str, output_mask_video);
  // debug printf
  printf("%s\n\n", command);
  system(command);
}

void scroller(char *input_png, char *output_video_1, int frame_rate, long double speed_of_scrolling, int choose_tblend) {
  char command[MAXBUFFSIZE];
  char ffmpeg_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  // Convert the variable speed_of_scrolling to a string
  char speed_of_scrolling_str[MAX_FACTOR_STR_LEN] = "";
  sprintf(speed_of_scrolling_str, "%9Lf", speed_of_scrolling);
  // Convert frame_rate to a string
  char frame_rate_str[MAX_FRAMERATE] = "";
  sprintf(frame_rate_str, "%d", frame_rate);
  strcat(ffmpeg_exec, FFMPEG_STATIC_BUILD_LATEST_PATH);
  char option_tblend[10];

  // If the answer is not YES, then set the choose_tblend to 0.
  if(choose_tblend != 1) {
    strcpy(option_tblend, "");
  }

  else {
    strcpy(option_tblend, ",tblend");
  }

  //.mov will be appended to the output file and the output will be produced in the QuickTime .mov container.
  /* ffmpeg -f lavfi -i color=s=1920x1080 -loop 1 -t 1.5 -i "long-outro.png" -filter_complex "[1:v]scale=1920:-2,setpts=if(eq(N\,0)\,0\,1+1/0.005/TB),fps=25[fg]; [0:v][fg]overlay=y=-'t*h*0.005':eof_action=endall[v]" -map "[v]" long-outro.MOV */
  sprintf(command, "%s -f lavfi -i color=s=1920x1080 -loop 1 -t %f -i %s -filter_complex \"[1:v]scale=1920:-2,setpts=if(eq(N\\,0)\\,0\\,1+1/%s/TB),fps=%s%s[fg]; [0:v][fg]overlay=y=-'t*h*%s':eof_action=endall[v]\" -map \"[v]\" %s", ffmpeg_exec, DURATION_OF_THE_COLOR_INPUT_STREAM, input_png, speed_of_scrolling_str, frame_rate_str, option_tblend, speed_of_scrolling_str, output_video_1);
  // debug printf
  printf("%s\n\n", command);
  system(command);
}

void merge(char *input_video, char *input_mask, char *output_png_video_w_real_alpha_channel_1) {
  char command[MAXBUFFSIZE];
  char ffmpeg_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  strcat(ffmpeg_exec, FFMPEG_STATIC_BUILD_LATEST_PATH);
  //.mov will be appended to the output file and the output will be produced in the QuickTime .mov container.
  /* ffmpeg -i long-outro.MOV -i long-outro-m.MOV -filter_complex "[0:v][1:v]alphamerge" -shortest -c:v png -an merged-alpha-vid.mov */
  sprintf(command, "%s -i %s -i %s -filter_complex \"[0:v][1:v]alphamerge\" -shortest -c:v png -q:v 0 -an %s", ffmpeg_exec, input_video, input_mask, output_png_video_w_real_alpha_channel_1);
  // debug printf
  printf("%s\n\n", command);
  system(command);
}

void intermediate_file_cleanup_w_trash_cli(char *temp_file) {
  char command[MAXBUFFSIZE];
  char trash_cli_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  char platform[10] = "";
  strcpy(platform, PLATFORM_NAME);

  if(strcmp(platform, "Windows") == 0) {
    strcat(trash_cli_exec, "del");
  }

  else {
    strcat(trash_cli_exec, "trash");
  }

  sprintf(command, "%s %s", trash_cli_exec, temp_file);
  // debug printf
  printf("%s\n\n", command);
  system(command);
}

void dumpXMLToFile(const char *filename, const char *xmlContent) {
  FILE *file = fopen(filename, "w");

  if(file == NULL) {
    printf("Error opening file!\n");
    return;
  }

  fprintf(file, "%s", xmlContent);
  fclose(file);
}

/*
  Returns -1 on failure and 0 on success.
  Use the function as follows:
  const char *programToCheck = "ffmpeg --help";
  int result = checkAvailability(programToCheck);

  if(result == 0) {
  printf("%s is available in the PATH!\n", programToCheck);
  }

  else {
  printf("%s is NOT available in the PATH.\n", programToCheck);
  }
*/
int checkAvailability(const char *programName) {
  char command[100];
  sprintf(command, "%s", programName);

  if(system(command) == 0) {
    return 0;
  }

  else {
    return -1;
  }
}

int main(int argc, char *argv[]) {
  if(argc != 3) {
    fprintf(stderr, "Usage: %s <input_png> <input_mask>\n", argv[0]);
    printf("You need to prepare your scroller image in the SVG format.\nHere's the template for you which you can edit with Inkscape:\n");
    const char *template_svg_fileName = "scroller-template.svg"; // Define the file name
    // Call the function to dump XML content to the file
    dumpXMLToFile(template_svg_fileName, predefinedXML);
    printf("XML dumped to %s\n", template_svg_fileName);
    printf("\nWARNING: The auto-generated SVG template will be overwritten in the next run.\nRename the file before editing it with Inkscape.\n");
    return 1;
  }

  const char *latestFFMPEGstaticBuildToCheck = "--help";
  const char *programTRASH_CLIToCheck = "trash --help";
  char command[MAXBUFFSIZE];
  char ffmpeg_exec[MAXPATHLEN] = "\0"; // https://stackoverflow.com/questions/18838933/why-do-i-first-have-to-strcpy-before-strcat
  strcat(ffmpeg_exec, FFMPEG_STATIC_BUILD_LATEST_PATH);
  sprintf(command, "%s %s", ffmpeg_exec, latestFFMPEGstaticBuildToCheck);
  printf("%s\n\n", command); // debug printf
  int result = -1;
  result = checkAvailability(command);

  if(result == 0) {
    printf("%s is available in the PATH!\n", command);
  }

  else {
    printf("%s is NOT available in the PATH.\n", command);
    printf("Please download and extract the FFMPEG Static Build archive from https://ffmpeg.org/download.html and set the FFMPEG_STATIC_BUILD_LATEST_PATH variable in the script.\n");
    exit(1);
  }

  // https://github.com/andreafrancia/trash-cli
  char platform[10] = "";
  strcpy(platform, PLATFORM_NAME);

  if(strcmp(platform, "nix") == 0) {
    result = -1;
    result = checkAvailability(programTRASH_CLIToCheck);

    if(result == 0) {
      printf("%s is available in the PATH!\n", programTRASH_CLIToCheck);
    }

    else {
      printf("%s is NOT available in the PATH.\n", programTRASH_CLIToCheck);
      printf("Please install 'trash-cli' on your system. https://github.com/andreafrancia/trash-cli\n");
      exit(1);
    }
  }

  // Ask the users whether they want to merge the videos and produce the final video with an alpha channel.
  printf("Do you plan to time-remap the scrolling title later in your NLE? Almost all NLEs have a feature to time remap videos, but some NLEs load the mask from a separate file in the mask filter section instead of treating a dedicated track as the matte track. Shotcut is one notable mention. In that instance, the NLE does not scale up/down the time of the loaded mask properly. An integrated video file with a premultiplied alpha channel is ideal if that is the case.\n");
  printf("\nDo you want to merge the scroller with the matte and produce a final video with a premultiplied alpha channel? (y/n) ");
  char user_input;
  scanf("%c", &user_input);
  // Ask the users to submit a frame rate.
  printf("Celluloid movies usually go with 24 FPS. 25 FPS is the standard for PAL TVs and 29.97 (~ 30) FPS for the NTSC.\nFILM=24, PAL=25, NTSC=30.\n");
  printf("Choose a frame rate: ");
  int frame_rate;
  scanf("%d", &frame_rate);
  printf("\n"); // newline
  // Ask the users to choose a scrolling speed multiplication factor.
  // 0.000625 = 1x
  // Reasonable = 8x
  printf("Scrolling at the 8x speed makes the video look natural in most scenarios, where 1x means 0.000625.\n");
  printf("You can always press CTRL+c to stop the process and check the speed from the incomplete scrolling video rendered.\n");
  printf("Choose a multiplication factor (the speed of the scrolling).\nType a number (can be fractional): ");
  long double factor;
  scanf("%9Lf", &factor);
  factor = factor * 0.000625;
  printf("\n"); // newline
  // Ask the users whether they want to add a slight motion blur.
  printf("Would you like to add a slight motion blur?\n");
  printf("With this option, if you press CTRL+c to stop the process you won't be able to watch the partly finished video. Type 1 (ONE) to say YES. (1/0): ");
  int choose_tblend = 0;
  scanf("%d", &choose_tblend);
  printf("\n"); // newline

  // If the answer is not YES, then set the choose_tblend to 0.
  if(choose_tblend != 1) {
    choose_tblend = 0;
  }

  char *input_png = argv[1];
  char *input_mask = argv[2];
  strcpy(output_alpha_mask_video, input_png);
  strcat(output_alpha_mask_video, "-mask.mov");
  // debug printf
  /*printf("%s\n", output_alpha_mask_video);*/
  strcpy(output_video, input_png);
  strcat(output_video, ".mov");
  // debug printf
  /*printf("%s\n", output_video);*/
  strcpy(output_png_video_w_real_alpha_channel, output_video);
  strcat(output_png_video_w_real_alpha_channel, "-PNG-alpha.mov");
  // debug printf
  /*printf("%s\n", output_png_video_w_real_alpha_channel);*/
  printf("\n"); // newline
  scroller_mask(input_mask, output_alpha_mask_video, frame_rate, factor, choose_tblend);
  scroller(input_png, output_video, frame_rate, factor, choose_tblend);

  if(user_input == 'y') {
    printf("Merging the videos and producing the final video with an alpha channel...\n");
    merge(output_video, output_alpha_mask_video, output_png_video_w_real_alpha_channel);
    intermediate_file_cleanup_w_trash_cli(output_alpha_mask_video);
    intermediate_file_cleanup_w_trash_cli(output_video);
  }

  return 0;
}

