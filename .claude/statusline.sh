#!/bin/zsh
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
folder_name=$(basename "$current_dir")
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Git branch
git_branch=""
cd "$current_dir" 2>/dev/null && git_branch=$(git branch --show-current 2>/dev/null)

# Nerd font icons via zsh unicode
folder_icon=$'\uf07b'
branch_icon=$'\ue725'

# Colors
cyan=$'\033[36m'
green=$'\033[32m'
reset=$'\033[0m'

# Progress bar
PCT=${used_pct%.*}
[ -z "$PCT" ] && PCT=0
FILLED=$((PCT / 10))
EMPTY=$((10 - FILLED))
BAR=$(printf "%${FILLED}s" | tr ' ' '█')$(printf "%${EMPTY}s" | tr ' ' '░')
pct_display=$(awk "BEGIN{printf \"%.1f\", $used_pct}")

# Single line: bar pct% [Model] 󰉋 folder | 󰘬 branch
line="${green}${BAR}${reset} ${pct_display}% | ${folder_icon} ${folder_name}"
[ -n "$git_branch" ] && line="${line} | ${branch_icon} ${git_branch}"
echo "$line"
