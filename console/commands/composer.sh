#!/usr/bin/env bash
set -euo pipefail

mirror_vendor_host_into_container()
{
    printf "${GREEN}Mirror vendor into container before executing composer${COLOR_RESET}\n"
    if [ ! -d "${MAGENTO_DIR}/vendor" ]; then
        echo " > creating '${MAGENTO_DIR}/vendor' in host"
        mkdir -p "${MAGENTO_DIR}/vendor"
    fi
    ${COMMANDS_DIR}/mirror-host.sh vendor
}

sync_all_from_container_to_host()
{
    # IMPORTANT:
    # Docker cp from container to host needs to be done in a not running container.
    # Otherwise the docker.hyperkit gets crazy and breaks the bind mounts
    ${COMMANDS_DIR}/stop.sh

    printf "${GREEN}First time setup: copying all files from container${COLOR_RESET}\n"
    echo " > removing vendor content: '${HOST_DIR}/${MAGENTO_DIR}/vendor/*'"
    rm -rf ${HOST_DIR}/${MAGENTO_DIR}/vendor/*

    echo " > copying '${SERVICE_PHP}:${WORKDIR_PHP}/.' into '${HOST_DIR}'"
    CONTAINER_ID=$(${DOCKER_COMPOSE} ps -q ${SERVICE_PHP})
    docker cp ${CONTAINER_ID}:${WORKDIR_PHP}/. ${HOST_DIR}

    # Start containers again because we needed to stop them before mirroring
    ${COMMANDS_DIR}/start.sh
}

sync_vendor_updates_into_host()
{
    COMPOSER_OUTPUT=$1
    source ${TASKS_DIR}/composer_output_parser.sh

    UPDATES_OUTPUT=$(getUpdatesFromOutput "${COMPOSER_OUTPUT}")
    if [ "$UPDATES_OUTPUT" == "" ]; then
        printf "\n${GREEN}No dependencies updated. Nothing to Sync${COLOR_RESET}\n"
        return 0
    fi

    PATHS_TO_UPDATE=$(getUpdatedDependencies "${UPDATES_OUTPUT}" "vendor/")
    if [ "${PATHS_TO_UPDATE}" != "" ]; then
        printf "\n${GREEN}Starting sync of updated dependencies${COLOR_RESET}\n"
        ${COMMANDS_DIR}/mirror-container.sh -f ${PATHS_TO_UPDATE} | grep "copying"
    fi

    PATHS_TO_REMOVE=$(getRemovedDependencies "$UPDATES_OUTPUT" "vendor/")
    if [ "${PATHS_TO_REMOVE}" != "" ]; then
        printf "\n${GREEN}Deleting removed dependencies${COLOR_RESET}\n"
        for PATH_TO_REMOVE in ${PATHS_TO_REMOVE}
        do
            if [[ ${PATH_TO_REMOVE} != *"vendor"* ]]; then
                printf "${RED}Dependency cannot be removed: '${PATH_TO_REMOVE}'${COLOR_RESET}\n"
                continue
            fi
            echo " > rm -rf ${PATH_TO_REMOVE}"
            rm -rf ${PATH_TO_REMOVE}
        done
    fi
}

if [[ "$#" != 0 && "$1" == "create-project" ]]; then
    printf "${RED}create-project is not compatible with dockergento. Please use:${COLOR_RESET}\n"
        echo ""
        echo "  dockergento create-project"
        echo ""
        exit 1
fi

if [[ "$#" != 0 \
    && ( "${MACHINE}" == "mac" || "${MACHINE}" == "windows" ) \
    && ( "$1" == "install" || "$1" == "update" || "$1" == "require" || "$1" == "remove" ) ]]
then
    printf "${GREEN}Validating composer before doing anything${COLOR_RESET}\n"
    VALIDATION_OUTPUT=$(${COMMANDS_DIR}/exec.sh composer validate) \
     || if [ $? == 1 ]; then echo "${VALIDATION_OUTPUT}"; exit 1; fi

    MAGENTO2_MODULE_PATH="${MAGENTO_DIR}/vendor/magento/magento2-base"
    MAGENTO_EXISTS_IN_CONTAINER=$(${COMMANDS_DIR}/exec.sh sh -c "[ -f ${MAGENTO2_MODULE_PATH}/composer.json ] && echo true || echo false")
    MAGENTO_EXISTS_IN_HOST=$([ -f ${MAGENTO2_MODULE_PATH}/composer.json ] && echo true || echo false)
    if [[ ${MAGENTO_EXISTS_IN_HOST} == true && ${MAGENTO_EXISTS_IN_CONTAINER} == *false* ]]; then
        printf "${RED}Magento is not set up yet in container. Please remove 'magento2-base' and try again.${COLOR_RESET}\n"
        echo ""
        echo "   rm -rf ${HOST_DIR}/${MAGENTO2_MODULE_PATH}"
        echo ""
        exit 1
    fi

    mirror_vendor_host_into_container
    COMPOSER_OUTPUT=$(${COMMANDS_DIR}/exec.sh composer "$@" | tee /dev/tty)
    if [[ ${MAGENTO_EXISTS_IN_HOST} == false ]]; then
        sync_all_from_container_to_host
    else
        sync_vendor_updates_into_host "${COMPOSER_OUTPUT}"
    fi
else
    ${COMMANDS_DIR}/exec.sh composer "$@"
fi