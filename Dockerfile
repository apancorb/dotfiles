FROM mcr.microsoft.com/devcontainers/universal:latest
RUN apt-get update && apt-get upgrade -y

# tools
RUN apt-get install -y \
  dnsutils       \
  iputils-ping   \
  tmux           \
  ripgrep        

# text editor
RUN wget -P /tmp https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
  && chmod u+x /tmp/nvim.appimage                         \
  && (cd /opt && /tmp/nvim.appimage --appimage-extract)   \
  && ln -sf /opt/squashfs-root/AppRun /usr/bin/vim 

# user
USER codespace
WORKDIR /home/codespace
COPY --chown=codespace:codespace bash/bash_aliases .bash_aliases
COPY --chown=codespace:codespace bash/bashrc .bashrc
COPY --chown=codespace:codespace nvim .config/nvim
COPY --chown=codespace:codespace ssh/config .ssh/config
COPY --chown=codespace:codespace tmux/*.sh  .tmux/
COPY --chown=codespace:codespace tmux/tmux.conf .tmux.conf
