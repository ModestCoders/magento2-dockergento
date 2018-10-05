#!/usr/bin/env bash
set -eu

usage()
{
    printf "${YELLOW}Usage:${COLOR_RESET}\n"
    echo "  mirror-host [path1] ... [pathN]"
    echo ""
    printf "${YELLOW}Allowed paths to mirror:${COLOR_RESET}\n"
    echo "  ${MIRROR_PATHS_ALLOWED}"
    echo ""
    echo "Example:"
    printf "  ${GREEN}dockergento mirror-host vendor${COLOR_RESET}\n"
}

if [ "$#" == 0 ] || [ "$1" == "--help" ]; then
    usage
    exit 0
fi

if [[ "${MACHINE}" != "mac" ]] && [[ "${MACHINE}" != "windows" ]]; then
    printf "${RED} This command is only for mac and windows systems.${COLOR_RESET}\n"
    exit 1
fi

source ${TASKS_DIR}/mirror_path.sh

printf "${GREEN}Start mirror copy of host into container${COLOR_RESET}\n"
CONTAINER_ID=$(${DOCKER_COMPOSE} ps -q ${SERVICE_PHP})

for PATH_TO_MIRROR in $@
do
    printf "${YELLOW}${PATH_TO_MIRROR} -> ${SERVICE_PHP}:${PATH_TO_MIRROR}${COLOR_RESET}\n"

    echo " > validating and sanitizing path: '${PATH_TO_MIRROR}'"
    PATH_TO_MIRROR=$(sanitize_mirror_path "${PATH_TO_MIRROR}")
    validate_mirror_path "${PATH_TO_MIRROR}"

    SRC_PATH="${PATH_TO_MIRROR}"
    DEST_PATH="${PATH_TO_MIRROR}"
    DEST_DIR=$(dirname ${DEST_PATH})

    SRC_IS_DIR=$([ -d ${SRC_PATH} ] && echo true || echo false)
    if [[ ${SRC_IS_DIR} == *true* ]]; then
        echo " > removing destination dir content: '${SERVICE_PHP}:${DEST_PATH}/*'"
        ${COMMANDS_DIR}/exec.sh sh -c "rm -rf ${DEST_PATH}/*"
        SRC_PATH="${SRC_PATH}/."
        DEST_DIR="${DEST_PATH}"
    fi

    echo " > ensure destination dir exists: '${DEST_DIR}'"
    ${COMMANDS_DIR}/exec.sh sh -c "mkdir -p ${DEST_DIR}"

    if [[ ${SRC_IS_DIR} == *true* && $(find ${SRC_PATH} -maxdepth 0 -empty) ]]; then
        echo " > skipping copy. Source dir is empty: '${SRC_PATH}'"
    else
        echo " > copying '${SRC_PATH}' into '${SERVICE_PHP}:${WORKDIR_PHP}/${DEST_PATH}'"
        docker cp ${SRC_PATH} ${CONTAINER_ID}:${WORKDIR_PHP}/${DEST_PATH}
    fi

    OWNERSHIP_COMMAND="chown -R ${USER_PHP}:${GROUP_PHP} ${WORKDIR_PHP}/${DEST_PATH}"
    echo " > setting permissions: ${OWNERSHIP_COMMAND}"
    ${COMMANDS_DIR}/exec.sh --root sh -c "${OWNERSHIP_COMMAND}"
done

printf "${GREEN}Host mirrored into container${COLOR_RESET}\n"
