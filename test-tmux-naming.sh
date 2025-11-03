#!/bin/bash
# Test script for tmux window naming configuration

echo "Testing tmux window naming configuration..."
echo "============================================"

if [ -z "$TMUX" ]; then
    echo "ERROR: This script must be run inside a tmux session"
    exit 1
fi

echo "Current window name: $(tmux display-message -p -F '#{window_name}')"
echo "First pane's current path: $(tmux display-message -p -t '#{window_id}.0' -F '#{pane_current_path}')"
echo "First pane's path basename: $(tmux display-message -p -t '#{window_id}.0' -F '#{b:pane_current_path}')"

echo ""
echo "Triggering window name update..."
/home/pofuk/magic-ide/update-tmux-window-name.sh

echo "Updated window name: $(tmux display-message -p -F '#{window_name}')"

echo ""
echo "To fully test the configuration:"
echo "1. Reload tmux config: tmux source-file ~/.tmux.conf"
echo "2. Add to your shell RC file: source /home/pofuk/magic-ide/tmux-shell-integration.sh"
echo "3. Restart your shell or source your RC file"
echo "4. Navigate to different directories and observe window name changes"