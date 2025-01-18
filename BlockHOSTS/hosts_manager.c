// Last Change: 2025-01-18  Saturday: 08:10:01 PM
/*
  Assited by Anthropic Claude 3.5 Sonnet.
  2025.01.15
*/

/*
  This program automates the process of updating and maintaining a
  custom hosts file for network traffic control.
  It downloads a curated blocklist from a specified URL, combines it with
  local host configurations and custom
  block lists, and updates the system's hosts file.
  The program creates timestamped backups of each update,
  providing a history of changes and allowing for easy rollback if needed.
  After updating the hosts file, it
  automatically restarts the name service caching daemon (nscd) to apply
  the changes immediately.
*/

/*
  https://github.com/StevenBlack/hosts.git
  Consolidating and extending hosts files from several well-curated sources.
*/

/*
  Required files:
  1. hosts.backup.txt
  2. hosts_config.txt (use the relevant URL from https://github.com/StevenBlack/hosts.git based on your needs)
  3. hosts-Win10-default.txt
  4. Personal-hosts-blocklist.txt (modify as needed)
*/

/*
  Installation:
  Requirements: 1. GCC. 2. CMake 3.10 or higher.

  cd BlockHOSTS

  For debug build:
  mkdir -p build
  cd build
  cmake -DCMAKE_BUILD_TYPE=Debug ..
  make
  sudo make install
  sudo chmod -R 755 $HOME/.config/hosts_manager/
  755: Only owner can write, read and execute
  https://linuxize.com/post/chmod-command-in-linux/
  https://linuxhandbook.com/chmod-command/

  For release build:
  mkdir -p build
  cd build
  cmake -DCMAKE_BUILD_TYPE=Release ..
  make
  sudo make install
  sudo chmod -R 755 $HOME/.config/hosts_manager/
  755: Only owner can write, read and execute
  https://linuxize.com/post/chmod-command-in-linux/
  https://linuxhandbook.com/chmod-command/

  Alternatively, install manually using the provided x86_x64 build:
  cd BlockHOSTS
  mkdir $HOME/.config/hosts_manager/
  mkdir -p $HOME/.local/bin
  cp hosts.backup.txt hosts_config.txt hosts-Win10-default.txt Personal-hosts-blocklist.txt $HOME/.config/hosts_manager
  sudo install -m 755 build/hosts_manager $HOME/.local/bin

  NOTE: Note on Editing Network Configuration Files with Superuser Privilege
  Using Advanced Text Editor Tools in Linux Operating Systems:

  It is imperative for users to understand that future alterations or edits
  made to certain critical system files, namely `hosts_config.txt` and
  'Personal-hosts-blocklist.txt', necessitate elevated permissions beyond the
  standard user privileges typically used within a Linux environment.
  These sensitive changes must be conducted by an individual
  with superuser (root) privilege for security reasons as well as
  to maintain consistent system integrity throughout its operation.

  To initiate these modifications, one is required to access and execute text
  editor commands using root authority; henceforth, it becomes essential that
  users possess the 'sudo' command knowledge or equivalent privileges
  within their accounts hierarchy—this grants them conditional execution of
  text editors with superuser permissions without necessitating
  a consistent state of elevated status.

  As an example, to open and edit `hosts_config.txt` using Vim editor
  under root user privilege conditions in your terminal:

  sudo vim $HOME/.config/hosts_manager/hosts_config.txt

  Or alternatively, use nano text editor for `Personal-hosts-blocklist.txt`:

  sudo nano /path/to/Personal-hosts-blocklist.txt # Replace with the accurate
                                                # absolute or relative path where
                                                # the file is located.
                                                # Ensure that the correct file
                                                # location replaces
                                                # '/path/to' in this command

  Always remember to adhere strictly to all system policy
  guidelines and maintain vigilance when handling these files—incorrect or
  negligent edits can potentially lead to severe
  disruptions within network services.
*/

