# Magic IDE

Development environment with Neovim 0.12 (LazyVim), tmux, and OpenCode AI integration.

## Quick Start

### DevPod (recommended)

```bash
devpod up github.com/alpha-prosoft/magic-ide
```

Or use the pre-built container image:

```bash
docker run -it --rm -v "$PWD":/workspace ghcr.io/alpha-prosoft/magic-ide:latest
```

### Local Install

```bash
git clone git@github.com:alpha-prosoft/magic-ide.git ~/magic-ide
cd ~/magic-ide
./install.sh   # install neovim 0.12, tmux, fonts, etc.
./setup.sh     # link configs, set up shell integration
```

Reload your shell, then in tmux press `Ctrl+b Shift+I` to install tmux plugins.

## What's Included

| Component | Details |
|-----------|---------|
| Neovim 0.12 | LazyVim distribution with lazy.nvim |
| Tmux | Catppuccin theme, vim-tmux-navigator, auto window naming |
| Languages | Java (jdtls), Clojure (clojure-lsp, Conjure), Terraform (terraform-ls) |
| AI | OpenCode popup (`<leader>a`) for quick questions |
| Search | fzf-lua with 25+ keybindings |

## File Structure

```
.
├── .devcontainer/        # DevPod / devcontainer config
├── .github/workflows/    # CI: build & push container to GHCR
├── Dockerfile            # Container definition (Neovim 0.12, tmux, tools)
├── install.sh            # Local install script
├── setup.sh              # Config linker & shell integration
├── .tmux.conf            # Tmux configuration
├── scripts/              # Tmux helper scripts
│   ├── tmux-shell-integration.sh
│   └── update-tmux-window-name.sh
└── lazyvim/              # Neovim configuration
    ├── init.lua
    ├── .neoconf.json
    ├── stylua.toml
    └── lua/
        ├── config/       # Core config (options, keymaps, lazy.lua)
        └── plugins/      # Plugin specs (java, clojure, terraform, fzf, opencode, etc.)
```

## Tmux Basics

| Key | Action |
|-----|--------|
| `Ctrl+b c` | New window |
| `Ctrl+b "` | Split horizontal |
| `Ctrl+b %` | Split vertical |
| `Ctrl+b arrow` | Navigate panes |
| `Ctrl+b n/p` | Next/previous window |
| `Ctrl+b d` | Detach |
| `Ctrl+b [` | Scroll mode (`q` to exit) |

## Requirements

- Neovim >= 0.12.0
- Tmux >= 3.0
- Git

## License

Apache License 2.0
