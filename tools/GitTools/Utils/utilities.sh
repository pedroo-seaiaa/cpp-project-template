#!/bin/bash

function git_is_submodule() {
    GIT_TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)
    cd $GIT_TOP_LEVEL_DIR
    IS_SUBMODULE=$(test -d .git; echo $?)
    if [[ $IS_SUBMODULE == 1 ]]; then
        return 1
    else
        return 0
    fi
}
