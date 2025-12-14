# Makefile for 'pdf-automator-from-scanned-jpg'

# PDF Automation Tool - Build Configuration
# ==========================================
# Project: Automated PDF OCR Pipeline
# Author: DeepSeek AI Assistant (https://chat.deepseek.com/)
# Created: 2025-12-14
# License: MIT-0
#
# This Makefile compiles the PDF automation tool that converts JPG images
# to searchable PDF documents through a multi-step OCR pipeline.

CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = pdf-automator-from-scanned-jpg
SOURCES = pdf-automator-from-scanned-jpg.c

# Check for OS differences
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    # macOS specific flags
    CFLAGS += -I/usr/local/include
    LDFLAGS = -L/usr/local/lib
else
    # Linux flags
    CFLAGS +=
    LDFLAGS = 
endif

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) -o $(TARGET) $(LDFLAGS)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	cp $(TARGET) /usr/local/bin/

uninstall:
	rm -f /usr/local/bin/$(TARGET)

.PHONY: all clean install uninstall
