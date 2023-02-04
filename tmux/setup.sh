#! /bin/sh

REPOSRC="https://github.com/tmux-plugins/tpm"
LOCALREPO="$HOME/.tmux/plugins/tpm"

git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull 1> /dev/null
