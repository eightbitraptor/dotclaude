#!/bin/bash

# Claude configuration management script
# This script merges version-controlled config with runtime state

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="$SCRIPT_DIR/claude-config.json"
RUNTIME_FILE="$HOME/.claude.json"
BACKUP_DIR="$HOME/.claude-backups"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: claude-config.json not found in $SCRIPT_DIR"
    exit 1
fi

# Backup existing runtime file if it exists
if [ -f "$RUNTIME_FILE" ]; then
    BACKUP_FILE="$BACKUP_DIR/claude.json.$(date +%Y%m%d_%H%M%S)"
    echo "Backing up existing runtime file to $BACKUP_FILE"
    cp "$RUNTIME_FILE" "$BACKUP_FILE"
fi

# If runtime file doesn't exist, just copy config
if [ ! -f "$RUNTIME_FILE" ]; then
    echo "No existing runtime file found. Creating new one from config."
    cp "$CONFIG_FILE" "$RUNTIME_FILE"
    echo "Configuration installed!"
    exit 0
fi

# Merge config into runtime file using jq
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq first."
    echo "On macOS: brew install jq"
    echo "On Ubuntu/Debian: sudo apt-get install jq"
    exit 1
fi

# Create a temporary file for the merge
TEMP_FILE=$(mktemp)

# Merge the configs - config values override runtime values for matching keys
echo "Merging configuration..."
jq -s '.[0] * .[1]' "$RUNTIME_FILE" "$CONFIG_FILE" > "$TEMP_FILE"

# Replace runtime file with merged version
mv "$TEMP_FILE" "$RUNTIME_FILE"

echo "Configuration merged successfully!"
echo "Your theme and MCP servers from claude-config.json have been applied."