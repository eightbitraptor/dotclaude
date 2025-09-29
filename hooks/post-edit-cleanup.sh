#!/bin/bash

# Claude Code post-edit hook to remove trailing whitespace
# This hook runs after every Edit tool invocation

# Get the file path from the tool parameters
FILE_PATH="$1"

# Check if the file exists
if [ -f "$FILE_PATH" ]; then
    # Remove trailing whitespace using sed
    # -i '' for in-place editing on macOS
    sed -i '' 's/[[:space:]]*$//' "$FILE_PATH"
fi
