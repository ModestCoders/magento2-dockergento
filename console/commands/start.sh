#!/usr/bin/env bash
set -euo pipefail

printf "${GREEN}Starting containers in detached mode${COLOR_RESET}\n"

if [ "$#" == 0 ]; then
    ${DOCKER_COMPOSE} up -d ${SERVICE_APP}
else
    ${DOCKER_COMPOSE} up -d "$@"
fi