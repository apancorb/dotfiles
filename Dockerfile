FROM --platform=linux/amd64 mcr.microsoft.com/vscode/devcontainers/universal:latest
MAINTAINER tony.software
RUN apt-get update && apt-get upgrade -y

# Install additional packages
RUN apt-get install -y \
  dnsutils \
  iputils-ping \
  ripgrep \
  tmux

# Install neovim
RUN wget -P /opt https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
  && tar -C /opt -xzf /opt/nvim-linux64.tar.gz \
  && ln -sf /opt/nvim-linux64/bin/nvim $(which vim)

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
COPY --chown=codespace:codespace bash/.bash_aliases .bash_aliases
COPY --chown=codespace:codespace git/.gitconfig .gitconfig
COPY --chown=codespace:codespace nvim .config/nvim
COPY --chown=codespace:codespace ssh/config .ssh/config
COPY --chown=codespace:codespace ssh/rc .ssh/rc
COPY --chown=codespace:codespace tmux/.tmux.conf .tmux.conf
COPY --chown=codespace:codespace tmux/setup.sh  .tmux/
