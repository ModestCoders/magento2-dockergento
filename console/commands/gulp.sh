#!/usr/bin/env bash
set -euo pipefail

usage()
{
    printf "${YELLOW}Usage:${COLOR_RESET}\n"
    echo "  gulp command"
    echo ""
    echo "Example:"
    printf "  ${GREEN}dockergento gulp style ${COLOR_RESET}\n"
}

if [ "$#" == 0 ] || [ "$1" == "--help" ]; then
    usage
    exit 0
fi

${DOCKER_COMPOSE} run --rm --no-deps --service-ports ${SERVICE_NODE} sh -c "cd ${MAGENTO_DIR}/frontools && \
    npx gulp $@"
