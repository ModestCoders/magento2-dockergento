#!/usr/bin/env bash
set -euo pipefail

NEEDLE="$1"
LIST="$2"

# IMPORTANT: trailing spaces are needed to ensure matching condition:
# - https://stackoverflow.com/questions/8063228/how-do-i-check-if-a-variable-exists-in-a-list-in-bash
if [[ " ${LIST} " == *" ${NEEDLE} "* ]]; then
    echo true
    exit 0
fi
echo false
exit 0