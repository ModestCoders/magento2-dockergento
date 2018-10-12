#!/usr/bin/env bash
set -euo pipefail

RUNNING_CONTAINERS=$(docker ps -q)
if [[ ${RUNNING_CONTAINERS} != "" ]]; then
    printf "${GREEN}Stopping running containers${COLOR_RESET}\n"
    docker stop ${RUNNING_CONTAINERS}
else
    echo "No containers running"
fi