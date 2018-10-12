#!/usr/bin/env bash
set -euo pipefail

CONFIG_IS_VALID=$(${DOCKER_COMPOSE} config -q && echo true || echo false)
if [[ ${CONFIG_IS_VALID} == false ]]; then
    echo ""
    printf "${RED}Docker is not properly configured. Please execute:${COLOR_RESET}\n"
    echo ""
    echo "  dockergento setup"
    echo ""
    exit 1
fi