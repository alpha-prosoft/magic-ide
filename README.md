# Magic IDE

Terminal-based development environment: Neovim 0.12 (LazyVim) + tmux.

Built-in support for Java, Clojure, and Terraform.

## Architecture

```
┌─────────────────────────────────────────┐
│  Host machine                           │
│  ┌───────────────────────────────────┐  │
│  │ tmux (terminal multiplexer)       │  │
│  │  ┌─────────┐  ┌─────────┐        │  │
│  │  │ pane 1  │  │ pane 2  │  ...   │  │
│  │  │ devpod  │  │ shell   │        │  │
│  │  │  └─────────────┐     │        │  │
│  │  │  │ Container    │     │        │  │
│  │  │  │  Neovim 0.12 │     │        │  │
│  │  │  │  LSPs, tools │     │        │  │
│  │  │  └─────────────┘     │        │  │
│  │  └─────────┘  └─────────┘        │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

- **tmux** runs on your host — window management, splits, copy/paste
- **Neovim** runs inside a DevPod container — editor, LSPs, language tools

## Prerequisites

Only Docker needs to be installed manually. Everything else is handled by `install.sh`.

| Requirement | Install |
|-------------|---------|
| Docker | [docs.docker.com/get-docker](https://docs.docker.com/get-docker/) |
| Nerd Font terminal | Alacritty, Kitty, iTerm2, WezTerm, Ghostty, or Windows Terminal |

Configure your terminal to use a [Nerd Font](https://www.nerdfonts.com/) (e.g. `JetBrainsMono Nerd Font`).

## Install

```bash
git clone git@github.com:alpha-prosoft/magic-ide.git ~/magic-ide
cd ~/magic-ide
./install.sh
```

This single script installs and configures everything on the host:
- **tmux** (via apt/brew/dnf/pacman)
- **DevPod CLI** (from GitHub releases)
- **Docker provider** for DevPod
- **TPM** (Tmux Plugin Manager)
- Symlinks `.tmux.conf`
- Shell integration in `.bashrc` / `.zshrc`

After install, restart your shell and press `Ctrl+b Shift+I` inside tmux to install tmux plugins.

## Usage

### Start Neovim in a container

```bash
# Create the workspace (first time)
devpod up github.com/alpha-prosoft/magic-ide --ide none

# SSH into it
devpod ssh magic-ide

# Run Neovim
nvim
```

### DevPod workspace commands

```bash
devpod up magic-ide             # Start an existing workspace
devpod ssh magic-ide            # SSH into the workspace
devpod stop magic-ide           # Stop the workspace
devpod delete magic-ide         # Delete the workspace
devpod up magic-ide --recreate  # Rebuild after config changes
```

The workspace is also reachable as an SSH host: `ssh magic-ide.devpod`

### Plain Docker (no DevPod)

```bash
docker run -it --rm \
  -v "$PWD":/workspace \
  ghcr.io/alpha-prosoft/magic-ide:main
```

## Keybindings

### tmux (host)

| Key | Action |
|-----|--------|
| `Ctrl+b c` | New window |
| `Ctrl+b "` | Split horizontal |
| `Ctrl+b %` | Split vertical |
| `Ctrl+b arrow` | Navigate panes (also `Ctrl+h/j/k/l` via vim-tmux-navigator) |
| `Ctrl+b n` / `Ctrl+b p` | Next / previous window |
| `Ctrl+b d` | Detach |
| `Ctrl+b [` | Scroll/copy mode (`q` to exit, `v` to select, `y` to copy) |
| `Ctrl+b Shift+I` | Install tmux plugins (TPM) |

### Neovim (container)

| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>a` | OpenCode AI popup |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |

## What's included

### Container (Neovim)

| Component | Details |
|-----------|---------|
| Neovim 0.12 | LazyVim distribution, lazy.nvim plugin manager |
| Java | jdtls via Mason |
| Clojure | clojure-lsp, Conjure REPL |
| Terraform | terraform-ls via Mason |
| AI | OpenCode integration (`<leader>a`) |
| Search | fzf-lua, ripgrep, fd |

### Host (tmux)

| Component | Details |
|-----------|---------|
| tmux | Catppuccin Mocha theme, vim-tmux-navigator |
| Window naming | Auto-renames windows to current directory |
| Shell integration | Bash and Zsh prompt hooks |

## File structure

```
.
├── install.sh                # HOST: install tmux, devpod, link config
├── .tmux.conf                # HOST: tmux configuration
├── scripts/
│   ├── tmux-shell-integration.sh   # HOST: cd/pushd hooks for window naming
│   └── update-tmux-window-name.sh  # HOST: tmux hook script
│
├── Dockerfile                # CONTAINER: Neovim 0.12 + language tools
├── .devcontainer/
│   └── devcontainer.json     # CONTAINER: DevPod config
├── .github/workflows/
│   └── build.yml             # CI: multi-arch build, push to GHCR
│
└── lazyvim/                  # Neovim configuration (copied into container)
    ├── init.lua
    ├── .neoconf.json
    ├── stylua.toml
    └── lua/
        ├── config/           # options, keymaps, autocmds, lazy.lua
        └── plugins/          # java, clojure, terraform, opencode, fzf, etc.
```

## Container image

Published automatically on push to `main`:

```
ghcr.io/alpha-prosoft/magic-ide:main
```

Multi-arch: `linux/amd64` and `linux/arm64`.

## License

Apache License 2.0
