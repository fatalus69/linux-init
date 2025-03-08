#!/usr/bin/env bash

local dev_apt_pckgs = (
    curl,
    wget,
    vim,
    tmux,
    tree,
)

apt install -y "${dev_apt_pckgs[@]}"