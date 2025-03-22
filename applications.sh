#!/usr/bin/env bash

apt_pckgs=(
    curl
    wget
    vim
    tmux
    tree
    tar
    unzip
    zip
    software-properties-common
    gnupg2
    apt-transport-https
    ca-certificates
    lsb-release
    neofetch
    openssl
    make
    gcc
    g++
)

npm_pckgs=(
    typescript
)

sudo apt install -y "${apt_pckgs[@]}"

npm install -g "${npm_pckgs[@]}"