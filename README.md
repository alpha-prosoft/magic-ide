# Magic IDE Setup

A complete development environment setup with LazyVim, tmux, and custom configurations.

## Quick Start

### Installation

1. Clone this repository or download the files
2. Run the setup script:
   ```bash
   ./setup.sh
   ```

3. Reload your shell or open a new terminal:
   ```bash
   source ~/.bashrc
   # OR
   # Open a new terminal window
   ```

4. **IMPORTANT**: After tmux starts, install tmux plugins by pressing:
   ```
   Ctrl+b then Shift+I
   ```
   (That's Ctrl+b, release, then hold Shift and press I)

5. Open nvim and wait for LazyVim to install plugins automatically

6. Verify the setup:
   ```
   :checkhealth
   ```

## How It Works

### Tmux Auto-Start

Each time you open a new terminal, a **new tmux session** will be created automatically. This means:

- Opening 2 terminal windows = 2 separate tmux sessions
- Opening 3 terminal windows = 3 separate tmux sessions
- Each session is independent and isolated

### Starting Additional Terminals with Tmux

To open a new terminal with its own tmux session:

1. **New Terminal Window**: Simply open a new terminal window from your terminal emulator
   - Each window will automatically start a fresh tmux session

2. **New Tmux Window** (within current session):
   ```
   Ctrl+b c
   ```

3. **New Tmux Pane** (split current window):
   - Horizontal split: `Ctrl+b "`
   - Vertical split: `Ctrl+b %`

## Tmux Basics

### Default Prefix Key
The default tmux prefix is `Ctrl+b`. Press this combination, release, then press the command key.

### Essential Commands

| Command | Action |
|---------|--------|
| `Ctrl+b c` | Create new window |
| `Ctrl+b "` | Split pane horizontally |
| `Ctrl+b %` | Split pane vertically |
| `Ctrl+b arrow` | Navigate between panes |
| `Ctrl+b n` | Next window |
| `Ctrl+b p` | Previous window |
| `Ctrl+b d` | Detach from session |
| `Ctrl+b [` | Enter scroll mode (q to exit) |

### Managing Multiple Sessions

```bash
# List all sessions
tmux ls

# Attach to a specific session
tmux attach -t <session-name>

# Kill a specific session
tmux kill-session -t <session-name>

# Kill all sessions except current
tmux kill-session -a
```

## What Gets Configured

The setup script will:

1. Link `init.lua` to `~/.config/nvim/init.lua`
2. Link `.neoconf.json` to `~/.config/nvim/.neoconf.json`
3. Link `stylua.toml` to `~/.config/nvim/stylua.toml`
4. Link `.tmux.conf` to `~/.tmux.conf`
5. Add `vi` and `vim` aliases to `~/.bashrc` (both point to `nvim`)
6. Configure tmux to auto-start in `~/.bashrc`

## File Structure

```
.
├── init.lua          # Neovim configuration
├── .neoconf.json     # Project-specific Neovim settings
├── stylua.toml       # Lua formatter configuration
├── .tmux.conf        # Tmux configuration
├── setup.sh          # Installation script
└── README.md         # This file
```

## Troubleshooting

### Tmux plugins not working
Make sure you pressed `Ctrl+b` then `Shift+I` after the first tmux start to install plugins.

### Neovim plugins not installing
Open nvim and wait. LazyVim will automatically install plugins on first launch. You can also run `:Lazy` to manage plugins.

### Want to disable tmux auto-start?
Edit `~/.bashrc` and comment out or remove the tmux auto-start section:
```bash
# Auto-start tmux - creates new session for each terminal
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    exec tmux new-session
fi
```

## Customization

- **Neovim**: Edit `init.lua` for configuration changes
- **Tmux**: Edit `.tmux.conf` for tmux customization
- **Bash**: Your `~/.bashrc` contains the aliases and auto-start logic

After making changes, re-run `./setup.sh` to update symlinks, or reload configurations manually.

## Requirements

- Neovim >= 0.9.0
- Tmux >= 3.0
- Bash shell
- Git (for plugin management)

## License

This is a personal configuration setup. Feel free to modify and use as needed.
