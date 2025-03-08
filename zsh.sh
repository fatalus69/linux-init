#!/usr/bin/env bash

set -ex

# Install zsh if not installed
if ! which zsh &> /dev/null; then
    sudo apt install -y zsh
fi

# Install perl if not installed
if ! command -v perl &> /dev/null; then
    sudo apt install -y perl
fi

perl_executable=$(which perl)

# Change default shell to zsh
sudo chsh -s `command -v zsh` $USER

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

$perl_executable ./modify-zshrc.pl

source ~/.zshrc