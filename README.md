# dotfiles

![](https://miro.medium.com/v2/resize:fit:1400/0*tIIPbYu_jOyl9C1H.png)

1. Download [Iterm2](https://iterm2.com/).
    - Import [profile.json](https://github.com/apancorb/dotfiles/blob/main/iterm2/profile.json).
    - Apply the [JetBrainsMono Nerd Font](https://github.com/apancorb/dotfiles/blob/main/iterm2/font.tff) by following this [guide](https://support.apple.com/guide/font-book/install-and-validate-fonts-fntbk1000/mac#:~:text=Install%20fonts&text=Do%20any%20of%20the%20following,in%20the%20dialog%20that%20appears.), font size should be 14.
2. Remap the Caps Locks key to the Ctrl key.
    - See this [guide](https://appleinsider.com/inside/macos/tips/how-to-remap-caps-lock-control-option-command-keys-in-macos).
3. Add SSH client configuration.
    - Add [config](https://github.com/apancorb/dotfiles/blob/main/ssh/config) inside the `~/.ssh` directory.

## Claude Code desktop app

Run Claude Code inside the devcontainer from the desktop app via the SSH Session feature.

1. Ensure an SSH key exists at `~/.ssh/id_ed25519`. If not: `ssh-keygen -t ed25519 -C "macbookpro"`.
2. Copy [ssh/config](https://github.com/apancorb/dotfiles/blob/main/ssh/config) to `~/.ssh/config` (same as step 3 above) — this defines the `devcontainer` host alias.
3. Build and start the container: `./run.sh up`. The script installs your public key into the container's `authorized_keys` and starts sshd.
4. In the Claude Code desktop app, open the environment dropdown → **+ Add SSH connection**.
    - Name: `devcontainer`
    - SSH Host: `codespace@localhost`
    - SSH Port: `8000`
    - Save.
5. Select the `devcontainer` environment to start a Claude Code session inside the container.
6. For a terminal shell into the container, run `./run.sh`. When done, `./run.sh down` removes it.

---

*For more information about devcontainers, visit [this](https://www.tony.software/posts/developing_inside_container/) post from my site.*
