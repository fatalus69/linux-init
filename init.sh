#!/usr/bin/env bash

set -ex

working_dir=$(pwd)

function install_workflow {
    bash "${working_dir}/applications.sh"
    bash "${working_dir}/zsh.sh"
    bash "${working_dir}/custom-install.sh"
}