// Restrict to UNIX-like systems only
#if !( defined( __unix__ ) || defined(_POSIX_VERSION) )
  #error "For UNIX-like Operating Systems Only"
#endif

#define  _POSIX_C_SOURCE 200809L
#define  _XOPEN_SOURCE 500L
// https://stackoverflow.com/questions/18792489/how-to-create-a-temporary-directory-in-c-in-linux

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>
#include <time.h>

#define MAX_CMD_LENGTH 4096
#define MAX_LINE_LENGTH 500000
#define MAX_PATH_LENGTH 4096
#define CURL_TIMEOUT 30
#define CONFIG_FILE "hosts_config.txt"
/*
  Block everything without social media sites.
  File: hosts_config.txt
  Customise according to your preferences.
  https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
*/
#define CONFIG_DIR_NAME ".config/hosts_manager"
#define MAX_FILENAME_LENGTH 512

/* Prototype declaration */
char *get_config_dir(void);
char *find_file(const char *filename);
char *read_url_from_config(void);
void get_timestamp(char *timestamp, size_t size);
int execute_command(const char *cmd);
int file_exists(const char *filename);
int concatenate_files(const char *output_file, const char *files[], int file_count);

/* Function definitions */

char *get_config_dir(void) {
  static char config_path[MAX_PATH_LENGTH];
  const char *home = getenv("HOME");

  if(!home) {
    fprintf(stderr, "Error: Could not get HOME directory\n");
    return NULL;
  }

  snprintf(config_path, sizeof(config_path), "%s/%s", home, CONFIG_DIR_NAME);
  // Create directory if it doesn't exist
  struct stat st = {0};

  if(stat(config_path, &st) == -1) {
    // Create the .config directory first if it doesn't exist
    char config_base[MAX_PATH_LENGTH];
    snprintf(config_base, sizeof(config_base), "%s/.config", home);

    if(stat(config_base, &st) == -1) {
      if(mkdir(config_base, 0755) == -1) {
        fprintf(stderr, "Error: Could not create .config directory\n");
        return NULL;
      }
    }

    // Now create our application directory
    if(mkdir(config_path, 0755) == -1) {
      fprintf(stderr, "Error: Could not create config directory %s\n", config_path);
      return NULL;
    }
  }

  return config_path;
}

// Function to find a file in either current directory or config directory
char *find_file(const char *filename) {
  static char file_path[MAX_PATH_LENGTH];

  // First try current directory
  if(file_exists(filename)) {
    return (char *)filename;
  }

  // Then try config directory
  char *config_dir = get_config_dir();

  if(config_dir) {
    snprintf(file_path, sizeof(file_path), "%s/%s", config_dir, filename);

    if(file_exists(file_path)) {
      return file_path;
    }
  }

  return NULL;
}

// Function to read URL from config file
char *read_url_from_config(void) {
  char *config_path = find_file(CONFIG_FILE);

  if(!config_path) {
    fprintf(stderr, "Error: Cannot find config file %s in current directory or %s\n",
            CONFIG_FILE, get_config_dir());
    return NULL;
  }

  else {
    fprintf(stderr, "Error: config file %s in current directory or %s\n",
            CONFIG_FILE, get_config_dir());
  }

  FILE *fp = fopen(config_path, "r");

  if(!fp) {
    fprintf(stderr, "Error: Cannot open config file %s\n", config_path);
    return NULL;
  }

  static char url[MAX_LINE_LENGTH];

  if(fgets(url, sizeof(url), fp) == NULL) {
    fclose(fp);
    return NULL;
  }

  // Remove trailing newline if present
  url[strcspn(url, "\n")] = 0;
  fclose(fp);
  return url;
}

// Function to generate timestamp string
void get_timestamp(char *timestamp, size_t size) {
  time_t now;
  struct tm *tm_info;
  time(&now);
  tm_info = localtime(&now);
  strftime(timestamp, size, "%y_%m_%d_%I_%M_%S_%p", tm_info);
}

