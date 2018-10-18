#!/usr/bin/env bash
set -euo pipefail

# IMPORTANT:
# mirror-container supports only dir copies for now.
# Because container src is not running, we cannot know whether the source is a file or a dir.
# For this reason and to simplify the logic, we support only dir copies.

usage()
{
    printf "${YELLOW}Usage:${COLOR_RESET}\n"
    echo "  mirror-container [options] [path1] ... [pathN]"
    echo ""
    printf "${YELLOW}Options:${COLOR_RESET}\n"
    printf "  ${GREEN}-f, --force${COLOR_RESET}     Do not ask confirmation to remove host destination\n"
    echo ""
    echo "Example:"
    printf "  ${GREEN}dockergento mirror-container generated${COLOR_RESET}\n"
}

if [ "$#" == 0 ] || [ "$1" == "--help" ]; then
    usage
    exit 0
fi

if [[ "${MACHINE}" != "mac" ]] && [[ "${MACHINE}" != "windows" ]]; then
    printf "${RED} This command is only for mac and windows systems.${COLOR_RESET}\n"
    exit 1
fi

ANSWER_REMOVE_DEST=""
if [[ "$1" == "--force" || "$1" == "-f" ]]; then
    ANSWER_REMOVE_DEST='y'
    shift
fi

# IMPORTANT:
# Docker cp from container to host needs to be done in a not running container.
# Otherwise the docker.hyperkit gets crazy and breaks the bind mounts
${COMMANDS_DIR}/stop.sh

source ${TASKS_DIR}/mirror_path.sh

clear_dest_dir()
{
    DEST_PATH=$1

    if [ "${ANSWER_REMOVE_DEST}" != "y" ]; then
        read -p "Confirm removing '${DEST_PATH}/*' in host (y/n [n])? " ANSWER_REMOVE_DEST
    fi

    if [ "${ANSWER_REMOVE_DEST}" == "y" ]; then
        echo "rm -rf ${DEST_PATH}/*"
        rm -rf ${DEST_PATH}/*
    else
        echo " > deletion skipped"
    fi
}

printf "${GREEN}Start mirror copy of container into host${COLOR_RESET}\n"
CONTAINER_ID=$(${DOCKER_COMPOSE} ps -q ${SERVICE_PHP})

for PATH_TO_MIRROR in $@
do
    printf "${YELLOW}${SERVICE_PHP}:${PATH_TO_MIRROR} -> ${PATH_TO_MIRROR}${COLOR_RESET}\n"

    echo " > validating and sanitizing path: '${PATH_TO_MIRROR}'"
    PATH_TO_MIRROR=$(sanitize_mirror_path "${PATH_TO_MIRROR}")

    SRC_PATH="${PATH_TO_MIRROR}/."
    DEST_PATH="${PATH_TO_MIRROR}"

    echo " > removing destination content: '${DEST_PATH}'"
    clear_dest_dir "${DEST_PATH}"
    echo " > ensure destination exists: '${DEST_PATH}'"
    mkdir -p ${DEST_PATH}

    echo " > copying '${SERVICE_PHP}:${WORKDIR_PHP}/${SRC_PATH}' into '${DEST_PATH}'"
    docker cp ${CONTAINER_ID}:${WORKDIR_PHP}/${SRC_PATH} ${DEST_PATH}
done

printf "${GREEN}Container mirrored into host${COLOR_RESET}\n"

# Start containers again because we needed to stop them before mirroring
${COMMANDS_DIR}/start.sh
