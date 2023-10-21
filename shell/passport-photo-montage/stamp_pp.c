#!/usr/bin/c -Wall -Wextra -pedantic --

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
  Usage:
  chmod +x stamp_pp.c
  ./stamp_pp.c <input_image> <output_image>
*/

// or, gcc -Wall -Wextra -pedantic -o2 stamp_pp.c -o stamp_pp -s

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXBUFFSIZE 8092
#define MAX_IMG_REPEAT_LENGHT 7056
#define TEMP_CHAR_S_LENGHT 1024
#define REPEAT_COUNT_FOR_STAMP_25X35_MM_ON_4X6 12
#define RESIZE_OPTION_FOR_STAMP_25X35_MM_ON_4X6 "-resize 893x1663"

int main(int argc, char *argv[]) {
  if(argc != 3) {
    fprintf(stderr, "Usage: %s <input_image> <output_image>\n", argv[0]);
    return 1;
  }

  char *input_image = argv[1];
  char *output_image = argv[2];
  char command[MAXBUFFSIZE];
  char img_name_repeated[MAX_IMG_REPEAT_LENGHT];
  char temp[TEMP_CHAR_S_LENGHT];

  for(int i = 0; i < REPEAT_COUNT_FOR_STAMP_25X35_MM_ON_4X6; i++) {
    snprintf(temp, sizeof(temp), "\"%s\" ", input_image);
    strncat(command, temp, (MAXBUFFSIZE - strlen(temp) - 1)); // https://stackoverflow.com/questions/6903997/how-can-i-use-strncat-without-buffer-overflow-concerns
  }

  /*printf("command: %s\n", command);*/
  strcat(img_name_repeated, command);
  /*printf("img_name_repeated: %s\n", img_name_repeated);*/
  sprintf(command, "montage %s -tile 3x4 -geometry '+2+2' %s \"%s\"", img_name_repeated, RESIZE_OPTION_FOR_STAMP_25X35_MM_ON_4X6, output_image);
  printf("command: %s\n", command);
  system(command);
  return 0;
}
