#!/usr/bin/c -Wall -Wextra -pedantic --

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
  Usage:
  chmod +x pdf_combiner.c
  ./pdf_combiner.c input.pdf
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h> // For mkdir
#include <dirent.h>   // For iterating directory contents (cleanup)

#define MAX_CMD_LEN 2048
#define MAX_FILENAME_LEN 256
#define MAX_PAGES 1000 // Max expected pages in the PDF

/*
   IMPORTANT NOTE REGARDING ImageMagick Resource Limits:

   If you encounter errors like "width or height exceeds limit"
   (e.g., montage-im6.q16: width or height exceeds limit `output.pdf' @ error/cache.c/OpenPixelCache/3909.),
   it means ImageMagick's policy settings are restricting resource usage.

   To resolve this, you need to edit ImageMagick's policy.xml file.

   1. Open the policy.xml file with administrative privileges:
   sudo geany /etc/ImageMagick-6/policy.xml
   (or use your preferred text editor like nano, vim, etc.)

   2. Locate the '<policymap>' section and find the lines related to resource limits,
   specifically 'width', 'height', 'memory', 'map', and 'area'.

   3. Increase the 'value' for these policies to accommodate larger images/outputs.
   For example, change:
   <policy domain="resource" name="width" value="16KP"/>
   <policy domain="resource" name="height" value="16KP"/>
   <policy domain="resource" name="memory" value="256MiB"/>
   <policy domain="resource" name="map" value="512MiB"/>
   <policy domain="resource" name="area" value="128MP"/>

   To higher values, such as:
   <policy domain="resource" name="width" value="200KP"/>   // e.g., 200,000 pixels
   <policy domain="resource" name="height" value="200KP"/>  // e.g., 200,000 pixels
   <policy domain="resource" name="memory" value="2GiB"/>   // 2 Gigabytes
   <policy domain="resource" name="map" value="4GiB"/>     // 4 Gigabytes
   <policy domain="resource" name="area" value="2GP"/>     // 2 Gigapixels

   4. Save the policy.xml file and close the editor.

   5. Re-run your program. ImageMagick should now have sufficient resources.
*/

/*
   REQUIRED DEPENDENCIES AND SYSTEM INFORMATION:

   This program relies on external command-line utilities. Please ensure they are installed
   and available in your system's PATH:

   1. ImageMagick: Provides `convert` (for PDF to image extraction) and `montage` (for image tiling).
   Installation (Debian/Ubuntu): sudo apt install imagemagick

   2. Poppler Utilities: Provides `pdfinfo` (for determining PDF page count).
   Installation (Debian/Ubuntu): sudo apt install poppler-utils

   3. PDF Toolkit (pdftk): Used for merging the individually generated combined PDF pages.
   Installation (Debian/Ubuntu): sudo apt install pdftk
   (Note: pdftk might be replaced by other tools like `qpdf` or `Ghostscript` in newer distributions,
   if pdftk is unavailable, you might need to find an alternative merging solution.)

   This code has been tested and confirmed working on:
   Operating System: Debian Bookworm
   Linux Kernel: 6.1.0.37-amd64
   Architecture: x86_64
*/

/*
   PROGRAM WORKING DETAILS:

  This program helps you create a new PDF where you can fit multiple pages of
  your original document onto a single page. For instance, if you have a
  100-page PDF and want to save on printing, you can use this tool
  to arrange 2 original pages side-by-side on each page of the final PDF.

   The workflow is as follows:

   1. Input Validation: Checks if an input PDF file path is provided as a command-line argument.
   2. User Input: Prompts the user to specify how many original PDF pages should be
   fitted onto one final output PDF page.
   3. Temporary Directory Creation: A unique temporary directory is created to store
   intermediate files generated during the process.
   4. PDF Page Count: It uses the 'pdfinfo' utility to determine the total number of
   pages in the input PDF.
   5. PDF to Image Extraction: The 'convert' utility from ImageMagick is used to
   extract each page of the input PDF into a separate high-resolution JPEG image
   within the temporary directory (e.g., output-0.jpg, output-1.jpg, etc.).
   6. Batch Montage Processing: Instead of creating one large composite image, the program
   iterates through the extracted JPEG images in batches. For each batch (determined
   by the user's "pages per final page" input), the 'montage' utility from ImageMagick
   is used to combine these images into a single, smaller, temporary PDF file
   (e.g., final_page_0.pdf, final_page_1.pdf, etc., inside the temp directory).
   7. Final PDF Merging: Once all individual combined pages (temporary PDFs) are generated,
   the 'pdftk' (PDF Toolkit) utility is invoked to merge all these temporary PDFs
   into one single, final output PDF document. The output filename is derived
   from the input PDF filename (e.g., "input_combined.pdf").
   8. Cleanup: Finally, the program cleans up by deleting all the intermediate JPEG images
   and the temporary combined PDF files, and then removes the temporary directory itself.

   This multi-step approach helps in handling large PDFs and avoids hitting single-command
   resource limits that might occur when trying to process all images in one go.
*/

