#!/bin/bash

set -e

echo "================================================"
echo "Setting up LazyVim Configuration"
echo "================================================"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Create neovim config directory if it doesn't exist
echo "Creating Neovim config directory..."
mkdir -p "$NVIM_CONFIG_DIR"

# Link configuration files
echo "Linking configuration files..."

# Link init.lua
ln -sf "$SCRIPT_DIR/lazyvim/init.lua" "$NVIM_CONFIG_DIR/init.lua"
echo "✓ Linked init.lua"

# Link .neoconf.json
ln -sf "$SCRIPT_DIR/lazyvim/.neoconf.json" "$NVIM_CONFIG_DIR/.neoconf.json"
echo "✓ Linked .neoconf.json"

# Link stylua.toml
ln -sf "$SCRIPT_DIR/lazyvim/stylua.toml" "$NVIM_CONFIG_DIR/stylua.toml"
echo "✓ Linked stylua.toml"

# Link lua directory
ln -sfn "$SCRIPT_DIR/lazyvim/lua" "$NVIM_CONFIG_DIR/lua"
echo "✓ Linked lua directory"

# Link .tmux.conf
ln -sf "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
echo "✓ Linked .tmux.conf"

# Setup bash aliases
echo "Configuring bash aliases..."
BASHRC="$HOME/.bashrc"

# Check if .bashrc exists, create if it doesn't
if [ ! -f "$BASHRC" ]; then
    touch "$BASHRC"
    echo "✓ Created .bashrc file"
fi

# Function to add alias if it doesn't exist
add_alias_if_missing() {
    local alias_name="$1"
    local alias_command="$2"
    local alias_line="alias $alias_name='$alias_command'"

    # Check if the alias already exists
    if ! grep -q "alias $alias_name=" "$BASHRC" 2>/dev/null; then
        echo "$alias_line" >> "$BASHRC"
        echo "✓ Added alias: $alias_name -> $alias_command"
        return 0
    else
        # Check if it points to the correct command
        if grep -q "^alias $alias_name='$alias_command'" "$BASHRC" 2>/dev/null || \
           grep -q "^alias $alias_name=\"$alias_command\"" "$BASHRC" 2>/dev/null; then
            echo "✓ Alias $alias_name already configured correctly"
            return 0
        else
            echo "⚠ Alias $alias_name exists but points to a different command"
            echo "  Please check your .bashrc manually"
            return 1
        fi
    fi
}

# Add vim and vi aliases
add_alias_if_missing "vim" "nvim"
add_alias_if_missing "vi" "nvim"

# Add tmux auto-start to .bashrc (always create new session)
echo "Configuring tmux auto-start..."
TMUX_AUTOSTART="
# Auto-start tmux - creates new session for each terminal
if command -v tmux &> /dev/null && [ -z \"\$TMUX\" ]; then
    exec tmux new-session
fi"

# Check if tmux auto-start already exists
if ! grep -q "Auto-start tmux - creates new session for each terminal" "$BASHRC" 2>/dev/null; then
    echo "$TMUX_AUTOSTART" >> "$BASHRC"
    echo "✓ Added tmux auto-start to .bashrc"
else
    echo "✓ Tmux auto-start already configured"
fi

echo "================================================"
echo "Setup complete!"
echo "================================================"
echo ""
echo "Configuration files have been linked to ~/.config/nvim/"
echo "Bash aliases have been added to ~/.bashrc"
echo "Tmux will auto-start in new terminals"
echo ""
echo "Next steps:"
echo "1. Reload your shell: source ~/.bashrc or open a new terminal"
echo "2. Tmux will start automatically"
echo "3. Install tmux plugins: Press Ctrl+b then Shift+I"
echo "4. Open nvim and let LazyVim install plugins"
echo ""
echo "See README.md for detailed instructions"
