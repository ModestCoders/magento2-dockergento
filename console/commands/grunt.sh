#!/usr/bin/env bash
set -euo pipefail

usage()
{
    printf "${YELLOW}Usage:${COLOR_RESET}\n"
    echo "  grunt command"
    echo ""
    echo "Example:"
    printf "  ${GREEN}dockergento grunt exec:<theme>${COLOR_RESET}\n"
}

if [ "$#" == 0 ] || [ "$1" == "--help" ]; then
    usage
    exit 0
fi

${DOCKER_COMPOSE} run --rm --service-ports ${SERVICE_NODE} sh -c "cd ${MAGENTO_DIR} && \
    cp -n package.json.sample package.json && \
    cp -n Gruntfile.js.sample Gruntfile.js && \
    npm install && \
    grunt $@"
