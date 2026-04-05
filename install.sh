#!/bin/bash
set -euo pipefail

# install.sh — Set up the host machine for Magic IDE (Linux).
# Installs Docker, tmux, DevPod CLI, links tmux config, adds shell integration.
# Neovim runs inside the DevPod container — nothing else needed on the host.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCH="$(uname -m)"

echo "=== Magic IDE — Host Setup ==="

# --- Docker Engine ---
if ! command -v docker &>/dev/null; then
  echo "Installing Docker Engine..."
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER"
  echo "Docker installed. You may need to log out and back in for group membership to take effect."
else
  echo "Docker already installed: $(docker --version)"
fi

# --- tmux ---
if ! command -v tmux &>/dev/null; then
  echo "Installing tmux..."
  if command -v apt-get &>/dev/null; then
    sudo apt-get update -qq
    sudo apt-get install -y --no-install-recommends tmux git curl unzip
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y tmux git curl unzip
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm tmux git curl unzip
  else
    echo "ERROR: Could not detect package manager. Install tmux manually."
    exit 1
  fi
else
  echo "tmux already installed: $(tmux -V)"
fi

# --- DevPod CLI ---
if ! command -v devpod &>/dev/null; then
  echo "Installing DevPod CLI..."
  case "${ARCH}" in
    x86_64)   DEVPOD_BIN="devpod-linux-amd64" ;;
    aarch64)  DEVPOD_BIN="devpod-linux-arm64" ;;
    *) echo "ERROR: Unsupported architecture: ${ARCH}"; exit 1 ;;
  esac
  curl -fsSL -o /tmp/devpod "https://github.com/loft-sh/devpod/releases/latest/download/${DEVPOD_BIN}"
  sudo install -c -m 0755 /tmp/devpod /usr/local/bin/devpod
  rm -f /tmp/devpod
  echo "DevPod CLI installed"
else
  echo "DevPod CLI already installed: $(devpod version 2>/dev/null || echo 'unknown version')"
fi

# --- Docker provider ---
if command -v docker &>/dev/null; then
  if ! devpod provider list 2>/dev/null | grep -q docker; then
    echo "Adding Docker provider to DevPod..."
    devpod provider add docker
  else
    echo "DevPod Docker provider already configured"
  fi
else
  echo "WARNING: Docker not found. Install Docker and then run: devpod provider add docker"
fi

# --- TPM (Tmux Plugin Manager) ---
TPM_DIR="${HOME}/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM..."
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already installed"
fi

# --- Link tmux config ---
echo "Linking .tmux.conf..."
ln -sf "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

# --- Make scripts executable ---
chmod +x "$SCRIPT_DIR"/scripts/*.sh 2>/dev/null || true

# --- Shell integration ---
echo "Configuring shell integration..."
export MAGIC_IDE_HOME="$SCRIPT_DIR"

for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$RC_FILE" ] || continue

  MARKER="# MAGIC-IDE-CONFIG"

  # Remove old block if present
  if grep -q "$MARKER" "$RC_FILE" 2>/dev/null; then
    sed -i.bak "/${MARKER}-START/,/${MARKER}-END/d" "$RC_FILE" && rm -f "${RC_FILE}.bak"
  fi

  # Remove legacy markers
  if grep -q "# START TMUX SHELL INTEGRATION - DO NOT EDIT THIS LINE" "$RC_FILE" 2>/dev/null; then
    sed -i.bak '/# START TMUX SHELL INTEGRATION/,/# END TMUX SHELL INTEGRATION/d' "$RC_FILE" && rm -f "${RC_FILE}.bak"
  fi

  cat >> "$RC_FILE" << EOF
${MARKER}-START
export MAGIC_IDE_HOME="$SCRIPT_DIR"
if command -v tmux &>/dev/null && [ -z "\$TMUX" ]; then
  exec tmux new-session
fi
if [ -f "\$MAGIC_IDE_HOME/scripts/tmux-shell-integration.sh" ]; then
  source "\$MAGIC_IDE_HOME/scripts/tmux-shell-integration.sh"
fi
${MARKER}-END
EOF
  echo "  Updated $(basename "$RC_FILE")"
done

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. Restart your shell (or run: source ~/.bashrc)"
echo "  2. Inside tmux, press Ctrl+b Shift+I to install tmux plugins"
echo "  3. Start Neovim in a container:"
echo "     devpod up github.com/alpha-prosoft/magic-ide --ide none"
echo "     devpod ssh magic-ide"
