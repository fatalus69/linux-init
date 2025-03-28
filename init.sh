#!/usr/bin/env bash

set -e

run_script() {
    local script="$1"
    
    if [[ -f "$script" ]]; then
        bash "$script"
    else
        echo "!!! Warning: $script not found. Skipping..."
    fi
}

run_script "./applications.sh"
run_script "./zsh.sh"
run_script "./custom-install.sh"