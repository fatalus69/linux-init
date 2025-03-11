#!/usr/bin/env bash

local apt_pckgs = (
    curl,
    wget,
    vim,
    tmux,
    tree,
    tar,
    unzip,
    zip,
    software-properties-common,
    gnupg2,
    apt-transport-https,
    ca-certificates,
    lsb-release,
)

apt install -y "${apt_pckgs[@]}"