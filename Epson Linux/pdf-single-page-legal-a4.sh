#!/bin/bash

# **Purpose:**
# This script is designed for printing **court filings and legal documents** on
# a dot matrix printer (EPSON LQ-310), ensuring the content fits within
# standard **legal/A4 paper dimensions** despite the printer’s inherent
# alignment quirks. It simplifies the process by:
# - Offering **quick scaling adjustments** (85–100%) to accommodate slight misalignments.
# - Preserving **readability and structure** for official submissions, where
# minor imperfections are tolerated but content must remain legible and properly formatted.
# - Embracing the **"good enough"** ethos of dot matrix printing while
# meeting bureaucratic requirements.

# **Note:** Dot matrix printers won’t deliver laser precision, but
# this script ensures the output is **functional for court purposes**—where
# content matters more than flawless margins.


# 1. Official Court Guidelines for Legal Documents**

# (Applicable to A4 paper filings in Indian courts)

# | Setting | Requirement |
# | ---               | ---                                                                   |
# | **Paper Size**    | **A4 (29.7 cm × 21 cm)**                                              |
# | **Paper Quality** | **≥75 GSM** (90–110 GSM bond paper is acceptable but not mandatory)   |
# | **Font**          | **Times New Roman** (Liberation Serif is a free alternative in Linux) |
# | **Font Size**     | **14pt** (12pt for quotations/indents)                                |
# | **Line Spacing**  | **1.5** (Single for quotations)                                       |
# | **Margins**       | **4 cm (left/right), 2 cm (top/bottom)**                              |
# | **Printing Side** | **One-sided** (unless dual-sided is explicitly allowed)               |

# Key Notes:

# - The Supreme Court and Delhi HC mandate these standards to reduce paper waste .
# - Liberation Serif (14pt) is a suitable substitute for Times New Roman in Linux,
#   as it has similar proportions.

### 2. Printing on Stamp Papers

# (Your current practice vs. recommendations)

# | Your Practice                | Suggested Adjustment (if unclear)                                                   |
# | ---                          | ---                                                                                 |
# | **Avoiding the silver line** | Leave **1 cm** from the silver line (as you do).                                    |
# | **Left margin**              | Keep **4 cm** (per court guidelines) .                                              |
# | **Right margin**             | **4.5 cm** (your practice) is acceptable if it avoids overwriting pre-printed text. |
# | **Top margin**               | **2 cm below stamp duty image** (aligns with court’s 2cm top margin).               |
# | **Bottom margin**            | Ensure **2 cm** blank space (per guidelines).                                       |

# This Matters Because:

# - Stamp papers often have pre-printed text (e.g., duty value).
#   Your approach of leaving space prevents clashes with these elements.
# - Courts prioritise readability, so consistency
#   with A4 margins (4cm left/right) is ideal, but stamp papers
#   may require flexibility.

# Dot Matrix Printer Friendly PDF Print Script
# - Embraces the "good enough" philosophy
# - Simple scaling control
# - Forgiving of minor imperfections

# sudo apt install pdftk  # Debian/Ubuntu

# Configuration
PRINTER="EPSON_LQ-310"  # Your trusty dot matrix warrior
DEFAULT_SCALE=93        # The sweet spot for most documents
CONFIG_DIR="$HOME/.dotmatrix_print"
CONFIG_FILE="$CONFIG_DIR/last_settings.conf"

# Set up config directory
mkdir -p "$CONFIG_DIR"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# Simple printer check
if ! lpstat -v | grep -q "$PRINTER"; then
    zenity --error --text="Printer $PRINTER not ready\n\nJust like dot matrix printers,\nsometimes we need a little patience.\n\nCheck connections and try again."
    exit 1
fi

# File selection with personality
PDF_FILE=$(zenity --file-selection \
    --title="Select PDF - Dot Matrix Style!" \
    --file-filter='PDF files (*.pdf) | *.pdf') || exit 1

# Simple page selection
PAGE_NUMBER=$(zenity --entry \
    --title="Which page speaks to you?" \
    --text="Enter page number to print (default: 1):" \
    --entry-text="1") || exit 1

# Friendly scale input
SCALE=$(zenity --scale \
    --title="Dot Matrix Adjustment" \
    --text="Scale (90-100%):\n\nDot matrix printers dance to their own beat.\nFind what works and embrace it!" \
    --value="${LAST_SCALE:-$DEFAULT_SCALE}" \
    --min-value=85 \
    --max-value=100 \
    --step=1) || exit 1

# Remember this setting
echo "LAST_SCALE=$SCALE" > "$CONFIG_FILE"

# Print with dot matrix spirit!
echo "Printing with dot matrix charm at ${SCALE}%..."
lp -d "$PRINTER" \
    -o scaling="$SCALE" \
    -o position=center \
    -o media=A4 \
    -o page-ranges="$PAGE_NUMBER" \
    "$PDF_FILE"

# Celebrate the attempt
zenity --info \
    --title="Print Job Launched!" \
    --text="Page $PAGE_NUMBER is being printed at $SCALE%\n\nRemember:\nDot matrix printers have personality!\n\nIf it's not perfect, it's authentic."
