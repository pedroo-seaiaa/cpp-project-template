#!/bin/bash

# ############################################################################
# Entrypoint
# ############################################################################

# Get 
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#
LOGGER_PATH=$ROOT_DIR/tools/GitTools/Utils/logger.sh

#
GIT_HOOKS_PATH=$ROOT_DIR/tools/GitTools/Hooks

#
PYTHON_SETUP_SCRIPT_PATH=$ROOT_DIR/tools/BuildTools/scripts/setup.py

# Include/Import logger
source $LOGGER_PATH

# TODO(PO): remove this
set_log_level $LOG_LEVEL_TRACE

# Parse command line arguments
# TODO: add --install-missing or something like that
VERBOSE=0
while getopts 'v' flag; do
    case "${flag}" in
    v)
        VERBOSE=1
        LOG_VERBOSITY=1
        set_log_level LOG_LEVEL_TRACE
        ;;
    ?)
        echo "script usage: $(basename \$0) [-v]" >&2
        exit 1
        ;;
    esac
done

# ############################################################################
# Helper Functions
# - setup_git_hooks
# - run_python_setup
# ############################################################################

function setup_git_hooks() {
    log_trace "setup_git_hooks"

    read -p "Do you want to configure the git hooks? (yes/no): " UserInput
    if [ "$UserInput" = "yes" ]; then
        log_warn "Configuring Git Hooks ..."
        if [ -d "$GIT_HOOKS_PATH" ]; then
            log_warn "Installing hooks ..."
            git config core.hooksPath "$GIT_HOOKS_PATH"
            log_info "Installing hooks --- SUCCESS"
            log_info "Configuring Git Hooks --- SUCCESS"
        else
            log_warn "Installing hooks --- FAILED"
            log_warn "Configuring Git Hooks --- FAILED"
        fi
    else
        log_info "Skipping git hooks configuration."
    fi
}

DEFAULT_PYTHON_VERSION="3.10.12"
function run_python_setup() {
    log_warn "Testing if python is installed or in PATH ..."
    if command -v python >/dev/null 2>&1; then
        log_info "Testing if python is installed or in PATH --- SUCCESS"
        log_warn "Checking python for version ${DEFAULT_PYTHON_VERSION} ..."
        if python --version | grep -q "Python ${DEFAULT_PYTHON_VERSION}"; then
            log_info "Checking python for version ${DEFAULT_PYTHON_VERSION} --- SUCCESS"
        else
            log_error "Checking python for version ${DEFAULT_PYTHON_VERSION} --- FAILED"
            log_warn "This project was tested with Python ${DEFAULT_PYTHON_VERSION}. Other versions may not work as expected."
        fi

    else
        log_fatal "Testing if python is installed or in PATH --- FAILED"
    fi

    log_warn "Detecting setup.py ..."
    if [ -e "$PYTHON_SETUP_SCRIPT_PATH" ]; then
        log_warn "Detecting setup.py --- SUCCESS"
        log_warn "Running setup.py"
        PYTHON_VERSION=$(python --version)
        log_debug "PYTHON_VERSION: $PYTHON_VERSION"
        python $PYTHON_SETUP_SCRIPT_PATH
    else
        log_fatal "Detecting setup.py --- FAILED"
    fi
}

# ############################################################################
# Main Function
# ############################################################################

main() {
    log_message " === Linux Configuration Batch File (version 0.1.0) ==="
    setup_git_hooks
    run_python_setup
}

main
