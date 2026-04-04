FROM ubuntu:24.04

ARG NVIM_VERSION=0.12.0
ARG NERD_FONT_VERSION=3.1.1
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    MAGIC_IDE_HOME=/opt/magic-ide \
    PATH="/opt/nvim/bin:${PATH}"

# System packages
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      git curl wget unzip ca-certificates \
      tmux \
      ripgrep fzf fd-find \
      nodejs npm \
      python3 python3-pip python3-venv \
      build-essential cmake \
      fontconfig \
      sudo \
      bash zsh \
      openssh-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Neovim from GitHub release
RUN ARCH=$(case "${TARGETARCH}" in \
      amd64) echo "linux-x86_64" ;; \
      arm64) echo "linux-arm64" ;; \
      *) echo "linux-x86_64" ;; \
    esac) && \
    curl -fsSL "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-${ARCH}.tar.gz" \
      -o /tmp/nvim.tar.gz && \
    tar xzf /tmp/nvim.tar.gz -C /opt/ && \
    mv "/opt/nvim-${ARCH}" /opt/nvim && \
    rm /tmp/nvim.tar.gz

# Create non-root user
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000
RUN userdel -r ubuntu 2>/dev/null || true && \
    groupdel ubuntu 2>/dev/null || true && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Nerd Font
RUN mkdir -p ~/.local/share/fonts/JetBrainsMono && \
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONT_VERSION}/JetBrainsMono.zip" \
      -o /tmp/JetBrainsMono.zip && \
    unzip -qo /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono && \
    rm /tmp/JetBrainsMono.zip && \
    fc-cache -f 2>/dev/null || true

# TPM (Tmux Plugin Manager)
RUN git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy magic-ide configuration
COPY --chown=$USERNAME:$USERNAME . $MAGIC_IDE_HOME/

# Link configs
RUN mkdir -p ~/.config/nvim && \
    ln -sf $MAGIC_IDE_HOME/lazyvim/init.lua      ~/.config/nvim/init.lua && \
    ln -sf $MAGIC_IDE_HOME/lazyvim/.neoconf.json  ~/.config/nvim/.neoconf.json && \
    ln -sf $MAGIC_IDE_HOME/lazyvim/stylua.toml    ~/.config/nvim/stylua.toml && \
    ln -sfn $MAGIC_IDE_HOME/lazyvim/lua           ~/.config/nvim/lua && \
    ln -sf $MAGIC_IDE_HOME/.tmux.conf             ~/.tmux.conf && \
    chmod +x $MAGIC_IDE_HOME/scripts/*.sh

# Shell integration
RUN { \
      echo '# MAGIC-IDE-CONFIG-START'; \
      echo "export MAGIC_IDE_HOME=\"$MAGIC_IDE_HOME\""; \
      echo 'export PATH="/opt/nvim/bin:$PATH"'; \
      echo "alias vim='nvim'"; \
      echo "alias vi='nvim'"; \
      echo 'if [ -f "$MAGIC_IDE_HOME/scripts/tmux-shell-integration.sh" ]; then'; \
      echo '  source "$MAGIC_IDE_HOME/scripts/tmux-shell-integration.sh"'; \
      echo 'fi'; \
      echo '# MAGIC-IDE-CONFIG-END'; \
    } >> ~/.bashrc

# Pre-install lazy.nvim and plugins (headless)
RUN nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

WORKDIR /workspace
CMD ["bash"]
