#!/usr/bin/c -Wall -Wextra -pedantic --


/*
  Licence Conditions: MIT License.
  https://opensource.org/licenses/MIT
*/

/*
  c: Use C as a shell scripting language:
  https://github.com/ryanmjacobs/c
*/

/*
  Installation (*-ubuntu):
  sudo apt install build-essential
  sudo apt install trash-cli
  cd ~/
  wget https://raw.githubusercontent.com/ryanmjacobs/c/master/c
  sudo install -m 755 c /usr/bin/c
  trash c
*/

/*
  An example script that takes an input (app
  name) and searches for the same from Ubuntu's
  software repository.
  Feel free to write your own.
  Usage:
  chmod +x script.c
  ./script.c app-name
*/

// Restrict to UNIX-like systems only
#if !( defined( __unix__ ) || defined(_POSIX_VERSION) )
  #error "For UNIX-like Operating Systems Only"
#endif

#define MAX_LENGTH_OF_OUTPUT 1000000

// Necessary headers from the standard library
#include <stdio.h> // req. by standard input-output
#include <stdlib.h> // contains the fn. system()
#include <string.h> // req. by string operations like strcat()

int main(int argc, char **argv)  {
  char apt_search[MAX_LENGTH_OF_OUTPUT] = "apt search "; //Edit this section to change the command
  char *search_query;
  int retrnval;
  printf("Script name: %s\n", *argv);
  printf("Type the program name you're searching\nfrom the repository before running the script.\n");
  printf("To do that, type (example): ./script.c app-name\n");

  if(argc == 2) {
    printf("The argument supplied is %s\n", *(argv + 1));
    search_query = *(argv + 1);
    strcat(apt_search, search_query);
    printf("%s\n", apt_search);
    retrnval = system(apt_search);

    if(retrnval == 0) {
      printf("Search successful.\n");
    }
  }

  else if(argc > 2) {
    printf("Too many arguments supplied.\n");
  }

  else {
    printf("One argument expected.\n");
  }

  return 0;
}
