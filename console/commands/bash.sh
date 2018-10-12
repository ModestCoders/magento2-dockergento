#!/usr/bin/env bash
set -euo pipefail

usage()
{
    printf "${YELLOW}Usage:${COLOR_RESET}\n"
    echo "  bash [options]"
    echo ""
    printf "${YELLOW}Options:${COLOR_RESET}\n"
    printf "  ${GREEN}--root${COLOR_RESET}     Use bash as root user\n"
}

if [ "$#" != 0 ] && [ "$1" == "--help" ]; then
    usage
    exit 0
fi

if [ "$#" != 0 ] && [ "$1" == "--root" ]; then
   ${COMMANDS_DIR}/exec.sh --root bash
else
    ${COMMANDS_DIR}/exec.sh bash
fi