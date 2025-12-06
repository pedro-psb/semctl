#!/bin/bash

# VHDL Formatting Script using VSG (VHDL Style Guide)
# Formats all .vhd files with indent_only style

# Check if vsg is available
if ! command -v vsg &> /dev/null; then
    echo "Error: vsg not found. Install with: uv tool install vsg"
    exit 1
fi

# Find and format all VHDL files
VHDL_FILES=$(find . -name "*.vhd" -type f | sort)

if [ -z "$VHDL_FILES" ]; then
    echo "No VHDL files found."
    exit 0
fi

echo "Formatting $(echo "$VHDL_FILES" | wc -l) VHDL files..."

for file in $VHDL_FILES; do
    vsg --style=indent_only --fix "$file" > /dev/null 2>&1
    case $? in
        0) ;; # No changes needed, silent
        1) echo "Fixed: $file" ;; # Violations found and fixed
        *) echo "Error: $file"; vsg --style=indent_only --fix "$file"; exit 1 ;;
    esac
done

echo "Formatting completed."
