// Last Change: 2023-08-22  Tuesday: 08:16:54 PM

// sudo apt install libgtk-3-dev
// dpkg --status libgtk-3-dev
// dpkg --listfiles libgtk-3-dev
// gcc -O2 -Wall -Wextra -pedantic -o phonemnt phonemnt.c `pkg-config --cflags --libs gtk+-3.0` -Wl,-Bstatic -Wl,-Bdynamic -lpthread -lm -s
/*
  Installation:
  BASH Shell:
  Open $HOME/.bashrc or $HOME/.bash_aliases with a text editor and
  paste the following line in the beginning:
  export PATH="$HOME/.local/bin/:$PATH"
  Fish Shell:
  Open $HOME/.config/fish/config.fish with a text editor and
  paste the following lines in the beginning:
  # --------------
  # $HOME/.local/bin
  export PATH="$HOME/.local/bin/:$PATH"
  export PATH
  # --------------
  Run: source $HOME/.config/fish/config.fish to reload the configuration.
  Now, compile this program and run the command given below.
  install -m +x phonemnt $HOME/.local/bin
  Delete the file from the current working dir: rm phonemnt
*/

// Restrict to UNIX-like systems only
#if !( defined( __unix__ ) || defined(_POSIX_VERSION) || defined(__debian__) )
  #error "For UNIX-like Operating Systems Only"
#endif

#include <gtk/gtk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h> // Include the header for mkdir function
#include <unistd.h>
#include <errno.h>

#define  MAXPATH  1024 // Maximum path length

void create_tmp_phone_dir(void);
void button_clicked(GtkWidget *widget, gpointer data);

void create_tmp_phone_dir(void) {
  /*printf("create_tmp_phone_dir\n");*/
  char dirname0[] = "/tmp";
  char dirname1[] = "/phone";
  char target[MAXPATH] = "";
  // https://www.demo2s.com/c/c-username-getenv-user.html
  char *username = NULL;
  username = getenv("USER");

  if(NULL != username) {
    printf("username '%s'\n", username);
  }

  strncat(target, "/home/", MAXPATH - 1);
  strncat(target, username, MAXPATH - 1);
  strncat(target, dirname0, MAXPATH - 1);
  printf("target dir = %s\n", target);

  // Create the directory using mkdir()
  // First, the program creates a directory ~/tmp
  if(mkdir(target, 0755) == -1 && errno != EEXIST) {
    perror("Failed to create directory\n");
  }

  else {
    printf("Directory created successfully\n");
  }

  strncat(target, dirname1, MAXPATH - 1);
  printf("target dir = %s\n", target);

  // Create the directory using mkdir()
  // The program creates a directory ~/tmp/phone
  if(mkdir(target, 0755) == -1 && errno != EEXIST) {
    perror("Failed to create directory\n");
  }

  else {
    printf("Directory created successfully\n");
  }
}

// Function to handle the "clicked" signal of the buttons
void button_clicked(GtkWidget *widget, gpointer data) {
  const char *button_label = (const char *)data;

  if(strcmp(button_label, "Button 1") == 0) {
    g_print("Button 1 clicked\n");
    system("jmtpfs ~/tmp/phone"); // Mount the filesystem from the phone.
  }

  // Add similar logic for other buttons...
  if(strcmp(button_label, "Button 2") == 0) {
    g_print("Button 2 clicked\n");
    system("fusermount -u ~/tmp/phone"); // Unount the filesystem from the phone.
  }
}

int main(int argc, char *argv[]) {
  /* Directory creation part. ~/tmp/phone */
  /*printf("main\n");*/
  char dirname0[] = "/tmp";
  char dirname1[] = "/phone";
  char target[MAXPATH] = "";
  // https://www.demo2s.com/c/c-username-getenv-user.html
  char *username = NULL;
  username = getenv("USER");

  if(NULL == username) {
    printf("Cannot get username\n");
  }

  else {
    strncat(target, "/home/", MAXPATH - 1);
    strncat(target, username, MAXPATH - 1);
    strncat(target, dirname0, MAXPATH - 1);
    strncat(target, dirname1, MAXPATH - 1);
    /*printf("target dir = %s\n", target);*/
  }

  // check whether the directory ~/tmp/phone exists or not
  if(access(target, F_OK) == -1) { // Check whether the directory exists
    // if not, create it
    create_tmp_phone_dir();
  }

  else {
    printf("Directory already exists\n");
  } /* (END) Directory creation part. ~/tmp/phone */

  gtk_init(&argc, &argv); // Initialize GTK
  GtkWidget *window, *button1, *button2;
  // Create the main window
  window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "Mount/Unmount phone storage");
  gtk_container_set_border_width(GTK_CONTAINER(window), 10);
  gtk_widget_set_size_request(window, 150, 100);
  g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
  // Create the buttons
  button1 = gtk_button_new_with_label("Mount the phone filesystem."); // Mount the filesystem from the phone.
  button2 = gtk_button_new_with_label("Unmount the phone filesystem."); // Unount the filesystem from the phone.
  // Connect the "clicked" signal to the button_clicked function
  g_signal_connect(button1, "clicked", G_CALLBACK(button_clicked), "Button 1");
  g_signal_connect(button2, "clicked", G_CALLBACK(button_clicked), "Button 2");
  // Create a vertical box layout and add buttons to it
  GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
  gtk_box_pack_start(GTK_BOX(vbox), button1, TRUE, TRUE, 0);
  gtk_box_pack_start(GTK_BOX(vbox), button2, TRUE, TRUE, 0);
  // Add the layout to the main window
  gtk_container_add(GTK_CONTAINER(window), vbox);
  // Show all widgets
  gtk_widget_show_all(window);
  // Start the GTK main loop
  gtk_main();
  return 0;
}

