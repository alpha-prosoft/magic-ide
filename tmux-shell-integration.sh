#!/bin/bash
# Tmux shell integration for automatic window naming
# Source this file in your .bashrc or .zshrc

# Function to update tmux window name based on first pane's directory
update_tmux_window_name() {
    if [ -n "$TMUX" ]; then
        # Only proceed if we're in a tmux session
        local window_id=$(tmux display-message -p -F "#{window_id}" 2>/dev/null)
        if [ -n "$window_id" ]; then
            # Get the path of the first pane in current window
            local first_pane_path=$(tmux display-message -p -t "${window_id}.0" -F "#{pane_current_path}" 2>/dev/null)
            if [ -n "$first_pane_path" ]; then
                # Get basename and rename window
                local window_name=$(basename "$first_pane_path")
                tmux rename-window "$window_name" 2>/dev/null
            fi
        fi
    fi
}

# For Bash: Use PROMPT_COMMAND
if [ -n "$BASH_VERSION" ]; then
    # Append to existing PROMPT_COMMAND if it exists
    if [ -n "$PROMPT_COMMAND" ]; then
        PROMPT_COMMAND="${PROMPT_COMMAND}; update_tmux_window_name"
    else
        PROMPT_COMMAND="update_tmux_window_name"
    fi
fi

# For Zsh: Use precmd hook
if [ -n "$ZSH_VERSION" ]; then
    # Define precmd function
    precmd() {
        update_tmux_window_name
    }
fi