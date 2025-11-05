#!/bin/bash

# Script to remove old tmux window naming configuration from ~/.bashrc

set -e

echo "================================================"
echo "Cleaning up old tmux configuration from ~/.bashrc"
echo "================================================"

BASHRC="$HOME/.bashrc"
BACKUP_FILE="$BASHRC.backup_$(date +%Y%m%d_%H%M%S)"

# Check if .bashrc exists
if [ ! -f "$BASHRC" ]; then
    echo "Error: ~/.bashrc not found"
    exit 1
fi

# Create backup
echo "Creating backup: $BACKUP_FILE"
cp "$BASHRC" "$BACKUP_FILE"

# Remove the old tmux window naming block
echo "Removing old tmux window naming configuration..."
TEMP_FILE=$(mktemp)

# Remove the block between the old markers
awk '/# START TMUX WINDOW NAMING CONFIG - DO NOT EDIT THIS LINE/,/# END TMUX WINDOW NAMING CONFIG - DO NOT EDIT THIS LINE/{next} {print}' "$BASHRC" > "$TEMP_FILE"

# Check if anything was actually removed
if diff -q "$BASHRC" "$TEMP_FILE" > /dev/null; then
    echo "No old tmux window naming configuration found - nothing to remove"
    rm "$TEMP_FILE"
    rm "$BACKUP_FILE"
else
    # Replace the original file
    mv "$TEMP_FILE" "$BASHRC"
    echo "✓ Removed old tmux window naming configuration"
    echo "✓ Backup saved as: $BACKUP_FILE"
    echo ""
    echo "The following block was removed:"
    echo "----------------------------------------"
    awk '/# START TMUX WINDOW NAMING CONFIG - DO NOT EDIT THIS LINE/,/# END TMUX WINDOW NAMING CONFIG - DO NOT EDIT THIS LINE/{print}' "$BACKUP_FILE"
    echo "----------------------------------------"
fi

echo ""
echo "================================================"
echo "Cleanup complete!"
echo "================================================"
echo ""
echo "Please reload your shell configuration:"
echo "  source ~/.bashrc"
echo ""
echo "Or open a new terminal for changes to take effect."