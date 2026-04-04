#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="${HOME}/.config/nvim"

echo "=== Setting up Magic IDE ==="

# Export MAGIC_IDE_HOME for tmux hooks and other scripts
export MAGIC_IDE_HOME="$SCRIPT_DIR"

# --- Neovim config ---
echo "Linking Neovim configuration..."
mkdir -p "$NVIM_CONFIG_DIR"

ln -sf "$SCRIPT_DIR/lazyvim/init.lua"      "$NVIM_CONFIG_DIR/init.lua"
ln -sf "$SCRIPT_DIR/lazyvim/.neoconf.json" "$NVIM_CONFIG_DIR/.neoconf.json"
ln -sf "$SCRIPT_DIR/lazyvim/stylua.toml"   "$NVIM_CONFIG_DIR/stylua.toml"

# Link lua directory
if [ -d "$NVIM_CONFIG_DIR/lua" ] && [ ! -L "$NVIM_CONFIG_DIR/lua" ]; then
  mv "$NVIM_CONFIG_DIR/lua" "$NVIM_CONFIG_DIR/lua.bak.$(date +%s)"
fi
ln -sfn "$SCRIPT_DIR/lazyvim/lua" "$NVIM_CONFIG_DIR/lua"

# --- Tmux config ---
echo "Linking tmux configuration..."
ln -sf "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Make scripts executable
chmod +x "$SCRIPT_DIR"/scripts/*.sh 2>/dev/null || true

# --- Shell integration ---
echo "Configuring shell integration..."
for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$RC_FILE" ] || continue

  MARKER="# MAGIC-IDE-CONFIG"

  # Remove old block if present
  if grep -q "$MARKER" "$RC_FILE" 2>/dev/null; then
    sed -i "/${MARKER}-START/,/${MARKER}-END/d" "$RC_FILE"
  fi

  # Also remove legacy markers
  if grep -q "# START TMUX SHELL INTEGRATION - DO NOT EDIT THIS LINE" "$RC_FILE" 2>/dev/null; then
    sed -i '/# START TMUX SHELL INTEGRATION/,/# END TMUX SHELL INTEGRATION/d' "$RC_FILE"
  fi

  cat >> "$RC_FILE" << EOF
${MARKER}-START
export MAGIC_IDE_HOME="$SCRIPT_DIR"
alias vim='nvim'
alias vi='nvim'
if command -v tmux &>/dev/null && [ -z "\$TMUX" ]; then
  exec tmux new-session
fi
if [ -f "\$MAGIC_IDE_HOME/scripts/tmux-shell-integration.sh" ]; then
  source "\$MAGIC_IDE_HOME/scripts/tmux-shell-integration.sh"
fi
${MARKER}-END
EOF
  echo "Updated $(basename "$RC_FILE")"
done

echo "=== Setup complete ==="
echo "Reload your shell or open a new terminal."
echo "In tmux, press Ctrl+b then Shift+I to install tmux plugins."
