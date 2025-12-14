/*
   PDF Processing Automation Suite
   ================================

   Developed by: DeepSeek AI Assistant (https://chat.deepseek.com/)
   Creation Date: December 14, 2025
   Creation Time: 19:05 IST (Indian Standard Time)


   License: MIT-0 (MIT No Attribution)
   This software is provided "as is", without warranty of any kind, express or
   implied. Permission is hereby granted, free of charge, to any person obtaining
   a copy of this software and associated documentation files to use, copy,
   modify, merge, publish, distribute, sublicense, and/or sell copies without
   requiring attribution.

   Acknowledgements:
   - Built upon standard C libraries and Unix system calls
   - Integrates with external tools: ImageMagick, ocrmypdf, poppler-utils
   - Inspired by real-world document digitisation workflows

   Version: 1.1.0
   Last Modified: December 14, 2025
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <libgen.h>
#include <limits.h>
#include <errno.h>

#define MAX_FILES 1000
#define MAX_PATH 4096
#define PDF_EXT ".pdf"
#define OCR_SUFFIX "-ocr"
#define COMBINED_SUFFIX "-combined"

typedef struct {
  char original_name[MAX_PATH];
  char pdf_name[MAX_PATH];
  char ocr_name[MAX_PATH];
  int sequence;  // For sorting
} FileInfo;

int file_count = 0;
FileInfo files[MAX_FILES];

// Function declarations
int collect_jpg_files(const char *dir_path);
void remove_extension(char *filename);
int run_command(const char *cmd);
int convert_to_pdf(const char *jpg_file, const char *pdf_file);
int ocr_pdf(const char *input_pdf, const char *output_pdf);
int combine_pdfs(const char *output_name);
int cleanup_intermediate_files();
void print_usage(const char *program_name);
int compare_files(const void *a, const void *b);
int safe_delete(const char *filename);
void safe_delete_files(const char **filenames, int count);

int main(int argc, char *argv[]) {
  if(argc != 2) {
    print_usage(argv[0]);
    return 1;
  }

  char *input_dir = argv[1];
  printf("Starting PDF processing pipeline in directory: %s\n", input_dir);
  // Step 1: Collect all JPG files
  printf("\nStep 1: Collecting JPG files...\n");

  if(collect_jpg_files(input_dir) <= 0) {
    printf("No JPG files found in directory: %s\n", input_dir);
    return 1;
  }

  printf("Found %d JPG files.\n", file_count);
  // Sort files by name to maintain sequence
  qsort(files, file_count, sizeof(FileInfo), compare_files);
  // Display processing order
  printf("\nProcessing order:\n");

  for(int i = 0; i < file_count; i++) {
    printf("  %d. %s\n", i + 1, files[i].original_name);
  }

  // Step 2: Process each file
  printf("\nStep 2: Processing files...\n");

  for(int i = 0; i < file_count; i++) {
    printf("\nProcessing file %d/%d: %s\n", i + 1, file_count, files[i].original_name);
    // Convert JPG to PDF
    printf("  Converting to PDF...\n");

    if(convert_to_pdf(files[i].original_name, files[i].pdf_name) != 0) {
      fprintf(stderr, "Failed to convert %s to PDF\n", files[i].original_name);
      continue;
    }

    // OCR the PDF
    printf("  Running OCR...\n");

    if(ocr_pdf(files[i].pdf_name, files[i].ocr_name) != 0) {
      fprintf(stderr, "Failed to OCR %s\n", files[i].pdf_name);
      continue;
    }

    // Remove original JPG and intermediate PDF
    printf("  Cleaning up intermediate files...\n");
    const char *files_to_delete[] = {
      files[i].original_name,
      files[i].pdf_name
    };
    safe_delete_files(files_to_delete, 2);
  }

  // Step 3: Combine all OCR'd PDFs
  printf("\nStep 3: Combining PDF files...\n");
  char combined_name[MAX_PATH];
  snprintf(combined_name, sizeof(combined_name), "all-documents%s.pdf", COMBINED_SUFFIX);

  if(combine_pdfs(combined_name) == 0) {
    printf("Successfully created combined PDF: %s\n", combined_name);
  }

  else {
    fprintf(stderr, "Failed to combine PDFs\n");
    return 1;
  }

  // Step 4: Final cleanup
  printf("\nStep 4: Final cleanup...\n");
  cleanup_intermediate_files();
  printf("\nProcessing completed successfully!\n");
  printf("Output file: %s\n", combined_name);
  return 0;
}

int compare_files(const void *a, const void *b) {
  const FileInfo *file_a = (const FileInfo *)a;
  const FileInfo *file_b = (const FileInfo *)b;
  // Use strcoll for locale-aware string comparison
  return strcoll(file_a->original_name, file_b->original_name);
}

int collect_jpg_files(const char *dir_path) {
  DIR *dir;
  struct dirent **namelist;
  // Use scandir to get sorted list
  int n = scandir(dir_path, &namelist, NULL, alphasort);

  if(n < 0) {
    perror("Error scanning directory");
    return -1;
  }

  // Change to the target directory
  if(chdir(dir_path) != 0) {
    perror("Error changing directory");
    free(namelist);
    return -1;
  }

  for(int i = 0; i < n && file_count < MAX_FILES; i++) {
    // Check if file has .jpg or .jpeg extension (case-insensitive)
    char *ext = strrchr(namelist[i]->d_name, '.');

    if(ext != NULL) {
      int is_jpg = (strcasecmp(ext, ".jpg") == 0) || (strcasecmp(ext, ".jpeg") == 0);

      if(is_jpg) {
        // Store file information
        strncpy(files[file_count].original_name, namelist[i]->d_name, MAX_PATH - 1);
        files[file_count].original_name[MAX_PATH - 1] = '\0';
        // Create PDF filename (remove extension, add .pdf)
        char base_name[MAX_PATH];
        strncpy(base_name, namelist[i]->d_name, MAX_PATH - 1);
        base_name[MAX_PATH - 1] = '\0';
        remove_extension(base_name);
        snprintf(files[file_count].pdf_name, MAX_PATH, "%s.pdf", base_name);
        snprintf(files[file_count].ocr_name, MAX_PATH, "%s%s.pdf", base_name, OCR_SUFFIX);
        file_count++;
      }
    }

    free(namelist[i]);
  }

  free(namelist);
  return file_count;
}

void remove_extension(char *filename) {
  char *dot = strrchr(filename, '.');

  if(dot != NULL) {
    *dot = '\0';
  }
}

int run_command(const char *cmd) {
  printf("    Executing: %s\n", cmd);
  int status = system(cmd);

  if(status == -1) {
    perror("Error executing command");
    return -1;
  }

  if(WIFEXITED(status) && WEXITSTATUS(status) != 0) {
    fprintf(stderr, "Command failed with exit code %d\n", WEXITSTATUS(status));
    return -1;
  }

  return 0;
}

int convert_to_pdf(const char *jpg_file, const char *pdf_file) {
  char cmd[MAX_PATH * 4];
  snprintf(cmd, sizeof(cmd),
           "convert \"%s\" -compress jpeg -quality 75 \"%s\"",
           jpg_file, pdf_file);
  return run_command(cmd);
}

int ocr_pdf(const char *input_pdf, const char *output_pdf) {
  char cmd[MAX_PATH * 4];
  snprintf(cmd, sizeof(cmd),
           "ocrmypdf \"%s\" \"%s\"",
           input_pdf, output_pdf);
  return run_command(cmd);
}

int combine_pdfs(const char *output_name) {
  if(file_count == 0) {
    fprintf(stderr, "No files to combine\n");
    return -1;
  }

  // Build the pdfunite command
  char cmd[MAX_PATH * (MAX_FILES + 10)];
  // Start with the command
  strcpy(cmd, "pdfunite ");

  // Add all OCR'd PDF files in sorted order
  for(int i = 0; i < file_count; i++) {
    strcat(cmd, "\"");
    strcat(cmd, files[i].ocr_name);
    strcat(cmd, "\" ");
  }

  // Add output filename
  strcat(cmd, "\"");
  strcat(cmd, output_name);
  strcat(cmd, "\"");
  return run_command(cmd);
}

int safe_delete(const char *filename) {
  // First try using trash command
  char trash_cmd[MAX_PATH * 3];
  snprintf(trash_cmd, sizeof(trash_cmd), "trash \"%s\" 2>/dev/null", filename);
  int status = system(trash_cmd);

  if(status == 0) {
    printf("    Moved to trash: %s\n", filename);
    return 0;
  }

  // If trash fails, use rm
  char rm_cmd[MAX_PATH * 3];
  snprintf(rm_cmd, sizeof(rm_cmd), "rm -f \"%s\"", filename);

  if(run_command(rm_cmd) == 0) {
    printf("    Deleted: %s\n", filename);
    return 0;
  }

  return -1;
}

void safe_delete_files(const char **filenames, int count) {
  char trash_cmd[MAX_PATH * (count + 10)];
  // Build trash command with all files
  strcpy(trash_cmd, "trash");

  for(int i = 0; i < count; i++) {
    strcat(trash_cmd, " \"");
    strcat(trash_cmd, filenames[i]);
    strcat(trash_cmd, "\"");
  }

  strcat(trash_cmd, " 2>/dev/null");
  // Try trash first
  int status = system(trash_cmd);

  if(status == 0) {
    printf("    Moved to trash: ");

    for(int i = 0; i < count; i++) {
      printf("%s ", filenames[i]);
    }

    printf("\n");
    return;
  }

  // If trash fails, use rm for each file
  for(int i = 0; i < count; i++) {
    char rm_cmd[MAX_PATH * 3];
    snprintf(rm_cmd, sizeof(rm_cmd), "rm -f \"%s\"", filenames[i]);
    run_command(rm_cmd);
  }
}

int cleanup_intermediate_files() {
  printf("Removing intermediate OCR PDF files...\n");
  // Prepare array of OCR files to delete
  const char *ocr_files[MAX_FILES];

  for(int i = 0; i < file_count; i++) {
    ocr_files[i] = files[i].ocr_name;
  }

  safe_delete_files(ocr_files, file_count);
  return 0;
}

void print_usage(const char *program_name) {
  printf("Usage: %s <directory_path>\n", program_name);
  printf("\nThis program automates the conversion of JPG files to OCR'd PDFs:\n");
  printf("1. Converts each JPG to PDF using ImageMagick's convert\n");
  printf("2. Performs OCR using ocrmypdf\n");
  printf("3. Removes original JPG and intermediate files (uses trash if available)\n");
  printf("4. Combines all OCR'd PDFs into a single file\n");
  printf("\nFiles are processed in alphabetical order to maintain sequence.\n");
  printf("\nRequirements:\n");
  printf("  - ImageMagick (convert command)\n");
  printf("  - ocrmypdf\n");
  printf("  - poppler-utils (pdfunite)\n");
  printf("  - trash-cli (optional, for safe deletion)\n");
}