// Function to execute system command and check result
int execute_command(const char *cmd) {
  printf("Executing: %s\n", cmd);
  int result = system(cmd);

  if(result != 0) {
    fprintf(stderr, "Error executing command: %s\n", cmd);
    return 0;
  }

  return 1;
}

// Function to check if file exists and is readable
int file_exists(const char *filename) {
  FILE *fp = fopen(filename, "r");

  if(fp) {
    fclose(fp);
    return 1;
  }

  return 0;
}

// Function to concatenate files with logging
int concatenate_files(const char *output_file, const char *files[], int file_count) {
  FILE *outfp = fopen(output_file, "w");

  if(!outfp) {
    fprintf(stderr, "Error: Cannot create output file %s\n", output_file);
    return 0;
  }

  printf("\nConcatenating files to %s:\n", output_file);
  char line[MAX_LINE_LENGTH];
  int total_lines = 0;

  for(int i = 0; i < file_count; i++) {
    int file_lines = 0;
    FILE *fp = fopen(files[i], "r");

    if(!fp) {
      fprintf(stderr, "Warning: Cannot open file %s\n", files[i]);
      continue;
    }

    printf("Processing %s...\n", files[i]);

    while(fgets(line, sizeof(line), fp)) {
      fputs(line, outfp);
      file_lines++;
    }

    printf("- Added %d lines from %s\n", file_lines, files[i]);
    total_lines += file_lines;
    fclose(fp);
  }

  printf("Total lines written: %d\n\n", total_lines);
  fclose(outfp);
  return total_lines > 0;
}

