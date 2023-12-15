#!/bin/bash

reset

# ============================================================================
# Set PROJECT_ROOT_DIR & REPO_NAME
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

GIT_REMOTE_URL=$(git remote get-url origin)
REPO_NAME=$(basename $GIT_REMOTE_URL | sed 's/\.git$//')

# ============================================================================
# Include logger
# ============================================================================

# import logger
source ${PROJECT_ROOT_DIR}/tools/GitTools/Utils/logger.sh
# TODO(PO): remove this
set_log_level $LOG_LEVEL_TRACE

# ============================================================================
# Test Initial Project Setup through Docker
# ============================================================================

log_info " === Running Initial Project Setup (through Docker) === "

LINUX_DOCKERFILE_PATH=$PROJECT_ROOT_DIR/tests/SetupTests/docker/
log_debug "LINUX_DOCKERFILE_PATH $LINUX_DOCKERFILE_PATH"

# ----------------------------------------------------------------------------
# Detect Docker Installation
# ----------------------------------------------------------------------------

log_warn "Detecting docker installation ..."
if command -v docker &>/dev/null; then
    log_warn "Detecting docker installation --- SUCCESS"
else
    log_fatal "Detecting docker installation --- FAILURE"
fi

# ----------------------------------------------------------------------------
# Detect Docker Image
# ----------------------------------------------------------------------------

DOCKER_IMAGE_TAG="docker-image-${REPO_NAME}"
log_warn "Detecting docker image tagged with ${DOCKER_IMAGE_TAG} ..."
DOCKER_IMAGE_ID=$(docker images -q ${DOCKER_IMAGE_TAG})
if [ "$DOCKER_IMAGE_ID" = "" ]; then
    log_error "Detecting docker image tagged with ${DOCKER_IMAGE_TAG} --- FAILURE"

    log_warn "Building ${DOCKER_IMAGE_TAG} from Dockerfile ..."
    docker build -f ${LINUX_DOCKERFILE_PATH}/linux.Dockerfile ${LINUX_DOCKERFILE_PATH} --tag ${DOCKER_IMAGE_TAG}
    DOCKER_IMAGE_ID=$(docker images -q ${DOCKER_IMAGE_TAG})
    if [ "$DOCKER_IMAGE_ID" = "" ]; then
        log_fatal "Building ${DOCKER_IMAGE_TAG} from Dockerfile --- FAILURE"
    else
        log_info "Building ${DOCKER_IMAGE_TAG} from Dockerfile --- SUCCESS"
    fi
else
    log_info "Detecting docker image tagged with ${DOCKER_IMAGE_TAG} --- SUCCESS"
fi

# ----------------------------------------------------------------------------
# Run Docker Image with this repository as Volume
# ----------------------------------------------------------------------------

DOCKER_VOLUME_NAME="docker-volume-${REPO_NAME}"
log_warn "Running project setup through ${DOCKER_IMAGE_TAG} ..."
cd ${PROJECT_ROOT_DIR}/..

sleep 1

DOCKER_ENTRYPOINT_CMD="echo '[${DOCKER_IMAGE_TAG}] hello-pedro' && cd ${DOCKER_VOLUME_NAME} && ./configure.sh && exit 0"

# docker run --rm -it --mount type=bind,source=${PROJECT_ROOT_DIR},target=/${DOCKER_VOLUME_NAME} ${DOCKER_IMAGE_TAG} bash
docker run --rm -it --mount type=bind,source=${PROJECT_ROOT_DIR},target=/${DOCKER_VOLUME_NAME} ${DOCKER_IMAGE_TAG} bash -c "${DOCKER_ENTRYPOINT_CMD}"

sleep 1

if [ "$?" != 0 ]; then
    log_error "Running project setup through ${DOCKER_IMAGE_TAG} --- FAILURE"
else
    log_info "Running project setup through ${DOCKER_IMAGE_TAG} --- SUCCESS"
fi

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

echo ""
echo -ne "Clearing screen in ..."
sleep 1
echo -ne "\r"
echo -ne "\rClearing screen in 2  "
sleep 1
echo -ne "\rClearing screen in 1  "
sleep 1

# reset
