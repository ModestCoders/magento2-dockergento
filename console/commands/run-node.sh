#!/usr/bin/env bash
set -eu

usage()
{
    printf "${YELLOW}Usage:${COLOR_RESET}\n"
    echo "  exec-node command"
    echo ""
    echo "Example:"
    printf "  ${GREEN}dockergento run-node ls -lah${COLOR_RESET}\n"
}

if [ "$#" == 0  ] || [ "$1" == "--help" ]; then
    usage
    exit 0
fi

COMMAND="$@" #IMPORTANT: This is needed because using "$@" directly in next docker-compose command, does not enclose the action within quotes. And thus it does not work
${DOCKER_COMPOSE} run --rm ${SERVICE_NODE} sh -c "$COMMAND"