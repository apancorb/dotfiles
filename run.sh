#!/bin/bash

# Display usage instructions
usage() {
  echo "Usage: $0 [--help] [up|down]"
  echo "  --help: Display usage instructions"
  echo "  up: Bring up devcontainer if not running"
  echo "  down: Delete the devcontainer if it exists"
}

# Enable PulseAudio with TCP support for audio forwarding to container
enable_pulseaudio() {
  if ! command -v pulseaudio &> /dev/null; then
    echo "PulseAudio not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
      echo "Error: Homebrew is not installed. Please install Homebrew."
      exit 1
    fi
    brew install pulseaudio
  fi
  if ! pulseaudio --check 2>/dev/null; then
    pulseaudio --load="module-native-protocol-tcp auth-anonymous=1" --exit-idle-time=-1 --daemon
  fi
}

# Update changes from remote repository
update_repository() {
  if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git."
    exit 1
  fi
  git pull origin main
}

# Start sshd and fix Docker socket permissions inside the container
prepare_container() {
  docker exec "$1" sudo sh -c '
    service ssh start
    usermod -aG docker codespace
    chown root:docker /var/run/docker.sock
    chmod 660 /var/run/docker.sock
  '
}

# Install the host user's public key into the container's authorized_keys
install_ssh_pubkey() {
  local container_id="$1"
  local pubkey="${SSH_PUBKEY:-$HOME/.ssh/id_ed25519.pub}"
  if [ ! -f "$pubkey" ]; then
    echo "Error: public key not found at $pubkey. Run 'ssh-keygen -t ed25519' or set SSH_PUBKEY."
    exit 1
  fi
  docker cp "$pubkey" "$container_id":/tmp/pubkey.tmp
  docker exec "$container_id" sudo sh -c '
    cat /tmp/pubkey.tmp >> /home/codespace/.ssh/authorized_keys
    rm /tmp/pubkey.tmp
    chown -R codespace:codespace /home/codespace/.ssh
    chmod 700 /home/codespace/.ssh
    chmod 600 /home/codespace/.ssh/authorized_keys
  '
}

# Make .env vars visible to SSH sessions (sshd scrubs its own env on login,
# but PAM sources /etc/environment for every session it sets up).
install_env_vars() {
  local container_id="$1"
  docker exec -i "$container_id" sudo sh -c '
    grep -E "^[A-Za-z_][A-Za-z0-9_]*=" >> /etc/environment
  ' < .env
}

# Register the container's SSH host key in the host's known_hosts so
# clients with strict host key checking (e.g. Claude Code desktop app) can connect.
register_host_key() {
  mkdir -p "$HOME/.ssh"
  touch "$HOME/.ssh/known_hosts"
  ssh-keygen -R "[localhost]:8000" > /dev/null 2>&1
  ssh-keyscan -p 8000 -H localhost >> "$HOME/.ssh/known_hosts" 2>/dev/null
}

# Connect to running devcontainer
connect_container() {
  local container_id
  container_id=$(docker ps -q --filter "ancestor=devcontainer")
  prepare_container "$container_id"
  if ! ssh devcontainer; then
    echo "Error: Failed to login into the devcontainer."
    exit 1
  fi
}

# Start devcontainer if it exists
start_container() {
  if [ -n "$(docker ps -q --filter ancestor=devcontainer)" ]; then
    connect_container
  elif [ -n "$(docker ps -aq --filter ancestor=devcontainer)" ]; then
    local container_id
    container_id=$(docker ps -aq --filter "ancestor=devcontainer")
    if ! docker start "$container_id" &> /dev/null; then
      echo "Error: Failed to start the devcontainer."
      exit 1
    fi
    # wait for the devcontainer to start before connecting
    sleep 2 && connect_container
  else
    echo "Error: devcontainer does not exist, nothing to start."
    exit 1
  fi
}

# Bring up devcontainer if not running, otherwise, build the container
build_container() {
  if [ -n "$(docker ps -aq --filter ancestor=devcontainer)" ]; then
    echo "Error: devcontainer already exists, skipping build."
    exit 1
  fi
  if [ -z "$HOME" ]; then
    echo "Error: \$HOME is not set."
    exit 1
  fi
  local pubkey="${SSH_PUBKEY:-$HOME/.ssh/id_ed25519.pub}"
  if [ ! -f "$pubkey" ]; then
    echo "Error: public key not found at $pubkey. Run 'ssh-keygen -t ed25519' or set SSH_PUBKEY."
    exit 1
  fi
  if [ ! -f .env ]; then
    echo "Error: .env file not found. Copy .env.example to .env and customize."
    exit 1
  fi
  if ! docker build -t devcontainer .; then
    echo "Error: Failed to build the devcontainer."
    exit 1
  fi
  local container_id
  container_id=$(docker run --privileged -d \
      --platform linux/amd64 \
      -e PULSE_SERVER=host.docker.internal \
      --env-file .env \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v "$HOME"/data:/home/codespace/data \
      -p 8000:2222 \
      -p 8001:8001 \
      devcontainer)
  if [ -z "$container_id" ]; then
    echo "Error: Failed to run the devcontainer."
    exit 1
  fi
  sleep 2
  install_ssh_pubkey "$container_id"
  install_env_vars "$container_id"
  prepare_container "$container_id"
  register_host_key
}

# Delete the devcontainer if it exists
delete_container() {
  local container_id
  container_id=$(docker ps -aq --filter "ancestor=devcontainer")
  if [ -z "$container_id" ]; then
    echo "Error: devcontainer does not exist, nothing to delete."
    exit 1
  fi
  if ! docker rm -f "$container_id" > /dev/null; then
    echo "Error: Failed to remove the devcontainer"
    exit 1
  fi
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --help)
      usage
      exit 0
      ;;
    -*)
      echo "Invalid option: $1" >&2
      usage
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ "$#" -gt 0 ]]; then
  if [[ "$1" == "up" ]]; then
    enable_pulseaudio
    update_repository
    build_container
  elif [[ "$1" == "down" ]]; then
    delete_container
  else
    echo "Invalid argument. Argument must be 'up' or 'down'."
    usage
    exit 1
  fi
else
  enable_pulseaudio
  update_repository
  start_container
fi
