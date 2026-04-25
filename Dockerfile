FROM --platform=linux/amd64 mcr.microsoft.com/devcontainers/universal:6.0.3-noble
LABEL maintainer="Antonio Pancorbo <me@tony.software>"

# Install additional packages
RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y \
    dnsutils \
    iputils-ping \
    ripgrep

# Install neovim
RUN wget -P /opt https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz \
  && tar -C /opt -xzf /opt/nvim-linux-x86_64.tar.gz \
  && ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/bin/vim

# Install lazygit
RUN LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "v\K[^"]*') \
  && wget -P /opt/lazygit https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz \
  && tar -C /opt/lazygit -xzf /opt/lazygit/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz \
  && install /opt/lazygit/lazygit /usr/local/bin

# Configure SSH server
COPY ssh/sshd.conf /etc/ssh/sshd_config.d/sshd.conf
RUN echo "codespace:codespace" | chpasswd

# Ports:
#  SSH  - 8000:2222
#  HTTP - 8001:8001
EXPOSE 2222 8001

USER codespace
WORKDIR /home/codespace

# Install claude code
RUN curl -fsSL https://claude.ai/install.sh | bash

COPY --chown=codespace:codespace bash/.bash_aliases .bash_aliases
COPY --chown=codespace:codespace claude/CLAUDE.md .claude/CLAUDE.md
COPY --chown=codespace:codespace git/.gitconfig .gitconfig
COPY --chown=codespace:codespace nvim .config/nvim
COPY --chown=codespace:codespace ssh/config .ssh/config
