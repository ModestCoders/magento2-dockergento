#!/usr/bin/env bash
set -euo pipefail

usage()
{
    printf "${YELLOW}Usage:${COLOR_RESET}\n"
    echo "  watch [path1] ... [pathN]"
    echo ""
    echo "Example:"
    printf "  ${GREEN}dockergento watch vendor/namespace/<module-to-watch>${COLOR_RESET}\n"
}

if [ "$#" == 0 ] || [ "$1" == "--help" ]; then
    usage
    exit 0
fi

if [[ "${MACHINE}" != "mac" ]] && [[ "${MACHINE}" != "windows" ]]; then
    printf "${RED} This command is only for mac and windows systems.${COLOR_RESET}\n"
    exit 1
fi

if [[ "${MACHINE}" == "mac" && "${USE_MUTAGEN_SYNC}" == "1" ]]; then
    printf "${RED} This command is not used when mutagen sync is enabled.${COLOR_RESET}\n"
    exit 1
fi

PATH_ARGS=""
for WATCH_PATH in $@
do
    PATH_ARGS="${PATH_ARGS} -path ${WATCH_PATH}"
done

${DOCKER_COMPOSE} run --rm ${SERVICE_UNISON} watch ${PATH_ARGS}
