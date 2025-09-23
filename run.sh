#!/bin/bash

# Display usage instructions
usage() {
  echo "Usage: $0 [--help] [up|down]"
  echo "  --help: Display usage instructions"
  echo "  up: Bring up devcontainer if not running"
  echo "  down: Delete the devcontainer if it exists"
}

# Enable SSH agent with GPG support
enable_ssh_agent_with_gpg_support() {
  if ! command -v gpg-agent &> /dev/null; then
    echo "Error: gpg is not installed. Please install gpg."
    echo "Check https://gpgtools.org"
    exit 1
  fi
  eval "$(gpg-agent --daemon --enable-ssh-support > /dev/null)"
}

# Update changes from remote repository
update_repository() {
  if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git."
    exit 1
  fi
  git pull origin main
}

# Connect to running devcontainer
connect_container() {
  # Start SSH service in the new container
  container_id=$(docker ps --format '{{.ID}}' --filter "ancestor=devcontainer")
  docker exec "$container_id" sudo service ssh start

  # Fix Docker permissions
  docker exec "$container_id" sudo usermod -aG docker codespace
  docker exec "$container_id" sudo chown root:docker /var/run/docker.sock
  docker exec "$container_id" sudo chmod 660 /var/run/docker.sock

  if command -v sshpass &> /dev/null; then
    if ! sshpass -p codespace ssh codespace@localhost -p 8000; then
      echo "Error: Failed to login into the devcontainer."
      exit 1
    fi
  else
    echo "Error: sshpass is not installed. Please install sshpass."
    exit 1
  fi
}

# Start devcontainer if it exists
start_container() {
  if docker ps --format '{{.Image}}' | grep -q "devcontainer"; then
    connect_container
  elif docker ps -a --format '{{.Image}}' | grep -q "devcontainer"; then
    container_id=$(docker ps -a --format '{{.ID}}' --filter "ancestor=devcontainer")
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
  if docker ps -a --format '{{.Image}}' | grep -q "devcontainer"; then
    echo "Error: devcontainer already exists, skipping build."
    exit 1 
  fi
  if [ -z "$HOME" ]; then
    echo "Error: \$HOME is not set."
    exit 1
  fi
  if ! docker build -t devcontainer .; then
    echo "Error: Failed to build the devcontainer."
    exit 1
  fi
  if ! docker run --privileged -d \
      --platform linux/amd64 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v "$HOME"/data:/home/codespace/data \
      -p 8000:2222 \
      -p 8001:8001 \
      devcontainer > /dev/null; then
    echo "Error: Failed to run the devcontainer."
    exit 1
  fi
}

# Delete the devcontainer if it exists
delete_container() {
  if docker ps -a --format '{{.Image}}' | grep -q "devcontainer"; then
    container_id=$(docker ps -a --format '{{.ID}}' --filter "ancestor=devcontainer")
    if ! docker rm -f "$container_id" > /dev/null; then
      echo "Error: Failed to remove the devcontainer"
      exit 1
    fi
  else
    echo "Error: devcontainer does not exist, nothing to delete."
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
    enable_ssh_agent_with_gpg_support
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
  enable_ssh_agent_with_gpg_support
  update_repository
  start_container
fi
