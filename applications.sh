#!/usr/bin/env bash

local dev_apt_pckgs = (
    python3,
    python3-full,
    curl,
    wget,
    vim,
    tmux,
    tree,
)

apt install -y "${dev_apt_pckgs[@]}"