#!/bin/bash

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

LOG_LEVEL_TRACE=2
LOG_LEVEL_DEBUG=3
LOG_LEVEL_INFO=4
LOG_LEVEL_WARN=5
LOG_LEVEL_ERROR=6

export LOG_VERBOSITY=1

CURRENT_LOG_LEVEL=$LOG_LEVEL_INFO
if [[ $LOG_VERBOSITY = 1 ]]; then
    echo "changing logger verbosity"
    CURRENT_LOG_LEVEL=$LOG_LEVEL_TRACE
fi

# =============================================================================
# Functions Definitions
# =============================================================================

function set_log_level() {
    CURRENT_LOG_LEVEL=$1
}

function log_message() {
    echo -e "$1"
}

function log_trace() {
    if [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_TRACE ]]; then
        if [[ $LOG_VERBOSITY = 1 ]]; then
            THIS_SCRIPT="[${0##*/}]"
        else
            THIS_SCRIPT=""
        fi
        log_message "$BWhite${THIS_SCRIPT}[T] $1 $Color_Off"
    fi
}

function log_debug() {
    if [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_DEBUG ]]; then
        if [[ $LOG_VERBOSITY = 1 ]]; then
            THIS_SCRIPT="[${0##*/}]"
        else
            THIS_SCRIPT=""
        fi
        log_message "$Cyan${THIS_SCRIPT}[D] $1 $Color_Off"
    fi
}

function log_info() {
    if [[ $LOG_VERBOSITY = 1 ]]; then
        THIS_SCRIPT="[${0##*/}]"
    else
        THIS_SCRIPT=""
    fi
    log_message "$Green${THIS_SCRIPT}[I] $1 $Color_Off"
}

function log_warn() {
    if [[ $LOG_VERBOSITY = 1 ]]; then
        THIS_SCRIPT="[${0##*/}]"
    else
        THIS_SCRIPT=""
    fi
    log_message "$Yellow${THIS_SCRIPT}[W] $1 $Color_Off"
}

function log_error() {
    if [[ $LOG_VERBOSITY = 1 ]]; then
        THIS_SCRIPT="[${0##*/}]"
    else
        THIS_SCRIPT=""
    fi
    log_message "$Red${THIS_SCRIPT}[E] $1 $Color_Off"
}

function log_fatal() {
    if [[ $LOG_VERBOSITY = 1 ]]; then
        THIS_SCRIPT="[${0##*/}]"
    else
        THIS_SCRIPT=""
    fi
    log_message "$On_Red${THIS_SCRIPT}[F] $1$Color_Off"
    exit 1
}


log_info " === Running Initial Configuration Setup === "

log_warn "Detecting docker image tagged with aiaa-linux ..."
IMAGE_ID=$(docker images -q aiaa-linux)
if [ "$IMAGE_ID" = "" ]; then
    log_error "Detecting docker image tagged with aiaa-linux --- FAILURE"
    
    log_warn "Building aiaa-linux from Dockerfile ..."
    docker build -f ../docker/linux.Dockerfile ../docker/ --tag aiaa-linux > /dev/null
    IMAGE_ID=$(docker images -q aiaa-linux)
    if [ "$IMAGE_ID" = "" ]; then
        log_fatal "Building aiaa-linux from Dockerfile --- FAILURE"
    else
        log_info "Building aiaa-linux from Dockerfile --- SUCCESS"
    fi
else
    log_info "Detecting docker image tagged with aiaa-linux --- SUCCESS"
fi

log_warn "Running project setup through aiaa-linux ..."
docker run --rm aiaa-linux


# # debug
log_debug ""
log_debug " === before === "
log_debug "containers:"
docker container ls -a
log_debug "images:"
docker images

# # clean-up

# # debug
log_debug ""
log_debug " === after === "
log_debug "containers:"
docker container ls -a
log_debug "images:"
docker images

# # TIPS(PO): command to remove all docker containers
# #docker ps -aq | xargs docker rm
