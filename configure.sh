#!/bin/bash

VERBOSE=0
while getopts 'v' flag; do
    case "${flag}" in
    v)
        VERBOSE=1
        ;;
    ?)
        echo "script usage: $(basename \$0) [-v]" >&2
        exit 1
        ;;
    esac
done

# ############################################################################
# TODO(PO): import logger.sh
# ############################################################################

# =============================================================================
# Color Definitions
# see also: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# =============================================================================

# Reset
Color_Off='\033[0m' # Text Reset

# Regular Colors
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;37m'  # White

# Bold
BBlack='\033[1;30m'  # Black
BRed='\033[1;31m'    # Red
BGreen='\033[1;32m'  # Green
BYellow='\033[1;33m' # Yellow
BBlue='\033[1;34m'   # Blue
BPurple='\033[1;35m' # Purple
BCyan='\033[1;36m'   # Cyan
BWhite='\033[1;37m'  # White

# Underline
UBlack='\033[4;30m'  # Black
URed='\033[4;31m'    # Red
UGreen='\033[4;32m'  # Green
UYellow='\033[4;33m' # Yellow
UBlue='\033[4;34m'   # Blue
UPurple='\033[4;35m' # Purple
UCyan='\033[4;36m'   # Cyan
UWhite='\033[4;37m'  # White

# Background
On_Black='\033[40m'  # Black
On_Red='\033[41m'    # Red
On_Green='\033[42m'  # Green
On_Yellow='\033[43m' # Yellow
On_Blue='\033[44m'   # Blue
On_Purple='\033[45m' # Purple
On_Cyan='\033[46m'   # Cyan
On_White='\033[47m'  # White

# =============================================================================
# Log Level Definitions
# =============================================================================

export CMAKE_LOG_LEVEL_TRACE=2
export CMAKE_LOG_LEVEL_DEBUG=3
export CMAKE_LOG_LEVEL_INFO=4
export CMAKE_LOG_LEVEL_WARN=5
export CMAKE_LOG_LEVEL_ERROR=6

CMAKE_CURRENT_LOG_LEVEL=$CMAKE_LOG_LEVEL_INFO
if [[ $VERBOSE = 1 ]]; then
    CMAKE_CURRENT_LOG_LEVEL=$CMAKE_LOG_LEVEL_TRACE
fi

# =============================================================================
# Functions Definitions
# =============================================================================

function log_message() {
    echo -e "$1"
}

function log_trace() {
    if [[ $CMAKE_CURRENT_LOG_LEVEL -le $CMAKE_LOG_LEVEL_TRACE ]]; then
        if [[ $VERBOSE = 1 ]]; then
            THIS_SCRIPT="[${0##*/}]"
        else
            THIS_SCRIPT=""
        fi
        log_message "$BWhite${THIS_SCRIPT}[T] $1 $Color_Off"
    fi
}

function log_debug() {
    if [[ $CMAKE_CURRENT_LOG_LEVEL -le $CMAKE_LOG_LEVEL_DEBUG ]]; then
        if [[ $VERBOSE = 1 ]]; then
            THIS_SCRIPT="[${0##*/}]"
        else
            THIS_SCRIPT=""
        fi
        log_message "$Cyan${THIS_SCRIPT}[D] $1 $Color_Off"
    fi
}

function log_info() {
    if [[ $VERBOSE = 1 ]]; then
        THIS_SCRIPT="[${0##*/}]"
    else
        THIS_SCRIPT=""
    fi
    log_message "$Green${THIS_SCRIPT}[I] $1 $Color_Off"
}

function log_warn() {
    if [[ $VERBOSE = 1 ]]; then
        THIS_SCRIPT="[${0##*/}]"
    else
        THIS_SCRIPT=""
    fi
    log_message "$Yellow${THIS_SCRIPT}[W] $1 $Color_Off"
}

function log_error() {
    if [[ $VERBOSE = 1 ]]; then
        THIS_SCRIPT="[${0##*/}]"
    else
        THIS_SCRIPT=""
    fi
    log_message "$Red${THIS_SCRIPT}[E] $1 $Color_Off"
}

function log_fatal() {
    if [[ $VERBOSE = 1 ]]; then
        THIS_SCRIPT="[${0##*/}]"
    else
        THIS_SCRIPT=""
    fi
    log_message "$On_Red${THIS_SCRIPT}[F] $1$Color_Off"
    exit 1
}

# ############################################################################
# Functions
# ############################################################################

function setup_git_hooks() {
    log_trace "setup_git_hooks"
    log_warn "Configuring Git Hooks ..."
    if [ -d "./tools/GitTools/Hooks" ]; then
        log_warn "Installing hooks ..."
        git config core.hooksPath ./tools/GitTools/Hooks
        log_info "Installing hooks --- SUCCESS"
        log_info "Configuring Git Hooks --- SUCCESS"
    else
        log_warn "Installing hooks --- FAILED"
        log_warn "Configuring Git Hooks --- FAILED"
    fi
}

function run_python_setup() {
    log_warn "Testing if python is installed or in PATH ..."
    if command -v python >/dev/null 2>&1; then
        log_info "Testing if python is installed or in PATH --- SUCCESS"
        log_warn "Checking python for version 3.12.0 ..."
        if python --version | grep -q "Python 3.12.0"; then
            log_info "Checking python for version 3.12.0 --- SUCCESS"
        else
            log_error "Checking python for version 3.12.0 --- FAILED"
            log_info "This project was tested with Python 3.12.0. Other versions may not work as expected."
        fi

    else
        log_fatal "Testing if python is installed or in PATH --- FAILED"
    fi

    log_warn "Detecting setup.py ..."
    if [ -e "./tools/scripts/setup.py" ]; then
        log_warn "Detecting setup.py --- SUCCESS"
        log_warn "Running setup.py"
        python --version
        python ./tools/scripts/setup.py
    else
        log_fatal "Detecting setup.py --- FAILED"
    fi
}

# ############################################################################
# Main Entry Point
# ############################################################################

main() {
    log_message " === Linux Configuration Batch File (version 0.1.0) ==="
    setup_git_hooks
    run_python_setup
}

main
