#!/usr/bin/env bash

PROJECT_NAME="linux-init"

is_command() {
  command -v "$1" &> /dev/null
}

download() {
  if ! which git &> /dev/null; then
    sudo apt install -y git
  fi
  # Remove existing directory if it exists
  rm -rf "${PROJECT_NAME}"
  # Clone the repository
  git clone "https://github.com/fatalus69/${PROJECT_NAME}.git" || exit 1
  cd "$PROJECT_NAME"
}

echo '
+------------------------------------+
        Configuring Ubuntu
+------------------------------------+
'

download

# remove sudo timeout
sudo perl -i -pe "s/^Defaults\tenv_reset.*/Defaults\tenv_reset, timestamp_timeout=-1/" /etc/sudoers

sudo -i sudo -u $USER -i "./init.sh"

# set sudo timeout back to default 15min
sudo perl -i -pe "s/^Defaults\tenv_reset.*/Defaults\tenv_reset, timestamp_timeout=900/" /etc/sudoers