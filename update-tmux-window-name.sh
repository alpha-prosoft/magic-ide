#!/bin/bash
# Script to update tmux window name based on first pane's directory

if [ -n "$TMUX" ]; then
    # Get the current window ID
    window_id=$(tmux display-message -p -F "#{window_id}")
    
    # Get the path of the first pane (pane 0) in current window
    first_pane_path=$(tmux display-message -p -t "${window_id}.0" -F "#{pane_current_path}" 2>/dev/null)
    
    if [ -n "$first_pane_path" ]; then
        # Get basename of the path
        window_name=$(basename "$first_pane_path")
        
        # Rename the window
        tmux rename-window "$window_name" 2>/dev/null
    fi
fi