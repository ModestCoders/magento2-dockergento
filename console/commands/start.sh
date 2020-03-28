#!/usr/bin/env bash
set -euo pipefail

printf "${GREEN}Starting containers in detached mode${COLOR_RESET}\n"

if [ "$#" == 0 ]; then
    ${DOCKER_COMPOSE} up -d ${SERVICE_APP}
else
    ${DOCKER_COMPOSE} up -d "$@"
fi

${TASKS_DIR}/validate_bind_mounts.sh

echo "Waiting for everything to spin up..."
sleep 5

if [[ "${MACHINE}" == "linux" ]]; then
    echo " > fixing permissions"
    ${TASKS_DIR}/fix_linux_permissions.sh
    echo " > permissions fix finished"
fi

if [[ "${MACHINE}" == "mac" && "${USE_MUTAGEN_SYNC}" == "1" ]]; then
    echo " > starting mutagen sync session"
    ${TASKS_DIR}/mutagen_sync.sh start
    printf " > mutagen sync started\n"
fi
