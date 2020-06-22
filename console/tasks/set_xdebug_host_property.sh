#!/usr/bin/env bash
set -euo pipefail

XDEBUG_HOST=""
if [ "${MACHINE}" == "linux" ]; then
    if grep -q Microsoft /proc/version; then # WSL
        XDEBUG_HOST=10.0.75.1
    elif grep -q microsoft-standard /proc/version; then #WSL2
        XDEBUG_HOST=host.docker.internal
    else
        if [ "$(command -v ip)" ]; then
            XDEBUG_HOST=$(ip addr show docker0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
        else
            XDEBUG_HOST=$(ifconfig docker0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
        fi
    fi
fi

export XDEBUG_HOST="${XDEBUG_HOST}"
