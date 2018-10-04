#!/usr/bin/env bash
set -eu

usage()
{
    printf "${YELLOW}Usage:${COLOR_RESET}\n"
    echo "  magento-urn-generate <path>"
    echo ""
    echo "Example:"
    printf "  ${GREEN}dockergento magento-urn-generate .idea/misc.xml${COLOR_RESET}\n"
}

if [ "$#" == 0 ] || [ "$1" == "--help" ]; then
    usage
    exit 0
fi

echo " > Generating urn-catalog in container"
MISC_PATH=$1
${COMMANDS_DIR}/exec.sh sh -c "mkdir -p $(dirname .idea/misc.xml)"
${COMMANDS_DIR}/magento.sh dev:urn-catalog:generate ${MISC_PATH}

ABSOLUTE_HOST_DIR=$(pwd)
echo " > Replacing paths: '${WORKDIR_PHP} -> ${ABSOLUTE_HOST_DIR}'"
${COMMANDS_DIR}/exec.sh sh -c "sed -i s#${WORKDIR_PHP}#${ABSOLUTE_HOST_DIR}#g ${MISC_PATH}"

echo " > Copying generated urn from container into host"
CONTAINER_ID=$(${DOCKER_COMPOSE} ps -q ${SERVICE_PHP})
docker cp ${CONTAINER_ID}:${WORKDIR_PHP}/${MISC_PATH} ${MISC_PATH}
