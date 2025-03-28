#!/usr/bin/env bash

PROJECT_NAME="linux-init"

is_command() {
  command -v "$1" &> /dev/null
}

download() {
  if ! is_command git; then
    sudo apt install -y git
  fi
  # Remove existing directory if it exists
  rm -rf "${PROJECT_NAME}"
  # Clone the repository
  git clone "https://github.com/fatalus69/${PROJECT_NAME}.git" || exit 1
  cd "$PROJECT_NAME" || { echo "Failed to enter $PROJECT_NAME directory"; exit 1; }
}

echo '
+------------------------------------+
        Configuring Ubuntu
+------------------------------------+
'

download

# remove sudo timeout
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER-init

sudo -u "$USER" bash "./init.sh"

# set sudo timeout back to default 15min
sudo rm -f /etc/sudoers.d/$USER-init