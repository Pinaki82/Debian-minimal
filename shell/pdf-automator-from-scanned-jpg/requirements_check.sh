#!/bin/bash
# requirements_check.sh

echo "Checking dependencies..."

# Check for required commands
commands=("convert" "ocrmypdf" "pdfunite")

for cmd in "${commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "❌ Missing: $cmd"
        missing=true
    else
        echo "✅ Found: $cmd"
    fi
done

# Check for optional trash command
if command -v trash &> /dev/null; then
    echo "✅ Found: trash (optional)"
else
    echo "⚠️  Note: trash command not found (will use rm instead)"
fi

echo ""
if [ "$missing" = true ]; then
    echo "Some required dependencies are missing."
    echo ""
    echo "Installation instructions:"
    echo "--------------------------"
    echo "Ubuntu/Debian:"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install imagemagick ocrmypdf poppler-utils trash-cli"
    echo ""
    echo "macOS (using Homebrew):"
    echo "  brew install imagemagick ocrmypdf poppler trash"
    echo ""
    echo "After installation, compile the C program with:"
    echo "  make"
else
    echo "✅ All dependencies are satisfied!"
    echo ""
    echo "To compile and use:"
    echo "1. Run: make"
    echo "2. Execute: ./pdf-automator-from-scanned-jpg <directory_path>"
fi
