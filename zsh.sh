#!/usr/bin/env bash

set -ex

# Install zsh if not installed
if ! which zsh &> /dev/null; then
    sudo apt install -y zsh
fi

# Change default shell to zsh
sudo chsh -s `command -v zsh` $USER

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

python3 modify_zshrc.py