#!/usr/bin/env bash
set -euo pipefail

SERVICE=$1

set +e # Disable interruption in case of error
${DOCKER_COMPOSE} exec -T ${SERVICE} sh -c "echo 'check ${SERVICE} service is running'" &> /dev/null
SERVICE_RUNNING_ERROR=$?
set -e # Enable interruption in case of error

if [ ${SERVICE_RUNNING_ERROR} == 1 ]; then
    ${COMMANDS_DIR}/start.sh ${SERVICE}
fi
