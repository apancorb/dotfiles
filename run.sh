#!/bin/bash

# Display usage instructions
usage() {
  echo "Usage: $0 [--gpg | --help] [up|down]"
  echo "    --help: Display usage instructions"
  echo "    --gpg: SSH authentication using GPG keys"
  echo "    up: Bring up devcontainer if not running"
  echo "    down: Delete the devcontainer if it exists"
}

# Enable SSH agent with GPG support
enable_ssh_agent_with_gpg_support() {
  if command -v gpg &> /dev/null; then
    eval "$(gpg-agent --daemon --enable-ssh-support > /dev/null)"
  else
    echo "Error: gpg is not installed. Please install gpg."
    echo "Check https://gpgtools.org"
    exit 1
  fi
}

# Enable default SSH agent
enable_default_ssh_agent() {
  eval "$(ssh-agent)" 1> /dev/null
}

connect_container() {
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
    sleep 2
    connect_container
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

gpg_flag=false
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --gpg)
      # Execute GPG commands
      enable_ssh_agent_with_gpg_support
      gpg_flag=true
      shift
      ;;
    --help)
      # Display usage instructions
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

# Check if the script is called with additional argument
if [[ "$#" -gt 0 ]]; then
  # Check if the argument is "up" or "down"
  if [[ "$1" == "up" ]]; then
    build_container
  elif [[ "$1" == "down" ]]; then
    delete_container
  else
    echo "Invalid argument. Argument must be 'up' or 'down'."
    usage
    exit 1
  fi
else
  # Check if --gpg flag is not provided
  if ! $gpg_flag; then
    enable_default_ssh_agent
  fi
  start_container
fi
