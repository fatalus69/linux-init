#!/usr/bin/env bash

set -ex

working_dir=$(pwd)

echo $working_dir

function install_workflow {
    bash "${working_dir}/applications.sh"
    bash "${working_dir}/zsh.sh"
}



