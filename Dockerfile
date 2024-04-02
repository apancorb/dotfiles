FROM --platform=linux/amd64 mcr.microsoft.com/vscode/devcontainers/universal:latest
MAINTAINER tony.software

# Update package lists and upgrade installed packages.
RUN apt-get update && apt-get upgrade -y

# Configure SSH server
COPY ssh/sshd.conf /etc/ssh/sshd_config.d/sshd.conf
RUN echo "codespace:codespace" | chpasswd

# Install additional packages
RUN apt-get install -y \
  dnsutils       \
  iputils-ping   \
  ripgrep        \
  tmux

# Open ports
#  SSH  - 8000:2222
#  HTTP - 8001:8001
EXPOSE 2222 8001

USER codespace
WORKDIR /home/codespace
COPY --chown=codespace:codespace bash/.bash_aliases .bash_aliases
COPY --chown=codespace:codespace git/.gitconfig .gitconfig
COPY --chown=codespace:codespace nvim .config/nvim
COPY --chown=codespace:codespace ssh/config .ssh/config
COPY --chown=codespace:codespace tmux/*.sh  .tmux/
COPY --chown=codespace:codespace tmux/.tmux.conf .tmux.conf
