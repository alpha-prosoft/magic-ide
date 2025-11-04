#!/bin/bash
# Wrapper script for tmux hooks that dynamically finds the update script
# This script is sourced by tmux hooks to avoid hardcoded paths

# Try to find the update script in several locations
if [ -f "$HOME/magic-ide/update-tmux-window-name.sh" ]; then
    "$HOME/magic-ide/update-tmux-window-name.sh"
elif [ -f "$(dirname "$(readlink -f "$0")")/update-tmux-window-name.sh" ]; then
    "$(dirname "$(readlink -f "$0")")/update-tmux-window-name.sh"
elif command -v update-tmux-window-name.sh &> /dev/null; then
    update-tmux-window-name.sh
fi