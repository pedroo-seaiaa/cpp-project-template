#!/bin/bash

# ============================================================================
# Set PROJECT_ROOT_DIR
# ============================================================================

# navigate to project root directory (this works as long as not in a submodule)
git_dir=$(git rev-parse --show-toplevel)

# import git utilities
GIT_UTILITIES_SCRIPT_PATH=$git_dir/tools/GitTools//Utils/utilities.sh
test -f $GIT_UTILITIES_SCRIPT_PATH || (echo "File not found: $GIT_UTILITIES_SCRIPT_PATH" && exit 1)
source $GIT_UTILITIES_SCRIPT_PATH || (echo "Failed to source $GIT_UTILITIES_SCRIPT_PATH" && exit 1)

# detect if this tools folder is a submodule or not
IS_SUBMODULE=$(
    git_is_submodule
    echo $?
)

# getting the root level directory of the project
PROJECT_ROOT_DIR=$(git rev-parse --show-toplevel)
if [[ $IS_SUBMODULE == 1 ]]; then
    cd "${PROJECT_ROOT_DIR}/.."
    PROJECT_ROOT_DIR=$(git rev-parse --show-toplevel)
fi

# ============================================================================
# Include logger
# ============================================================================

# import logger
source ${PROJECT_ROOT_DIR}/tools/GitTools/Utils/logger.sh
# set_log_level $LOG_LEVEL_TRACE

# ============================================================================
# Test Initial Project Setup through Docker
# ============================================================================

LINUX_DOCKERFILE_PATH=$PROJECT_ROOT_DIR/tests/SetupTests/docker/
log_debug "LINUX_DOCKERFILE_PATH $LINUX_DOCKERFILE_PATH"

# ----------------------------------------------------------------------------
# Declarations
# ----------------------------------------------------------------------------

log_info " === Running Initial Project Setup (through Docker) === "

log_warn "Detecting docker installation ..."
if command -v docker &>/dev/null; then
    log_warn "Detecting docker installation --- SUCCESS"
else
    log_fatal "Detecting docker installation --- FAILURE"
fi

log_warn "Detecting docker image tagged with aiaa-linux ..."
IMAGE_ID=$(docker images -q aiaa-linux)
if [ "$IMAGE_ID" = "" ]; then
    log_error "Detecting docker image tagged with aiaa-linux --- FAILURE"

    log_warn "Building aiaa-linux from Dockerfile ..."
    docker build -f ${LINUX_DOCKERFILE_PATH}/linux.Dockerfile ${LINUX_DOCKERFILE_PATH} --tag aiaa-linux
    IMAGE_ID=$(docker images -q aiaa-linux)
    if [ "$IMAGE_ID" = "" ]; then
        log_fatal "Building aiaa-linux from Dockerfile --- FAILURE"
    else
        log_info "Building aiaa-linux from Dockerfile --- SUCCESS"
    fi
else
    log_info "Detecting docker image tagged with aiaa-linux --- SUCCESS"
fi

VOLUME_NAME="cpp-template-project"
log_warn "Running project setup through aiaa-linux ..."
cd ${PROJECT_ROOT_DIR}/..
docker run --rm -it --mount type=bind,source=${PROJECT_ROOT_DIR},target=/${VOLUME_NAME} aiaa-linux bash
#docker run --rm aiaa-linux -v ${VOLUME_NAME}:/${VOLUME_NAME}

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
