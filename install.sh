#!/bin/bash

set -e

echo "================================================"
echo "Installing Neovim, Tmux, and Plugin Managers"
echo "================================================"

# Update apt package list
echo "Updating apt package list..."
sudo apt-get update

# Install Neovim
echo "Installing Neovim..."
if ! command -v nvim &> /dev/null; then
    sudo apt-get install -y neovim
    echo "✓ Neovim installed successfully"
else
    echo "✓ Neovim is already installed"
fi

# Install Tmux
echo "Installing Tmux..."
if ! command -v tmux &> /dev/null; then
    sudo apt-get install -y tmux
    echo "✓ Tmux installed successfully"
else
    echo "✓ Tmux is already installed"
fi

# Install git (required for TPM and vim-plug)
echo "Installing Git..."
if ! command -v git &> /dev/null; then
    sudo apt-get install -y git
    echo "✓ Git installed successfully"
else
    echo "✓ Git is already installed"
fi

# Install TPM (Tmux Plugin Manager)
echo "Installing TPM (Tmux Plugin Manager)..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "✓ TPM installed successfully"
else
    echo "✓ TPM is already installed"
fi

# Install vim-plug for Neovim
echo "Installing vim-plug..."
VIMPLUG_DIR="$HOME/.local/share/nvim/site/autoload"
VIMPLUG_FILE="$VIMPLUG_DIR/plug.vim"
if [ ! -f "$VIMPLUG_FILE" ]; then
    mkdir -p "$VIMPLUG_DIR"
    curl -fLo "$VIMPLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "✓ vim-plug installed successfully"
else
    echo "✓ vim-plug is already installed"
fi

# Install curl and wget if not present (useful for downloading plugins)
echo "Installing additional utilities..."
sudo apt-get install -y curl wget

echo "================================================"
echo "Installation complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Run ./setup.sh to link configuration files"
echo "2. Open nvim and run :Lazy to install plugins"
echo "3. Restart your terminal for aliases to take effect"
