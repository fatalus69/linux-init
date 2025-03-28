#!/usr/bin/env bash

set -e

# Install zsh if not installed
if ! which zsh &> /dev/null; then
    sudo apt install -y zsh
fi

# Install perl if not installed
if ! command -v perl &> /dev/null; then
    sudo apt install -y perl
fi

# Change default shell to zsh
sudo chsh -s `command -v zsh` $USER
export PROFILE=~/.zshrc

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

curl -sSL https://github.com/zthxxx/jovial/raw/master/installer.sh | sudo -E bash -s ${USER:=`whoami`}

perl ./modify-files.pl zsh

source ~/.zshrc