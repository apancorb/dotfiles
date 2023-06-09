FROM --platform=linux/amd64 mcr.microsoft.com/devcontainers/universal:latest
MAINTAINER tony.software
RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
  dnsutils       \
  iputils-ping   \
  tmux           \
  ripgrep        

RUN git clone --depth 1 --branch stable https://github.com/neovim/neovim /opt/neovim \
  && apt-get install -y ninja-build gettext cmake unzip curl \
  && pip install cmake                                       \
  && cd /opt/neovim                                          \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install    \
  && ln -sf $(which nvim) $(which vim)

USER codespace
WORKDIR /home/codespace
COPY --chown=codespace:codespace bash/bash_aliases .bash_aliases
COPY --chown=codespace:codespace bash/bashrc .bashrc
COPY --chown=codespace:codespace git/gitconfig .gitconfig
COPY --chown=codespace:codespace nvim .config/nvim
COPY --chown=codespace:codespace ssh/config .ssh/config
COPY --chown=codespace:codespace tmux/*.sh  .tmux/
COPY --chown=codespace:codespace tmux/tmux.conf .tmux.conf
