# dotfiles

![](https://miro.medium.com/v2/resize:fit:1400/0*tIIPbYu_jOyl9C1H.png)

## Host setup

- **iTerm2** — install [Iterm2](https://iterm2.com/), import [profile.json](iterm2/profile.json), and apply [JetBrainsMono Nerd Font](iterm2/font.tff) at size 14 ([font install guide](https://support.apple.com/guide/font-book/install-and-validate-fonts-fntbk1000/mac)).
- **Caps Lock → Ctrl** — remap via [this guide](https://appleinsider.com/inside/macos/tips/how-to-remap-caps-lock-control-option-command-keys-in-macos).
- **SSH** — copy [ssh/config](ssh/config) to `~/.ssh/config`.

## Claude Code desktop app

Run Claude Code inside the devcontainer via the desktop app's SSH session.

1. Ensure an SSH key exists: `ssh-keygen -t ed25519 -C "macbookpro"` (if `~/.ssh/id_ed25519` is missing).
2. Build and start the container: `./run.sh up` — installs your public key and starts sshd.
3. In the desktop app, open the environment dropdown → **+ Add SSH connection**:

    | Field    | Value                |
    | -------- | -------------------- |
    | Name     | `devcontainer`       |
    | SSH Host | `codespace@localhost`|
    | SSH Port | `8000`               |

4. Select the `devcontainer` environment to launch a session.

For a terminal shell, run `./run.sh`; `./run.sh down` removes the container.

---

*More on devcontainers in [this post](https://www.tony.software/posts/developing_inside_container/).*