/*
   AUTHORSHIP:
   This entire code was written by Gemini 2.5 Flash (AI model) on Sunday, June 15, 2025 at 3:16:46 PM IST.
*/

// Prototype declaration
int get_pdf_page_count(const char *pdf_path);

// Function to get the number of pages in a PDF using pdfinfo
int get_pdf_page_count(const char *pdf_path) {
  char cmd[MAX_CMD_LEN];
  char line[256];
  FILE *fp;
  int page_count = 0;
  snprintf(cmd, sizeof(cmd), "pdfinfo \"%s\" | grep Pages", pdf_path);
  fp = popen(cmd, "r");

  if(fp == NULL) {
    perror("Failed to run pdfinfo");
    return -1;
  }

  if(fgets(line, sizeof(line), fp) != NULL) {
    sscanf(line, "Pages: %d", &page_count);
  }

  pclose(fp);
  return page_count;
}

int main(int argc, char *argv[]) {
  if(argc != 2) {
    fprintf(stderr, "Usage: %s <input_pdf_file>\n", argv[0]);
    return 1;
  }

  const char *input_pdf = argv[1];
  char temp_dir_name[] = "temp_pdf_images_XXXXXX"; // Template for mkdtemp
  char final_pdf_name[MAX_FILENAME_LEN];
  int pages_per_final_page;
  int page_count;
  char cmd[MAX_CMD_LEN];
  int ret;
  printf("Welcome to the PDF Combiner!\n");
  printf("\n*------------------*\n");
  printf("\n1. Please open the code file if you encounter problems regarding ImageMagick Resource Limits.\n2. Delete the temporary directory if it exists.\n");
  printf("\n*------------------*\n");
  // 1. Get pages per final page from user
  printf("\nHow many original pages do you want to fit on one final PDF page? ");
  ret = scanf("%d", &pages_per_final_page);

  if(ret != 1 || pages_per_final_page <= 0) {
    fprintf(stderr, "Invalid input for pages per final page. Please enter a positive integer.\n");
    return 1;
  }

  // Consume the rest of the line from stdin
  while(getchar() != '\n');

  // 2. Create a temporary directory
  // mkdtemp is safer than just using a fixed name, but needs specific header
  // Using a simpler approach for wider compatibility here, be aware of race conditions
  // snprintf(temp_dir_name, sizeof(temp_dir_name), "temp_pdf_images_%d", getpid());
  if(mkdir(temp_dir_name, 0755) != 0) {
    perror("Failed to create temporary directory");
    return 1;
  }

  printf("Created temporary directory: %s\n", temp_dir_name);
  // 3. Get the total page count of the input PDF
  page_count = get_pdf_page_count(input_pdf);

  if(page_count <= 0) {
    fprintf(stderr, "Could not determine PDF page count or PDF is empty.\n");
    // Clean up temp dir if created
    rmdir(temp_dir_name);
    return 1;
  }

  printf("Input PDF has %d pages.\n", page_count);
  // 4. Extract PDF pages to JPGs
  printf("Extracting PDF pages to images...\n");
  snprintf(cmd, sizeof(cmd), "convert -density 300 \"%s\" \"%s/output.jpg\"", input_pdf, temp_dir_name);
  ret = system(cmd);

  if(ret != 0) {
    fprintf(stderr, "Error extracting PDF: convert command failed (exit code %d).\n", ret);
    fprintf(stderr, "Please manually clean up directory: %s\n", temp_dir_name);
    return 1;
  }

  printf("PDF extraction complete.\n");
  // 5. Construct and run montage for each final page
  printf("Generating individual combined PDF pages...\n");
  int num_combined_pages = (page_count + pages_per_final_page - 1) / pages_per_final_page; // Ceiling division
  char combined_pdf_list_for_pdftk[MAX_CMD_LEN] = {0}; // To store list of temp combined PDFs for pdftk

  for(int i = 0; i < num_combined_pages; i++) {
    int start_img_idx = i * pages_per_final_page;
    int end_img_idx = (i + 1) * pages_per_final_page - 1;

    if(end_img_idx >= page_count) {
      end_img_idx = page_count - 1; // Adjust for the last batch
    }

    // Build montage command for the current batch of images
    char current_montage_input_files[MAX_CMD_LEN] = {0};

    for(int j = start_img_idx; j <= end_img_idx; j++) {
      char img_filename[MAX_FILENAME_LEN];
      snprintf(img_filename, sizeof(img_filename), "\"%s/output-%d.jpg\" ", temp_dir_name, j);

      // Append with space, ensuring not to exceed buffer
      if(strlen(current_montage_input_files) + strlen(img_filename) < MAX_CMD_LEN) {
        strcat(current_montage_input_files, img_filename);
      }

      else {
        fprintf(stderr, "Error: Montage input command buffer too small for image batch %d.\n", i);
        fprintf(stderr, "Please increase MAX_CMD_LEN.\n");
        // Attempt cleanup before returning
        fprintf(stderr, "Please manually clean up directory: %s\n", temp_dir_name);
        return 1;
      }
    }

    char temp_combined_pdf_path[MAX_FILENAME_LEN];
    snprintf(temp_combined_pdf_path, sizeof(temp_combined_pdf_path), "\"%s/final_page_%d.pdf\"", temp_dir_name, i);

    // Append this temporary combined PDF path to the list for pdftk
    if(strlen(combined_pdf_list_for_pdftk) + strlen(temp_combined_pdf_path) + 1 < MAX_CMD_LEN) {
      strcat(combined_pdf_list_for_pdftk, temp_combined_pdf_path);
      strcat(combined_pdf_list_for_pdftk, " "); // Add a space separator
    }

    else {
      fprintf(stderr, "Error: PDFtk command buffer too small for combined PDF list.\n");
      fprintf(stderr, "Please increase MAX_CMD_LEN.\n");
      // Attempt cleanup before returning
      fprintf(stderr, "Please manually clean up directory: %s\n", temp_dir_name);
      return 1;
    }

    // Execute montage for this batch
    snprintf(cmd, sizeof(cmd),
             // "montage %s -tile %dx -geometry +10+10 -quality 300 -page A4 %s",
             "montage %s -tile %dx -geometry +10+10 -quality 300 %s",
             current_montage_input_files, pages_per_final_page, temp_combined_pdf_path);
    printf("Executing batch montage command for page %d: %s\n", i, cmd);
    ret = system(cmd);

    if(ret != 0) {
      fprintf(stderr, "Error generating batch PDF page %d: montage command failed (exit code %d).\n", i, ret);
      fprintf(stderr, "Please manually clean up directory: %s\n", temp_dir_name);
      return 1;
    }
  }

  printf("Individual combined PDF pages generated.\n");
  // 6. Merge all individual combined PDF pages using pdftk
  printf("Merging all combined PDF pages into final document...\n");
  // Determine output PDF name (e.g., input_combined.pdf)
  const char *dot = strrchr(input_pdf, '.');

  if(dot && dot != input_pdf) {
    snprintf(final_pdf_name, sizeof(final_pdf_name), "%.*s_combined.pdf", (int)(dot - input_pdf), input_pdf);
  }

  else {
    snprintf(final_pdf_name, sizeof(final_pdf_name), "output_combined.pdf");
  }

  // Remove trailing space from combined_pdf_list_for_pdftk
  if(strlen(combined_pdf_list_for_pdftk) > 0) {
    combined_pdf_list_for_pdftk[strlen(combined_pdf_list_for_pdftk) - 1] = '\0';
  }

  snprintf(cmd, sizeof(cmd), "pdftk %s cat output \"%s\"", combined_pdf_list_for_pdftk, final_pdf_name);
  printf("Executing PDF merge command: %s\n", cmd);
  ret = system(cmd);

  if(ret != 0) {
    fprintf(stderr, "Error merging PDF pages: pdftk command failed (exit code %d).\n", ret);
    fprintf(stderr, "Ensure 'pdftk' is installed and in your system's PATH. You might need to install it (e.g., 'sudo apt install pdftk').\n");
    fprintf(stderr, "Please manually clean up directory: %s\n", temp_dir_name);
    return 1;
  }

  printf("Final PDF generated: %s\n", final_pdf_name);
  // 7. Clean up temporary directory and extracted JPGs/PDFs
  printf("Cleaning up temporary files...\n");
  DIR *d;
  struct dirent *dir;
  d = opendir(temp_dir_name);

  if(d) {
    while((dir = readdir(d)) != NULL) {
      if(strcmp(dir->d_name, ".") == 0 || strcmp(dir->d_name, "..") == 0) {
        continue;
      }

      char file_to_remove[MAX_FILENAME_LEN + MAX_CMD_LEN]; // Path for file
      snprintf(file_to_remove, sizeof(file_to_remove), "%s/%s", temp_dir_name, dir->d_name);
      remove(file_to_remove); // Delete the file (JPG or temporary PDF)
    }

    closedir(d);
    rmdir(temp_dir_name); // Delete the empty directory
    printf("Temporary directory %s removed.\n", temp_dir_name);
  }

  else {
    perror("Could not open temporary directory for cleanup");
  }

  printf("Program finished successfully!\n");
  return 0;
}
