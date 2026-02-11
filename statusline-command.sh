#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project_name=$(basename "$cwd")
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
branch=$(git -C "$cwd" branch --show-current 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

# Create progress bar (20 characters wide)
bar_width=20
if [ "$used_pct" != "null" ] && [ -n "$used_pct" ]; then
    filled=$(printf "%.0f" "$(echo "$used_pct * $bar_width / 100" | bc -l)")
    empty=$((bar_width - filled))
    progress_bar="["
    for ((i=0; i<filled; i++)); do progress_bar+="█"; done
    for ((i=0; i<empty; i++)); do progress_bar+="░"; done
    progress_bar+="]"
else
    progress_bar="[░░░░░░░░░░░░░░░░░░░░]"
    used_pct="0.0"
fi

# Line 1: Gear icon, progress bar, percentage
printf "\033[90m⚙\033[0m  %s \033[36m%.1f%%\033[0m\n" "$progress_bar" "$used_pct"

# Line 2: Folder icon with project | Robot icon with model | Git branch icon with branch
line2="\033[90m📁\033[0m \033[34m${project_name}\033[0m"
line2+=" \033[90m|\033[0m \033[90m🤖\033[0m \033[35m${model}\033[0m"
if [ -n "$branch" ]; then
    # Check if dirty
    dirty=""
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
        dirty="*"
    fi
    line2+=" \033[90m|\033[0m \033[90m\033[0m \033[32m${branch}${dirty}\033[0m"
fi

printf "%b" "$line2"
