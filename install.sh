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
if ! command -v nvim &>/dev/null; then
  sudo apt-get install -y neovim
  echo "✓ Neovim installed successfully"
else
  echo "✓ Neovim is already installed"
fi

# Install Tmux
echo "Installing Tmux..."
if ! command -v tmux &>/dev/null; then
  sudo apt-get install -y tmux
  echo "✓ Tmux installed successfully"
else
  echo "✓ Tmux is already installed"
fi

# Install git (required for TPM and vim-plug)
echo "Installing Git..."
if ! command -v git &>/dev/null; then
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

# Install curl, wget, and unzip if not present (useful for downloading plugins)
echo "Installing additional utilities..."
sudo apt-get install -y curl wget unzip

# Install wl-clipboard for Wayland clipboard support in tmux
echo "Installing wl-clipboard..."
if ! command -v wl-copy &>/dev/null; then
  sudo apt-get install -y wl-clipboard
  echo "✓ wl-clipboard installed successfully"
else
  echo "✓ wl-clipboard is already installed"
fi

# Install Nerd Font for tmux/nvim icons
echo "Installing JetBrainsMono Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="JetBrainsMono"
rm -rf "$FONT_DIR/$FONT_NAME"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip -d "$FONT_NAME"
rm JetBrainsMono.zip
fc-cache -fv >/dev/null 2>&1
cd - >/dev/null
echo "✓ JetBrainsMono Nerd Font installed successfully"

# Configure GNOME Terminal to use Nerd Font
echo "Configuring GNOME Terminal font..."
if command -v gsettings &>/dev/null; then
  # Get the default profile UUID
  PROFILE_UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")

  if [ -n "$PROFILE_UUID" ]; then
    # Set custom font to JetBrainsMono Nerd Font
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ use-system-font false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ font 'JetBrainsMono Nerd Font 11'
    echo "✓ GNOME Terminal configured to use JetBrainsMono Nerd Font"
  else
    echo "  → Could not detect GNOME Terminal profile. Please set font manually."
  fi
else
  echo "  → gsettings not found. Please configure terminal font manually to 'JetBrainsMono Nerd Font'"
fi

echo "================================================"
echo "Installation complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Run ./setup.sh to link configuration files"
echo "2. Open nvim and run :Lazy to install plugins"
echo "3. Restart your terminal for aliases to take effect"
