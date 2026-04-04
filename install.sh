#!/bin/bash
set -euo pipefail

NVIM_VERSION="${NVIM_VERSION:-0.12.0}"
NERD_FONT_VERSION="${NERD_FONT_VERSION:-3.1.1}"
ARCH="${ARCH:-$(uname -m)}"

case "$ARCH" in
  x86_64)  NVIM_ARCH="linux-x86_64" ;;
  aarch64) NVIM_ARCH="linux-arm64" ;;
  *)       echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "=== Installing Magic IDE dependencies ==="

# Core packages
echo "Installing system packages..."
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends \
  git curl wget unzip \
  tmux \
  ripgrep fzf fd-find \
  nodejs npm \
  python3 python3-pip \
  build-essential

# Neovim from GitHub release
echo "Installing Neovim ${NVIM_VERSION}..."
if ! command -v nvim &>/dev/null || [[ "$(nvim --version | head -1)" != *"${NVIM_VERSION}"* ]]; then
  curl -fsSL "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-${NVIM_ARCH}.tar.gz" \
    -o /tmp/nvim.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar xzf /tmp/nvim.tar.gz -C /opt/
  sudo mv "/opt/nvim-${NVIM_ARCH}" /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm /tmp/nvim.tar.gz
  echo "Neovim ${NVIM_VERSION} installed"
else
  echo "Neovim ${NVIM_VERSION} already installed"
fi

# TPM (Tmux Plugin Manager)
echo "Installing TPM..."
TPM_DIR="${HOME}/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "TPM installed"
else
  echo "TPM already installed"
fi

# Nerd Font
echo "Installing JetBrainsMono Nerd Font..."
FONT_DIR="${HOME}/.local/share/fonts/JetBrainsMono"
if [ ! -d "$FONT_DIR" ]; then
  mkdir -p "$FONT_DIR"
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONT_VERSION}/JetBrainsMono.zip" \
    -o /tmp/JetBrainsMono.zip
  unzip -qo /tmp/JetBrainsMono.zip -d "$FONT_DIR"
  rm /tmp/JetBrainsMono.zip
  fc-cache -f 2>/dev/null || true
  echo "Nerd Font installed"
else
  echo "Nerd Font already installed"
fi

echo "=== Installation complete ==="
echo "Run ./setup.sh to link configuration files"