int main(void) {
  char downloaded_hosts[MAX_PATH_LENGTH];
  char temp_dir[MAX_PATH_LENGTH];
  // Read URL from config file
  char *url = read_url_from_config();

  if(!url) {
    fprintf(stderr, "Error: Could not read URL from config file\n");
    return 1;
  }

  // Create temporary directory for downloads
  strcpy(temp_dir, "/tmp/hosts_XXXXXX");

  if(mkdtemp(temp_dir) == NULL) {
    fprintf(stderr, "Error creating temporary directory\n");
    return 1;
  }

  // Set path for downloaded hosts file
  if(snprintf(downloaded_hosts, sizeof(downloaded_hosts), "%s/downloaded_hosts.txt", temp_dir) >= (int)sizeof(downloaded_hosts)) {
    fprintf(stderr, "Error: Path too long for downloaded hosts file\n");
    return 1;
  }

  char cmd[MAX_CMD_LENGTH];

  // Download hosts file
  if(snprintf(cmd, sizeof(cmd), "curl --max-time %d \"%s\" --output \"%s\"",
              CURL_TIMEOUT, url, downloaded_hosts) >= (int)sizeof(cmd)) {
    fprintf(stderr, "Error: Command string too long\n");
    return 1;
  }

  if(!execute_command(cmd)) {
    return 1;
  }

  // Verify download was successful
  if(!file_exists(downloaded_hosts)) {
    fprintf(stderr, "Error: Downloaded hosts file not found at %s\n", downloaded_hosts);
    return 1;
  }

  // Define input files in order
  const char *input_files_names[] = {
    "hosts.backup.txt",
    "hosts-Win10-default.txt",
    "Personal-hosts-blocklist.txt",
    downloaded_hosts  // Use the full path to downloaded file
  };
  // Define input files with actual path as a copy in proper order
  const char *input_files_w_path[4];

  // Fill the above array with NULL
  for(int i = 0; i < 4; i++) {
    input_files_w_path[i] = NULL;
  }

  const int file_count = sizeof(input_files_names) / sizeof(input_files_names[0]);
  char *resolved_paths[4];  // To store the actual paths
  const char *input_files[4];  // Final array for concatenate_files
  input_files[file_count - 1] = downloaded_hosts;  // Add the downloaded file path
  // Check if required local files exist
  printf("\nChecking required files:\n");

  for(int i = 0; i < file_count - 1; i++) {   // Exclude downloaded file from check
    resolved_paths[i] = find_file(input_files_names[i]);
    input_files[i] = resolved_paths[i] ? resolved_paths[i] : input_files_names[i];

    if(!file_exists(input_files[i])) {
      fprintf(stderr, "Warning: Required file %s not found\n", input_files[i]);
    }

    else {
      printf("Found %s\n", input_files[i]);
    }
  }

  // The file_count loop:
  for(int i = 0; i < file_count; i++) {
    resolved_paths[i] = find_file(input_files_names[i]);
    input_files[i] = resolved_paths[i] ? resolved_paths[i] : input_files_names[i];
    printf("Resolved path for %s: %s\n", input_files_names[i], input_files[i]);  // Debugging
    // Copy the content of input_files to input_files_w_path
    input_files_w_path[i] = strdup(input_files[i]); // Use strdup to create a copy
    // printf("input_files_w_path for %s: %s\n", input_files_names[i], input_files_w_path[i]);  // Debugging
  }

  // Debugging: Print all input files
  printf("\nInput files to concatenate:\n");

  for(int i = 0; i < file_count; i++) {
    printf("File %d: %s\n", i + 1, input_files_w_path[i]);
  }

  // Generate timestamp for backup filename
  char timestamp[MAX_FILENAME_LENGTH];
  get_timestamp(timestamp, sizeof(timestamp));
  char backup_filename[MAX_FILENAME_LENGTH];

  // Fix for the backup filename:
  if(snprintf(backup_filename, sizeof(backup_filename), "hosts_%s", timestamp) >= (int)sizeof(backup_filename)) {
    fprintf(stderr, "Error: Backup filename too long\n");
    return 1;
  }

  // Concatenate all files to timestamped backup
  if(!concatenate_files(backup_filename, input_files_w_path, file_count)) {
    fprintf(stderr, "Error concatenating files\n");
    return 1;
  }

  // Verify the backup file was created and has content
  struct stat st;

  if(stat(backup_filename, &st) != 0 || st.st_size == 0) {
    fprintf(stderr, "Error: Backup file is empty or not created\n");
    return 1;
  }

  // Copy timestamped file to /etc/hosts
  snprintf(cmd, sizeof(cmd), "sudo cp %s /etc/hosts", backup_filename);

  if(!execute_command(cmd)) {
    return 1;
  }

  // Create a local copy with timestamp
  printf("Created backup file: %s\n", backup_filename);
  // Restart nscd service
  snprintf(cmd, sizeof(cmd), "sudo service nscd restart");

  if(!execute_command(cmd)) {
    return 1;
  }

  // Cleanup temporary directory
  if(snprintf(cmd, sizeof(cmd), "rm -rf %s", temp_dir) >= (int)sizeof(cmd)) {
    fprintf(stderr, "Error: Cleanup command too long\n");
    return 1;
  }

  if(!execute_command(cmd)) {
    return 1;
  }

  printf("\nHosts file successfully updated!\n");
  printf("You can check the contents of %s to verify the update\n", backup_filename);
  return 0;
}

/*
  The program performs the following operations in sequence:
  1. Reads a URL from a configuration file (hosts_config.txt)
  2. Creates a secure temporary directory for downloaded content
  3. Downloads the remote hosts file using curl with a timeout
  4. Verifies the existence of required local configuration files:
   - hosts.backup.txt: Basic host configurations
   - hosts-Win10-default.txt: Windows 10 specific host entries
   - Personal-hosts-blocklist.txt: User's custom block rules
  5. Concatenates all host files in a specific order to maintain priority
  6. Creates a timestamped backup of the new hosts file
  7. Copies the new configuration to /etc/hosts using sudo
  8. Restarts the nscd service to apply changes
  9. Cleans up temporary files and directories
  The program includes extensive error checking and logging to ensure
  reliable operation
  and maintainability.
*/
